CREATE TABLE [dbo].[dog_breeds]
(
	[id] INT NOT NULL IDENTITY(1,1),
	[name] NVARCHAR(100) NOT NULL,
	[group_id] INT NOT NULL,
	[description] NVARCHAR(1000) NULL,
	CONSTRAINT [pk_dog_breeds] PRIMARY KEY ([id]) WITH (DATA_COMPRESSION = PAGE),
	CONSTRAINT [fk_dog_breeds_dog_group] FOREIGN KEY ([group_id]) REFERENCES [dbo].[dog_groups] ([id]) ON DELETE CASCADE
)
