-- NOTE: this script includes SPs,Functions and Type for Goals 2,4,5.
-- I marked the relevant Goals before each Stored Procedure.

USE [Grades]
GO

DROP FUNCTION IF EXISTS dbo.fn_AllSnapshotData;
DROP FUNCTION IF EXISTS dbo.fn_ZoneScoresPerSnapshot;
DROP PROCEDURE IF EXISTS dbo.Get_Principal_Report
DROP PROCEDURE IF EXISTS dbo.Get_Student_Report_Zones;
DROP PROCEDURE IF EXISTS [dbo].[Calculate_Score_Per_Snapshot];
DROP TYPE IF EXISTS dbo.SnapshotIdList;
GO

-- I extracted the following TYPE and 2 FUNCTIONS as they are required by Goals 4,5 (code / logic reuse).
CREATE TYPE dbo.SnapshotIdList AS TABLE (SnapshotId INT NOT NULL PRIMARY KEY);
GO

CREATE OR ALTER FUNCTION dbo.fn_AllSnapshotData(@SnapshotIds dbo.SnapshotIdList READONLY)
RETURNS TABLE
AS
RETURN
(
    SELECT
        s.SnapshotId,
        s.SubjectId,
        s.SubjectName,
        z.ZoneId,
        z.ZoneName,
        z.IsRelevant AS IsZoneRelevant,
        q.QuestionId,
        q.Score,
        q.IsRelevant AS IsQuestionRelevant,
        t.IsATest
    FROM dbo.Questions q
    INNER JOIN dbo.ZonesQuestions zq ON q.QuestionId = zq.QuestionId AND q.SnapshotId = zq.SnapshotId
	INNER JOIN dbo.Zones z ON zq.ZoneId = z.ZoneId AND zq.SnapshotId = z.SnapshotId 
	-- left join, since for goals 4,5 I care about zones and not about subjects, and a zone may be unrelated to any subject. 
	-- Goal 2 refers only zones that are related to subjects, so I'll filter out the rows with SubjectId IS NULL when handling Goal2
    LEFT JOIN dbo.SubjectZones sz ON z.ZoneId = sz.ZoneId AND z.SnapshotId = sz.SnapshotId
    LEFT JOIN dbo.Subjects s ON sz.SubjectId = s.SubjectId AND sz.SnapshotId = s.SnapshotId
    INNER JOIN dbo.Tests t ON q.TestId = t.TestId
    INNER JOIN @SnapshotIds sid ON q.SnapshotId = sid.SnapshotId
	-- not filtering by IsRelevant since questions statistics (NumNationalQuestions, NumNationalAnswerdQuestions etc.) include Irrelevant questions (as far as I understand)
)
GO

CREATE OR ALTER FUNCTION dbo.fn_ZoneScoresPerSnapshot(@SnapshotIds dbo.SnapshotIdList READONLY)
RETURNS TABLE
AS
RETURN
(
	
	SELECT SnapshotId, 
		ZoneId,
		AVG(CASE WHEN IsATest = 1 THEN 
			CAST((CASE WHEN Score IS NULL THEN 0 -- relevant questions un-ansewered are actually scored 0.
						ELSE Score END)
			AS DECIMAL(5,2)) END) AS AvgNationalZoneScore,
		AVG(CASE WHEN IsATest = 0 THEN 
			CAST((CASE WHEN Score IS NULL THEN 0 -- relevant questions un-ansewered are actually scored 0.
						ELSE Score END)
			AS DECIMAL(5,2)) END) AS AvgNonNationalZoneScore
	FROM (
		-- I use DISTINCT since if each Zone + Question appears multiple times in fn_AllSnapshotData (one for each Subject it's related to)
		SELECT DISTINCT SnapshotId, ZoneId, QuestionId, Score, IsATest  
		FROM dbo.fn_AllSnapshotData(@SnapshotIds)
		WHERE IsQuestionRelevant = 1 AND IsZoneRelevant = 1
    ) deduped
	GROUP BY SnapshotId, ZoneId
)
GO

---------------------------------------------	 GOAL 2	   ---------------------------------------------

CREATE OR ALTER PROCEDURE [dbo].[Calculate_Score_Per_Snapshot] (@SnapshotId INT) 
AS
BEGIN

-- validate exitence of the requested snapshotId
	IF NOT EXISTS (SELECT 1 FROM dbo.Subjects WHERE SnapshotId = @SnapshotId)
	BEGIN
		RAISERROR('SnapshotId Not Found', 16, 1)
	END

	DECLARE @SnapshotIds dbo.SnapshotIdList;
    INSERT INTO @SnapshotIds (SnapshotId) VALUES (@SnapshotId);

;WITH All_Snapshot_Data AS (
    SELECT * FROM dbo.fn_AllSnapshotData(@SnapshotIds)
    WHERE SubjectId IS NOT NULL
	-- To my understanding of Goal 2, the statistics of: NumNationalQuestions, NumNationalAnsweredQuestions etc. are calculated over all the Subject's
	-- Questions, even the Irrelevant ones. If that's wrong, and the questions statistics are on the Relevant Questions only, then I should add here:
	-- AND q.IsQuestionRelevant = 1 
	-- and remove the redundant IsRelevant filters from the SubjectsScores CTE table
), 	

-- To my undersdtanding of Goal 2, the statistics of: NumNationalQuestions, NumNationalAnsweredQuestions etc. should be calculated on Distinct Questions.
-- Otherwise it will count duplicated questions (the same question may refer multiple zones and therefore appear multiple times on All_Snapshot_Data CTE.
-- This is why I created DistinctQuestionsPerSubject CTE. I haven't used DICSTINCT in All_Snapshot_Data since it's used also for the subject score calculation 
-- which is calcualted from the scores of all the zones, while each zone's score is calculated of all its related questions, even if a question is also related to another
-- zone - which in this case the question will be counted for the score calulation of its 2 related zoness.
DistinctQuestionsPerSubject AS (
	SELECT DISTINCT SubjectId, SubjectName, QuestionId, IsATest, Score
	FROM All_Snapshot_Data
	WHERE SubjectId IS NOT NULL -- filter out zones that are not related to subjects
),
QuestionsStats AS (	
	-- NOTE: questionId may be duplicated as it may refer multiple zones that refer to a single subject.
	-- therefore in order to count the question types I need to use DistinctQuestionsPerSubject table to deduplicates the questions.
	SELECT SubjectId, SubjectName,
		COUNT(CASE WHEN IsATest = 1 THEN QuestionId END) AS NumNationalQuestions,
		COUNT(CASE WHEN IsATest = 1 AND Score IS NOT NULL THEN QuestionId END) AS NumNationalAnsweredQuestions,
		COUNT(CASE WHEN IsATest = 1 AND Score IS NULL THEN QuestionId END) AS NumNationalNonAnsweredQuestions,
		COUNT(CASE WHEN IsATest = 0 THEN QuestionId END) AS NumNonNationalQuestions,
		COUNT(CASE WHEN IsATest = 0 AND Score IS NOT NULL THEN QuestionId END) AS NumNonNationalAnsweredQuestions,
		COUNT(CASE WHEN IsATest = 0 AND Score IS NULL THEN QuestionId END) AS NumNonNationalNonAnsweredQuestions
	FROM DistinctQuestionsPerSubject
	GROUP BY SubjectId, SubjectName
),
SubjectsScores AS (

	-- NOTE 1: When calculating the scores, I don't take the scores of just *DISTINCT Questions* (counting a Question's score only once - for just a single zone), 
	-- since according to the assignment instructions, a question's score is counted for each Zone it is related to and the Subject's score is the average 
	-- of all its related zones - each zone with ALL its related questions.

	-- NOTE 2: I Should Convert Relevant Questions with Score Null to Score 0. (since an un-answered question means 0 score, but NULLS are not taking part in AVG.)

	SELECT s.SubjectId, 
		   CAST(AVG(zsps.AvgNationalZoneScore) AS DECIMAL(5,2)) AS SubjectNationalScore, 
		   CAST(AVG(zsps.AvgNonNationalZoneScore) AS DECIMAL(5,2)) AS SubjectNonNationalScore
	FROM dbo.fn_ZoneScoresPerSnapshot(@SnapshotIds) zsps
	INNER JOIN dbo.SubjectZones sz ON zsps.ZoneId = sz.ZoneId
	INNER JOIN dbo.Subjects s ON sz.SubjectId = s.SubjectId
	GROUP BY zsps.SnapshotId, s.SubjectId
)

SELECT @SnapshotId AS SnapshotId, 
	   qs.SubjectId, 
	   qs.SubjectName, 
	   qs.NumNationalQuestions,
	   qs.NumNationalAnsweredQuestions, 
	   ss.SubjectNationalScore AS NationalTestScores,
	   qs.NumNonNationalQuestions,
	   qs.NumNonNationalAnsweredQuestions, 
	   ss.SubjectNonNationalScore AS NonNationalTestScores
FROM SubjectsScores ss INNER JOIN QuestionsStats qs ON qs.SubjectId = ss.SubjectId

END
GO

--- test Goal2 ---
--EXEC dbo.Calculate_Score_Per_Snapshot @SnapshotId='1001191'
--GO




---------------------------------------------	 GOAL 4	   ---------------------------------------------


CREATE OR ALTER PROCEDURE dbo.Get_Student_Report_Zones @SnapshotId INT
AS
BEGIN

    DECLARE @SnapshotIds dbo.SnapshotIdList;
    INSERT INTO @SnapshotIds VALUES (@SnapshotId);
	
	DECLARE @ZoneScores TABLE (
			SnapshotId INT,
			ZoneId INT,
			AvgNationalZoneScore DECIMAL(5,2),
			AvgNonNationalZoneScore DECIMAL(5,2)
    );

    INSERT INTO @ZoneScores
    SELECT *
    FROM dbo.fn_ZoneScoresPerSnapshot(@SnapshotIds);

    SELECT 'Top_3_National_Zones' AS Category, * FROM (
		SELECT TOP (3) /*WITH TIES*/ SnapshotId,
			ZoneId,
			AvgNationalZoneScore,
			AvgNonNationalZoneScore
		FROM @ZoneScores
		ORDER BY AvgNationalZoneScore DESC
	) AS top3national
	
	UNION ALL

	SELECT 'Top_3_Non_National_Zones' AS Category, * FROM (
		SELECT TOP (3) /*WITH TIES*/ SnapshotId,
			ZoneId,
			AvgNationalZoneScore,
			AvgNonNationalZoneScore
		FROM @ZoneScores
		ORDER BY AvgNonNationalZoneScore DESC
	) AS top3nonnational

	UNION ALL

	SELECT 'Bottom_3_National_Zones' AS Category, * FROM (
		SELECT TOP (3) /*WITH TIES*/ SnapshotId,
			ZoneId,
			AvgNationalZoneScore,
			AvgNonNationalZoneScore
		FROM @ZoneScores
		ORDER BY AvgNationalZoneScore ASC
	) AS bottom3national

	UNION ALL

	SELECT 'Bottom_3_Non_National_Zones' AS Category, * FROM (
		SELECT TOP (3) /*WITH TIES*/ SnapshotId,
			ZoneId,
			AvgNationalZoneScore,
			AvgNonNationalZoneScore
		FROM @ZoneScores
		ORDER BY AvgNonNationalZoneScore ASC
	) AS bottom3nonnational
    
	UNION ALL

	SELECT 'NationalZoneScore_Below_60 ' AS Category, * FROM (
        SELECT SnapshotId,
        ZoneId,
        AvgNationalZoneScore,
        AvgNonNationalZoneScore  
		FROM @ZoneScores
		WHERE AvgNationalZoneScore < 60
	) AS nationalunder60

	UNION ALL

	SELECT 'NonNationalZoneScore_Below_60 ' AS Category, * FROM (
        SELECT SnapshotId,
        ZoneId,
        AvgNationalZoneScore,
        AvgNonNationalZoneScore  
		FROM @ZoneScores
		WHERE AvgNonNationalZoneScore < 60
	) AS nonnationalunder60

END
GO



---------------------------------------------	 GOAL 5	   ---------------------------------------------


CREATE OR ALTER PROCEDURE dbo.Get_Principal_Report @SnapshotIds dbo.SnapshotIdList READONLY
AS
BEGIN
	
;WITH Ranked AS (
    SELECT *,
        RANK() OVER (ORDER BY AvgNationalZoneScore ASC) AS NationalScoreRank,
        RANK() OVER (ORDER BY AvgNonNationalZoneScore ASC) AS NonNationalScoreRank
    FROM dbo.fn_ZoneScoresPerSnapshot(@SnapshotIds)
)
SELECT SnapshotId, ZoneId, AvgNationalZoneScore, AvgNonNationalZoneScore, 'LowestNationalScoreZone' AS Category
FROM Ranked
WHERE NationalScoreRank = 1

UNION ALL

SELECT SnapshotId, ZoneId, AvgNationalZoneScore, AvgNonNationalZoneScore, 'LowestNonNationalScoreZone' AS Category
FROM Ranked
WHERE NonNationalScoreRank = 1;

END


