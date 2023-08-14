SET NOCOUNT ON;

Update app.GenerateReports set IsActive = 0 where reportcode in ('c199','c200','c201','c202','c209','c210',
                                                                'c213','c214','c215','c216','c217')