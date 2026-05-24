using CsvHelper;
using System.Globalization;

namespace EpargneArgents.Business.Services
{
    public class GenerateRandomDailyContribution : IGenerateRandomDailyContribution
    {
        public List<int> GenerateDailyContribution(List<int>? denominations, int? totalAmount, int? numberDaysSaving)
        {
            // List to store daily contributions
            var dailyContributions = new List<int>();

            var random = new Random();

            // Keep track of the remaining amount
            var remainingAmount = totalAmount;

            // Generate contributions for number of days specified
            for (var day = 1; day <= numberDaysSaving; day++)
            {
                var contribution = 0;

                // Ensure that we either spend the remaining amount or choose a random amount
                if (remainingAmount > 0)
                {
                    contribution = denominations![random.Next(denominations.Count)];
                    if (contribution > remainingAmount)
                    {
                        contribution = (int)remainingAmount; // Limit contribution to remaining amount
                    }
                }

                dailyContributions.Add(contribution);
                remainingAmount -= contribution;

                // If we reach totalAmount, fill the remaining days with 0 contributions
                if (remainingAmount <= 0)
                {
                    // Fill the rest of the year with 0 contributions
                    for (int fillDay = day + 1; fillDay <= numberDaysSaving; fillDay++)
                    {
                        dailyContributions.Add(0);
                    }
                    break;
                }
            }
            return dailyContributions;
        }

        public async Task<string?> GenerateCsv(IList<int> dailyContributions, string pathGeneratedCsvOutput, string fileNameConfig)
        {
            if (string.IsNullOrWhiteSpace(pathGeneratedCsvOutput) || string.IsNullOrWhiteSpace(fileNameConfig))
            {
                throw new ArgumentException("Invalid file path or name");
            }
            if (!Directory.Exists(pathGeneratedCsvOutput))
            {
                Directory.CreateDirectory(pathGeneratedCsvOutput);
            }
            var fileName = $"{fileNameConfig}_{DateTime.Now.ToString("yyyyMMddHHmmss")}.csv";
            var fullPathGeneratedCsvOutput = Path.Combine(pathGeneratedCsvOutput, fileName);
            using var writer = new StreamWriter(fullPathGeneratedCsvOutput);
            using var csv = new CsvWriter(writer, CultureInfo.InvariantCulture);
            await csv.WriteRecordsAsync(dailyContributions);
            return fullPathGeneratedCsvOutput;
        }
    }
}
