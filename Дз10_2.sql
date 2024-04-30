-- Шаг 0 создание Бд
use master
go

CREATE DATABASE BarberShopDB;
USE BarberShopDB;

-- Позиции в барбершопе
CREATE TABLE Positions (
    PositionID INT IDENTITY PRIMARY KEY,
    PositionName NVARCHAR(100) NOT NULL
);

-- Барберы
CREATE TABLE Barbers (
    BarberID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(255) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    ContactPhone NVARCHAR(50),
    Email NVARCHAR(100),
    DateOfBirth DATE CHECK (DateOfBirth <= DATEADD(YEAR, -21, GETDATE())), -- Проверка на возраст старше 21 года
    HireDate DATE,
    PositionID INT FOREIGN KEY REFERENCES Positions(PositionID)
);

-- Клиенты
CREATE TABLE Clients (
    ClientID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(255) NOT NULL,
    ContactPhone NVARCHAR(50),
    Email NVARCHAR(100)
);

-- Услуги
CREATE TABLE Services (
    ServiceID INT IDENTITY PRIMARY KEY,
    ServiceName NVARCHAR(255) NOT NULL,
    Price MONEY NOT NULL,
    DurationInMinutes INT NOT NULL
);

-- Фидбеки клиентов
CREATE TABLE ClientFeedbacks (
    FeedbackID INT IDENTITY PRIMARY KEY,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    Feedback NVARCHAR(MAX),
    Rating NVARCHAR(50) CHECK (Rating IN ('very_bad', 'bad', 'normal', 'good', 'excellent'))
);

-- Фидбеки барберов
CREATE TABLE BarberFeedbacks (
    FeedbackID INT IDENTITY PRIMARY KEY,
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    Feedback NVARCHAR(MAX),
    Rating NVARCHAR(50) CHECK (Rating IN ('very_bad', 'bad', 'normal', 'good', 'excellent'))
);

-- Расписание барберов
CREATE TABLE BarberSchedule (
    ScheduleID INT IDENTITY PRIMARY KEY,
    BarberID INT FOREIGN KEY REFERENCES Barbers(BarberID),
    Date DATE NOT NULL,
    TimeFrom TIME NOT NULL,
    TimeTo TIME NOT NULL,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID)
);

-- Архив посещений
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

--Шаг 1 Заполняем данные

-- Заполняем позиции
INSERT INTO Positions (PositionName) VALUES
('chief-barber'),
('senior-barber'),
('junior-barber'),
('stylist'),
('apprentice');

SELECT * FROM Positions

-- Заполняем барберов
INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID) VALUES
('Иван Иванов', 'M', '123-456-7890', 'ivanov@example.com', '1980-06-15', '2015-01-01', 1),
('Алексей Смирнов', 'M', '234-567-8901', 'smirnov@example.com', '1990-07-20', '2016-02-01', 2),
('Мария Петрова', 'F', '345-678-9012', 'petrova@example.com', '1985-08-25', '2017-03-01', 3),
('Екатерина Сергеева', 'F', '456-789-0123', 'sergeeva@example.com', '1983-09-30', '2018-04-01', 2),
('Дмитрий Волков', 'M', '567-890-1234', 'volkov@example.com', '1995-05-05', '2019-05-01', 3);

SELECT * FROM Barbers

-- Заполняем клиентов
INSERT INTO Clients (FullName, ContactPhone, Email) VALUES
('Сергей Кузнецов', '678-901-2345', 'kuznetsov@example.com'),
('Елена Васильева', '789-012-3456', 'vasilieva@example.com'),
('Ольга Новикова', '890-123-4567', 'novikova@example.com'),
('Татьяна Морозова', '901-234-5678', 'morozova@example.com'),
('Андрей Белов', '012-345-6789', 'belov@example.com');

SELECT * FROM Clients

-- Заполняем услуги
INSERT INTO Services (ServiceName, Price, DurationInMinutes) VALUES
('Стрижка', 1500.00, 60),
('Бритьё бороды', 800.00, 30),
('Окраска', 2000.00, 120),
('Укладка', 1000.00, 40),
('Маска для волос', 500.00, 30);

SELECT * FROM Services

-- Заполняем фидбеки клиентов
INSERT INTO ClientFeedbacks (ClientID, BarberID, Feedback, Rating) VALUES
(1, 1, 'Отличная стрижка!', 'excellent'),
(2, 2, 'Неплохо, но могло быть и лучше.', 'good'),
(3, 3, 'Я осталась довольна услугой.', 'good'),
(4, 4, 'Не очень аккуратно.', 'normal'),
(5, 5, 'Великолепно, буду рекомендовать друзьям!', 'excellent');

SELECT * FROM ClientFeedbacks

-- Заполняем фидбеки барберов
INSERT INTO BarberFeedbacks (BarberID, ClientID, Feedback, Rating) VALUES
(1, 1, 'Пунктуальный клиент.', 'good'),
(2, 2, 'Замечательный разговор.', 'excellent'),
(3, 3, 'Были небольшие замечания.', 'normal'),
(4, 4, 'Клиент недоволен.', 'bad'),
(5, 5, 'Все прошло отлично!', 'excellent');

SELECT * FROM BarberFeedbacks

-- Заполняем расписание барберов
INSERT INTO BarberSchedule (BarberID, Date, TimeFrom, TimeTo, ClientID) VALUES
(1, '2024-04-25', '09:00', '10:00', 1),
(2, '2024-04-25', '10:00', '11:00', 2),
(3, '2024-04-25', '11:00', '12:00', 3),
(4, '2024-04-25', '12:00', '13:00', 4),
(5, '2024-04-25', '13:00', '14:00', 5);

SELECT * FROM BarberSchedule

-- Заполняем архив посещений
INSERT INTO VisitsArchive (ClientID, BarberID, ServiceID, VisitDate, TotalCost, Rating, Feedback) VALUES
(1, 1, 1, '2023-01-15', 1500.00, 'excellent', 'Хорошая стрижка и обслуживание.'),
(2, 2, 2, '2023-02-20', 800.00, 'good', 'Быстро и качественно.'),
(3, 3, 3, '2023-03-25', 2000.00, 'normal', 'Цвет не совсем тот, что хотелось.'),
(4, 4, 4, '2023-04-30', 1000.00, 'bad', 'Укладка не держится.'),
(5, 5, 5, '2023-05-05', 500.00, 'excellent', 'Волосы после маски шелковистые.');

SELECT * FROM VisitsArchive

--Шаг 2 

--1. Вернуть ФИО всех барберов салона
CREATE FUNCTION dbo.GetAllBarbersNames()
RETURNS TABLE
AS
RETURN
    SELECT FullName
    FROM Barbers;
GO

SELECT * FROM dbo.GetAllBarbersNames();

--2. Вернуть информацию о всех синьор-барберах
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

--3. Вернуть информацию о всех барберах, которые могут пре-
--доставить услугу традиционного бритья бороды
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

EXEC dbo.GetBarbersByService @ServiceName = 'Бритьё бороды';

--4. Вернуть информацию о всех барберах, которые могут пре-
--доставить конкретную услугу. Информация о требуемой
--услуге предоставляется в качестве параметра

EXEC dbo.GetBarbersByService @ServiceName = 'Стрижка';

--5. Вернуть информацию о всех барберах, которые работают
--свыше указанного количества лет. Количество лет переда-
--ётся в качестве параметра
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

--6. Вернуть количество синьор-барберов и количество джу-
--ниор-барберов
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

--7. Вернуть информацию о постоянных клиентах. Критерий
--постоянного клиента: был в салоне заданное количество
--раз. Количество передаётся в качестве параметра
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

--8. Запретить возможность удаления информации о чиф-бар-
--бере, если не добавлен второй чиф-барбер
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

--9. Запретить добавлять барберов младше 21 года.
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
VALUES ('Молодой Барбер', 'M', '987-654-3210', 'youngbarber@example.com', '2007-01-01', '2024-01-01', 1);

--ЧАСТЬ 2
--Задание 1
--1. Вернуть информацию о барбере, который работает в барбершопе дольше всех
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

--2. Вернуть информацию о барбере, который обслужил максимальное количество клиентов в указанном
--диапазоне дат.
--Даты передаются в качестве параметра
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

--3. Вернуть информацию о клиенте, который посетил барбершоп максимальное количество раз
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

--4. Вернуть информацию о клиенте, который потратил в барбершопе максимальное количество денег
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

--5. Вернуть информацию о самой длинной по времени услуге
--в барбершопе
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

--Задание 2
--1. Вернуть информацию о самом популярном барбере (по
--количеству клиентов)
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
--2. Вернуть топ-3 барберов за месяц (по сумме денег, потраченной клиентами)
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

--3. Вернуть топ-3 барберов за всё время (по средней оценке).
--Количество посещений клиентов не меньше 30
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

--4. Показать расписание на день конкретного барбера. Информация о барбере и дне передаётся в качестве параметра
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

--5. Показать свободные временные слоты на неделю конкретного барбера. Информация о барбере и дне передаётся
--в качестве параметра
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

--6. Перенести в архив информацию о всех уже завершенных
--услугах (это те услуги, которые произошли в прошлом)
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
VALUES (1, 1, 1, '2022-01-15', 1500.00, 'excellent', 'Хорошая стрижка и обслуживание.');

SELECT * FROM VisitsArchive

--7. Запретить записывать клиента к барберу на уже занятое
--время и дату
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

--8. Запретить добавление нового джуниор-барбера, если в салоне уже работают 5 джуниор-барберов
DROP TRIGGER trg_PreventChiefBarberDeletion;
DROP TRIGGER trg_CheckBarberAge;

CREATE TRIGGER trg_BarberChecks
ON Barbers
INSTEAD OF INSERT
AS
BEGIN
    -- Проверка возраста барберов
    IF EXISTS (SELECT * FROM inserted WHERE DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 21)
    BEGIN
        RAISERROR ('Barbers must be at least 21 years old.', 16, 1);
        RETURN;
    END

    -- Проверка количества джуниор-барберов
    IF (SELECT COUNT(*) FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'junior-barber')) >= 5
    BEGIN
        RAISERROR ('Cannot add more than 5 junior barbers.', 16, 1);
        RETURN;
    END

    -- Проверка, нет ли уже барбера на эту должность чиф-барбера
    IF EXISTS (SELECT * FROM inserted WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'chief-barber')
               AND (SELECT COUNT(*) FROM Barbers WHERE PositionID = (SELECT PositionID FROM Positions WHERE PositionName = 'chief-barber')) >= 1)
    BEGIN
        RAISERROR ('Cannot add more than one chief barber.', 16, 1);
        RETURN;
    END

    -- Вставка данных
    INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID)
    SELECT FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID FROM inserted;
END;
GO

INSERT INTO Barbers (FullName, Gender, ContactPhone, Email, DateOfBirth, HireDate, PositionID) 
VALUES ('Новый Джуниор', 'M', '999-888-7777', 'junior@example.com', '2002-01-01', '2024-01-01', (SELECT PositionID FROM Positions WHERE PositionName = 'junior-barber'));

--9. Вернуть информацию о клиентах, которые не поставили
--ни одного фидбека и ни одной оценки
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
VALUES ('Новый Клиент', '123-456-7890', 'newclient@example.com');

EXEC GetClientsWithoutFeedbacks;

--10.Вернуть информацию о клиентах, которые не посещали
--барбершоп свыше одного года

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

