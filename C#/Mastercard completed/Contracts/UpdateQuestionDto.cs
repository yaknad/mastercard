using System.ComponentModel.DataAnnotations;

namespace Contracts;

public class UpdateQuestionDto : IValidatableObject
{
    [StringLength(200, MinimumLength = 10)]
    public string? QuestionText { get; set; }
    [Range(0, 100)]
    public int? Score { get; set; }
    public bool? IsRelevant { get; set; }

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        if (QuestionText == null && Score == null && IsRelevant == null)
        {
            yield return new ValidationResult(
                "At least one of QuestionText, Score, or IsRelevant must be provided.",
                [nameof(QuestionText), nameof(Score), nameof(IsRelevant)]
            );
        }
    }
}
