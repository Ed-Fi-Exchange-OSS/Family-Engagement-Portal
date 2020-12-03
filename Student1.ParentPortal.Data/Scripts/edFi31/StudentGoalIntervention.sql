/****** Object:  Table [ParentPortal].[StudentGoal]    Script Date: 03/11/2020 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[StudentGoalIntervention](
	[StudentGoalInterventionId] [int] IDENTITY(1,1) NOT NULL,
	[StudentUSI] [int] NOT NULL,
	[StudentGoalId] [int] NOT NULL,
	[Description] [nvarchar](MAX) NULL,
	[InterventionStart] [datetime] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdated] [datetime] NOT NULL
 CONSTRAINT [StudentGoalIntervention_PK] PRIMARY KEY CLUSTERED 
(
	[StudentGoalInterventionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
