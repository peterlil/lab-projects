CREATE TABLE [dbo].[boat_manufacturers]
(
	[id] INT NOT NULL IDENTITY(1,1),
	[name] NVARCHAR(100) NOT NULL,
	CONSTRAINT [pk_boat_manufacturers] PRIMARY KEY ([id]) WITH (DATA_COMPRESSION = PAGE)
)
