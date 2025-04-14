drop database if exists sf;
create database if not exists sf;
use sf;

DROP TABLE IF EXISTS company;
CREATE TABLE company (
	company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(50) NOT NULL,
    year_established INT NOT NULL,
    fast_fashion TINYINT NOT NULL,
    physical_store TINYINT NOT NULL,
    annual_emissions INT NOT NULL
);


CREATE TABLE Material (
	material_id INT AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	animal_derived TINYINT NOT NULL,
	type ENUM ("Recycled", "Natural", "Synthetic") NOT NULL,
	machine_washable TINYINT NOT NULL,
	global_organic_textile_standard TINYINT,
	PRIMARY KEY (material_id)
);


CREATE TABLE Product (
	product_id INT AUTO_INCREMENT,
	clothing_type VARCHAR(50) NOT NULL,
	price DOUBLE,
	biodegradable_packaging TINYINT,
	fair_trade_certification TINYINT,
	num_sales INT,
	num_returns INT,
	PRIMARY KEY (product_id)
);


CREATE TABLE Material_in_Product (
	material_id INT,
	product_id INT,
	percentage DECIMAL,
	PRIMARY KEY (material_id, product_id),
	FOREIGN KEY (material_id) REFERENCES Material(material_id),
	FOREIGN KEY (product_id) REFERENCES Product(product_id) 
);


CREATE TABLE Factory (
	factory_id INT AUTO_INCREMENT,
	city VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	avg_employee_wage DOUBLE NOT NULL,
	safety_rating ENUM("Low", "Medium", "High") NOT NULL,
	PRIMARY KEY (factory_id)
);


CREATE TABLE Production (
	factory_id INT,
	product_id INT,
	company_id INT,
	num_produced INT NOT NULL,
	PRIMARY KEY ( factory_id, product_id, company_id),
	FOREIGN KEY (factory_id) REFERENCES Factory(factory_id),
	FOREIGN KEY (product_id) REFERENCES Product(product_id),
	FOREIGN KEY (company_id) REFERENCES Company(company_id)
);


CREATE TABLE Sustainability_Practice (
	sustainability_practice_id INT AUTO_INCREMENT,
description VARCHAR(300) NOT NULL,
rating ENUM("Poor", "Standard", "Excellent") NOT NULL,
PRIMARY KEY (sustainability_practice_id)
);


CREATE TABLE Sustainability_Policy (
	company_id INT,
	sustainability_practice_id INT,
	PRIMARY KEY (company_id, sustainability_practice_id),
	FOREIGN KEY (company_id) REFERENCES Company(company_id),
	FOREIGN KEY (sustainability_practice_id) REFERENCES Sustainability_Practice(sustainability_practice_id) 
);


INSERT INTO company (company_name, year_established, fast_fashion, physical_store, annual_emissions) VALUES
	('Fashion Corp', 2005, 1, 1, 120000),
	('Trendy Apparel', 2012, 1, 1, 80000),
	('EcoWear Ltd', 2017, 0, 1, 30000),
	('Vintage Vibes', 2001, 0, 1, 45000),
	('ModernStyles Inc.', 2010, 1, 0, 110000),
	('Urban Chic', 2015, 1, 1, 95000),
	('Sustainable Threads', 2018, 0, 1, 22000);

INSERT INTO Product (product_id, clothing_type, price, biodegradable_packaging, FTC, num_sales, num_returns, company_id)
VALUES
    ("T-Shirt", 20.99, 1, 1, 1500, 25, 1),
    ("Jacket", 90, 0, 1, 500, 25, 1),
    ("Jeans", 75, 1, 1, 700, 15, 2),
    ("Sneakers", 55, 1, 0, 400, 10, 3),
    ("Scarf", 35.99, 0, 1, 200, 5, 2),
    ("Dress", 120, 1, 1, 300, 10, 1),
    ("Hat", 25.50, 0, 1, 100, 3, 2),
    ("Gloves", 18.75, 1, 0, 250, 8, 3);


INSERT INTO material
VALUES
	("Cotton", 0, "Natural", 1, 1),
	("Polyester", 0, "Synthetic", 1, 0),
	("Wool", 1, "Natural", 0, 0),
	("Nylon", 0, "Synthetic", 1, 0),
	("Recycled Nylon", 0, "Recycled", 1, 1),
	("Mulesed Wool", 1, "Natural", 0, 0),
	("Leather", 1, "Natural", 0, 0),
	("Silk", 1, "Natural", 0, 1);


INSERT INTO ProductMaterial (material_id, product_id, percentage)
VALUES
	(1, 1, 70.0),
	(2, 1, 30.0),
	(3, 2, 100.0),
	(2, 3, 60.0),
	(4, 3, 40.0),
	(5, 4, 100.0),
	(8, 5, 100.0);


INSERT INTO Factory (city, country, avg_employee_salary, safety)
VALUES
	("Guangzhou", "China", 12.50, "Low"),
	("Dhaka", "Bangladesh", 10.35, "Medium"),
	("Ho Chi Minh City", "Vietnam", 16.00, "High"),
	("Mexico City", "Mexico", 16.00, "Medium"),
	("Barcelona", "Spain", 15.00, "High");


INSERT INTO Production (factory_id, product_id, company_id, num_produced) VALUES
	(1, 1, 1, 1000),
	(1, 2, 2, 500),
	(2, 3, 1, 800),
	(3, 4, 3, 600),
	(4, 5, 7, 400),
	(5, 1, 6, 200),
	(5, 2, 4, 150),
	(2, 5, 1, 300);


INSERT INTO Sustainability_Practice (description, rating) VALUES
	('Use of recycled materials' , 'Excellent'),
	('Carbon offset initiatives' , 'Standard'),
	('Water-saving manufacturing processes', 'Excellent'),
	('minimal plastic packaging', 'Poor'), 
	('Fair trade certified labor practices', 'Standard'),
	('Non-toxic dyes and chemicals in manufacturing', 'Standard'),
	('Employee health and safety programs', 'Excellent');


INSERT INTO Sustainability_Policy (company_id, sustainability_practice_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(2, 7),
(3, 3),
(3, 4),
(3, 5),
(3, 7),
(4, 5),
(5, 2),
(6, 1),
(6, 5),
(7, 3),
(7, 6),
(7, 7);


