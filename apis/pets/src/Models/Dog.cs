using System.ComponentModel.DataAnnotations.Schema;

namespace PetsApi.Models
{
    [Table("dogs")]
    public class Dog
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Age { get; set; }
        [Column("breed_id")]
        public int BreedId { get; set; }
        public DogBreed Breed { get; set; }

    }
}
