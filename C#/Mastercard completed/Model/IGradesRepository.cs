
namespace Model;

public interface IGradesRepository
{
    Task<List<Question>> GetQuestions(int snapshotId, int pageSize, int pageNumber);
    Task<Question?> GetQuestion(int snapshotId, int questionId);
    Task DeleteQuestion(int snapshotId, int questionId);
    Task UpdateChanges();
    Task<int> GetLatestQuestionId(int snapshotId);
    Task CreateQuestion(Question question);
    Task<List<ZoneScores>> GetStudentReportZones(int snapshotId);
    Task<List<ZoneScores>> GetPrincipalReportZones(int[] snapshotId);
}