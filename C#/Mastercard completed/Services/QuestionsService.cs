using AutoMapper;
using Contracts;
using Microsoft.EntityFrameworkCore;
using Model;
using Model.Exceptions;
using Services.Cache;

namespace Services
{
    public class QuestionsService(IGradesRepository _repository, IMapper mapper/*, ICacheService cache*/) : IQuestionsService
    {
        const int CREATE_MAX_RETRIES = 3; // TODO: make this configurable

        private readonly IGradesRepository _repository = _repository;
        private readonly IMapper _mapper = mapper;
        //TODO: at first I added a cache here, but then I added pagination to the GetQuestions method, and it complicated the cache logic.
        // So I commented it out for now, but I might want to use it in the future.
        //private readonly ICacheService _cache = cache;
        private readonly TimeSpan _cacheDuration = TimeSpan.FromMinutes(10); // TODO: make this configurable

        public async Task<IEnumerable<QuestionResponseDto>> GetQuestions(int snapshotId, int pageSize, int pageNumber)
        {
            ValidateGetQuestionsRequest(snapshotId, pageSize, pageNumber);

            //var cacheKey = $"questions_snapshot_{snapshotId}";
            //var questionsDto = _cache.Get<IEnumerable<QuestionDto>>(cacheKey);
            //if (questionsDto == null)
            //{ 

            var questions = await _repository.GetQuestions(snapshotId, pageSize, pageNumber);
            var questionsDto = questions.Select(question => _mapper.Map<QuestionResponseDto>(question));

            //    _cache.Set(cacheKey, questionsDto, _cacheDuration);
            //}
            return questionsDto;
        }

        public async Task UpdateQuestion(int snapshotId, int questionId, UpdateQuestionDto dto)
        {
            ValidateUpdateRequest(snapshotId, questionId, dto);
            var question = await _repository.GetQuestion(snapshotId, questionId) ?? 
                throw new KeyNotFoundException($"Question with ID {questionId} not found for Snapshot ID {snapshotId}");

            if (dto.QuestionText == question.QuestionText &&
                dto.IsRelevant == question.IsRelevant &&
                dto.Score == question.Score) 
                return; // nothing to update (we've already checked for all nulls in the DTO)

            question.QuestionText = dto.QuestionText ?? question.QuestionText;
            question.IsRelevant = dto.IsRelevant ?? question.IsRelevant;
            question.Score = dto.Score ?? question.Score;

            await _repository.UpdateChanges();
        }

        public async Task DeleteQuestion(int snapshotId, int questionId)
        {
            ValidateDeleteRequest(snapshotId, questionId);
            await _repository.DeleteQuestion(snapshotId, questionId);            
        }

        public async Task<QuestionResponseDto> CreateQuestion(int snapshotId, CreateQuestionDto dto)
        {
            ValidateCreateRequest(snapshotId, dto);
            var question = _mapper.Map<Question>(dto);
            question.SnapshotId = snapshotId;
            // since the table schema is not set to auto-generate IDs, we need to set them manually.
            // we need to get the latest QuestionId for the given SnapshotId, increment it and insert the new question with that ID.
            // we need to perform 2 operations atomically (get the latest QuestionId and insert the new question),
            // without risking that another request will insert a question in between and cause a duplicate ID,
            // there are 4 options here: 
            // 1. change the table schema to auto-generate IDs (not possible for this assignment).
            // 2. use a stored procedure to get the latest QuestionId and insert the new question (in one transaction).
            // 3. use a transaction in backend code to get the latest QuestionId, increment it and insert the new question.
            // 4. optimistically assume that the QuestionId will be unique and insert the new question. If it fails, catch the exception and retry.
            // I chose option 4, since it is the most efficient way.

            int retry = 0;
            while (retry < CREATE_MAX_RETRIES)
            {
                try
                {
                    var latestQuestionId = await _repository.GetLatestQuestionId(snapshotId);
                    question.QuestionId = latestQuestionId + 1;
                    await _repository.CreateQuestion(question);
                    break;
                }
                catch (KeyAlreadyExistsException)
                {
                    retry++;
                    if (retry == CREATE_MAX_RETRIES)
                        throw;
                }
            }

            return _mapper.Map<QuestionResponseDto>(question);
        }

        private static void ValidateGetQuestionsRequest(int snapshotId, int pageSize, int pageNumber)
        {
            if (snapshotId <= 0) throw new ArgumentException("SnapshotId must be a positive number", nameof(snapshotId));
            if (pageNumber <= 0) throw new ArgumentException("PageNumber must be a positive number", nameof(pageNumber));
            if (pageSize < 1 || pageSize > 100) throw new ArgumentOutOfRangeException(nameof(pageSize), "PageSize must be between 1 and 100");
        }

        private static void ValidateUpdateRequest(int snapshotId, int questionId, UpdateQuestionDto dto)
        {
            if (dto == null) throw new ArgumentNullException(nameof(dto), "QuestionDto cannot be null");
            if (snapshotId <= 0) throw new ArgumentException("SnapshotId must be a positive number", nameof(snapshotId));
            if (questionId <= 0) throw new ArgumentException("QuestionId must be a positive number", nameof(questionId));
        }

        private static void ValidateDeleteRequest(int snapshotId, int questionId)
        {
            if (snapshotId <= 0) throw new ArgumentException("SnapshotId must be a positive number", nameof(snapshotId));
            if (questionId <= 0) throw new ArgumentException("QuestionId must be a positive number", nameof(questionId));
        }

        private static void ValidateCreateRequest(int snapshotId, CreateQuestionDto dto)
        {
            if (dto == null) throw new ArgumentNullException(nameof(dto), "QuestionDto cannot be null");
            if (snapshotId <= 0) throw new ArgumentException("SnapshotId must be a positive number", nameof(snapshotId));            
        }
    }
}
