using Contracts;
using Microsoft.AspNetCore.Mvc;
using Services;

namespace Mastecard.Controllers
{
    [ApiController]
    [Route("api/reports")]
    public class ReportsController(IReportsService service, ILogger<ReportsController> logger) : ControllerBase
    {
        private readonly ILogger<ReportsController> _logger = logger;
        private readonly IReportsService _reportsService = service;

        [HttpGet]
        [Route("student/{snapshotId}")]
        public async Task<ActionResult<StudentReportDto>> GetStudentReport([FromRoute] int snapshotId)
        {
            try
            {
                var report = await _reportsService.GetStudentReport(snapshotId);
                return Ok(report);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An error occurred while creating student report for snapshotId: {SnapshotId}", snapshotId);
                
                return StatusCode(500, new
                {
                    Error = "An unexpected error occurred.",
                    Details = $"Error while creating student report for snapshotId: {snapshotId}" 
                });
            }
        }

        [HttpGet]
        [Route("principal")]
        public async Task<ActionResult<PrincipalReportDto>> GetPrincipalReport([FromQuery] int[] snapshotIds)
        {
            try
            {
                var report = await _reportsService.GetPrincipalReport(snapshotIds);
                return Ok(report);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An error occurred while creating principal report for snapshotId: {SnapshotId}", string.Join(',', snapshotIds));

                return StatusCode(500, new
                {
                    Error = "An unexpected error occurred.",
                    Details = $"Error while creating principal report for snapshotId: {string.Join(',', snapshotIds)}"
                });
            }
        }
    }
}
