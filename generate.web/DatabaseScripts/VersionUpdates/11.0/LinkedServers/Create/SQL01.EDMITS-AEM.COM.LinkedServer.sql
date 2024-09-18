IF NOT EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'SQL01.EDMITS-AEM.COM,3748')
BEGIN
EXEC master.dbo.sp_addlinkedserver @server = N'SQL01.EDMITS-AEM.COM,3748', @srvproduct=N'SQL Server'

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SQL01.EDMITS-AEM.COM,3748',@useself=N'False',@locallogin=NULL,@rmtuser=N'DoEDUser',@rmtpassword='Edendev1!'
END

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'collation compatible', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'data access', @optvalue=N'true'

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'dist', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'pub', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'rpc', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'rpc out', @optvalue=N'true'

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'sub', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'connect timeout', @optvalue=N'0'

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'collation name', @optvalue=null

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'lazy schema validation', @optvalue=N'false'

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'query timeout', @optvalue=N'0'

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'use remote collation', @optvalue=N'true'

EXEC master.dbo.sp_serveroption @server=N'SQL01.EDMITS-AEM.COM,3748', @optname=N'remote proc transaction promotion', @optvalue=N'true'


