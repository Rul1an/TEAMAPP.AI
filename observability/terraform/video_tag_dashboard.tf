resource "aws_cloudwatch_dashboard" "video_tagging" {
  dashboard_name = "video-tagging"
  dashboard_body = jsonencode({
    widgets = [
      {
        type  = "metric",
        x     = 0,
        y     = 0,
        width = 12,
        height= 6,
        properties = {
          metrics = [["VideoPlatform/Tagging", "LatencyMs", {"stat": "p95"}]],
          view   = "timeSeries",
          title  = "Tagging Latency p95 (ms)"
        }
      }
    ]
  })
}