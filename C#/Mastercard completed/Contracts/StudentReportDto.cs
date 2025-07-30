namespace Contracts;

public class StudentReportDto
{
    private const string ReportName = "Student Report";
    private DateTime? _creationTime;

    public string Title => ReportName;
    public DateTime CreationTime => _creationTime ??= DateTime.UtcNow;

    public required List<ZoneScoresDto> Top3NationalZones { get; set; }
    public required List<ZoneScoresDto> Top3NonNationalZones { get; set; }
    public required List<ZoneScoresDto> Bottom3NationalZones { get; set; }
    public required List<ZoneScoresDto> Bottom3NonNationalZones { get; set; }
    public required List<ZoneScoresDto> NationalZonesBelow60 { get; set; }
    public required List<ZoneScoresDto> NonNationalZonesBelow60 { get; set; }
}
