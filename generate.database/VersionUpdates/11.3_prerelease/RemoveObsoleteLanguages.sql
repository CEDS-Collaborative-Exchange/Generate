--FS141 Remove obsolete languages from the permitted values 
delete o
from app.CategoryOptions o
    inner join app.CategorySets cs
        on o.CategorySetId = cs.CategorySetId
    inner join app.Categories c 
        on o.CategoryId = c.CategoryId
where cs.GenerateReportId = 54
and c.CategoryCode = 'LANGHOME'
and cs.CategorySetCode = 'CSB'    
and cs.SubmissionYear >= 2023
and o.CategoryOptionCode in 
('afh','akk','ang','arc','art','ave','bod','ces','chb','chg','chu','cop','cym','deu',
'dum','egy','ell','elx','enm','epo','eus','fas','fra','frm','fro','gez','gmh','goh',
'got','grc','hye','ido','ile','ina','isl','jbo','kat','kaw','lat','mga','mkd','mri',
'msa','mya','nld','non','nwc','pal','peo','phn','pli','pro','ron','sam','san','sga',
'slk','sqi','sux','syc','tlh','uga','vol','zho','zxx')
