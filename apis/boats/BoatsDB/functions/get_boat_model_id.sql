CREATE FUNCTION [dbo].[get_boat_model_id]
(
	@model_name nvarchar(100)
)
RETURNS INT
BEGIN
	DECLARE @boat_model_id INT;
	SELECT @boat_model_id = [id] FROM dbo.boat_models WHERE [name] = @model_name
	RETURN @boat_model_id
END;
