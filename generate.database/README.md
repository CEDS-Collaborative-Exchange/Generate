# Database Script Instructions

# Installations

For new installations, please restore the most recent version of the Generate database located
in the DatabaseFiles directory.  You may restore it manually or use the provided RestoreDatbase.sql script.

For updates, just run generate.web.exe from the commandline.

# Configuration of New Releases

Each release usually includes changes to the following database components:

* Database code (e.g. stored procedures, functions, table types, etc.)
* EDFacts/CEDS metadata (e.g. categories, category sets, category options, table types, file columns, CEDS connections, etc.)
* Generate metadata (e.g. FactTables, Dimensions, DimensionTables, dimension seed data, etc.)
* Table changes (e.g. new tables, new columns, altered columns, etc.)
* List of Changes (e.g. list of script files that should be run for a release)

Database Code

* When making changes to database code for a release, change the script file for that particular object
located in the directory for that object type (e.g. StoredProcedures, Functions)

EDFacts/CEDS Metadata

* When making changes for a release, run these common metadata scripts against the EDFacts or CEDS database to obtain fresh versions with the latest changes.

Generate Metadata

* These changes should go in the VersionUpdates folder, under the specific release.
* They should be placed in the MetaData.sql file for the relevant schema, for example, ODS.Metadata.sql.
* Be sure to provide documentation in the file to explain why the changes were required.

Table changes

* All structural changes should be made via SQL scripts and must work without deleting data or recreating tables.
* These changes should go in the VersionUpdates folder, under the specific release.
* They should be placed in the TableChanges.sql file for the relevant schema, for example, ODS.TableChanges.sql.
* Be sure to provide documentation in the file to explain why the changes were required.

List of Changes

* Place the the list of script files to be run into a .csv file called VersionScripts.csv in the release-specific folder.
* For each script in that .csv file, the last parameter is a bit flag that indicates whether the script should always be run (i.e. forced).

# Ongoing Implementation

* While under development, the release should include the "_prerelease" suffix in the folder name.  This will
prevent deployment of those scripts in the stage and production environments.
* Once a release is complete, create database backup that includes the test data.
* Each release must be tested against a database will full test data and full migrations for every release starting with 2.4.  In other, when we put together the 2.6 release, we’ll test it agains a 2.4 database, a 2.5 database, and a 2.6 database (all fully populated with test data and all migrations run).

# Upgrade Process

* The upgrade process for each state will be the same as it is now, but we should have less problems and they will not be required to drop and re-create the generate database.
