namespace EpargneArgents.Business.Services
{
    public interface IGenerateRandomDailyContribution
    {
        List<int> GenerateDailyContribution(List<int>? denominations, int? totalAmount, int? numberDaysSaving);
        Task<string?> GenerateCsv(IList<int> dailyContributions, string pathGeneratedCsvOutput, string fileNameConfig);
    }
}
