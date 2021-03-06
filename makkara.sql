USE [makkara]
GO
/****** Object:  Table [dbo].[Activity]    Script Date: 14/01/2020 15.32.47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Activity](
	[ActivityID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ActivityDate] [date] NOT NULL,
	[ActivityMeasurement] [int] NULL,
	[ActivityComment] [varchar](255) NULL,
	[ActivityLogo] [varchar](128) NULL,
	[ActivityPicture] [varchar](128) NULL,
	[CategoryID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActivityCategories]    Script Date: 14/01/2020 15.32.47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityCategories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 14/01/2020 15.32.47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[AccountName] [varchar](16) NULL,
	[AccountPassword] [varchar](64) NULL,
	[UsersName] [varchar](128) NOT NULL,
	[UserInformation] [varchar](255) NULL,
	[UserHeight] [int] NULL,
	[UserWeight] [int] NULL,
	[UserBirth] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[AccountName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Activity]  WITH CHECK ADD FOREIGN KEY([CategoryID])
REFERENCES [dbo].[ActivityCategories] ([CategoryId])
GO
ALTER TABLE [dbo].[Activity]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
