-- *** Execute in master *** --

-- Create the login and the user in master
CREATE LOGIN [az-func-timeout] FROM EXTERNAL PROVIDER;
CREATE USER [az-func-timeout] FOR LOGIN [az-func-timeout];



-- *** Execute in timeout-db *** --

CREATE USER [az-func-timeout] FOR LOGIN [az-func-timeout];

exec sp_addrolemember N'db_datawriter', N'az-func-timeout';
exec sp_addrolemember N'db_datareader', N'az-func-timeout';



-- ***************************** --
--         REMOVAL CODE
-- ***************************** --

-- *** Execute in timeout-db *** --
exec sp_droprolemember N'db_datawriter', N'az-func-timeout';
exec sp_droprolemember N'db_datareader', N'az-func-timeout';

DROP USER [az-func-timeout];

-- *** Execute in master *** --
-- Create the login and the user in master
DROP USER [az-func-timeout];
DROP LOGIN [az-func-timeout];
