using System.ComponentModel.DataAnnotations;

namespace Contracts;

public class CreateQuestionDto
{
    [Required]
    [StringLength(200, MinimumLength = 10)]
    public string QuestionText { get; set; } = default!;
    [Range(0, 100)]
    public int? Score { get; set; }
    public bool? IsRelevant { get; set; }
    [Required]
    [Range(1, int.MaxValue, ErrorMessage = "testId must be a positive number")]
    public required int TestId { get; set; }    
}
