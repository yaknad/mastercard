using AutoMapper;
using Contracts;
using Model;

namespace Services;

public class ReportsService(IGradesRepository _repository, IMapper mapper) : IReportsService
{
    private readonly IGradesRepository _repository = _repository;
    private readonly IMapper _mapper = mapper;

    public async Task<StudentReportDto> GetStudentReport(int snapshotId)
    {
        var reports = await _repository.GetStudentReportZones(snapshotId);
        return new StudentReportDto
        {
            Top3NationalZones = _mapper.Map<List<ZoneScoresDto>>(reports.Where(z => z.Category == ZoneScoreCategory.Top_3_National_Zones)
                                                                        .OrderByDescending(z => z.AvgNationalZoneScore).Take(3).ToList()),
            Top3NonNationalZones = _mapper.Map<List<ZoneScoresDto>>(reports.Where(z => z.Category == ZoneScoreCategory.Top_3_Non_National_Zones)
                                                                        .OrderByDescending(z => z.AvgNonNationalZoneScore).Take(3).ToList()),
            Bottom3NationalZones = _mapper.Map<List<ZoneScoresDto>>(reports.Where(z => z.Category == ZoneScoreCategory.Bottom_3_National_Zones)
                                                                     .OrderBy(z => z.AvgNationalZoneScore).Take(3).ToList()),
            Bottom3NonNationalZones = _mapper.Map<List<ZoneScoresDto>>(reports.Where(z => z.Category == ZoneScoreCategory.Bottom_3_Non_National_Zones)
                                                                        .OrderBy(z => z.AvgNonNationalZoneScore).Take(3).ToList()),
            NationalZonesBelow60 = _mapper.Map<List<ZoneScoresDto>>(reports.Where(z => z.Category == ZoneScoreCategory.NationalZoneScore_Below_60)
                                                                        .OrderBy(z => z.AvgNationalZoneScore).ToList()),
            NonNationalZonesBelow60 = _mapper.Map<List<ZoneScoresDto>>(reports.Where(z => z.Category == ZoneScoreCategory.NonNationalZoneScore_Below_60)
                                                                        .OrderBy(z => z.AvgNonNationalZoneScore).Take(3).ToList()),
        };
    }

    public async Task<PrincipalReportDto> GetPrincipalReport(int[] snapshotIds)
    {
        var reports = await _repository.GetPrincipalReportZones(snapshotIds);
        return new PrincipalReportDto
        {
            LowestNationalScoreZone = _mapper.Map<ZoneScoresDto>(reports.Where(z => z.Category == ZoneScoreCategory.LowestNationalScoreZone).First()),
            LowestNonNationalScoreZone = _mapper.Map<ZoneScoresDto>(reports.Where(z => z.Category == ZoneScoreCategory.LowestNonNationalScoreZone).First())            
        };
    }
}
