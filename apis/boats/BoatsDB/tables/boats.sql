CREATE TABLE [dbo].[boats]
(
	[id] INT NOT NULL IDENTITY(1,1),
	[name] NVARCHAR(100) NOT NULL,
	[model_id] INT NOT NULL,
	CONSTRAINT [pk_boats] PRIMARY KEY ([id]) WITH (DATA_COMPRESSION = PAGE),
	CONSTRAINT [fk_boats_boat_models] FOREIGN KEY ([model_id]) REFERENCES [dbo].[boat_models] ([id]) ON DELETE CASCADE
)
