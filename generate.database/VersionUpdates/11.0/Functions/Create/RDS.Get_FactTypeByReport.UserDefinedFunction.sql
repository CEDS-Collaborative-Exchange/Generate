CREATE FUNCTION [RDS].[Get_FactTypeByReport]
(
	@reportCode as varchar(50)
)
RETURNS Varchar(50)
AS
BEGIN

	DECLARE @factTypeCode as varchar(50)

	if(@reportCode in ('c029','c035','c039','c129','c130','c163','c170','c190','c193','c196','c197','c198','c103','c131','c205', 'c206'))
	begin
		set @factTypeCode = 'directory'
	end 
	else if(@reportCode in ('c199','c200','c201','c202'))
	begin
		set @factTypeCode = 'organizationstatus'
	end 
	else if(@reportCode in ('studentcount','studentsex','studentdisability','studentrace','studentswdtitle1','studentdiscipline','studentsubpopulation'))
	begin
		set @factTypeCode = 'datapopulation'
	end 
	else if(@reportCode in ('c002','c089','yeartoyearenvironmentcount','yeartoyearchildcount','yeartoyearremovalcount', 'studentssummary'))
	begin
		set @factTypeCode = 'childcount'
	end 
	else if(@reportCode in ('c009','exitspecialeducation','yeartoyearexitcount'))
	begin
		set @factTypeCode = 'specedexit'
	end 
	else if(@reportCode in ('c082','c083','c154','c155','c156','c158','c169','c132'))
	begin
		set @factTypeCode = 'cte'
	end 
	else if(@reportCode in ('c033','c052'))
	begin
		set @factTypeCode = 'membership'
	end 
	else if(@reportCode in ('c032'))
	begin
		set @factTypeCode = 'dropout'
	end 
	else if(@reportCode in ('c040','cohortgraduationrate'))
	begin
		set @factTypeCode = 'grad'
	end 
	else if(@reportCode in ('indicator9','indicator10'))
	begin
		set @factTypeCode = 'sppapr'
	end 
	else if(@reportCode in ('c141'))
	begin
		set @factTypeCode = 'titleIIIELOct'
	end 
	else if(@reportCode in ('c116','c045','c204'))
	begin
		set @factTypeCode = 'titleIIIELSY'
	end 
	else if(@reportCode in ('c037','c134'))
	begin
		set @factTypeCode = 'titleI'
	end 
	else if(@reportCode in ('c054', 'c121', 'c122', 'c145'))
	begin
		set @factTypeCode = 'mep'
	end 
	else if(@reportCode in ('c165'))
	begin
		set @factTypeCode = 'immigrant'
	end 
	else if(@reportCode in ('c119', 'c127', 'c180', 'c181'))
	begin
		set @factTypeCode = 'nord'
	end 
	else if(@reportCode in ('c118', 'c194'))
	begin
		set @factTypeCode = 'homeless'
	end 
	else if(@reportCode in ('c195'))
	begin
		set @factTypeCode = 'chronic'
	end 
	else if(@reportCode in ('c150', 'c151'))
	begin
		set @factTypeCode = 'gradrate'
	end 
	else if(@reportCode in ('c160'))
	begin
		set @factTypeCode = 'hsgradenroll'
	end 
	else if(@reportCode in ('studentfederalprogramsparticipation', 'studentmultifedprogsparticipation', 'edenvironmentdisabilitiesage3-5', 'edenvironmentdisabilitiesage6-21'))
	begin
		set @factTypeCode = 'other'
	end 
	else if(@reportCode in ('c212'))
	begin
		set @factTypeCode = 'compsupport'
	end 
	else
	begin
		set @factTypeCode = 'submission'
	end

	return @factTypeCode

END