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
Add boat manufacturers
*/

IF ((SELECT COUNT(id) FROM dbo.boat_manufacturers) < 13)
	INSERT INTO dbo.boat_manufacturers (name)
	VALUES ('Farr'),
		   ('Jeanneau'),
		   ('Beneteau'),
		   ('Shogun'),
		   ('X-Yachts'),
		   ('Diva'),
		   ('Arcona');
GO

/*
Add boat models
*/
IF ((SELECT COUNT(id) FROM dbo.boat_models) < 13)
	INSERT INTO dbo.boat_models (name, manufacturer_id)
	VALUES ('31 IMS', dbo.get_boat_manufacturer_id('Farr')),
		   ('Sun Fast 37', dbo.get_boat_manufacturer_id('Jeanneau')),
		   ('First 41', dbo.get_boat_manufacturer_id('Beneteau')),
		   ('43', dbo.get_boat_manufacturer_id('Shogun')),
		   ('IMX', dbo.get_boat_manufacturer_id('X-Yachts')),
		   ('399', dbo.get_boat_manufacturer_id('Diva')),
		   ('465 Carbon', dbo.get_boat_manufacturer_id('Arcona'));
GO

/*
Add dogs
*/
IF((SELECT COUNT(id) FROM dbo.boats) < 7)
	INSERT INTO dbo.boats ([name], model_id)
	VALUES ('Farr Ahead', dbo.get_boat_model_id('31 IMS')),
		   ('Monique', dbo.get_boat_model_id('Sun Fast 37')),
		   ('After ski', dbo.get_boat_model_id('First 41')),
		   ('Jackie', dbo.get_boat_model_id('43')),
		   ('X-treme', dbo.get_boat_model_id('IMX')),
		   ('EST!EST!!EST!!!', dbo.get_boat_model_id('399')),
		   ('Nice', dbo.get_boat_model_id('465 Carbon'));
GO