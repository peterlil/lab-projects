SELECT TOP 10 * FROM TimeoutLog ORDER BY Id DESC
SELECT COUNT(*) AS [Count], 30*60 AS [30MinsinSec] FROM TimeoutLog 
SELECT COUNT(*) AS [Count], 30*60 AS [30MinsinSec] FROM TimeoutLog WHERE Id >= 6000

SELECT Execution, 
	COUNT(*) AS [Count],
	30*60 AS [30MinsinSec],
	MIN(Inserted) AS [From],
	MAX(Inserted) AS [To]
FROM (
	SELECT 
		*, CAST([Id] / 2000 AS INT) AS Execution
	FROM TimeoutLog
) base
GROUP BY Execution
ORDER BY Execution

SELECT MAX(Id) FROM TimeoutLog

DBCC CHECKIDENT ( TimeoutLog, RESEED, 10000 )

/*
-- Remove ALL rows
TRUNCATE TABLE TimeoutLog
*/


--SELECT COUNT(*) FROM TimeoutLog WHERE Inserted > '2024-09-26 09:58:00'
--DELETE FROM  TimeoutLog WHERE Inserted > '2024-09-26 09:58:00'