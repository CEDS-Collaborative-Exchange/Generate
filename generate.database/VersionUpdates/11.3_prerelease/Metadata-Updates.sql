--Set the appropriate dimensionid for Assessment Participation Status
update app.filecolumns
set dimensionid = 23
where columnname = 'testingstatusid'
and displayname = 'Participation Status S'