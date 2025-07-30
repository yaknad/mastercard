namespace Contracts;

public class ZoneScoresDto
{
    public int SnapshotId { get; set; }
    public int ZoneId { get; set; }
    public decimal? AvgNationalZoneScore { get; set; }
    public decimal? AvgNonNationalZoneScore { get; set; }
}
