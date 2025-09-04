//+------------------------------------------------------------------+
//|                                          Awesome EA Template v2.0
//|                                        Copyright 2025,Ofer Kruzel
//|                                             okruzel@gmail.com
//+------------------------------------------------------------------+

#property copyright "Copyright 2025, Black Algo Technologies Pte Ltd"
#property copyright "Copyright 2025, Ofer Kruzel"
#property link      "okruzel@gmail.com"
// #property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "1.0"  
#property strict
/* 

Falcon B: 
- Adding specific functions to manage Decision Support System

*/

//+------------------------------------------------------------------+
//| Setup                                               
//+------------------------------------------------------------------+
extern string  Version                           =  "1.0";                   

extern string  HeaderLicense="----------License Settings-----------";
extern string  LicenseKey                       = "";       // License Key (Format: FALCON-XXXXX-XXXXX-XXXXX-XXXX)
bool    EnableTrial                      = true;     // Allow trial mode (7 days)

extern string  Header21="----------Trading time settings-----------";
extern int     TradingStartHour                 = 0;        // Start hour for trading (0-23)
extern int     TradingEndHour                   = 23;       // End hour for trading (0-23)
extern int     TradingStartMinute               = 0;        // Start minute for trading (0-59)
extern int     TradingEndMinute                 = 59;       // End minute for trading (0-59)

extern string  Header1="----------EA General Settings-----------";
extern int     MagicNumber                      = 8118201;
extern int     TerminalType                     = 1;         //0 mean slave, 1 mean master
extern bool    R_Management                     = False;      //R_Management true will enable Decision Support Centre (using R)
extern int     Slippage                         = 2; // Slippage in Pips
extern bool    IsECNbroker                      = False; // Is your broker an ECN
extern bool    OnJournaling                     = True; // Add EA updates in the Journal Tab
extern bool    OnChartShots                     = False; // Add EA updates in the Chart Shots
extern bool    ShowLotSizeOnChart               = True; // Display lot size near entry points

extern string  Header3="----------Position Sizing Settings-----------";
extern double  Lots                             = 0.01; 
extern bool    IsSizingOn                       = True; // Risk based sizing, ignore fixed lots
extern double  Risk                             = 1; // Risk per trade (%)
extern int     MaxPositionsAllowed              = 1;
extern double  LotAdjustFactor                  = 1; // Lot Adjustment Factor, for Yen set to 100

extern string  Header24="----------Trading Limits Settings-----------";
extern double  MaxSpread                        = 50; // Maximum spread (Points)
extern bool    UseMaxSpreadATR                  = True;
extern double  MaxSpreadATRMultiplier           = 0.3; // Maximum spread (ATR Multiplier)
extern double  MinBarSize                       = 50; // Minimum bar size (Points)

extern string  Header23="----------Arears Management Settings-----------";
extern bool    IsArearsManagementEnabled          = True; // Enable Arears Money Management
extern double  ArearsMMSizeIncrement            = 0.5; // Arears Money Management increment %
extern double  ArearsMMMaxMultiplier            = 3.0; // Maximum risk multiplier (safety cap)
extern bool    UseProgressiveArears             = True; // Use progressive recovery calculation

extern string  Header13="----------Set Max Loss Win Limit settings-----------";
extern bool    IsLossLimitActivated             = True; // Enable Max Loss Limit
extern double  LossLimitPercent                 = -3.0; // Loss Limit (%)
extern bool    IsWinLimitActivated              = True; // Enable Max Win Limit
extern double  WinLimitPercent                  = 3.0; // Win Limit (%)

extern string  Header20="----------Breakout settings -----------";
extern int     MaxConsecutiveFailures           = 99; // Max consecutive failures, then wait for breakout
extern bool    UseBreakoutPoints                = False;
extern int     BreakoutMarginPoints             = 10; // Breakout Margin (Points)
extern bool    UseBreakoutATR                   = True;
extern double  BreakoutMarginATRMultiplier      = 0.2; // Breakout Distance (ATR Multiplier)

extern string  Header4="----------TP & SL Settings-----------";
extern bool    SlTpbyLastBar                    = True; // Use the last bar's high/low as Stop Loss
extern double  TpSlRatio                        = 1.0; // Take Profit to Stop Loss Ratio
extern double  MinStopLossATRMultiplier         = 1.2; // Min Stop Loss ATR multiplier
extern double  MaxStopLossATRMultiplier         = 2; // Max Stop Loss ATR Multiplier
extern double  StopBarMargin                    = 10; // stop loss margin (% bar size)
extern bool    UseFixedStopLoss                 = False; // Fixed size stop loss
extern double  FixedStopLoss                    = 0; // Hard Stop in Pips. Will be overridden if vol-based SL is true 
extern bool    IsVolatilityStopOn               = False;
extern double  VolBasedSLMultiplier             = 2; // Stop Loss Amount in units of Volatility
extern double  StopLossMarginATRMultiplier      = 0.5; // Stop Loss margin ATR Multiplier


extern bool    UseFixedTakeProfit               = False; // Fixed size take profit
extern double  FixedTakeProfit                  = 0; // Hard Take Profit in Pips. Will be overridden if vol-based TP is true 
extern bool    IsVolatilityTakeProfitOn         = False;
extern double  VolBasedTPMultiplier             = 6; // Take Profit Amount in units of Volatility
extern double  TakeProfitMarginATRMultiplier    = 0.5; // Take Profit margin ATR Multiplier
extern double  MinTakeProfitATRMultiplier       = 0.5; // Min Take Profit margin ATR Multiplier

extern string  Header5="----------Hidden TP & SL Settings-----------";
extern bool    UseHiddenStopLoss                = False;
extern double  FixedStopLoss_Hidden             = 0; // In Pips. Will be overridden if hidden vol-based SL is true 
extern bool    IsVolatilityStopLossOn_Hidden    = False;
extern double  VolBasedSLMultiplier_Hidden      = 0; // Stop Loss Amount in units of Volatility

extern bool    UseHiddenTakeProfit              = False;
extern double  FixedTakeProfit_Hidden           = 0; // In Pips. Will be overridden if hidden vol-based TP is true 
extern bool    IsVolatilityTakeProfitOn_Hidden  = False;
extern double  VolBasedTPMultiplier_Hidden      = 0; // Take Profit Amount in units of Volatility

extern string  Header6="----------Breakeven Stops Settings-----------";
extern bool    UseBreakevenStops                = False;
extern double  BreakevenBuffer                  = 0; // In pips

extern string  Header7="----------Hidden Breakeven Stops Settings-----------";
extern bool    UseHiddenBreakevenStops          = False;
extern double  BreakevenBuffer_Hidden           = 0; // In pips

extern string  Header8="----------Trailing Stops Settings-----------";
extern bool    UseTrailingStops                 = False;
extern double  TrailingStopDistance             = 10; // In pips
extern double  TrailingStopBuffer               = 10; // In pips

extern string  Header9="----------Hidden Trailing Stops Settings-----------";
extern bool    UseHiddenTrailingStops           = False;
extern double  TrailingStopDistance_Hidden      = 0; // In pips
extern double  TrailingStopBuffer_Hidden        = 0; // In pips

extern string  Header10="----------Volatility Trailing Stops Settings-----------";
extern bool    UseVolTrailingStops              = False;
extern double  VolTrailingDistMultiplier        = 1; // Trailing distance In units of ATR
extern double  VolTrailingBuffMultiplier        = 0.3; // Trailing buffer In units of ATR

extern string  Header11="----------Hidden Volatility Trailing Stops Settings-----------";
extern bool    UseHiddenVolTrailing             = False;
extern double  VolTrailingDistMultiplier_Hidden = 0; // Trailing distance In units of ATR
extern double  VolTrailingBuffMultiplier_Hidden = 0; // In units of ATR

extern string  Header12="----------Volatility Measurement Settings-----------";
extern int     atr_period                       = 5; // ATR period for volatility measurement

extern string  Header14="----------Set Max Volatility Limit-----------";
extern bool    IsVolLimitActivated              = False;
extern double  VolatilityMultiplier             = 3; // In units of ATR
extern int     ATRTimeframe                     = 60; // In minutes
extern int     ATRPeriod                        = 14;

extern string  Header15="----------PipFinite rules settings-----------";
extern bool    UsePipFiniteEntry                = True;    // Use PipFinite Trend PRO
extern int     PipFinite_Period                 = 3;       // PipFinite Trend PRO Period
extern double  PipFinite_TargetFactor           = 2.0;     // PipFinite Trend PRO Target Factor
extern int     PipFinite_MaxHistoryBars         = 3000;    // PipFinite Trend PRO Maximum History Bars
extern int     PipFinite_UptrendBuffer          = 10;       // PipFinite Uptrend Buffer Number
extern int     PipFinite_DowntrendBuffer        = 11;       // PipFinite Downtrend Buffer Number

extern string  Header16="----------Support Resistance rules settings-----------";
extern bool    UseSupportResistance             = False;     // Use Support/Resistance Threshold
extern int     SRmarginPoints                   = 1;       // Support/Resistance threshold (Points))
extern int     zigzagDepth                      = 12;       // ZigZag Depth
extern int     zigzagDeviation                  = 5;        // ZigZag Deviation
extern int     zigzagBackstep                   = 3;        // ZigZag Backstep

extern string  Header17="---------- Supply and Demand rules settings-----------";
extern bool    UseSupplyDemandPoints            = False;     // Use Supply and Demand Zones
extern int     supplyDemandMarginPoints         = 1;       // Supply / Demand margin (Points)
extern bool    UseSupplyDemandATR               = True;     // Use Supply and Demand Zones (ATR)
extern double  supplyDemandMarginATR            = 0.3;       // Supply / Demand margin (ATR)

extern string  Header18="----------Trend rules settings-----------";
extern bool    UseReversal                      = True;     // Use Reversal 

extern string  Header19="----------Mean reversal settings-----------";
extern bool    UseMeanReversalPoints            = False;     // Use Mean Reversal (Points)
extern int     MeanReversalDistancePoints       = 5;       // Mean Reversal Distance (Points)
extern bool    UseMeanReversalATR               = False;     // Use Mean Reversal (ATR)
extern double  MeanReversalATRMultiplier        = 1;      // Mean Reversal ATR Multiplier
extern double  MeanReversalLoHiDistance         = 5;    // Mean Reversal Low-High Distance Multiplier (in ATR units)

#include <Falcon_B_Include/LicenseManager.mqh>
#include <Falcon_B_Include/01_GetHistoryOrder.mqh>
#include <Falcon_B_Include/02_OrderProfitToCSV.mqh>
#include <Falcon_B_Include/03_ReadCommandFromCSV.mqh>
#include <Falcon_B_Include/08_TerminalNumber.mqh>
#include <Falcon_B_Include/10_isNewBar.mqh>
#include <Falcon_B_Include/enums.mqh>
#include <Falcon_B_Include/PriceActionStates.mqh>
#include <Falcon_B_Include/SupportResistance.mqh>
#include <Falcon_B_Include/PinBarDetector.mqh>
#include <Falcon_B_Include/TradingControl.mqh>
#include <Falcon_B_Include/02_OrderProfitToCSV.mqh>

string  InternalHeader1="----------Errors Handling Settings-----------";
int     RetryInterval                           = 100; // Pause Time before next retry (in milliseconds)
int     MaxRetriesPerTick                       = 10;

string  InternalHeader2="----------Service Variables-----------";

CLicenseManager* LicenseManager;  // License management system

int currentTerminal;

double Stop,Take;
double StopHidden,TakeHidden;

int    PipFactor;
double myATR;
double UpdatedRisk = Risk;

double PipFiniteUptrendSignal1, PipFiniteDowntrendSignal1;
int EntrySignal;

CSupportResistance* SupportResistance;
CTradingControl* TradeController;
CPriceActionStates* PriceActionStates;

double prev_ner_hi_zone_P1 = -1;
double prev_ner_hi_zone_P2 = -1;
double prev_ner_lo_zone_P1 = -1;
double prev_ner_lo_zone_P2 = -1;

int Trigger;
int SRTriggered;
bool IsMeanReversal = false; // Flag for mean reversal condition
bool lastOrderClosedByStopLoss = false;
bool IsPinBar = false;

enum BreakoutStates
{
  BO_NORMAL = 0,
  BO_WAITING = 1,
  BO_TRIGGERED = 2
};

BreakoutStates BreakoutState = BO_NORMAL; // Flag for breakout condition

int OrderNumber;
double HiddenSLList[][2]; // First dimension is for position ticket numbers, second is for the SL Levels
double HiddenTPList[][2]; // First dimension is for position ticket numbers, second is for the TP Levels
double HiddenBEList[]; // First dimension is for position ticket numbers
double HiddenTrailingList[][2]; // First dimension is for position ticket numbers, second is for the hidden trailing stop levels
double VolTrailingList[][2]; // First dimension is for position ticket numbers, second is for recording of volatility amount (one unit of ATR) at the time of trade
double HiddenVolTrailingList[][3]; // First dimension is for position ticket numbers, second is for the hidden trailing stop levels, third is for recording of volatility amount (one unit of ATR) at the time of trade

string  InternalHeader3="----------Decision Support Variables-----------";
bool     TradeAllowed = true; 
datetime ReferenceTime;       //used for order history


#define ZONE_SUPPORT 1
#define ZONE_RESIST  2

#define ZONE_WEAK      0
#define ZONE_TURNCOAT  1
#define ZONE_UNTESTED  2
#define ZONE_VERIFIED  3
#define ZONE_PROVEN    4

//+------------------------------------------------------------------+
//| End of Setup                                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert Initialization                                    
//+------------------------------------------------------------------+
int init()
  {
   
//------------- License Check
   // Initialize license manager
   LicenseManager = new CLicenseManager();
   
   // Check license
   bool licenseValid = false;
   
   if(LicenseKey != "" && LicenseManager.CheckLicense(LicenseKey))
   {
       licenseValid = true;
       Comment("Falcon EA - Licensed Version - HW: " + StringSubstr(LicenseManager.GetHardwareFingerprint(), 0, 12));
       
       // Check if license is expiring soon
       if(LicenseManager.IsLicenseExpiringSoon())
       {
           Alert("Warning: Your license will expire soon! Please renew.");
       }
   }
   else if(EnableTrial)
   {
       int trialDays = LicenseManager.GetTrialDaysRemaining();
       if(OnJournaling) Print("Trial days remaining: ", trialDays);
       
       if(trialDays > 0)
       {
           licenseValid = true;
           Comment("Falcon EA - Trial Mode (" + IntegerToString(trialDays) + " days remaining) - HW: " + StringSubstr(LicenseManager.GetHardwareFingerprint(), 0, 12));
           
           // Warning when trial is expiring
           if(trialDays <= 3)
           {
               Alert("Trial expires in " + IntegerToString(trialDays) + " days! Hardware ID: " + LicenseManager.GetHardwareFingerprint());
           }
       }
       else
       {
           Comment("Trial period expired! Please purchase a license. Hardware ID: " + LicenseManager.GetHardwareFingerprint());
           if(OnJournaling) Print("Trial period expired! Hardware ID: " + LicenseManager.GetHardwareFingerprint());
       }
   }
   
   if(!licenseValid)
   {
       Alert("No valid license found! Hardware ID: " + LicenseManager.GetHardwareFingerprint());
       return(INIT_FAILED);
   }

//------------- Decision Support Centre
// Write file to the sandbox if it's does not exist
//    
   ReferenceTime = TimeCurrent(); // record time for order history function
   currentTerminal = T_Num();
   
   //write file system control to enable initial trading
   TradeAllowed = ReadCommandFromCSV(MagicNumber);
      if(TradeAllowed == false)
     {
      Comment("Trade is not allowed");
     }
   else if(TradeAllowed == true)   // or file does not exist, create a new file
            {
               string fileName = "SystemControl"+string(MagicNumber)+".csv";//create the name of the file same for all symbols...
               // open file handle
               int handle = FileOpen(fileName,FILE_CSV|FILE_READ|FILE_WRITE); FileSeek(handle,0,SEEK_END);
               string data = string(MagicNumber)+","+string(TerminalType);
               FileWrite(handle,data);  FileClose(handle);
               //end of writing to file
               Comment("Trade is allowed");
            }
            
                
   
   PipFactor=GetPipFactor(); // To account for 5 digit brokers. Used to convert pips to decimal place

//----------(Hidden) TP, SL and Breakeven Stops Variables-----------  

// If EA disconnects abruptly and there are open positions from this EA, records form these arrays will be gone.
   if(UseHiddenStopLoss) ArrayResize(HiddenSLList,MaxPositionsAllowed,0);
   if(UseHiddenTakeProfit) ArrayResize(HiddenTPList,MaxPositionsAllowed,0);
   if(UseHiddenBreakevenStops) ArrayResize(HiddenBEList,MaxPositionsAllowed,0);
   if(UseHiddenTrailingStops) ArrayResize(HiddenTrailingList,MaxPositionsAllowed,0);
   if(UseVolTrailingStops) ArrayResize(VolTrailingList,MaxPositionsAllowed,0);
   if(UseHiddenVolTrailing) ArrayResize(HiddenVolTrailingList,MaxPositionsAllowed,0);

   PriceActionStates = new CPriceActionStates();
   PriceActionStates.Init();
   if(UseSupportResistance)
    SupportResistance = new CSupportResistance(SRmarginPoints, zigzagDepth,zigzagDeviation, zigzagBackstep); // margin=10 points, ZigZag params

    TradeController = new CTradingControl();
    TradeController.CreateController(LossLimitPercent, WinLimitPercent, IsTesting(), Version);

   PaResults paState = PriceActionStates.ProcessBars(1);
   if(UseSupportResistance)
    SupportResistance.SRUpdate(0); // Update for current bar
  
    if(UseSupplyDemandPoints || UseSupplyDemandATR)
   {
      iCustom(NULL, 0, "Falcon_B_Indicator\\supply_and_demand_v1.8", 4, 0); // Get Supply Zone High
   }

  UpdatedRisk = CalculateArearsRisk();

  if(IsTesting() && OnChartShots)
  {
    // Delete all screenshot files in the ScreenShots folder
    string folderPath = "ScreenShots\\*";
    string filename;
    long search_handle = FileFindFirst(folderPath, filename);

    if(search_handle != INVALID_HANDLE)
    {
      do
      {
        if(filename != "." && filename != "..")
        {
          string fullPath = "ScreenShots\\" + filename;
          if(FileDelete(fullPath))
          {
            Print("Deleted screenshot: ", fullPath);
          }
          else
          {
            Print("Failed to delete: ", fullPath);
          }
        }
      }
      while(FileFindNext(search_handle, filename));
      
      FileFindClose(search_handle);
    }
    else
    {
      Print("No screenshot files found or failed to access ScreenShots folder");
    }
  }

   start();
   return(0);
  }
//+------------------------------------------------------------------+
//| End of Expert Initialization                            
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert Deinitialization                                  
//+------------------------------------------------------------------+
int deinit()
  {
//----
    if(PriceActionStates != NULL)
      {
        PriceActionStates.Deinit();
        delete PriceActionStates;
        PriceActionStates = NULL;
      }
    if(UseSupportResistance)
      delete SupportResistance;

    if(TradeController != NULL)
      {
        TradeController.DeleteController();
        delete TradeController;
        TradeController = NULL;
      }

   string str = "signal_";
   int total = ObjectsTotal();
    // Loop backwards to avoid skipping objects when deleting
    for(int i = total - 1; i >= 0; i--)
    {
        string name = ObjectName(i);
        if(StringFind(name, str) != -1)
        {
            ObjectDelete(name);
        }
    }

    str = "peak_";
    // Loop backwards to avoid skipping objects when deleting
    for(int i = total - 1; i >= 0; i--)
    {
        string name = ObjectName(i);
        if(StringFind(name, str) != -1)
        {
            ObjectDelete(name);
        }
    }

    str = "result_";
    // Loop backwards to avoid skipping objects when deleting
    for(int i = total - 1; i >= 0; i--)
    {
        string name = ObjectName(i);
        if(StringFind(name, str) != -1)
        {
            ObjectDelete(name);
        }
    }

    str = "risksize_";
    // Loop backwards to avoid skipping objects when deleting
    for(int i = total - 1; i >= 0; i--)
    {
        string name = ObjectName(i);
        if(StringFind(name, str) != -1)
        {
            ObjectDelete(name);
        }
    }
    
    // Cleanup license manager
    if(LicenseManager != NULL)
    {
        delete LicenseManager;
        LicenseManager = NULL;
    }
    
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| End of Expert Deinitialization                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert start                                             
//+------------------------------------------------------------------+
int start()
  {
    // Check license validity periodically
    static datetime lastLicenseCheck = 0;
    if(TimeCurrent() - lastLicenseCheck > 3600) // Check every hour
    {
        if(LicenseManager != NULL && !LicenseManager.IsLicenseValid())
        {
            if(EnableTrial)
            {
                int trialDays = LicenseManager.GetTrialDaysRemaining();
                if(trialDays <= 0)
                {
                    Comment("Trial expired! EA stopped. Hardware ID: " + LicenseManager.GetHardwareFingerprint());
                    return(0);
                }
                Comment("Trial Mode (" + IntegerToString(trialDays) + " days remaining)");
            }
            else
            {
                Comment("License invalid! EA stopped. Hardware ID: " + LicenseManager.GetHardwareFingerprint());
                return(0);
            }
        }
        lastLicenseCheck = TimeCurrent();
    }
    
    Trigger = 0; // Reset trigger for entry/exit signals
    // lastOrderClosedByStopLoss = false;
    IsMeanReversal = false;

    static int lastOpenOrder = 0;
    int newOpenOrder = GetLastOpenOrder(MagicNumber, Symbol());
    if(lastOpenOrder != newOpenOrder)
    {
      lastOpenOrder = newOpenOrder;
      // UpdateStopLossTakeProfitAll(OnJournaling,RetryInterval,MagicNumber,PipFactor);
      SaveChart();
    }

    static int lastOrder = 0;
    int newClosedOrder = GetLastClosedOrderToday(MagicNumber, Symbol());
    if(lastOrder!=newClosedOrder)
    {
      lastOrder = newClosedOrder;
      SaveChart();

      double price;
      double profit;
      int type;
      int order;
      datetime time;
      CloseReason closeReason;
      if(GetLastProfit(MagicNumber, order, time, profit, type, price, closeReason, Symbol()))
      {
        // Compare hours and minutes of time with Time[0]
        int timeHour = TimeHour(time);
        int timeMinute = TimeMinute(time);
        int currentBarHour = TimeHour(Time[0]);
        int currentBarMinute = TimeMinute(Time[0]);
        int prvBarHour = TimeHour(Time[1]);
        int prvBarMinute = TimeMinute(Time[1]);

        if((timeHour == currentBarHour && timeMinute == currentBarMinute) ||
           (timeHour == prvBarHour && timeMinute == prvBarMinute))
        {
          if(profit < 0)
          {
            if(closeReason == StopLoss)
            {
              if(type==OP_BUY)
              {
                // Last trade was a losing buy, trigger a sell
                Trigger = 2;
                if(OnJournaling) Print("Entry Signal - SELL after losing BUY trade");
              }
              else if(type==OP_SELL) 
              {
                // Last trade was a losing sell, trigger a buy
                Trigger = 1;
                if(OnJournaling) Print("Entry Signal - BUY after losing SELL trade"); 
              }
              
            }
            lastOrderClosedByStopLoss = true;
            VisualizeResultOverlay(time, 2, price);
          }
          else if(profit > 0)
          {
            VisualizeResultOverlay(time, 1, price);
          }

          UpdatedRisk = CalculateArearsRisk();
        }
      }
    }

    //----------TP, SL, Breakeven and Trailing Stops Variables-----------
   if(UseBreakevenStops) BreakevenStopAll(OnJournaling,RetryInterval,BreakevenBuffer,MagicNumber,PipFactor);
   if(UseTrailingStops) TrailingStopAll(OnJournaling,TrailingStopDistance,TrailingStopBuffer,RetryInterval,MagicNumber,PipFactor);
   if(UseVolTrailingStops) {
      UpdateVolTrailingList(OnJournaling,RetryInterval,MagicNumber);
      ReviewVolTrailingStop(OnJournaling,VolTrailingDistMultiplier,VolTrailingBuffMultiplier,RetryInterval,MagicNumber,PipFactor);
   }
//----------(Hidden) TP, SL, Breakeven and Trailing Stops Variables-----------  

   if(UseHiddenStopLoss) TriggerStopLossHidden(OnJournaling,RetryInterval,MagicNumber,Slippage,PipFactor);
   if(UseHiddenTakeProfit) TriggerTakeProfitHidden(OnJournaling,RetryInterval,MagicNumber,Slippage,PipFactor);
   if(UseHiddenBreakevenStops) { 
      UpdateHiddenBEList(OnJournaling,RetryInterval,MagicNumber);
      SetAndTriggerBEHidden(OnJournaling,BreakevenBuffer,MagicNumber,Slippage,PipFactor,RetryInterval);
   }
   if(UseHiddenTrailingStops) {
      UpdateHiddenTrailingList(OnJournaling,RetryInterval,MagicNumber);
      SetAndTriggerHiddenTrailing(OnJournaling,TrailingStopDistance_Hidden,TrailingStopBuffer_Hidden,Slippage,RetryInterval,MagicNumber,PipFactor);
   }
   if(UseHiddenVolTrailing) {
      UpdateHiddenVolTrailingList(OnJournaling,RetryInterval,MagicNumber);
      TriggerAndReviewHiddenVolTrailing(OnJournaling,VolTrailingDistMultiplier_Hidden,VolTrailingBuffMultiplier_Hidden,Slippage,RetryInterval,MagicNumber,PipFactor);
   }

//--------- Check if its a new bar -------------------------
    if(!isNewBar() && Trigger==0)
      return (0);

//----------Order management through R - to avoid slow down the system only enable with external parameters
   if(R_Management)
     {
         //code that only executed once a bar
      //   Direction = -1; //set direction to -1 by default in order to achieve cross!
         int terminalNum = T_Num();
         OrderProfitToCSV(terminalNum);                        //write previous orders profit results for auto analysis in R
         TradeAllowed = ReadCommandFromCSV(terminalNum);              //read command from R to make sure trading is allowed
      //   Direction = ReadAutoPrediction(MagicNumber, -1);             //get prediction from R for trade direction         
     }

   SaveChart(); // for debugging

   OrderProfitToCSV(currentTerminal);

//----------states update-----------
// variables to reset
   OrderNumber=0; // OrderNumber used in Entry Rules
   double currentSpread = MarketInfo(Symbol(), MODE_SPREAD); //points
   bool IsAfterExit = false;
   IsPinBar = false;
  
  if(!lastOrderClosedByStopLoss)
  {
    UpdatedRisk = CalculateArearsRisk();
    // if(OnJournaling) Print("Updated Risk: ", UpdatedRisk, "%");
  }

   myATR=iATR(NULL,Period(),atr_period,1);

   
   if(UseBreakoutATR)
      BreakoutMarginPoints = BreakoutMarginATRMultiplier * myATR / Point;

   PaResults paState = PriceActionStates.ProcessBars(1);
   if(UseSupportResistance)
    SupportResistance.SRUpdate(0); // Update for current bar
  
    if(!IsTesting() && !TradeController.IsTradingEnabled())
      {
        if(OnJournaling) Print("Trading is disabled, click the button to enable trading.");
        return (0);
      } 

    LossLimitPercent = TradeController.GetLossTarget();
    WinLimitPercent = TradeController.GetWinTarget();

    if(TradingStartHour!=-1 && TradingEndHour!=-1 && TradingStartMinute!=-1 && TradingEndMinute!=-1)
    {
      datetime localTime = TimeLocal();
      int currentHour = TimeHour(localTime);
      int currentMinute = TimeMinute(localTime);

      bool isBeforeStart = (currentHour < TradingStartHour) || (currentHour == TradingStartHour && currentMinute < TradingStartMinute);
      bool isAfterEnd = (currentHour > TradingEndHour) || (currentHour == TradingEndHour && currentMinute > TradingEndMinute);

      if (TradingStartHour <= TradingEndHour) // Normal time range within the same day
      {
        if (isBeforeStart || isAfterEnd)
        {
          if (OnJournaling) Print("waiting for valid trading time: ", TradingStartHour, ":", TradingStartMinute);
          return (0);
        }
      }
      else if (!isBeforeStart && !isAfterEnd) // Time range spans midnight
      {
        if (OnJournaling) Print("waiting for valid trading time: ", TradingStartHour, ":", TradingStartMinute);
        return (0);
      }
    }

    if(UseMaxSpreadATR)
        MaxSpread = myATR / Point * MaxSpreadATRMultiplier;

    if( currentSpread  > MaxSpread )
    {
      if(OnJournaling) Print("Current spread is too high: ", NormalizeDouble(currentSpread, 1), " points. Max allowed: ", NormalizeDouble(MaxSpread, 1), " points");
      return (0); // Exit if spread is too high
    }

    if(MathAbs(Close[1] - Open[1]) < MinBarSize * Point)
    {
      if(OnJournaling) Print("Previous bar size is too small: ", NormalizeDouble(MathAbs(Close[1] - Open[1])/Point,1), " points. Min required: ", MinBarSize, " points");
      return (0); // Exit if previous bar size is too small
    }

 
   //----------Entry & Exit rules -----------

   if(CountPosOrders(MagicNumber,-1) == 0)
    {
      // check continuation after retracement
      if(paState.prevTrendState == UP_TREND_RETRACEMENT && paState.trendState == UP_TREND && BreakoutState!=BO_WAITING)
      {
          Trigger = 1; // Buy signal
          if(OnJournaling) Print("Entry Signal - BUY on UP_TREND after UP retracement");
      }
      else if(paState.prevTrendState == DOWN_TREND_RETRACEMENT && paState.trendState == DOWN_TREND && BreakoutState!=BO_WAITING)
      {
          Trigger = 2; // Sell signal
            if(OnJournaling) Print("Entry Signal - SELL on DOWN_TREND after DOWN retracement");
      }
      else if(paState.prevTrendState == DOWN_TREND_RETRACEMENT && paState.trendState == UP_TREND && BreakoutState!=BO_WAITING)
      {
          Trigger = 1; // Buy signal
          if(OnJournaling) Print("Entry Signal - BUY on UP_TREND after DOWN retracement (reversal)");
      }
      else if(paState.prevTrendState == UP_TREND_RETRACEMENT && paState.trendState == DOWN_TREND && BreakoutState!=BO_WAITING)
      {
          Trigger = 2; // Sell signal
            if(OnJournaling) Print("Entry Signal - SELL on DOWN_TREND after UP retracement (reversal)");
      }

      //check breakout
      if(paState.trendState == UP_TREND && BreakoutState == BO_WAITING)
      {
          // if(OnJournaling) Print("checking breakout, margin: ", BreakoutMarginPoints*Point);
          PriceActionState peaksState = PriceActionStates.GetPrevPeaks();
          if(Close[1] > peaksState.peakCloseHighest + BreakoutMarginPoints*Point && peaksState.peakStateHighest==HIGHER_HIGH_PEAK)
          {
            BreakoutState = BO_TRIGGERED; // set breakout flag
            Trigger = 1; // Buy signal
            if(OnJournaling) Print("Entry Signal - BUY on breakout");
          }
      }
      else if(paState.trendState == DOWN_TREND && BreakoutState == BO_WAITING)
      {
          // if(OnJournaling) Print("checking breakout, margin: ", BreakoutMarginPoints*Point);
          PriceActionState peaksState = PriceActionStates.GetPrevPeaks();
          if(Close[1] < peaksState.peakCloseLowest - BreakoutMarginPoints*Point && peaksState.peakStateLowest==LOWER_LOW_PEAK)
          {
            BreakoutState = BO_TRIGGERED; // set breakout flag
            Trigger = 2; // Sell signal
            if(OnJournaling) Print("Entry Signal - SELL on breakout");
          }
      }
    }

   if(UseReversal && !lastOrderClosedByStopLoss)
   {
      if(CountPosOrders(MagicNumber,OP_BUY)>=1 && (paState.trendState == DOWN_TREND))
      {
         Trigger = 2; // Sell signal
         if(OnJournaling) Print("Exit Signal - SELL on reversal to DOWN_TREND");
      }
      else if(CountPosOrders(MagicNumber,OP_SELL)>=1 && (paState.trendState == UP_TREND))
      {
         Trigger = 1; // Buy signal
         if(OnJournaling) Print("Exit Signal - BUY on reversal to UP_TREND");
      }
   } 

   if(!lastOrderClosedByStopLoss)
   {
    if(IsBearishPinBar(1))
    {
        Trigger = 2; // Sell signal
        IsPinBar = true;
        if(OnJournaling) Print("Exit Signal - SELL on reversal to DOWN_TREND due to bearish pin bar");
    }
    else if(IsBullishPinBar(1))
    {
        Trigger = 1; // Buy signal
        IsPinBar = true;
        if(OnJournaling) Print("Exit Signal - BUY on reversal to UP_TREND due to bullish pin bar");
    }
  }

   // support resistance exit rules
   if(UseSupportResistance && !lastOrderClosedByStopLoss)
   {
      SRresult SRres = SupportResistance.CheckNearSR(Close[1], paState.trendState);
      if(CountPosOrders(MagicNumber,OP_BUY)>=1 && (SRres.status == BELOW_RESISTANCE || SRres.status == BELOW_SUPPORT))
      { 
        Trigger = 2;
        if(OnJournaling) Print("Exit Signal - SELL below support or resistance line");
      } 
      else if(CountPosOrders(MagicNumber,OP_SELL)>=1 && (SRres.status == ABOVE_RESISTANCE || SRres.status == ABOVE_SUPPORT))
      {
          Trigger = 1;
          if(OnJournaling) Print("Exit Signal - BUY above support or resistance line");
      } 
      else
      { //if there are no open position, check for entry signal
        int SRCrossTriggered = SupportResistance.CheckSRCrossed(Close[2], Close[1]); 
        if(SRCrossTriggered == 1)
        {
          // BreakoutState = BO_TRIGGERED; // set breakout flag
          Trigger = 1;
          if(OnJournaling) Print("Entry Signal - breakout,  BUY above suppot or resistance line");
        }
        else if(SRCrossTriggered == 2)
        {
          // BreakoutState = BO_TRIGGERED; // set breakout flag
          Trigger = 2;
          if(OnJournaling) Print("Entry Signal - breakout, SELL below suppot or resistance line");
        
        }
      }
   }

   double pipFiniteLine = EMPTY_VALUE;
   if(UsePipFiniteEntry && !lastOrderClosedByStopLoss)
    {
      // Get PipFinite indicator values with proper parameters
      PipFiniteUptrendSignal1 = iCustom(NULL, 0, "Market\\PipFinite Trend PRO", PipFinite_UptrendBuffer, 1); // Buffer for Uptrend, Shift 1
      PipFiniteDowntrendSignal1 = iCustom(NULL, 0, "Market\\PipFinite Trend PRO", PipFinite_DowntrendBuffer, 1); // Buffer for Downtrend, Shift 1
      
      if (PipFiniteUptrendSignal1 != EMPTY_VALUE && PipFiniteUptrendSignal1 != 0)
        pipFiniteLine = PipFiniteUptrendSignal1;
      else if (PipFiniteDowntrendSignal1 != EMPTY_VALUE  && PipFiniteDowntrendSignal1 != 0)
        pipFiniteLine = PipFiniteDowntrendSignal1;
      
      if (pipFiniteLine != EMPTY_VALUE)
      {
        if(Trigger == 0) // don't use pip finite trigger if waiting for breakout
        {
          int CrossTriggeredPF = Crossed(Close[2], Close[1], pipFiniteLine); // Check if crossed the PipFinite line
          if(CrossTriggeredPF == 1) // Buy signal after retracement
            { 
              Trigger = 1;
              if(OnJournaling) Print("Entry Signal - BUY after PipFinite crossing");
            }
          else if(CrossTriggeredPF == 2) // Sell signal after retracement
            {
              Trigger = 2;
              if(OnJournaling) Print("Entry Signal - SELL after PipFinite crossing");
            }
        }
        
      }
    }  

   double ner_hi_zone_P1 = -1;
   double ner_hi_zone_P2 = -1;
   double ner_lo_zone_P1 = -1;
   double ner_lo_zone_P2 = -1;
   int ner_hi_zone_strength = -1;
   int ner_lo_zone_strength = -1;
   int ner_price_inside_zone = -1;

   if(UseSupplyDemandATR)
    supplyDemandMarginPoints = supplyDemandMarginATR * myATR / Point; // Calculate Supply/Demand margin in points

   if((UseSupplyDemandPoints || UseSupplyDemandATR) && !lastOrderClosedByStopLoss)
   {
      ner_hi_zone_P1 = (double)iCustom(NULL, 0, "Falcon_B_Indicator\\supply_and_demand_v1.8", 4, 0); // Get Supply Zone High
      ner_hi_zone_P2 = (double)iCustom(NULL, 0, "Falcon_B_Indicator\\supply_and_demand_v1.8", 5, 0); // Get Supply Zone Low
      ner_lo_zone_P1 = (double)iCustom(NULL, 0, "Falcon_B_Indicator\\supply_and_demand_v1.8", 6, 0); // Get Demand Zone High
      ner_lo_zone_P2 = (double)iCustom(NULL, 0, "Falcon_B_Indicator\\supply_and_demand_v1.8", 7, 0); // Get Demand Zone Low
      ner_hi_zone_strength = (int)iCustom(NULL, 0, "Falcon_B_Indicator\\supply_and_demand_v1.8", 8, 0); // Get Supply Zone Strength
      ner_lo_zone_strength = (int)iCustom(NULL, 0, "Falcon_B_Indicator\\supply_and_demand_v1.8", 9, 0); // Get Demand Zone Strength
      ner_price_inside_zone = (int)iCustom(NULL, 0, "Falcon_B_Indicator\\supply_and_demand_v1.8", 10, 0); // Get Supply Zone Type

      // Print("Supply Zone High: ", ner_hi_zone_P1, " Low: ", ner_hi_zone_P2, " Strength: ", ner_hi_zone_strength, " inside zone: ", ner_price_inside_zone);
      // Print("Demand Zone High: ", ner_lo_zone_P1, " Low: ", ner_lo_zone_P2, " Strength: ", ner_lo_zone_strength, " inside zone: ", ner_price_inside_zone);

      if(CountPosOrders(MagicNumber,OP_BUY)>=1 && (Close[1] < ner_lo_zone_P2) && (Close[1] > ner_lo_zone_P2 - supplyDemandMarginPoints * Point))
      { 
        Trigger = 2;
        if(OnJournaling) Print("Exit Signal - SELL below supply and demand line");
      }
      else if(CountPosOrders(MagicNumber,OP_SELL)>=1 && (Close[1] > ner_hi_zone_P1) && (Close[1] < ner_hi_zone_P1 + supplyDemandMarginPoints * Point))
      {
          Trigger = 1;
          if(OnJournaling) Print("Exit Signal - BUY above supply and demand line");
      } 
      else 
      { //if there are no open position, check for entry signal
        PriceActionState peaksState = PriceActionStates.GetPrevPeaks();
        // Print("trend state: ", peaksState.trendState, " ,peaksState.peakState1: ", peaksState.peakState1, " ,peaksState.peakClose1: ", peaksState.peakClose1);
        // Print("Close[1]: ", Close[1], " ,hi P1 + margin: ", ner_hi_zone_P1 + BreakoutMarginPoints*Point, " ,hi P2 + margin: ", ner_hi_zone_P2 + BreakoutMarginPoints*Point);
        // Print("Close[1]: ", Close[1], " ,lo P1 - margin: ", ner_lo_zone_P1 - BreakoutMarginPoints*Point, " ,lo P2 - margin: ", ner_lo_zone_P2 - BreakoutMarginPoints*Point);

        if(UseMeanReversalATR)
          MeanReversalDistancePoints = MeanReversalATRMultiplier * myATR / Point;

        if(peaksState.trendState == UP_TREND || peaksState.trendState == DOWN_TREND_RETRACEMENT)
        {
          if((Close[1] > prev_ner_hi_zone_P1 + BreakoutMarginPoints*Point) && (peaksState.peakClose1 < prev_ner_hi_zone_P1))
          {
            BreakoutState = BO_TRIGGERED; // set breakout flag
            Trigger = 1;
            if(OnJournaling) Print("Entry Signal - breakout,  BUY above supply line");
          }
          else if((UseMeanReversalATR || UseMeanReversalPoints) && 
                  (prev_ner_hi_zone_P2 - prev_ner_lo_zone_P1 > MeanReversalLoHiDistance*myATR) &&
                  (Close[1] < prev_ner_lo_zone_P1 + MeanReversalDistancePoints*Point || Close[2] < prev_ner_lo_zone_P1 + MeanReversalDistancePoints*Point)) // Check for mean reversal condition
          {
            IsMeanReversal = true; // Set flag for mean reversal condition
            if(OnJournaling) Print("Mean Reversal Condition - BUY above supply line");
            Trigger = 1; // Set trigger for mean reversal
          }
        }
        else if (peaksState.trendState == DOWN_TREND  || peaksState.trendState == UP_TREND_RETRACEMENT)
        {
          if ((Close[1] < prev_ner_lo_zone_P2 - BreakoutMarginPoints*Point) && (peaksState.peakClose1 > prev_ner_lo_zone_P2))
          {
            BreakoutState = BO_TRIGGERED; // set breakout flag
            Trigger = 2;
            if(OnJournaling) Print("Entry Signal - breakout, SELL below demand line");
          } 
          else if((UseMeanReversalATR || UseMeanReversalPoints) && 
                  (prev_ner_hi_zone_P2 - prev_ner_lo_zone_P1 > MeanReversalLoHiDistance*myATR) &&
                  (Close[1] > prev_ner_hi_zone_P2 - MeanReversalDistancePoints*Point || Close[2] > prev_ner_hi_zone_P2 - MeanReversalDistancePoints*Point)) // Check for mean reversal condition
          {
            IsMeanReversal = true; // Set flag for mean reversal condition
            if(OnJournaling) Print("Mean Reversal Condition - SELL below demand line");
            Trigger = 2; // Set trigger for mean reversal
          }
        }
      }

      prev_ner_hi_zone_P1 = ner_hi_zone_P1;
      prev_ner_hi_zone_P2 = ner_hi_zone_P2;
      prev_ner_lo_zone_P1 = ner_lo_zone_P1;
      prev_ner_lo_zone_P2 = ner_lo_zone_P2;
   }

//----------Stop loss and Take Profit calculation for new trades -----------

    Stop = CalculateStopLoss();
    Take = CalculateTakeProfit();

//----------Exit Rules (All Opened Positions)-----------
   // TDL 2: Setting up Exit rules. Modify the ExitSignal() function to suit your needs.

   if(CountPosOrders(MagicNumber,OP_BUY)>=1 && ExitSignal(Trigger)==2 && IsPinBar)
     { // Close Long Positions
      CloseOrderPosition(OP_BUY, OnJournaling, MagicNumber, Slippage, PipFactor, RetryInterval); 
      IsAfterExit = true; // Set flag to indicate exit
     }
   if(CountPosOrders(MagicNumber,OP_SELL)>=1 && ExitSignal(Trigger)==1 && IsPinBar)
     { // Close Short Positions
      CloseOrderPosition(OP_SELL, OnJournaling, MagicNumber, Slippage, PipFactor, RetryInterval);
      IsAfterExit = true; // Set flag to indicate exit
     }

//----------Entry Rules (Market and Pending) -----------
   if(Trigger>0)
   {  
    if(IsLossLimitBreached(IsLossLimitActivated,LossLimitPercent,OnJournaling,EntrySignal(Trigger), MagicNumber) == True) 
    {
        if(OnJournaling) Print("Loss limit breached, no new trades will be opened until reset.");
        return (0);
    }

    if(IsWinLimitBreached(IsWinLimitActivated,WinLimitPercent,OnJournaling,EntrySignal(Trigger), MagicNumber)==True) 
    {
        if(OnJournaling) Print("Win limit breached, no new trades will be opened until reset.");
        return (0);
    }

    if(IsVolLimitBreached(IsVolLimitActivated,VolatilityMultiplier,ATRTimeframe,ATRPeriod)==True)
    {
        if(OnJournaling) Print("Volatility limit breached, no new trades will be opened until reset.");
        return (0); // Exit if volatility limit is breached
    }

    if(IsMaxPositionsReached(MaxPositionsAllowed,MagicNumber,OnJournaling)==True)
    {
        return (0);
    }

    if(UseSupplyDemandPoints || UseSupplyDemandATR)
    {
        // if(OnJournaling) Print("Checking breakout conditions, Trigger: ", Trigger, ", prev_ner_hi_zone_P1: ", prev_ner_hi_zone_P1, ", prev_ner_hi_zone_P2: ", prev_ner_hi_zone_P2, ", prev_ner_lo_zone_P1: ", prev_ner_lo_zone_P1, ", prev_ner_lo_zone_P2: ", prev_ner_lo_zone_P2);
        if(Trigger == 1 && prev_ner_hi_zone_P1 == 999999 && prev_ner_hi_zone_P2 == 999999)
          BreakoutState = BO_TRIGGERED;
        if(Trigger == 2 && prev_ner_lo_zone_P1 == 0 && prev_ner_lo_zone_P2 == 0)
          BreakoutState = BO_TRIGGERED;
    }

    if(!IsMeanReversal && BreakoutState!=BO_TRIGGERED && GetConsecutiveFailureCount(MagicNumber)>=MaxConsecutiveFailures) // && Trigger==0 && !IsAfterExit
      {
          BreakoutState = BO_WAITING;
          if(OnJournaling) Print("Max consecutive failures reached, no new trades will be opened until breakout.");
          return (0); // Exit without opening new trades
        }

      if(!lastOrderClosedByStopLoss && UsePipFiniteEntry && !IsAfterExit && !IsMeanReversal) // pip finite rules apply only for new trades
      {
        if(Close[1] > pipFiniteLine && Trigger == 2) // ignore sell signals above the PipFinite line
        {
          Trigger = 0; // Reset to no signal
          if(OnJournaling) Print("SELL signal canceled - only buy allowed above pipFinite line");
          return (0); // Exit if no valid signal
        }
        else if(Close[1] < pipFiniteLine && Trigger == 1) // ignore buy signals below the PipFinite line
        {
          Trigger = 0; // Reset to no signal
          if(OnJournaling) Print("BUY signal canceled - only sell allowed below pipFinite line");
          return (0); // Exit if no valid signal
        }
      }
    }

// ---------- positions processing ----------
  // TODO: if IsPinBar then open limit order above / below pinbar high / low

   if(TradeAllowed && EntrySignal(Trigger)==1)
    { // Open Long Positions
      double lotSize = GetLot(IsSizingOn,Lots,UpdatedRisk,Stop, PipFactor,LotAdjustFactor);
      // if(lotSize == 0)
      // {
      //   Print("Requested Position: ", lotSize, " lots, " , MarketInfo(Symbol(), MODE_MINLOT), " min lot,  canceling signal");
      //   return(0);
      // }
      OrderNumber=OpenPositionMarket(OP_BUY,lotSize,Stop,Take,MagicNumber,Slippage,OnJournaling,PipFactor,IsECNbroker,MaxRetriesPerTick,RetryInterval);

      // Display lot size on chart if order was successful
      if(OrderNumber > 0 && OrderSelect(OrderNumber, SELECT_BY_TICKET) && ShowLotSizeOnChart)
      {
         DisplayRiskSizeOnChart(OrderOpenTime(), OrderOpenPrice(), UpdatedRisk, lotSize, OP_BUY);
      }

      // Set Stop Loss value for Hidden SL
      if(UseHiddenStopLoss) SetStopLossHidden(OnJournaling,IsVolatilityStopLossOn_Hidden,FixedStopLoss_Hidden,myATR,VolBasedSLMultiplier_Hidden,PipFactor,OrderNumber);

      // Set Take Profit value for Hidden TP
      if(UseHiddenTakeProfit) SetTakeProfitHidden(OnJournaling,IsVolatilityTakeProfitOn_Hidden,FixedTakeProfit_Hidden,myATR,VolBasedTPMultiplier_Hidden,PipFactor,OrderNumber);
      
      // Set Volatility Trailing Stop Level           
      if(UseVolTrailingStops) SetVolTrailingStop(OnJournaling,RetryInterval,myATR,VolTrailingDistMultiplier,MagicNumber,PipFactor,OrderNumber);
      
      // Set Hidden Volatility Trailing Stop Level 
      if(UseHiddenVolTrailing) SetHiddenVolTrailing(OnJournaling,myATR,VolTrailingDistMultiplier_Hidden,MagicNumber,PipFactor,OrderNumber);
    
      BreakoutState = BO_NORMAL; // Reset breakout flag
      IsMeanReversal = false; // Reset mean reversal flag
      if(lastOrderClosedByStopLoss)
        VisualizeSignalOverlay(0, Trigger);
      else
      {
        VisualizeSignalOverlay(1, Trigger);
      }
    }

   if(TradeAllowed && EntrySignal(Trigger)==2)
    { // Open Short Positions
      double lotSize = GetLot(IsSizingOn,Lots,UpdatedRisk,Stop,PipFactor,LotAdjustFactor);
      // if(lotSize == 0)
      // {
      //   Print("Requested Short Position: ", lotSize, " lots, " ,MarketInfo(Symbol(), MODE_MINLOT), " min lot,  canceling signal");
      //   return(0);
      // }
      OrderNumber=OpenPositionMarket(OP_SELL,lotSize,Stop,Take,MagicNumber,Slippage,OnJournaling,PipFactor,IsECNbroker,MaxRetriesPerTick,RetryInterval);

      // Display lot size on chart if order was successful
      if(OrderNumber > 0 && OrderSelect(OrderNumber, SELECT_BY_TICKET) && ShowLotSizeOnChart)
      {
         DisplayRiskSizeOnChart(OrderOpenTime(), OrderOpenPrice(), UpdatedRisk, lotSize, OP_SELL);
      }

      // Set Stop Loss value for Hidden SL
      if(UseHiddenStopLoss) SetStopLossHidden(OnJournaling,IsVolatilityStopLossOn_Hidden,FixedStopLoss_Hidden,myATR,VolBasedSLMultiplier_Hidden,PipFactor,OrderNumber);

      // Set Take Profit value for Hidden TP
      if(UseHiddenTakeProfit) SetTakeProfitHidden(OnJournaling,IsVolatilityTakeProfitOn_Hidden,FixedTakeProfit_Hidden,myATR,VolBasedTPMultiplier_Hidden,PipFactor,OrderNumber);
      
      // Set Volatility Trailing Stop Level 
      if(UseVolTrailingStops) SetVolTrailingStop(OnJournaling,RetryInterval,myATR,VolTrailingDistMultiplier,MagicNumber,PipFactor,OrderNumber);
      
      // Set Hidden Volatility Trailing Stop Level  
      if(UseHiddenVolTrailing) SetHiddenVolTrailing(OnJournaling,myATR,VolTrailingDistMultiplier_Hidden,MagicNumber,PipFactor,OrderNumber);
      
      BreakoutState = BO_NORMAL; // Reset breakout flag
      IsMeanReversal = false; // Reset mean reversal flag
      if(lastOrderClosedByStopLoss)
        VisualizeSignalOverlay(0, Trigger);
      else
      {
        VisualizeSignalOverlay(1, Trigger);
      }
    }

    lastOrderClosedByStopLoss = false; 

//----------Pending Order Management-----------
/*
        Not Applicable (See Desiree for example of pending order rules).
   */

//----

   return(0);
  }
//+------------------------------------------------------------------+
//| End of expert start function                                     |
//+------------------------------------------------------------------+

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//|                     FUNCTIONS LIBRARY                                   
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/*

Content:
1) EntrySignal
2) ExitSignal
3) GetLot
4) CheckLot
5) CountPosOrders
6) IsMaxPositionsReached
7) OpenPositionMarket
8) OpenPositionPending
9) CloseOrderPosition
10) GetPipFactor
11) GetYenAdjustFactor
12) VolBasedStopLoss
13) VolBasedTakeProfit
14) Crossed1 / Crossed2
15) IsLossLimitBreached
16) IsVolLimitBreached
17) SetStopLossHidden
18) TriggerStopLossHidden
19) SetTakeProfitHidden
20) TriggerTakeProfitHidden
21) BreakevenStopAll
22) UpdateHiddenBEList
23) SetAndTriggerBEHidden
24) TrailingStopAll
25) UpdateHiddenTrailingList
26) SetAndTriggerHiddenTrailing
27) UpdateVolTrailingList
28) SetVolTrailingStop
29) ReviewVolTrailingStop
30) UpdateHiddenVolTrailingList
31) SetHiddenVolTrailing
32) TriggerAndReviewHiddenVolTrailing
33) HandleTradingEnvironment
34) GetErrorDescription

*/


//+------------------------------------------------------------------+
//| ENTRY SIGNAL                                                     |
//+------------------------------------------------------------------+
int EntrySignal(int CrossOccurred)
  {
// Type: Customisable 
// Modify this function to suit your trading robot

// This function checks for entry signals

   int   entryOutput=0;

   if(CrossOccurred==1)
     {
      entryOutput=1; 
     }

   if(CrossOccurred==2)
     {
      entryOutput=2;
     }

   return(entryOutput);
  }
//+------------------------------------------------------------------+
//| End of ENTRY SIGNAL                                              |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Exit SIGNAL                                                      |
//+------------------------------------------------------------------+
int ExitSignal(int CrossOccurred)
  {
// Type: Customisable 
// Modify this function to suit your trading robot

// This function checks for exit signals

   int   ExitOutput=0;

   if(CrossOccurred==1)
     {
      ExitOutput=1;
     }

   if(CrossOccurred==2)
     {
      ExitOutput=2;
     }

   return(ExitOutput);
  }
//+------------------------------------------------------------------+
//| End of Exit SIGNAL                                               
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Position Sizing Algo               
//+------------------------------------------------------------------+
// Type: Customisable 
// Modify this function to suit your trading robot

// This is our sizing algorithm

double GetLot(bool IsSizingOnTrigger ,double FixedLots ,double riskPercent ,double stopLossPips,int K, int AdjustmentFactor = 1) 
  {

   double output;

   if(IsSizingOnTrigger==true) 
     {
      double accountBalance = AccountBalance(); // Your total account balance
      double riskAmount = accountBalance * riskPercent / 100.0; // The maximum money to risk on this trade
      
      // Calculate pip value for 1 lot
      double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
      double pipValue = tickValue * K; // Value of 1 pip for 1 lot (adjusted for broker digits)
      
      // Calculate lot size: Risk Amount = Volume × Stop Loss × Pip Value
      // Therefore: Volume = Risk Amount / (Stop Loss × Pip Value)
      output = riskAmount / (stopLossPips * pipValue);
      
      // Apply adjustment factor (for Yen pairs) before normalizing
      output = output * AdjustmentFactor;
      
      // Normalize lot to nearest allowed step
      double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
      double minLot = MarketInfo(Symbol(), MODE_MINLOT);
      double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
      
      // Adjust lot size within broker limits
      output = MathFloor(output / lotStep) * lotStep;

      if (output < minLot) output = minLot; // Use minimum lot if calculated is too small
      if (output > maxLot) output = maxLot; // Cap at maximum lot
      
      // Verify that max loss doesn't exceed risk amount
      double calculatedMaxLoss = output * stopLossPips * pipValue;
      if (calculatedMaxLoss > riskAmount)
      {
        // Recalculate to ensure we don't exceed risk
        output = riskAmount / (stopLossPips * pipValue);
        output = output * AdjustmentFactor;
        output = MathFloor(output / lotStep) * lotStep;
        if (output < minLot) output = 0; // Can't trade if risk is too small for minimum lot
      }
    } 
    else {
      output=FixedLots;
     }

   output=NormalizeDouble(output,2); // Round to 2 decimal place

   return(output);
  }

  // double GetLot(bool IsSizingOnTrigger,double FixedLots,double RiskPerTrade, double STOP,int K, int AdjustmentFactor = 1) 
  // {

  //  double output;

  //  if(IsSizingOnTrigger==true) 
  //    {
  //     output=RiskPerTrade*0.01*AccountBalance()/(MarketInfo(Symbol(),MODE_LOTSIZE)*MarketInfo(Symbol(),MODE_TICKVALUE)*STOP*K*Point); // Sizing Algo based on account size
  //     output=output*AdjustmentFactor; // Adjust for Yen Pairs
  //       } else {
  //     output=FixedLots;
  //    }
  //  output=NormalizeDouble(output,2); // Round to 2 decimal place
  //  return(output);
  // }
//+------------------------------------------------------------------+
//| End of Position Sizing Algo               
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| CHECK LOT
//+------------------------------------------------------------------+
double CheckLot(double Lot,bool Journaling)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function checks if our Lots to be trade satisfies any broker limitations

   double LotToOpen=0;
   LotToOpen=NormalizeDouble(Lot,2);
   LotToOpen=MathFloor(LotToOpen/MarketInfo(Symbol(),MODE_LOTSTEP))*MarketInfo(Symbol(),MODE_LOTSTEP);

   if(LotToOpen<MarketInfo(Symbol(),MODE_MINLOT))LotToOpen=MarketInfo(Symbol(),MODE_MINLOT);
   if(LotToOpen>MarketInfo(Symbol(),MODE_MAXLOT))LotToOpen=MarketInfo(Symbol(),MODE_MAXLOT);
   LotToOpen=NormalizeDouble(LotToOpen,2);

   if(Journaling && LotToOpen!=Lot)
    if(OnJournaling) Print("Trading Lot has been changed by CheckLot function. Requested lot: "+(string)Lot+". Lot to open: "+(string)LotToOpen);

   return(LotToOpen);
  }
//+------------------------------------------------------------------+
//| End of CHECK LOT
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| COUNT POSITIONS 
//+------------------------------------------------------------------+
int CountPosOrders(int Magic,int TYPE)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function counts number of positions/orders of OrderType TYPE

   int Orders=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==TYPE)
         Orders++;
     }
   return(Orders);

  }
//+------------------------------------------------------------------+
//| End of COUNT POSITIONS
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| MAX ORDERS                                              
//+------------------------------------------------------------------+
bool IsMaxPositionsReached(int MaxPositions,int Magic,bool Journaling)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function checks the number of positions we are holding against the maximum allowed 

   bool result=False;
   if(CountPosOrders(Magic,OP_BUY)+CountPosOrders(Magic,OP_SELL)>MaxPositions) 
     {
      result=True;
      if(Journaling)Print("Max Orders Exceeded");
        } else if(CountPosOrders(Magic,OP_BUY)+CountPosOrders(Magic,OP_SELL)==MaxPositions) {
      result=True;
     }

   return(result);

/* Definitions: Position vs Orders
   
   Position describes an opened trade
   Order is a pending trade
   
   How to use in a sentence: Jim has 5 buy limit orders pending 10 minutes ago. The market just crashed. The orders were executed and he has 5 losing positions now lol.

*/
  }
//+------------------------------------------------------------------+
//| End of MAX ORDERS                                                
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| OPEN FROM MARKET
//+------------------------------------------------------------------+
int OpenPositionMarket(int TYPE,double LOT,double SL,double TP,int Magic,int Slip,bool Journaling,int K,bool ECN,int Max_Retries_Per_Tick,int Retry_Interval)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function submits new orders

   int tries=0;
   string symbol=Symbol();
   int cmd=TYPE;
   double volume=LOT; //CheckLot(LOT,Journaling);
  if(MarketInfo(symbol,MODE_MARGINREQUIRED)*volume > AccountFreeMargin())
  {
    // Calculate maximum possible volume based on available margin
    double maxVolume = AccountFreeMargin() / MarketInfo(symbol,MODE_MARGINREQUIRED);
    
    // Apply safety margin (use 90% of available margin)
    maxVolume = maxVolume * 0.9;
    
   // Normalize to broker's lot step
   double lotStep = MarketInfo(symbol, MODE_LOTSTEP);
   double minLot = MarketInfo(symbol, MODE_MINLOT);
   
   volume = MathFloor(maxVolume / lotStep) * lotStep;
   
   if(volume < minLot)
   {
      Print("Insufficient margin even for minimum lot size. Required: ", MarketInfo(symbol,MODE_MARGINREQUIRED), 
            " Available: ", AccountFreeMargin());
      return(-1);
   }
   
   if(Journaling) Print("Volume adjusted due to insufficient margin. Original: ", LOT, 
                       " Adjusted: ", volume, " Free margin: ", AccountFreeMargin());
  }
   int slippage=Slip*K; // Slippage is in points. 1 point = 0.0001 on 4 digit broker and 0.00001 on a 5 digit broker
   string comment=" "+(string)TYPE+"(#"+(string)Magic+")";
   int magic=Magic;
   datetime expiration=0;
   color arrow_color=0;if(TYPE==OP_BUY)arrow_color=Blue;if(TYPE==OP_SELL)arrow_color=Red;
   double stoploss=0;
   double takeprofit=0;
   double initTP = TP;
   double initSL = SL;
   int Ticket=-1;
   double price=0;
   if(!ECN)
     {
      while(tries<Max_Retries_Per_Tick) // Edits stops and take profits before the market order is placed
        {
         RefreshRates();
         if(TYPE==OP_BUY)price=Ask;if(TYPE==OP_SELL)price=Bid;

         // Sets Take Profits and Stop Loss. Check against Stop Level Limitations.
         if(TYPE==OP_BUY && SL!=0)
           {
            stoploss=NormalizeDouble(Ask-SL*K*Point,Digits);
            if(Bid-stoploss<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
              {
               stoploss=NormalizeDouble(Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
               if(Journaling)Print("Stop Loss changed from "+(string)initSL+" to "+string(MarketInfo(Symbol(),MODE_STOPLEVEL)/K)+" pips");
              }
           }
         if(TYPE==OP_SELL && SL!=0)
           {
            stoploss=NormalizeDouble(Bid+SL*K*Point,Digits);
            if(stoploss-Ask<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
              {
               stoploss=NormalizeDouble(Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
               if(Journaling)Print("Stop Loss changed from "+(string)initSL+" to "+string(MarketInfo(Symbol(),MODE_STOPLEVEL)/K)+" pips");
              }
           }
         if(TYPE==OP_BUY && TP!=0)
           {
            takeprofit=NormalizeDouble(Ask+TP*K*Point,Digits);
            if(takeprofit-Bid<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
              {
               takeprofit=NormalizeDouble(Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
               if(Journaling)Print("Take Profit changed from "+(string)initTP+" to "+string(MarketInfo(Symbol(),MODE_STOPLEVEL)/K)+" pips");
              }
           }
         if(TYPE==OP_SELL && TP!=0)
           {
            takeprofit=NormalizeDouble(Bid-TP*K*Point,Digits);
            if(Ask-takeprofit<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
              {
               takeprofit=NormalizeDouble(Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
               if(Journaling)Print("Take Profit changed from "+(string)initTP+" to "+string(MarketInfo(Symbol(),MODE_STOPLEVEL)/K)+" pips");
              }
           }
         if(Journaling)Print("Trying to place a market order...");
         HandleTradingEnvironment(Journaling,Retry_Interval);
         Ticket=OrderSend(symbol,cmd,volume,price,slippage,stoploss,takeprofit,comment,magic,expiration,arrow_color);
         if(Ticket>0)break;
         tries++;
        }
     }
   if(ECN) // Edits stops and take profits after the market order is placed
     {
      HandleTradingEnvironment(Journaling,Retry_Interval);
      if(TYPE==OP_BUY)price=Ask;if(TYPE==OP_SELL)price=Bid;
      if(Journaling)Print("Trying to place a market order...");
      Ticket=OrderSend(symbol,cmd,volume,price,slippage,0,0,comment,magic,expiration,arrow_color);
      if(Ticket>0)
         if(Ticket>0 && OrderSelect(Ticket,SELECT_BY_TICKET)==true && (SL!=0 || TP!=0))
           {
            // Sets Take Profits and Stop Loss. Check against Stop Level Limitations.
            if(TYPE==OP_BUY && SL!=0)
              {
               stoploss=NormalizeDouble(OrderOpenPrice()-SL*K*Point,Digits);
               if(Bid-stoploss<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
                 {
                  stoploss=NormalizeDouble(Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
                  if(Journaling)Print("Stop Loss changed from "+(string)initSL+" to "+string((OrderOpenPrice()-stoploss)/(K*Point))+" pips");
                 }
              }
            if(TYPE==OP_SELL && SL!=0)
              {
               stoploss=NormalizeDouble(OrderOpenPrice()+SL*K*Point,Digits);
               if(stoploss-Ask<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
                 {
                  stoploss=NormalizeDouble(Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
                  if(Journaling)Print("Stop Loss changed from "+(string)initSL+" to "+string((stoploss-OrderOpenPrice())/(K*Point))+" pips");
                 }
              }
            if(TYPE==OP_BUY && TP!=0)
              {
               takeprofit=NormalizeDouble(OrderOpenPrice()+TP*K*Point,Digits);
               if(takeprofit-Bid<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
                 {
                  takeprofit=NormalizeDouble(Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
                  if(Journaling)Print("Take Profit changed from "+(string)initTP+" to "+string((takeprofit-OrderOpenPrice())/(K*Point))+" pips");
                 }
              }
            if(TYPE==OP_SELL && TP!=0)
              {
               takeprofit=NormalizeDouble(OrderOpenPrice()-TP*K*Point,Digits);
               if(Ask-takeprofit<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
                 {
                  takeprofit=NormalizeDouble(Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
                  if(Journaling)Print("Take Profit changed from "+(string)initTP+" to "+string((OrderOpenPrice()-takeprofit)/(K*Point))+" pips");
                 }
              }
            bool ModifyOpen=false;
            while(!ModifyOpen)
              {
               HandleTradingEnvironment(Journaling,Retry_Interval);
               ModifyOpen=OrderModify(Ticket,OrderOpenPrice(),stoploss,takeprofit,expiration,arrow_color);
               if(Journaling && !ModifyOpen)Print("Take Profit and Stop Loss not set. Error Description: "+GetErrorDescription(GetLastError()));
              }
           }
     }
   if(Journaling && Ticket<0)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
   if(Journaling && Ticket>0)
     {
      Print("Order successfully placed. Ticket: "+(string)Ticket);
     }
   return(Ticket);
  }
//+------------------------------------------------------------------+
//| End of OPEN FROM MARKET   
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| OPEN PENDING ORDERS
//+------------------------------------------------------------------+
int OpenPositionPending(int TYPE,double OpenPrice,datetime expiration,double LOT,double SL,double TP,int Magic,int Slip,bool Journaling,int K,bool ECN,int Max_Retries_Per_Tick,int Retry_Interval)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function submits new pending orders
   OpenPrice= NormalizeDouble(OpenPrice,Digits);
   int tries=0;
   string symbol=Symbol();
   int cmd=TYPE;
   double volume=LOT; //CheckLot(LOT,Journaling);
  if(MarketInfo(symbol,MODE_MARGINREQUIRED)*volume > AccountFreeMargin())
  {
    // Calculate maximum possible volume based on available margin
    double maxVolume = AccountFreeMargin() / MarketInfo(symbol,MODE_MARGINREQUIRED);
    
    // Apply safety margin (use 90% of available margin)
    maxVolume = maxVolume * 0.9;
    
   // Normalize to broker's lot step
   double lotStep = MarketInfo(symbol, MODE_LOTSTEP);
   double minLot = MarketInfo(symbol, MODE_MINLOT);
   
   volume = MathFloor(maxVolume / lotStep) * lotStep;
   
   if(volume < minLot)
   {
      Print("Insufficient margin even for minimum lot size. Required: ", MarketInfo(symbol,MODE_MARGINREQUIRED), 
            " Available: ", AccountFreeMargin());
      return(-1);
   }
   
   if(Journaling) Print("Volume adjusted due to insufficient margin. Original: ", LOT, 
                       " Adjusted: ", volume, " Free margin: ", AccountFreeMargin());
  }
   int slippage=Slip*K; // Slippage is in points. 1 point = 0.0001 on 4 digit broker and 0.00001 on a 5 digit broker
   string comment=" "+(string)TYPE+"(#"+(string)Magic+")";
   int magic=Magic;
   color arrow_color=0;if(TYPE==OP_BUYLIMIT || TYPE==OP_BUYSTOP)arrow_color=Blue;if(TYPE==OP_SELLLIMIT || TYPE==OP_SELLSTOP)arrow_color=Green;
   double stoploss=0;
   double takeprofit=0;
   double initTP = TP;
   double initSL = SL;
   int Ticket=-1;
   double price=0;

   while(tries<Max_Retries_Per_Tick) // Edits stops and take profits before the market order is placed
     {
      RefreshRates();

      // We are able to send in TP and SL when we open our orders even if we are using ECN brokers

      // Sets Take Profits and Stop Loss. Check against Stop Level Limitations.
      if((TYPE==OP_BUYLIMIT || TYPE==OP_BUYSTOP) && SL!=0)
        {
         stoploss=NormalizeDouble(OpenPrice-SL*K*Point,Digits);
         if(OpenPrice-stoploss<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
           {
            stoploss=NormalizeDouble(OpenPrice-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
            if(Journaling)Print("Stop Loss changed from "+(string)initSL+" to "+string((OpenPrice-stoploss)/(K*Point))+" pips");
           }
        }
      if((TYPE==OP_BUYLIMIT || TYPE==OP_BUYSTOP) && TP!=0)
        {
         takeprofit=NormalizeDouble(OpenPrice+TP*K*Point,Digits);
         if(takeprofit-OpenPrice<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
           {
            takeprofit=NormalizeDouble(OpenPrice+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
            if(Journaling)Print("Take Profit changed from "+(string)initTP+" to "+string((takeprofit-OpenPrice)/(K*Point))+" pips");
           }
        }
      if((TYPE==OP_SELLLIMIT || TYPE==OP_SELLSTOP) && SL!=0)
        {
         stoploss=NormalizeDouble(OpenPrice+SL*K*Point,Digits);
         if(stoploss-OpenPrice<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
           {
            stoploss=NormalizeDouble(OpenPrice+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
            if(Journaling)Print("Stop Loss changed from " + (string)initSL + " to " + string((stoploss-OpenPrice)/(K*Point)) + " pips");
           }
        }
      if((TYPE==OP_SELLLIMIT || TYPE==OP_SELLSTOP) && TP!=0)
        {
         takeprofit=NormalizeDouble(OpenPrice-TP*K*Point,Digits);
         if(OpenPrice-takeprofit<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) 
           {
            takeprofit=NormalizeDouble(OpenPrice-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point,Digits);
            if(Journaling)Print("Take Profit changed from " + (string)initTP + " to " + string((OpenPrice-takeprofit)/(K*Point)) + " pips");
           }
        }
      if(Journaling)Print("Trying to place a pending order...");
      HandleTradingEnvironment(Journaling,Retry_Interval);

      //Note: We did not modify Open Price if it breaches the Stop Level Limitations as Open Prices are sensitive and important. It is unsafe to change it automatically.
      Ticket=OrderSend(symbol,cmd,volume,OpenPrice,slippage,stoploss,takeprofit,comment,magic,expiration,arrow_color);
      if(Ticket>0)break;
      tries++;
     }

   if(Journaling && Ticket<0)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
   if(Journaling && Ticket>0)
     {
      Print("Order successfully placed. Ticket: "+(string)Ticket);
     }
   return(Ticket);
  }
//+------------------------------------------------------------------+
//| End of OPEN PENDING ORDERS 
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| CLOSE/DELETE ORDERS AND POSITIONS
//+------------------------------------------------------------------+
bool CloseOrderPosition(int TYPE,bool Journaling,int Magic,int Slip,int K,int Retry_Interval)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function closes all positions of type TYPE or Deletes pending orders of type TYPE
   int ordersPos=OrdersTotal();

   for(int i=ordersPos-1; i>=0; i--)
     {
      // Note: Once pending orders become positions, OP_BUYLIMIT AND OP_BUYSTOP becomes OP_BUY, OP_SELLLIMIT and OP_SELLSTOP becomes OP_SELL
      if(TYPE==OP_BUY || TYPE==OP_SELL)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==TYPE)
           {
            bool Closing=false;
            double Price=0;
            color arrow_color=0;if(TYPE==OP_BUY)arrow_color=Blue;if(TYPE==OP_SELL)arrow_color=Green;
            if(Journaling)Print("Trying to close position "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,RetryInterval);
            if(TYPE==OP_BUY)Price=Bid; if(TYPE==OP_SELL)Price=Ask;
            Closing=OrderClose(OrderTicket(),OrderLots(),Price,Slip*K,arrow_color);
            if(Journaling && !Closing)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Closing)Print("Position successfully closed.");
           }
        }
      else
        {
         bool Delete=false;
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderType()==TYPE)
           {
            if(Journaling)Print("Trying to delete order "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,RetryInterval);
            Delete=OrderDelete(OrderTicket(),CLR_NONE);
            if(Journaling && !Delete)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Delete)Print("Order successfully deleted.");
           }
        }
     }
   if(CountPosOrders(Magic, TYPE)==0)return(true); else return(false);
  }
//+------------------------------------------------------------------+
//| End of CLOSE/DELETE ORDERS AND POSITIONS 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Check for 4/5 Digits Broker              
//+------------------------------------------------------------------+ 
int GetPipFactor() 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function returns PipFactor, which is used for converting pips to decimals/points

   int output;
   if(Digits==5 || Digits==3) 
      output=10;
   else if(Digits==4 || Digits==2)
      output=1;
   else
      output=1;

   

   Print("GetPipFactor: ", output);

   return(output);

/* Some definitions: Pips vs Point

1 pip = 0.0001 on a 4 digit broker and 0.00010 on a 5 digit broker
1 point = 0.0001 on 4 digit broker and 0.00001 on a 5 digit broker
  
*/

  }
//+------------------------------------------------------------------+
//| End of Check for 4/5 Digits Broker               
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Yen Adjustment Factor             
//+------------------------------------------------------------------+ 
int GetYenAdjustFactor() 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function returns a constant factor, which is used for position sizing for Yen pairs

   int output= 1;
   if(Digits == 3|| Digits == 2) output = 100;
   return(output);
  }
//+------------------------------------------------------------------+
//| End of Yen Adjustment Factor             
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Volatility-Based Stop Loss                                             
//+------------------------------------------------------------------+
double VolBasedStopLoss(bool isVolatilitySwitchOn,double fixedStop,double VolATR,double volMultiplier,int K)
  { // K represents our PipFactor multiplier to adjust for broker digits
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function calculates stop loss amount based on volatility

   double StopL;
   if(!isVolatilitySwitchOn)
     {
      StopL=fixedStop; // If Volatility Stop Loss not activated. Stop Loss = Fixed Pips Stop Loss
        } else {
      StopL=volMultiplier*VolATR/(K*Point); // Stop Loss in Pips
     }
   return(StopL);
  }
//+------------------------------------------------------------------+
//| End of Volatility-Based Stop Loss                  
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Volatility-Based Take Profit                                     
//+------------------------------------------------------------------+

double VolBasedTakeProfit(bool isVolatilitySwitchOn,double fixedTP,double VolATR,double volMultiplier,int K)
  { // K represents our PipFactor multiplier to adjust for broker digits
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function calculates take profit amount based on volatility

   double TakeP;
   if(!isVolatilitySwitchOn)
     {
      TakeP=fixedTP; // If Volatility Take Profit not activated. Take Profit = Fixed Pips Take Profit
        } else {
      TakeP=volMultiplier*VolATR/(K*Point); // Take Profit in Pips
     }
   return(TakeP);
  }
//+------------------------------------------------------------------+
//| End of Volatility-Based Take Profit                 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Is Loss Limit Breached                                       
//+------------------------------------------------------------------+
bool IsLossLimitBreached(bool LossLimitActivated,double LossLimitPercentage,bool Journaling,int EntrySignalTrigger, int Magic)
  {

// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function determines if our maximum loss threshold is breached

   static bool firstTick=False;
   static double initialCapital=0;
   double profitAndLoss=0;
   double profitAndLossPrint=0;
   bool output=False;

   if(LossLimitActivated==False) return(output);

   if(firstTick==False)
     {
      initialCapital=AccountEquity();
      firstTick=True;
     }

  

   profitAndLoss=(GetProfitToday(Magic, Symbol())/initialCapital);

   if(profitAndLoss<LossLimitPercentage/100)
     {
      output=True;
      profitAndLossPrint=NormalizeDouble(profitAndLoss,4)*100;
      if(Journaling)if(EntrySignalTrigger!=0) Print("Entry trade triggered but not executed. Loss threshold breached. Current Loss: "+(string)profitAndLossPrint+"%");
     }

   return(output);
  }
//+------------------------------------------------------------------+
//| End of Is Loss Limit Breached                                     
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Is Win Limit Breached                                       
//+------------------------------------------------------------------+
bool IsWinLimitBreached(bool WinLimitActivated,double WinLimitPercentage,bool Journaling,int EntrySignalTrigger,int Magic)
  {

// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function determines if our maximum loss threshold is breached

   static bool firstTick=False;
   static double initialCapital2=0;
   double profitAndLoss=0;
   double profitAndLossPrint=0;
   bool output=False;

   if(WinLimitActivated==False) return(output);

   if(firstTick==False)
     {
      initialCapital2=AccountEquity();
      firstTick=True;
     }

   profitAndLoss=(GetProfitToday(Magic, Symbol())/initialCapital2);

   if(profitAndLoss>WinLimitPercentage/100)
     {
      output=True;
      profitAndLossPrint=NormalizeDouble(profitAndLoss,4)*100;
      if(Journaling)if(EntrySignalTrigger!=0) Print("Entry trade triggered but not executed. Win threshold breached. Current Win: "+(string)profitAndLossPrint+"%");
     }

   return(output);
  }
//+------------------------------------------------------------------+
//| End of Is Loss Limit Breached                                     
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Is Volatility Limit Breached                                       
//+------------------------------------------------------------------+
bool IsVolLimitBreached(bool VolLimitActivated,double VolMulti,int ATR_Timeframe, int ATR_per)
  {

// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function determines if our maximum volatility threshold is breached

// 2 steps to this function: 
// 1) It checks the price movement between current time and the closing price of the last completed 1min bar (shift 1 of 1min timeframe).
// 2) Return True if this price movement > VolLimitMulti * VolATR

   bool output = False;
   if(VolLimitActivated==False) return(output);
   
   double priceMovement = MathAbs(Bid-iClose(NULL,PERIOD_M1,1)); // Not much difference if we use bid or ask prices here. We can also use iOpen at shift 0 here, it will be similar to using iClose at shift 1.
   double VolATR = iATR(NULL, ATR_Timeframe, ATR_per, 1);
   
   if(priceMovement > VolMulti*VolATR) output = True;

   return(output);
  }
//+------------------------------------------------------------------+
//| End of Is Volatility Limit Breached                                         
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set Hidden Stop Loss                                     
//+------------------------------------------------------------------+

void SetStopLossHidden(bool Journaling,bool isVolatilitySwitchOn,double fixedSL,double VolATR,double volMultiplier,int K,int OrderNum)
  { // K represents our PipFactor multiplier to adjust for broker digits
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function calculates hidden stop loss amount and tags it to the appropriate order using an array

   double StopL;

   if(!isVolatilitySwitchOn)
     {
      StopL=fixedSL; // If Volatility Stop Loss not activated. Stop Loss = Fixed Pips Stop Loss
        } else {
      StopL=volMultiplier*VolATR/(K*Point); // Stop Loss in Pips
     }

   for(int x=0; x<ArrayRange(HiddenSLList,0); x++) 
     { // Number of elements in column 1
      if(HiddenSLList[x,0]==0) 
        { // Checks if the element is empty
         HiddenSLList[x,0] = OrderNum;
         HiddenSLList[x,1] = StopL;
         if(Journaling)Print("Order "+(string)HiddenSLList[x,0]+" assigned with a hidden SL of "+(string)NormalizeDouble(HiddenSLList[x,1],2)+" pips.");
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Set Hidden Stop Loss                   
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Trigger Hidden Stop Loss                                      
//+------------------------------------------------------------------+
void TriggerStopLossHidden(bool Journaling,int Retry_Interval,int Magic,int Slip,int K) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

/* This function does two 2 things:
1) Clears appropriate elements of your HiddenSLList if positions has been closed
2) Closes positions based on its hidden stop loss levels
*/

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   double orderSL;
   int doesOrderExist;

// 1) Check the HiddenSLList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(HiddenSLList,0); x++) 
     { // Looping through all order number in list

      doesOrderExist=False;
      orderTicketNumber=(int)HiddenSLList[x,0];

      if(orderTicketNumber!=0) 
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--) 
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
              {
               if(orderTicketNumber==OrderTicket()) 
                 { // Checks order number in list against order number of current positions
                  doesOrderExist=True;
                  break;
                 }
              }
           }

         if(doesOrderExist==False) 
           { // Deletes elements if the order number does not match any current positions
            HiddenSLList[x, 0] = 0;
            HiddenSLList[x, 1] = 0;
           }
        }

     }

// 2) Check each position against its hidden SL and close the position if hidden SL is hit

   for(int z=0; z<ArrayRange(HiddenSLList,0); z++) 
     { // Loops through elements in the list

      orderTicketNumber=(int)HiddenSLList[z,0]; // Records order numner
      orderSL=HiddenSLList[z,1]; // Records SL

      if(OrderSelect(orderTicketNumber,SELECT_BY_TICKET)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
        {
         bool Closing=false;
         if(OrderType()==OP_BUY && OrderOpenPrice() -(orderSL*K*Point)>=Bid) 
           { // Checks SL condition for closing long orders

            if(Journaling)Print("Trying to close position "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Closing=OrderClose(OrderTicket(),OrderLots(),Bid,Slip*K,Blue);
            if(Journaling && !Closing)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Closing)Print("Position successfully closed.");

           }
         if(OrderType()==OP_SELL && OrderOpenPrice()+(orderSL*K*Point)<=Ask) 
           { // Checks SL condition for closing short orders

            if(Journaling)Print("Trying to close position "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Closing=OrderClose(OrderTicket(),OrderLots(),Ask,Slip*K,Red);
            if(Journaling && !Closing)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Closing)Print("Position successfully closed.");

           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Trigger Hidden Stop Loss                                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set Hidden Take Profit                                     
//+------------------------------------------------------------------+

void SetTakeProfitHidden(bool Journaling,bool isVolatilitySwitchOn,double fixedTP,double VolATR,double volMultiplier,int K,int OrderNum)
  { // K represents our PipFactor multiplier to adjust for broker digits
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function calculates hidden take profit amount and tags it to the appropriate order using an array

   double TakeP;

   if(!isVolatilitySwitchOn)
     {
      TakeP=fixedTP; // If Volatility Take Profit not activated. Take Profit = Fixed Pips Take Profit
        } else {
      TakeP=volMultiplier*VolATR/(K*Point); // Take Profit in Pips
     }

   for(int x=0; x<ArrayRange(HiddenTPList,0); x++) 
     { // Number of elements in column 1
      if(HiddenTPList[x,0]==0) 
        { // Checks if the element is empty
         HiddenTPList[x,0] = OrderNum;
         HiddenTPList[x,1] = TakeP;
         if(Journaling)Print("Order "+(string)HiddenTPList[x,0]+" assigned with a hidden TP of "+(string)NormalizeDouble(HiddenTPList[x,1],2)+" pips.");
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Set Hidden Take Profit                  
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Trigger Hidden Take Profit                                        
//+------------------------------------------------------------------+
void TriggerTakeProfitHidden(bool Journaling,int Retry_Interval,int Magic,int Slip,int K) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

/* This function does two 2 things:
1) Clears appropriate elements of your HiddenTPList if positions has been closed
2) Closes positions based on its hidden take profit levels
*/

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   double orderTP;
   int doesOrderExist;

// 1) Check the HiddenTPList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(HiddenTPList,0); x++) 
     { // Looping through all order number in list

      doesOrderExist=False;
      orderTicketNumber=(int)HiddenTPList[x,0];

      if(orderTicketNumber!=0) 
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--) 
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
              {
               if(orderTicketNumber==OrderTicket()) 
                 { // Checks order number in list against order number of current positions
                  doesOrderExist=True;
                  break;
                 }
              }

           }

         if(doesOrderExist==False) 
           { // Deletes elements if the order number does not match any current positions
            HiddenTPList[x, 0] = 0;
            HiddenTPList[x, 1] = 0;
           }
        }

     }

// 2) Check each position against its hidden TP and close the position if hidden TP is hit

   for(int z=0; z<ArrayRange(HiddenTPList,0); z++) 
     { // Loops through elements in the list

      orderTicketNumber=(int)HiddenTPList[z,0]; // Records order numner
      orderTP=HiddenTPList[z,1]; // Records TP

      if(OrderSelect(orderTicketNumber,SELECT_BY_TICKET)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
        {
         bool Closing=false;
         if(OrderType()==OP_BUY && OrderOpenPrice()+(orderTP*K*Point)<=Bid) 
           { // Checks TP condition for closing long orders

            if(Journaling)Print("Trying to close position "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Closing=OrderClose(OrderTicket(),OrderLots(),Bid,Slip*K,Blue);
            if(Journaling && !Closing)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Closing)Print("Position successfully closed.");

           }
         if(OrderType()==OP_SELL && OrderOpenPrice() -(orderTP*K*Point)>=Ask) 
           { // Checks TP condition for closing short orders 

            if(Journaling)Print("Trying to close position "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Closing=OrderClose(OrderTicket(),OrderLots(),Ask,Slip*K,Red);
            if(Journaling && !Closing)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Closing)Print("Position successfully closed.");

           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Trigger Hidden Take Profit                                       
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Breakeven Stop
//+------------------------------------------------------------------+
void BreakevenStopAll(bool Journaling,int Retry_Interval,double Breakeven_Buffer,int Magic,int K)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function sets breakeven stops for all positions

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      bool Modify=false;
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
        {
         RefreshRates();
         if(OrderType()==OP_BUY && (Bid-OrderOpenPrice())>(Breakeven_Buffer*K*Point))
           {
            if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Modify=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,CLR_NONE);
            if(Journaling && !Modify)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Modify)Print("Order successfully modified, breakeven stop updated.");
           }
         if(OrderType()==OP_SELL && (OrderOpenPrice()-Ask)>(Breakeven_Buffer*K*Point))
           {
            if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Modify=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,CLR_NONE);
            if(Journaling && !Modify)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Modify)Print("Order successfully modified, breakeven stop updated.");
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Breakeven Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Update Hidden Breakeven Stops List                                     
//+------------------------------------------------------------------+

void UpdateHiddenBEList(bool Journaling,int Retry_Interval,int Magic) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function clears the elements of your HiddenBEList if the corresponding positions has been closed

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   bool doesPosExist;

// Check the HiddenBEList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(HiddenBEList,0); x++)
     { // Looping through all order number in list

      doesPosExist=False;
      orderTicketNumber=(int)HiddenBEList[x];

      if(orderTicketNumber!=0)
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--)
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
              {
               if(orderTicketNumber==OrderTicket())
                 { // Checks order number in list against order number of current positions
                  doesPosExist=True;
                  break;
                 }
              }
           }

         if(doesPosExist==False)
           { // Deletes elements if the order number does not match any current positions
            HiddenBEList[x]=0;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Update Hidden Breakeven Stops List                                         
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set and Trigger Hidden Breakeven Stops                                  
//+------------------------------------------------------------------+

void SetAndTriggerBEHidden(bool Journaling,double Breakeven_Buffer,int Magic,int Slip,int K,int Retry_Interval)
  { // K represents our PipFactor multiplier to adjust for broker digits
// Type: Fixed Template 
// Do not edit unless you know what you're doing

/* 
This function scans through the current positions and does 2 things:
1) If the position is in the hidden breakeven list, it closes it if the appropriate conditions are met
2) If the positon is not the hidden breakeven list, it adds it to the list if the appropriate conditions are met
*/

   bool isOrderInBEList=False;
   int orderTicketNumber;

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      bool Modify=false;
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
        { // Loop through list of current positions
         RefreshRates();
         orderTicketNumber=OrderTicket();
         for(int x=0; x<ArrayRange(HiddenBEList,0); x++)
           { // Loops through hidden BE list
            if(orderTicketNumber==HiddenBEList[x])
              { // Checks if the current position is in the list 
               isOrderInBEList=True;
               break;
              }
           }
         if(isOrderInBEList==True)
           { // If current position is in the list, close it if hidden breakeven stop is breached
            bool Closing=false;
            if(OrderType()==OP_BUY && OrderOpenPrice()>=Bid) 
              { // Checks BE condition for closing long orders    
               if(Journaling)Print("Trying to close position "+(string)OrderTicket()+" using hidden breakeven stop...");
               HandleTradingEnvironment(Journaling,Retry_Interval);
               Closing=OrderClose(OrderTicket(),OrderLots(),Bid,Slip*K,Blue);
               if(Journaling && !Closing)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
               if(Journaling && Closing)Print("Position successfully closed due to hidden breakeven stop.");
              }
            if(OrderType()==OP_SELL && OrderOpenPrice()<=Ask) 
              { // Checks BE condition for closing short orders
               if(Journaling)Print("Trying to close position "+(string)OrderTicket()+" using hidden breakeven stop...");
               HandleTradingEnvironment(Journaling,Retry_Interval);
               Closing=OrderClose(OrderTicket(),OrderLots(),Ask,Slip*K,Red);
               if(Journaling && !Closing)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
               if(Journaling && Closing)Print("Position successfully closed due to hidden breakeven stop.");
              }
              } else { // If current position is not in the hidden BE list. We check if we need to add this position to the hidden BE list.
            if((OrderType()==OP_BUY && (Bid-OrderOpenPrice())>(Breakeven_Buffer*PipFactor*Point)) || (OrderType()==OP_SELL && (OrderOpenPrice()-Ask)>(Breakeven_Buffer*PipFactor*Point)))
              {
               for(int y=0; y<ArrayRange(HiddenBEList,0); y++)
                 { // Loop through of elements in column 1
                  if(HiddenBEList[y]==0)
                    { // Checks if the element is empty
                     HiddenBEList[y]= orderTicketNumber;
                     if(Journaling)Print("Order "+(string)HiddenBEList[y]+" assigned with a hidden breakeven stop.");
                     break;
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Set and Trigger Hidden Breakeven Stops                      
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Trailing Stop
//+------------------------------------------------------------------+

void TrailingStopAll(bool Journaling,double TrailingStopDist,double TrailingStopBuff,int Retry_Interval,int Magic,int K)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function sets trailing stops for all positions

   for(int i=OrdersTotal()-1; i>=0; i--) // Looping through all orders
     {
      bool Modify=false;
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
        {
         RefreshRates();
         if(OrderType()==OP_BUY && (Bid-OrderStopLoss()>(TrailingStopDist+TrailingStopBuff)*K*Point))
           {
            if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TrailingStopDist*K*Point,OrderTakeProfit(),0,CLR_NONE);
            if(Journaling && !Modify)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Modify)Print("Order successfully modified, trailing stop changed.");
           }
         if(OrderType()==OP_SELL && ((OrderStopLoss()-Ask>((TrailingStopDist+TrailingStopBuff)*K*Point)) || (OrderStopLoss()==0)))
           {
            if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TrailingStopDist*K*Point,OrderTakeProfit(),0,CLR_NONE);
            if(Journaling && !Modify)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Modify)Print("Order successfully modified, trailing stop changed.");
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End Trailing Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Update Stop and take profit levels for all positions
//+------------------------------------------------------------------+

void UpdateStopLossTakeProfitAll(bool Journaling,int Retry_Interval,int Magic,int K)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function sets trailing stops for all positions

   for(int i=OrdersTotal()-1; i>=0; i--) // Looping through all orders
     {
      bool Modify=false;
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
        {
         RefreshRates();
         Stop = CalculateStopLoss();
         Take = CalculateTakeProfit();
          if(OrderType()==OP_BUY && (Bid-OrderStopLoss()!=Stop*K*Point || OrderStopLoss()==0))
            {
              if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
              HandleTradingEnvironment(Journaling,Retry_Interval);
              Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Stop*K*Point,Bid+Take*K*Point,0,CLR_NONE);
              if(Journaling && !Modify)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
              if(Journaling && Modify)Print("Order successfully modified, stop loss and take profit changed.");
            }
         if(OrderType()==OP_SELL && ((OrderStopLoss()-Ask!=Stop*K*Point) || (OrderStopLoss()==0)))
           {
            if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Stop*K*Point,Ask-Take*K*Point,0,CLR_NONE);
            if(Journaling && !Modify)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Modify)Print("Order successfully modified, stop loss and take profit changed.");
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End Update Stop and take profit levels for all positions
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Update Hidden Trailing Stops List                                     
//+------------------------------------------------------------------+

void UpdateHiddenTrailingList(bool Journaling,int Retry_Interval,int Magic) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function clears the elements of your HiddenTrailingList if the corresponding positions has been closed

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   bool doesPosExist;

// Check the HiddenTrailingList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(HiddenTrailingList,0); x++)
     { // Looping through all order number in list

      doesPosExist=False;
      orderTicketNumber=(int)HiddenTrailingList[x,0];

      if(orderTicketNumber!=0)
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--)
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
              {
               if(orderTicketNumber==OrderTicket())
                 { // Checks order number in list against order number of current positions
                  doesPosExist=True;
                  break;
                 }
              }
           }

         if(doesPosExist==False)
           { // Deletes elements if the order number does not match any current positions
            HiddenTrailingList[x,0] = 0;
            HiddenTrailingList[x,1] = 0;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Update Hidden Trailing Stops List                                       
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set and Trigger Hidden Trailing Stop
//+------------------------------------------------------------------+

void SetAndTriggerHiddenTrailing(bool Journaling,double TrailingStopDist,double TrailingStopBuff,int Slip,int Retry_Interval,int Magic,int K)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function does 2 things. 1) It sets hidden trailing stops for all positions 2) It closes the positions if hidden trailing stops levels are breached

   bool doesHiddenTrailingRecordExist;
   int posTicketNumber;

   for(int i=OrdersTotal()-1; i>=0; i--) 
     { // Looping through all orders

      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
        {

         doesHiddenTrailingRecordExist=False;
         posTicketNumber=OrderTicket();

         // Step 1: Check if there is any hidden trailing stop records pertaining to this order. If yes, check if we need to close the order.

         for(int x=0; x<ArrayRange(HiddenTrailingList,0); x++) 
           { // Looping through all order number in list 

            if(posTicketNumber==HiddenTrailingList[x,0]) 
              { // If condition holds, it means the position have a hidden trailing stop level attached to it

               doesHiddenTrailingRecordExist=True;
               bool Closing=false;
               RefreshRates();

               if(OrderType()==OP_BUY && HiddenTrailingList[x,1]>=Bid) 
                 {

                  if(Journaling)Print("Trying to close position "+(string)OrderTicket()+" using hidden trailing stop...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Closing=OrderClose(OrderTicket(),OrderLots(),Bid,Slip*K,Blue);
                  if(Journaling && !Closing)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Closing)Print("Position successfully closed due to hidden trailing stop.");

                    } else if(OrderType()==OP_SELL && HiddenTrailingList[x,1]<=Ask) {

                  if(Journaling)Print("Trying to close position "+(string)OrderTicket()+" using hidden trailing stop...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Closing=OrderClose(OrderTicket(),OrderLots(),Ask,Slip*K,Red);
                  if(Journaling && !Closing)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Closing)Print("Position successfully closed due to hidden trailing stop.");

                    }  else {

                  // Step 2: If there are hidden trailing stop records and the position was not closed in Step 1. We update the hidden trailing stop record.

                  if(OrderType()==OP_BUY && (Bid-HiddenTrailingList[x,1]>(TrailingStopDist+TrailingStopBuff)*K*Point)) 
                    {
                     HiddenTrailingList[x,1]=Bid-TrailingStopDist*K*Point; // Assigns new hidden trailing stop level
                     if(Journaling)Print("Order "+(string)posTicketNumber+" successfully modified, hidden trailing stop updated to "+(string)NormalizeDouble(HiddenTrailingList[x,1],Digits)+".");
                    }
                  if(OrderType()==OP_SELL && (HiddenTrailingList[x,1]-Ask>((TrailingStopDist+TrailingStopBuff)*K*Point))) 
                    {
                     HiddenTrailingList[x,1]=Ask+TrailingStopDist*K*Point; // Assigns new hidden trailing stop level
                     if(Journaling)Print("Order "+(string)posTicketNumber+" successfully modified, hidden trailing stop updated "+(string)NormalizeDouble(HiddenTrailingList[x,1],Digits)+".");
                    }
                 }
               break;
              }
           }

         // Step 3: If there are no hidden trailing stop records, add new record.

         if(doesHiddenTrailingRecordExist==False) 
           {

            for(int y=0; y<ArrayRange(HiddenTrailingList,0); y++) 
              { // Looping through list 

               if(HiddenTrailingList[y,0]==0) 
                 { // Slot is empty

                  RefreshRates();
                  HiddenTrailingList[y,0]=posTicketNumber; // Assigns Order Number
                  if(OrderType()==OP_BUY) 
                    {
                     HiddenTrailingList[y,1]=MathMax(Bid,OrderOpenPrice())-TrailingStopDist*K*Point; // Hidden trailing stop level = Higher of Bid or OrderOpenPrice - Trailing Stop Distance
                     if(Journaling)Print("Order "+(string)posTicketNumber+" successfully modified, hidden trailing stop added. Trailing Stop = "+(string)NormalizeDouble(HiddenTrailingList[y,1],Digits)+".");
                    }
                  if(OrderType()==OP_SELL) 
                    {
                     HiddenTrailingList[y,1]=MathMin(Ask,OrderOpenPrice())+TrailingStopDist*K*Point; // Hidden trailing stop level = Lower of Ask or OrderOpenPrice + Trailing Stop Distance
                     if(Journaling)Print("Order "+(string)posTicketNumber+" successfully modified, hidden trailing stop added. Trailing Stop = "+(string)NormalizeDouble(HiddenTrailingList[y,1],Digits)+".");
                    }
                  break;
                 }
              }
           }

        }
     }
  }
//+------------------------------------------------------------------+
//| End of Set and Trigger Hidden Trailing Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Update Volatility Trailing Stops List                                     
//+------------------------------------------------------------------+

void UpdateVolTrailingList(bool Journaling,int Retry_Interval,int Magic) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function clears the elements of your VolTrailingList if the corresponding positions has been closed

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   bool doesPosExist;

// Check the VolTrailingList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(VolTrailingList,0); x++)
     { // Looping through all order number in list

      doesPosExist=False;
      orderTicketNumber=(int)VolTrailingList[x,0];

      if(orderTicketNumber!=0)
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--)
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
              {
               if(orderTicketNumber==OrderTicket())
                 { // Checks order number in list against order number of current positions
                  doesPosExist=True;
                  break;
                 }
              }
           }

         if(doesPosExist==False)
           { // Deletes elements if the order number does not match any current positions
            VolTrailingList[x,0] = 0;
            VolTrailingList[x,1] = 0;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Update Volatility Trailing Stops List                                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set Volatility Trailing Stop
//+------------------------------------------------------------------+

void SetVolTrailingStop(bool Journaling,int Retry_Interval,double VolATR,double VolTrailingDistMulti,int Magic,int K,int OrderNum)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function adds new volatility trailing stop level using OrderModify()

   double VolTrailingStopDist;
   bool Modify=False;
   bool IsVolTrailingStopAdded=False;
   
   VolTrailingStopDist=VolTrailingDistMulti*VolATR/(K*Point); // Volatility trailing stop amount in Pips

   if(OrderSelect(OrderNum,SELECT_BY_TICKET)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
     {
      RefreshRates();
      if(OrderType()==OP_BUY)
        {
         if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
         HandleTradingEnvironment(Journaling,Retry_Interval);
         Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-VolTrailingStopDist*K*Point,OrderTakeProfit(),0,CLR_NONE);
         IsVolTrailingStopAdded=True;   
         if(Journaling && !Modify)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
         if(Journaling && Modify)Print("Order successfully modified, volatility trailing stop changed.");
        }
      if(OrderType()==OP_SELL)
        {
         if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
         HandleTradingEnvironment(Journaling,Retry_Interval);
         Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+VolTrailingStopDist*K*Point,OrderTakeProfit(),0,CLR_NONE);
         IsVolTrailingStopAdded=True;
         if(Journaling && !Modify)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
         if(Journaling && Modify)Print("Order successfully modified, volatility trailing stop changed.");
        } 
     
      // Records volatility measure (ATR value) for future use
      if(IsVolTrailingStopAdded==True) 
         {
         for(int x=0; x<ArrayRange(VolTrailingList,0); x++) // Loop through elements in VolTrailingList
           { 
            if(VolTrailingList[x,0]==0)  // Checks if the element is empty
              { 
               VolTrailingList[x,0]=OrderNum; // Add order number
               VolTrailingList[x,1]=VolATR/(K*Point); // Add volatility measure aka 1 unit of ATR
               break;
              }
           }
         }
     }     
  }
//+------------------------------------------------------------------+
//| End of Set Volatility Trailing Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Review Hidden Volatility Trailing Stop
//+------------------------------------------------------------------+

void ReviewVolTrailingStop(bool Journaling, double VolTrailingDistMulti, double VolTrailingBuffMulti, int Retry_Interval, int Magic, int K)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function updates volatility trailing stops levels for all positions (using OrderModify) if appropriate conditions are met

   bool doesVolTrailingRecordExist;
   int posTicketNumber;

   for(int i=OrdersTotal()-1; i>=0; i--) 
     { // Looping through all orders

      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
        {
         doesVolTrailingRecordExist = False;
         posTicketNumber=OrderTicket();

         for(int x=0; x<ArrayRange(VolTrailingList,0); x++) 
           { // Looping through all order number in list 

            if(posTicketNumber==VolTrailingList[x,0]) 
              { // If condition holds, it means the position have a volatility trailing stop level attached to it

               doesVolTrailingRecordExist = True; 
               bool Modify=false;
               RefreshRates();

               // We update the volatility trailing stop record using OrderModify.
               if(OrderType()==OP_BUY && (Bid-OrderStopLoss()>(VolTrailingDistMulti*VolTrailingList[x,1]+VolTrailingBuffMulti*VolTrailingList[x,1])*K*Point) &&
                  (OrderStopLoss()+VolTrailingBuffMulti*VolTrailingList[x,1]*K*Point < Bid))
                 {
                  if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-VolTrailingDistMulti*VolTrailingList[x,1]*K*Point,OrderTakeProfit(),0,CLR_NONE);
                  if(Journaling && !Modify)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Modify)Print("Order successfully modified, volatility trailing stop changed.");
                 }
               if(OrderType()==OP_SELL && ((OrderStopLoss()-Ask>((VolTrailingDistMulti*VolTrailingList[x,1]+VolTrailingBuffMulti*VolTrailingList[x,1])*K*Point)) || (OrderStopLoss()==0))  &&
                  (OrderStopLoss()-VolTrailingBuffMulti*VolTrailingList[x,1]*K*Point > Ask))
                 {
                  if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+VolTrailingDistMulti*VolTrailingList[x,1]*K*Point,OrderTakeProfit(),0,CLR_NONE);
                  if(Journaling && !Modify)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Modify)Print("Order successfully modified, volatility trailing stop changed.");
                 }
               break;
              }
           }
        // If order does not have a record attached to it. Alert the trader.
        if(!doesVolTrailingRecordExist && Journaling) Print("Error. Order "+(string)posTicketNumber+" has no volatility trailing stop attached to it.");
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Review Volatility Trailing Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Update Hidden Volatility Trailing Stops List                                     
//+------------------------------------------------------------------+

void UpdateHiddenVolTrailingList(bool Journaling,int Retry_Interval,int Magic) 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function clears the elements of your HiddenVolTrailingList if the corresponding positions has been closed

   int ordersPos=OrdersTotal();
   int orderTicketNumber;
   bool doesPosExist;

// Check the HiddenVolTrailingList, match with current list of positions. Make sure the all the positions exists. 
// If it doesn't, it means there are positions that have been closed

   for(int x=0; x<ArrayRange(HiddenVolTrailingList,0); x++)
     { // Looping through all order number in list

      doesPosExist=False;
      orderTicketNumber=(int)HiddenVolTrailingList[x,0];

      if(orderTicketNumber!=0)
        { // Order exists
         for(int y=ordersPos-1; y>=0; y--)
           { // Looping through all current open positions
            if(OrderSelect(y,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
              {
               if(orderTicketNumber==OrderTicket())
                 { // Checks order number in list against order number of current positions
                  doesPosExist=True;
                  break;
                 }
              }
           }

         if(doesPosExist==False)
           { // Deletes elements if the order number does not match any current positions
            HiddenVolTrailingList[x,0] = 0;
            HiddenVolTrailingList[x,1] = 0;
            HiddenVolTrailingList[x,2] = 0;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Update Hidden Volatility Trailing Stops List                                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Set Hidden Volatility Trailing Stop
//+------------------------------------------------------------------+

void SetHiddenVolTrailing(bool Journaling,double VolATR,double VolTrailingDistMultiplierHidden,int Magic,int K,int OrderNum)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function adds new hidden volatility trailing stop record 

   double VolTrailingStopLevel=0;
   double VolTrailingStopDist=0;

   VolTrailingStopDist=VolTrailingDistMultiplierHidden*VolATR/(K*Point); // Volatility trailing stop amount in Pips

   if(OrderSelect(OrderNum,SELECT_BY_TICKET)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
     {
      RefreshRates();
      if(OrderType()==OP_BUY)  VolTrailingStopLevel = MathMax(Bid, OrderOpenPrice()) - VolTrailingStopDist*K*Point; // Volatility trailing stop level of buy trades
      if(OrderType()==OP_SELL) VolTrailingStopLevel = MathMin(Ask, OrderOpenPrice()) + VolTrailingStopDist*K*Point; // Volatility trailing stop level of sell trades
     
     }

   for(int x=0; x<ArrayRange(HiddenVolTrailingList,0); x++) // Loop through elements in HiddenVolTrailingList
     { 
      if(HiddenVolTrailingList[x,0]==0)  // Checks if the element is empty
        { 
         HiddenVolTrailingList[x,0] = OrderNum; // Add order number
         HiddenVolTrailingList[x,1] = VolTrailingStopLevel; // Add volatility trailing stop level 
         HiddenVolTrailingList[x,2] = VolATR/(K*Point); // Add volatility measure aka 1 unit of ATR
         if(Journaling)Print("Order "+(string)HiddenVolTrailingList[x,0]+" assigned with a hidden volatility trailing stop level of "+(string)NormalizeDouble(HiddenVolTrailingList[x,1],Digits)+".");
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Set Hidden Volatility Trailing Stop
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Trigger and Review Hidden Volatility Trailing Stop
//+------------------------------------------------------------------+

void TriggerAndReviewHiddenVolTrailing(bool Journaling, double VolTrailingDistMultiplierHidden, double VolTrailingBuffMultiplierHidden, int Slip, int Retry_Interval, int Magic, int K)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function does 2 things. 1) It closes the positions if hidden volatility trailing stops levels are breached. 2) It updates hidden volatility trailing stops for all positions if appropriate conditions are met

   bool doesHiddenVolTrailingRecordExist;
   int posTicketNumber;

   for(int i=OrdersTotal()-1; i>=0; i--) 
     { // Looping through all orders

      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic) 
        {
         doesHiddenVolTrailingRecordExist = False;
         posTicketNumber=OrderTicket();

         // 1) Check if we need to close the order.

         for(int x=0; x<ArrayRange(HiddenVolTrailingList,0); x++) 
           { // Looping through all order number in list 

            if(posTicketNumber==HiddenVolTrailingList[x,0]) 
              { // If condition holds, it means the position have a hidden volatility trailing stop level attached to it

               doesHiddenVolTrailingRecordExist = True; 
               bool Closing=false;
               RefreshRates();

               if(OrderType()==OP_BUY && HiddenVolTrailingList[x,1]>=Bid) 
                 {

                  if(Journaling)Print("Trying to close position "+(string)OrderTicket()+" using hidden volatility trailing stop...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Closing=OrderClose(OrderTicket(),OrderLots(),Bid,Slip*K,Blue);
                  if(Journaling && !Closing)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Closing)Print("Position successfully closed due to hidden volatility trailing stop.");

                    } else if (OrderType()==OP_SELL && HiddenVolTrailingList[x,1]<=Ask) {

                  if(Journaling)Print("Trying to close position "+(string)OrderTicket()+" using hidden volatility trailing stop...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Closing=OrderClose(OrderTicket(),OrderLots(),Ask,Slip*K,Red);
                  if(Journaling && !Closing)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Closing)Print("Position successfully closed due to hidden volatility trailing stop.");

                    }  else {

                  // 2) If orders was not closed in 1), we update the hidden volatility trailing stop record.

                  if(OrderType()==OP_BUY && (Bid-HiddenVolTrailingList[x,1]>(VolTrailingDistMultiplierHidden*HiddenVolTrailingList[x,2]+VolTrailingBuffMultiplierHidden*HiddenVolTrailingList[x,2])*K*Point)) 
                    {
                     HiddenVolTrailingList[x,1]=Bid-VolTrailingDistMultiplierHidden*HiddenVolTrailingList[x,2]*K*Point; // Assigns new hidden trailing stop level
                     if(Journaling)Print("Order "+(string)posTicketNumber+" successfully modified, hidden volatility trailing stop updated to "+(string)NormalizeDouble(HiddenVolTrailingList[x,1],Digits)+".");
                    }
                  if(OrderType()==OP_SELL && (HiddenVolTrailingList[x,1]-Ask>(VolTrailingDistMultiplierHidden*HiddenVolTrailingList[x,2]+VolTrailingBuffMultiplierHidden*HiddenVolTrailingList[x,2])*K*Point))
                    {
                     HiddenVolTrailingList[x,1]=Ask+VolTrailingDistMultiplierHidden*HiddenVolTrailingList[x,2]*K*Point; // Assigns new hidden trailing stop level
                     if(Journaling)Print("Order "+(string)posTicketNumber+" successfully modified, hidden volatility trailing stop updated "+(string)NormalizeDouble(HiddenVolTrailingList[x,1],Digits)+".");
                    }
                 }
               break;
              }
           }
        // If order does not have a record attached to it. Alert the trader.
        if(!doesHiddenVolTrailingRecordExist && Journaling) Print("Error. Order "+(string)posTicketNumber+" has no hidden volatility trailing stop attached to it.");
        }
     }
  }
//+------------------------------------------------------------------+
//| End of Trigger and Review Hidden Volatility Trailing Stop
//+------------------------------------------------------------------+
//| CalculateStopLoss                                                |
//+------------------------------------------------------------------+
double CalculateStopLoss()
  {
   if(UseFixedStopLoss==True) 
    {
      if(Trigger==1) // Buy
        Stop=FixedStopLoss; // Use Fixed Stop Loss in Pips
      else if(Trigger==2) // Sell
        Stop=FixedStopLoss; // Use Fixed Stop Loss in Pips
    }  
    else if(SlTpbyLastBar==True) 
    {
      if(Trigger==1) // Buy
        {
          double min = Low[0];
          for(int iBarIndex = 0; iBarIndex < 10; iBarIndex++)
          {
            min = MathMin(Low[iBarIndex],Low[iBarIndex+1]);
            if(Ask - min > MinStopLossATRMultiplier * myATR)
            {
              Stop=(Ask - min)/(PipFactor*Point) * (1+StopBarMargin/100); // Stop Loss in Pips
              break;
            }
          }
          
          // if(OnJournaling) Print("Stop: ", Stop, " StopBarMargin: ", StopBarMargin);
          // if(!lastOrderClosedByStopLoss) // skip check if last order closed by stop loss
          // Print("Initial Stop: ", Stop, " MinStopLoss: ", MinStopLoss);
          {
            if(Stop*(PipFactor*Point)<MinStopLossATRMultiplier*myATR) 
            {
              Stop=VolBasedStopLoss(True,FixedStopLoss,myATR,VolBasedSLMultiplier,PipFactor);
              if(OnJournaling) Print("Stop too small, using ATR for Stop Loss: ", NormalizeDouble(Stop, 1));
            } 
            else if(Stop*(PipFactor*Point)>MaxStopLossATRMultiplier*myATR && !lastOrderClosedByStopLoss && !IsPinBar) // If the stop is too large, use ATR
            {
              Stop=VolBasedStopLoss(True,FixedStopLoss,myATR,VolBasedSLMultiplier,PipFactor);
              if(OnJournaling) Print("Stop is too large, using ATR for Stop Loss: ", NormalizeDouble(Stop, 1));
            }
          }
        } 
        else if(Trigger==2) 
        { 
          double max = High[0];
          for(int iBarIndex = 0; iBarIndex < 10; iBarIndex++)
          {
            max = MathMax(High[iBarIndex],High[iBarIndex+1]);
            if(max - Bid > MinStopLossATRMultiplier * myATR)
            {
              Stop=(max - Bid)/(PipFactor*Point) * (1+StopBarMargin/100); // Stop Loss in Pips
              break;
            }
          }

          // if(OnJournaling) Print("Stop: ", Stop, " StopBarMargin: ", StopBarMargin);
          // if(!lastOrderClosedByStopLoss) // skip check if last order closed by stop loss
          // Print("Initial Stop: ", Stop, " MinStopLoss: ", MinStopLoss);
          {
            if(Stop*(PipFactor*Point)<MinStopLossATRMultiplier*myATR) 
            {
              Stop=VolBasedStopLoss(True,FixedStopLoss,myATR,VolBasedSLMultiplier,PipFactor);
              if(OnJournaling) Print("Stop too small, using ATR for Stop Loss: ", NormalizeDouble(Stop, 1));
            }
            else if(Stop*(PipFactor*Point)>MaxStopLossATRMultiplier*myATR && !lastOrderClosedByStopLoss && !IsPinBar) // If the stop is too large, use ATR
            {
              Stop=VolBasedStopLoss(True,FixedStopLoss,myATR,VolBasedSLMultiplier,PipFactor);
              if(OnJournaling) Print("Stop is too large, using ATR for Stop Loss: ", NormalizeDouble(Stop, 1));
            }
          }
        }
    } else
    {
      Stop=VolBasedStopLoss(IsVolatilityStopOn,FixedStopLoss,myATR,VolBasedSLMultiplier,PipFactor);
    }

    // check if Stop is close to supply or demand zone, not in breakout
    if((UseSupplyDemandPoints || UseSupplyDemandATR) && Trigger > 0)
    {
      if(Trigger==1)
      {
        if(Ask - Stop*(PipFactor*Point) < prev_ner_lo_zone_P1) // P1 is the upper bound of the demand zone
        {
          // double prvStop = Stop;
          Stop = (Ask - prev_ner_lo_zone_P2 + StopLossMarginATRMultiplier * myATR)/(PipFactor*Point); // Adjust Stop Profit to be below the demand zone to stop on breakout
          // Print("Take Profit is close to demand zone, Take: ", Take*(PipFactor*Point), " prvTake: ", prvTake*(PipFactor*Point), " ATR: ", myATR);
          if(Stop < MinStopLossATRMultiplier*myATR/(PipFactor*Point)) // Ensure Stop is not too small
          {
            Stop = 0;
            Trigger = 0;
            if(OnJournaling) Print("Stop Profit is too close or below to demand zone, canceling signal");
          }
        }
      } else if(Trigger==2)
      {
        if(Ask + Stop*(PipFactor*Point) > prev_ner_hi_zone_P2) //P2 is the lower bound of the supply zone
        {
          // double prvStop = Stop;
          Stop = (prev_ner_hi_zone_P1 - Ask + StopLossMarginATRMultiplier * myATR)/(PipFactor*Point); // Adjust Take Profit to be above the supply zone to stop on breakout
          // Print("Take Profit is close to demand zone, Take: ", Take*(PipFactor*Point), " prvTake: ", prvTake*(PipFactor*Point), " ATR: ", myATR);
          if(Stop < MinStopLossATRMultiplier*myATR/(PipFactor*Point))
          {
            Stop = 0;
            Trigger = 0;
            if(OnJournaling) Print("Stop Profit is too close or above to supply zone, canceling signal");
          }
        }
        
      } 
    }

   return(Stop);
  }

//+------------------------------------------------------------------+
//| CalculateStopLoss                                      
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| CalculateTakeProfit                                                                                     
//+------------------------------------------------------------------+
double CalculateTakeProfit()
  {
   if(UseFixedTakeProfit==True) 
    {
      if(Trigger==1) // Buy
        Take=FixedTakeProfit; // Use Fixed Take Profit in Pips
      else if(Trigger==2) // Sell
        Take=FixedTakeProfit; // Use Fixed Take Profit in Pips
    }  
    else if(SlTpbyLastBar==True) 
    {
       Take=Stop*TpSlRatio;
    }
    else 
    {
      Take=VolBasedTakeProfit(IsVolatilityTakeProfitOn,FixedTakeProfit,myATR,VolBasedTPMultiplier,PipFactor);
    }

    if(lastOrderClosedByStopLoss)
    {
      Take = 0.5 * Take;
    }

    // check if Take is close to supply or demand zone, not in breakout
    if((UseSupplyDemandPoints || UseSupplyDemandATR) && Trigger > 0)
    {
      if(Trigger==1)
      {
        if(Ask + Take*(PipFactor*Point) + TakeProfitMarginATRMultiplier * myATR > prev_ner_hi_zone_P2) //P2 is the lower bound of the supply zone
        {
          double prvTake = Take;
          Take = (prev_ner_hi_zone_P2 - Ask - TakeProfitMarginATRMultiplier * myATR)/(PipFactor*Point); // Adjust Take Profit to be below the supply zone
          // Print("Take Profit is close to demand zone, Take: ", Take*(PipFactor*Point), " prvTake: ", prvTake*(PipFactor*Point), " ATR: ", myATR);
          if(Take < TakeProfitMarginATRMultiplier*myATR/(PipFactor*Point) && Take < MinTakeProfitATRMultiplier*myATR/(PipFactor*Point))
          {
            Take = 0;
            Trigger = 0;
            if(OnJournaling) Print("Take Profit is too close or above to supply zone, canceling signal");
          }
        }
        
      } 
      else if(Trigger==2)
      {
        if(Ask - Take*(PipFactor*Point) - TakeProfitMarginATRMultiplier * myATR < prev_ner_lo_zone_P1) // P1 is the upper bound of the demand zone
        {
          double prvTake = Take;
          Take = (Ask - prev_ner_lo_zone_P1 - TakeProfitMarginATRMultiplier * myATR)/(PipFactor*Point); // Adjust Take Profit to be above the demand zone
          // Print("Take Profit is close to demand zone, Take: ", Take*(PipFactor*Point), " prvTake: ", prvTake*(PipFactor*Point), " ATR: ", myATR);
          if(Take < TakeProfitMarginATRMultiplier*myATR/(PipFactor*Point) && Take < MinTakeProfitATRMultiplier*myATR/(PipFactor*Point)) // Ensure Take is not too small
          {
            Take = 0;
            Trigger = 0;
            if(OnJournaling) Print("Take Profit is too close or below to demand zone, canceling signal");
          }
        }
      }
    }

   return(Take);
  }
//+------------------------------------------------------------------+
//| CalculateTakeProfit                                                                                     
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Calculate Arears Money Management Risk Size                      |
//+------------------------------------------------------------------+
double CalculateArearsRisk()
{
    double adjustedRisk = UpdatedRisk;

    if(!IsArearsManagementEnabled)
        return adjustedRisk;

    static int prvOrder = 0;

    double price;
    double profit;
    int type;
    int order;
    datetime time;
    CloseReason closeReason;
    if(!GetLastProfit(MagicNumber, order, time, profit, type, price, closeReason, Symbol()))
      return adjustedRisk;

    if(prvOrder==order)
      return adjustedRisk;
    
    prvOrder = order;

    int consecutiveLosses = 0;
    double lossAmount = GetConsecutiveLossAmount(MagicNumber, consecutiveLosses);
    double profitToday = GetProfitToday(MagicNumber, Symbol());
    double sumProfitFromLoss = GetSumProfitSinceLoss(MagicNumber, Symbol());
    double accountBalance = AccountBalance();
    double dailyTarget = Risk * accountBalance / 100; // Target profit in currency

    double arears = sumProfitFromLoss; // Current arears in currency
    if (arears > 0) 
      arears = 0;

    if(UseProgressiveArears)
    {
        if(consecutiveLosses > 0) // We have new loss (consecutive losses but maybe overall positive today)
        {
          // Increase risk by increment for new loss
          adjustedRisk = adjustedRisk + ArearsMMSizeIncrement;
          
          // Apply safety cap
          if(adjustedRisk > Risk * ArearsMMMaxMultiplier)
            adjustedRisk = Risk * ArearsMMMaxMultiplier;
        }
        else 
        {
          if(arears < -dailyTarget)
            adjustedRisk = (MathAbs(arears) / accountBalance) * 100;
          else
            adjustedRisk = Risk;

          // Apply safety cap
          if(adjustedRisk > Risk * ArearsMMMaxMultiplier)
            adjustedRisk = Risk * ArearsMMMaxMultiplier;
        }
    }
    else
    {
        // Simple incremental approach (your current method)
        adjustedRisk = Risk + (ArearsMMSizeIncrement * consecutiveLosses);
        
        // Apply safety cap
        if(adjustedRisk > Risk * ArearsMMMaxMultiplier)
            adjustedRisk = Risk * ArearsMMMaxMultiplier;
            
    }

    if(OnJournaling)
    {             
      string csvFileName = "AreasManagement_" + Symbol() + "_" + TimeToString(TimeCurrent(), TIME_DATE) + ".csv";
      int csvHandle = FileOpen(csvFileName, FILE_CSV | FILE_WRITE | FILE_READ);
      
      if(csvHandle != INVALID_HANDLE)
      {
          // Check if file is empty and add header if needed
          if(FileSize(csvHandle) == 0)
          {
          FileWrite(csvHandle, "Time,Symbol,Risk%,Result,Profit,Accumulated_Profit,Arear, accountBalance");
          }
          
          // Move to end of file to append
          FileSeek(csvHandle, 0, SEEK_END);

          string res = (profit < 0) ? "Loss" : "Win";
          
          // Write data row
          string csvRow = TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES) + "," +
                Symbol() + "," +
                DoubleToString(UpdatedRisk, 2) + "," +
                res + "," +
                DoubleToString(profit, 2) + "," +
                DoubleToString(profitToday, 2) + "," +
                DoubleToString(arears, 2) + "," +
                DoubleToString(accountBalance, 2);
                                ;
          FileWrite(csvHandle, csvRow);
          FileClose(csvHandle);
      }
      else
      {
        Print("Failed to open CSV file: ", csvFileName, " Error: ", GetLastError());
      }
    }

    return adjustedRisk;
}
//+------------------------------------------------------------------+
//| Calculate Arears Money Management Risk Size                      |
//+------------------------------------------------------------------+

void HandleTradingEnvironment(bool Journaling,int Retry_Interval)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing 

// This function checks for errors

   if(IsTradeAllowed()==true)return;
   if(!IsConnected())
     {
      if(Journaling)Print("Terminal is not connected to server...");
      return;
     }
   if(!IsTradeAllowed() && Journaling)Print("Trade is not alowed for some reason...");
   if(IsConnected() && !IsTradeAllowed())
     {
      while(IsTradeContextBusy()==true)
        {
         if(Journaling)Print("Trading context is busy... Will wait a bit...");
         Sleep(Retry_Interval);
        }
     }
   RefreshRates();
  }
//+------------------------------------------------------------------+
//| End of HANDLE TRADING ENVIRONMENT                                
//+------------------------------------------------------------------+  
//+------------------------------------------------------------------+
//| ERROR DESCRIPTION                                                
//+------------------------------------------------------------------+
string GetErrorDescription(int error)
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function returns the exact error

   string ErrorDescription="";
//---
   switch(error)
     {
      case 0:     ErrorDescription = "NO Error. Everything should be good.";                                    break;
      case 1:     ErrorDescription = "No error returned, but the result is unknown";                            break;
      case 2:     ErrorDescription = "Common error";                                                            break;
      case 3:     ErrorDescription = "Invalid trade parameters";                                                break;
      case 4:     ErrorDescription = "Trade server is busy";                                                    break;
      case 5:     ErrorDescription = "Old version of the client terminal";                                      break;
      case 6:     ErrorDescription = "No connection with trade server";                                         break;
      case 7:     ErrorDescription = "Not enough rights";                                                       break;
      case 8:     ErrorDescription = "Too frequent requests";                                                   break;
      case 9:     ErrorDescription = "Malfunctional trade operation";                                           break;
      case 64:    ErrorDescription = "Account disabled";                                                        break;
      case 65:    ErrorDescription = "Invalid account";                                                         break;
      case 128:   ErrorDescription = "Trade timeout";                                                           break;
      case 129:   ErrorDescription = "Invalid price";                                                           break;
      case 130:   ErrorDescription = "Invalid stops";                                                           break;
      case 131:   ErrorDescription = "Invalid trade volume";                                                    break;
      case 132:   ErrorDescription = "Market is closed";                                                        break;
      case 133:   ErrorDescription = "Trade is disabled";                                                       break;
      case 134:   ErrorDescription = "Not enough money";                                                        break;
      case 135:   ErrorDescription = "Price changed";                                                           break;
      case 136:   ErrorDescription = "Off quotes";                                                              break;
      case 137:   ErrorDescription = "Broker is busy";                                                          break;
      case 138:   ErrorDescription = "Requote";                                                                 break;
      case 139:   ErrorDescription = "Order is locked";                                                         break;
      case 140:   ErrorDescription = "Long positions only allowed";                                             break;
      case 141:   ErrorDescription = "Too many requests";                                                       break;
      case 145:   ErrorDescription = "Modification denied because order too close to market";                   break;
      case 146:   ErrorDescription = "Trade context is busy";                                                   break;
      case 147:   ErrorDescription = "Expirations are denied by broker";                                        break;
      case 148:   ErrorDescription = "Too many open and pending orders (more than allowed)";                    break;
      case 4000:  ErrorDescription = "No error";                                                                break;
      case 4001:  ErrorDescription = "Wrong function pointer";                                                  break;
      case 4002:  ErrorDescription = "Array index is out of range";                                             break;
      case 4003:  ErrorDescription = "No memory for function call stack";                                       break;
      case 4004:  ErrorDescription = "Recursive stack overflow";                                                break;
      case 4005:  ErrorDescription = "Not enough stack for parameter";                                          break;
      case 4006:  ErrorDescription = "No memory for parameter string";                                          break;
      case 4007:  ErrorDescription = "No memory for temp string";                                               break;
      case 4008:  ErrorDescription = "Not initialized string";                                                  break;
      case 4009:  ErrorDescription = "Not initialized string in array";                                         break;
      case 4010:  ErrorDescription = "No memory for array string";                                              break;
      case 4011:  ErrorDescription = "Too long string";                                                         break;
      case 4012:  ErrorDescription = "Remainder from zero divide";                                              break;
      case 4013:  ErrorDescription = "Zero divide";                                                             break;
      case 4014:  ErrorDescription = "Unknown command";                                                         break;
      case 4015:  ErrorDescription = "Wrong jump (never generated error)";                                      break;
      case 4016:  ErrorDescription = "Not initialized array";                                                   break;
      case 4017:  ErrorDescription = "DLL calls are not allowed";                                               break;
      case 4018:  ErrorDescription = "Cannot load library";                                                     break;
      case 4019:  ErrorDescription = "Cannot call function";                                                    break;
      case 4020:  ErrorDescription = "Expert function calls are not allowed";                                   break;
      case 4021:  ErrorDescription = "Not enough memory for temp string returned from function";                break;
      case 4022:  ErrorDescription = "System is busy (never generated error)";                                  break;
      case 4050:  ErrorDescription = "Invalid function parameters count";                                       break;
      case 4051:  ErrorDescription = "Invalid function parameter value";                                        break;
      case 4052:  ErrorDescription = "String function internal error";                                          break;
      case 4053:  ErrorDescription = "Some array error";                                                        break;
      case 4054:  ErrorDescription = "Incorrect series array using";                                            break;
      case 4055:  ErrorDescription = "Custom indicator error";                                                  break;
      case 4056:  ErrorDescription = "Arrays are incompatible";                                                 break;
      case 4057:  ErrorDescription = "Global variables processing error";                                       break;
      case 4058:  ErrorDescription = "Global variable not found";                                               break;
      case 4059:  ErrorDescription = "Function is not allowed in testing mode";                                 break;
      case 4060:  ErrorDescription = "Function is not confirmed";                                               break;
      case 4061:  ErrorDescription = "Send mail error";                                                         break;
      case 4062:  ErrorDescription = "String parameter expected";                                               break;
      case 4063:  ErrorDescription = "Integer parameter expected";                                              break;
      case 4064:  ErrorDescription = "Double parameter expected";                                               break;
      case 4065:  ErrorDescription = "Array as parameter expected";                                             break;
      case 4066:  ErrorDescription = "Requested history data in updating state";                                break;
      case 4067:  ErrorDescription = "Some error in trading function";                                          break;
      case 4099:  ErrorDescription = "End of file";                                                             break;
      case 4100:  ErrorDescription = "Some file error";                                                         break;
      case 4101:  ErrorDescription = "Wrong file name";                                                         break;
      case 4102:  ErrorDescription = "Too many opened files";                                                   break;
      case 4103:  ErrorDescription = "Cannot open file";                                                        break;
      case 4104:  ErrorDescription = "Incompatible access to a file";                                           break;
      case 4105:  ErrorDescription = "No order selected";                                                       break;
      case 4106:  ErrorDescription = "Unknown symbol";                                                          break;
      case 4107:  ErrorDescription = "Invalid price";                                                           break;
      case 4108:  ErrorDescription = "Invalid ticket";                                                          break;
      case 4109:  ErrorDescription = "EA is not allowed to trade is not allowed. ";                             break;
      case 4110:  ErrorDescription = "Longs are not allowed. Check the expert properties";                      break;
      case 4111:  ErrorDescription = "Shorts are not allowed. Check the expert properties";                     break;
      case 4200:  ErrorDescription = "Object exists already";                                                   break;
      case 4201:  ErrorDescription = "Unknown object property";                                                 break;
      case 4202:  ErrorDescription = "Object does not exist";                                                   break;
      case 4203:  ErrorDescription = "Unknown object type";                                                     break;
      case 4204:  ErrorDescription = "No object name";                                                          break;
      case 4205:  ErrorDescription = "Object coordinates error";                                                break;
      case 4206:  ErrorDescription = "No specified subwindow";                                                  break;
      case 4207:  ErrorDescription = "Some error in object function";                                           break;
      default:    ErrorDescription = "No error or error is unknown";
     }
   return(ErrorDescription);
  }
//+------------------------------------------------------------------+
//| End of ERROR DESCRIPTION                                         
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| CROSSED                                         |
//+------------------------------------------------------------------+
int Crossed(double prevClose, double currClose, double line)
  {
// This function determines if a cross happened between 2 lines/data set

/* 
If Output is 0: No cross happened
If Output is 1: Price crossed line from Bottom (Bullish)
If Output is 2: Price crossed line from Top (Bearish)
*/
   
   // Check crossing using Close[2] and Close[1] vs the provided line
   if(prevClose > line && currClose < line)
      return(2);  // Bearish cross: Price crossed below line
   else if(prevClose < line && currClose > line)
      return(1);  // Bullish cross: Price crossed above line
   else
      return(0);  // No cross

    return(0);
  }
//+------------------------------------------------------------------+
//| End of CROSSED                            
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Visualize peak: draw text at close price (overlay on chart)      |
//+------------------------------------------------------------------+
void VisualizeSignalOverlay(int i, int signal)
{
   static int signalsCountr = 0;
  //  string txt = "";
  int arrowCode = 0;
   color col = clrBlack;
   double chartHigh = WindowPriceMax();
   double chartLow = WindowPriceMin();
   double chartRange = chartHigh - chartLow;
   double y_offset = 2* chartRange * 0.02; // Use 2% of visible chart range as offset
   double y = 0;

   switch(signal) {
      case 1:   arrowCode = 233;  col = clrGreen;  y = High[i] + 1.5*y_offset; break;   
      case 2:   arrowCode = 234;  col = clrRed;   y = Low[i] - y_offset; break; 
      default:  return; 
   }
   string name = "signal_" + IntegerToString(signalsCountr++) + "_time_" + TimeToString(Time[i], TIME_MINUTES) + "_" + string(arrowCode);
  //  Print("VisualizeSignalOverlay: i=", i, " name=", name, ", y=", y);

   ObjectDelete(name);
   if(ObjectCreate(name, OBJ_ARROW, 0, Time[i], y))
   {
      ObjectSet(name, OBJPROP_CORNER, 0);
      ObjectSet(name, OBJPROP_ANCHOR, ANCHOR_CENTER);
      ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(name, OBJPROP_ARROWCODE, arrowCode); // e.g., 233 for up, 234 for down
      ObjectSet(name, OBJPROP_COLOR, col);
   }
   else
   {
      if(PAverbose) Print("Failed to create text object: ", name);
   }
   
}

void VisualizeResultOverlay(datetime now, int winloss, double price)
{
   static int signalsCountr = 0;
  //  string txt = "";
   string code = "";
   color col = clrBlack;


   switch(winloss) {
      case 1:   code = "ü";  col = clrGreen;  break;   
      case 2:   code = "û";  col = clrRed;   break; 
      default:  return; 
   }
   string name = "result_" + IntegerToString(signalsCountr++) + "_time_" + TimeToString(now, TIME_MINUTES) + "_" + code;
  //  Print("VisualizeSignalOverlay: i=", i, " name=", name, ", y=", y);

   ObjectDelete(name);
   if(ObjectCreate(name, OBJ_TEXT, 0, now, price))
   {
      ObjectSetText(name, code, 24, "Wingdings", col);
      ObjectSet(name, OBJPROP_CORNER, 0);
      ObjectSet(name, OBJPROP_ANCHOR, ANCHOR_CENTER);
      ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(name, OBJPROP_COLOR, col);
   }
   else
   {
      if(PAverbose) Print("Failed to create text object: ", name);
   }
   
}

//+------------------------------------------------------------------+
//| Display Risk Size Near Entry Point                               |
//+------------------------------------------------------------------+
void DisplayRiskSizeOnChart(datetime entryTime, double entryPrice, double risk, double size, int orderType)
{
   static int riskDisplayCounter = 0;
   
   // Create unique name for the text object
   string name = "risksize_" + IntegerToString(riskDisplayCounter++) + "_time_" + TimeToString(entryTime, TIME_MINUTES);
      
   // Set color based on order type
   color textColor = (orderType == OP_BUY) ? clrGreen : clrRed;
   
   // Calculate text position slightly offset from entry price
   double textPrice = entryPrice;
   if(orderType == OP_BUY)
   {
      textPrice = entryPrice + (Point); // Above entry for buy orders
   }
   else
   {
      textPrice = entryPrice - (Point); // Below entry for sell orders
   }

  string sizeText = " " + DoubleToString(size, 1);
  string riskText = " (" + DoubleToString(risk, 1) + "%)";
  riskText = sizeText + riskText;
   
   // Delete any existing object with the same name
   ObjectDelete(name);
   
   // Create text object
  if(ObjectCreate(name, OBJ_TEXT, 0, entryTime, textPrice))
  {
    ObjectSetText(name, riskText, 10, "Arial", textColor);
    ObjectSet(name, OBJPROP_ANCHOR, ANCHOR_LEFT);
    ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
    ObjectSet(name, OBJPROP_COLOR, textColor);
    ObjectSet(name, OBJPROP_BACK, false); // Draw in foreground
      
    // if(OnJournaling) Print("Lot size display created: ", name, " Size: ", riskText, " at ", TimeToString(entryTime));
   }
  //  else
  //  {
  //     if(OnJournaling) Print("Failed to create lot size display: ", name);
  //  }
}

//+------------------------------------------------------------------+
//| Chart event function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
    // Handle button clicks
    if(id == CHARTEVENT_OBJECT_CLICK)
    {
        if(TradeController != NULL && sparam == "AutoTradingBtn")
        {
            TradeController.CheckButtonClick();
        }
    }
}

void SaveChart()
{
  if(!OnChartShots)
    return;

  datetime current_time = TimeCurrent();
  string time_str = StringFormat("%04d.%02d.%02d %02d-%02d-%02d",
      TimeYear(current_time),
      TimeMonth(current_time), 
      TimeDay(current_time),
      TimeHour(current_time),
      TimeMinute(current_time),
      TimeSeconds(current_time)
  );
  string filename = "ScreenShots\\" + Symbol() +"\\ScreenShot_" + Symbol() + "_" + time_str + ".png";
  // Print("Saving chart screenshot to: ", filename);

  int width = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
  int height = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);
  bool success = ChartScreenShot(0, filename, width, height);
  if(!success)
  {
    int error = GetLastError();
    Print("Screenshot failed. Error: ", error, " - ", GetErrorDescription(error));
  }
}