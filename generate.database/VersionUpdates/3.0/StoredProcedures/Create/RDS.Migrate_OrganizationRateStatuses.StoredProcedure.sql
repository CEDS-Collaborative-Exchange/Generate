-- =============================================
-- Author:		Andy Tsovma
-- Create date: 10/31/2018
-- Description:	migrate organization rate statuses for c199 etc.
-- =============================================
CREATE PROCEDURE [RDS].[Migrate_OrganizationRateStatuses]
	@factTypeCode as varchar(50) = 'datapopulation',
	@runAsTest as bit 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

END