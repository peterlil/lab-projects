SELECT * FROM sys.sql_logins;

CREATE LOGIN peterlil WITH PASSWORD = ''; 

/*Switch DB*/

CREATE USER peterlil FOR LOGIN peterlil;

exec sp_addrolemember 'db_owner', 'peterlil'

