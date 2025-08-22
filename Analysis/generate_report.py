import os
import re
from datetime import datetime
from pathlib import Path

def parse_timestamp_from_filename(filename):
    """Extract timestamp from image filename (assuming format: prefix_YYYY.MM.DD HH-MM-SS.ext)"""
    timestamp_pattern = r'(\d{4}\.\d{2}\.\d{2} \d{2}-\d{2}-\d{2})'
    match = re.search(timestamp_pattern, filename)
    if match:
        timestamp_str = match.group(1)
        return datetime.strptime(timestamp_str, '%Y.%m.%d %H-%M-%S')
    return None

def parse_log_line(line):
    """Extract timestamp from log line"""
    timestamp_pattern = r'(\d{2}:\d{2}:\d{2}\.\d{3})'
    match = re.search(timestamp_pattern, line)
    if match:
        timestamp_str = match.group(1)
        return datetime.strptime(timestamp_str, '%H:%M:%S.%f')
    return None

def generate_trading_report(logs_folder, images_folder, output_file, report_date, symbol):
    """Generate HTML report correlating logs with chart captures"""
    
    # Read all log files
    log_entries = []
    target_date_str = report_date.strftime('%Y%m%d')
    
    for log_file in Path(logs_folder).glob('*.log'):
        # Check if the target date is in the filename
        if target_date_str in log_file.name:
            with open(log_file, 'r', encoding='utf-8', errors='ignore') as f:
                for line in f:
                    # Check if the line contains the requested symbol
                    if symbol in line:
                        timestamp = parse_log_line(line.strip())
                        if timestamp:
                            # Combine the time from log with the report date
                            full_timestamp = datetime.combine(report_date.date(), timestamp.time())
                            if full_timestamp.date() == report_date.date():
                                log_entries.append((full_timestamp, line.strip()))
    
    # Sort log entries by timestamp
    log_entries.sort(key=lambda x: x[0])
    
    # Get all chart images with timestamps
    chart_images = {}
    for img_file in Path(images_folder).glob('*.png'):
        timestamp = parse_timestamp_from_filename(img_file.name)
        if timestamp:
            chart_images[timestamp] = img_file
    
    # Generate HTML report
    with open(output_file, 'w', encoding='utf-8') as f:
        # Write HTML header
        f.write("""<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trading Report</title>
        <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            border-bottom: 3px solid #3498db;
            padding-bottom: 10px;
        }
        h2 {
            color: #34495e;
            border-left: 4px solid #3498db;
            padding-left: 15px;
        }
        .time-group {
            margin-bottom: 40px;
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
        }
        .time-header {
            background-color: #3498db;
            color: white;
            padding: 15px;
            font-size: 18px;
            font-weight: bold;
        }
        .content {
            padding: 20px;
        }
        .chart-section {
            margin-bottom: 20px;
        }
        .chart-section img {
            max-width: 100%;
            height: auto;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .logs-section {
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 15px;
        }
        .logs-section h4 {
            margin-top: 0;
            color: #495057;
        }
        .log-entry {
            background-color: #ffffff;
            color: #000000;
            padding: 10px;
            border-radius: 5px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            white-space: pre-wrap;
            word-wrap: break-word;
            margin-bottom: 5px;
            border-left: 3px solid #4299e1;
        }
        .separator {
            height: 2px;
            background: linear-gradient(to right, #3498db, #2ecc71);
            margin: 20px 0;
        }
        </style>
    </head>
    <body>
        <div class="container">
        <h1>Trading Report</h1>
        <h2>Log Analysis with Chart Captures</h2>
    """)
        
        # Generate report content
        generate_html_content(f, log_entries, chart_images, images_folder)
        
        # Write HTML footer
        f.write("""
    </div>
</body>
</html>""")

def generate_html_content(f, log_entries, chart_images, images_folder):
    """Generate the main content of the HTML report"""
    # Group log entries by timestamp (rounded to nearest minute)
    current_time = None
    current_logs = []
    
    for timestamp, log_line in log_entries:
        rounded_time = timestamp.replace(second=0, microsecond=0)
        
        if current_time != rounded_time:
            # Process previous group
            if current_time and current_logs:
                write_html_time_group(f, current_time, current_logs, chart_images, images_folder)
            
            # Start new group
            current_time = rounded_time
            current_logs = [log_line]
        else:
            current_logs.append(log_line)
    
    # Process last group
    if current_time and current_logs:
        write_html_time_group(f, current_time, current_logs, chart_images, images_folder)

def write_html_time_group(f, timestamp, logs, chart_images, images_folder):
    """Write a group of logs for a specific timestamp in HTML format"""
    f.write('<div class="time-group">\n')
    f.write(f'    <div class="time-header">{timestamp.strftime("%Y-%m-%d %H:%M:%S")}</div>\n')
    f.write('    <div class="content">\n')
    
    # Find closest chart image
    closest_image = find_closest_chart(timestamp, chart_images)
    
    if closest_image:
        relative_path = os.path.relpath(closest_image, os.path.dirname(f.name))
        # Convert Windows path separators to forward slashes for HTML
        relative_path = relative_path.replace('\\', '/')
        f.write('        <div class="chart-section">\n')
        f.write('            <h4>Chart Capture</h4>\n')
        f.write(f'            <img src="{relative_path}" alt="Trading Chart" />\n')
        f.write('        </div>\n')
    
    f.write('        <div class="logs-section">\n')
    f.write('            <h4>Log Entries</h4>\n')
    
    for log in logs:
        # Escape HTML special characters
        escaped_log = log.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
        cleaned_log = escaped_log.replace("Falcon_B_PriceAction", "").strip()
        f.write(f'            <div class="log-entry">{cleaned_log}</div>\n')
    f.write('        </div>\n')
    f.write('    </div>\n')
    f.write('</div>\n\n')

def find_closest_chart(target_time, chart_images):
    """Find chart image closest to target timestamp"""
    closest_image = None
    min_diff = float('inf')
    
    for img_time, img_path in chart_images.items():
        diff = abs((target_time - img_time).total_seconds())
        if diff < min_diff and diff <= 60:  # 1 minute tolerance
            min_diff = diff
            closest_image = img_path

    return closest_image

# Usage example
if __name__ == "__main__":
    symbol = "DE40"
    date = "2025.08.22"

    root_folder = Path(r"C:\Users\Ofer Kruzel\AppData\Roaming\MetaQuotes\Terminal\0A89B723E9501DAD3F2D5CB4F27EBDAB\MQL4")
    logs_folder = root_folder / "Logs"
    images_folder = root_folder / "Files" / "ScreenShots" / symbol

    dt = datetime.strptime(date, "%Y.%m.%d")
    output_file = r"Analysis\trading_report_" + date + ".html"
    
    generate_trading_report(logs_folder, images_folder, output_file, dt, symbol)
    print(f"HTML report generated: {output_file}")