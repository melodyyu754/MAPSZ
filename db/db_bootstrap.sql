-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database cool_db;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on cool_db.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use cool_db;

-- Put your DDL 
/* airport table */
CREATE TABLE IF NOT EXISTS airport(
airportID varchar(3) NOT NULL,
name varchar(50),
city varchar(50),
  state varchar(50),
  country varchar(50),
  PRIMARY KEY (airportID)
);


/* airline table */
CREATE TABLE IF NOT EXISTS airline (
  airlineID INT AUTO_INCREMENT NOT NULL,
  name VARCHAR(50) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(50),
  rating INT CHECK (rating >= 1 AND rating <= 5),
  PRIMARY KEY (airlineID)
);


/* airplane table */
CREATE TABLE IF NOT EXISTS airplane (
  airplaneID INT AUTO_INCREMENT NOT NULL,
  model VARCHAR(50),
  capacity INT,
  airlineID INT,
  PRIMARY KEY (airplaneID),
  FOREIGN KEY (airlineID) REFERENCES airline (airlineID) ON UPDATE CASCADE ON DELETE CASCADE
);



/* travel agency table */
CREATE TABLE IF NOT EXISTS travelAgency(
  agencyID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  website VARCHAR(100) NOT NULL,
  name VARCHAR(100),
  phone VARCHAR(20),
  ceoName VARCHAR(50)
);




/* trip advisor table */
CREATE TABLE IF NOT EXISTS tripAdvisor
(
  employeeID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  agencyID INT,
  firstName VARCHAR(50),
  lastName VARCHAR(50),
  salary INT,
  birthdate DATE,
  email VARCHAR(100),
  phone VARCHAR(20),
  language VARCHAR(50),
  supervisor_id INT,
  FOREIGN KEY (agencyID) REFERENCES travelAgency(agencyID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (supervisor_id) REFERENCES tripAdvisor(employeeID) ON UPDATE CASCADE ON DELETE CASCADE
);


/* passenger table */
CREATE TABLE IF NOT EXISTS passenger
(
  passengerID INT AUTO_INCREMENT NOT NULL,
  fName varchar(50) NOT NULL,
  lName varchar(50) NOT NULL,
  phone INT,
  sex varchar(50),
  birthDate DATE,
  email varchar(50),
  street varchar(50),
  zipcode INT,
  state varchar(50),
  country varchar(50),
  tripadvisorID INT,
  PRIMARY KEY (passengerID),
  FOREIGN KEY (tripadvisorID) REFERENCES tripAdvisor(employeeID)
);


/* department table */
CREATE TABLE IF NOT EXISTS department
(
  departmentID INT AUTO_INCREMENT NOT NULL,
  departmentName varchar(50),
  airportID VARCHAR(3),
  PRIMARY KEY (departmentID),
  FOREIGN KEY (airportID) REFERENCES airport(airportID) ON UPDATE CASCADE ON DELETE CASCADE
);




/* lounge table */
CREATE TABLE IF NOT EXISTS lounge
(
  loungeID INT AUTO_INCREMENT NOT NULL,
  name varchar(50),
  airportID VARCHAR(3),
  PRIMARY KEY (loungeID),
  FOREIGN KEY (airportID) REFERENCES airport(airportID) ON UPDATE CASCADE ON DELETE CASCADE
);


/* terminal table */
CREATE TABLE IF NOT EXISTS terminal
(
  terminalID INT AUTO_INCREMENT NOT NULL,
  airportID VARCHAR(3),
  PRIMARY KEY (terminalID, airportID),
  FOREIGN KEY (airportID) REFERENCES airport(airportID)
);


/* gate table */
CREATE TABLE IF NOT EXISTS gate
(
  gateNumber INT NOT NULL,
  terminalID INT,
  PRIMARY KEY (gateNumber, terminalID),
  FOREIGN KEY (terminalID) REFERENCES terminal(terminalID) ON UPDATE CASCADE ON DELETE CASCADE
);


/* store table */
CREATE TABLE IF NOT EXISTS store
(
  storeID INT AUTO_INCREMENT NOT NULL,
  terminalID INT,
  name varchar(50),
  PRIMARY KEY (storeID),
  FOREIGN KEY (terminalID) REFERENCES terminal(terminalID)
);




/* airportEmployee table */
CREATE TABLE IF NOT EXISTS flight
(
    flightID INT AUTO_INCREMENT PRIMARY KEY ,
    seatsAvailable INT,
    airplaneID INT,
    airlineID INT,
    departureTime DATETIME,
    arrivalTime DATETIME,
    arrivalAirport VARCHAR(3),
    departureAirport VARCHAR(3),
    arrivalTerminal INT,
    departureTerminal INT,
    arrivalGate INT,
    departureGate INT,
    FOREIGN KEY (arrivalAirport) REFERENCES airport(airportID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (departureAirport) REFERENCES airport(airportID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (arrivalTerminal) REFERENCES terminal(terminalID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (departureTerminal) REFERENCES terminal(terminalID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (arrivalGate) REFERENCES gate(gateNumber) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (departureGate) REFERENCES gate(gateNumber) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (airplaneID) REFERENCES airplane(airplaneID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (airlineID) REFERENCES airline(airlineID) ON UPDATE CASCADE ON DELETE CASCADE
);

/* flight table */
CREATE TABLE IF NOT EXISTS airportEmployee
(
  employeeID INT AUTO_INCREMENT NOT NULL,
  fName VARCHAR(50),
  lName VARCHAR(50),
  salary INT,
  title VARCHAR(50),
  sex VARCHAR(50),
  emailAddress VARCHAR(50),
  birthDate DATE,
  sup_id INT,
  departmentID INT,
  PRIMARY KEY (employeeID),
  FOREIGN KEY (departmentID) REFERENCES department(departmentID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (sup_id) REFERENCES airportEmployee(employeeID) ON UPDATE CASCADE ON DELETE CASCADE
);


/* ticket table */
CREATE TABLE IF NOT EXISTS ticket
(
  ticketID INT AUTO_INCREMENT NOT NULL,
  flightID INT,
  seatNum VARCHAR(10),
  class VARCHAR(20),
  price DECIMAL(10, 2),
  boardingGroup CHAR(1),
  passengerID INT,
  PRIMARY KEY (ticketID),
  FOREIGN KEY (flightID) REFERENCES flight(flightID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (passengerID) REFERENCES passenger(passengerID) ON UPDATE CASCADE ON DELETE CASCADE
);


/* baggage table */
CREATE TABLE IF NOT EXISTS baggage
(
  baggageID INT AUTO_INCREMENT,
  passengerID INT,
  ticketID INT,
  flightID INT,
  weight DECIMAL(6, 2),
  PRIMARY KEY (baggageID, ticketID, flightID),
  FOREIGN KEY (ticketID) REFERENCES ticket(ticketID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (flightID) REFERENCES flight(flightID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (passengerID) REFERENCES ticket(passengerID) ON UPDATE CASCADE ON DELETE CASCADE
);


/* airlineFlightEmployee */
CREATE TABLE IF NOT EXISTS airlineFlightEmployee (
  employeeID INT AUTO_INCREMENT NOT NULL,
  fName VARCHAR(50) NOT NULL,
  lName VARCHAR(50) NOT NULL,
  salary INT,
  title VARCHAR(50),
  sex VARCHAR(50),
  emailAddress VARCHAR(50),
  birthDate DATE,
  sup_id INT,
  airlineID INT,
  PRIMARY KEY (employeeID),
  FOREIGN KEY (airlineID) REFERENCES airline(airlineID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (sup_id) REFERENCES airlineFlightEmployee(employeeID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS crew (
  employeeID INT,
  flightID INT,
  PRIMARY KEY (employeeID, flightID),
  FOREIGN KEY (employeeID) REFERENCES airlineFlightEmployee(employeeID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (flightID) REFERENCES flight(flightID) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Sample data for airport table
INSERT INTO airport (airportID, name, city, country) VALUES
('YNT', 'Yantai Laishan Airport', 'Jacarezinho', 'Brazil'),
('DWN', 'Downtown Airpark', 'Águas de Lindóia', 'Brazil'),
('XTG', 'Thargomindah Airport', 'Boskovice', 'Czech Republic'),
('PWK', 'Chicago Executive Airport', 'Zhihe', 'China'),
('WME', 'Mount Keith Airport', 'Ritaebang', 'Indonesia'),
('XMA', 'Maramag Airport', 'Puntaru', 'Indonesia'),
('INE', 'Chinde Airport', 'Youngstown', 'United States'),
('SFM', 'Sanford Seacoast Regional Airport', 'Minas de Matahambre', 'Cuba'),
('CVO', 'Corvallis Municipal Airport', 'Huangzhuang', 'China'),
('VUU', 'Mvuu Camp Airport', 'Sumuragung', 'Indonesia'),
('KAL', 'Kaltag Airport', 'Guangyubao', 'China'),
('SFS', 'Subic Bay International Airport', 'Açucena', 'Brazil'),
('CGE', 'Cambridge Dorchester Airport', 'Xiaochengzi', 'China'),
('BYS', 'Bicycle Lake Army Air Field', 'Ngadri', 'Indonesia'),
('BWQ', 'Brewarrina Airport', 'Almeria', 'Spain'),
('JVL', 'Southern Wisconsin Regional Airport', 'Surulangun Rawas', 'Indonesia'),
('YKX', 'Kirkland Lake Airport', 'Las Varillas', 'Argentina'),
('KMM', 'Kimaam Airport', 'Wenchun', 'China'),
('UNG', 'Kiunga Airport', 'Nikulino', 'Russia'),
('YPX', 'Puvirnituq Airport', 'Mogila', 'Macedonia'),
('HBK', 'Holbrook Municipal Airport', 'Břeclav', 'Czech Republic'),
('TIB', 'Tibú Airport', 'Santa Monica', 'United States'),
('GBF', 'Negarbo(Negabo) Airport', 'Sóc Trăng', 'Vietnam'),
('ODB', 'Córdoba Airport', 'Xinye', 'China'),
('OUT', 'Bousso Airport', 'Zhatay', 'Russia'),
('MRS', 'Marseille Provence Airport', 'Tamorot', 'Morocco'),
('CAP', 'Cap Haitien International Airport', 'Tha Wang Pha', 'Thailand'),
('RKI', 'Rokot Airport', 'Vroutek', 'Czech Republic'),
('LCD', 'Louis Trichardt Airport', 'Shangcun', 'China'),
('GAB', 'Gabbs Airport', 'San Sebastián de Yalí', 'Nicaragua'),
('PNY', 'Pondicherry Airport', 'Longnan', 'China'),
('GLF', 'Golfito Airport', 'Sendai', 'Japan'),
('SJS', 'San José De Chiquitos Airport', 'Vanáton', 'Greece'),
('YRR', 'Stuart Island Airstrip', 'Trilj', 'Croatia'),
('ASG', 'Ashburton Aerodrome', 'Marale', 'Honduras'),
('SVP', 'Kuito Airport', 'Chã', 'Portugal'),
('YDQ', 'Dawson Creek Airport', 'Xialaba', 'China'),
('XQP', 'Quepos Managua Airport', 'Goryachevodskiy', 'Russia'),
('ZAO', 'Cahors-Lalbenque Airport', 'Majennang', 'Indonesia'),
('LRU', 'Las Cruces International Airport', 'Puzi', 'China'),
('MWP', 'Mountain Airport', 'Baihua', 'China'),
('KBH', 'Kalat Airport', 'Siderejo', 'Indonesia'),
('CEQ', 'Cannes-Mandelieu Airport', 'Chư Sê', 'Vietnam'),
('PEP', 'Peppimenarti Airport', 'Jiangduo', 'China'),
('KIV', 'Chişinău International Airport', 'Limeira', 'Brazil'),
('CLE', 'Cleveland Hopkins International Airport', 'Mehendiganj', 'Bangladesh'),
('DCY', 'Daocheng Yading Airport', 'Barra Velha', 'Brazil'),
('SUB', 'Juanda International Airport', 'Shuanggang', 'China'),
('ULX', 'Ulusaba Airport', 'Frydek', 'Poland'),
('HRI', 'Mattala Rajapaksa International Airport', 'Hengjian', 'China');


-- Sample data for department table
INSERT INTO department (departmentName, airportID) VALUES
('Department 1', 'LAX'),
('Department 2', 'JFK'),
('Department 3', 'LOG');


-- Sample data for lounge table
INSERT INTO lounge (name, airportID) VALUES
('Lounge 1', 'LAX'),
('Lounge 2', 'JFK'),
('Lounge 3', 'LOG');


-- Sample data for terminal table
INSERT INTO terminal (terminalID, airportID) VALUES
(1, 'LAX'),
(2, 'JFK'),
(3, 'LOG');


-- Sample data for gate table
INSERT INTO gate (gateNumber, terminalID) VALUES
(1, 1),
(2, 2),
(3, 3);


-- Sample data for store table
INSERT INTO store (terminalID, name) VALUES
(1, 'Store 1'),
(2, 'Store 2'),
(3, 'Store 3');


-- Sample data for airportEmployee table
INSERT INTO airportEmployee (fName, lName, salary, title, sex, emailAddress, birthDate, sup_id, departmentID) VALUES
('John', 'Doe', 50000, 'Manager', 'Male', 'john.doe@example.com', '1990-01-01', NULL, 1),
('Jane', 'Smith', 45000, 'Staff', 'Female', 'jane.smith@example.com', '1995-02-15', 1, 2),
('Bob', 'Johnson', 60000, 'Supervisor', 'Male', 'bob.johnson@example.com', '1985-05-10', NULL, 3);


-- Sample data for airline table
INSERT INTO airline (name, phone, email, rating) VALUES
('Kautzer and Sons', '856-880-2093', 'abariball0@timesonline.co.uk', 6),
('Schiller, Cruickshank and Rodriguez', '829-685-0790', 'agyorffy1@archive.org', 3),
('Daugherty, Borer and Frami', '790-892-9045', 'etrodden2@apache.org', 9),
('Cormier-Upton', '807-763-3022', 'adunkerton3@earthlink.net', 2),
('Weimann and Sons', '973-784-7969', 'hturbard4@house.gov', 10),
('Spinka-Ratke', '931-281-4427', 'dloudyan5@weibo.com', 2),
('Morar-Flatley', '335-548-4028', 'gwebby6@webs.com', 2),
('Hyatt-Kulas', '493-584-1781', 'ccommuzzo7@dion.ne.jp', 10),
('Armstrong, Kub and Becker', '405-244-8567', 'lgarioch8@wordpress.com', 8),
('Ankunding-Leuschke', '137-686-7683', 'belcombe9@google.co.uk', 4),
('Dibbert, Wilderman and Zboncak', '190-113-0417', 'blesora@uiuc.edu', 6),
('Bauch-Feil', '254-531-8593', 'drowbottamb@bizjournals.com', 10),
('Reilly LLC', '968-542-2323', 'lgovinic@omniture.com', 2),
('Kozey, Gorczany and Stiedemann', '437-205-6953', 'aspellsworthd@japanpost.jp', 5),
('Kassulke-Baumbach', '896-960-4201', 'ddornine@si.edu', 10),
('Cremin, Kutch and Hickle', '945-892-9783', 'hpatricksonf@bbb.org', 9),
('Hoppe-Farrell', '199-733-4958', 'mdeguiseg@ibm.com', 10),
('Hamill, Kerluke and Borer', '464-632-0915', 'urowlandsh@ted.com', 6),
('Torp, Kautzer and Hilll', '110-521-6320', 'lfallowfieldi@mapquest.com', 3),
('Sawayn Group', '345-274-9015', 'malleburtonj@cbsnews.com', 4),
('Toy Inc', '904-311-0868', 'amarjotk@com.com', 5),
('Jerde, Gleichner and Gottlieb', '724-519-4218', 'hgollinl@sakura.ne.jp', 7),
('Runolfsson, Von and Sawayn', '810-457-0935', 'lwannesm@myspace.com', 3),
('Harber and Sons', '921-279-4671', 'kdayshn@mit.edu', 8),
('Rath and Sons', '962-302-2977', 'rmackonochieo@ed.gov', 3),
('Schneider, Kuphal and Gutmann', '211-735-5656', 'lliffep@sourceforge.net', 5),
('Littel-Hermann', '956-691-1408', 'rbrannonq@usa.gov', 1),
('Rodriguez-Schimmel', '849-395-2748', 'dwaistellr@usnews.com', 7),
('Auer, Kuvalis and Macejkovic', '786-806-9191', 'apriestnalls@census.gov', 8),
('Breitenberg Group', '920-144-6492', 'isalamont@wisc.edu', 2),
('West-Schmeler', '586-157-8944', 'lhandreku@behance.net', 5),
('Dibbert, Littel and Ruecker', '276-212-6665', 'rrudev@google.com.hk', 8),
('Pouros-Weissnat', '446-743-0004', 'dmcconigalw@imgur.com', 3),
('Kilback, Hyatt and MacGyver', '260-265-5911', 'rmacquakerx@1und1.de', 1),
('Reichert-Kihn', '524-411-4199', 'dlauy@china.com.cn', 4),
('Friesen-Weber', '559-529-9973', 'skavez@nymag.com', 10),
('Jaskolski-Walker', '561-240-9852', 'scussen10@dagondesign.com', 6),
('Hammes, Franecki and Vandervort', '640-327-7814', 'dtantrum11@sitemeter.com', 2),
('Franecki LLC', '548-250-1738', 'mtrewinnard12@weebly.com', 2),
('Blick Group', '600-190-5287', 'rharbin13@aboutads.info', 4),
('West, Medhurst and Pouros', '697-935-1366', 'nfehners14@webeden.co.uk', 9),
('Yost, OKon and Bogan', '534-395-1742', 'blowthian15@soup.io', 9),
('Jerde, Murphy and Wolf', '878-349-2161', 'nshah16@plala.or.jp', 2),
('Herman-Langworth', '652-394-4248', 'jclappson17@cbslocal.com', 2),
('Kihn Group', '298-913-8541', 'dwestcot18@virginia.edu', 4),
('Swaniawski and Sons', '598-966-6037', 'cambrosoli19@so-net.ne.jp', 9),
('Graham-Ondricka', '329-120-8706', 'amelloi1a@plala.or.jp', 8),
('Davis, Gutmann and McLaughlin', '600-453-2416', 'abuglar1b@ocn.ne.jp', 6),
('Weber, Hahn and Effertz', '937-914-1515', 'amcclurg1c@google.com', 3),
('Gusikowski-Erdman', '505-922-0339', 'njilkes1d@printfriendly.com', 1);


-- Sample data for airplane table
INSERT INTO airplane (model, capacity, airlineID) VALUES
('Model 1', 150, 1),
('Model 2', 200, 2),
('Model 3', 100, 3);


-- Sample data for flight table
INSERT INTO flight (flightID, seatsAvailable, airplaneID, airlineID,
                    departureTime, arrivalTime, arrivalAirport, departureAirport,
                    arrivalTerminal, departureTerminal, arrivalGate, departureGate) VALUES
(3, 18, 3, 2, '2023-02-15 12:30:00', '2023-02-15 12:30:00', 'LAX', 'JFK', 2, 3, 2, 3),
(2, 0, 1, 3, '2023-02-15 12:30:00', '2023-02-15 12:30:00', 'LOG', 'JFK', 2, 1, 1, 1),
(1, 0, 1, 1, '2023-02-15 12:30:00', '2023-02-15 12:30:00', 'JFK', 'LOG', 3, 2, 2, 1);

-- Sample data for airlineflightEmployee table
INSERT INTO airlineFlightEmployee (fName, lName, salary, title, sex, emailAddress, birthDate, airlineID) VALUES
('Delinda', 'Edling', 117634, 'Reservation Agent', 'F', 'dedling0@independent.co.uk', '12/29/1944', 7),
('Ban', 'Farge', 273949, 'Line Maintenance Technician', 'M', 'bfarge1@google.nl', '06/03/1926', 19),
('Gregor', 'Rodolico', 250520, 'Flight Attendant', 'M', 'grodolico2@nytimes.com', '08/19/1950', 21),
('Joanie', 'Whall', 202287, 'Communications Specialist', 'F', 'jwhall3@washingtonpost.com', '12/20/1950', 49),
('Drake', 'Kee', 126654, 'Crew Resource Planner', 'M', 'dkee4@indiatimes.com', '11/29/1947', 10),
('Randy', 'Crumby', 52385, 'Route Planner', 'F', 'rcrumby5@wp.com', '02/11/1925', 19),
('Gertrudis', 'Berthome', 248041, 'Airline Finance Analyst', 'F', 'gberthome6@examiner.com', '06/17/2019', 5),
('Kaia', 'Bampkin', 96093, 'First Officer', 'F', 'kbampkin7@rediff.com', '08/07/2015', 44),
('Desdemona', 'Coskerry', 203380, 'Crew Scheduler', 'F', 'dcoskerry8@thetimes.co.uk', '02/11/1960', 30),
('Janos', 'Ralestone', 67145, 'Air Traffic Controller', 'M', 'jralestone9@rediff.com', '01/30/1998', 13),
('Oona', 'Ardron', 85843, 'Crew Resource Planner', 'F', 'oardrona@dailymail.co.uk', '12/20/1995', 43),
('Rozele', 'Shallcrass', 152632, 'Crew Chief', 'F', 'rshallcrassb@vistaprint.com', '11/04/1954', 47),
('Whitby', 'Savell', 277712, 'Flight Operations Coordinator', 'M', 'wsavellc@woothemes.com', '04/05/1921', 5),
('Dot', 'Donke', 229279, 'Aircraft Interior Designer', 'F', 'ddonked@sohu.com', '05/07/1959', 40),
('Gavin', 'Rosita', 189714, 'Crew Resource Planner', 'M', 'grositae@economist.com', '05/18/2018', 30),
('Harv', 'Brettor', 255600, 'Aircraft Engineer', 'M', 'hbrettorf@w3.org', '06/19/1958', 8),
('Nikkie', 'Childerley', 107426, 'Aircraft Mechanic', 'F', 'nchilderleyg@liveinternet.ru', '10/20/2006', 39),
('Windy', 'Matterface', 238275, 'Airport Security Officer', 'F', 'wmatterfaceh@businesswire.com', '05/01/2019', 20),
('Barbara', 'Silver', 117035, 'Crew Chief', 'F', 'bsilveri@dot.gov', '06/25/1940', 41),
('Kingsley', 'Rawet', 111816, 'Passenger Experience Manager', 'M', 'krawetj@delicious.com', '07/16/1999', 4),
('Ceil', 'Norgan', 50860, 'Customer Service Representative', 'F', 'cnorgank@redcross.org', '02/13/2007', 37),
('Fraser', 'Yedy', 159366, 'Aircraft Maintenance Technician', 'M', 'fyedyl@hud.gov', '10/16/1982', 20),
('Gwen', 'McCalister', 87857, 'Flight Dispatcher', 'F', 'gmccalisterm@walmart.com', '08/26/2011', 20),
('Shayne', 'Pilpovic', 272264, 'Aircraft Cleaner', 'M', 'spilpovicn@constantcontact.com', '12/01/1967', 7),
('Morna', 'Chicken', 145230, 'Load Planner', 'F', 'mchickeno@typepad.com', '07/24/1959', 46),
('Deny', 'Losano', 202693, 'Crew Scheduler', 'F', 'dlosanop@ucsd.edu', '03/14/1963', 47),
('Leigh', 'Tanswill', 127322, 'Airport Security Officer', 'F', 'ltanswillq@disqus.com', '01/19/1974', 41),
('Quincy', 'Bradman', 267969, 'Customer Service Representative', 'M', 'qbradmanr@yahoo.co.jp', '10/14/1999', 46),
('Vikky', 'Hemphrey', 227340, 'Pilot', 'F', 'vhemphreys@mayoclinic.com', '08/25/1928', 21),
('Bride', 'Froude', 82788, 'Line Maintenance Technician', 'F', 'bfroudet@miitbeian.gov.cn', '11/28/1931', 9),
('Ellery', 'Glave', 69552, 'Aircraft Maintenance Technician', 'M', 'eglaveu@usatoday.com', '01/15/2001', 9),
('Jamil', 'Linnock', 61956, 'Line Maintenance Technician', 'M', 'jlinnockv@nbcnews.com', '10/08/1958', 48),
('Corissa', 'Sillis', 175654, 'Cabin Crew Manager', 'F', 'csillisw@earthlink.net', '02/23/2018', 37),
('Federico', 'Moakson', 250689, 'Airline Training Instructor', 'M', 'fmoaksonx@google.ru', '08/27/1950', 37),
('Sal', 'Allsupp', 139459, 'Airline Manager', 'M', 'sallsuppy@nba.com', '10/11/1946', 47),
('Reinwald', 'Killner', 234611, 'Dispatch Coordinator', 'M', 'rkillnerz@domainmarket.com', '10/20/1996', 42),
('Maddi', 'Partkya', 179479, 'Captain', 'F', 'mpartkya10@wix.com', '06/03/1984', 24),
('Coretta', 'Campion', 90344, 'Aircraft Cleaner', 'F', 'ccampion11@ftc.gov', '07/05/1949', 46),
('Suzi', 'Rowlstone', 268079, 'Airline Finance Analyst', 'F', 'srowlstone12@blogs.com', '06/25/1974', 22),
('Bern', 'Corryer', 90359, 'Aircraft Interior Designer', 'M', 'bcorryer13@deviantart.com', '02/19/2013', 22),
('Linnet', 'Prigg', 236200, 'Flight Operations Coordinator', 'F', 'lprigg14@arizona.edu', '04/27/1927', 24),
('Linnea', 'McVeighty', 103118, 'Reservation Agent', 'F', 'lmcveighty15@reference.com', '05/25/1923', 24),
('Gregory', 'Emer', 162998, 'Ticketing Agent', 'M', 'gemer16@cmu.edu', '12/20/1925', 14),
('Nikolai', 'Canton', 125656, 'Airline Marketing Specialist', 'M', 'ncanton17@ucla.edu', '11/21/2012', 1),
('Nicolais', 'Kett', 228545, 'Aircraft Interior Designer', 'M', 'nkett18@cpanel.net', '02/28/1962', 35),
('Jilleen', 'Natt', 246816, 'Airline Analyst', 'F', 'jnatt19@skyrock.com', '05/03/1995', 43),
('Mose', 'Cahen', 225381, 'Operations Manager', 'M', 'mcahen1a@abc.net.au', '08/26/2018', 45),
('Celinka', 'Rainey', 216345, 'Aircraft Engineer', 'F', 'crainey1b@bloglovin.com', '02/04/1968', 17),
('Barny', 'Hearnes', 276039, 'Pilot', 'M', 'bhearnes1c@people.com.cn', '03/22/2006', 15),
('Elnar', 'Agney', 205092, 'Co-pilot', 'M', 'eagney1d@edublogs.org', '05/27/1982', 6),
('Tobe', 'Nellen', 68134, 'Airline Marketing Specialist', 'F', 'tnellen1e@tripod.com', '08/03/1977', 25);


-- Sample data for travelAgency table
INSERT INTO travelAgency (website, name, phone, ceoName) VALUES
('www.travelAgency1.com', 'Travel Agency 1', '111-111-1111', 'CEO 1'),
('www.travelAgency2.com', 'Travel Agency 2', '222-222-2222', 'CEO 2'),
('www.travelAgency3.com', 'Travel Agency 3', '333-333-3333', 'CEO 3');


-- Sample data for tripAdvisor table
INSERT INTO tripAdvisor (agencyID, firstName, lastName, salary, birthdate, email, phone, language, supervisor_id) VALUES
(1, 'Tom', 'Thompson', 60000, '1990-03-25', 'tom.thompson@example.com', '444-444-4444', 'English', NULL),
(2, 'Sara', 'Smith', 55000, '1985-12-12', 'sara.smith@example.com', '555-555-5555', 'Spanish', 1),
(3, 'Mike', 'Miller', 65000, '1995-08-30', 'mike.miller@example.com', '666-666-6666', 'French', 1);


-- Sample data for passenger table
INSERT INTO passenger (fName, lName, phone, sex, birthDate, email, street, zipcode, state, country, tripAdvisorID) VALUES
('Peter', 'Parker', 123456789, 'Male', '1989-06-15', 'peter.parker@example.com', '123 Main St', 10001, 'NY', 'USA', 1),
('Mary', 'Jane', 987654321, 'Female', '1992-02-28', 'mary.jane@example.com', '456 Oak St', 20002, 'CA', 'USA', 1),
('Tony', 'Stark', 555555555, 'Male', '1970-05-29', 'tony.stark@example.com', '789 Pine St', 30003, 'TX', 'USA', 1);


-- Sample data for ticket table
INSERT INTO ticket (flightID, seatNum, class, price, boardingGroup, passengerID) VALUES
(1, 'A1', 'Business', 500.00, 'A', 3),
(2, 'B3', 'Economy', 300.00, 'B', 2),
(3, 'C2', 'First Class', 700.00, 'C', 1);


-- Sample data for baggage table
INSERT INTO baggage (baggageID, passengerID, ticketID, flightID, weight) VALUES
(1, 3, 1, 3, 25.5),
(2, 2, 2, 2, 15.0),
(3, 1, 3, 1, 30.0);

-- Sample data for crew table
INSERT INTO crew (employeeID, flightID) VALUES
(2, 3),
(3, 1),
(1, 2);