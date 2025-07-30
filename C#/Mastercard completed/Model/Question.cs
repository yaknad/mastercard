using System.ComponentModel.DataAnnotations;

namespace Model;

public class Question
{
    [Key]
    [Range(1, int.MaxValue, ErrorMessage = "snapshotId must be a positive number")]
    public required int SnapshotId { get; set; }
    [Key]
    public required int QuestionId { get; set; }
    [Required]
    [StringLength(200, MinimumLength = 10)]
    public string QuestionText { get; set; } = default!;
    [Range(0, 100)]
    public int? Score { get; set; }
    public bool? IsRelevant { get; set; }
    [Required]
    [Range(1, int.MaxValue, ErrorMessage = "testId must be a positive number")]
    public int TestId { get; set; }
    
}
