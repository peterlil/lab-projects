using System.ComponentModel.DataAnnotations.Schema;

namespace PetsApi.Models
{
    [Table("dog_breeds")]
    public class DogBreed
    {
        public int Id { get; set; }
        public string Name { get; set; }
        [Column("group_id")]
        public int GroupId { get; set; }
        public DogGroup Group { get; set; }
    }
}
