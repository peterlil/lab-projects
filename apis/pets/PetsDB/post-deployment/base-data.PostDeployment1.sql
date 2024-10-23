/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

/*
Add dog groups
*/

IF ((SELECT COUNT(id) FROM dbo.dog_groups) < 7)
	INSERT INTO dbo.dog_groups (name)
	VALUES ('Sporting'),
		   ('Hound'),
		   ('Working'),
		   ('Terrier'),
		   ('Toy'),
		   ('Non-Sporting'),
		   ('Herding');
GO

/*
Add dog breeds
*/
IF ((SELECT COUNT(id) FROM dbo.dog_breeds) < 13)
	INSERT INTO dbo.dog_breeds (name, group_id)
	VALUES ('Labrador Retriever', dbo.get_dog_group_id('Sporting')),
		   ('German Shepherd', dbo.get_dog_group_id('Working')),
		   ('Golden Retriever', dbo.get_dog_group_id('Sporting')),
		   ('Bulldog', dbo.get_dog_group_id('Non-Sporting')),
		   ('Beagle', dbo.get_dog_group_id('Hound')),
		   ('Poodle', dbo.get_dog_group_id('Toy')),
		   ('Rottweiler', dbo.get_dog_group_id('Working')),
		   ('Yorkshire Terrier', dbo.get_dog_group_id('Terrier')),
		   ('Boxer', dbo.get_dog_group_id('Working')),
		   ('Dachshund', dbo.get_dog_group_id('Hound')),
		   ('Siberian Husky', dbo.get_dog_group_id('Working')),
		   ('Border Collie', dbo.get_dog_group_id('Herding')),
		   ('Australian Shepherd', dbo.get_dog_group_id('Herding')),
		   ('Miniture American Shepherd', dbo.get_dog_group_id('Herding'));
GO

/*
Add dogs
*/
IF((SELECT COUNT(id) FROM dbo.dogs) < 14)
	INSERT INTO dbo.dogs ([name], age, breed_id)
	VALUES ('Buddy', 3, dbo.get_dog_breed_id('Labrador Retriever')),
		   ('Max', 2, dbo.get_dog_breed_id('German Shepherd')),
		   ('Charlie', 1, dbo.get_dog_breed_id('Golden Retriever')),
		   ('Jack', 4, dbo.get_dog_breed_id('Bulldog')),
		   ('Cooper', 5, dbo.get_dog_breed_id('Beagle')),
		   ('Rocky', 6, dbo.get_dog_breed_id('Poodle')),
		   ('Bear', 7, dbo.get_dog_breed_id('Rottweiler')),
		   ('Duke', 8, dbo.get_dog_breed_id('Yorkshire Terrier')),
		   ('Tucker', 9, dbo.get_dog_breed_id('Boxer')),
		   ('Oliver', 10, dbo.get_dog_breed_id('Dachshund')),
		   ('Bentley', 11, dbo.get_dog_breed_id('Siberian Husky')),
		   ('Milo', 12, dbo.get_dog_breed_id('Border Collie')),
		   ('Teddy', 13, dbo.get_dog_breed_id('Australian Shepherd')),
		   ('Mickie', 5, dbo.get_dog_breed_id('Miniture American Shepherd'));
GO
GO