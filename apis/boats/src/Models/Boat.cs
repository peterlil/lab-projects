using System.ComponentModel.DataAnnotations.Schema;

namespace BoatsApi.Models
{
    [Table("boats")]
    public class Boat
    {
        public int Id { get; set; }
        public string Name { get; set; }
        [Column("model_id")]
        public int ModelId { get; set; }
        public BoatModel Model { get; set; }

    }
}
