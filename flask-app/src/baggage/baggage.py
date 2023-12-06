from flask import Blueprint, request, jsonify, current_app
from src import db

baggage = Blueprint('baggage', __name__)

# Get all the baggage from the database
@baggage.route('/baggage', methods=['GET'])
def get_baggage():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT baggageID, ticketID, passengerID, bagWeight FROM baggage')
    column_headers = [x[0] for x in cursor.description]
    json_data = [dict(zip(column_headers, row)) for row in cursor.fetchall()]
    return jsonify(json_data)

# Get a specific airport from the database
@baggage.route('/baggage/<id>', methods=['GET'])
def get_baggage_detail(id):
    query = 'SELECT baggageID WHERE ticketID = ' + str(id)
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = [dict(zip(column_headers, row)) for row in cursor.fetchall()]
    return jsonify(json_data)

# Adds a new baggage
@baggage.route('/baggage', methods=['POST'])
def add_new_baggage():
    the_data = request.json
    current_app.logger.info(the_data)

    passengerID = 1
    ticketID = the_data['ticketID']
    flightID = the_data['flightID']
    weight = the_data['bagWeight']

    query = 'INSERT INTO baggage (passengerID, ticketID, flightID, bagWeight) VALUES (%s, %s, %s, %s)'
    query_values = (passengerID, ticketID, flightID, weight)

    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query, query_values)
    db.get_db().commit()

    return 'Success!'


# Deletes a given baggage
@baggage.route('/baggage/<baggageID>', methods=['DELETE'])
def delete_baggage(baggageID):
    query = '''
        DELETE
        FROM Baggage
        WHERE baggageID = {0};
    '''.format(baggageID)
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    
    db.get_db().commit()
    return "Successfully deleted baggage #{0}!".format(baggageID)

# updates a given ticket
@baggage.route('/baggage/<baggageID>', methods=['PUT'])
def update_baggage(baggageID):
    the_data = request.json

    weight = the_data['bagWeight']
    
    current_app.logger.info(the_data)

    the_query = 'UPDATE baggage SET '
    the_query += 'bagWeight = "' + str(weight) + '", '
    the_query += 'WHERE baggageID = {0};'.format(baggageID)

    current_app.logger.info(the_query)
    
    cursor = db.get_db().cursor()
    cursor.execute(the_query)
    db.get_db().commit()

    return "successfully editted baggage #{0}!".format(baggageID)
