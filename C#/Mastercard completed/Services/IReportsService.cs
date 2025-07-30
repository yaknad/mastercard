using Contracts;

namespace Services;

public interface IReportsService
{
    Task<StudentReportDto> GetStudentReport(int snapshotId);
    Task<PrincipalReportDto> GetPrincipalReport(int[] snapshotIds);
}