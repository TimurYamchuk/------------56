-- ��� 0 �������� ��
use master
go

CREATE DATABASE BarberShopDB;
USE BarberShopDB;

-- ������� � ����������
CREATE TABLE Positions (
    PositionID INT IDENTITY PRIMARY KEY,
    PositionName NVARCHAR(100) NOT NULL
);

-- �������
CREATE TABLE Barbers (
    BarberID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(255) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    ContactPhone NVARCHAR(50),
    Email NVARCHAR(100),
    DateOfBirth DATE CHECK (DateOfBirth <= DATEADD(YEAR, -21, GETDATE())), -- �������� �� ������� ������ 21 ����
    HireDate DATE,
    PositionID INT FOREIGN KEY REFERENCES Positions(PositionID)
);

-- �������
CREATE TABLE Clients (
    ClientID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(255) NOT NULL,
    ContactPhone NVARCHAR(50),
    Email NVARCHAR(100)
);

-- ������
CREATE TABLE Services (
    ServiceID INT IDENTITY PRIMARY KEY,
    ServiceName NVARCHAR(255) NOT NULL,
    Price MONEY NOT NULL,
    DurationInMinutes INT NOT NULL
);

-- ������� ��������
CREATE TABLE ClientFeedbacks (
    FeedbackID INT IDENTITY PRIMARY KEY,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    Feedback NVARCHAR(MAX),
    Rating NVARCHAR(50) CHECK (Rating IN ('very_bad', 'bad', 'normal', 'good', 'excellent'))
);

-- ������� ��������
CREATE TABLE BarberFeedbacks (
    FeedbackID INT IDENTITY PRIMARY KEY,
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    Feedback NVARCHAR(MAX),
    Rating NVARCHAR(50) CHECK (Rating IN ('very_bad', 'bad', 'normal', 'good', 'excellent'))
);

-- ���������� ��������
CREATE TABLE BarberSchedule (
    ScheduleID INT IDENTITY PRIMARY KEY,
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    Date DATE NOT NULL,
    TimeFrom TIME NOT NULL,
    TimeTo TIME NOT NULL,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID)
);

-- ����� ���������
CREATE TABLE VisitsArchive (
    VisitID INT IDENTITY PRIMARY KEY,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    ServiceID INT FOREIGN KEY REFERENCES Services(ServiceID),
    VisitDate DATE NOT NULL,
    TotalCost MONEY,
    Rating NVARCHAR(50) CHECK (Rating IN ('very_bad', 'bad', 'normal', 'good', 'excellent')),
    Feedback NVARCHAR(MAX)
);

--��� 1 ��������� ������

-- ��������� �������
INSERT INTO Positions (PositionName) VALUES
('chief-barber'),
('senior-barber'),
('junior-barber'),
('stylist'),
('apprentice');

SELECT * FROM Positions

-- ��������� ��������
INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID) VALUES
('���� ������', 'M', '123-456-7890', 'ivanov@example.com', '1980-06-15', '2015-01-01', 1),
('������� �������', 'M', '234-567-8901', 'smirnov@example.com', '1990-07-20', '2016-02-01', 2),
('����� �������', 'F', '345-678-9012', 'petrova@example.com', '1985-08-25', '2017-03-01', 3),
('��������� ��������', 'F', '456-789-0123', 'sergeeva@example.com', '1983-09-30', '2018-04-01', 2),
('������� ������', 'M', '567-890-1234', 'volkov@example.com', '1995-05-05', '2019-05-01', 3);

SELECT * FROM Barbers

-- ��������� ��������
INSERT INTO Clients (FullName, ContactPhone, Email) VALUES
('������ ��������', '678-901-2345', 'kuznetsov@example.com'),
('����� ���������', '789-012-3456', 'vasilieva@example.com'),
('����� ��������', '890-123-4567', 'novikova@example.com'),
('������� ��������', '901-234-5678', 'morozova@example.com'),
('������ �����', '012-345-6789', 'belov@example.com');

SELECT * FROM Clients

-- ��������� ������
INSERT INTO Services (ServiceName, Price, DurationInMinutes) VALUES
('�������', 1500.00, 60),
('������ ������', 800.00, 30),
('�������', 2000.00, 120),
('�������', 1000.00, 40),
('����� ��� �����', 500.00, 30);

SELECT * FROM Services

-- ��������� ������� ��������
INSERT INTO ClientFeedbacks (ClientID, BarberID, Feedback, Rating) VALUES
(1, 1, '�������� �������!', 'excellent'),
(2, 2, '�������, �� ����� ���� � �����.', 'good'),
(3, 3, '� �������� �������� �������.', 'good'),
(4, 4, '�� ����� ���������.', 'normal'),
(5, 5, '�����������, ���� ������������� �������!', 'excellent');

SELECT * FROM ClientFeedbacks

-- ��������� ������� ��������
INSERT INTO BarberFeedbacks (BarberID, ClientID, Feedback, Rating) VALUES
(1, 1, '������������ ������.', 'good'),
(2, 2, '������������� ��������.', 'excellent'),
(3, 3, '���� ��������� ���������.', 'normal'),
(4, 4, '������ ���������.', 'bad'),
(5, 5, '��� ������ �������!', 'excellent');

SELECT * FROM BarberFeedbacks

-- ��������� ���������� ��������
INSERT INTO BarberSchedule (BarberID, Date, TimeFrom, TimeTo, ClientID) VALUES
(1, '2024-04-25', '09:00', '10:00', 1),
(2, '2024-04-25', '10:00', '11:00', 2),
(3, '2024-04-25', '11:00', '12:00', 3),
(4, '2024-04-25', '12:00', '13:00', 4),
(5, '2024-04-25', '13:00', '14:00', 5);

SELECT * FROM BarberSchedule

-- ��������� ����� ���������
INSERT INTO VisitsArchive (ClientID, BarberID, ServiceID, VisitDate, TotalCost, Rating, Feedback) VALUES
(1, 1, 1, '2023-01-15', 1500.00, 'excellent', '������� ������� � ������������.'),
(2, 2, 2, '2023-02-20', 800.00, 'good', '������ � �����������.'),
(3, 3, 3, '2023-03-25', 2000.00, 'normal', '���� �� ������ ���, ��� ��������.'),
(4, 4, 4, '2023-04-30', 1000.00, 'bad', '������� �� ��������.'),
(5, 5, 5, '2023-05-05', 500.00, 'excellent', '������ ����� ����� �����������.');

SELECT * FROM VisitsArchive

--��� 2 

--1. ������� ��� ���� �������� ������
CREATE FUNCTION dbo.GetAllBarbersNames()
RETURNS TABLE
AS
RETURN
    SELECT FullName
    FROM Barbers;
GO

SELECT * FROM dbo.GetAllBarbersNames();

--2. ������� ���������� � ���� ������-��������
CREATE PROCEDURE GetSeniorBarbersInfo
AS
BEGIN
    SELECT b.*
    FROM Barbers AS b
    INNER JOIN Positions AS p ON b.PositionID = p.PositionID
    WHERE p.PositionName = 'senior-barber';
END
GO

EXEC GetSeniorBarbersInfo;

--3. ������� ���������� � ���� ��������, ������� ����� ���-
--��������� ������ ������������� ������ ������
CREATE PROCEDURE dbo.GetBarbersByService
    @ServiceName NVARCHAR(255)
AS
BEGIN
    SELECT b.*
    FROM Barbers b
    INNER JOIN Services s ON b.PositionID = s.ServiceID
    WHERE s.ServiceName = @ServiceName;
END
GO

EXEC dbo.GetBarbersByService @ServiceName = '������ ������';

--4. ������� ���������� � ���� ��������, ������� ����� ���-
--��������� ���������� ������. ���������� � ���������
--������ ��������������� � �������� ���������

EXEC dbo.GetBarbersByService @ServiceName = '�������';

--5. ������� ���������� � ���� ��������, ������� ��������
--����� ���������� ���������� ���. ���������� ��� ������-
--���� � �������� ���������
CREATE PROCEDURE dbo.GetBarbersByYearsOfService
    @Years INT
AS
BEGIN
    SELECT *
    FROM Barbers
    WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > @Years;
END
GO

EXEC dbo.GetBarbersByYearsOfService @Years = 5;

--6. ������� ���������� ������-�������� � ���������� ���-
--����-��������
CREATE FUNCTION dbo.GetBarbersCountByPosition()
RETURNS @BarberCounts TABLE
(
    SeniorBarbersCount INT,
    JuniorBarbersCount INT
)
AS
BEGIN
    INSERT INTO @BarberCounts (SeniorBarbersCount, JuniorBarbersCount)
    SELECT
        (SELECT COUNT(*) FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'senior-barber')),
        (SELECT COUNT(*) FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'junior-barber'));
    
    RETURN;
END
GO

SELECT * FROM dbo.GetBarbersCountByPosition();

--7. ������� ���������� � ���������� ��������. ��������
--����������� �������: ��� � ������ �������� ����������
--���. ���������� ��������� � �������� ���������
CREATE PROCEDURE GetRegularClients
    @VisitThreshold INT
AS
BEGIN
    SELECT 
        c.ClientID, 
        c.FullName, 
        c.ContactPhone, 
        c.Email, 
        COUNT(v.VisitID) AS VisitCount
    FROM 
        Clients c
    JOIN 
        VisitsArchive v ON c.ClientID = v.ClientID
    GROUP BY 
        c.ClientID, 
        c.FullName, 
        c.ContactPhone, 
        c.Email
    HAVING 
        COUNT(v.VisitID) >= @VisitThreshold
END
GO

EXEC GetRegularClients @VisitThreshold = 1;

--8. ��������� ����������� �������� ���������� � ���-���-
--����, ���� �� �������� ������ ���-������
CREATE TRIGGER trg_PreventChiefBarberDeletion
ON Barbers
INSTEAD OF DELETE
AS
BEGIN
    IF (SELECT COUNT(*) FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'chief-barber')) <= 1
    BEGIN
        RAISERROR ('Cannot delete the only chief barber without having a replacement.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Barbers WHERE BarberID IN (SELECT BarberID FROM deleted);
    END
END
GO

DELETE FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'chief-barber');

--9. ��������� ��������� �������� ������ 21 ����.
CREATE TRIGGER trg_CheckBarberAge
ON Barbers
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 21)
    BEGIN
        RAISERROR ('Barbers must be at least 21 years old.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID)
        SELECT FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID FROM inserted;
    END
END
GO

INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID) 
VALUES ('������� ������', 'M', '987-654-3210', 'youngbarber@example.com', '2007-01-01', '2024-01-01', 1);

--����� 2
--������� 1
--1. ������� ���������� � �������, ������� �������� � ���������� ������ ����
CREATE FUNCTION dbo.GetMostExperiencedBarber()
RETURNS TABLE
AS
RETURN (
    SELECT TOP 1 *
    FROM Barbers
    ORDER BY HireDate ASC
);
GO

SELECT * FROM dbo.GetMostExperiencedBarber();

--2. ������� ���������� � �������, ������� �������� ������������ ���������� �������� � ���������
--��������� ���.
--���� ���������� � �������� ���������
CREATE PROCEDURE dbo.GetTopBarberByClientsInRange
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT TOP 1 b.*
    FROM Barbers b
    INNER JOIN VisitsArchive v ON b.BarberID = v.BarberID
    WHERE v.VisitDate BETWEEN @StartDate AND @EndDate
    GROUP BY b.BarberID, b.FullName, b.Gender, b.ContactPhone, b.Email, b.DateOfBirth, b.HireDate, b.PositionID
    ORDER BY COUNT(v.ClientID) DESC;
END
GO

EXEC dbo.GetTopBarberByClientsInRange @StartDate = '2023-01-01', @EndDate = '2023-12-31';

--3. ������� ���������� � �������, ������� ������� ��������� ������������ ���������� ���
CREATE PROCEDURE dbo.GetTopClientByVisits
AS
BEGIN
    SELECT TOP 1 c.*, COUNT(v.VisitID) AS NumberOfVisits
    FROM Clients c
    INNER JOIN VisitsArchive v ON c.ClientID = v.ClientID
    GROUP BY c.ClientID, c.FullName, c.ContactPhone, c.Email
    ORDER BY NumberOfVisits DESC;
END
GO

EXEC dbo.GetTopClientByVisits;

--4. ������� ���������� � �������, ������� �������� � ���������� ������������ ���������� �����
CREATE PROCEDURE dbo.GetTopClientBySpending
AS
BEGIN
    SELECT TOP 1 c.*, SUM(v.TotalCost) AS TotalSpent
    FROM Clients c
    INNER JOIN VisitsArchive v ON c.ClientID = v.ClientID
    GROUP BY c.ClientID, c.FullName, c.ContactPhone, c.Email
    ORDER BY TotalSpent DESC;
END
GO

EXEC dbo.GetTopClientBySpending;

--5. ������� ���������� � ����� ������� �� ������� ������
--� ����������
CREATE FUNCTION dbo.GetLongestService()
RETURNS TABLE
AS
RETURN (
    SELECT TOP 1 *
    FROM Services
    ORDER BY DurationInMinutes DESC
);
GO

SELECT * FROM dbo.GetLongestService();

--������� 2
--1. ������� ���������� � ����� ���������� ������� (��
--���������� ��������)
CREATE PROCEDURE GetMostPopularBarber AS
BEGIN
    SELECT TOP 1 b.*, COUNT(v.ClientID) as NumberOfClients
    FROM Barbers b
    JOIN VisitsArchive v ON b.BarberID = v.BarberID
    GROUP BY b.BarberID, b.FullName, b.Gender, b.ContactPhone, b.Email, b.DateOfBirth, b.HireDate, b.PositionID
    ORDER BY NumberOfClients DESC;
END;
GO

EXEC GetMostPopularBarber;
--2. ������� ���-3 �������� �� ����� (�� ����� �����, ����������� ���������)
CREATE PROCEDURE GetTopBarbersOfMonth AS
BEGIN
    SELECT TOP 3 b.*, SUM(v.TotalCost) as TotalEarned
    FROM Barbers b
    JOIN VisitsArchive v ON b.BarberID = v.BarberID
    WHERE v.VisitDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) 
    AND v.VisitDate < DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE()), 0)
    GROUP BY b.BarberID, b.FullName, b.Gender, b.ContactPhone, b.Email, b.DateOfBirth, b.HireDate, b.PositionID
    ORDER BY TotalEarned DESC;
END;
GO

EXEC GetTopBarbersOfMonth;

--3. ������� ���-3 �������� �� �� ����� (�� ������� ������).
--���������� ��������� �������� �� ������ 30
CREATE OR ALTER PROCEDURE GetTopBarbersAllTime AS
BEGIN
    SELECT TOP 3 b.*, AVG(CASE fb.Rating
                             WHEN 'excellent' THEN 5
                             WHEN 'good' THEN 4
                             WHEN 'normal' THEN 3
                             WHEN 'bad' THEN 2
                             WHEN 'very_bad' THEN 1
                             ELSE 0
                         END) AS AverageRating
    FROM Barbers b
    JOIN BarberFeedbacks fb ON b.BarberID = fb.BarberID
    GROUP BY b.BarberID, b.FullName, b.Gender, b.ContactPhone, b.Email, b.DateOfBirth, b.HireDate, b.PositionID
    HAVING COUNT(fb.FeedbackID) >= 30
    ORDER BY AverageRating DESC;
END;
GO

EXEC GetTopBarbersAllTime;

--4. �������� ���������� �� ���� ����������� �������. ���������� � ������� � ��� ��������� � �������� ���������
CREATE PROCEDURE GetBarberScheduleByDay
    @BarberID INT,
    @Date DATE
AS
BEGIN
    SELECT *
    FROM BarberSchedule
    WHERE BarberID = @BarberID AND Date = @Date;
END;
GO

EXEC GetBarberScheduleByDay @BarberID = 1, @Date = '2024-04-25';

--5. �������� ��������� ��������� ����� �� ������ ����������� �������. ���������� � ������� � ��� ���������
--� �������� ���������
CREATE FUNCTION GetFreeSlotsForBarber
    (@BarberID INT, @WeekStartDate DATE)
RETURNS @FreeSlots TABLE
    (Date DATE, TimeFrom TIME, TimeTo TIME)
AS
BEGIN
    
    INSERT INTO @FreeSlots (Date, TimeFrom, TimeTo)
    VALUES (@WeekStartDate, '09:00', '10:00'); 
    
    RETURN;
END;
GO

EXEC GetBarberScheduleByDay @BarberID = 1, @Date = '2024-04-25';

--6. ��������� � ����� ���������� � ���� ��� �����������
--������� (��� �� ������, ������� ��������� � �������)
CREATE TRIGGER ArchivePastServices
ON VisitsArchive
AFTER INSERT, UPDATE
AS
BEGIN
    INSERT INTO VisitsArchive (ClientID, BarberID, ServiceID, VisitDate, TotalCost, Rating, Feedback)
    SELECT ClientID, BarberID, ServiceID, VisitDate, TotalCost, Rating, Feedback
    FROM inserted
    WHERE VisitDate < GETDATE();
END;
GO


INSERT INTO VisitsArchive (ClientID, BarberID, ServiceID, VisitDate, TotalCost, Rating, Feedback)
VALUES (1, 1, 1, '2022-01-15', 1500.00, 'excellent', '������� ������� � ������������.');

SELECT * FROM VisitsArchive

--7. ��������� ���������� ������� � ������� �� ��� �������
--����� � ����
CREATE TRIGGER PreventDoubleBooking
ON BarberSchedule
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM BarberSchedule
        JOIN inserted ON BarberSchedule.BarberID = inserted.BarberID
        AND BarberSchedule.Date = inserted.Date
        AND BarberSchedule.TimeFrom = inserted.TimeFrom
        AND BarberSchedule.TimeTo = inserted.TimeTo
    )
    BEGIN
        RAISERROR('This time slot is already booked.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO BarberSchedule (BarberID, Date, TimeFrom, TimeTo, ClientID)
        SELECT BarberID, Date, TimeFrom, TimeTo, ClientID FROM inserted;
    END
END;
GO

INSERT INTO BarberSchedule (BarberID, Date, TimeFrom, TimeTo, ClientID) 
VALUES (1, '2024-04-26', '09:00', '10:00', 1);

SELECT * FROM BarberSchedule

--8. ��������� ���������� ������ �������-�������, ���� � ������ ��� �������� 5 �������-��������
DROP TRIGGER trg_PreventChiefBarberDeletion;
DROP TRIGGER trg_CheckBarberAge;

CREATE TRIGGER trg_BarberChecks
ON Barbers
INSTEAD OF INSERT
AS
BEGIN
    -- �������� �������� ��������
    IF EXISTS (SELECT * FROM inserted WHERE DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 21)
    BEGIN
        RAISERROR ('Barbers must be at least 21 years old.', 16, 1);
        RETURN;
    END

    -- �������� ���������� �������-��������
    IF (SELECT COUNT(*) FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'junior-barber')) >= 5
    BEGIN
        RAISERROR ('Cannot add more than 5 junior barbers.', 16, 1);
        RETURN;
    END

    -- ��������, ��� �� ��� ������� �� ��� ��������� ���-�������
    IF EXISTS (SELECT * FROM inserted WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'chief-barber')
               AND (SELECT COUNT(*) FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'chief-barber')) >= 1)
    BEGIN
        RAISERROR ('Cannot add more than one chief barber.', 16, 1);
        RETURN;
    END

    -- ������� ������
    INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID)
    SELECT FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID FROM inserted;
END;
GO

INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID) 
VALUES ('����� �������', 'M', '999-888-7777', 'junior@example.com', '2002-01-01', '2024-01-01', (SELECT PositionID FROM Positions WHERE PositionName = 'junior-barber'));

--9. ������� ���������� � ��������, ������� �� ���������
--�� ������ ������� � �� ����� ������
CREATE PROCEDURE GetClientsWithoutFeedbacks
AS
BEGIN
    SELECT *
    FROM Clients
    WHERE ClientID NOT IN (SELECT DISTINCT ClientID FROM ClientFeedbacks)
    AND ClientID NOT IN (SELECT DISTINCT ClientID FROM BarberFeedbacks);
END;
GO

INSERT INTO Clients (FullName, ContactPhone, Email) 
VALUES ('����� ������', '123-456-7890', 'newclient@example.com');

EXEC GetClientsWithoutFeedbacks;

--10.������� ���������� � ��������, ������� �� ��������
--��������� ����� ������ ����

CREATE PROCEDURE GetInactiveClients
AS
BEGIN
    SELECT *
    FROM Clients
    WHERE ClientID NOT IN (
        SELECT DISTINCT ClientID
        FROM VisitsArchive
        WHERE VisitDate >= DATEADD(YEAR, -1, GETDATE())
    );
END;
GO

EXEC GetInactiveClients;

