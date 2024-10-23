CREATE TABLE TimeoutLog
(
	Id int IDENTITY(1,1) NOT NULL,
	Inserted DATETIME DEFAULT GETDATE() NOT NULL,
	ApplicationName nvarchar(255) NOT NULL,
	CONSTRAINT PK_TimeoutLog PRIMARY KEY CLUSTERED (Id) WITH (DATA_COMPRESSION=PAGE)
);