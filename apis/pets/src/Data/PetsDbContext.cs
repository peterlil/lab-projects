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
        public DbSet<DogBreed> DogBreeds { get; set; }
        public DbSet<Dog> Dogs { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<DogGroup>().ToTable("dog_groups");
            modelBuilder.Entity<DogBreed>().ToTable("dog_breeds");
            modelBuilder.Entity<Dog>().ToTable("dogs");

            modelBuilder.Entity<DogBreed>()
                .Property(b => b.GroupId)
                .HasColumnName("group_id");

            modelBuilder.Entity<Dog>()
                .Property(d => d.BreedId)
                .HasColumnName("breed_id");
        }
    }
}