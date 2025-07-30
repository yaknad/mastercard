using AutoMapper;
using Contracts;
using Model;

namespace Services.Configuration;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        CreateMap<Question, CreateQuestionDto>().ReverseMap();
        CreateMap<Question, QuestionResponseDto>().ReverseMap();
        CreateMap<ZoneScores, ZoneScoresDto>().ReverseMap();
    }
}
