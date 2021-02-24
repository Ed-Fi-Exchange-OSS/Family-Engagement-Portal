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
