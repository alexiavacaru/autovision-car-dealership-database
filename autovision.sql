--creare table Masini
CREATE TABLE Masini ( 
ID_Masina NUMBER PRIMARY KEY, 
Marca VARCHAR2(50) NOT NULL, 
Model VARCHAR2(50) NOT NULL, 
Pret NUMBER(10, 2) NOT NULL, 
Stare VARCHAR2(20) CHECK (Stare IN ('Nou', 'Second-Hand')), 
Disponibil NUMBER(1) DEFAULT 1 
);

--creare tabel Clienti1
CREATE TABLE Clienti1 ( 
ID_Client NUMBER PRIMARY KEY, 
Nume VARCHAR2(50) NOT NULL, 
Prenume VARCHAR2(50) NOT NULL, 
Telefon VARCHAR2(15) UNIQUE, 
Email VARCHAR2(50) 
);

--creare tabel Vanzari
CREATE TABLE Vanzari ( 
ID_Vanzare NUMBER PRIMARY KEY, 
ID_Masina NUMBER REFERENCES Masini(ID_Masina), 
ID_Client NUMBER REFERENCES Clienti(ID_Client), 
Data_Vanzare DATE DEFAULT SYSDATE, 
Pret_Final NUMBER(10, 2) 
);

--creare tabel Garantii
CREATE TABLE Garantii ( 
ID_Garantie NUMBER PRIMARY KEY, 
ID_Masina NUMBER REFERENCES Masini(ID_Masina), 
Data_Inceput DATE DEFAULT SYSDATE, 
Data_Sfarsit DATE 
);

--adaugati o constrangere check in tabelul Masini pentru ca valoarea din coloana Stare sa fie doar Nou sau Second-Hand
ALTER TABLE Masini ADD CONSTRAINT CK_Stare CHECK (Stare IN ('Nou', 'Second-Hand'));

--adaugati coloana Culoare in tabelul Masini, cu valoarea implicita Necunoscut
ALTER TABLE Masini ADD Culoare VARCHAR2(20) DEFAULT 'Necunoscut';


-- extindeți lungimea coloanei Email din tabelul Clienti1 la 100 de caractere
ALTER TABLE Clienti1 MODIFY Email VARCHAR2(100);


--adăugați coloana Discount în tabelul Vanzari 
ALTER TABLE Vanzari ADD Discount NUMBER(5, 2);


--stergeți tabelul Vanzari împreună cu toate constrângerile asociate
DROP TABLE Vanzari CASCADE CONSTRAINTS;


--adăugați trei vehicule noi în tabelul Masini, specificând ID-ul fiecărei mașini, marca, modelul, prețul, starea și disponibilitatea acestora: 
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

--adăugați două tranzacții în tabelul Vanzari, specificând ID-ul tranzacției, ID-ul mașinii, ID-ul clientului, data vânzării și prețul final, folosind TO_DATE() pentru formatarea corectă a datei. 
INSERT INTO Vanzari (ID_Vanzare, ID_Masina, ID_Client, Data_Vanzare, Pret_Final) 
VALUES (1, 1, 1, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 22000); 
INSERT INTO Vanzari (ID_Vanzare, ID_Masina, ID_Client, Data_Vanzare, Pret_Final) 
VALUES (2, 3, 2, TO_DATE('2024-12-15', 'YYYY-MM-DD'), 60000);


--adăugați o garanție în tabelul Garantii pentru mașina cu ID_Masina = 4, cu data de început 20 decembrie 2024 și data de sfârșit 20 decembrie 2027, utilizând TO_DATE() pentru conversia corectă a datelor. 
INSERT INTO Garantii (ID_Garantie, ID_Masina, Data_Inceput, Data_Sfarsit) 
VALUES (1, 4, TO_DATE('2024-12-20', 'YYYY-MM-DD'), TO_DATE('2027-12-20', 'YYYY-MM-DD'));


--adăugați o nouă mașină în tabelul Masini, specificând ID-ul, marca, modelul, prețul, starea și disponibilitatea acesteia. 
INSERT INTO Masini (ID_Masina, Marca, Model, Pret, Stare, Disponibil) 
VALUES (2, 'Dacia', 'Duster', 18000, 'Nou', 1);


--inregistrați o nouă vânzare pentru clientul cu ID-ul 2, care achiziționează mașina cu ID-ul 4, aplicând un discount. 
Data vânzării este 20 decembrie 2024, iar prețul final rezultat după aplicarea discountului este 17.000. 
INSERT INTO Vanzari (ID_Vanzare, ID_Masina, ID_Client, Data_Vanzare, Pret_Final) 
VALUES (3, 4, 2, TO_DATE('2024-12-20', 'YYYY-MM-DD'), 17000);


--marcați vehiculul cu ID-ul 1 ca fiind vândut, actualizând câmpul Disponibil: 
UPDATE Masini 
SET Disponibil = 0 
WHERE ID_Masina = 1;


--actualizați prețul final pentru tranzacția cu ID-ul 1: 
UPDATE Vanzari 
SET Pret_Final = 21000 
WHERE ID_Vanzare = 1;

--actualizați adresa de email a clientului cu ID-ul 2 pentru a corecta o eroare: 
UPDATE Clienti1 
SET Email = 'alexia.vacaru@newdomain.com' 
WHERE ID_Client = 2;

--actualizați marca și modelul mașinii cu ID-ul 3: 
UPDATE Masini 
SET Marca = 'Mercedes', Model = 'GLC' 
WHERE ID_Masina = 3;

--stergeți mașinile care au starea “Second-Hand”: 
DELETE FROM Masini 
WHERE Stare = 'Second-Hand';

--stergeți clientul cu ID-ul 2 din baza de date: 
DELETE FROM Clienti1 
WHERE ID_Client = 2;

--afișați toate informațiile despre clientul cu ID-ul 2: 
SELECT * 
FROM Clienti1 
WHERE ID_Client = 2;

--afișați mașinile cu prețul mai mare de 30.000 și care nu sunt noi. 
SELECT ID_Masina, Marca, Model, Pret 
FROM Masini 
WHERE Pret > 30000 AND Stare != 'Nou';

--afișați clienții care nu au specificată adresa de e-mail. 
SELECT ID_Client, Nume, Prenume 
FROM Clienti1 
WHERE Email IS NULL;

--afișați toate mașinile care au prețul între 20.000 și 50.000. 
SELECT Marca, Model, Pret
FROM Masini 
WHERE Pret BETWEEN 20000 AND 50000;

--afișați starea mașinilor și numărul de vehicule pentru fiecare stare. 
SELECT Stare, COUNT(*) AS Nr_Masini 
FROM Masini 
GROUP BY Stare;

--afisati masinile care au un pret mai mare decat toate preturile masinilor second-hand. 
SELECT Marca, Model, Pret 
FROM Masini 
WHERE Pret > ALL (SELECT Pret FROM Masini WHERE Stare = 'Second-Hand');

--afișați toți clienții care nu au un nume ce începe cu litera ‘A’, împreună cu numărul de comenzi plasate de fiecare client și discount-ul acordat, calculat astfel: 
--dacă un client are exact 1 comandă, discount-ul este de 10% 
--dacă un client are exact 2 comenzi, discount-ul este de 15% 
--dacă un client are 3 sau mai multe comenzi, discount-ul este de 20% 
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

--se determină comisionul pe baza numărului comenzilor efectuate:
--1 comanda → comision 10% din valoarea totală.
--2 comenzi → comision 20%.
--3 sau mai multe comenzi → comision 30%.
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

--se selectează produsele comandate de cel puțin 3 ori, care au valoarea totală diferită de 20.000 sau 50.000. 
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

--afișați ID-ul tranzacției și data formatată DD-MM-YYYY. 
SELECT ID_Vanzare, TO_CHAR(Data_Vanzare, 'DD-MM-YYYY') AS Data_Tranzactie 
FROM Vanzari;

--afișați tranzacțiile efectuate după 1 decembrie 2024. 
SELECT ID_Vanzare, Pret_Final 
FROM Vanzari 
WHERE Data_Vanzare > TO_DATE('2024-12-01', 'YYYY-MM-DD');

--afișați numele și prenumele clienților care au plasat comenzi și al căror nume nu începe cu litera ‘A’, împreună cu discount-ul acordat, calculat astfel: 
--discount-ul este de 10% pentru clienții cu o singură comandă. 
--discount-ul este de 15% pentru clienții cu două comenzi. 
--discount-ul este de 20% pentru clienții cu trei sau mai multe comenzi. 
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

--afișați starea mașinilor și prețul mediu al acestora, doar pentru stările cu cel puțin 2 vehicule. 
SELECT Stare, AVG(Pret) AS Pret_Mediu 
FROM Masini 
GROUP BY Stare 
HAVING COUNT(*) >= 2;

--afișați clienții și adresele de e-mail, utilizând “Necunoscut” pentru emailurile NULL. 
SELECT Nume, Prenume, NVL(Email, 'Necunoscut') AS Email
FROM Clienti1;

--afișați primele 3 litere ale fiecărei mărci de mașini. 
SELECT Marca, SUBSTR(Marca, 1, 3) AS Prefix 
FROM Masini;

--afișați numărul total de tranzacții efectuate în fiecare an, extrăgând anul din data vânzării și grupând rezultatele în funcție de acesta. 
SELECT EXTRACT(YEAR FROM Data_Vanzare) AS An_Tranzactie, COUNT(*) AS Nr_Tranzactii 
FROM Vanzari 
GROUP BY EXTRACT(YEAR FROM Data_Vanzare);

--afișați clienții și suma totală a cheltuielilor acestora, selectând doar cei care au cheltuit mai mult de 50.000 pe achiziția de mașini. 
SELECT ID_Client, SUM(Pret_Final) AS Total_Cheltuit 
FROM Vanzari 
GROUP BY ID_Client 
HAVING SUM(Pret_Final) > 50000;

--afișați toate mașinile din ierarhie, împreună cu nivelul lor ierarhic, ordonate crescător după nivel. 
SELECT ID_Masina, Marca, Model, LEVEL 
FROM Masini 
START WITH ID_Parinte IS NULL 
CONNECT BY PRIOR ID_Masina = ID_Parinte 
ORDER BY LEVEL;

--afișați traseul complet al fiecărei mașini din ierarhie, indicând toate nodurile ierarhice până la mașina respectivă. Utilizați caracterul / pentru a separa fiecare nod din traseu. 
SELECT ID_Masina, 
SYS_CONNECT_BY_PATH(Marca || ' ' || Model, '/') AS Cale_Completa, 
LEVEL 
FROM Masini 
START WITH ID_Parinte IS NULL 
CONNECT BY PRIOR ID_Masina = ID_Parinte;

--selectați doar mașinile aflate pe nivelul 2 al ierarhiei și ordonați-le după ID-ul mașinii. 
SELECT ID_Masina, Marca, Model, LEVEL 
FROM Masini 
WHERE LEVEL = 2 
CONNECT BY PRIOR ID_Masina = ID_Parinte 
ORDER BY ID_Masina;


--listați toate mașinile din ierarhie, împreună cu nivelul lor și cu numărul total de superiori din calea lor ierarhică, ordonate după nivel și ID-ul mașinii. 
SELECT ID_Masina, Marca, Model, LEVEL, SYS_CONNECT_BY_PATH(Marca, '/') AS Superioara 
FROM Masini 
START WITH ID_Parinte IS NULL 
CONNECT BY PRIOR ID_Masina = ID_Parinte 
ORDER BY LEVEL, ID_Masina;


--creați o vedere pentru a afișa detalii complete despre vânzări, incluzând informațiile despre client și mașină. 
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

--creați un index pentru coloana Pret din tabelul Masini pentru a optimiza căutările după preț. 
CREATE INDEX idx_pret_masini ON Masini(Pret);

--creați o secvență pentru a genera automat ID-urile tranzacțiilor în tabelul Vanzari. 
CREATE SEQUENCE seq_vanzari 
START WITH 1 
INCREMENT BY 1 
NOCACHE 
NOCYCLE;

--crearea unui sinonim pentru view-ul Vanzari_Detaliate. 
CREATE SYNONYM Sinonim_Vanzari_Detaliate FOR Vanzari_Detaliate;




