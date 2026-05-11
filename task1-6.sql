USE master;
GO 

IF EXISTS (SELECT 1 FROM SYS.DATABASES WHERE NAME = 'FestivalGraph')
    BEGIN  
        ALTER DATABASE FestivalGraph SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        DROP DATABASE FestivalGraph;
    END;
GO
    
CREATE DATABASE FestivalGraph;
GO

USE FestivalGraph;
GO 

CREATE TABLE [Stage]
(
    [StageID] Int NOT NULL,
    [StageName] Nvarchar(100) NOT NULL,
    [Capacity] Int NOT NULL,
    CONSTRAINT [PK_Stage] PRIMARY KEY ([StageID]),
    CONSTRAINT [UQ_Stage_StageName] UNIQUE ([StageName])
) AS NODE;
GO

CREATE TABLE [Band]
(
    [BandID] Int NOT NULL,
    [BandName] Nvarchar(100) NOT NULL,
    [Genre] Nvarchar(50) NOT NULL,
    CONSTRAINT [PK_Band] PRIMARY KEY ([BandID]),
    CONSTRAINT [UQ_Band_BandName] UNIQUE ([BandName])
) AS NODE;
GO

CREATE TABLE [TechStaff]
(
    [TechStaffID] Int NOT NULL,
    [FullName] Nvarchar(100) NOT NULL,
    [PositionName] Nvarchar(100) NOT NULL,
    CONSTRAINT [PK_TechStaff] PRIMARY KEY ([TechStaffID])
) AS NODE;
GO

CREATE TABLE [PerformsOn]
(
    [PerformanceDate] Date NOT NULL,
    [StartTime] Time NOT NULL,
    [StatusName] Nvarchar(30) NOT NULL,
    CONSTRAINT [EC_PerformsOn] CONNECTION ([Band] TO [Stage])
) AS EDGE;
GO

CREATE TABLE [AssignedToStage]
(
    [WorkDate] Date NOT NULL,
    [ShiftName] Nvarchar(30) NOT NULL,
    [Responsibility] Nvarchar(100) NOT NULL,
    CONSTRAINT [EC_AssignedToStage] CONNECTION ([TechStaff] TO [Stage])
) AS EDGE;
GO

CREATE TABLE [SupportsBand]
(
    [SupportDate] Date NOT NULL,
    [TaskName] Nvarchar(100) NOT NULL,
    [StatusName] Nvarchar(30) NOT NULL,
    CONSTRAINT [EC_SupportsBand] CONNECTION ([TechStaff] TO [Band])
) AS EDGE;
GO

CREATE TABLE [FollowsAfter]
(
    [PerformanceDate] Date NOT NULL,
    [GapMinutes] Int NOT NULL,
    CONSTRAINT [EC_FollowsAfter] CONNECTION ([Band] TO [Band])
) AS EDGE;
GO

-- 3. Заполнение таблиц узлов

INSERT INTO [Stage] ([StageID], [StageName], [Capacity])
VALUES (1, N'Минск-Арена', 15000),
       (2, N'Стадион «Динамо»', 22000),
       (3, N'Чижовка-Арена', 9000),
       (4, N'Дворец спорта', 4500),
       (5, N'Дворец Республики', 2700),
       (6, N'Prime Hall', 1240),
       (7, N'КЗ «Минск»', 1300),
       (8, N'Falcon Club', 2000),
       (9, N'Re:Public', 1200),
       (10, N'Event Space', 1800);
GO

SELECT *
FROM [Stage];
GO

INSERT INTO [Band] ([BandID], [BandName], [Genre])
VALUES (1, N'Александр Солодуха', N'поп'),
       (2, N'Песняры', N'фолк-рок'),
       (3, N'Naviband', N'инди-поп'),
       (4, N'Леприконсы', N'рок'),
       (5, N'Макс Корж', N'хип-хоп'),
       (6, N'Сябры', N'эстрада'),
       (7, N'Андрей Катиков', N'шансон'),
       (8, N'Molchat Doma', N'пост-панк'),
       (9, N'Voskresenskii', N'рэп'),
       (10, N'ЛСП', N'хип-хоп');
GO

SELECT *
FROM [Band];
GO

INSERT INTO [TechStaff] ([TechStaffID], [FullName], [PositionName])
VALUES (1, N'Алексей Иванов', N'звукорежиссёр'),
       (2, N'Анна Соколова', N'специалист по видеосопровождению'),
       (3, N'Кирилл Петров', N'светорежиссёр'),
       (4, N'Константин Орлов', N'техник по оборудованию'),
       (5, N'Ольга Морозова', N'техник по звуку'),
       (6, N'Дмитрий Жуков', N'техник по оборудованию'),
       (7, N'Павел Климов', N'инженер по звуку'),
       (8, N'Марина Белова', N'видеооператор'),
       (9, N'Светлана Романова', N'координатор технической смены'),
       (10, N'Юрий Савельев', N'инженер сцены');
GO

SELECT *
FROM [TechStaff];
GO

-- 4. Заполнение таблиц ребер


INSERT INTO [PerformsOn] ($from_id, $to_id, [PerformanceDate], [StartTime], [StatusName]) VALUES
((SELECT $node_id FROM [Band] WHERE [BandID] = 1), (SELECT $node_id FROM [Stage] WHERE [StageID] = 1), '2025-07-12', '18:00', N'подтверждено'),
((SELECT $node_id FROM [Band] WHERE [BandID] = 2), (SELECT $node_id FROM [Stage] WHERE [StageID] = 2), '2025-07-12', '19:00', N'подтверждено'),
((SELECT $node_id FROM [Band] WHERE [BandID] = 3), (SELECT $node_id FROM [Stage] WHERE [StageID] = 6), '2025-07-12', '20:00', N'подтверждено'),
((SELECT $node_id FROM [Band] WHERE [BandID] = 4), (SELECT $node_id FROM [Stage] WHERE [StageID] = 7), '2025-07-12', '17:30', N'подтверждено'),
((SELECT $node_id FROM [Band] WHERE [BandID] = 5), (SELECT $node_id FROM [Stage] WHERE [StageID] = 1), '2025-07-12', '21:00', N'подтверждено'),
((SELECT $node_id FROM [Band] WHERE [BandID] = 6), (SELECT $node_id FROM [Stage] WHERE [StageID] = 3), '2025-07-12', '16:00', N'подтверждено'),
((SELECT $node_id FROM [Band] WHERE [BandID] = 7), (SELECT $node_id FROM [Stage] WHERE [StageID] = 4), '2025-07-12', '15:30', N'подтверждено'),
((SELECT $node_id FROM [Band] WHERE [BandID] = 8), (SELECT $node_id FROM [Stage] WHERE [StageID] = 8), '2025-07-12', '22:00', N'подтверждено'),
((SELECT $node_id FROM [Band] WHERE [BandID] = 9), (SELECT $node_id FROM [Stage] WHERE [StageID] = 9), '2025-07-12', '23:00', N'подтверждено'),
((SELECT $node_id FROM [Band] WHERE [BandID] = 10), (SELECT $node_id FROM [Stage] WHERE [StageID] = 10), '2025-07-12', '20:30', N'подтверждено');
GO

INSERT INTO [AssignedToStage] ($from_id, $to_id, [WorkDate], [ShiftName], [Responsibility]) VALUES
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 1), (SELECT $node_id FROM [Stage] WHERE [StageID] = 1), '2025-07-12', N'дневная', N'звук'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 2), (SELECT $node_id FROM [Stage] WHERE [StageID] = 1), '2025-07-12', N'дневная', N'видео'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 3), (SELECT $node_id FROM [Stage] WHERE [StageID] = 2), '2025-07-12', N'вечерняя', N'свет'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 4), (SELECT $node_id FROM [Stage] WHERE [StageID] = 3), '2025-07-12', N'дневная', N'оборудование'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 5), (SELECT $node_id FROM [Stage] WHERE [StageID] = 4), '2025-07-12', N'дневная', N'звук'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 6), (SELECT $node_id FROM [Stage] WHERE [StageID] = 5), '2025-07-12', N'вечерняя', N'оборудование'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 7), (SELECT $node_id FROM [Stage] WHERE [StageID] = 6), '2025-07-12', N'вечерняя', N'звук'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 8), (SELECT $node_id FROM [Stage] WHERE [StageID] = 7), '2025-07-12', N'дневная', N'видеосопровождение'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 9), (SELECT $node_id FROM [Stage] WHERE [StageID] = 8), '2025-07-12', N'вечерняя', N'координация'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 10), (SELECT $node_id FROM [Stage] WHERE [StageID] = 9), '2025-07-12', N'вечерняя', N'инженерное сопровождение');
GO

INSERT INTO [SupportsBand] ($from_id, $to_id, [SupportDate], [TaskName], [StatusName]) VALUES
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 1), (SELECT $node_id FROM [Band] WHERE [BandID] = 1), '2025-07-12', N'настройка звука', N'выполнено'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 2), (SELECT $node_id FROM [Band] WHERE [BandID] = 3), '2025-07-12', N'видеосопровождение', N'выполнено'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 3), (SELECT $node_id FROM [Band] WHERE [BandID] = 2), '2025-07-12', N'настройка света', N'выполнено'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 4), (SELECT $node_id FROM [Band] WHERE [BandID] = 5), '2025-07-12', N'подключение оборудования', N'выполнено'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 5), (SELECT $node_id FROM [Band] WHERE [BandID] = 4), '2025-07-12', N'контроль звука', N'выполнено'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 6), (SELECT $node_id FROM [Band] WHERE [BandID] = 6), '2025-07-12', N'монтаж оборудования', N'выполнено'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 7), (SELECT $node_id FROM [Band] WHERE [BandID] = 7), '2025-07-12', N'саундчек', N'выполнено'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 8), (SELECT $node_id FROM [Band] WHERE [BandID] = 8), '2025-07-12', N'видеозапись выступления', N'выполнено'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 9), (SELECT $node_id FROM [Band] WHERE [BandID] = 9), '2025-07-12', N'координация выхода на сцену', N'выполнено'),
((SELECT $node_id FROM [TechStaff] WHERE [TechStaffID] = 10), (SELECT $node_id FROM [Band] WHERE [BandID] = 10), '2025-07-12', N'техническая проверка сцены', N'выполнено');
GO

INSERT INTO [FollowsAfter] ($from_id, $to_id, [PerformanceDate], [GapMinutes]) VALUES
((SELECT $node_id FROM [Band] WHERE [BandID] = 1), (SELECT $node_id FROM [Band] WHERE [BandID] = 2), '2025-07-12', 20),
((SELECT $node_id FROM [Band] WHERE [BandID] = 2), (SELECT $node_id FROM [Band] WHERE [BandID] = 6), '2025-07-12', 15),
((SELECT $node_id FROM [Band] WHERE [BandID] = 3), (SELECT $node_id FROM [Band] WHERE [BandID] = 8), '2025-07-12', 20),
((SELECT $node_id FROM [Band] WHERE [BandID] = 8), (SELECT $node_id FROM [Band] WHERE [BandID] = 10), '2025-07-12', 25),
((SELECT $node_id FROM [Band] WHERE [BandID] = 4), (SELECT $node_id FROM [Band] WHERE [BandID] = 7), '2025-07-12', 15),
((SELECT $node_id FROM [Band] WHERE [BandID] = 7), (SELECT $node_id FROM [Band] WHERE [BandID] = 9), '2025-07-12', 20),
((SELECT $node_id FROM [Band] WHERE [BandID] = 5), (SELECT $node_id FROM [Band] WHERE [BandID] = 3), '2025-07-12', 30),
((SELECT $node_id FROM [Band] WHERE [BandID] = 6), (SELECT $node_id FROM [Band] WHERE [BandID] = 4), '2025-07-12', 10);
GO

-- 5. Запросы с использованием MATCH

-- Какие сотрудники обслуживают группы, выступающие на сцене «Минск-Арена»
SELECT T.FullName
     , B.BandName AS [Группа]
FROM TechStaff AS T
   , SupportsBand AS SB
   , Band AS B
   , PerformsOn AS PO
   , Stage AS S
WHERE MATCH(T-(SB)->B-(PO)->S)
  AND S.StageName = N'Минск-Арена';
GO

--Какие группы выступают после группы «Макс Корж» и на каких сценах
SELECT B2.BandName
     , S.StageName AS [Сцена]
FROM Band AS B1
   , FollowsAfter AS FA
   , Band AS B2
   , PerformsOn AS PO
   , Stage AS S
WHERE MATCH(B1-(FA)->B2-(PO)->S)
  AND B1.BandName = N'Макс Корж';
GO

--Какие группы выступают на сценах, за которые отвечает сотрудник «Алексей Иванов»
SELECT B.BandName
     , S.StageName AS [Сцена]
FROM TechStaff AS T
   , AssignedToStage AS ATS
   , Stage AS S
   , PerformsOn AS PO
   , Band AS B
WHERE MATCH(T-(ATS)->S AND B-(PO)->S)
  AND T.FullName = N'Алексей Иванов';
GO

--Какие сотрудники обслуживают группы, которые идут после группы «Naviband»
SELECT T.FullName
     , B2.BandName AS [Группа]
FROM Band AS B1
   , FollowsAfter AS FA
   , Band AS B2
   , SupportsBand AS SB
   , TechStaff AS T
WHERE MATCH(B1-(FA)->B2 AND T-(SB)->B2)
  AND B1.BandName = N'Naviband';
GO

--Какие сотрудники через обслуживаемую группу выходят на следующую группу и её сцену
SELECT T.FullName
     , B2.BandName AS [Следующая группа]
     , S.StageName AS [Сцена]
FROM TechStaff AS T
   , SupportsBand AS SB
   , Band AS B1
   , FollowsAfter AS FA
   , Band AS B2
   , PerformsOn AS PO
   , Stage AS S
WHERE MATCH(T-(SB)->B1-(FA)->B2-(PO)->S);
GO

-- 6. Запросы с использованием функции SHORTEST_PATH

--Максимально возможная цепочка выступлений после группы «Макс Корж»
SELECT Band1.BandName AS BandName
     , STRING_AGG(Band2.BandName, '->') WITHIN GROUP (GRAPH PATH) AS [Path]
FROM Band AS Band1
   , FollowsAfter FOR PATH AS fa
   , Band FOR PATH AS Band2
WHERE MATCH(SHORTEST_PATH(Band1(-(fa)->Band2)+))
  AND Band1.BandName = N'Макс Корж';
GO


--Кратчайший путь от группы «Макс Корж» до группы «ЛСП» не более чем за 5 шагов
SELECT Band1.BandName AS BandFrom
     , Band3.BandName AS BandTo
     , STRING_AGG(Band2.BandName, '->') WITHIN GROUP (GRAPH PATH) AS [Path]
FROM Band AS Band1
   , FollowsAfter FOR PATH AS fa
   , Band FOR PATH AS Band2
   , Band AS Band3
WHERE MATCH(SHORTEST_PATH(Band1(-(fa)->Band2){1,5}) AND LAST_NODE(Band2) = Band3)
  AND Band1.BandName = N'Макс Корж'
  AND Band3.BandName = N'ЛСП';
GO

