using Microsoft.AspNetCore.Mvc;

namespace SilentID.Api.Controllers;

[ApiController]
[Route("v1/[controller]")]
public class HealthController : ControllerBase
{
    private readonly ILogger<HealthController> _logger;
    private readonly IConfiguration _configuration;

    public HealthController(ILogger<HealthController> logger, IConfiguration configuration)
    {
        _logger = logger;
        _configuration = configuration;
    }

    /// <summary>
    /// Simple health check endpoint
    /// </summary>
    /// <returns>Health status with basic API info</returns>
    [HttpGet]
    public IActionResult Get()
    {
        var response = new
        {
            status = "healthy",
            application = _configuration["SilentId:ApplicationName"] ?? "SilentID API",
            version = _configuration["SilentId:ApiVersion"] ?? "v1",
            environment = _configuration["SilentId:Environment"] ?? "Unknown",
            timestamp = DateTime.UtcNow
        };

        _logger.LogInformation("Health check requested at {Timestamp}", response.timestamp);

        return Ok(response);
    }
}
