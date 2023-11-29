CREATE table vornamen
(
	jahr_id int,
    bezirk_id int,
    geschlecht_bin int,
    vorname varchar (30),
    anzahl int
 );   
 
 CREATE TABLE wohnbezirke
 ( 
	bezirk_id int PRIMARY KEY,
    bezirk_name varchar (30)
);

 CREATE TABLE jahre
 ( 
	jahr_id int PRIMARY KEY,
    jahr int
);

CREATE TABLE geschlecht
(
	geschlecht_bin int PRIMARY KEY,
    geschlecht_name varchar(30)
);

INSERT INTO geschlecht (geschlecht_bin, geschlecht_name) VALUES
    (1, 'männlich'),
    (2, 'weiblich');


USE babynames;
LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\babynames\\OGDEXT_VORNAMEN_1.csv' INTO TABLE vornamen
CHARACTER SET utf8mb4
FIELDS terminated by ';'
IGNORE 1 Lines;

USE babynames;
LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\babynames\\OGDEXT_VORNAMEN_1_C-JAHR-0.csv' INTO TABLE jahre
CHARACTER SET utf8mb4
FIELDS terminated by ';'
IGNORE 1 Lines;

USE babynames;
LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\babynames\\OGDEXT_VORNAMEN_1_C-WOHNBEZIRK-0.csv' INTO TABLE wohnbezirke
CHARACTER SET utf8mb4
FIELDS terminated by ';'
IGNORE 1 Lines;

CREATE VIEW bezirk_with_bundesland_view AS
SELECT bezirk_id, bezirk_name, 
	CASE
		WHEN SUBSTRING(bezirk_id, 1, 1) IN ('1') THEN 'Burgenland'
        WHEN SUBSTRING(bezirk_id, 1, 1) IN ('2') THEN 'Kärnten'
        WHEN SUBSTRING(bezirk_id, 1, 1) IN ('3') THEN 'Niederösterreich'
        WHEN SUBSTRING(bezirk_id, 1, 1) IN ('4') THEN 'Oberösterreich'
        WHEN SUBSTRING(bezirk_id, 1, 1) IN ('5') THEN 'Salzburg'
        WHEN SUBSTRING(bezirk_id, 1, 1) IN ('6') THEN 'Steiermark'
        WHEN SUBSTRING(bezirk_id, 1, 1) IN ('7') THEN 'Tirol'
        WHEN SUBSTRING(bezirk_id, 1, 1) IN ('8') THEN 'Vorarlberg'
        WHEN SUBSTRING(bezirk_id, 1, 1) IN ('9') THEN 'Wien'
        ELSE 'Unknown Bundesland'
	END AS bundesland
FROM wohnbezirke;


CREATE VIEW vornamen_sum_view AS
SELECT Vorname, sum(Anzahl) AS Gesamtanzahl
FROM vornamen
GROUP BY Vorname;

CREATE VIEW vornamen_sum_2000 AS
SELECT Vorname, sum(Anzahl) AS Gesamtanzahl
FROM vornamen
WHERE jahr_id > 1999
GROUP BY Vorname;


CREATE TABLE vornamen_counts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Vorname VARCHAR(30),
    Anzahl INT
);

INSERT INTO vornamen_counts (Vorname, Anzahl)
SELECT Vorname, COUNT(*) AS Anzahl
FROM vornamen
GROUP BY Vorname;

CREATE VIEW vornamen_by_bundesland AS
SELECT
    v.vorname,
    w.bundesland,
    count(v.anzahl)
FROM vornamen v
LEFT JOIN
    bezirk_with_bundesland_view w ON v.bezirk_id = w.bezirk_id
GROUP BY v.vorname;

