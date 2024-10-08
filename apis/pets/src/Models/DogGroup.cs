using System.ComponentModel.DataAnnotations.Schema;

namespace PetsApi.Models
{
    [Table("dog_groups")]
    public class DogGroup
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }
}