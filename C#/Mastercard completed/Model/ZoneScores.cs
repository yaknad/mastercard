namespace Model;

public class ZoneScores
{
    public ZoneScoreCategory Category { get; set; } = default!;
    public int SnapshotId { get; set; }
    public int ZoneId { get; set; }
    public decimal? AvgNationalZoneScore { get; set; }
    public decimal? AvgNonNationalZoneScore { get; set; }
}

public enum ZoneScoreCategory
{
    Top_3_National_Zones,
    Top_3_Non_National_Zones,
    Bottom_3_National_Zones,
    Bottom_3_Non_National_Zones,
    NationalZoneScore_Below_60,
    NonNationalZoneScore_Below_60,
    LowestNationalScoreZone,
    LowestNonNationalScoreZone,
}
