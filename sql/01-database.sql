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
