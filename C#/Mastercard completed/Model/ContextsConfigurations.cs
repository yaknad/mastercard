using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Model;

public static class ContextsConfigurations
{
    public static IServiceCollection RegisterContexts(this IServiceCollection services, IConfiguration configuration)
    {
        const int sqlCommandTimeoutSeconds = 60;
        // prefered not to use DbContextFactory since the GetQuestion and UpdateQuestion methods in the GradesRepository must share the same context instance
        // and DbContextFactory creates a new instance for each call, which can lead to issues with tracking changes.
        // working around that with DbContextFactory will be messy (moving around the DbContext instance between methods, etc.)
        services.AddDbContext<GradesContext>(optionsBuilder => { 
            optionsBuilder.UseSqlServer(configuration.GetConnectionString("Grades"),
                providerOptions => providerOptions.CommandTimeout(sqlCommandTimeoutSeconds));
            });
        return services;
    }
}
