namespace Contracts;

public class QuestionResponseDto : CreateQuestionDto
{
    public int SnapshotId { get; set; }
    public int QuestionId { get; set; }
}
