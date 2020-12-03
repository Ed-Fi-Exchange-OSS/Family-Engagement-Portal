SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
