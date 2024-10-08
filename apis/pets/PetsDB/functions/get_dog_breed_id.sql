CREATE FUNCTION [dbo].[get_dog_breed_id]
(
	@breed_name nvarchar(100)
)
RETURNS INT
BEGIN
	DECLARE @dog_breed_id INT;
	SELECT @dog_breed_id = [id] FROM dbo.dog_breeds WHERE [name] = @breed_name
	RETURN @dog_breed_id
END;
