using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Model.Exceptions;
using System.Data;

namespace Model;

public class GradesRepository(GradesContext context, ILogger<GradesRepository> logger) : IGradesRepository
{
    private const int SqlServerUniqueConstraintViolationErrorCode = 2627;
    private const int SqlServerUniqueIndexViolationErrorCode = 2601;

    private readonly GradesContext _context = context;
    private readonly ILogger<GradesRepository> _logger = logger;

    public async Task<Question?> GetQuestion(int snapshotId, int questionId)
    {
        try
        {
            return await _context.Questions
                        .Where(q => q.SnapshotId == snapshotId && q.QuestionId == questionId)
                        .FirstOrDefaultAsync();
        }
        // TODO: explicitily handle specific exception types like DbUpdateException
        catch (Exception ex)
        {
            _logger.LogError(ex, "An error occurred while fetching question for SnapshotId: {SnapshotId}, QuestionId: {QuestionId}", snapshotId, questionId);
            throw;
        }
    }

    public async Task<List<Question>> GetQuestions(int snapshotId, int pageSize, int pageNumber)
    {
        try
        {
            return await _context.Questions
                        .Where(q => q.SnapshotId == snapshotId)
                        .Skip((pageNumber - 1) * pageSize)
                        .Take(pageSize)
                        .ToListAsync();
        }
        // TODO: explicitily handle specific exception types like DbUpdateException
        catch (Exception ex)
        {
            _logger.LogError(ex, "An error occurred while fetching questions for SnapshotId: {SnapshotId}, PageSize: {PageSize}, PageNumber: {PageNumber}", snapshotId, pageSize, pageNumber);
            throw;
        }
    }

    public async Task UpdateChanges()
    {
        await _context.SaveChangesAsync();
    }

    public async Task DeleteQuestion(int snapshotId, int questionId)
    {
        try
        {
            // this way of deletion saves the need to first fetch the Question jusy in order to delete it.
            var question = new Question { SnapshotId = snapshotId, QuestionId = questionId };
            _context.Questions.Attach(question);
            _context.Questions.Remove(question);
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException ex)
        {
            _logger.LogWarning(ex, "Question with ID {QuestionId} of SnapshotId: {SnapshotId} was not found for deletion", questionId, snapshotId);
            throw new KeyNotFoundException($"Question with ID {questionId} of Snapshot ID {snapshotId} was not found for deletion");
        }        
    }

    public async Task<int> GetLatestQuestionId(int snapshotId)
    {
        try
        {
            return await _context.Questions
                        .Where(q => q.SnapshotId == snapshotId)
                        .MaxAsync(q => q.QuestionId);
        }
        catch (InvalidOperationException ex)
        {
            // This exception occurs if there are no questions for the given snapshotId.
            _logger.LogWarning(ex, "No questions found for SnapshotId: {SnapshotId}", snapshotId);
            return 0; 
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An error occurred while fetching the latest question ID for SnapshotId: {SnapshotId}", snapshotId);
            throw;
        }
    }

    public async Task CreateQuestion(Question question)
    {
        try
        {
            _context.Questions.Add(question);
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateException ex)
        {
            if(IsUniqueConstraintViolation(ex))
            {
                _logger.LogWarning(ex, "A question with the same SnapshotId and QuestionId already exists: SnapshotId: {SnapshotId}, QuestionId: {QuestionId}", question.SnapshotId, question.QuestionId);
                throw new KeyAlreadyExistsException($"A question with SnapshotId {question.SnapshotId} and QuestionId {question.QuestionId} already exists.");
            }
            _logger.LogError(ex, "An error occurred while creating a new question for SnapshotId: {SnapshotId}", question.SnapshotId);
            throw;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An unexpected error occurred while creating a new question for SnapshotId: {SnapshotId}", question.SnapshotId);
            throw;
        }
    }    

    public async Task<List<ZoneScores>> GetStudentReportZones(int snapshotId)
    {
        try
        {
            return await _context
                .ZoneScores                
                .FromSqlInterpolated($"EXEC Get_Student_Report_Zones @SnapshotId = {snapshotId}") // SP is located in calculate_score_per_snapshot.sql
            .ToListAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An error occurred while fetching zone scores for SnapshotIds: {SnapshotIds}", snapshotId);
            throw;
        }
    }

    public async Task<List<ZoneScores>> GetPrincipalReportZones(int[] snapshotIds)
    {
        try
        {
            var snapshotIdsParameter = ToSnapshotIdParameter(snapshotIds);
            return await _context.ZoneScores
                .FromSql($"exec [dbo].[Get_Principal_Report] {snapshotIdsParameter}") // SP is located in calculate_score_per_snapshot.sql
                .ToListAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An error occurred while fetching zone scores for SnapshotIds: {SnapshotIds}", string.Join(", ", snapshotIds));
            throw;
        }
    }

    private static bool IsUniqueConstraintViolation(DbUpdateException exception)
    {
        var sqlException = exception.InnerException as SqlException;
        return IsErrorCodeFromList(sqlException, SqlServerUniqueConstraintViolationErrorCode, SqlServerUniqueIndexViolationErrorCode);
    }

    private static bool IsErrorCodeFromList(SqlException? exception, params int[] sqlServerErrorCodes)
    {
        if (exception == null)
        {
            return false;
        }
        return sqlServerErrorCodes.Contains(exception.Number);
    }

    private static SqlParameter ToSnapshotIdParameter(IEnumerable<int> snapshotIds)
    {
        var table = new DataTable
        {
            TableName = "dbo.SnapshotIdList"
        };
        table.Columns.Add("SnapshotId", typeof(int));

        foreach (var id in snapshotIds)
        {
            table.Rows.Add(id);
        }

        return new SqlParameter("@SnapshotIds", SqlDbType.Structured)
        {
            Value = table,
            TypeName = "[dbo].[SnapshotIdList]"
        };
    }
}
