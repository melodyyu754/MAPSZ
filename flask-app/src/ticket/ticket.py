from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


ticket = Blueprint('products', __name__)

# Get all the products from the database
@ticket.route('/ticket', methods=['GET'])
def get_products():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute('SELECT ticketID, flightID, seatNum, class, price, boardingGroup, passengerID FROM ticket')

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

@ticket.route('/ticket/<id>', methods=['GET'])
def get_product_detail (id):

    query = 'SELECT ticketID, flightID, seatNum, class, price, boardingGroup, passengerID FROM ticket WHERE ticketID = ' + str(id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)