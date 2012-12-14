$Archive: /Dreamdb/readme.txt $
$Revision: 3 $
$Date: 9/09/06 1:15 $
$Author: Tanz $


Readme for Dreamdb solution folder

Dreamdb is the backend database in the Dream modeling system. Bedides a relational database for storing production and external data, the SQL server instance provides integration services and eventually online analytical processing capabilities.

The subfolders of the Dreamdb solution folder contains the source code required for building, initializing and maintaining these SQL Server applications. The code is organized largely by development environment as follows:

CFG - Configuration scripts and xml for controlling environment
CLR - General purpose CLR functionality in dbo schema
ETL - CLR and Integration Services (SSIS) implementation of an ETL system
SCR - Scripts for creating, building, loading, testing and maintaining Dreamdb
SQL - T-SQL code defining schema, integrity and programmability of database engine


See readme.txt files in solutions for project structure.