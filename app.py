from flask import Flask, request, jsonify, render_template, redirect, url_for, flash
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
import mysql.connector
from mysql.connector import Error
from werkzeug.security import generate_password_hash, check_password_hash
import io
import csv
from flask import make_response
from datetime import date

app = Flask(__name__, static_folder='static')
app.config['SECRET_KEY'] = 'a-very-secret-key-for-your-project'

# --- DATABASE CONFIG ---
db_config = {
    'host': 'localhost',
    'user': 'admin_user', 
    'password': 'Admin_Pass!123',
    'database': 'ArtGallery'
}

def create_connection():
    try:
        conn = mysql.connector.connect(**db_config)
        return conn
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None

# --- LOGIN MANAGER SETUP ---
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login' 

class User(UserMixin):
    def __init__(self, id, email, name, role, gallery_id=None, gallery_name=None):
        self.id = id
        self.email = email
        self.name = name
        self.role = role
        self.gallery_id = gallery_id
        self.gallery_name = gallery_name

@login_manager.user_loader
def load_user(user_id):
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT u.UserID, u.Email, u.Name, u.Role, u.GalleryID, g.Name as GalleryName
        FROM Users u
        LEFT JOIN Galleries g ON u.GalleryID = g.GalleryID
        WHERE u.UserID = %s
    """, (user_id,))
    user_data = cursor.fetchone()
    conn.close()
    if user_data:
        return User(
            id=user_data['UserID'], email=user_data['Email'], name=user_data['Name'], 
            role=user_data['Role'], gallery_id=user_data['GalleryID'],
            gallery_name=user_data['GalleryName']
        )
    return None

# --- AUTHENTICATION ROUTES ---
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        conn = create_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM Users WHERE Email = %s", (email,))
        user_data = cursor.fetchone()
        
        if user_data and user_data['Password'] == 'placeholder' and password == 'password123':
            hashed_password = generate_password_hash(password)
            cursor.execute("UPDATE Users SET Password = %s WHERE UserID = %s", (hashed_password, user_data['UserID']))
            conn.commit()
            user_obj = load_user(user_data['UserID'])
            login_user(user_obj)
            flash('Welcome! Your password has been set.', 'success')
            if user_obj.role == 'admin':
                return redirect(url_for('admin_dashboard'))
            else:
                return redirect(url_for('list_galleries'))

        elif user_data and check_password_hash(user_data['Password'], password):
            user_obj = load_user(user_data['UserID'])
            login_user(user_obj)
            if user_obj.role == 'admin':
                return redirect(url_for('admin_dashboard'))
            else:
                return redirect(url_for('list_galleries')) 
        else:
            flash('Invalid email or password.')
        conn.close()
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('list_galleries'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        password = request.form['password']
        hashed_password = generate_password_hash(password)
        conn = create_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("INSERT INTO Users (Name, Email, Password, Role, GalleryID) VALUES (%s, %s, %s, 'customer', NULL)",
                           (name, email, hashed_password))
            conn.commit()
            flash('Account created successfully! Please log in.', 'success')
            return redirect(url_for('login'))
        except Error as e:
            conn.rollback()
            flash(f'Error: {e}', 'error')
        finally:
            conn.close()
    return render_template('register.html')

# --- CUSTOMER-FACING ROUTES ---

@app.route('/')
def list_galleries():
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Galleries")
    galleries = cursor.fetchall()
    conn.close()
    return render_template('index.html', galleries=galleries) 

@app.route('/gallery/<int:gallery_id>')
def gallery_page(gallery_id):
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT GalleryID, Name FROM Galleries WHERE GalleryID = %s", (gallery_id,))
    gallery = cursor.fetchone()
    if not gallery:
        flash("Gallery not found.")
        return redirect(url_for('list_galleries'))
    cursor.execute("""
        SELECT 
            i.InventoryID, i.PurchasePrice,
            aw.Title, aw.Description, aw.ArtworkID,
            ar.Name as ArtistName, ar.ArtistID
        FROM Inventory i
        JOIN Artworks aw ON i.ArtworkID = aw.ArtworkID
        LEFT JOIN Artists ar ON aw.ArtistID = ar.ArtistID
        WHERE i.GalleryID = %s AND i.Status = 'Available'
    """, (gallery_id,))
    artworks = cursor.fetchall()
    conn.close()
    return render_template('gallery.html', artworks=artworks, gallery=gallery)

@app.route('/buy', methods=['POST'])
@login_required
def buy_artwork():
    if current_user.role != 'customer':
        return jsonify({"error": "Only customers can buy art."}), 403
    data = request.get_json()
    inventory_id = data['inventory_id']
    payment_method = data['payment_method']
    user_id = current_user.id
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.callproc('sp_BuyArtwork', [user_id, inventory_id, payment_method])
        new_sale = {}
        for result in cursor.stored_results():
            new_sale = result.fetchone()
        conn.commit()
        if new_sale and 'NewSaleID' in new_sale:
            return jsonify({"message": "Artwork purchased successfully!", "sale_id": new_sale['NewSaleID']})
        else:
            return jsonify({"error": "Item is no longer available."}), 400
    except Error as e:
        conn.rollback()
        return jsonify({"error": f"Database error: {e}"}), 500
    finally:
        conn.close()

@app.route('/receipt/<int:sale_id>')
@login_required
def receipt(sale_id):
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM v_sales_dashboard_details WHERE SaleID = %s", (sale_id,))
    sale = cursor.fetchone()
    conn.close() 
    if not sale or (sale['CustomerName'] != current_user.name and current_user.role != 'admin'):
        flash("You do not have permission to view this receipt.")
        return redirect(url_for('list_galleries'))
    return render_template('receipt.html', sale=sale)

@app.route('/search')
def search():
    query = request.args.get('q', '')
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    sql_query = """
        SELECT 
            i.InventoryID, i.PurchasePrice, i.GalleryID,
            aw.Title, aw.Description, aw.ArtworkID,
            ar.Name as ArtistName, ar.ArtistID
        FROM Artworks aw
        JOIN Artists ar ON aw.ArtistID = ar.ArtistID
        JOIN Inventory i ON aw.ArtworkID = i.ArtworkID
        WHERE MATCH(aw.Title, aw.Description) AGAINST(%s IN BOOLEAN MODE)
        AND i.Status = 'Available'
    """
    cursor.execute(sql_query, (query + '*',))
    artworks = cursor.fetchall()
    conn.close()
    return render_template('gallery.html', artworks=artworks, search_query=query)

@app.route('/artist/<int:artist_id>')
def artist_page(artist_id):
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT Name FROM Artists WHERE ArtistID = %s", (artist_id,))
    artist = cursor.fetchone()
    if not artist:
        flash("Artist not found.")
        return redirect(url_for('list_galleries'))
    cursor.execute("""
        SELECT 
            i.InventoryID, i.PurchasePrice, i.GalleryID,
            aw.Title, aw.Description, aw.ArtworkID,
            ar.Name as ArtistName, ar.ArtistID
        FROM Inventory i
        JOIN Artworks aw ON i.ArtworkID = aw.ArtworkID
        JOIN Artists ar ON aw.ArtistID = ar.ArtistID
        WHERE ar.ArtistID = %s AND i.Status = 'Available'
    """, (artist_id,))
    artworks = cursor.fetchall()
    conn.close()
    return render_template('gallery.html', artworks=artworks, artist_name=artist['Name'])

@app.route('/exhibitions/<int:gallery_id>')
def exhibitions_list(gallery_id):
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT Name FROM Galleries WHERE GalleryID = %s", (gallery_id,))
    gallery = cursor.fetchone()
    if not gallery:
        flash("Gallery not found.")
        return redirect(url_for('list_galleries'))
    cursor.execute("""
        SELECT * FROM Exhibitions 
        WHERE GalleryID = %s AND EndDate >= CURDATE()
        ORDER BY StartDate ASC
    """, (gallery_id,))
    exhibitions = cursor.fetchall()
    conn.close()
    return render_template('exhibitions_list.html', exhibitions=exhibitions, today=date.today(), gallery_name=gallery['Name'], gallery_id=gallery_id)

@app.route('/exhibition/<int:exhibition_id>')
def exhibition_page(exhibition_id):
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT Title, GalleryID FROM Exhibitions WHERE ExhibitionID = %s", (exhibition_id,))
    exhibition = cursor.fetchone()
    if not exhibition:
        flash("Exhibition not found.")
        return redirect(url_for('list_galleries'))
    cursor.execute("""
        SELECT 
            i.InventoryID, i.PurchasePrice, i.GalleryID,
            aw.Title, aw.Description, aw.ArtworkID,
            ar.Name as ArtistName, ar.ArtistID
        FROM Inventory i
        JOIN Artworks aw ON i.ArtworkID = aw.ArtworkID
        LEFT JOIN Artists ar ON aw.ArtistID = ar.ArtistID
        JOIN Exhibition_Artworks ea ON i.InventoryID = ea.InventoryID
        WHERE ea.ExhibitionID = %s AND i.Status = 'Available'
    """, (exhibition_id,))
    artworks = cursor.fetchall()
    conn.close()
    return render_template('gallery.html', 
                           artworks=artworks, 
                           exhibition_name=exhibition['Title'], 
                           gallery_id=exhibition['GalleryID'])

@app.route('/profile', methods=['GET', 'POST'])
@login_required
def profile():
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    if request.method == 'POST':
        name = request.form['name']
        address = request.form['address']
        city = request.form['city']
        zipcode = request.form['zipcode']
        try:
            cursor.execute("""
                UPDATE Users 
                SET Name = %s, Address = %s, City = %s, ZipCode = %s
                WHERE UserID = %s
            """, (name, address, city, zipcode, current_user.id))
            conn.commit()
            flash('Profile updated successfully!', 'success')
        except Error as e:
            conn.rollback()
            flash(f'Error updating profile: {e}', 'error')
        return redirect(url_for('profile'))
    cursor.execute("SELECT Name, Email, Address, City, ZipCode FROM Users WHERE UserID = %s", (current_user.id,))
    user = cursor.fetchone()
    cursor.execute("SELECT * FROM v_sales_dashboard_details WHERE CustomerName = %s ORDER BY SaleDate DESC", (current_user.name,))
    sales = cursor.fetchall()
    cursor.execute("SELECT * FROM v_ticket_sales_details WHERE CustomerName = %s ORDER BY PurchaseDate DESC", (current_user.name,))
    tickets = cursor.fetchall()
    conn.close()
    return render_template('profile.html', user=user, sales=sales, tickets=tickets)

@app.route('/buy_ticket', methods=['POST'])
@login_required
def buy_ticket():
    if current_user.role != 'customer':
        return jsonify({"error": "Only customers can buy tickets."}), 403
    data = request.get_json()
    gallery_id = data['gallery_id']
    visit_date = data['visit_date']
    payment_method = data['payment_method']
    user_id = current_user.id
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.callproc('sp_BuyTicket', [user_id, gallery_id, visit_date, payment_method])
        new_ticket = {}
        for result in cursor.stored_results():
            new_ticket = result.fetchone()
        conn.commit()
        if new_ticket and 'NewTicketID' in new_ticket:
            return jsonify({"message": "Ticket purchased successfully!", "ticket_id": new_ticket['NewTicketID']})
        else:
            return jsonify({"error": "Could not process ticket purchase."}), 400
    except Error as e:
        conn.rollback()
        return jsonify({"error": f"Database error: {e}"}), 500
    finally:
        conn.close()

# --- ADMIN-ONLY ROUTES ---
def admin_required(f):
    @login_required
    def decorated_function(*args, **kwargs):
        if current_user.role != 'admin':
            flash("You do not have permission to access this page.")
            return redirect(url_for('list_galleries'))
        if current_user.gallery_id is None:
            flash("You are an admin but not assigned to a gallery. Contact system administrator.")
            return redirect(url_for('list_galleries'))
        return f(*args, **kwargs)
    decorated_function.__name__ = f.__name__
    return decorated_function

@app.route('/admin')
@admin_required
def admin_dashboard():
    return render_template('admin.html')

@app.route('/admin/payments')
@admin_required
def admin_payments():
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    admin_gallery_id = current_user.gallery_id
    cursor.execute("SELECT SUM(SalePrice) as TotalRevenue, COUNT(SaleID) as TotalSales, AVG(SalePrice) as AvgSalePrice FROM v_sales_dashboard_details WHERE GalleryID = %s", (admin_gallery_id,))
    stats = cursor.fetchone()
    cursor.execute("SELECT SUM(TicketPrice) as TotalTicketRevenue, COUNT(TicketID) as TotalTicketSales FROM v_ticket_sales_details WHERE GalleryID = %s", (admin_gallery_id,))
    ticket_stats = cursor.fetchone()
    cursor.execute("SELECT * FROM v_sales_dashboard_details WHERE GalleryID = %s ORDER BY SaleDate DESC", (admin_gallery_id,))
    sales = cursor.fetchall()
    cursor.execute("SELECT * FROM v_ticket_sales_details WHERE GalleryID = %s ORDER BY PurchaseDate DESC", (admin_gallery_id,))
    tickets = cursor.fetchall()
    cursor.execute("""
        SELECT u.Name, SUM(s.SalePrice) as TotalSpent FROM Sales s 
        JOIN Users u ON s.UserID = u.UserID 
        JOIN Inventory i ON s.InventoryID = i.InventoryID
        WHERE i.GalleryID = %s
        GROUP BY u.UserID, u.Name 
        ORDER BY TotalSpent DESC LIMIT 1
    """, (admin_gallery_id,))
    top_customer = cursor.fetchone()
    cursor.execute("""
        SELECT ar.Name, COUNT(s.SaleID) as TotalSales FROM Sales s 
        JOIN Inventory i ON s.InventoryID = i.InventoryID
        JOIN Artworks aw ON i.ArtworkID = aw.ArtworkID 
        JOIN Artists ar ON aw.ArtistID = ar.ArtistID 
        WHERE i.GalleryID = %s
        GROUP BY ar.ArtistID, ar.Name ORDER BY TotalSales DESC LIMIT 1
    """, (admin_gallery_id,))
    top_artist = cursor.fetchone()
    cursor.execute("SELECT SUM(GalleryRevenue) as TotalProfit FROM Sales s JOIN Inventory i ON s.InventoryID = i.InventoryID WHERE i.GalleryID = %s", (admin_gallery_id,))
    profit = cursor.fetchone()
    conn.close()
    return render_template('admin_payments.html', 
                           stats=stats, sales=sales, 
                           top_customer=top_customer, 
                           top_artist=top_artist,
                           profit=profit,
                           ticket_stats=ticket_stats,
                           tickets=tickets,
                           gallery_name=current_user.gallery_name)

@app.route('/admin/export/csv')
@admin_required
def export_csv():
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    admin_gallery_id = current_user.gallery_id
    cursor.execute("SELECT * FROM v_sales_dashboard_details WHERE GalleryID = %s ORDER BY SaleDate DESC", (admin_gallery_id,))
    sales_data = cursor.fetchall()
    si = io.StringIO()
    cw = csv.writer(si)
    if sales_data:
        cw.writerow(sales_data[0].keys())
    for sale in sales_data:
        sale['SaleDate'] = sale['SaleDate'].strftime('%Y-%m-%d %H:%M:%S')
        cw.writerow(sale.values())
    output = make_response(si.getvalue())
    output.headers["Content-Disposition"] = f"attachment; filename=sales_export_{current_user.gallery_name}.csv"
    output.headers["Content-type"] = "text/csv"
    conn.close()
    return output

@app.route('/admin/exhibitions', methods=['GET', 'POST'])
@admin_required
def admin_exhibitions():
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    admin_gallery_id = current_user.gallery_id
    if request.method == 'POST':
        title = request.form['title']
        description = request.form['description']
        start_date = request.form['start_date']
        end_date = request.form['end_date']
        try:
            cursor.execute("INSERT INTO Exhibitions (Title, Description, StartDate, EndDate, GalleryID) VALUES (%s, %s, %s, %s, %s)",
                           (title, description, start_date, end_date, admin_gallery_id))
            conn.commit()
            flash('Exhibition created successfully!', 'success')
        except Error as e:
            conn.rollback()
            flash(f'Error: {e}', 'error')
    cursor.execute("SELECT * FROM Exhibitions WHERE GalleryID = %s ORDER BY StartDate DESC", (admin_gallery_id,))
    exhibitions = cursor.fetchall()
    conn.close()
    return render_template('admin_exhibitions.html', exhibitions=exhibitions, today=date.today())

@app.route('/admin/exhibition/edit/<int:exhibition_id>', methods=['GET', 'POST'])
@admin_required
def admin_edit_exhibition(exhibition_id):
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    admin_gallery_id = current_user.gallery_id
    cursor.execute("SELECT * FROM Exhibitions WHERE ExhibitionID = %s AND GalleryID = %s", (exhibition_id, admin_gallery_id))
    exhibition = cursor.fetchone()
    if not exhibition:
        flash('Exhibition not found or you do not have permission to edit it.', 'error')
        return redirect(url_for('admin_exhibitions'))
    if request.method == 'POST':
        title = request.form['title']
        description = request.form['description']
        start_date = request.form['start_date']
        end_date = request.form['end_date']
        try:
            cursor.execute("""
                UPDATE Exhibitions SET Title = %s, Description = %s, StartDate = %s, EndDate = %s
                WHERE ExhibitionID = %s
            """, (title, description, start_date, end_date, exhibition_id))
            linked_inventory_ids = request.form.getlist('inventory_ids')
            cursor.execute("DELETE FROM Exhibition_Artworks WHERE ExhibitionID = %s", (exhibition_id,))
            if linked_inventory_ids:
                insert_data = [(exhibition_id, inv_id) for inv_id in linked_inventory_ids]
                cursor.executemany("INSERT INTO Exhibition_Artworks (ExhibitionID, InventoryID) VALUES (%s, %s)", insert_data)
            conn.commit()
            flash('Exhibition updated successfully!', 'success')
        except Error as e:
            conn.rollback()
            flash(f'Error: {e}', 'error')
        return redirect(url_for('admin_exhibitions'))
    cursor.execute("""
        SELECT 
            i.InventoryID, aw.Title,
            CASE WHEN ea.ExhibitionID IS NOT NULL THEN 1 ELSE 0 END as is_linked
        FROM Inventory i
        JOIN Artworks aw ON i.ArtworkID = aw.ArtworkID
        LEFT JOIN Exhibition_Artworks ea ON i.InventoryID = ea.InventoryID AND ea.ExhibitionID = %s
        WHERE i.GalleryID = %s
        ORDER BY aw.Title
    """, (exhibition_id, admin_gallery_id))
    all_inventory = cursor.fetchall()
    conn.close()
    return render_template('admin_edit_exhibition.html', exhibition=exhibition, all_inventory=all_inventory)

# --- NEW: Conclude Exhibition Route ---
@app.route('/admin/exhibition/conclude/<int:exhibition_id>', methods=['POST'])
@admin_required
def conclude_exhibition(exhibition_id):
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    admin_gallery_id = current_user.gallery_id
    
    try:
        # Security check: Does this exhibition belong to this admin's gallery?
        cursor.execute("SELECT ExhibitionID FROM Exhibitions WHERE ExhibitionID = %s AND GalleryID = %s", (exhibition_id, admin_gallery_id))
        exhibit = cursor.fetchone()
        
        if not exhibit:
            return jsonify({"error": "Exhibition not found or you don't have permission."}), 404
        
        # Set the end date to today (or yesterday, to be safe)
        cursor.execute("UPDATE Exhibitions SET EndDate = CURDATE() WHERE ExhibitionID = %s", (exhibition_id,))
        conn.commit()
        flash('Exhibition has been concluded.', 'success')
        return jsonify({"message": "Exhibition concluded."})
    except Error as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

@app.route('/admin/inventory/add', methods=['GET', 'POST'])
@admin_required
def admin_add_inventory():
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    admin_gallery_id = current_user.gallery_id
    if request.method == 'POST':
        artwork_id = request.form['artwork_id']
        price = request.form['price']
        status = request.form['status']
        try:
            cursor.execute("""
                INSERT INTO Inventory (ArtworkID, GalleryID, PurchasePrice, Status)
                VALUES (%s, %s, %s, %s)
            """, (artwork_id, admin_gallery_id, price, status))
            conn.commit()
            flash('New inventory item added successfully!', 'success')
            return redirect(url_for('admin_dashboard'))
        except Error as e:
            conn.rollback()
            flash(f'Error: {e}', 'error')
    cursor.execute("SELECT ArtworkID, Title FROM Artworks ORDER BY Title")
    artworks = cursor.fetchall()
    conn.close()
    return render_template('admin_add_inventory.html', artworks=artworks)

@app.route('/admin/artworks', methods=['GET'])
@admin_required
def get_all_artworks():
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    admin_gallery_id = current_user.gallery_id
    cursor.execute("""
        SELECT i.InventoryID, i.Status, i.PurchasePrice,
               aw.Title, ar.Name as ArtistName
        FROM Inventory i
        JOIN Artworks aw ON i.ArtworkID = aw.ArtworkID
        LEFT JOIN Artists ar ON aw.ArtistID = ar.ArtistID
        WHERE i.GalleryID = %s
    """, (admin_gallery_id,))
    inventory = cursor.fetchall()
    conn.close()
    return jsonify(inventory)

@app.route('/admin/artist', methods=['POST'])
@admin_required
def add_artist():
    data = request.get_json()
    conn = create_connection()
    cursor = conn.cursor()
    try:
        cursor.callproc('sp_AddArtist', [data['name'], data['nationality']])
        conn.commit()
        message = "Artist added successfully (via Procedure)"
    except Error as e:
        conn.rollback()
        message = f"Error: {e}"
    conn.close()
    return jsonify({"message": message})

@app.route('/admin/artwork/update/<int:id>', methods=['PUT'])
@admin_required
def update_artwork_status(id):
    # TODO: Add security check
    data = request.get_json()
    conn = create_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("UPDATE Inventory SET Status = %s WHERE InventoryID = %s", (data['status'], id))
        conn.commit()
        message = f"Inventory {id} status updated to {data['status']}"
    except Error as e:
        conn.rollback()
        message = f"Error: {e}"
    conn.close()
    return jsonify({"message": message})

@app.route('/admin/artwork/delete/<int:id>', methods=['DELETE'])
@admin_required
def delete_artwork(id):
    # TODO: Add security check
    conn = create_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM Inventory WHERE InventoryID = %s", (id,))
        conn.commit()
        message = f"Inventory {id} deleted. This action was logged."
    except Error as e:
        conn.rollback()
        message = f"Error: {e}"
    conn.close()
    return jsonify({"message": message})

@app.route('/admin/queries/<int:id>', methods=['GET'])
@admin_required
def run_query(id):
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    query = ""
    if id == 1:
        query = "SELECT aw.Title, i.PurchasePrice FROM Inventory i JOIN Artworks aw ON i.ArtworkID = aw.ArtworkID WHERE i.Status = 'Available';"
    elif id == 2:
        # --- *** THIS IS THE UPDATE *** ---
        # Q2 now queries your new "master" transaction view
        query = "SELECT * FROM v_all_transactions ORDER BY TransactionDate DESC;"
    elif id == 3:
        query = "SELECT ar.Name as Artist, COUNT(aw.ArtworkID) as TotalArtworks FROM Artworks aw JOIN Artists ar ON aw.ArtistID = ar.ArtistID GROUP BY ar.Name;"
    elif id == 4:
        query = "SELECT AVG(PurchasePrice) as AveragePrice FROM Inventory WHERE Status = 'Available';"
    elif id == 5:
        query = "SELECT * FROM AuditLog ORDER BY Timestamp DESC LIMIT 5;"
    
    if query:
        cursor.execute(query)
        result = cursor.fetchall()
        conn.close()
        return jsonify(result)
    else:
        conn.close()
        return jsonify({"error": "Invalid query ID"}), 400

@app.route('/admin/staff', methods=['GET', 'POST'])
@admin_required
def admin_staff():
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    admin_gallery_id = current_user.gallery_id
    if request.method == 'POST':
        name = request.form['name']
        position = request.form['position']
        email = request.form['email']
        try:
            cursor.execute("INSERT INTO Staff (Name, Position, Email, GalleryID) VALUES (%s, %s, %s, %s)",
                           (name, position, email, admin_gallery_id))
            conn.commit()
            flash('Staff member added successfully!', 'success')
        except Error as e:
            conn.rollback()
            flash(f'Error: {e}', 'error')
    cursor.execute("SELECT * FROM Staff WHERE GalleryID = %s", (admin_gallery_id,))
    staff = cursor.fetchall()
    conn.close()
    return render_template('admin_staff.html', staff_list=staff)

@app.route('/admin/staff/delete/<int:staff_id>', methods=['POST'])
@admin_required
def delete_staff(staff_id):
    conn = create_connection()
    cursor = conn.cursor(dictionary=True)
    admin_gallery_id = current_user.gallery_id
    try:
        cursor.execute("SELECT StaffID FROM Staff WHERE StaffID = %s AND GalleryID = %s", (staff_id, admin_gallery_id))
        staff = cursor.fetchone()
        if not staff:
            return jsonify({"error": "Staff not found or you don't have permission."}), 404
        cursor.execute("DELETE FROM Staff WHERE StaffID = %s", (staff_id,))
        conn.commit()
        flash('Staff member fired successfully.', 'success')
        return jsonify({"message": "Staff member fired."})
    except Error as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

if __name__ == '__main__':
    app.run(debug=True)