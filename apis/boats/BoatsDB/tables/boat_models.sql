CREATE TABLE [dbo].[boat_models]
(
	[id] INT NOT NULL IDENTITY(1,1),
	[name] NVARCHAR(100) NOT NULL,
	[manufacturer_id] INT NOT NULL,
	[type] nvarchar(20) NOT NULL DEFAULT 'Sailboat',
	[description] NVARCHAR(1000) NULL,
	CONSTRAINT [pk_boat_models] PRIMARY KEY ([id]) WITH (DATA_COMPRESSION = PAGE),
	CONSTRAINT [fk_boat_models_boat_manufacturers] FOREIGN KEY ([manufacturer_id]) REFERENCES [dbo].[boat_manufacturers] ([id]) ON DELETE CASCADE
)
