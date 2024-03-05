use MuseumDB


CREATE OR ALTER FUNCTION checkInt
(
    @n INT
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT;

    IF @n >= 0 AND @n <= 100
        SET @result = 1;
    ELSE
        SET @result = 0; 
    RETURN @result;
END;
go 




--DECLARE @result INT;
--SET @result = dbo.checkInt(10);
--SELECT @result AS Result;


CREATE OR ALTER FUNCTION checkFutureDate
(
    @inputDate DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT;

    IF @inputDate IS NOT NULL AND @inputDate >= CAST(GETDATE() AS DATE)
        SET @result = 1;
    ELSE
        SET @result = 0; 
    RETURN @result;
END;

--DECLARE @result INT;
--SET @result = dbo.checkFutureDate('2023-12-01');
--SELECT @result AS Result;


CREATE OR ALTER FUNCTION checkPastDate
(
    @inputDate DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT;

    IF @inputDate IS NOT NULL AND @inputDate < CAST(GETDATE() AS DATE)
        SET @result = 1;
    ELSE
        SET @result = 0; 
    RETURN @result;
END;

--DECLARE @result INT;
--SET @result = dbo.checkPastDate('2024-12-01');
--SELECT @result AS Result;



CREATE OR ALTER FUNCTION checkString
(
    @location NVARCHAR(255)
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT;

    IF @location IS NOT NULL AND @location LIKE '[A-Z]%'
        SET @result = 1;
    ELSE
        SET @result = 0;
    RETURN @result;
END;

--DECLARE @result INT;
--SET @result = dbo.checkString('Aasdsa')
--SELECT @result AS Result;



create or alter procedure addMuseum @name varchar(50), @location varchar(50), @foundation_date date output as
begin
	select * from museums
	if dbo.checkString(@name)=1 and dbo.checkString(@location)=1 and dbo.checkPastDate(@foundation_date)=1
	begin
		print 'gud'
		insert into museums ( Name, Location, FoundationDate) Values (@name, @location,@foundation_date)
		select * from Museums
	end
	else
	begin
		print'not gud'
	end
end
go
--id name location fundation_date
--exec addMuseum @name='Alabla',@location='sadasda' ,@foundation_date='2000-12-01'


create or alter procedure addMuseum @name varchar(50), @location varchar(50), @foundation_date date output as
begin
	select * from museums
	if dbo.checkString(@name)=1 and dbo.checkString(@location)=1 and dbo.checkPastDate(@foundation_date)=1
	begin
		print 'gud'
		insert into Museums ( Name, Location, FoundationDate) Values (@name, @location,@foundation_date)
		select * from Museums
	end
	else
	begin
		print'not gud'
	end
end
go

--id title start_date end_date type museumID
create or alter procedure addExhibition @title varchar(50), @start_date date, @end_date date, @type varchar(50), @id int output as
begin
	select * from Exhibitions
	if dbo.checkString(@title)=1 and dbo.checkFutureDate(@start_date)=1 and dbo.checkFutureDate(@end_date)=1 and dbo.checkInt(@id)=1
	begin
		print 'gud'
		insert into Exhibitions( Title, StartDate,EndDate,type, MuseumID) Values (@title, @start_date, @end_date, @type, @id)
		select * from Exhibitions
	end
	else
	begin
		print'not gud'
	end
end
go
--exec addExhibition @title='Alabla',@start_date='2033-12-01',@end_date='2034-12-01',@type='dsffs',@id=3

create view vAll
as
	SELECT m.museumID, e.Title, ea.ArtworkID, a.ArtistID
	from Museums m inner join Exhibitions e on e.ExhibitionID=m.MuseumID
	inner join ExhibitionArtworks ea on ea.ExhibitionID=m.MuseumID
	inner join Artists a on a.ArtistID=ea.ExhibitionID
go


-- Create a log table to store the trigger information
CREATE TABLE MuseumLog (
    LogID INT PRIMARY KEY IDENTITY,
    TriggerDateTime DATETIME,
    TriggerType VARCHAR(10),
    TableName VARCHAR(100),
    RecordsAffected INT
);

-- Create a trigger for INSERT, UPDATE, or DELETE operations on the Museums table
CREATE TRIGGER MuseumTrigger
ON Museums
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @TriggerDateTime DATETIME = GETDATE();
    DECLARE @TriggerType VARCHAR(10);
    DECLARE @TableName VARCHAR(100) = 'Museums';
    DECLARE @RecordsAffected INT;

    -- Determine the trigger type
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @TriggerType = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @TriggerType = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @TriggerType = 'DELETE';

    -- Get the number of records affected
    SELECT @RecordsAffected = COUNT(*) FROM inserted;

    -- Insert the log information into the MuseumLog table
    INSERT INTO MuseumLog (TriggerDateTime, TriggerType, TableName, RecordsAffected)
    VALUES (@TriggerDateTime, @TriggerType, @TableName, @RecordsAffected);
END;


-- Insert a record into the Museums table
INSERT INTO Museums (Name, Location, FoundationDate)
VALUES ('National Museum', 'City Center', '2023-01-01');

-- Check the content of the Museums table
SELECT * FROM Museums;

-- Check the content of the MuseumLog table (to see the trigger log)
SELECT * FROM MuseumLog;SELECT *
INTO MuseumCopy
FROM Museums;--Clustered Index Scan on Museums TableSELECT * FROM MuseumCopy WHERE Location LIKE 'City%';

--Nonclustered Index Seek on Artists Table
SELECT * FROM Artists WHERE Nationality = 'Dutch';

SELECT *
INTO ManagersCopy
FROM Managers;
-- Clustered index seek and key lookup on Managers table
SELECT Name, Experience FROM ManagersCopy WHERE ManagerID = 1;

-- Nonclustered index scan with order by on Exhibitions table
SELECT * FROM Exhibitions WHERE StartDate >= '2023-01-01' ORDER BY Type DESC;

