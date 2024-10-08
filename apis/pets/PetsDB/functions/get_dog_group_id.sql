CREATE FUNCTION [dbo].[get_dog_group_id]
(
	@group_name nvarchar(100)
)
RETURNS INT
BEGIN
	DECLARE @dog_group_id INT;
	SELECT @dog_group_id = [id] FROM dbo.dog_groups WHERE [name] = @group_name
	RETURN @dog_group_id
END;
