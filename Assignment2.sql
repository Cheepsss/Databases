use MuseumDB
go


--INSERT
INSERT INTO Museums (Name, Location, FoundationDate)
VALUES ('National Museum', 'City Center', '1920-01-01'),
       ('Modern Art Museum', 'Art District', '1985-05-10'),
       ('History Museum', 'Downtown', '1950-08-20');


INSERT INTO Managers (Name, Experience, MuseumID)
VALUES ('John Manager', 10, 1),
       ('Alice Director', 15, 2),
       ('Bob Curator', 8, 3);

INSERT INTO Visitors (Name, Age, MembershipStatus) VALUES
('John Doe', 30, 'Regular'),
('John Manager', 25, 'Premium'),
('Bob Curator', 18, 'Regular');

INSERT INTO Artists (Name, Nationality, BirthDate, DeathDate)
VALUES ('Leonardo da Vinci', 'Italian', '1452-04-15', '1519-05-02'),
       ('Frida Kahlo', 'Mexican', '1907-07-06', '1954-07-13'),
       ('Vincent van Gogh', 'Dutch', '1853-03-30', '1890-07-29');


INSERT INTO Artworks (Title, CreationDate, Medium, ArtistID)
VALUES ('Mona Lisa', '1503-01-01', 'Oil on canvas', 1),
       ('The Two Fridas', '1939-01-01', 'Oil on canvas', 2),
       ('Starry Night', '1889-01-01', 'Oil on canvas', 3),
	       ('The Birth of Venus', '1484-01-01', 'Tempera on canvas', 2),
    ('American Gothic', '1930-01-01', 'Oil on beaverboard', 3),
    ('The Starry Night', '1889-01-01', 'Oil on canvas', 1),
    ('The Night Watch', '1642-01-01', 'Oil on canvas', 2),
    ('Les Demoiselles d''Avignon', '1907-01-01', 'Oil on canvas', 3),
    ('The Last Supper', '1498-01-01', 'Tempera on gesso, pitch, and mastic', 1),
    ('The Persistence of Memory', '1931-01-01', 'Oil on canvas', 2),
    ('Water Lilies', '1916-01-01', 'Oil on canvas', 3),
    ('The Birth of Venus', '1484-01-01', 'Tempera on canvas', 1),
    ('American Gothic', '1930-01-01', 'Oil on beaverboard', 2),
    ('The Starry Night', '1889-01-01', 'Oil on canvas', 3),
    ('The Last Supper', '1498-01-01', 'Tempera on gesso, pitch, and mastic', 1),
    ('Water Lilies', '1916-01-01', 'Oil on canvas', 2);

--UDPATE  LIKE =
UPDATE Managers SET Experience = 12 WHERE ManagerID = 1 OR Name LIKE 'John%';
--DELETE IS NOT NULL
INSERT INTO Artists (Name, Nationality, BirthDate, DeathDate)
VALUES ('Leonardo da Vinci', 'test', '1452-04-15', '1519-05-02');
DELETE FROM Artists WHERE Nationality = 'test' AND DeathDate IS NOT NULL;

--DELETE BETWEEN
DELETE FROM Visitors WHERE Age BETWEEN 25 AND 30;
INSERT INTO Visitors (Name, Age, MembershipStatus)
VALUES ('Alice Smith', 30, 'Member'),
('John Doe', 30, 'Regular'),
('John Manager', 25, 'Premium');


--------------------------------------------------------------------------
--SELECT
SELECT Name from Artists UNION SELECT Title from Artworks;
SELECT Name FROM Visitors INTERSECT SELECT Name FROM Managers;
SELECT Name FROM Visitors EXCEPT SELECT Name FROM Managers;


INSERT INTO Artists (Name, Nationality, BirthDate, DeathDate) VALUES
('FOR TEST JOIN', 'Italian', '1452-04-15', '1519-05-02');
INSERT INTO Artworks (Title, CreationDate, Medium, ArtistID)
VALUES ('FOR TEST JOIN2', '1503-01-01', 'Oil on canvas', 1);
SELECT Artists.Name, Artworks.Title FROM Artists INNER JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID;
SELECT Artists.Name, Artworks.Title FROM Artists LEFT JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID;
SELECT Artists.Name, Artworks.Title FROM Artists RIGHT JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID;
SELECT Artists.Name, Artworks.Title FROM Artists FULL JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID;

--pt distinct
SELECT DISTINCT Name FROM (SELECT Artists.Name, Artworks.Title FROM Artists FULL JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID) AS s;
--PT TOP
SELECT TOP 3 Name FROM (SELECT Artists.Name, Artworks.Title FROM Artists FULL JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID) AS s;
--pt 3 table join	
SELECT * FROM (SELECT Artists.Name, Artworks.Title FROM Artists FULL JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID) As S JOIN Museums ON 1=1;

--in + exists----------------------------------
SELECT Name FROM Visitors WHERE Name IN (SELECT Name FROM Managers WHERE ManagerID < 10);
INSERT INTO Artists (Name, Nationality, BirthDate, DeathDate)
VALUES ('This shouldnt show', 'Dutch', '1853-03-30', '1890-07-29');
SELECT Name FROM Artists A WHERE EXISTS (SELECT ArtworkID FROM Artworks where ArtworkID = A.ArtistID);


SELECT AVG(Age) AS AvgAge FROM (SELECT Age FROM Visitors) AS Subquery;

--extra valori
INSERT INTO Tickets (TicketPrice) VALUES
(20),
(30),
(15);
INSERT INTO VisitorMuseums (VisitorID, MuseumID) VALUES
(3, 1),
(5, 2), 
(6, 3);
INSERT INTO VisitorTickets (VisitorID, TicketID) VALUES
(3, 1),
(5, 2),
(6, 3);


INSERT INTO Artworks (Title, CreationDate, Medium, ArtistID)
VALUES ('EXTRA', '1503-01-01', 'Oil on canvas', 1);
SELECT * FROM VisitorTickets;
INSERT INTO VisitorTickets (VisitorID, TicketID) VALUES
(3, 2);
INSERT INTO VisitorTickets (VisitorID, TicketID) VALUES
(3, 3);

SELECT COUNT(ArtistID)  FROM Artworks GROUP BY ArtistID ORDER BY COUNT(ArtistID);

SELECT * FROM VISITORS;

--grupeaza toti vizitatorii in functie de numarul de bilete
SELECT Name,COUNT(Name) AS Tickests FROM 
(SELECT Visitors.Name FROM Visitors INNER JOIN VisitorTickets ON Visitors.VisitorID = VisitorTickets.VisitorID) As Subq
GROUP BY Name
;


SELECT Name,COUNT(Name) AS Tickests FROM 
(SELECT Visitors.Name FROM Visitors INNER JOIN VisitorTickets ON Visitors.VisitorID = VisitorTickets.VisitorID) As Subq
GROUP BY Name
;

INSERT INTO Artworks (Title, CreationDate, Medium, ArtistID)
VALUES ('Mona Lisa', '1503-01-01', 'Oil on canvas', 1),
       ('The Two Fridas', '1939-01-01', 'Oil on canvas', 2),
       ('Starry Night', '1889-01-01', 'Oil on canvas', 3);

SELECT * FROM ARTWORKS;
INSERT INTO Exhibitions (Title, StartDate, EndDate, Type, MuseumID)
VALUES ('Revolution of Colors', '2023-03-15', '2023-04-15', 'Modern Art', 1);

INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID)
VALUES
    (1, 1), 
    (1, 2),
    (1, 3);


INSERT INTO Exhibitions (Title, StartDate, EndDate, Type, MuseumID)
VALUES ('Timeless Elegance', '2023-05-01', '2023-06-01', 'Renaissance', 2);

INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID)
VALUES
    (2, 4), 
    (2, 5), 
    (2, 6);

INSERT INTO Exhibitions (Title, StartDate, EndDate, Type, MuseumID)
VALUES ('Eternal Forms', '2023-07-10', '2023-08-10', 'Sculpture', 3);
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID)
VALUES
    (3, 7), 
    (3, 8), 
    (3, 9); 


-- Retrieve the number of artworks in each exhibition
SELECT
    E.ExhibitionID,
    E.Title AS ExhibitionTitle,
    COUNT(EA.ArtworkID) AS NumberOfArtworks
FROM
    Exhibitions E
JOIN
    ExhibitionArtworks EA ON E.ExhibitionID = EA.ExhibitionID
GROUP BY
    E.ExhibitionID, E.Title
ORDER BY
    E.ExhibitionID;

