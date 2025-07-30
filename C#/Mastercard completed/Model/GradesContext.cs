using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using System.Diagnostics;

namespace Model;

public class GradesContext(DbContextOptions<GradesContext> options) : DbContext(options)
{
    public DbSet<Question> Questions { get; set; }
    public DbSet<ZoneScores> ZoneScores { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Question>()
            .HasKey(e => new { e.SnapshotId, e.QuestionId });

        var categoryConverter = new ValueConverter<ZoneScoreCategory, string>(
                v => v.ToString(), // Convert enum to string for DB
                v => (ZoneScoreCategory)Enum.Parse(typeof(ZoneScoreCategory), v) // Convert string to enum
        );

        modelBuilder.Entity<ZoneScores>()
                    .HasNoKey() // TVFs don't have primary keys
                    .Property(s => s.Category)
                    .HasConversion(categoryConverter);
    }
}


