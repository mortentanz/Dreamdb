



/****** Object:  Login [FM\DEP DREAM]    Script Date: 09/11/2006 14:31:37 ******/
/****** Object:  Login [FM\DEP DREAM]    Script Date: 09/11/2006 14:31:37 ******/
CREATE LOGIN [FM\DEP DREAM] FROM WINDOWS WITH DEFAULT_DATABASE=[Dreamdb], DEFAULT_LANGUAGE=[us_english]
GO

USE [Dreamdb]
GO
/****** Object:  User [dream]    Script Date: 09/11/2006 14:32:28 ******/
GO
CREATE USER [dream] FOR LOGIN [FM\DEP DREAM]