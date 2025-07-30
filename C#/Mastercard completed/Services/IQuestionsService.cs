using Contracts;

namespace Services
{
    public interface IQuestionsService
    {
        Task<IEnumerable<QuestionResponseDto>> GetQuestions(int snapshotId, int pageSize, int pageNumber);
        Task UpdateQuestion(int snapshotId, int questionId, UpdateQuestionDto dto);
        Task DeleteQuestion(int snapshotId, int questionId);
        Task<QuestionResponseDto> CreateQuestion(int snapshotId, CreateQuestionDto dto);
    }
}