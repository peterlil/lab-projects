using System.ComponentModel.DataAnnotations.Schema;

namespace BoatsApi.Models
{
    [Table("boat_manufacturers")]
    public class BoatManufacturer
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }
}