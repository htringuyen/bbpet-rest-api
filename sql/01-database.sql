USE master;
GO

-- Check if the bbpet database exists
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'bbpet')
BEGIN
    -- Delete the bbpet database
    ALTER DATABASE bbpet SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE bbpet;
END

-- Create a new bbpet database
CREATE DATABASE bbpet;
GO
--
-- USE master;
-- GO
--
-- ALTER LOGIN sa WITH DEFAULT_DATABASE = bbpet;
-- GO
--
-- USE bbpet;
-- GO
--
-- -- For generating random numbers
-- CREATE TABLE RandomSeed (
--     id INT IDENTITY(1, 1) PRIMARY KEY
-- );
