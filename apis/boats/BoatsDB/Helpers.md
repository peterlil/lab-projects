
```sql
-- *** Execute in master *** --

-- Create the login and the user in master
CREATE LOGIN [petsapi-id] FROM EXTERNAL PROVIDER;
CREATE USER [petsapi-id] FOR LOGIN [petsapi-id];



-- *** Execute in BoatsDB *** --

CREATE USER [petsapi-id] FOR LOGIN [petsapi-id];

exec sp_addrolemember N'db_datawriter', N'petsapi-id';
exec sp_addrolemember N'db_datareader', N'petsapi-id';



-- ***************************** --
--         REMOVAL CODE
-- ***************************** --

-- *** Execute in timeout-db *** --
exec sp_droprolemember N'db_datawriter', N'petsapi-id';
exec sp_droprolemember N'db_datareader', N'petsapi-id';

DROP USER [petsapi-id];

-- *** Execute in master *** --
-- Create the login and the user in master
DROP USER [petsapi-id];
DROP LOGIN [petsapi-id];

```