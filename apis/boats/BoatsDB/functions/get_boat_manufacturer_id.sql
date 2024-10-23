CREATE FUNCTION [dbo].[get_boat_manufacturer_id]
(
	@manufacturer_name nvarchar(100)
)
RETURNS INT
BEGIN
	DECLARE @boat_manufacturer_id INT;
	SELECT @boat_manufacturer_id = [id] FROM dbo.boat_manufacturers WHERE [name] = @manufacturer_name
	RETURN @boat_manufacturer_id
END;
