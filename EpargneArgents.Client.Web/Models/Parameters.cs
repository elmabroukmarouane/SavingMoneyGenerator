using System.ComponentModel.DataAnnotations;

namespace EpargneArgents.Client.Web.Models
{
    /// <summary>
    /// Parameters for generating daily contribution CSV file
    /// </summary>
    public class Parameters
    {
        /// <summary>
        /// Comma or semicolon separated list of denominations
        /// </summary>
        [Required(ErrorMessage = "Denominations are required")]
        public string? Denominations { get; set; }

        /// <summary>
        /// Total amount to save
        /// </summary>
        [Required(ErrorMessage = "Total amount is required")]
        [Range(1, int.MaxValue, ErrorMessage = "Total amount must be greater than 0")]
        public int TotalAmount { get; set; }

        /// <summary>
        /// Number of days for the saving plan
        /// </summary>
        [Required(ErrorMessage = "Number of days is required")]
        [Range(1, int.MaxValue, ErrorMessage = "Number of days must be greater than 0")]
        public int NumberDaysSaving { get; set; }
    }
}
