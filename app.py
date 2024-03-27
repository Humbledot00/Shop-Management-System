from flask import Flask, render_template, request, redirect, session, jsonify, url_for
from datetime import datetime
import json
import mysql.connector
from decimal import Decimal


app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Set a secret key for session management


# Connect to MySQL database
def connect_to_mysql():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password='',
            database='shop management'
        )
        if connection.is_connected():
            print("Connected to MySQL database")
            return connection
    except Exception as e:
        print("Error connecting to MySQL database:", e)
        return None

user_credentials = {'example@example.com': 'password123'}

# Route for login page
@app.route('/')
def login():
    return render_template('login.html')


# Define a route for "/orders.html"
@app.route('/orders.html')
def orders():
    # Return the appropriate template for the orders page
    return render_template('orders.html')

@app.route('/profit.html')
def profit_sum():
    total_price, total_wprice, total_expenses, sum = fetch_data()
    print(sum)
    print(total_expenses)
    net_profit = total_price - total_wprice
    return render_template('profit.html', total_price=total_price, total_wprice=total_wprice, total_expenses=total_expenses, net_profit=net_profit, sum=sum)

@app.route('/profit', methods=['GET', 'POST'])
def profit():
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')
    
    total_price, total_wprice, total_expenses, sum = fetch_data(start_date, end_date)
    
    net_profit = total_price - total_wprice
    
    # Return JSON response with data
    return jsonify({
        'total_price': str(total_price),
        'total_wprice': str(total_wprice),
        'net_profit': str(net_profit),
        'total_expenses': str(total_expenses)

    })

@app.route('/inventory.html')
def inventory():
    # Return the appropriate template for the orders page
    return render_template('inventory.html')




# Define a route for "/orders.html"
@app.route('/index.html')
def index():
    # Return the appropriate template for the orders page
    return render_template('index.html')


# Define a route for "/orders.html"
@app.route('/analytics.html')
def analytics():
    # Return the appropriate template for the orders page
    return render_template('analytics.html')

# Route to handle login form submission
@app.route('/login', methods=['POST'])
def login_user():
    # Get form data
    email = request.form['email']
    password = request.form['password']
    print(email)

    # Check if email exists in user_credentials dictionary and password matches
    if email in user_credentials and user_credentials[email] == password:
        # Store user information in session
        session['user'] = email
        return render_template('index.html')
    else:
        return 'Invalid email or password'


# Route to logout
@app.route('/logout')
def logout():
    # Remove user information from session
    session.pop('user', None)
    return redirect('/')


# Function to fetch data from the database
def fetch_data(start_date=None, end_date=None):
    connection = connect_to_mysql()
    cursor = connection.cursor()

    # Constructing SQL query for fetching data within the specified time period
    earnQuery = "SELECT SUM(totalBill) FROM transactions WHERE action = 'earned'"
    if start_date and end_date:
        # No need to convert start_date and end_date to datetime objects
        earnQuery += f" AND transactionDate BETWEEN '{start_date}' AND '{end_date}'"
    elif start_date:
        # Only start_date is provided
        earnQuery += f" AND transactionDate >= '{start_date}'"
    elif end_date:
        # Only end_date is provided
        earnQuery += f" AND transactionDate <= '{end_date}'"



    # Constructing SQL query for fetching data within the specified time period
    wearnQuery = "SELECT SUM(totalwprice) FROM transactions WHERE action = 'earned'"
    if start_date and end_date:
        # No need to convert start_date and end_date to datetime objects
        wearnQuery += f" AND transactionDate BETWEEN '{start_date}' AND '{end_date}'"
    elif start_date:
        # Only start_date is provided
        wearnQuery += f" AND transactionDate >= '{start_date}'"
    elif end_date:
        # Only end_date is provided
        wearnQuery += f" AND transactionDate <= '{end_date}'"



    spentQuery = "SELECT SUM(totalwprice) FROM transactions WHERE action = 'spent'"
    if start_date and end_date:
        # No need to convert start_date and end_date to datetime objects
        spentQuery += f" AND transactionDate BETWEEN '{start_date}' AND '{end_date}'"
    elif start_date:
        # Only start_date is provided
        spentQuery += f" AND transactionDate >= '{start_date}'"
    elif end_date:
        # Only end_date is provided
        spendQuery += f" AND transactionDate <= '{end_date}'"
            

    cursor.execute(earnQuery)
    total_price = cursor.fetchone()[0]
    
    cursor.execute("SELECT SUM(MRP*quantity) FROM product")
    sum = cursor.fetchone()[0]

    # Fetching total wprice within the specified time period
    cursor.execute(wearnQuery)
    total_wprice = cursor.fetchone()[0]

    # Fetching total expenses within the specified time period
    cursor.execute(spentQuery)
    total_expenses = cursor.fetchone()[0]

    connection.close()

    return Decimal(total_price or 0), Decimal(total_wprice or 0), Decimal(total_expenses or 0), Decimal(sum or 0)

@app.route('/submit_order', methods=['POST'])
def submit_order():
    # Get the data from the request
    order_data = request.json

    # Extract relevant information from the order data
    total_bill = order_data.get('totalBill')
    totalwprice = order_data.get('totalwprice')
    action = 'earned'
    product_list = order_data.get('productList')
    transaction_date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')  # Current date and time

    # Connect to MySQL database
    connection = connect_to_mysql()
    if connection:
        # Create cursor
        cursor = connection.cursor()

        # Insert the order data into your database
        try:
            # Insert order data into transactions table
            cursor.execute("INSERT INTO transactions (totalBill, transactionDate, totalwprice, action) VALUES (%s, %s, %s, %s)", (total_bill, transaction_date, totalwprice, action))

            # Update product quantities
            for product in product_list:
                product_id = product['product_id']
                quantity = product['quantity']
                print(product_id)
                cursor.execute("INSERT INTO analytics (product_id, date ) VALUES (%s, %s)", (product_id, transaction_date))

                # Update quantity in the product table
                cursor.execute("UPDATE product SET quantity = %s WHERE product_id = %s", (quantity, product_id))

            connection.commit()
            cursor.close()
            connection.close()
            return jsonify({'success': True, 'message': 'Order confirmed successfully'})
        except Exception as e:
            return jsonify({'success': False, 'message': 'Error inserting data: ' + str(e)})
    else:
        return jsonify({'success': False, 'message': 'Failed to connect to the database'})


@app.route('/transactionsData')
def transactionsData():
    try:
        cur = mysql.connection.cursor()
        cur.callproc('FetchAllDataFromTable', ['transactions'])
        # Notice the removal of extra space after 'transactions' here ^
        data = cur.fetchall()
        print(data)
        cur.close()
        return jsonify({"transactions": data})  # Return data with a key 'transactions'
    except Exception as e:
        return jsonify({'error': str(e)})


@app.route('/get_products')
def get_products():
    connection = connect_to_mysql()
    if connection:
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM product")
            products = cursor.fetchall()
            return jsonify({"products": products})
        except Exception as e:
            print("Error fetching products:", e)
        finally:
            cursor.close()
            connection.close()
    return jsonify({"error": "Failed to fetch products"})


@app.route('/get_seller')
def get_seller():
    connection = connect_to_mysql()
    if connection:
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM supplier")
            sellers = cursor.fetchall()
            return jsonify({"sellers": sellers})
        except Exception as e:
            print("Error fetching seller:", e)
        finally:
            cursor.close()
            connection.close()
    return jsonify({"error": "Failed to fetch seller"})


# Route to fetch product details from analytics table
@app.route('/get_product_analytics')
def get_product_analytics():
    try:
        connection = connect_to_mysql()
        if connection:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT product_id, date FROM analytics")
            product_analytics = cursor.fetchall()
            return jsonify(product_analytics)
    except Exception as e:
        print("Error:", e)
    finally:
        if connection:
            connection.close()

# Route to handle DELETE request for deleting a product
@app.route('/deleteProduct', methods=['POST'])
def delete_product():
    try:
        # Get the product ID from the request body
        data = request.get_json()
        product_id = data.get('productId')
        print(product_id)

        # Assuming you have a function to delete the product from the database
        # Implement your database deletion logic here
        # For example:
        connection = connect_to_mysql()
        if connection:
            try:
                cursor = connection.cursor(dictionary=True)
                # Execute the DELETE query to remove the product with the given ID
                cursor.execute("DELETE FROM product WHERE product_id = %s", (product_id,))
                # Commit the transaction
                connection.commit()
                return jsonify({"message": "Product deleted successfully"}), 200
            except Exception as e:
                print("Error deleting product:", e)
                connection.rollback()  # Rollback the transaction in case of error
                return jsonify({"error": "Failed to delete product"}), 500
            finally:
                cursor.close()
                connection.close()
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        print("Error:", e)
        return jsonify({"error": "An error occurred"}), 500


# Route to handle DELETE request for deleting a product
@app.route('/deleteSeller', methods=['POST'])
def deleteSeller():
    try:
        # Get the product ID from the request body
        data = request.get_json()
        supplier_id = data.get('sellerId')
        print(supplier_id)

        # Assuming you have a function to delete the product from the database
        # Implement your database deletion logic here
        # For example:
        connection = connect_to_mysql()
        if connection:
            try:
                cursor = connection.cursor(dictionary=True)
                # Execute the DELETE query to remove the product with the given ID
                cursor.execute("DELETE FROM supplier WHERE supplier_id = %s", (supplier_id,))
                # Commit the transaction
                connection.commit()
                return jsonify({"message": "Product deleted successfully"}), 200
            except Exception as e:
                print("Error deleting supplier:", e)
                connection.rollback()  # Rollback the transaction in case of error
                return jsonify({"error": "Failed to delete supplier"}), 500
            finally:
                cursor.close()
                connection.close()
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        print("Error:", e)
        return jsonify({"error": "An error occurred"}), 500

@app.route('/update_order', methods=['POST'])
def update_order():
    order_data_str = request.form.get('orderData')  # Get the order data as a string
    order_data = json.loads(order_data_str)  # Parse the string to convert it into a dictionary

    # Get additional parameters
    total_bill = request.form.get('total_amount')
    totalwprice = request.form.get('totalwprice')
    action = 'spent'
    transaction_date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')  # Current date and time

    # Process the order data as needed
    connection = connect_to_mysql()
    
    if connection:
        # Create cursor
        cursor = connection.cursor()

        # Insert the order data into your database
        try:
            # Update product data based on the order (assuming order includes product ID, name, and price)
            for product_info in order_data:
                product_id = product_info['product_id']
                product_name = product_info['productName']
                MRP = product_info['productPrice']
                quantity = product_info['productQuantity']
                wprice = product_info['productwprice']
                suplier_id = product_info['sid']

                # Execute SQL UPDATE statement to update product name and price
                update_sql = "UPDATE product SET product_name = %s, MRP = %s, quantity = %s, wprice = %s, suplier_id = %s WHERE product_id = %s"
                cursor.execute(update_sql, (product_name, MRP, quantity, wprice, suplier_id, product_id))
                connection.commit()  # Commit the transaction

            cursor.execute("INSERT INTO transactions (totalBill, transactionDate, totalwprice, action) VALUES (%s, %s, %s, %s)",
                           (total_bill, transaction_date, totalwprice, action))
            connection.commit()  # Commit the transaction

            
            cursor.execute("INSERT INTO orders (total_bill	, transaction_date	, sid) VALUES (%s, %s, %s)",
                           (totalwprice, transaction_date, suplier_id))
            connection.commit()  # Commit the transaction
    
            connection.close()
            return jsonify({'success': True, 'message': 'Order confirmed successfully'})
        
        except Exception as e:
            return jsonify({'success': False, 'message': 'Error inserting data: ' + str(e)})
    
    else:
        return jsonify({'success': False, 'message': 'Failed to connect to the database'})


@app.route('/newproduct', methods=['POST'])
def add_new_product():
    try:
        # Retrieve product data from the form
        product_id = request.form.get('productId')
        print(product_id)
        product_name = request.form.get('productName')
        product_quantity = request.form.get('productQuantity')
        product_price = request.form.get('productPrice')
        productwprice = request.form.get('productwprice')
        suplier_id = request.form.get('suplier_id')


        
        # Connect to MySQL database
        connection = connect_to_mysql()
        
        if connection:
            try:
                # Create a cursor object to execute SQL queries
                cursor = connection.cursor()
                
                # Insert new product into the product table
                sql = "INSERT INTO product (product_id, product_name, quantity, MRP, wprice, suplier_id) VALUES (%s, %s, %s, %s, %s, %s)"
                cursor.execute(sql, (product_id, product_name, product_quantity, product_price, productwprice, suplier_id))
                
                # Commit the transaction
                connection.commit()
                
                return redirect(url_for('index'))
            except mysql.connector.Error as error:
                print("Error adding product:", error)
                connection.rollback()
                return jsonify({"error": "Failed to add product"}), 500
            finally:
                # Close cursor and connection
                cursor.close()
                connection.close()
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        print("Error:", e)
        return jsonify({"error": "An error occurred"}), 500



@app.route('/newseller', methods=['POST'])
def add_new_seller():
    try:
        # Retrieve product data from the form
        supplier_id = request.form.get('supplier_id')
        supplier_name = request.form.get('supplier_name')
        contact = request.form.get('contact')


        
        # Connect to MySQL database
        connection = connect_to_mysql()
        
        if connection:
            try:
                # Create a cursor object to execute SQL queries
                cursor = connection.cursor()
                
                # Insert new product into the product table
                sql = "INSERT INTO supplier (supplier_id, supplier_name, contact) VALUES (%s, %s, %s)"
                cursor.execute(sql, (supplier_id, supplier_name, contact))
                
                # Commit the transaction
                connection.commit()
                
                return redirect(url_for('index'))
            except mysql.connector.Error as error:
                print("Error adding product:", error)
                connection.rollback()
                return jsonify({"error": "Failed to add product"}), 500
            finally:
                # Close cursor and connection
                cursor.close()
                connection.close()
        else:
            return jsonify({"error": "Failed to connect to database"}), 500
    except Exception as e:
        print("Error:", e)
        return jsonify({"error": "An error occurred"}), 500

@app.route('/transactions')
def get_transactions():
    connection = connect_to_mysql()
    if connection:
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM orders")
            products = cursor.fetchall()
            return jsonify( products)
        except Exception as e:
            print("Error fetching products:", e)
        finally:
            cursor.close()
            connection.close()
    return jsonify({"error": "Failed to fetch products"})


@app.route('/fetch_notifications')
def fetch_notifications():
    connection = connect_to_mysql()
    if connection:
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT product_id, message FROM notification_log")
            notifications = cursor.fetchall()  # Fetch all notifications from the database
            return jsonify({"success": True, "notifications": notifications})
        except Exception as e:
            print("Error fetching notifications:", e)
            return jsonify({"success": False, "error": str(e)})  # Return error message
        finally:
            cursor.close()
            connection.close()
    return jsonify({"success": False, "error": "Failed to connect to the database"})  # Return error message if failed to connect



@app.route('/delete_notification', methods=['DELETE'])
def delete_notification():
    notification_id = request.json.get('id')  # Assuming the notification ID is sent in the request body
    if notification_id:
        connection = connect_to_mysql()
        if connection:
            try:
                cursor = connection.cursor()
                cursor.execute("DELETE FROM notification_log WHERE product_id = %s", (notification_id,))
                connection.commit()
                return jsonify({"success": True, "message": "Notification deleted successfully"})
            except Exception as e:
                print("Error deleting notification:", e)
                return jsonify({"success": False, "error": "Failed to delete notification"})
            finally:
                cursor.close()
                connection.close()
    return jsonify({"success": False, "error": "Notification ID not provided"})


@app.route('/transactionData')
def transactionData():
    connection = connect_to_mysql()
    if connection:
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM transactions")
            products = cursor.fetchall()
            return jsonify({"transactions": products})
        except Exception as e:
            print("Error fetching transactions:", e)
        finally:
            cursor.close()
            connection.close()
    return jsonify({"error": "Failed to fetch transactions"})

if __name__ == "__main__":
    app.run(debug=True)
