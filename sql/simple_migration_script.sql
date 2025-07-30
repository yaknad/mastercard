-- since this is a static data migration, I haven't fetched the latest ids in the updated tables 
-- (in order to calculate the next id in each table), but assumed we can set the ids "hard coded" in the script

USE Grades
GO

INSERT [dbo].[Subjects] ([SnapshotId], [SubjectId], [SubjectName]) VALUES (0, 2, 'Subject-2')
GO

INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1001, 'zone number:1001', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1002, 'zone number:1002', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1003, 'zone number:1003', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1004, 'zone number:1004', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1005, 'zone number:1005', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1006, 'zone number:1006', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1007, 'zone number:1007', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1008, 'zone number:1008', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1009, 'zone number:1009', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1010, 'zone number:1010', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1011, 'zone number:1011', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1012, 'zone number:1012', 1)
INSERT [dbo].[Zones] ([SnapshotId], [ZoneId], [ZoneName], [IsRelevant]) VALUES (0, 1013, 'zone number:1013', 1)
GO

INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1001)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1002)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1003)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1004)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1005)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1006)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1007)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1008)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1009)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1010)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1011)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1012)
INSERT [dbo].[SubjectZones] ([SnapshotId], [SubjectId], [ZoneId]) VALUES (0, 2, 1013)
GO

INSERT [dbo].[Tests] ([TestId], [TestName], [IsATest]) VALUES (2001, 'test number2001', 1)
GO

INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300000, 'question number300000', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300001, 'question number300001', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300002, 'question number300002', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300003, 'question number300003', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300004, 'question number300004', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300005, 'question number300005', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300006, 'question number300006', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300007, 'question number300007', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300008, 'question number300008', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300009, 'question number300009', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300010, 'question number300010', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300011, 'question number300011', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300012, 'question number300012', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300013, 'question number300013', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300014, 'question number300014', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300015, 'question number300015', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300016, 'question number300016', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300017, 'question number300017', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300018, 'question number300018', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300019, 'question number300019', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300020, 'question number300020', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300021, 'question number300021', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300022, 'question number300022', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300023, 'question number300023', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300024, 'question number300024', NULL, 1, 2001)
INSERT [dbo].[Questions] ([SnapshotId], [QuestionId], [QuestionText], [Score], [IsRelevant], [TestId]) VALUES (0, 300025, 'question number300025', NULL, 1, 2001)
GO


INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1001, 300000)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1001, 300001)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1001, 300002)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1001, 300003)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1001, 300004)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1001, 300005)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1001, 300006)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1002, 300001)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1002, 300002)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1002, 300003)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1002, 300004)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1002, 300005)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1002, 300006)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1002, 300007)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1003, 300002)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1003, 300003)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1003, 300004)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1003, 300005)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1003, 300006)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1004, 300003)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1004, 300004)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1004, 300005)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1004, 300006)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1004, 300007)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1004, 300008)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1004, 300009)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1005, 300008)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1005, 300009)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1005, 300010)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1006, 300010)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1006, 300011)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1006, 300012)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1007, 300013)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1008, 300013)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1008, 300014)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1008, 300015)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1008, 300016)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1008, 300017)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1008, 300018)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1008, 300019)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1008, 300020)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1008, 300021)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1008, 300022)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1009, 300016)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1009, 300017)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1009, 300018)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1009, 300019)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1009, 300020)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1010, 300021)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1010, 300022)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1010, 300023)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1011, 300023)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1011, 300024)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1011, 300025)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1012, 300001)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1012, 300002)

INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1013, 300006)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1013, 300007)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1013, 300008)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1013, 300009)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1013, 300010)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1013, 300011)
INSERT [dbo].[ZonesQuestions] ([SnapshotId], [ZoneId], [QuestionId]) VALUES (0, 1013, 300012)
GO