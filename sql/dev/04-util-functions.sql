-- always use right database
USE bbpet;
GO

CREATE PROCEDURE dbo.GenerateRandomInt
    @MinValue INT,
    @MaxValue INT,
    @Seed INT,
    @RandomInt INT OUTPUT
AS
BEGIN
    DECLARE @Range INT = @MaxValue - @MinValue + 1;
    DECLARE @RandomFloat FLOAT = RAND();

    SELECT @RandomInt = ROUND((@Range - 1) * @RandomFloat + @MinValue, 0);

    RETURN;
END;
GO


CREATE PROCEDURE dbo.GenerateRandomDateTime
    @MinTime DATETIME,
    @MaxTime DATETIME,
    @Seed INT,
    @RandomTime DATETIME OUTPUT
AS
BEGIN
    DECLARE @DateDiff FLOAT = DATEDIFF(SECOND , @MinTime, @MaxTime);
    DECLARE @RandomFloat FLOAT = RAND();

    SELECT @RandomTime = DATEADD(SECOND, ROUND(@DateDiff * @RandomFloat, 0), @MinTime);

    RETURN;
END;
GO


CREATE PROCEDURE dbo.GenerateRandomDecimal
    @MinValue DECIMAL(10, 2),
    @MaxValue DECIMAL(10, 2),
    @Seed INT,
    @RandomDecimal DECIMAL(10, 2) OUTPUT
AS
BEGIN
    DECLARE @Range DECIMAL(10, 2) = @MaxValue - @MinValue + 0.01;
    DECLARE @RandomFloat FLOAT = RAND();

    SELECT @RandomDecimal = ROUND((@Range - 0.01) * @RandomFloat + @MinValue, 2);

    RETURN;
END;
GO