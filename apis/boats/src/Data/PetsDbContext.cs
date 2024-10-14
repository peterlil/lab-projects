using Microsoft.EntityFrameworkCore;
using BoatsApi.Models;

namespace BoatsApi.Data
{
    public class BoatsDbContext : DbContext
    {
        public BoatsDbContext(DbContextOptions<BoatsDbContext> options) : base(options)
        {
        }

        public DbSet<BoatManufacturer> BoatManufacturers { get; set; }
        public DbSet<BoatModel> BoatModels{ get; set; }
        public DbSet<Boat> Boats{ get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BoatManufacturer>().ToTable("boat_manufacturers");
            modelBuilder.Entity<BoatModel>().ToTable("boat_models");
            modelBuilder.Entity<Boat>().ToTable("boats");

            modelBuilder.Entity<BoatModel>()
                .Property(b => b.ManufacturerId)
                .HasColumnName("manufacturer_id");

            modelBuilder.Entity<Boat>()
                .Property(d => d.ModelId)
                .HasColumnName("model_id");
        }
    }
}