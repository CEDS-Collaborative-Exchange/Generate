 IF COL_LENGTH('App.FileColumns', 'ReportColumn') IS NULL
 BEGIN
     ALTER TABLE App.FileColumns ADD ReportColumn varchar(100) null
 END