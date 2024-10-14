using System.ComponentModel.DataAnnotations.Schema;

namespace BoatsApi.Models
{
    [Table("boat_models")]
    public class BoatModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        [Column("manufacturer_id")]
        public int ManufacturerId { get; set; }

        public BoatManufacturer Manufacturer { get; set; }
    }
}
