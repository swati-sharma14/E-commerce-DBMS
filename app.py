from flask import Flask,g,request, render_template
from flask_mysqldb import MySQL
from flask_session import Session


app = Flask(__name__)
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = open('pass.txt').read().strip()
app.config['MYSQL_DB'] = 'alldeez'
app.config['SESSION_TYPE'] = 'filesystem'
app.config['SESSION_PERMANENT'] = False

Session(app)
mysql = MySQL(app)

@app.route('/')
def start():
    return 'Hello World'

@app.route('/product/<int:product_id>')
def product_page(product_id):
    if 'cursor' not in g:
        g.cursor = mysql.connection.cursor()
    cursor = g.cursor
    cursor.execute('SELECT * FROM products WHERE productid = %s', (product_id,))
    product = cursor.fetchone()
    if product is None:
        return 'Product not found'
    return str(product)

@app.route('/products',methods=['GET','POST'])
def products():
    if request.method == 'GET':
        return render_template('search.html')
    price_floor = request.form['low_price']
    price_ceiling = request.form['high_price']
    min_rating = request.form['min_rating']
    if 'cursor' not in g:
        g.cursor = mysql.connection.cursor()
    cursor = g.cursor
    cursor.execute('SELECT p.productid,p.productname FROM products p JOIN reviews r on p.productid = r.productid WHERE p.price BETWEEN %s AND %s GROUP BY p.productid HAVING AVG(r.rating) > %s', (price_floor, price_ceiling, min_rating))
    products = cursor.fetchall()
    results = []
    for p in products:
        results.append({'name':p[1], 'url':f'/product/{p[0]}'})
    return render_template('results.html', results=results)

@app.route('/total',methods = ['GET']) 
def total():
    if 'cursor' not in g:
        g.cursor = mysql.connection.cursor()
    cursor = g.cursor
    cursor.execute('''
SELECT s.sellername, c.categoryname, SUM(p.price) AS total_sales
FROM categories c
JOIN products p ON c.categoryid = p.categoryid
JOIN sellers s ON p.sellerid = s.sellerid
GROUP BY c.categoryname, s.sellername;
''')
    thing = cursor.fetchall()
    return str(thing)

@app.route('/ten',methods = ['GET'])
def ten():
    if 'cursor' not in g:
        g.cursor = mysql.connection.cursor()
    cursor = g.cursor
    cursor.execute('''
SELECT sellers.sellername, SUM(products.price)
FROM sellers
JOIN products ON sellers.sellerid = products.sellerid
JOIN carts ON products.productid = carts.productid
JOIN orders ON carts.orderid = orders.orderid
WHERE orders.haspaid = 1
GROUP BY sellers.sellername
ORDER BY SUM(products.price) DESC
LIMIT 10;
''' )
    thing = cursor.fetchall()
    return str(thing)

@app.route('/cats',methods = ['GET'])
def cats():
    if 'cursor' not in g:
        g.cursor = mysql.connection.cursor()
    cursor = g.cursor

    cursor.execute('''
SELECT categories.categoryname, SUM(products.price)
FROM orders
JOIN carts ON orders.orderid = carts.orderid
JOIN products ON carts.productid = products.productid
JOIN categories ON products.categoryid = categories.categoryid
GROUP BY categories.categoryid;
''')
    thing = cursor.fetchall()
    return str(thing)

@app.route('/returns',methods = ['GET'])
def returns():
    if 'cursor' not in g:
        g.cursor = mysql.connection.cursor()
    cursor = g.cursor
    cursor.execute('''
SELECT userid, productid, COUNT(*) AS total_returns
FROM prod_returns
GROUP BY userid, productid WITH ROLLUP
''' )
    thing = cursor.fetchall()
    return str(thing)

