var builder = WebApplication.CreateBuilder(args);
builder.WebHost.UseUrls("http://0.0.0.0:5125");
var app = builder.Build();

app.MapPost("/api/metrics", (ServerMetric metric) =>
{
    Console.WriteLine($"Received Data: Disk={metric.DiskUsagePercentage}%, Mem={metric.MemoryUsagePercentage}%");
    return Results.Ok(new { message = "Data received successfully!" });
});

app.Run();

public record ServerMetric(int DiskUsagePercentage, int MemoryUsagePercentage);