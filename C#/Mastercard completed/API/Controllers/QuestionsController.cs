using AutoMapper;
using Contracts;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Model;
using Services;

namespace Mastecard.Controllers
{
    [ApiController]
    // in my opnion, the main entity in the domain is the snapshot, even though there's no snapshot table.  
    // (which I believe there should have been, and relate the Subjects, Zones, Questions to it,
    // and their fields that vary for each snapshot, like "IsRelevant", "Score" etc. should be in the Snapshot<->Entity junction table).
    // All other entities are duplicate for each snapshot.
    // And all the requests in this API and even in the DB Goals of the assignment are related to a specific snapshot.
    // thus, I believe the root route is the snapshot and the other entities are its sub-routes:
    [Route("api/snapshots/{snapshotId}/questions")]
    public class QuestionsController(IQuestionsService service, ILogger<QuestionsController> logger) : ControllerBase
    {
        private readonly ILogger<QuestionsController> _logger = logger;
        private readonly IQuestionsService _questionsService = service;

        [HttpGet]
        public async Task<ActionResult<PagedResult<QuestionResponseDto>>> GetQuestions([FromRoute] int snapshotId, [FromQuery] PagedRequest request)
        {
            try
            {
                var questions = await _questionsService.GetQuestions(snapshotId, request.PageSize, request.PageNumber);
                var pageDto = new PagedResult<QuestionResponseDto>
                {
                    PageNumber = request.PageNumber,
                    PageSize = request.PageSize,
                    TotalCount = questions.Count(),
                    Items = [.. questions]
                };
                return Ok(pageDto);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An error occurred while fetching questions for snapshotId: {SnapshotId}", snapshotId);
                
                return StatusCode(500, new
                {
                    Error = "An unexpected error occurred.",
                    Details = $"Error while fetching Questions for snapshotId: {snapshotId}" 
                });
            }
        }

        //  /api/snapshots/{snapshotId}/questions/{id}
        [HttpPut("{questionId}")]
        public async Task<IActionResult> UpdateQuestion([FromRoute] int snapshotId, [FromRoute] int questionId, [FromBody] UpdateQuestionDto dto)
        {
            try
            {
                await _questionsService.UpdateQuestion(snapshotId, questionId, dto);
                return NoContent();
            }
            catch (KeyNotFoundException ex)
            {
                _logger.LogWarning(ex, "Question with ID {QuestionId} not found for Snapshot ID {SnapshotId}", questionId, snapshotId);
                return NotFound(new { Error = ex.Message });
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid argument provided for updating question {QuestionId} for snapshotId: {SnapshotId}", questionId, snapshotId);
                return BadRequest(new { Error = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An error occurred while updating question {QuestionId} for snapshotId: {SnapshotId}", questionId, snapshotId);

                return StatusCode(500, new
                {
                    Error = "An unexpected error occurred.",
                    Details = $"Error while updating question {questionId} for snapshotId: {snapshotId}"
                });
            }            
        }

        // DELETE: /api/snapshots/{snapshotId}/questions/{id}
        [HttpDelete("{questionId}")]
        public async Task<IActionResult> DeleteQuestion(int snapshotId, int questionId)
        {
            try
            {
                await _questionsService.DeleteQuestion(snapshotId, questionId);
                return NoContent();
            }
            catch (KeyNotFoundException ex)
            {
                _logger.LogWarning(ex, "Question with ID {QuestionId} not found for Snapshot ID {SnapshotId}", questionId, snapshotId);
                return NotFound(new { Error = ex.Message });
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid argument provided for deleting question {QuestionId} for snapshotId: {SnapshotId}", questionId, snapshotId);
                return BadRequest(new { Error = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An error occurred while deleting question {QuestionId} for snapshotId: {SnapshotId}", questionId, snapshotId);

                return StatusCode(500, new
                {
                    Error = "An unexpected error occurred.",
                    Details = $"Error while deleting question {questionId} for snapshotId: {snapshotId}"
                });
            }
        }


        // POST: /api/snapshots/{snapshotId}/questions
        [HttpPost]
        public async Task<ActionResult<QuestionResponseDto>> CreateQuestion(int snapshotId, [FromBody] CreateQuestionDto dto)
        {
            try
            {
                var createdQuestion = await _questionsService.CreateQuestion(snapshotId, dto);
                return CreatedAtAction(nameof(CreateQuestion), createdQuestion);
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid argument provided for creating question for snapshotId: {SnapshotId}", snapshotId);
                return BadRequest(new { Error = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An error occurred while creating question for snapshotId: {SnapshotId}", snapshotId);

                return StatusCode(500, new
                {
                    Error = "An unexpected error occurred.",
                    Details = $"Error while creating question for snapshotId: {snapshotId}"
                });
            }
        }
    }
}
