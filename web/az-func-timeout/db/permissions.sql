-- *** Execute in master *** --

-- Create the login and the user in master
CREATE LOGIN [az-func-timeout] FROM EXTERNAL PROVIDER;
CREATE USER [az-func-timeout] FOR LOGIN [az-func-timeout];



-- *** Execute in timeout-db *** --

CREATE USER [az-func-timeout] FOR LOGIN [az-func-timeout];

exec sp_addrolemember N'db_datawriter', N'az-func-timeout';
exec sp_addrolemember N'db_datareader', N'az-func-timeout';

