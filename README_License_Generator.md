# 🔐 Falcon EA License Generator

Independent Python application for generating and managing Falcon EA license keys.

## 🚀 Features

### ✅ **GUI Interface**
- **Generate License**: Create individual license keys
- **View Records**: Browse all generated licenses
- **Bulk Generation**: Process multiple licenses from CSV
- **Search & Export**: Find and export license records

### ✅ **Command Line Interface**
- Generate licenses from terminal/command prompt
- Perfect for automation and scripting
- Cross-platform compatibility

### ✅ **License Management**
- Hardware-bound license keys
- Expiry date support (optional)
- Duplicate detection
- JSON and CSV record keeping
- License validation

## 📦 Installation

### **Requirements**
- Python 3.6 or higher
- No external dependencies (uses only standard library)

### **Quick Start**
1. Copy `falcon_license_generator.py` to your computer
2. Double-click `run_license_generator.bat` (Windows)
3. Or run: `python falcon_license_generator.py`

## 🎯 Usage

### **GUI Mode (Recommended)**
```bash
python falcon_license_generator.py
```

Features:
- User-friendly interface
- Real-time validation
- Copy license keys to clipboard
- View all license records
- Search and filter
- Bulk generation from CSV

### **Command Line Mode**
```bash
python falcon_license_generator.py "Customer Name" "FHWL123456X789" [expiry_days]
```

Examples:
```bash
# Generate permanent license
python falcon_license_generator.py "John Smith" "FHWL123456X789"

# Generate 365-day license
python falcon_license_generator.py "Jane Doe" "FHWL987654X321" 365
```

## 📊 Bulk Generation

### **CSV Format**
Create a CSV file with headers:
```csv
customer_name,hardware_id,expiry_days
John Smith,FHWL123456X789,0
Jane Doe,FHWL987654X321,365
Bob Johnson,FHWL111222X333,30
```

### **Process**
1. Open GUI → "Bulk Generation" tab
2. Click "Load CSV File"
3. Review preview
4. Click "Generate All Licenses"

## 🔧 License Key Format

**Format**: `FALCON-XXXXX-XXXXX-XXXXX-XXXX`

**Example**: `FALCON-12345-67890-ABCDE-FHWL`

- **Segment 1**: Hardware ID hash (validation)
- **Segment 2**: Expiry encoding (if applicable)
- **Segment 3**: Feature flags (extensible)
- **Segment 4**: Version identifier

## 📁 Generated Files

### **License Records**
- `falcon_license_records.json` - Complete license database
- `falcon_license_records.csv` - Spreadsheet-friendly export

### **Individual Records**
- Each generation creates timestamped entries
- Includes customer info, hardware ID, license key
- Tracks expiry and status

## 🛡️ Security Features

### **Hardware Binding**
- License keys are mathematically bound to specific hardware
- Uses same algorithm as Falcon EA for validation
- Prevents license key sharing between systems

### **Validation**
- Hardware ID format checking
- Duplicate license detection
- Input sanitization and validation

### **Record Keeping**
- Comprehensive audit trail
- Searchable license database
- Export capabilities for external systems

## 📋 Customer Instructions

When providing license to customers:

### **License Activation Steps**
1. **Install Falcon EA** in MT4
2. **Get Hardware ID** from trial mode display
3. **Receive License Key** from you
4. **Enter License** in EA parameters:
   - Set `LicenseKey = "FALCON-XXXXX-XXXXX-XXXXX-XXXX"`
   - Set `EnableTrial = false`
5. **Restart EA** and verify "Licensed Version" display

### **Customer Support**
- Hardware ID changes require new license
- Keep license key safe for reinstallation
- Contact support for hardware transfers

## 🔄 Integration with Falcon EA

This generator creates license keys that work with the Falcon EA licensing system:

### **EA License Manager** (`LicenseManager.mqh`)
- Validates license format
- Checks hardware binding
- Manages trial periods
- Handles offline validation

### **Compatibility**
- Uses identical validation algorithm
- Same hardware fingerprinting method
- Compatible license key format
- Synchronized security features

## 🎯 Business Benefits

### **For License Vendors**
- ✅ Professional license management
- ✅ Automated bulk generation
- ✅ Complete audit trail
- ✅ No server infrastructure needed
- ✅ Scalable for any number of customers

### **For Customers**
- ✅ Simple activation process
- ✅ Hardware-bound security
- ✅ Offline operation
- ✅ Clear trial period
- ✅ Professional support experience

## 📞 Support & Troubleshooting

### **Common Issues**

**"Invalid Hardware ID"**
- Must start with "FHWL"
- Check for typos in Hardware ID
- Ensure complete Hardware ID copied from EA

**"License already exists"**
- Generator warns about duplicate Hardware IDs
- Choose to generate new license or use existing

**"Python not found"**
- Install Python 3.6+ from python.org
- Ensure Python is in system PATH

### **File Locations**
- `falcon_license_records.json` - Main database
- `falcon_license_records.csv` - CSV export
- Generated in same folder as script

## 🔗 Quick Reference

### **Hardware ID Format**
```
FHWLXXXXXXXXXXXXXXXXX
Example: FHWL123456789X987654321
```

### **License Key Format**
```
FALCON-XXXXX-XXXXX-XXXXX-XXXX
Example: FALCON-12345-67890-ABCDE-FHWL
```

### **File Paths**
- Script: `falcon_license_generator.py`
- Launcher: `run_license_generator.bat`
- Records: `falcon_license_records.json`
- Export: `falcon_license_records.csv`

---

**License Generator Status**: ✅ **FULLY FUNCTIONAL**
**Compatible with**: Falcon EA License System v1.0+
**Last Updated**: August 30, 2025
