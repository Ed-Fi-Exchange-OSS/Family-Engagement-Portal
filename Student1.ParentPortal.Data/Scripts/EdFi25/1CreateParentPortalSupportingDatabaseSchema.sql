IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ParentPortal')) 
BEGIN
    EXEC ('CREATE SCHEMA [ParentPortal] AUTHORIZATION [dbo]')
END

/****** Object:  Table [ParentPortal].[AlertLog]    Script Date: 11/28/2018 5:36:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[AlertLog](
	[AlertlogId] [int] IDENTITY(1,1) NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[AlertTypeId] [int] NOT NULL,
	[ParentUniqueId] [nvarchar](32) NOT NULL,
	[StudentUniqueId] [nvarchar](32) NOT NULL,
	[Value] [nvarchar](200) NOT NULL,
	[Read] [bit] NOT NULL,
	[UTCSentDate] [datetime] NOT NULL,
	[UTCCreateDate] [datetime] NOT NULL,
	[UTCLastModifiedDate] [datetime] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL
 CONSTRAINT [AlertLog_PK] PRIMARY KEY CLUSTERED 
(
	[AlertlogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [ParentPortal].[MethodOfContactType]    Script Date: 11/28/2018 5:36:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[MethodOfContactType](
	[MethodOfContactTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
	[ShortDescription] [nvarchar](450) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [MethodOfContactType_PK] PRIMARY KEY CLUSTERED 
(
	[MethodOfContactTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ParentPortal].[AlertType]    Script Date: 11/28/2018 5:36:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[AlertType](
	[AlertTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
	[ShortDescription] [nvarchar](450) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [AlertType_PK] PRIMARY KEY CLUSTERED 
(
	[AlertTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ParentPortal].[ParentAlert]    Script Date: 11/28/2018 5:36:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[ParentAlert](
	[ParentUniqueId] [nvarchar](32) NOT NULL,
	[AlertsEnabled] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ParentAlert] PRIMARY KEY CLUSTERED 
(
	[ParentUniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ParentPortal].[ParentAlertAssociation]    Script Date: 11/28/2018 5:36:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[ParentAlertAssociation](
	[ParentUniqueId] [nvarchar](32) NOT NULL,
	[AlertTypeId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [ParentPortal].[TextMessageCarrierType]    Script Date: 11/28/2018 5:36:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[TextMessageCarrierType](
	[TextMessageCarrierTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
	[ShortDescription] [nvarchar](450) NOT NULL,
	[SmsSuffixDomain] [nvarchar](50) NOT NULL,
	[MmsSuffixDomain] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [TextMessageCarrierType_PK] PRIMARY KEY CLUSTERED 
(
	[TextMessageCarrierTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [ParentPortal].[AlertLog] ADD  CONSTRAINT [DF_AlertLog_CreateDate1]  DEFAULT (getutcdate()) FOR [UTCSentDate]
GO
ALTER TABLE [ParentPortal].[AlertLog] ADD  CONSTRAINT [DF_AlertLog_CreateDate]  DEFAULT (getutcdate()) FOR [UTCCreateDate]
GO
ALTER TABLE [ParentPortal].[AlertLog] ADD  CONSTRAINT [DF_AlertLog_LastModifiedDate]  DEFAULT (getutcdate()) FOR [UTCLastModifiedDate]
GO
ALTER TABLE [ParentPortal].[AlertLog] ADD  CONSTRAINT [DF_AlertLog_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [ParentPortal].[Alertlog] ADD  CONSTRAINT [DF_AlertLog_Read]  DEFAULT (0) FOR [Read];
GO
ALTER TABLE [ParentPortal].[MethodOfContactType] ADD  CONSTRAINT [MethodOfContactType_DF_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [ParentPortal].[MethodOfContactType] ADD  CONSTRAINT [MethodOfContactType_DF_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [ParentPortal].[MethodOfContactType] ADD  CONSTRAINT [MethodOfContactType_DF_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [ParentPortal].[AlertType] ADD  CONSTRAINT [AlertType_DF_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [ParentPortal].[AlertType] ADD  CONSTRAINT [AlertType_DF_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [ParentPortal].[AlertType] ADD  CONSTRAINT [AlertType_DF_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [ParentPortal].[ParentAlert] ADD  CONSTRAINT [DF_ParentAlert_AlertsEnabled]  DEFAULT ((0)) FOR [AlertsEnabled]
GO
ALTER TABLE [ParentPortal].[ParentAlert] ADD  CONSTRAINT [DF_ParentAlert_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [ParentPortal].[TextMessageCarrierType] ADD  CONSTRAINT [TextMessageCarrierType_DF_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [ParentPortal].[TextMessageCarrierType] ADD  CONSTRAINT [TextMessageCarrierType_DF_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [ParentPortal].[TextMessageCarrierType] ADD  CONSTRAINT [TextMessageCarrierType_DF_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [ParentPortal].[AlertLog]  WITH CHECK ADD  CONSTRAINT [FK_AlertLog_AlertType] FOREIGN KEY([AlertTypeId])
REFERENCES [ParentPortal].[AlertType] ([AlertTypeId])
GO
ALTER TABLE [ParentPortal].[AlertLog] CHECK CONSTRAINT [FK_AlertLog_AlertType]
GO
ALTER TABLE [ParentPortal].[ParentAlertAssociation]  WITH CHECK ADD  CONSTRAINT [FK_ParentAlertAssociation_AlertType] FOREIGN KEY([AlertTypeId])
REFERENCES [ParentPortal].[AlertType] ([AlertTypeId])
GO
ALTER TABLE [ParentPortal].[ParentAlertAssociation] CHECK CONSTRAINT [FK_ParentAlertAssociation_AlertType]
GO
ALTER TABLE [ParentPortal].[ParentAlertAssociation]  WITH CHECK ADD  CONSTRAINT [FK_ParentAlertAssociation_ParentAlert] FOREIGN KEY([ParentUniqueId])
REFERENCES [ParentPortal].[ParentAlert] ([ParentUniqueId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ParentPortal].[ParentAlertAssociation] CHECK CONSTRAINT [FK_ParentAlertAssociation_ParentAlert]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Key for School Year' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'AlertLog', @level2type=N'COLUMN',@level2name=N'SchoolYear';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Key for AlertType' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'AlertLog', @level2type=N'COLUMN',@level2name=N'AlertTypeId';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A unique alphanumeric code assigned to a parent.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'AlertLog', @level2type=N'COLUMN',@level2name=N'ParentUniqueId';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A unique alphanumeric code assigned to a student.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'AlertLog', @level2type=N'COLUMN',@level2name=N'StudentUniqueId';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The main value which triggered the alert' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'AlertLog', @level2type=N'COLUMN',@level2name=N'Value';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Key for MethodOfContact' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'MethodOfContactType', @level2type=N'COLUMN',@level2name=N'MethodOfContactTypeId';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The description for the MethodOfContact type.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'MethodOfContactType', @level2type=N'COLUMN',@level2name=N'Description';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The value for the MethodOfContact type.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'MethodOfContactType', @level2type=N'COLUMN',@level2name=N'ShortDescription';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type for MethodOfContact.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'MethodOfContactType';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Key for AlertType' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'AlertType', @level2type=N'COLUMN',@level2name=N'AlertTypeId';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The description for the AlertType type.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'AlertType', @level2type=N'COLUMN',@level2name=N'Description';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The value for the AlertType type.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'AlertType', @level2type=N'COLUMN',@level2name=N'ShortDescription';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of alerts available.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'AlertType';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A unique alphanumeric code assigned to a parent.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentAlert', @level2type=N'COLUMN',@level2name=N'ParentUniqueId';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'An indication that the parent has opted in to receive alerts.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentAlert', @level2type=N'COLUMN',@level2name=N'AlertsEnabled';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Key for TextMessageCarrierType' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'TextMessageCarrierType', @level2type=N'COLUMN',@level2name=N'TextMessageCarrierTypeId';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The description for the TextMessageCarrierType type.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'TextMessageCarrierType', @level2type=N'COLUMN',@level2name=N'Description';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The short description for the TextMessageCarrierType type.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'TextMessageCarrierType', @level2type=N'COLUMN',@level2name=N'ShortDescription';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The suffix used to send SMS.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'TextMessageCarrierType', @level2type=N'COLUMN',@level2name=N'SmsSuffixDomain';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The suffix used to send MMS.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'TextMessageCarrierType', @level2type=N'COLUMN',@level2name=N'MmsSuffixDomain';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of alerts available.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'TextMessageCarrierType'
GO

/*Parent Profile*/
/****** Object:  Table [ParentPortal].[ParentProfile]    Script Date: 1/12/2019 3:18:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[ParentProfile](
	[ParentUniqueId] [varchar](32) NOT NULL,
	[FirstName] [nvarchar](75) NOT NULL,
	[MiddleName] [nvarchar](75) NULL,
	[LastSurname] [nvarchar](75) NOT NULL,
	[NickName] [nvarchar](75) NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[PreferredMethodOfContactTypeId] [int] NOT NULL,
	[ReplyExpectations] [varchar](255) NULL,
	[LanguageCode] [nvarchar](10) NULL,
 CONSTRAINT [PK_ParentProfile] PRIMARY KEY CLUSTERED 
(
	[ParentUniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ParentPortal].[ParentProfileAddress]    Script Date: 1/12/2019 3:18:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[ParentProfileAddress](
	[ParentUniqueId] [varchar](32) NOT NULL,
	[AddressTypeId] [int] NOT NULL,
	[StreetNumberName] [nvarchar](150) NOT NULL,
	[ApartmentRoomSuiteNumber] [nvarchar](50) NULL,
	[City] [nvarchar](30) NOT NULL,
	[StateAbbreviationTypeId] [int] NOT NULL,
	[PostalCode] [nvarchar](17) NOT NULL,
	[NameOfCounty] [nvarchar](30) NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ParentProfileAddress] PRIMARY KEY CLUSTERED 
(
	[ParentUniqueId] ASC,
	[AddressTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ParentPortal].[ParentProfileElectronicMail]    Script Date: 1/12/2019 3:18:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[ParentProfileElectronicMail](
	[ParentUniqueId] [varchar](32) NOT NULL,
	[ElectronicMailTypeId] [int] NOT NULL,
	[ElectronicMailAddress] [nvarchar](128) NOT NULL,
	[PrimaryEmailAddressIndicator] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ParentProfileElectronicMail] PRIMARY KEY CLUSTERED 
(
	[ParentUniqueId] ASC,
	[ElectronicMailTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ParentPortal].[ParentProfileTelephone]    Script Date: 1/12/2019 3:18:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[ParentProfileTelephone](
	[ParentUniqueId] [varchar](32) NOT NULL,
	[TelephoneNumberTypeId] [int] NOT NULL,
	[TelephoneNumber] [nvarchar](24) NOT NULL,
	[TextMessageCapabilityIndicator] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[TelephoneCarrierTypeId] [int] NULL,
	[PrimaryMethodOfContact] [bit] NULL,
 CONSTRAINT [PK_ParentProfileTelephone] PRIMARY KEY CLUSTERED 
(
	[ParentUniqueId] ASC,
	[TelephoneNumberTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [ParentPortal].[ParentProfile] ADD  CONSTRAINT [DF_ParentProfile_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
ALTER TABLE [ParentPortal].[ParentProfileAddress] ADD  CONSTRAINT [DF_ParentProfileAddress_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
ALTER TABLE [ParentPortal].[ParentProfileElectronicMail] ADD  CONSTRAINT [DF_ParentProfileElectronicMail_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
ALTER TABLE [ParentPortal].[ParentProfileTelephone] ADD  CONSTRAINT [DF_ParentProfileTelephone_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [ParentPortal].[ParentProfile] ADD  CONSTRAINT [DF_ParentProfile_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
ALTER TABLE [ParentPortal].[ParentProfileAddress] ADD  CONSTRAINT [DF_ParentProfileAddress_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
ALTER TABLE [ParentPortal].[ParentProfileElectronicMail] ADD  CONSTRAINT [DF_ParentProfileElectronicMail_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
ALTER TABLE [ParentPortal].[ParentProfileTelephone] ADD  CONSTRAINT [DF_ParentProfileTelephone_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [ParentPortal].[ParentProfileAddress]  WITH CHECK ADD  CONSTRAINT [FK_ParentProfileAddress_AddressType] FOREIGN KEY([AddressTypeId])
REFERENCES [edfi].[AddressType] ([AddressTypeId])
GO
ALTER TABLE [ParentPortal].[ParentProfileAddress] CHECK CONSTRAINT [FK_ParentProfileAddress_AddressType]
GO
ALTER TABLE [ParentPortal].[ParentProfileAddress]  WITH CHECK ADD  CONSTRAINT [FK_ParentProfileAddress_ParentProfile] FOREIGN KEY([ParentUniqueId])
REFERENCES [ParentPortal].[ParentProfile] ([ParentUniqueId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ParentPortal].[ParentProfileAddress] CHECK CONSTRAINT [FK_ParentProfileAddress_ParentProfile]
GO
ALTER TABLE [ParentPortal].[ParentProfileAddress]  WITH CHECK ADD  CONSTRAINT [FK_ParentProfileAddress_StateAbbreviationType] FOREIGN KEY([StateAbbreviationTypeId])
REFERENCES [edfi].[StateAbbreviationType] ([StateAbbreviationTypeId])
GO
ALTER TABLE [ParentPortal].[ParentProfileAddress] CHECK CONSTRAINT [FK_ParentProfileAddress_StateAbbreviationType]
GO
ALTER TABLE [ParentPortal].[ParentProfileElectronicMail]  WITH CHECK ADD  CONSTRAINT [FK_ParentProfileElectronicMail_ElectronicMailType] FOREIGN KEY([ElectronicMailTypeId])
REFERENCES [edfi].[ElectronicMailType] ([ElectronicMailTypeId])
GO
ALTER TABLE [ParentPortal].[ParentProfileElectronicMail] CHECK CONSTRAINT [FK_ParentProfileElectronicMail_ElectronicMailType]
GO
ALTER TABLE [ParentPortal].[ParentProfileElectronicMail]  WITH CHECK ADD  CONSTRAINT [FK_ParentProfileElectronicMail_ParentProfile] FOREIGN KEY([ParentUniqueId])
REFERENCES [ParentPortal].[ParentProfile] ([ParentUniqueId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ParentPortal].[ParentProfileElectronicMail] CHECK CONSTRAINT [FK_ParentProfileElectronicMail_ParentProfile]
GO
ALTER TABLE [ParentPortal].[ParentProfileTelephone]  WITH CHECK ADD  CONSTRAINT [FK_ParentProfileTelephone_ParentProfile] FOREIGN KEY([ParentUniqueId])
REFERENCES [ParentPortal].[ParentProfile] ([ParentUniqueId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ParentPortal].[ParentProfileTelephone] CHECK CONSTRAINT [FK_ParentProfileTelephone_ParentProfile]
GO
ALTER TABLE [ParentPortal].[ParentProfileTelephone]  WITH CHECK ADD  CONSTRAINT [FK_ParentProfileTelephone_TelephoneNumberType] FOREIGN KEY([TelephoneNumberTypeId])
REFERENCES [edfi].[TelephoneNumberType] ([TelephoneNumberTypeId])
GO
ALTER TABLE [ParentPortal].[ParentProfileTelephone] CHECK CONSTRAINT [FK_ParentProfileTelephone_TelephoneNumberType]
GO
ALTER TABLE [ParentPortal].[ParentProfileTelephone]  WITH CHECK ADD  CONSTRAINT [FK_ParentProfileTelephone_CarrierType] FOREIGN KEY([TelephoneCarrierTypeId])
REFERENCES [ParentPortal].[TextMessageCarrierType] ([TextMessageCarrierTypeId])
GO
ALTER TABLE [ParentPortal].[ParentProfileTelephone] CHECK CONSTRAINT [FK_ParentProfileTelephone_CarrierType]
GO
ALTER TABLE [ParentPortal].[ParentProfile]  WITH CHECK ADD  CONSTRAINT [FK_ParentProfile_MethodOfContactType] FOREIGN KEY([PreferredMethodOfContactTypeId])
REFERENCES [ParentPortal].[MethodOfContactType] ([MethodOfContactTypeId])
GO
ALTER TABLE [ParentPortal].[ParentProfile] CHECK CONSTRAINT [FK_ParentProfile_MethodOfContactType]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A name given to an individual at birth, baptism, or during another naming ceremony, or through legal change.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfile', @level2type=N'COLUMN',@level2name=N'FirstName'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A secondary name given to an individual at birth, baptism, or during another naming ceremony.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfile', @level2type=N'COLUMN',@level2name=N'MiddleName'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name borne in common by members of a family.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfile', @level2type=N'COLUMN',@level2name=N'LastSurname'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A unique alphanumeric code assigned to a parent.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileAddress', @level2type=N'COLUMN',@level2name=N'ParentUniqueId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of address listed for an individual or organization.    For example:  Physical Address, Mailing Address, Home Address, etc.)' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileAddress', @level2type=N'COLUMN',@level2name=N'AddressTypeId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The street number and street name or post office box number of an address.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileAddress', @level2type=N'COLUMN',@level2name=N'StreetNumberName'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The apartment, room, or suite number of an address.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileAddress', @level2type=N'COLUMN',@level2name=N'ApartmentRoomSuiteNumber'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the city in which an address is located.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileAddress', @level2type=N'COLUMN',@level2name=N'City'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The abbreviation for the state (within the United States) or outlying area in which an address is located.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileAddress', @level2type=N'COLUMN',@level2name=N'StateAbbreviationTypeId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The five or nine digit zip code or overseas postal code portion of an address.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileAddress', @level2type=N'COLUMN',@level2name=N'PostalCode'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the county, parish, borough, or comparable unit (within a state) in which an address is located.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileAddress', @level2type=N'COLUMN',@level2name=N'NameOfCounty'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A unique alphanumeric code assigned to a parent.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileElectronicMail', @level2type=N'COLUMN',@level2name=N'ParentUniqueId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of email listed for an individual or organization. For example: Home/Personal, Work, etc.)' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileElectronicMail', @level2type=N'COLUMN',@level2name=N'ElectronicMailTypeId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The electronic mail (e-mail) address listed for an individual or organization.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileElectronicMail', @level2type=N'COLUMN',@level2name=N'ElectronicMailAddress'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'An indication that the electronic mail address should be used as the principal electronic mail address for an individual or organization.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileElectronicMail', @level2type=N'COLUMN',@level2name=N'PrimaryEmailAddressIndicator'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A unique alphanumeric code assigned to a parent.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileTelephone', @level2type=N'COLUMN',@level2name=N'ParentUniqueId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of communication number listed for an individual or organization.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileTelephone', @level2type=N'COLUMN',@level2name=N'TelephoneNumberTypeId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The telephone number including the area code, and extension, if applicable.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileTelephone', @level2type=N'COLUMN',@level2name=N'TelephoneNumber'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'An indication that the telephone number is technically capable of sending and receiving Short Message Service (SMS) text messages.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'ParentProfileTelephone', @level2type=N'COLUMN',@level2name=N'TextMessageCapabilityIndicator'
GO

/****** Object:  Table [ParentPortal].[StaffProfile]    Script Date: 1/12/2019 3:18:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[StaffProfile](
	[StaffUniqueId] [varchar](32) NOT NULL,
	[FirstName] [nvarchar](75) NOT NULL,
	[MiddleName] [nvarchar](75) NULL,
	[LastSurname] [nvarchar](75) NOT NULL,
	[NickName] [nvarchar](75) NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[PreferredMethodOfContactTypeId] [int] NOT NULL,
	[ReplyExpectations] [varchar](255) null,
	[LanguageCode] [nvarchar](10) null,
 CONSTRAINT [PK_StaffProfile] PRIMARY KEY CLUSTERED 
(
	[StaffUniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ParentPortal].[StaffProfileAddress]    Script Date: 1/12/2019 3:18:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[StaffProfileAddress](
	[StaffUniqueId] [varchar](32) NOT NULL,
	[AddressTypeId] [int] NOT NULL,
	[StreetNumberName] [nvarchar](150) NOT NULL,
	[ApartmentRoomSuiteNumber] [nvarchar](50) NULL,
	[City] [nvarchar](30) NOT NULL,
	[StateAbbreviationTypeId] [int] NOT NULL,
	[PostalCode] [nvarchar](17) NOT NULL,
	[NameOfCounty] [nvarchar](30) NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_StaffProfileAddress] PRIMARY KEY CLUSTERED 
(
	[StaffUniqueId] ASC,
	[AddressTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ParentPortal].[StaffProfileElectronicMail]    Script Date: 1/12/2019 3:18:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[StaffProfileElectronicMail](
	[StaffUniqueId] [varchar](32) NOT NULL,
	[ElectronicMailTypeId] [int] NOT NULL,
	[ElectronicMailAddress] [nvarchar](128) NOT NULL,
	[PrimaryEmailAddressIndicator] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_StaffProfileElectronicMail] PRIMARY KEY CLUSTERED 
(
	[StaffUniqueId] ASC,
	[ElectronicMailTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ParentPortal].[StaffProfileTelephone]    Script Date: 1/12/2019 3:18:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[StaffProfileTelephone](
	[StaffUniqueId] [varchar](32) NOT NULL,
	[TelephoneNumberTypeId] [int] NOT NULL,
	[TelephoneNumber] [nvarchar](24) NOT NULL,
	[TextMessageCapabilityIndicator] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[TelephoneCarrierTypeId] [int] NULL,
	[PrimaryMethodOfContact] [bit] NULL,
 CONSTRAINT [PK_StaffProfileTelephone] PRIMARY KEY CLUSTERED 
(
	[StaffUniqueId] ASC,
	[TelephoneNumberTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [ParentPortal].[StaffProfile] ADD  CONSTRAINT [DF_StaffProfile_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
ALTER TABLE [ParentPortal].[StaffProfileAddress] ADD  CONSTRAINT [DF_StaffProfileAddress_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
ALTER TABLE [ParentPortal].[StaffProfileElectronicMail] ADD  CONSTRAINT [DF_StaffProfileElectronicMail_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
ALTER TABLE [ParentPortal].[StaffProfileTelephone] ADD  CONSTRAINT [DF_StaffProfileTelephone_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [ParentPortal].[StaffProfile] ADD  CONSTRAINT [DF_StaffProfile_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
ALTER TABLE [ParentPortal].[StaffProfileAddress] ADD  CONSTRAINT [DF_StaffProfileAddress_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
ALTER TABLE [ParentPortal].[StaffProfileElectronicMail] ADD  CONSTRAINT [DF_StaffProfileElectronicMail_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
ALTER TABLE [ParentPortal].[StaffProfileTelephone] ADD  CONSTRAINT [DF_StaffProfileTelephone_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [ParentPortal].[StaffProfile]  WITH CHECK ADD  CONSTRAINT [FK_StaffProfile_MethodOfContactType] FOREIGN KEY([PreferredMethodOfContactTypeId])
REFERENCES [ParentPortal].[MethodOfContactType] ([MethodOfContactTypeId])
GO
ALTER TABLE [ParentPortal].[StaffProfile] CHECK CONSTRAINT [FK_StaffProfile_MethodOfContactType]
GO
ALTER TABLE [ParentPortal].[StaffProfileAddress]  WITH CHECK ADD  CONSTRAINT [FK_StaffProfileAddress_AddressType] FOREIGN KEY([AddressTypeId])
REFERENCES [edfi].[AddressType] ([AddressTypeId])
GO
ALTER TABLE [ParentPortal].[StaffProfileAddress] CHECK CONSTRAINT [FK_StaffProfileAddress_AddressType]
GO
ALTER TABLE [ParentPortal].[StaffProfileAddress]  WITH CHECK ADD  CONSTRAINT [FK_StaffProfileAddress_StaffProfile] FOREIGN KEY([StaffUniqueId])
REFERENCES [ParentPortal].[StaffProfile] ([StaffUniqueId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ParentPortal].[StaffProfileAddress] CHECK CONSTRAINT [FK_StaffProfileAddress_StaffProfile]
GO
ALTER TABLE [ParentPortal].[StaffProfileAddress]  WITH CHECK ADD  CONSTRAINT [FK_StaffProfileAddress_StateAbbreviationType] FOREIGN KEY([StateAbbreviationTypeId])
REFERENCES [edfi].[StateAbbreviationType] ([StateAbbreviationTypeId])
GO
ALTER TABLE [ParentPortal].[StaffProfileAddress] CHECK CONSTRAINT [FK_StaffProfileAddress_StateAbbreviationType]
GO
ALTER TABLE [ParentPortal].[StaffProfileElectronicMail]  WITH CHECK ADD  CONSTRAINT [FK_StaffProfileElectronicMail_ElectronicMailType] FOREIGN KEY([ElectronicMailTypeId])
REFERENCES [edfi].[ElectronicMailType] ([ElectronicMailTypeId])
GO
ALTER TABLE [ParentPortal].[StaffProfileElectronicMail] CHECK CONSTRAINT [FK_StaffProfileElectronicMail_ElectronicMailType]
GO
ALTER TABLE [ParentPortal].[StaffProfileElectronicMail]  WITH CHECK ADD  CONSTRAINT [FK_StaffProfileElectronicMail_StaffProfile] FOREIGN KEY([StaffUniqueId])
REFERENCES [ParentPortal].[StaffProfile] ([StaffUniqueId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ParentPortal].[StaffProfileElectronicMail] CHECK CONSTRAINT [FK_StaffProfileElectronicMail_StaffProfile]
GO
ALTER TABLE [ParentPortal].[StaffProfileTelephone]  WITH CHECK ADD  CONSTRAINT [FK_StaffProfileTelephone_StaffProfile] FOREIGN KEY([StaffUniqueId])
REFERENCES [ParentPortal].[StaffProfile] ([StaffUniqueId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ParentPortal].[StaffProfileTelephone] CHECK CONSTRAINT [FK_StaffProfileTelephone_StaffProfile]
GO
ALTER TABLE [ParentPortal].[StaffProfileTelephone]  WITH CHECK ADD  CONSTRAINT [FK_StaffProfileTelephone_TelephoneNumberType] FOREIGN KEY([TelephoneNumberTypeId])
REFERENCES [edfi].[TelephoneNumberType] ([TelephoneNumberTypeId])
GO
ALTER TABLE [ParentPortal].[StaffProfileTelephone] CHECK CONSTRAINT [FK_StaffProfileTelephone_TelephoneNumberType]
GO
ALTER TABLE [ParentPortal].[StaffProfileTelephone]  WITH CHECK ADD  CONSTRAINT [FK_StaffProfileTelephone_CarrierType] FOREIGN KEY([TelephoneCarrierTypeId])
REFERENCES [ParentPortal].[TextMessageCarrierType] ([TextMessageCarrierTypeId])
GO
ALTER TABLE [ParentPortal].[StaffProfileTelephone] CHECK CONSTRAINT [FK_StaffProfileTelephone_CarrierType]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A name given to an individual at birth, baptism, or during another naming ceremony, or through legal change.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfile', @level2type=N'COLUMN',@level2name=N'FirstName'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A secondary name given to an individual at birth, baptism, or during another naming ceremony.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfile', @level2type=N'COLUMN',@level2name=N'MiddleName'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name borne in common by members of a family.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfile', @level2type=N'COLUMN',@level2name=N'LastSurname'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A unique alphanumeric code assigned to a staff.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileAddress', @level2type=N'COLUMN',@level2name=N'StaffUniqueId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of address listed for an individual or organization.    For example:  Physical Address, Mailing Address, Home Address, etc.)' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileAddress', @level2type=N'COLUMN',@level2name=N'AddressTypeId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The street number and street name or post office box number of an address.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileAddress', @level2type=N'COLUMN',@level2name=N'StreetNumberName'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The apartment, room, or suite number of an address.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileAddress', @level2type=N'COLUMN',@level2name=N'ApartmentRoomSuiteNumber'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the city in which an address is located.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileAddress', @level2type=N'COLUMN',@level2name=N'City'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The abbreviation for the state (within the United States) or outlying area in which an address is located.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileAddress', @level2type=N'COLUMN',@level2name=N'StateAbbreviationTypeId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The five or nine digit zip code or overseas postal code portion of an address.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileAddress', @level2type=N'COLUMN',@level2name=N'PostalCode'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the county, parish, borough, or comparable unit (within a state) in which an address is located.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileAddress', @level2type=N'COLUMN',@level2name=N'NameOfCounty'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A unique alphanumeric code assigned to a staff.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileElectronicMail', @level2type=N'COLUMN',@level2name=N'StaffUniqueId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of email listed for an individual or organization. For example: Home/Personal, Work, etc.)' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileElectronicMail', @level2type=N'COLUMN',@level2name=N'ElectronicMailTypeId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The electronic mail (e-mail) address listed for an individual or organization.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileElectronicMail', @level2type=N'COLUMN',@level2name=N'ElectronicMailAddress'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'An indication that the electronic mail address should be used as the principal electronic mail address for an individual or organization.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileElectronicMail', @level2type=N'COLUMN',@level2name=N'PrimaryEmailAddressIndicator'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A unique alphanumeric code assigned to a staff.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileTelephone', @level2type=N'COLUMN',@level2name=N'StaffUniqueId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of communication number listed for an individual or organization.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileTelephone', @level2type=N'COLUMN',@level2name=N'TelephoneNumberTypeId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The telephone number including the area code, and extension, if applicable.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileTelephone', @level2type=N'COLUMN',@level2name=N'TelephoneNumber'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'An indication that the telephone number is technically capable of sending and receiving Short Message Service (SMS) text messages.' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'StaffProfileTelephone', @level2type=N'COLUMN',@level2name=N'TextMessageCapabilityIndicator'
GO

/*DATA*/
SET IDENTITY_INSERT [ParentPortal].[MethodOfContactType] ON 
INSERT [ParentPortal].[MethodOfContactType] ([MethodOfContactTypeId], [Description], [ShortDescription], [CreateDate], [LastModifiedDate], [Id]) VALUES (1, N'Email', N'Email', CAST(N'2018-11-23T17:16:51.620' AS DateTime), CAST(N'2018-11-23T17:16:51.620' AS DateTime), N'5d98c5aa-e244-421f-9439-6b50648e34ca');
INSERT [ParentPortal].[MethodOfContactType] ([MethodOfContactTypeId], [Description], [ShortDescription], [CreateDate], [LastModifiedDate], [Id]) VALUES (2, N'SMS Text Message', N'SMS', CAST(N'2018-11-23T17:16:58.227' AS DateTime), CAST(N'2018-11-23T17:16:58.227' AS DateTime), N'24919a67-a67d-4ac3-bcd4-d2b33a7e75f2');
SET IDENTITY_INSERT [ParentPortal].[MethodOfContactType] OFF
GO
SET IDENTITY_INSERT [ParentPortal].[AlertType] ON 
INSERT [ParentPortal].[AlertType] ([AlertTypeId], [Description], [ShortDescription], [CreateDate], [LastModifiedDate], [Id]) VALUES (1, N'Absence Alert', N'Absence', CAST(N'2018-11-23T17:15:42.257' AS DateTime), CAST(N'2018-11-23T17:15:42.257' AS DateTime), N'1485e0aa-5c20-42d0-8541-d06ca28630fa');
INSERT [ParentPortal].[AlertType] ([AlertTypeId], [Description], [ShortDescription], [CreateDate], [LastModifiedDate], [Id]) VALUES (2, N'Behavior Alert', N'Behavior', CAST(N'2018-11-23T17:16:03.023' AS DateTime), CAST(N'2018-11-23T17:16:03.023' AS DateTime), N'cf5a7c3e-1157-4209-b594-c933c68b43af');
INSERT INTO [ParentPortal].[AlertType] (AlertTypeId, Description, ShortDescription) VALUES (3, 'Missing Assignment Alert', 'Assignment');
INSERT INTO [ParentPortal].[AlertType] (AlertTypeId, Description, ShortDescription) VALUES (4, 'Course Grade Alert', 'Course Grade');
INSERT INTO [ParentPortal].[AlertType] (AlertTypeId, Description, ShortDescription) VALUES (5, 'Unread Message Alert', 'Unread Message');
SET IDENTITY_INSERT [ParentPortal].[AlertType] OFF
GO
INSERT [ParentPortal].[ParentAlert] ([ParentUniqueId], [AlertsEnabled], [CreateDate]) VALUES ('778657', 1, CAST(N'2018-11-23T17:23:13.997' AS DateTime));
INSERT [ParentPortal].[ParentAlertAssociation] ([ParentUniqueId], [AlertTypeId]) VALUES ('778657', 1);
GO
SET IDENTITY_INSERT [ParentPortal].[TextMessageCarrierType] ON 
INSERT [ParentPortal].[TextMessageCarrierType] ([TextMessageCarrierTypeId], [Description], [ShortDescription], [SmsSuffixDomain], [MmsSuffixDomain], [CreateDate], [LastModifiedDate], [Id]) VALUES (1, N'AT&T', N'AT&T', N'@txt.att.net', N'@mms.att.net', CAST(N'2018-11-27T10:40:34.423' AS DateTime), CAST(N'2018-11-27T10:40:34.423' AS DateTime), N'10c5a5eb-3e57-4e34-a739-50a69e9829a0');
INSERT [ParentPortal].[TextMessageCarrierType] ([TextMessageCarrierTypeId], [Description], [ShortDescription], [SmsSuffixDomain], [MmsSuffixDomain], [CreateDate], [LastModifiedDate], [Id]) VALUES (2, N'Boost Mobile', N'Boost Mobile', N'@smsmyboostmobile.com', N'@myboostmobile.com', CAST(N'2018-11-27T10:40:34.423' AS DateTime), CAST(N'2018-11-27T10:40:34.423' AS DateTime), N'ea4b8f7f-2cf5-4262-83d9-09e3b457e55c');
INSERT [ParentPortal].[TextMessageCarrierType] ([TextMessageCarrierTypeId], [Description], [ShortDescription], [SmsSuffixDomain], [MmsSuffixDomain], [CreateDate], [LastModifiedDate], [Id]) VALUES (3, N'Cricket', N'Cricket', N'@sms.cricketwireless.net', N'@mms.cricketwireless.net', CAST(N'2018-11-27T10:40:34.423' AS DateTime), CAST(N'2018-11-27T10:40:34.423' AS DateTime), N'5b6de159-4973-453c-918c-eaaa59deb2db');
INSERT [ParentPortal].[TextMessageCarrierType] ([TextMessageCarrierTypeId], [Description], [ShortDescription], [SmsSuffixDomain], [MmsSuffixDomain], [CreateDate], [LastModifiedDate], [Id]) VALUES (4, N'Sprint', N'Sprint', N'@messaging.sprintpcs.com', N'@pm.sprint.com', CAST(N'2018-11-27T10:40:34.423' AS DateTime), CAST(N'2018-11-27T10:40:34.423' AS DateTime), N'a417aca6-24b1-49e1-a8e2-f1fd08b32425');
INSERT [ParentPortal].[TextMessageCarrierType] ([TextMessageCarrierTypeId], [Description], [ShortDescription], [SmsSuffixDomain], [MmsSuffixDomain], [CreateDate], [LastModifiedDate], [Id]) VALUES (5, N'T-Mobile', N'T-Mobile', N'@tmomail.net', N'@tmomail.net', CAST(N'2018-11-27T10:40:34.423' AS DateTime), CAST(N'2018-11-27T10:40:34.423' AS DateTime), N'082c5c06-ab01-46bc-b291-f639dda90549');
INSERT [ParentPortal].[TextMessageCarrierType] ([TextMessageCarrierTypeId], [Description], [ShortDescription], [SmsSuffixDomain], [MmsSuffixDomain], [CreateDate], [LastModifiedDate], [Id]) VALUES (6, N'U.S. Cellular', N'U.S. Cellular', N'@email.uscc.net', N'@mms.uscc.net', CAST(N'2018-11-27T10:40:34.427' AS DateTime), CAST(N'2018-11-27T10:40:34.427' AS DateTime), N'd1d107c7-cc68-441e-ac53-00310a4f843c');
INSERT [ParentPortal].[TextMessageCarrierType] ([TextMessageCarrierTypeId], [Description], [ShortDescription], [SmsSuffixDomain], [MmsSuffixDomain], [CreateDate], [LastModifiedDate], [Id]) VALUES (7, N'Verizon', N'Verizon', N'@vtext.com', N'@vzwpix.com', CAST(N'2018-11-27T10:40:34.427' AS DateTime), CAST(N'2018-11-27T10:40:34.427' AS DateTime), N'92020e5a-dd07-4bcd-a09f-f1aa77865309');
INSERT [ParentPortal].[TextMessageCarrierType] ([TextMessageCarrierTypeId], [Description], [ShortDescription], [SmsSuffixDomain], [MmsSuffixDomain], [CreateDate], [LastModifiedDate], [Id]) VALUES (8, N'Virgin Mobile', N'Virgin Mobile', N'@vmobl.com', N'@vmpix.com', CAST(N'2018-11-27T10:40:34.427' AS DateTime), CAST(N'2018-11-27T10:40:34.427' AS DateTime), N'b0546971-e991-4825-8211-0b799a37d289');
SET IDENTITY_INSERT [ParentPortal].[TextMessageCarrierType] OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[AlertTypeThresholdAssociation](
	[AlertTypeId] [int] NOT NULL,
	[ThresholdTypeId] [int] NOT NULL,
 CONSTRAINT [PK_AlertType_ThresholdType] PRIMARY KEY CLUSTERED 
(
	[AlertTypeId] ASC,
	[ThresholdTypeId]
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[ThresholdType](
	[ThresholdTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
	[ShortDescription] [nvarchar](450) NOT NULL,
	[ThresholdValue] [decimal](6,2) NOT NULL,
	[WhatCanParentDo] [nvarchar](MAX) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ThresholdType] PRIMARY KEY CLUSTERED 
(
	[ThresholdTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [ParentPortal].[AlertTypeThresholdAssociation]  WITH CHECK ADD  CONSTRAINT [FK_AlertTypeThresholdAssociation_Threshold] FOREIGN KEY([ThresholdTypeId])
REFERENCES [ParentPortal].[ThresholdType] ([ThresholdTypeId])
GO
ALTER TABLE [ParentPortal].[AlertTypeThresholdAssociation] CHECK CONSTRAINT [FK_AlertTypeThresholdAssociation_Threshold]
GO
ALTER TABLE [ParentPortal].[AlertTypeThresholdAssociation]  WITH CHECK ADD  CONSTRAINT [FK_AlertTypeThresholdAssociation_AlertType] FOREIGN KEY([AlertTypeId])
REFERENCES [ParentPortal].[AlertType] ([AlertTypeId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ParentPortal].[AlertTypeThresholdAssociation] CHECK CONSTRAINT [FK_AlertTypeThresholdAssociation_AlertType]
GO

GO
ALTER TABLE [ParentPortal].[ThresholdType] ADD  CONSTRAINT [ThresholdType_DF_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [ParentPortal].[ThresholdType] ADD  CONSTRAINT [ThresholdType_DF_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [ParentPortal].[ThresholdType] ADD  CONSTRAINT [ThresholdType_DF_Id]  DEFAULT (newid()) FOR [Id]
GO

SET IDENTITY_INSERT [ParentPortal].[ThresholdType] ON 
GO
INSERT INTO [ParentPortal].[ThresholdType](ThresholdTypeId, Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES(1, 'Unexcused Absence Threshold', 'Unexcused Absence', 5, 'At YES Prep, your child’s education is our #1 priority.   In order to achieve our goals as educators, we need students in school, on time, every day.  If a student has three or more unexcused absences for three or more days or parts of days, we want to connect with you as the parent or guardian to identify what barriers prevent your child from attending school regularly.  You can connect with your child’s Student Support Counselor to discuss the current number of absences, rectify any errors (excused absences), and possibly develop an attendance plan that outlines how the campus and family can work in partnership support your child’s regular participation in school.  Please note that according to Texas Education Agency (Section 25.093), it is an offense for a parent to contribute to nonattendance and YES Prep is required to notify the Courts of truancy if there a lack of compliance after notice of excessive absences.');
INSERT INTO [ParentPortal].[ThresholdType](ThresholdTypeId, Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES(2, 'Excused Absence Threshold', 'Excused Absence', 3, 'At YES Prep, your child’s education is our #1 priority.   In order to achieve our goals as educators, we need students in school, on time, every day.  If a student has three or more unexcused absences for three or more days or parts of days, we want to connect with you as the parent or guardian to identify what barriers prevent your child from attending school regularly.  You can connect with your child’s Student Support Counselor to discuss the current number of absences, rectify any errors (excused absences), and possibly develop an attendance plan that outlines how the campus and family can work in partnership support your child’s regular participation in school.  Please note that according to Texas Education Agency (Section 25.093), it is an offense for a parent to contribute to nonattendance and YES Prep is required to notify the Courts of truancy if there a lack of compliance after notice of excessive absences.');
INSERT INTO [ParentPortal].[ThresholdType](ThresholdTypeId, Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES(3, 'Tardy Threshold', 'Tardy', 10, 'At YES Prep, your child’s education is our #1 priority.   In order to achieve our goals as educators, we need students in school, on time, every day.  If a student has three or more unexcused absences for three or more days or parts of days, we want to connect with you as the parent or guardian to identify what barriers prevent your child from attending school regularly.  You can connect with your child’s Student Support Counselor to discuss the current number of absences, rectify any errors (excused absences), and possibly develop an attendance plan that outlines how the campus and family can work in partnership support your child’s regular participation in school.  Please note that according to Texas Education Agency (Section 25.093), it is an offense for a parent to contribute to nonattendance and YES Prep is required to notify the Courts of truancy if there a lack of compliance after notice of excessive absences.');
INSERT INTO [ParentPortal].[ThresholdType](ThresholdTypeId, Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES(4, 'Discipline Incidents Threshold', 'Discipline', 1, 'YES Prep students are expected to behave in a manner that promotes respect for all individuals, contributes to a safe environment for students, and provides an educational environment free of disruption. <br><br> Collaborating with our parents around student behavior is an important part of the YES Prep community.  We hope to meet with you to discuss your student’s behavior further to ensure we are all working towards providing your student with the supports necessary to be successful behaviorally and academically.  If you have not scheduled a meeting with your students Dean of Students, please reach out to the front office.');
INSERT INTO [ParentPortal].[ThresholdType](ThresholdTypeId, Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES(5, 'Missing Assignment Threshold', 'Assignment', 3,'In order to progress towards promotion, graduation, and college readiness, students should be succeeding in their coursework.  Based on the number of missing assignments, the following actions are recommended. <ul><li> Review your child''s agenda nightly.</li><li>Provide your child with a designated time and space to study and do homework.</li><li>Ensure you have an active account in Home Access Center and check students’ progress regularly.</li><li>Refer to the teacher’s makeup policy to determine if there are any assignments that can be made up.</li></ul> Ensure your student is present at school on time, every day so that they are not missing instruction and important assignments.');
INSERT INTO [ParentPortal].[ThresholdType](ThresholdTypeId, Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES(6, 'Course Average Threshold', 'Course', 70, 'In order to progress towards promotion, graduation, and college readiness, students should be succeeding in their coursework.  Based on your child''s current grades, the following actions are recommended. <ul><li>Your child should attend tutorials when available.</li><li>Refer to the teacher’s reassessment policy to determine if there are any reassessment opportunities.</li><li>Ensure you have an active account in Home Access Center and check students’ progress regularly.</li><li>Provide your child with a designated time and space to study and do homework.</li><li>Set a goal with your child and monitor progress toward that goal.</li></ul>');
GO
SET IDENTITY_INSERT [ParentPortal].[ThresholdType] OFF
GO
INSERT INTO [ParentPortal].[AlertTypeThresholdAssociation] VALUES (1,1),(1,2),(1,3),(2,4),(3,5),(4,6);
GO
/****** Object:  Table [ParentPortal].[ChatLog]    Script Date: 3/22/2019 11:51:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[ChatLog](
	[StudentUniqueId] [nvarchar](32) NOT NULL,
	[SenderTypeId] [int] not null,
	[SenderUniqueId] [nvarchar](32) NOT NULL,
	[RecipientTypeId] [int] not null,
	[RecipientUniqueId] [nvarchar](32) NOT NULL,
	[OriginalMessage] [nvarchar](MAX) NOT NULL,
	[EnglishMessage] [nvarchar](MAX) NULL,
	[DateSent] [datetime] NOT NULL,
	[RecipientHasRead] bit NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [ChatLog_PK] PRIMARY KEY CLUSTERED 
(
	[StudentUniqueId] ASC,
	[SenderTypeId],
	[SenderUniqueId],
	[RecipientTypeId],
	[RecipientUniqueId],
	[DateSent]
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [ParentPortal].[ChatLog] ADD  CONSTRAINT [DF_ChatLog_CreateDate]  DEFAULT (getdate()) FOR [DateSent];
GO
ALTER TABLE [ParentPortal].[ChatLog] ADD  CONSTRAINT [ChatLog_DF_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [ParentPortal].[ChatLog] ADD  CONSTRAINT [DF_ChatLog_RecipientHasRead]  DEFAULT (0) FOR [RecipientHasRead];
GO

/****** Object:  Table [ParentPortal].[[ThresholdType]]    Script Date: 05/02/2019 3:50:00 PM ******/
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[ChatLogPersonType](
	[ChatLogPersonTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
	[ShortDescription] [nvarchar](450) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ChatLogPersonType] PRIMARY KEY CLUSTERED 
(
	[ChatLogPersonTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [ParentPortal].[ChatLogPersonType] ADD  CONSTRAINT [DF_ChatLogPersonType_CreateDate]  DEFAULT (getdate()) FOR [CreateDate];
GO
ALTER TABLE [ParentPortal].[ChatLogPersonType] ADD  CONSTRAINT [ChatLogPersonType_DF_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [ParentPortal].[ChatLogPersonType] ADD  CONSTRAINT [ChatLogPersonType_DF_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [ParentPortal].[ChatLog]  WITH CHECK ADD  CONSTRAINT [FK_ChatLog_RecipientType] FOREIGN KEY([RecipientTypeId])
REFERENCES [ParentPortal].[ChatLogPersonType] ([ChatLogPersonTypeId])
GO
ALTER TABLE [ParentPortal].[ChatLog] CHECK CONSTRAINT [FK_ChatLog_RecipientType]
GO
ALTER TABLE [ParentPortal].[ChatLog]  WITH CHECK ADD  CONSTRAINT [FK_ChatLog_SenderType] FOREIGN KEY([SenderTypeId])
REFERENCES [ParentPortal].[ChatLogPersonType] ([ChatLogPersonTypeId])
GO
ALTER TABLE [ParentPortal].[ChatLog] CHECK CONSTRAINT [FK_ChatLog_SenderType]
GO

SET IDENTITY_INSERT [ParentPortal].[ChatLogPersonType] ON 
GO
INSERT INTO [ParentPortal].[ChatLogPersonType](ChatLogPersonTypeId,Description,ShortDescription) VALUES (1, 'Parent', 'Parent'), (2, 'Staff', 'Staff');    
GO
SET IDENTITY_INSERT [ParentPortal].[ChatLogPersonType] OFF
GO
/****** Object:  Table [ParentPortal].[AppOffline]    Script Date: 4/29/2019 3:40:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ParentPortal].[AppOffline](
	[IsAppOffline] [bit] NOT NULL
) ON [PRIMARY]
GO
/*Set Default to NOT offline*/
INSERT INTO [ParentPortal].[AppOffline] (IsAppOffline) VALUES (0);
GO
/****** Object:  Table [ParentPortal].[FeedbackLog]    Script Date: 5/03/2019 2:40:0 PM ******/
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[FeedbackLog] (
	[FeedbackLogId] [int] IDENTITY(1,1) NOT NULL,
	[PersonUniqueId] [nvarchar](32) NOT NULL,
	[PersonTypeId] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](128) NOT NULL,
	[Subject] [nvarchar](128) NOT NULL,
	[Issue] [nvarchar](128) NOT NULL,
	[CurrentUrl] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](MAX) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FeedbackLog] PRIMARY KEY CLUSTERED 
(
	[FeedbackLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [ParentPortal].[FeedbackLog] ADD  CONSTRAINT [DF_FeedbackLog_CreateDate]  DEFAULT (getdate()) FOR [CreateDate];
GO
ALTER TABLE [ParentPortal].[FeedbackLog] ADD  CONSTRAINT [FeedbackLog_DF_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [ParentPortal].[FeedbackLog] ADD  CONSTRAINT [FeedbackLog_DF_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [ParentPortal].[FeedbackLog]  WITH CHECK ADD  CONSTRAINT [FK_FeedbackLog_PersonType] FOREIGN KEY([PersonTypeId])
REFERENCES [ParentPortal].[ChatLogPersonType] ([ChatLogPersonTypeId])
GO
ALTER TABLE [ParentPortal].[FeedbackLog] CHECK CONSTRAINT [FK_FeedbackLog_PersonType]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[SpotlightIntegration](
	[StudentUniqueId] [nvarchar](32) NOT NULL,
	[Url] [nvarchar](MAX) NOT NULL,
	[UrlTypeId] [int] NOT NULL,
 CONSTRAINT [PK_SpotlightIntegration] PRIMARY KEY CLUSTERED 
(
	[StudentUniqueId] ASC,
	[UrlTypeId]
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ParentPortal].[UrlType](
	[UrlTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
	[ShortDescription] [nvarchar](450) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_UrlType] PRIMARY KEY CLUSTERED 
(
	[UrlTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [ParentPortal].[UrlType] ADD  CONSTRAINT [DF_UrlType_CreateDate]  DEFAULT (getdate()) FOR [CreateDate];
GO
ALTER TABLE [ParentPortal].[UrlType] ADD  CONSTRAINT [UrlType_DF_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [ParentPortal].[UrlType] ADD  CONSTRAINT [UrlType_DF_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [ParentPortal].[SpotlightIntegration]  WITH CHECK ADD  CONSTRAINT [FK_SpotlightIntegration_UrlType] FOREIGN KEY([UrlTypeId])
REFERENCES [ParentPortal].[UrlType] ([UrlTypeId])
GO
ALTER TABLE [ParentPortal].[SpotlightIntegration] CHECK CONSTRAINT [FK_SpotlightIntegration_UrlType]
GO
SET IDENTITY_INSERT [ParentPortal].[UrlType] ON 
GO
INSERT INTO [ParentPortal].[UrlType](UrlTypeId,Description,ShortDescription) VALUES (1, 'Video Url', 'Video'), (2, 'PDF Url', 'PDF');    
GO
SET IDENTITY_INSERT [ParentPortal].[UrlType] OFF
GO

CREATE VIEW ParentPortal.StudentABCSummary AS
SELECT s.StudentUsi, s.StudentUniqueId, s.FirstName, s.MiddleName, s.LastSurname,
-- Sex Type --
	(SELECT ShortDescription FROM edfi.SexType
			WHERE SexTypeId = s.SexTypeId) as  [SexType],
-- GPA --
	(SELECT TOP(1) sar.CumulativeGradePointAverage FROM edfi.StudentAcademicRecord as sar
			WHERE StudentUSI = s.StudentUSI
			ORDER BY sar.SchoolYear desc, sar.TermDescriptorId desc) as [Gpa],
-- Grade Level --
(SELECT TOP(1) gt.ShortDescription FROM edfi.StudentSchoolAssociation as ssa
		inner join edfi.GradeLevelDescriptor as gld on ssa.EntryGradeLevelDescriptorId = gld.GradeLevelDescriptorId
		inner join edfi.GradeLevelType as gt on gld.GradeLevelTypeId = gt.GradeLevelTypeId
		where ssa.StudentUSI = s.StudentUsi
		order by ssa.EntryDate desc) as [GradeLevel],
-- Absences Count --
 (SELECT COUNT(*) AS Expr1 
		FROM edfi.StudentSchoolAttendanceEvent AS ssae 
		INNER JOIN edfi.SchoolYearType AS sy ON ssae.SchoolYear = sy.SchoolYear
		INNER JOIN edfi.Descriptor as aecd on ssae.AttendanceEventCategoryDescriptorId = aecd.DescriptorId
		WHERE (sy.CurrentSchoolYear = 1) 
			AND (ssae.StudentUSI = s.StudentUSI)
			AND (aecd.CodeValue NOT IN ('In Attendance'))) as [Absences],
-- Missing Assignment Count --
  (SELECT Count(*) 
	FROM edfi.GradebookEntry as gbe
		INNER JOIN edfi.GradebookEntryType as getd
			on gbe.GradebookEntryTypeId = getd.GradebookEntryTypeId
		INNER JOIN edfi.StudentSectionAssociation as ssa
			on ssa.SchoolId = gbe.SchoolId
			AND ssa.SchoolYear = gbe.SchoolYear
			AND ssa.ClassroomIdentificationCode = gbe.ClassroomIdentificationCode
			AND ssa.LocalCourseCode = gbe.LocalCourseCode
			AND ssa.ClassPeriodName = gbe.ClassPeriodName
			AND ssa.UniqueSectionCode = gbe.UniqueSectionCode
			AND ssa.SequenceOfCourse = gbe.SequenceOfCourse
			AND ssa.TermDescriptorId = gbe.TermDescriptorId
		LEFT JOIN edfi.StudentGradebookEntry as sgbe
		    on sgbe.DateAssigned = gbe.DateAssigned
			AND sgbe.StudentUSI = ssa.StudentUSI
			AND sgbe.GradebookEntryTitle = gbe.GradebookEntryTitle
			AND sgbe.LocalCourseCode = gbe.LocalCourseCode
			AND sgbe.SchoolId = gbe.SchoolId
			AND sgbe.SchoolYear = gbe.SchoolYear
			AND sgbe.ClassroomIdentificationCode = gbe.ClassroomIdentificationCode
			AND sgbe.ClassPeriodName = gbe.ClassPeriodName
			AND sgbe.UniqueSectionCode = gbe.UniqueSectionCode
			AND sgbe.SequenceOfCourse = gbe.SequenceOfCourse
			AND sgbe.TermDescriptorId = gbe.TermDescriptorId
			AND ssa.BeginDate = sgbe.BeginDate
		WHERE  sgbe.DateFulfilled IS NULL 
			AND ssa.StudentUSI = s.StudentUSI
			AND sgbe.LetterGradeEarned = 'M'
			AND gbe.GradebookEntryTypeId IS NOT NULL
			AND getd.CodeValue IN  ('Assignment', 'Homework')
			AND gbe.SchoolYear = (SELECT SchoolYear FROM edfi.SchoolYearType WHERE( CurrentSchoolYear = 1)))
			as [MissingAssignments],
-- Discipline Incident Count --
(SELECT Count(*) 
	FROM edfi.StudentDisciplineIncidentAssociation as sdia
		inner join edfi.DisciplineIncident as di
			on sdia.IncidentIdentifier = di.IncidentIdentifier
			AND sdia.SchoolId = di.SchoolId
		inner join edfi.StudentParticipationCodeType as d
			on sdia.StudentParticipationCodeTypeId = d.StudentParticipationCodeTypeId
		WHERE d.CodeValue = 'Perpetrator'
			AND sdia.StudentUSI = s.StudentUSI
			AND di.IncidentDate >= (SELECT MAX(BeginDate) FROM edfi.Session WHERE SchoolId = sdia.SchoolId )) 
			as [DisciplineIncidents],
-- Grading Period Average --
(SELECT AVG(g.NumericGradeEarned) from edfi.Grade as g
		inner join edfi.GradeType as gt
			on g.GradeTypeId = gt.GradeTypeId
		inner join edfi.Descriptor as gpd
			on g.GradingPeriodDescriptorId = gpd.DescriptorId
		inner join edfi.SchoolYearType as sy
			on g.SchoolYear = sy.SchoolYear
		WHERE g.StudentUSI = s.StudentUSI
			AND sy.CurrentSchoolYear = 1
			AND  gt.CodeValue = 'Grading Period'
			AND g.NumericGradeEarned IS NOT NULL)
			as [GradingPeriodAvg],
-- Exam Average --
(SELECT AVG(g.NumericGradeEarned) from edfi.Grade as g
		inner join edfi.GradeType as gt
			on g.GradeTypeId = gt.GradeTypeId
		inner join edfi.Descriptor as gpd
			on g.GradingPeriodDescriptorId = gpd.DescriptorId
		inner join edfi.SchoolYearType as sy
			on g.SchoolYear = sy.SchoolYear
		WHERE g.StudentUSI = s.StudentUSI
			AND sy.CurrentSchoolYear = 1
			AND  gt.CodeValue = 'Exam'
			AND g.NumericGradeEarned IS NOT NULL)
			as [ExamAvg],
-- Semester Average --
(SELECT AVG(g.NumericGradeEarned) from edfi.Grade as g
		inner join edfi.GradeType as gt
			on g.GradeTypeId = gt.GradeTypeId
		inner join edfi.Descriptor as gpd
			on g.GradingPeriodDescriptorId = gpd.DescriptorId
		inner join edfi.SchoolYearType as sy
			on g.SchoolYear = sy.SchoolYear
		WHERE g.StudentUSI = s.StudentUSI
			AND sy.CurrentSchoolYear = 1
			AND  gt.CodeValue = 'Semester'
			AND g.NumericGradeEarned IS NOT NULL)
			as [SemesterAvg],
-- Final Average --
(SELECT AVG(g.NumericGradeEarned) FROM edfi.Grade as g
		inner join edfi.GradeType as gt
			on g.GradeTypeId = gt.GradeTypeId
		inner join edfi.Descriptor as gpd
			on g.GradingPeriodDescriptorId = gpd.DescriptorId
		inner join edfi.SchoolYearType as sy
			on g.SchoolYear = sy.SchoolYear
		WHERE g.StudentUSI = s.StudentUSI
			AND sy.CurrentSchoolYear = 1
			AND  gt.CodeValue = 'Final'
			AND g.NumericGradeEarned IS NOT NULL)
			as [FinalAvg]
FROM edfi.Student as s;
GO
CREATE TABLE [ParentPortal].[Logs](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[LogMessage] [nvarchar](MAX) NOT NULL,
	[LogType] [nvarchar](450) NOT NULL,
	[DateTimeOfEvent] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [ParentPortal].[Logs] ADD  CONSTRAINT [DF_Logs_DateTimeOfEvent]  DEFAULT (getdate()) FOR [DateTimeOfEvent];
GO
ALTER TABLE [ParentPortal].[Logs] ADD  CONSTRAINT [Logs_DF_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [ParentPortal].[Logs] ADD  CONSTRAINT [Logs_DF_Id]  DEFAULT (newid()) FOR [Id]
GO

CREATE TABLE [ParentPortal].[NotificationsToken](
	[NotificationTokenUSI] [int] IDENTITY(1,1) NOT NULL,
	[PersonUniqueId] [nvarchar](32) NOT NULL,
	[PersonType] [nvarchar](8) NOT NULL,
	[DeviceUUID] [nvarchar](100) NOT NULL,
	[Token] [nvarchar](500) NOT NULL,
	[CreateDate] [datetime2](7) NOT NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_NotificationsToken] PRIMARY KEY CLUSTERED 
(
	[NotificationTokenUSI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [ParentPortal].[MethodOfContactType]
           ([Description]
           ,[ShortDescription]
           )
     VALUES
           ('Push Notifications'
           ,'Push Notifications')
GO

 /****** Object:  Table [ParentPortal].[Admin]    Script Date: 3/4/2020 2:50:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ParentPortal].[Admin](
	[AdminUSI] [int] IDENTITY(1,1) NOT NULL,
	[ElectronicMailAddress] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime2](7) NOT NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Admin] PRIMARY KEY CLUSTERED 
(
	[AdminUSI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [ParentPortal].[GroupMessagesQueueLog]    Script Date: 5/5/2020 7:38:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ParentPortal].[GroupMessagesQueueLog](
	[Id] [uniqueidentifier] NOT NULL,
	[Type] [nvarchar](20) NOT NULL,
	[QueuedDateTime] [datetime] NOT NULL,
	[StaffUniqueIdSent] [nvarchar](50) NOT NULL,
	[SchoolId] [int] NOT NULL,
	[Audience] [nvarchar](1000) NOT NULL,
	[FilterParams] [nvarchar](max) NULL,
	[Subject] [nvarchar](250) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[SentStatus] [int] NOT NULL,
	[RetryCount] [int] NOT NULL,
	[Data] [nvarchar](max) NOT NULL,
	[DateSent] [datetime] NULL,
 CONSTRAINT [PK_GroupMessagesQueueLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [ParentPortal].[GroupMessagesQueueLog] ADD  CONSTRAINT [GroupMessagesQueueLog_DF_Id]  DEFAULT (newid()) FOR [Id]
GO

/****** Object:  Table [ParentPortal].[GroupMessagesLogChatLog]    Script Date: 5/7/2020 8:17:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ParentPortal].[GroupMessagesLogChatLog](
	[GroupMessagesLogId] [uniqueidentifier] NOT NULL,
	[ChatLogId] [uniqueidentifier] NOT NULL,
	[Status] [int] NOT NULL,
	[ErrorMessage] [nvarchar](500) NULL
) ON [PRIMARY]
GO

ALTER TABLE [ParentPortal].[GroupMessagesLogChatLog]  WITH CHECK ADD  CONSTRAINT [FK_GroupMessagesLogChatLog_GroupMessagesQueueLog] FOREIGN KEY([GroupMessagesLogId])
REFERENCES [ParentPortal].[GroupMessagesQueueLog] ([Id])
GO

ALTER TABLE [ParentPortal].[GroupMessagesLogChatLog] CHECK CONSTRAINT [FK_GroupMessagesLogChatLog_GroupMessagesQueueLog]
GO
