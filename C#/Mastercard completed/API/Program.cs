using Model;
using Services;
using Services.Cache;
using Services.Configuration;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer()
                .AddSwaggerGen()
                .RegisterContexts(builder.Configuration)
                .AddMemoryCache()
                .AddAutoMapper(cfg => { }, typeof(MappingProfile));
RegisterAppServices(builder);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();

static void RegisterAppServices(WebApplicationBuilder builder)
{
    builder.Services.AddScoped<IQuestionsService, QuestionsService>();
    builder.Services.AddScoped<IReportsService, ReportsService>();
    builder.Services.AddScoped<IGradesRepository, GradesRepository>();
    builder.Services.AddSingleton<ICacheService, MemoryCacheService>();
}