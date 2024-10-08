using Microsoft.EntityFrameworkCore;
using PetsApi.Models;

namespace PetsApi.Data
{
    public class PetsDbContext : DbContext
    {
        public PetsDbContext(DbContextOptions<PetsDbContext> options) : base(options)
        {
        }

        public DbSet<DogGroup> DogGroups { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<DogGroup>().ToTable("dog_groups");
        }
    }
}