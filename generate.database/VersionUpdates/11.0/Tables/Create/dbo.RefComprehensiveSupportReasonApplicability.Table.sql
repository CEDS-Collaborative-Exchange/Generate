IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'RefComprehensiveSupportReasonApplicability' AND Type = N'U')
BEGIN
    CREATE TABLE [dbo].[RefComprehensiveSupportReasonApplicability](
	    [RefComprehensiveSupportReasonApplicabilityId] [int] IDENTITY(1,1) NOT NULL,
	    [Description] [nvarchar](100) NULL,
	    [Code] [nvarchar](50) NULL,
	    [Definition] [nvarchar](max) NULL,
	    [RefJurisdictionId] [int] NULL,
	    [SortOrder] [decimal](5, 2) NULL,
	CONSTRAINT [PK_RefComprehensiveSupportReasonApplicability] PRIMARY KEY CLUSTERED 
    (
	    [RefComprehensiveSupportReasonApplicabilityId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    


    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefComprehensiveSupportReasonApplicability_Org]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefComprehensiveSupportReasonApplicability]'))
    ALTER TABLE [dbo].[RefComprehensiveSupportReasonApplicability]  WITH CHECK ADD  CONSTRAINT [FK_RefComprehensiveSupportReasonApplicability_Org] FOREIGN KEY([RefJurisdictionId])
    REFERENCES [dbo].[Organization] ([OrganizationId])


    IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefComprehensiveSupportReasonApplicability_Org]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefComprehensiveSupportReasonApplicability]'))
    ALTER TABLE [dbo].[RefComprehensiveSupportReasonApplicability] CHECK CONSTRAINT [FK_RefComprehensiveSupportReasonApplicability_Org]

END
