from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


baggage = Blueprint('baggage', __name__)

# Get all the baggage from the database
@baggage.route('/baggage', methods=['GET'])
def get_baggage():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute('SELECT baggageID, ticketID, passengerID, weight FROM baggage')

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

    # Get a specific airport from the database
@baggage.route('/baggage/<id>', methods=['GET'])
def get_baggage_detail (id):

    query = 'SELECT baggageID, ticketID, passengerID, weight FROM baggage WHERE baggageID = ' + str(id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)

#CHANGE!!!
# Adds a new baggage
@baggage.route('/baggage', methods=['POST'])
def add_new_baggage():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    baggageID = the_data['baggageID']
    passengerID = the_data['passengerID']
    ticketID = the_data['ticketID']
    flightID = the_data['flightID']
    weight = the_data['weight']

    # Constructing the query
    query = 'insert into baggage (baggageID, passengerID, ticketID, flightID, weight) values ("'
    query += baggageID + '", "'
    query += passengerID+ '", "'
    query += ticketID + '", '
    query += flightID + '", '
    query += weight+ '", '
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'



# Deletes a given baggage
@baggage.route('/deleteBaggage/<baggageID>', methods=['DELETE'])
def delete_baggage(baggageID):
    query = '''
        DELETE
        FROM Baggage
        WHERE baggageID = {0};
    '''.format(baggageID)
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    
    db.get_db().commit()
    return "successfully deleted baggage #{0}!".format(baggageID)