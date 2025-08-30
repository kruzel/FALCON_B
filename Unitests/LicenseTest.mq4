//+------------------------------------------------------------------+
//|                                          License Test EA
//|                                        Test license functionality
//+------------------------------------------------------------------+

#property copyright "Test"
#property link      ""
#property version   "1.00"
#property strict

#include <Falcon_B_Include/LicenseManager.mqh>

extern string  LicenseKey = "";       // Enter your license key here
extern bool    EnableTrial = true;    // Allow trial mode

CLicenseManager* LicenseManager;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    Print("=== License Test Starting ===");
    
    // Initialize license manager
    LicenseManager = new CLicenseManager();
    
    Print("License Manager created");
    
    // Get hardware fingerprint
    string hwId = LicenseManager.GetHardwareFingerprint();
    Print("Hardware ID: ", hwId);
    
    // Check license
    bool licenseValid = false;
    
    if(LicenseKey != "" && LicenseManager.CheckLicense(LicenseKey))
    {
        licenseValid = true;
        Print("License validated successfully");
    }
    else if(EnableTrial)
    {
        Print("Checking trial status...");
        int trialDays = LicenseManager.GetTrialDaysRemaining();
        Print("Trial days remaining: ", trialDays);
        
        if(trialDays > 0)
        {
            licenseValid = true;
            Print("Trial mode activated - ", trialDays, " days remaining");
        }
        else
        {
            Print("Trial period expired");
        }
    }
    
    if(!licenseValid)
    {
        Print("LICENSE VALIDATION FAILED!");
        return(INIT_FAILED);
    }
    else
    {
        Print("LICENSE VALIDATION SUCCESSFUL!");
    }
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    if(LicenseManager != NULL)
    {
        delete LicenseManager;
        LicenseManager = NULL;
    }
    
    Print("=== License Test Ended ===");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Do nothing - this is just a license test
}
//+------------------------------------------------------------------+
