using EpargneArgents.API.Models;
using EpargneArgents.Business.Services;
using Microsoft.AspNetCore.Mvc;
using System.Net;

namespace EpargneArgents.API.Controllers
{
    /// <summary>
    /// Controller for generating daily contribution CSV files
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class DailyContributionController(IGenerateRandomDailyContribution generateRandomDailyContribution, IConfiguration configuration, IHostEnvironment hostEnvironment) : ControllerBase
    {
        protected readonly IGenerateRandomDailyContribution _generateRandomDailyContribution = generateRandomDailyContribution ?? throw new ArgumentNullException(nameof(generateRandomDailyContribution));
        protected readonly IConfiguration _configuration = configuration ?? throw new ArgumentNullException(nameof(configuration));
        protected readonly IHostEnvironment _hostEnvironment = hostEnvironment ?? throw new ArgumentNullException(nameof(hostEnvironment));

        /// <summary>
        /// Generate a CSV file with daily contribution values
        /// </summary>
        /// <param name="parameters">Parameters for CSV generation (can be null to use config defaults)</param>
        /// <returns>CSV file download</returns>
        [HttpPost]
        [Produces("text/csv")]
        public async Task<IActionResult> Post(Parameters? parameters = null)
        {
            try
            {
                // Use provided parameters or load from configuration
                if (parameters is null)
                {
                    var denominations = _configuration?.GetSection("Parameters")?.GetSection("Denominations")?.Value;
                    var totalAmountStr = _configuration?.GetSection("Parameters")?.GetSection("TotalAmount")?.Value;
                    var numberDaysSavingStr = _configuration?.GetSection("Parameters")?.GetSection("NumberDaysSaving")?.Value;

                    if (string.IsNullOrEmpty(denominations) || string.IsNullOrEmpty(totalAmountStr) || string.IsNullOrEmpty(numberDaysSavingStr))
                    {
                        return BadRequest(new
                        {
                            Message = "Parameters are required or must be configured in appsettings.",
                            StatusCode = (int)HttpStatusCode.BadRequest
                        });
                    }

                    if (!int.TryParse(totalAmountStr, out var totalAmount) || !int.TryParse(numberDaysSavingStr, out var numberDaysSaving))
                    {
                        return BadRequest(new
                        {
                            Message = "Invalid parameter format in configuration.",
                            StatusCode = (int)HttpStatusCode.BadRequest
                        });
                    }

                    parameters = new Parameters
                    {
                        Denominations = denominations,
                        TotalAmount = totalAmount,
                        NumberDaysSaving = numberDaysSaving
                    };
                }

                // Validate parameters
                if (string.IsNullOrWhiteSpace(parameters.Denominations) || 
                    !parameters.TotalAmount.HasValue || parameters.TotalAmount <= 0 ||
                    !parameters.NumberDaysSaving.HasValue || parameters.NumberDaysSaving <= 0)
                {
                    return BadRequest(new
                    {
                        Message = "All parameters must be provided and valid (TotalAmount > 0, NumberDaysSaving > 0)",
                        StatusCode = (int)HttpStatusCode.BadRequest
                    });
                }

                // Parse denominations
                var denominationsList = parameters.Denominations
                    .Split(';')
                    .Select(s => s.Trim())
                    .Where(s => !string.IsNullOrEmpty(s))
                    .Select(s => 
                    {
                        if (!int.TryParse(s, out var value))
                        {
                            throw new ArgumentException($"Invalid denomination value: {s}");
                        }
                        return value;
                    })
                    .ToList();

                if (denominationsList.Count == 0)
                {
                    return BadRequest(new
                    {
                        Message = "Denominations list cannot be empty",
                        StatusCode = (int)HttpStatusCode.BadRequest
                    });
                }

                // Generate daily contributions
                var dailyContributions = _generateRandomDailyContribution.GenerateDailyContribution(
                    denominations: denominationsList,
                    totalAmount: parameters.TotalAmount.Value,
                    numberDaysSaving: parameters.NumberDaysSaving.Value
                );

                dailyContributions.RemoveAll(x => x == 0);

                if (dailyContributions == null || dailyContributions.Count == 0)
                {
                    return NotFound(new
                    {
                        Message = "Unable to generate daily contributions with the provided parameters.",
                        StatusCode = (int)HttpStatusCode.NotFound
                    });
                }

                // Generate CSV file
                var pathGeneratedCsvOutput = Path.Combine(_hostEnvironment.ContentRootPath, "GeneratedCsvOutputFolder");
                var csvFileName = _configuration?.GetSection("Parameters")?.GetSection("CsvFileName")?.Value ?? "daily_contribution.csv";

                var fullPathGeneratedCsvOutput = await _generateRandomDailyContribution.GenerateCsv(
                    dailyContributions,
                    pathGeneratedCsvOutput,
                    csvFileName
                );

                if (string.IsNullOrEmpty(fullPathGeneratedCsvOutput) || !System.IO.File.Exists(fullPathGeneratedCsvOutput))
                {
                    return StatusCode(StatusCodes.Status500InternalServerError, new
                    {
                        Message = "Failed to generate CSV file.",
                        StatusCode = StatusCodes.Status500InternalServerError
                    });
                }

                // Read and return file
                var fileBytes = await System.IO.File.ReadAllBytesAsync(fullPathGeneratedCsvOutput);
                var fileName = Path.GetFileName(fullPathGeneratedCsvOutput);

                return File(fileBytes, "text/csv", fileName);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new
                {
                    Message = $"Invalid input: {ex.Message}",
                    StatusCode = (int)HttpStatusCode.BadRequest
                });
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new
                {
                    Message = "An unexpected error occurred while generating the CSV file.",
                    Details = ex.Message,
                    StatusCode = StatusCodes.Status500InternalServerError
                });
            }
        }
    }
}
