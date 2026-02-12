-- create Masini table
CREATE TABLE Masini ( 
ID_Masina NUMBER PRIMARY KEY, 
Marca VARCHAR2(50) NOT NULL, 
Model VARCHAR2(50) NOT NULL, 
Pret NUMBER(10, 2) NOT NULL, 
Stare VARCHAR2(20) CHECK (Stare IN ('Nou', 'Second-Hand')), 
Disponibil NUMBER(1) DEFAULT 1 
);

-- create Clienti1 table
CREATE TABLE Clienti1 ( 
ID_Client NUMBER PRIMARY KEY, 
Nume VARCHAR2(50) NOT NULL, 
Prenume VARCHAR2(50) NOT NULL, 
Telefon VARCHAR2(15) UNIQUE, 
Email VARCHAR2(50) 
);

-- create Vanzari table
CREATE TABLE Vanzari ( 
ID_Vanzare NUMBER PRIMARY KEY, 
ID_Masina NUMBER REFERENCES Masini(ID_Masina), 
ID_Client NUMBER REFERENCES Clienti(ID_Client), 
Data_Vanzare DATE DEFAULT SYSDATE, 
Pret_Final NUMBER(10, 2) 
);

-- create Garantii table
CREATE TABLE Garantii ( 
ID_Garantie NUMBER PRIMARY KEY, 
ID_Masina NUMBER REFERENCES Masini(ID_Masina), 
Data_Inceput DATE DEFAULT SYSDATE, 
Data_Sfarsit DATE 
);

-- add a check constraint to the Masini table so the value in the Stare column can only be Nou or Second-Hand
ALTER TABLE Masini ADD CONSTRAINT CK_Stare CHECK (Stare IN ('Nou', 'Second-Hand'));

-- add the Culoare column to the Masini table, with the default value Necunoscut
ALTER TABLE Masini ADD Culoare VARCHAR2(20) DEFAULT 'Necunoscut';


-- extend the length of the Email column in the Clienti1 table to 100 characters
ALTER TABLE Clienti1 MODIFY Email VARCHAR2(100);


-- add the Discount column to the Vanzari table
ALTER TABLE Vanzari ADD Discount NUMBER(5, 2);


-- delete the Vanzari table along with all associated constraints
DROP TABLE Vanzari CASCADE CONSTRAINTS;


-- add three new vehicles to the Masini table, specifying each car's ID, brand, model, price, condition, and availability:
INSERT INTO Masini (ID_Masina, Marca, Model, Pret, Stare, Disponibil) 
VALUES (1, 'Toyota', 'Corolla', 22000, 'Nou', 1); 
INSERT INTO Masini (ID_Masina, Marca, Model, Pret, Stare, Disponibil) 
VALUES (2, 'BMW', 'X5', 45000, 'Second-Hand', 1); 
INSERT INTO Masini (ID_Masina, Marca, Model, Pret, Stare, Disponibil) 
VALUES (3, 'Audi', 'Q7', 60000, 'Nou', 1);
INSERT INTO Masini (ID_Masina, Marca, Model, Pret, Stare, Disponibil) 
VALUES (4, 'Dacia', 'Duster', 18000, 'Nou', 1); 
INSERT INTO Masini (ID_Masina, Marca, Model, Pret, Stare, Disponibil) 
VALUES (5, 'Mercedes', 'A-Class', 35000, 'Second-Hand', 1);

-- add two transactions to the Vanzari table, specifying the transaction ID, car ID, customer ID, sale date, and final price, using TO_DATE() for correct date formatting.
INSERT INTO Vanzari (ID_Vanzare, ID_Masina, ID_Client, Data_Vanzare, Pret_Final) 
VALUES (1, 1, 1, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 22000); 
INSERT INTO Vanzari (ID_Vanzare, ID_Masina, ID_Client, Data_Vanzare, Pret_Final) 
VALUES (2, 3, 2, TO_DATE('2024-12-15', 'YYYY-MM-DD'), 60000);


-- add a warranty in the Garantii table for the car with ID_Masina = 4, with a start date of December 20, 2024, and an end date of December 20, 2027, using TO_DATE() for correct date conversion.
INSERT INTO Garantii (ID_Garantie, ID_Masina, Data_Inceput, Data_Sfarsit) 
VALUES (1, 4, TO_DATE('2024-12-20', 'YYYY-MM-DD'), TO_DATE('2027-12-20', 'YYYY-MM-DD'));


-- add a new car to the Masini table, specifying its ID, brand, model, price, condition, and availability.
INSERT INTO Masini (ID_Masina, Marca, Model, Pret, Stare, Disponibil) 
VALUES (2, 'Dacia', 'Duster', 18000, 'Nou', 1);


-- record a new sale for the customer with ID 2, who purchases the car with ID 4, applying a discount.
-- The sale date is December 20, 2024, and the final price resulting after applying the discount is 17,000.
INSERT INTO Vanzari (ID_Vanzare, ID_Masina, ID_Client, Data_Vanzare, Pret_Final) 
VALUES (3, 4, 2, TO_DATE('2024-12-20', 'YYYY-MM-DD'), 17000);


-- mark the vehicle with ID 1 as sold by updating the Disponibil field:
UPDATE Masini 
SET Disponibil = 0 
WHERE ID_Masina = 1;


-- update the final price for the transaction with ID 1:
UPDATE Vanzari 
SET Pret_Final = 21000 
WHERE ID_Vanzare = 1;

-- update the email address of the customer with ID 2 to correct an error:
UPDATE Clienti1 
SET Email = 'alexia.vacaru@newdomain.com' 
WHERE ID_Client = 2;

-- update the brand and model of the car with ID 3:
UPDATE Masini 
SET Marca = 'Mercedes', Model = 'GLC' 
WHERE ID_Masina = 3;

-- delete cars that have the “Second-Hand” status:
DELETE FROM Masini 
WHERE Stare = 'Second-Hand';

-- delete the customer with ID 2 from the database:
DELETE FROM Clienti1 
WHERE ID_Client = 2;

-- display all information about the customer with ID 2:
SELECT * FROM Clienti1 
WHERE ID_Client = 2;

-- display cars with a price greater than 30,000 and that are not new.
SELECT ID_Masina, Marca, Model, Pret 
FROM Masini 
WHERE Pret > 30000 AND Stare != 'Nou';

-- display customers who do not have a specified email address.
SELECT ID_Client, Nume, Prenume 
FROM Clienti1 
WHERE Email IS NULL;

-- display all cars that have a price between 20,000 and 50,000.
SELECT Marca, Model, Pret
FROM Masini 
WHERE Pret BETWEEN 20000 AND 50000;

-- display the status of the cars and the number of vehicles for each status.
SELECT Stare, COUNT(*) AS Nr_Masini 
FROM Masini 
GROUP BY Stare;

-- display cars that have a price higher than all the prices of second-hand cars.
SELECT Marca, Model, Pret 
FROM Masini 
WHERE Pret > ALL (SELECT Pret FROM Masini WHERE Stare = 'Second-Hand');

-- display all customers who do not have a name starting with the letter 'A', along with the number of orders placed by each customer and the granted discount, calculated as follows:
-- if a customer has exactly 1 order, the discount is 10%
-- if a customer has exactly 2 orders, the discount is 15%
-- if a customer has 3 or more orders, the discount is 20%
SELECT Nume, 
(SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) AS Numar_Comenzi, 
CASE 
WHEN (SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) = 1 THEN 0.10 
WHEN (SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) = 2 THEN 0.15 
WHEN (SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) >= 3 THEN 0.20 
ELSE 0 
END AS Discount 
FROM Clienti1 
MINUS 
SELECT Nume, 
(SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) AS Numar_Comenzi, 
CASE 
WHEN (SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) = 1 THEN 0.10 
WHEN (SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) = 2 THEN 0.15 
WHEN (SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) >= 3 THEN 0.20 
ELSE 0 
END AS Discount 
FROM Clienti1 
WHERE Nume LIKE 'A%';

-- the commission is determined based on the number of orders placed:
-- 1 order → 10% commission of the total value.
-- 2 orders → 20% commission.
-- 3 or more orders → 30% commission.
SELECT Nume, 
(SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) AS Numar_Comenzi, 
0.10 * (SELECT SUM(Pret_Final) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) AS Valoare_Comision 
FROM Clienti1 
WHERE (SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) = 1 
UNION 
SELECT Nume, 
(SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) AS Numar_Comenzi, 
0.20 * (SELECT SUM(Pret_Final) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) AS Valoare_Comision 
FROM Clienti1 
WHERE (SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) = 2 
UNION 
SELECT Nume, 
(SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) AS Numar_Comenzi, 
0.30 * (SELECT SUM(Pret_Final) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) AS Valoare_Comision 
FROM Clienti1 
WHERE (SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Client = Clienti1.ID_Client) >= 3;

-- select products ordered at least 3 times that have a total value different from 20,000 or 50,000.
SELECT Marca, 
(SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Masina = Masini.ID_Masina) AS Numar_Comenzi, 
(SELECT SUM(Pret_Final) 
FROM Vanzari 
WHERE Vanzari.ID_Masina = Masini.ID_Masina) AS Valoare_Totala 
FROM Masini 
WHERE (SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Masina = Masini.ID_Masina) >= 3 
INTERSECT 
SELECT Marca, 
(SELECT COUNT(*) 
FROM Vanzari 
WHERE Vanzari.ID_Masina = Masini.ID_Masina) AS Numar_Comenzi, 
(SELECT SUM(Pret_Final) 
FROM Vanzari 
WHERE Vanzari.ID_Masina = Masini.ID_Masina) AS Valoare_Totala
FROM Masini 
WHERE (SELECT SUM(Pret_Final) 
FROM Vanzari 
WHERE Vanzari.ID_Masina = Masini.ID_Masina) NOT IN (20000, 50000);

-- display the transaction ID and the date formatted as DD-MM-YYYY.
SELECT ID_Vanzare, TO_CHAR(Data_Vanzare, 'DD-MM-YYYY') AS Data_Tranzactie 
FROM Vanzari;

-- display transactions carried out after December 1, 2024.
SELECT ID_Vanzare, Pret_Final 
FROM Vanzari 
WHERE Data_Vanzare > TO_DATE('2024-12-01', 'YYYY-MM-DD');

-- display the first and last names of customers who placed orders and whose names do not start with the letter 'A', along with the granted discount, calculated as follows:
-- the discount is 10% for customers with a single order.
-- the discount is 15% for customers with two orders.
-- the discount is 20% for customers with three or more orders.
SELECT Nume, Prenume, 
CASE 
WHEN COUNT(ID_Vanzare) = 1 THEN 0.1 
WHEN COUNT(ID_Vanzare) = 2 THEN 0.15 
WHEN COUNT(ID_Vanzare) >= 3 THEN 0.2 
ELSE 0 
END AS Discount 
FROM Clienti1 c, Vanzari v 
WHERE c.ID_Client = v.ID_Client 
GROUP BY Nume, Prenume 
MINUS 
SELECT Nume, Prenume, 
CASE 
WHEN COUNT(ID_Vanzare) = 1 THEN 0.1 
WHEN COUNT(ID_Vanzare) = 2 THEN 0.15 
WHEN COUNT(ID_Vanzare) >= 3 THEN 0.2 
ELSE 0 
END AS Discount
FROM Clienti1 c, Vanzari v 
WHERE c.ID_Client = v.ID_Client AND Nume LIKE 'A%' 
GROUP BY Nume, Prenume;

-- display the status of the cars and their average price, only for statuses with at least 2 vehicles.
SELECT Stare, AVG(Pret) AS Pret_Mediu 
FROM Masini 
GROUP BY Stare 
HAVING COUNT(*) >= 2;

-- display customers and email addresses, using “Necunoscut” for NULL emails.
SELECT Nume, Prenume, NVL(Email, 'Necunoscut') AS Email
FROM Clienti1;

-- display the first 3 letters of each car brand.
SELECT Marca, SUBSTR(Marca, 1, 3) AS Prefix 
FROM Masini;

-- display the total number of transactions carried out in each year, extracting the year from the sale date and grouping the results accordingly.
SELECT EXTRACT(YEAR FROM Data_Vanzare) AS An_Tranzactie, COUNT(*) AS Nr_Tranzactii 
FROM Vanzari 
GROUP BY EXTRACT(YEAR FROM Data_Vanzare);

-- display customers and the total sum of their expenses, selecting only those who spent more than 50,000 on car purchases.
SELECT ID_Client, SUM(Pret_Final) AS Total_Cheltuit 
FROM Vanzari 
GROUP BY ID_Client 
HAVING SUM(Pret_Final) > 50000;

-- display all cars in the hierarchy, along with their hierarchical level, ordered increasingly by level.
SELECT ID_Masina, Marca, Model, LEVEL 
FROM Masini 
START WITH ID_Parinte IS NULL 
CONNECT BY PRIOR ID_Masina = ID_Parinte 
ORDER BY LEVEL;

-- display the complete path of each car in the hierarchy, indicating all hierarchical nodes up to that car. Use the character / to separate each node in the path.
SELECT ID_Masina, 
SYS_CONNECT_BY_PATH(Marca || ' ' || Model, '/') AS Cale_Completa, 
LEVEL 
FROM Masini 
START WITH ID_Parinte IS NULL 
CONNECT BY PRIOR ID_Masina = ID_Parinte;

-- select only the cars on level 2 of the hierarchy and order them by car ID.
SELECT ID_Masina, Marca, Model, LEVEL 
FROM Masini 
WHERE LEVEL = 2 
CONNECT BY PRIOR ID_Masina = ID_Parinte 
ORDER BY ID_Masina;


-- list all cars in the hierarchy, along with their level and the total number of superiors in their hierarchical path, ordered by level and car ID.
SELECT ID_Masina, Marca, Model, LEVEL, SYS_CONNECT_BY_PATH(Marca, '/') AS Superioara 
FROM Masini 
START WITH ID_Parinte IS NULL 
CONNECT BY PRIOR ID_Masina = ID_Parinte 
ORDER BY LEVEL, ID_Masina;


-- create a view to display complete sales details, including customer and car information.
CREATE VIEW Vanzari_Detaliate AS 
SELECT 
v.ID_Vanzare, 
c.Nume || ' ' || c.Prenume AS Client, 
m.Marca || ' ' || m.Model AS Masina, 
v.Data_Vanzare,
v.Pret_Final 
FROM Vanzari v, Clienti1 c, Masini m 
WHERE v.ID_Client = c.ID_Client 
AND v.ID_Masina = m.ID_Masina;

-- create an index for the Pret column in the Masini table to optimize price searches.
CREATE INDEX idx_pret_masini ON Masini(Pret);

-- create a sequence to automatically generate transaction IDs in the Vanzari table.
CREATE SEQUENCE seq_vanzari 
START WITH 1 
INCREMENT BY 1 
NOCACHE 
NOCYCLE;

-- creating a synonym for the Vanzari_Detaliate view.
CREATE SYNONYM Sinonim_Vanzari_Detaliate FOR Vanzari_Detaliate;
