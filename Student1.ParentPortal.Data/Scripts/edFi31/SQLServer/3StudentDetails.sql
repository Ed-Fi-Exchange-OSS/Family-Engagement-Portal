/****** Object:  Table [ParentPortal].[StudentGoal]    Script Date: 03/11/2020 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[StudentAllAbout](
	[StudentAllAboutId] [int] IDENTITY(1,1) NOT NULL,
	[StudentUSI] [int] NOT NULL,
	[PrefferedName] [nvarchar](MAX) NULL,
	[FunFact] [nvarchar](MAX) NULL,
	[TypesOfBook] [nvarchar](MAX) NULL,
	[FavoriteAnimal] [nvarchar](MAX) NULL,
	[FavoriteThingToDo] [nvarchar](MAX) NULL,
	[FavoriteSubjectSchool] [nvarchar](MAX) NULL,
	[OneThingWant] [nvarchar](MAX) NULL,
	[LearnToDo] [nvarchar](MAX) NULL,
	[LearningThings] [nvarchar](MAX) NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdated] [datetime] NOT NULL
 CONSTRAINT [StudentAllAbout_PK] PRIMARY KEY CLUSTERED 
(
	[StudentAllAboutId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [ParentPortal].[AdminStudentDetailFeatures](
	[AdminStudentDetailFeaturesId] [int] IDENTITY(1,1) NOT NULL,
	[Profile] [bit] NOT NULL,
	[AttendanceIndicator] [bit] NOT NULL,
	[CourseAverageIndicator] [bit] NOT NULL,
	[BehaviorIndicator] [bit] NOT NULL,
	[MissingAssignmentsIndicator] [bit] NOT NULL,
	[AllAboutMe] [bit] NOT NULL,
	[Goals] [bit] NOT NULL,
	[AttendanceLog] [bit] NOT NULL,
	[BehaviorLog] [bit] NOT NULL,
	[CourseGrades] [bit] NOT NULL,
	[MissingAssignments] [bit] NOT NULL,
	[Calendar] [bit] NOT NULL,
	[SuccessTeam] [bit] NOT NULL,
	[CollegeInitiativeCorner] [bit] NOT NULL,
	[ARC] [bit] NOT NULL,
	[STAARAssessment] [bit] NOT NULL,
	[Assessment] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdated] [datetime] NOT NULL
 CONSTRAINT [AdminStudentDetailFeatures_PK] PRIMARY KEY CLUSTERED 
(
	[AdminStudentDetailFeaturesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[StudentGoal](
	[StudentGoalId] [int] IDENTITY(1,1) NOT NULL,
	[StudentUSI] [int] NOT NULL,
	[GoalType] [nvarchar](10) NOT NULL,
	[Goal] [nvarchar](max) NOT NULL,
	[GradeLevel] [nvarchar](max) NOT NULL,
	[DateGoalCreated] [datetime] NOT NULL,
	[DateScheduled] [datetime] NOT NULL,
	[DateCompleted] [datetime] NULL,
	[Additional] [nvarchar](max) NOT NULL,
	[Completed] [nvarchar](10) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdated] [datetime] NOT NULL,
	[Labels] [nvarchar](max) NULL
 CONSTRAINT [StudentGoal_PK] PRIMARY KEY CLUSTERED 
(
	[StudentGoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[StudentGoalStep](
	[StudentGoalStepId] [int] IDENTITY(1,1) NOT NULL,
	[StudentGoalId] [int] NOT NULL,
	[StepName] [nvarchar](max) NOT NULL,
	[Completed] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdated] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[StudentGoalInterventionId] [int] NULL
 CONSTRAINT [StudentGoalStep_PK] PRIMARY KEY CLUSTERED 
(
	[StudentGoalStepId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [ParentPortal].[StudentGoalStep]  WITH CHECK ADD  CONSTRAINT [FK_StudentGoalStep_StudentGoal] FOREIGN KEY([StudentGoalId])
REFERENCES [ParentPortal].[StudentGoal] ([StudentGoalId])
GO
/****** Object:  Table [ParentPortal].[StudentGoalLabel]    Script Date: 03/11/2020 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[StudentGoalLabel](
	[StudentGoalLabelId] [int] IDENTITY(1,1) NOT NULL,
	[Label] [nvarchar](max) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdated] [datetime] NOT NULL
 CONSTRAINT [StudentGoalLabel_PK] PRIMARY KEY CLUSTERED 
(
	[StudentGoalLabelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT INTO ParentPortal.StudentGoalLabel VALUES ('Reading',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
INSERT INTO ParentPortal.StudentGoalLabel VALUES ('Writing',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
INSERT INTO ParentPortal.StudentGoalLabel VALUES ('Math',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
INSERT INTO ParentPortal.StudentGoalLabel VALUES ('Social Studies',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
INSERT INTO ParentPortal.StudentGoalLabel VALUES ('Science',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
INSERT INTO ParentPortal.StudentGoalLabel VALUES ('Literacy',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
INSERT INTO ParentPortal.StudentGoalLabel VALUES ('Art',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
INSERT INTO ParentPortal.StudentGoalLabel VALUES ('Music',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
INSERT INTO ParentPortal.StudentGoalLabel VALUES ('CTE',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
INSERT INTO ParentPortal.StudentGoalLabel VALUES ('PE',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
GO