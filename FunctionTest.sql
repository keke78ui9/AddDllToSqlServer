USE [TestDB];
GO

-- drop functions which are using assemblies 
IF  EXISTS (
SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnTestFunc]') 
AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnTestFunc]
GO

USE [TestDB]
GO
IF  EXISTS (SELECT * FROM sys.assemblies asms WHERE asms.name = N'MyTestUDFFunc')
DROP ASSEMBLY [MyTestUDFFunc]
GO

USE TestDB
GO
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;
alter database TestDB Set trustworthy on;
GO

USE TestDB
GO
CREATE ASSEMBLY [MyTestUDFFunc]
AUTHORIZATION [dbo]
FROM 'C:\Test\SqlServerProject1.dll'
WITH PERMISSION_SET = UNSAFE
GO

USE [TestDB]
GO
CREATE FUNCTION dbo.fnTestFunc
(
)
RETURNS NVARCHAR(MAX) 
AS
EXTERNAL NAME [MyTestUDFFunc].[UserDefinedFunctions].[FunctionTest];
GO

-- test the result
USE [TestDB]
select dbo.fnTestFunc();



