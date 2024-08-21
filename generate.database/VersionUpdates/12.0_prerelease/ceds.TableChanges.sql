update ceds.CedsOptionSetMapping
set CedsOptionSetDescription = 'Northern Mariana Islands',
	CedsOptionSetDefinition =  'Northern Mariana Islands'
where CedsElementTechnicalName in ('QualifyingMoveFromState', 'StateAbbreviation')
and CedsOptionSetDefinition = 'Northern Marianas'
