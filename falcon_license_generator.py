#!/usr/bin/env python3
"""
Falcon EA License Generator
Copyright 2025, Falcon EA

Independent Python script for generating license keys for Falcon EA customers.
This script generates hardware-bound license keys that work with the Falcon EA licensing system.
"""

import hashlib
import datetime
import json
import os
import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import csv

class FalconLicenseGenerator:
    def __init__(self):
        self.license_records = []
        self.load_license_records()
        
    def generate_license_key(self, hardware_id, customer_name="", expiry_days=0):
        """
        Generate a license key based on hardware ID
        Format: FALCON-XXXXX-XXXXX-XXXXX-XXXX
        """
        # Create validation hash from hardware ID (same algorithm as MQL4)
        hw_hash = 0
        for char in hardware_id:
            hw_hash = (hw_hash * 31 + ord(char)) % 99999
        
        # Generate license segments
        segment1 = (hw_hash * 7 + 12345) % 99999
        seg1 = f"{segment1:05d}"
        
        # Generate additional segments (can include expiry, features, etc.)
        seg2 = "12345"  # Could encode expiry date
        seg3 = "67890"  # Could encode features  
        seg4 = "FHWL"   # Could encode version
        
        # If expiry days specified, encode it in seg2
        if expiry_days > 0:
            expiry_code = (expiry_days % 99999)
            seg2 = f"{expiry_code:05d}"
        
        # Combine into license key
        license_key = f"FALCON-{seg1}-{seg2}-{seg3}-{seg4}"
        
        return license_key
    
    def validate_hardware_id(self, hardware_id):
        """Validate hardware ID format"""
        if not hardware_id:
            return False, "Hardware ID cannot be empty"
        
        if not hardware_id.startswith("FHWL"):
            return False, "Hardware ID must start with 'FHWL'"
        
        if len(hardware_id) < 10:
            return False, "Hardware ID too short"
        
        return True, "Valid"
    
    def save_license_record(self, customer_name, hardware_id, license_key, expiry_days=0):
        """Save license record to JSON file"""
        record = {
            "customer_name": customer_name,
            "hardware_id": hardware_id,
            "license_key": license_key,
            "generated_date": datetime.datetime.now().isoformat(),
            "expiry_days": expiry_days,
            "status": "active"
        }
        
        self.license_records.append(record)
        
        # Save to JSON file
        with open("falcon_license_records.json", "w") as f:
            json.dump(self.license_records, f, indent=2)
        
        # Also save to CSV for easy viewing
        self.export_to_csv()
        
        return record
    
    def load_license_records(self):
        """Load existing license records"""
        try:
            if os.path.exists("falcon_license_records.json"):
                with open("falcon_license_records.json", "r") as f:
                    self.license_records = json.load(f)
        except Exception as e:
            print(f"Error loading license records: {e}")
            self.license_records = []
    
    def export_to_csv(self):
        """Export license records to CSV"""
        if not self.license_records:
            return
        
        with open("falcon_license_records.csv", "w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=["customer_name", "hardware_id", "license_key", "generated_date", "expiry_days", "status"])
            writer.writeheader()
            writer.writerows(self.license_records)
    
    def find_license_by_hardware_id(self, hardware_id):
        """Find existing license for hardware ID"""
        for record in self.license_records:
            if record["hardware_id"] == hardware_id:
                return record
        return None

class LicenseGeneratorGUI:
    def __init__(self):
        self.generator = FalconLicenseGenerator()
        self.create_gui()
    
    def create_gui(self):
        # Create main window
        self.root = tk.Tk()
        self.root.title("Falcon EA License Generator")
        self.root.geometry("800x600")
        
        # Create notebook for tabs
        notebook = ttk.Notebook(self.root)
        notebook.pack(fill='both', expand=True, padx=10, pady=10)
        
        # Tab 1: Generate License
        self.create_generate_tab(notebook)
        
        # Tab 2: View Records
        self.create_records_tab(notebook)
        
        # Tab 3: Bulk Generation
        self.create_bulk_tab(notebook)
    
    def create_generate_tab(self, notebook):
        # Generate License Tab
        generate_frame = ttk.Frame(notebook)
        notebook.add(generate_frame, text="Generate License")
        
        # Customer Information
        info_frame = ttk.LabelFrame(generate_frame, text="Customer Information", padding=10)
        info_frame.pack(fill='x', padx=10, pady=5)
        
        ttk.Label(info_frame, text="Customer Name:").grid(row=0, column=0, sticky='w', pady=2)
        self.customer_name_entry = ttk.Entry(info_frame, width=40)
        self.customer_name_entry.grid(row=0, column=1, sticky='ew', pady=2)
        
        ttk.Label(info_frame, text="Hardware ID:").grid(row=1, column=0, sticky='w', pady=2)
        self.hardware_id_entry = ttk.Entry(info_frame, width=40)
        self.hardware_id_entry.grid(row=1, column=1, sticky='ew', pady=2)
        
        ttk.Label(info_frame, text="Expiry (days, 0=never):").grid(row=2, column=0, sticky='w', pady=2)
        self.expiry_entry = ttk.Entry(info_frame, width=40)
        self.expiry_entry.insert(0, "0")
        self.expiry_entry.grid(row=2, column=1, sticky='ew', pady=2)
        
        info_frame.columnconfigure(1, weight=1)
        
        # Buttons
        button_frame = ttk.Frame(generate_frame)
        button_frame.pack(fill='x', padx=10, pady=5)
        
        ttk.Button(button_frame, text="Generate License Key", command=self.generate_license).pack(side='left', padx=5)
        ttk.Button(button_frame, text="Clear Fields", command=self.clear_fields).pack(side='left', padx=5)
        ttk.Button(button_frame, text="Check Existing", command=self.check_existing).pack(side='left', padx=5)
        
        # Results
        result_frame = ttk.LabelFrame(generate_frame, text="Generated License", padding=10)
        result_frame.pack(fill='both', expand=True, padx=10, pady=5)
        
        self.result_text = tk.Text(result_frame, height=15, wrap='word')
        scrollbar = ttk.Scrollbar(result_frame, orient='vertical', command=self.result_text.yview)
        self.result_text.configure(yscrollcommand=scrollbar.set)
        
        self.result_text.pack(side='left', fill='both', expand=True)
        scrollbar.pack(side='right', fill='y')
        
        # Copy button
        ttk.Button(result_frame, text="Copy License Key", command=self.copy_license_key).pack(pady=5)
    
    def create_records_tab(self, notebook):
        # View Records Tab
        records_frame = ttk.Frame(notebook)
        notebook.add(records_frame, text="License Records")
        
        # Buttons
        button_frame = ttk.Frame(records_frame)
        button_frame.pack(fill='x', padx=10, pady=5)
        
        ttk.Button(button_frame, text="Refresh", command=self.refresh_records).pack(side='left', padx=5)
        ttk.Button(button_frame, text="Export CSV", command=self.export_csv).pack(side='left', padx=5)
        ttk.Button(button_frame, text="Search", command=self.search_records).pack(side='left', padx=5)
        
        # Search entry
        self.search_entry = ttk.Entry(button_frame, width=30)
        self.search_entry.pack(side='left', padx=5)
        self.search_entry.bind('<Return>', lambda e: self.search_records())
        
        # Records tree
        tree_frame = ttk.Frame(records_frame)
        tree_frame.pack(fill='both', expand=True, padx=10, pady=5)
        
        columns = ("Customer", "Hardware ID", "License Key", "Generated", "Expiry", "Status")
        self.records_tree = ttk.Treeview(tree_frame, columns=columns, show='headings', height=20)
        
        for col in columns:
            self.records_tree.heading(col, text=col)
            self.records_tree.column(col, width=120)
        
        # Scrollbars for tree
        v_scrollbar = ttk.Scrollbar(tree_frame, orient='vertical', command=self.records_tree.yview)
        h_scrollbar = ttk.Scrollbar(tree_frame, orient='horizontal', command=self.records_tree.xview)
        self.records_tree.configure(yscrollcommand=v_scrollbar.set, xscrollcommand=h_scrollbar.set)
        
        self.records_tree.pack(side='left', fill='both', expand=True)
        v_scrollbar.pack(side='right', fill='y')
        h_scrollbar.pack(side='bottom', fill='x')
        
        self.refresh_records()
    
    def create_bulk_tab(self, notebook):
        # Bulk Generation Tab
        bulk_frame = ttk.Frame(notebook)
        notebook.add(bulk_frame, text="Bulk Generation")
        
        # Instructions
        inst_frame = ttk.LabelFrame(bulk_frame, text="Instructions", padding=10)
        inst_frame.pack(fill='x', padx=10, pady=5)
        
        instructions = """
        1. Prepare a CSV file with columns: customer_name, hardware_id, expiry_days
        2. Click 'Load CSV File' to select your file
        3. Review the data in the preview
        4. Click 'Generate All Licenses' to process
        """
        ttk.Label(inst_frame, text=instructions, justify='left').pack()
        
        # File selection
        file_frame = ttk.Frame(bulk_frame)
        file_frame.pack(fill='x', padx=10, pady=5)
        
        ttk.Button(file_frame, text="Load CSV File", command=self.load_csv_file).pack(side='left', padx=5)
        self.csv_file_label = ttk.Label(file_frame, text="No file selected")
        self.csv_file_label.pack(side='left', padx=10)
        
        # Preview
        preview_frame = ttk.LabelFrame(bulk_frame, text="Preview", padding=10)
        preview_frame.pack(fill='both', expand=True, padx=10, pady=5)
        
        self.bulk_text = tk.Text(preview_frame, height=15, wrap='none')
        bulk_scrollbar_v = ttk.Scrollbar(preview_frame, orient='vertical', command=self.bulk_text.yview)
        bulk_scrollbar_h = ttk.Scrollbar(preview_frame, orient='horizontal', command=self.bulk_text.xview)
        self.bulk_text.configure(yscrollcommand=bulk_scrollbar_v.set, xscrollcommand=bulk_scrollbar_h.set)
        
        self.bulk_text.pack(side='left', fill='both', expand=True)
        bulk_scrollbar_v.pack(side='right', fill='y')
        bulk_scrollbar_h.pack(side='bottom', fill='x')
        
        # Generate button
        ttk.Button(bulk_frame, text="Generate All Licenses", command=self.generate_bulk_licenses).pack(pady=10)
        
        self.bulk_data = []
    
    def generate_license(self):
        customer_name = self.customer_name_entry.get().strip()
        hardware_id = self.hardware_id_entry.get().strip()
        
        try:
            expiry_days = int(self.expiry_entry.get() or "0")
        except ValueError:
            messagebox.showerror("Error", "Expiry days must be a number")
            return
        
        if not customer_name:
            messagebox.showerror("Error", "Customer name is required")
            return
        
        # Validate hardware ID
        is_valid, message = self.generator.validate_hardware_id(hardware_id)
        if not is_valid:
            messagebox.showerror("Error", f"Invalid Hardware ID: {message}")
            return
        
        # Check if license already exists
        existing = self.generator.find_license_by_hardware_id(hardware_id)
        if existing:
            if not messagebox.askyesno("Warning", 
                f"License already exists for this Hardware ID!\n"
                f"Customer: {existing['customer_name']}\n"
                f"Generated: {existing['generated_date']}\n\n"
                f"Generate new license anyway?"):
                return
        
        # Generate license key
        license_key = self.generator.generate_license_key(hardware_id, customer_name, expiry_days)
        
        # Save record
        record = self.generator.save_license_record(customer_name, hardware_id, license_key, expiry_days)
        
        # Display result
        result = f"""
LICENSE GENERATED SUCCESSFULLY!

Customer Name: {customer_name}
Hardware ID: {hardware_id}
License Key: {license_key}
Generated: {record['generated_date']}
Expiry: {'Never' if expiry_days == 0 else f'{expiry_days} days'}

CUSTOMER INSTRUCTIONS:
1. In Falcon EA settings, enter the license key in 'LicenseKey' field
2. Set 'EnableTrial = false'
3. Restart the EA
4. Verify "Licensed Version" is displayed

SUPPORT INFO:
- License is tied to specific hardware
- Contact support for hardware changes
- Keep license key safe for future use
"""
        
        self.result_text.delete(1.0, tk.END)
        self.result_text.insert(1.0, result)
        self.current_license_key = license_key
        
        # Refresh records if tab is visible
        self.refresh_records()
        
        messagebox.showinfo("Success", f"License generated for {customer_name}")
    
    def clear_fields(self):
        self.customer_name_entry.delete(0, tk.END)
        self.hardware_id_entry.delete(0, tk.END)
        self.expiry_entry.delete(0, tk.END)
        self.expiry_entry.insert(0, "0")
        self.result_text.delete(1.0, tk.END)
    
    def check_existing(self):
        hardware_id = self.hardware_id_entry.get().strip()
        if not hardware_id:
            messagebox.showerror("Error", "Enter Hardware ID to check")
            return
        
        existing = self.generator.find_license_by_hardware_id(hardware_id)
        if existing:
            result = f"""
EXISTING LICENSE FOUND:

Customer: {existing['customer_name']}
Hardware ID: {existing['hardware_id']}
License Key: {existing['license_key']}
Generated: {existing['generated_date']}
Expiry: {'Never' if existing['expiry_days'] == 0 else f"{existing['expiry_days']} days"}
Status: {existing['status']}
"""
            self.result_text.delete(1.0, tk.END)
            self.result_text.insert(1.0, result)
            self.current_license_key = existing['license_key']
        else:
            messagebox.showinfo("Not Found", "No existing license found for this Hardware ID")
    
    def copy_license_key(self):
        if hasattr(self, 'current_license_key'):
            self.root.clipboard_clear()
            self.root.clipboard_append(self.current_license_key)
            messagebox.showinfo("Copied", "License key copied to clipboard")
        else:
            messagebox.showerror("Error", "No license key to copy")
    
    def refresh_records(self):
        # Clear existing items
        for item in self.records_tree.get_children():
            self.records_tree.delete(item)
        
        # Add records
        for record in reversed(self.generator.license_records):  # Show newest first
            generated_date = record['generated_date'][:10] if record['generated_date'] else ""
            expiry_text = "Never" if record.get('expiry_days', 0) == 0 else f"{record['expiry_days']} days"
            
            self.records_tree.insert('', 0, values=(
                record['customer_name'],
                record['hardware_id'][:20] + "..." if len(record['hardware_id']) > 20 else record['hardware_id'],
                record['license_key'],
                generated_date,
                expiry_text,
                record.get('status', 'active')
            ))
    
    def export_csv(self):
        filename = filedialog.asksaveasfilename(
            defaultextension=".csv",
            filetypes=[("CSV files", "*.csv"), ("All files", "*.*")],
            title="Export License Records"
        )
        if filename:
            self.generator.export_to_csv()
            import shutil
            shutil.copy("falcon_license_records.csv", filename)
            messagebox.showinfo("Success", f"Records exported to {filename}")
    
    def search_records(self):
        search_term = self.search_entry.get().strip().lower()
        if not search_term:
            self.refresh_records()
            return
        
        # Clear existing items
        for item in self.records_tree.get_children():
            self.records_tree.delete(item)
        
        # Add matching records
        for record in self.generator.license_records:
            if (search_term in record['customer_name'].lower() or 
                search_term in record['hardware_id'].lower() or 
                search_term in record['license_key'].lower()):
                
                generated_date = record['generated_date'][:10] if record['generated_date'] else ""
                expiry_text = "Never" if record.get('expiry_days', 0) == 0 else f"{record['expiry_days']} days"
                
                self.records_tree.insert('', 0, values=(
                    record['customer_name'],
                    record['hardware_id'][:20] + "..." if len(record['hardware_id']) > 20 else record['hardware_id'],
                    record['license_key'],
                    generated_date,
                    expiry_text,
                    record.get('status', 'active')
                ))
    
    def load_csv_file(self):
        filename = filedialog.askopenfilename(
            filetypes=[("CSV files", "*.csv"), ("All files", "*.*")],
            title="Select CSV file for bulk generation"
        )
        
        if filename:
            try:
                with open(filename, 'r', newline='', encoding='utf-8') as f:
                    reader = csv.DictReader(f)
                    self.bulk_data = list(reader)
                
                # Display preview
                preview_text = f"Loaded {len(self.bulk_data)} records from {os.path.basename(filename)}\n\n"
                preview_text += "Customer Name | Hardware ID | Expiry Days\n"
                preview_text += "-" * 60 + "\n"
                
                for i, row in enumerate(self.bulk_data[:10]):  # Show first 10
                    customer = row.get('customer_name', 'N/A')
                    hardware = row.get('hardware_id', 'N/A')
                    expiry = row.get('expiry_days', '0')
                    preview_text += f"{customer[:20]:<20} | {hardware[:20]:<20} | {expiry}\n"
                
                if len(self.bulk_data) > 10:
                    preview_text += f"\n... and {len(self.bulk_data) - 10} more records"
                
                self.bulk_text.delete(1.0, tk.END)
                self.bulk_text.insert(1.0, preview_text)
                self.csv_file_label.config(text=os.path.basename(filename))
                
            except Exception as e:
                messagebox.showerror("Error", f"Failed to load CSV file: {str(e)}")
    
    def generate_bulk_licenses(self):
        if not self.bulk_data:
            messagebox.showerror("Error", "No data loaded. Please load a CSV file first.")
            return
        
        if not messagebox.askyesno("Confirm", f"Generate {len(self.bulk_data)} license keys?"):
            return
        
        results = []
        errors = []
        
        for i, row in enumerate(self.bulk_data):
            try:
                customer_name = row.get('customer_name', '').strip()
                hardware_id = row.get('hardware_id', '').strip()
                expiry_days = int(row.get('expiry_days', '0') or '0')
                
                if not customer_name or not hardware_id:
                    errors.append(f"Row {i+1}: Missing customer name or hardware ID")
                    continue
                
                # Validate hardware ID
                is_valid, message = self.generator.validate_hardware_id(hardware_id)
                if not is_valid:
                    errors.append(f"Row {i+1}: Invalid Hardware ID - {message}")
                    continue
                
                # Generate license
                license_key = self.generator.generate_license_key(hardware_id, customer_name, expiry_days)
                record = self.generator.save_license_record(customer_name, hardware_id, license_key, expiry_days)
                
                results.append({
                    'customer_name': customer_name,
                    'hardware_id': hardware_id,
                    'license_key': license_key,
                    'expiry_days': expiry_days
                })
                
            except Exception as e:
                errors.append(f"Row {i+1}: {str(e)}")
        
        # Show results
        result_text = f"BULK GENERATION COMPLETE!\n\n"
        result_text += f"Successfully generated: {len(results)} licenses\n"
        result_text += f"Errors: {len(errors)}\n\n"
        
        if errors:
            result_text += "ERRORS:\n"
            for error in errors[:10]:  # Show first 10 errors
                result_text += f"- {error}\n"
            if len(errors) > 10:
                result_text += f"... and {len(errors) - 10} more errors\n"
        
        result_text += f"\nResults saved to falcon_license_records.json and .csv"
        
        self.bulk_text.delete(1.0, tk.END)
        self.bulk_text.insert(1.0, result_text)
        
        self.refresh_records()
        messagebox.showinfo("Complete", f"Generated {len(results)} licenses with {len(errors)} errors")
    
    def run(self):
        self.root.mainloop()

def main():
    """Main function - can be run from command line or GUI"""
    import sys
    
    if len(sys.argv) > 1:
        # Command line mode
        if len(sys.argv) < 3:
            print("Usage: python falcon_license_generator.py <customer_name> <hardware_id> [expiry_days]")
            sys.exit(1)
        
        customer_name = sys.argv[1]
        hardware_id = sys.argv[2]
        expiry_days = int(sys.argv[3]) if len(sys.argv) > 3 else 0
        
        generator = FalconLicenseGenerator()
        
        # Validate hardware ID
        is_valid, message = generator.validate_hardware_id(hardware_id)
        if not is_valid:
            print(f"Error: Invalid Hardware ID - {message}")
            sys.exit(1)
        
        # Generate license
        license_key = generator.generate_license_key(hardware_id, customer_name, expiry_days)
        record = generator.save_license_record(customer_name, hardware_id, license_key, expiry_days)
        
        print(f"License Generated Successfully!")
        print(f"Customer: {customer_name}")
        print(f"Hardware ID: {hardware_id}")
        print(f"License Key: {license_key}")
        print(f"Expiry: {'Never' if expiry_days == 0 else f'{expiry_days} days'}")
        print(f"Record saved to falcon_license_records.json")
        
    else:
        # GUI mode
        app = LicenseGeneratorGUI()
        app.run()

if __name__ == "__main__":
    main()
