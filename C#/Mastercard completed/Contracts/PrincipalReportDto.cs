namespace Contracts;

public class PrincipalReportDto
{
    private const string ReportName = "Principal Report";
    private DateTime? _creationTime;

    public string Title => ReportName;
    public DateTime CreationTime => _creationTime ??= DateTime.UtcNow;

    public required ZoneScoresDto LowestNationalScoreZone { get; set; }
    public required ZoneScoresDto LowestNonNationalScoreZone { get; set; }
}
