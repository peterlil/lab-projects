CREATE TABLE [dbo].[dogs]
(
	[id] INT NOT NULL IDENTITY(1,1),
	[name] NVARCHAR(100) NOT NULL,
	[age] INT NOT NULL,
	[breed_id] INT NOT NULL,
	CONSTRAINT [pk_dogs] PRIMARY KEY ([id]) WITH (DATA_COMPRESSION = PAGE),
	CONSTRAINT [fk_dogs_dog_breeds] FOREIGN KEY ([breed_id]) REFERENCES [dbo].[dog_breeds] ([id]) ON DELETE CASCADE
)
