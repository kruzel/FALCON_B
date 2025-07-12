//+------------------------------------------------------------------+
//|                                          Falcon EA Template v2.0
//|                                        Copyright 2015,Lucas Liew 
//|                                  lucas@blackalgotechnologies.com 
//+------------------------------------------------------------------+
#include <Falcon_B/01_GetHistoryOrder.mqh>
#include <Falcon_B/02_OrderProfitToCSV.mqh>
#include <Falcon_B/03_ReadCommandFromCSV.mqh>
#include <Falcon_B/08_TerminalNumber.mqh>

#property copyright "Copyright 2015, Black Algo Technologies Pte Ltd"
#property copyright "Copyright 2018, Vladimir Zhbanko"
#property link      "lucas@blackalgotechnologies.com"
#property link      "https://vladdsm.github.io/myblog_attempt/"
#property version   "1.001"  
#property strict
/* 

Falcon B: 
- Adding specific functions to manage Decision Support System

*/

//+------------------------------------------------------------------+
//| Setup                                               
//+------------------------------------------------------------------+
extern string  Header1="----------EA General Settings-----------";
extern int     MagicNumber                      = 8118201;
extern int     TerminalType                     = 1;         //0 mean slave, 1 mean master
extern bool    R_Management                     = true;      //R_Management true will enable Decision Support Centre (using R)
extern int     Slippage                         = 3; // In Pips
extern bool    IsECNbroker                      = false; // Is your broker an ECN
extern bool    VerboseJournaling                = true; // Add EA updates in the Journal Tab

extern string  Header2="----------Trading Rules Variables-----------";
extern int     PipFinite_Period                 = 3;       // PipFinite Trend PRO Period
extern double  PipFinite_TargetFactor           = 2.0;     // PipFinite Trend PRO Target Factor
extern int     PipFinite_MaxHistoryBars         = 3000;    // PipFinite Trend PRO Maximum History Bars
extern int     PipFinite_UptrendBuffer          = 10;       // PipFinite Uptrend Buffer Number
extern int     PipFinite_DowntrendBuffer        = 11;       // PipFinite Downtrend Buffer Number

extern string  Header2b="----------ZigZag Indicator Settings-----------";
extern int     ZigZag_Depth                     = 12;      // ZigZag Depth
extern int     ZigZag_Deviation                 = 5;       // ZigZag Deviation  
extern int     ZigZag_Backstep                  = 3;       // ZigZag Backstep
extern double  SupportResistanceThreshold      = 10.0;    // Distance in pips to consider close to S/R level

extern string  Header2c="----------Retracement Trading Settings-----------";
extern bool    UseRetracementEntry              = true;    // Enable retracement-based entry signals
extern double  MinRetracementPips               = 5.0;     // Minimum retracement distance in pips
extern double  RetracementEndThreshold          = 3.0;     // Pips threshold to confirm retracement has ended

extern string  Header2d="----------Support/Resistance Breakout Settings-----------";
extern bool    UseSRBreakoutEntry               = true;    // Enable support/resistance breakout entry signals
extern int     SRLookbackPeriod                 = 50;     // Number of bars to look back for S/R levels
extern double  SRBreakoutBuffer                 = 2.0;     // Buffer in pips to confirm breakout
extern int     MaxSRLevels                      = 10;     // Maximum number of S/R levels to track

extern string  Header3="----------Position Sizing Settings-----------";
extern string  Lot_explanation                  = "If IsSizingOn = true, Lots variable will be ignored";
extern double  Lots                             = 0.01;
extern bool    IsSizingOn                       = False;
extern double  Risk                             = 1; // Risk per trade (in percentage)
extern int     MaxPositionsAllowed              = 1;

extern string  Header4="----------TP & SL Settings-----------";
extern bool    UseFixedStopLoss                 = True; // If this is false and IsSizingOn = True, sizing algo will not be able to calculate correct lot size. 
extern double  FixedStopLoss                    = 0; // Hard Stop in Pips. Will be overridden if vol-based SL is true 
extern bool    IsVolatilityStopOn               = True;
extern double  VolBasedSLMultiplier             = 3; // Stop Loss Amount in units of Volatility

extern bool    UseFixedTakeProfit               = True;
extern double  FixedTakeProfit                  = 0; // Hard Take Profit in Pips. Will be overridden if vol-based TP is true 
extern bool    IsVolatilityTakeProfitOn         = True;
extern double  VolBasedTPMultiplier             = 6; // Take Profit Amount in units of Volatility

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
extern double  TrailingStopDistance             = 0; // In pips
extern double  TrailingStopBuffer               = 0; // In pips

extern string  Header9="----------Hidden Trailing Stops Settings-----------";
extern bool    UseHiddenTrailingStops           = False;
extern double  TrailingStopDistance_Hidden      = 0; // In pips
extern double  TrailingStopBuffer_Hidden        = 0; // In pips

extern string  Header10="----------Volatility Trailing Stops Settings-----------";
extern bool    UseVolTrailingStops              = False;
extern double  VolTrailingDistMultiplier        = 0; // In units of ATR
extern double  VolTrailingBuffMultiplier        = 0; // In units of ATR

extern string  Header11="----------Hidden Volatility Trailing Stops Settings-----------";
extern bool    UseHiddenVolTrailing             = False;
extern double  VolTrailingDistMultiplier_Hidden = 0; // In units of ATR
extern double  VolTrailingBuffMultiplier_Hidden = 0; // In units of ATR

extern string  Header12="----------Volatility Measurement Settings-----------";
extern int     atr_period                       = 14;

extern string  Header13="----------Set Max Loss Limit-----------";
extern bool    IsLossLimitActivated             = False;
extern double  LossLimitPercent                 = 50;

extern string  Header14="----------Set Max Volatility Limit-----------";
extern bool    IsVolLimitActivated              = False;
extern double  VolatilityMultiplier             = 3; // In units of ATR
extern int     ATRTimeframe                     = 60; // In minutes
extern int     ATRPeriod                        = 14;


string  InternalHeader1="----------Errors Handling Settings-----------";
int     RetryInterval                           = 100; // Pause Time before next retry (in milliseconds)
int     MaxRetriesPerTick                       = 10;

string  InternalHeader2="----------Service Variables-----------";

double Stop,Take;
double StopHidden,TakeHidden;
int YenPairAdjustFactor;
int    P;
double myATR;
double Price1;

// TDL 3: Declaring Variables (and the extern variables above)

double PipFiniteUptrendSignal1, PipFiniteDowntrendSignal1;
int CrossTriggered;

// ZigZag Variables
double ZigZagHighs, ZigZagLows;

// Retracement Variables
double LastZigZagPeak = 0;          // Last confirmed ZigZag peak (high or low)
int LastPeakType = 0;               // 1 = High peak, -1 = Low peak, 0 = None
bool InRetracement = false;         // Currently in a retracement phase
double RetracementStart = 0;        // Price where retracement started
double RetracementExtreme = 0;      // Most extreme price during retracement
int RetracementDirection = 0;       // 1 = retracing down from high, -1 = retracing up from low

// Support/Resistance Variables
double SRLevels[];                  // Array to store S/R levels
int SRTypes[];                      // Array to store S/R types: 1=resistance, -1=support
int SRStrength[];                   // Array to store S/R strength (number of touches)
int CurrentSRCount = 0;             // Current number of S/R levels tracked

// Crossing state arrays for multiple line detection (for enhanced Crossed function)
int CrossCurrentDirection[];        // Current direction for each line being tracked
int CrossLastDirection[];          // Last direction for each line being tracked  
bool CrossFirstTime[];             // First time flag for each line being tracked
int MaxCrossLines = 20;            // Maximum number of lines that can be tracked simultaneously

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

//+------------------------------------------------------------------+
//| End of Setup                                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert Initialization                                    
//+------------------------------------------------------------------+
int init()
  {
   
//------------- Decision Support Centre
// Write file to the sandbox if it's does not exist
//    
   ReferenceTime = TimeCurrent(); // record time for order history function
   
   // Check if terminal.csv file exists
   int testHandle = FileOpen("terminal.csv", FILE_READ);
   if(testHandle == -1)
     {
      if(VerboseJournaling) Print("terminal.csv file does not exist, creating it...");
      // Create the file
      testHandle = FileOpen("terminal.csv", FILE_WRITE|FILE_CSV);
      if(testHandle != -1)
        {
         FileWrite(testHandle, "1");
         FileClose(testHandle);
         if(VerboseJournaling) Print("terminal.csv file created successfully");
        }
      else
        {
         if(VerboseJournaling) Print("Failed to create terminal.csv file");
        }
     }
   else
     {
      FileClose(testHandle);
      if(VerboseJournaling) Print("terminal.csv file exists and is accessible");
     }
   
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
            
//---------             
   
   P=GetP(); // To account for 5 digit brokers. Used to convert pips to decimal place
   YenPairAdjustFactor=GetYenAdjustFactor(); // Adjust for YenPair

//----------(Hidden) TP, SL and Breakeven Stops Variables-----------  

// If EA disconnects abruptly and there are open positions from this EA, records form these arrays will be gone.
   if(UseHiddenStopLoss) ArrayResize(HiddenSLList,MaxPositionsAllowed,0);
   if(UseHiddenTakeProfit) ArrayResize(HiddenTPList,MaxPositionsAllowed,0);
   if(UseHiddenBreakevenStops) ArrayResize(HiddenBEList,MaxPositionsAllowed,0);
   if(UseHiddenTrailingStops) ArrayResize(HiddenTrailingList,MaxPositionsAllowed,0);
   if(UseVolTrailingStops) ArrayResize(VolTrailingList,MaxPositionsAllowed,0);
   if(UseHiddenVolTrailing) ArrayResize(HiddenVolTrailingList,MaxPositionsAllowed,0);

//----------Support/Resistance and Crossing Arrays Initialization-----------
   if(UseSRBreakoutEntry) 
     {
      ArrayResize(SRLevels, MaxSRLevels, 0);
      ArrayResize(SRTypes, MaxSRLevels, 0);
      ArrayResize(SRStrength, MaxSRLevels, 0);
     }
   
   // Initialize crossing state arrays for multiple line tracking
   ArrayResize(CrossCurrentDirection, MaxCrossLines, 0);
   ArrayResize(CrossLastDirection, MaxCrossLines, 0);
   ArrayResize(CrossFirstTime, MaxCrossLines, 0);
   
   // Initialize all crossing states
   for(int i = 0; i < MaxCrossLines; i++)
     {
      CrossCurrentDirection[i] = 0;
      CrossLastDirection[i] = 0;
      CrossFirstTime[i] = true;
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
  
//----------Order management through R - to avoid slow down the system only enable with external parameters
   if(R_Management)
     {
         //code that only executed once a bar
      //   Direction = -1; //set direction to -1 by default in order to achieve cross!
         int terminalNum = T_Num();
        //  if(VerboseJournaling) Print("Terminal Number retrieved: " + string(terminalNum));
         OrderProfitToCSV(terminalNum);                        //write previous orders profit results for auto analysis in R
         TradeAllowed = ReadCommandFromCSV(MagicNumber);              //read command from R to make sure trading is allowed
      //   Direction = ReadAutoPrediction(MagicNumber, -1);             //get prediction from R for trade direction         
        
       
     }
//----------Variables to be Refreshed-----------

   OrderNumber=0; // OrderNumber used in Entry Rules

//----------Entry & Exit Variables-----------

   // TDL 1: Assigning Values to Variables
   
   // Calculate entry/exit signals only at the beginning of a new bar
   static datetime lastSignalBarTime = 0;
   datetime currentBarTime = Time[1]; // Use previous completed bar
   
   // Only calculate signals once per new bar
   if(currentBarTime != lastSignalBarTime)
   {
      // Get PipFinite indicator values with proper parameters
      PipFiniteUptrendSignal1 = iCustom(NULL, 0, "Market\\PipFinite Trend PRO", PipFinite_UptrendBuffer, 1); // Buffer for Uptrend, Shift 1
      PipFiniteDowntrendSignal1 = iCustom(NULL, 0, "Market\\PipFinite Trend PRO", PipFinite_DowntrendBuffer, 1); // Buffer for Downtrend, Shift 1
      
      // Get ZigZag indicator values directly from buffers
      ZigZagHighs = iCustom(NULL, 0, "ZigZag", ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep, 1, 1); // Buffer 1 for Highs
      ZigZagLows = iCustom(NULL, 0, "ZigZag", ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep, 2, 1);  // Buffer 2 for Lows
      
      // Calculate entry signals using Close[2] and Close[1] for crossing logic
      // Use main trend line - choose uptrend or downtrend based on which has valid data
      double pipFiniteLine = EMPTY_VALUE;
      if (PipFiniteUptrendSignal1 != EMPTY_VALUE)
         pipFiniteLine = PipFiniteUptrendSignal1;
      else if (PipFiniteDowntrendSignal1 != EMPTY_VALUE)
         pipFiniteLine = PipFiniteDowntrendSignal1;
      
      if (pipFiniteLine == EMPTY_VALUE)
         CrossTriggered = 0; // Reset CrossTriggered if no signal is available
      else
         CrossTriggered = CrossedWithId(Close[2], Close[1], pipFiniteLine, 0); // Use ID 0 for PipFinite line
      
      lastSignalBarTime = currentBarTime; // Update last signal calculation time
   }

//----------TP, SL, Breakeven and Trailing Stops Variables-----------

   myATR=iATR(NULL,Period(),atr_period,1);

   if(UseFixedStopLoss==False) 
     {
      Stop=0;
        }  else {
      Stop=VolBasedStopLoss(IsVolatilityStopOn,FixedStopLoss,myATR,VolBasedSLMultiplier,P);
     }

   if(UseFixedTakeProfit==False) 
     {
      Take=0;
        }  else {
      Take=VolBasedTakeProfit(IsVolatilityTakeProfitOn,FixedTakeProfit,myATR,VolBasedTPMultiplier,P);
     }

   if(UseBreakevenStops) BreakevenStopAll(VerboseJournaling,RetryInterval,BreakevenBuffer,MagicNumber,P);
   if(UseTrailingStops) TrailingStopAll(VerboseJournaling,TrailingStopDistance,TrailingStopBuffer,RetryInterval,MagicNumber,P);
   if(UseVolTrailingStops) {
      UpdateVolTrailingList(VerboseJournaling,RetryInterval,MagicNumber);
      ReviewVolTrailingStop(VerboseJournaling,VolTrailingDistMultiplier,VolTrailingBuffMultiplier,RetryInterval,MagicNumber,P);
   }
//----------(Hidden) TP, SL, Breakeven and Trailing Stops Variables-----------  

   if(UseHiddenStopLoss) TriggerStopLossHidden(VerboseJournaling,RetryInterval,MagicNumber,Slippage,P);
   if(UseHiddenTakeProfit) TriggerTakeProfitHidden(VerboseJournaling,RetryInterval,MagicNumber,Slippage,P);
   if(UseHiddenBreakevenStops) { 
      UpdateHiddenBEList(VerboseJournaling,RetryInterval,MagicNumber);
      SetAndTriggerBEHidden(VerboseJournaling,BreakevenBuffer,MagicNumber,Slippage,P,RetryInterval);
   }
   if(UseHiddenTrailingStops) {
      UpdateHiddenTrailingList(VerboseJournaling,RetryInterval,MagicNumber);
      SetAndTriggerHiddenTrailing(VerboseJournaling,TrailingStopDistance_Hidden,TrailingStopBuffer_Hidden,Slippage,RetryInterval,MagicNumber,P);
   }
   if(UseHiddenVolTrailing) {
      UpdateHiddenVolTrailingList(VerboseJournaling,RetryInterval,MagicNumber);
      TriggerAndReviewHiddenVolTrailing(VerboseJournaling,VolTrailingDistMultiplier_Hidden,VolTrailingBuffMultiplier_Hidden,Slippage,RetryInterval,MagicNumber,P);
   }

//----------Exit Rules (All Opened Positions)-----------

   // TDL 2: Setting up Exit rules. Modify the ExitSignal() function to suit your needs.

   int exitSignal = ExitSignal(CrossTriggered);
   
   if(CountPosOrders(MagicNumber,OP_BUY)>=1 && exitSignal==2)
     { // Close Long Positions
      if(VerboseJournaling) 
        {
         int buyPositions = CountPosOrders(MagicNumber,OP_BUY);
         Print("Closing " + string(buyPositions) + " BUY position(s) due to exit signal");
        }
      CloseOrderPosition(OP_BUY, VerboseJournaling, MagicNumber, Slippage, P, RetryInterval); 
     }
     
   if(CountPosOrders(MagicNumber,OP_SELL)>=1 && exitSignal==1)
     { // Close Short Positions
      if(VerboseJournaling) 
        {
         int sellPositions = CountPosOrders(MagicNumber,OP_SELL);
         Print("Closing " + string(sellPositions) + " SELL position(s) due to exit signal");
        }
      CloseOrderPosition(OP_SELL, VerboseJournaling, MagicNumber, Slippage, P, RetryInterval);
     }

//----------Entry Rules (Market and Pending) -----------

   if(IsLossLimitBreached(IsLossLimitActivated,LossLimitPercent,VerboseJournaling,EntrySignal(CrossTriggered))==False) 
      if(IsVolLimitBreached(IsVolLimitActivated,VolatilityMultiplier,ATRTimeframe,ATRPeriod)==False)
         if(IsMaxPositionsReached(MaxPositionsAllowed,MagicNumber,VerboseJournaling)==False)
           {
            if(TradeAllowed && EntrySignal(CrossTriggered)==1)
              { // Open Long Positions based on PipFinite Buy signal
               OrderNumber=OpenPositionMarket(OP_BUY,GetLot(IsSizingOn,Lots,Risk,YenPairAdjustFactor,Stop,P),Stop,Take,MagicNumber,Slippage,VerboseJournaling,P,IsECNbroker,MaxRetriesPerTick,RetryInterval);
   
               // Set Stop Loss value for Hidden SL
               if(UseHiddenStopLoss) SetStopLossHidden(VerboseJournaling,IsVolatilityStopLossOn_Hidden,FixedStopLoss_Hidden,myATR,VolBasedSLMultiplier_Hidden,P,OrderNumber);
   
               // Set Take Profit value for Hidden TP
               if(UseHiddenTakeProfit) SetTakeProfitHidden(VerboseJournaling,IsVolatilityTakeProfitOn_Hidden,FixedTakeProfit_Hidden,myATR,VolBasedTPMultiplier_Hidden,P,OrderNumber);
               
               // Set Volatility Trailing Stop Level           
               if(UseVolTrailingStops) SetVolTrailingStop(VerboseJournaling,RetryInterval,myATR,VolTrailingDistMultiplier,MagicNumber,P,OrderNumber);
               
               // Set Hidden Volatility Trailing Stop Level 
               if(UseHiddenVolTrailing) SetHiddenVolTrailing(VerboseJournaling,myATR,VolTrailingDistMultiplier_Hidden,MagicNumber,P,OrderNumber);
             
              }
   
            if(TradeAllowed && EntrySignal(CrossTriggered)==2)
              { // Open Short Positions based on PipFinite Sell signal
               OrderNumber=OpenPositionMarket(OP_SELL,GetLot(IsSizingOn,Lots,Risk,YenPairAdjustFactor,Stop,P),Stop,Take,MagicNumber,Slippage,VerboseJournaling,P,IsECNbroker,MaxRetriesPerTick,RetryInterval);
   
               // Set Stop Loss value for Hidden SL
               if(UseHiddenStopLoss) SetStopLossHidden(VerboseJournaling,IsVolatilityStopLossOn_Hidden,FixedStopLoss_Hidden,myATR,VolBasedSLMultiplier_Hidden,P,OrderNumber);
   
               // Set Take Profit value for Hidden TP
               if(UseHiddenTakeProfit) SetTakeProfitHidden(VerboseJournaling,IsVolatilityTakeProfitOn_Hidden,FixedTakeProfit_Hidden,myATR,VolBasedTPMultiplier_Hidden,P,OrderNumber);
               
               // Set Volatility Trailing Stop Level 
               if(UseVolTrailingStops) SetVolTrailingStop(VerboseJournaling,RetryInterval,myATR,VolTrailingDistMultiplier,MagicNumber,P,OrderNumber);
                
               // Set Hidden Volatility Trailing Stop Level  
               if(UseHiddenVolTrailing) SetHiddenVolTrailing(VerboseJournaling,myATR,VolTrailingDistMultiplier_Hidden,MagicNumber,P,OrderNumber);
             
              }
           }

//----------Pending Order Management-----------
/*
        Not Applicable (See Desiree for example of pending order rules).
   */

//----------Display ZigZag Information-----------
  //  if(VerboseJournaling)
  //    {
  //     DisplayZigZagInfo(); // Show current ZigZag support/resistance analysis
  //     DisplayRetracementInfo(); // Show current retracement status
  //    }

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
1) DetectRetracementSignal
2) EntrySignal
3) ExitSignal
4) GetLot
5) CheckLot
6) CountPosOrders
7) IsMaxPositionsReached
8) OpenPositionMarket
9) OpenPositionPending
10) CloseOrderPosition
11) GetP
12) GetYenAdjustFactor
13) VolBasedStopLoss
14) VolBasedTakeProfit
15) Crossed1 / Crossed2
16) IsLossLimitBreached
17) IsVolLimitBreached
18) SetStopLossHidden
19) TriggerStopLossHidden
20) SetTakeProfitHidden
21) TriggerTakeProfitHidden
22) BreakevenStopAll
23) UpdateHiddenBEList
24) SetAndTriggerBEHidden
25) TrailingStopAll
26) UpdateHiddenTrailingList
27) SetAndTriggerHiddenTrailing
28) UpdateVolTrailingList
29) SetVolTrailingStop
30) ReviewVolTrailingStop
31) UpdateHiddenVolTrailingList
32) SetHiddenVolTrailing
33) TriggerAndReviewHiddenVolTrailing
34) HandleTradingEnvironment
35) GetErrorDescription
36) DisplayZigZagInfo
37) DisplayRetracementInfo
38) CrossedWithId
39) DetectSupportResistanceLevels
40) DetectSRBreakoutSignal
41) DisplaySRInfo

*/


//+------------------------------------------------------------------+
//| RETRACEMENT DETECTION                                            |
//+------------------------------------------------------------------+
int DetectRetracementSignal()
  {
// This function detects retracement patterns and generates entry signals
// Returns: 0=no signal, 1=buy signal after retracement, 2=sell signal after retracement

   int retracementSignal = 0;
   
   // Skip retracement detection if disabled
   if(!UseRetracementEntry) return(0);
   
   double currentPrice = Close[1];
   
   // Get latest ZigZag peaks
   double latestHigh = 0, latestLow = 0;
   int highShift = -1, lowShift = -1;
   
   // Find the most recent ZigZag high and low
   for(int i = 1; i <= 50; i++)
     {
      double zzHigh = iCustom(NULL, 0, "ZigZag", ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep, 1, i);
      double zzLow = iCustom(NULL, 0, "ZigZag", ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep, 2, i);
      
      if(zzHigh != EMPTY_VALUE && zzHigh > 0 && latestHigh == 0)
        {
         latestHigh = zzHigh;
         highShift = i;
        }
      if(zzLow != EMPTY_VALUE && zzLow > 0 && latestLow == 0)
        {
         latestLow = zzLow;
         lowShift = i;
        }
      if(latestHigh > 0 && latestLow > 0) break;
     }
   
   // Determine which peak is more recent
   double recentPeak = 0;
   int recentPeakType = 0;
   
   if(highShift > 0 && lowShift > 0)
     {
      if(highShift < lowShift) // High is more recent
        {
         recentPeak = latestHigh;
         recentPeakType = 1; // High peak
        }
      else // Low is more recent
        {
         recentPeak = latestLow;
         recentPeakType = -1; // Low peak
        }
     }
   else if(highShift > 0)
     {
      recentPeak = latestHigh;
      recentPeakType = 1;
     }
   else if(lowShift > 0)
     {
      recentPeak = latestLow;
      recentPeakType = -1;
     }
   
   // Check if we have a new peak
   if(recentPeak != LastZigZagPeak && recentPeak > 0)
     {
      LastZigZagPeak = recentPeak;
      LastPeakType = recentPeakType;
      InRetracement = false;
      RetracementStart = 0;
      RetracementExtreme = 0;
      RetracementDirection = 0;
      
      if(VerboseJournaling) 
        {
         string peakTypeStr = (recentPeakType == 1) ? "HIGH" : "LOW";
         Print("New ZigZag " + peakTypeStr + " peak detected at " + DoubleToString(recentPeak, Digits));
        }
     }
   
   // Retracement detection logic
   if(LastZigZagPeak > 0 && LastPeakType != 0)
     {
      double retracementDistance = 0;
      
      if(!InRetracement)
        {
         // Check if retracement is starting
         if(LastPeakType == 1) // After high peak, look for downward retracement
           {
            if(currentPrice < LastZigZagPeak - MinRetracementPips * Point * P)
              {
               InRetracement = true;
               RetracementStart = LastZigZagPeak;
               RetracementExtreme = currentPrice;
               RetracementDirection = -1; // Retracing down
               
               if(VerboseJournaling) 
                 Print("Retracement started - DOWN from high at " + DoubleToString(LastZigZagPeak, Digits));
              }
           }
         else if(LastPeakType == -1) // After low peak, look for upward retracement
           {
            if(currentPrice > LastZigZagPeak + MinRetracementPips * Point * P)
              {
               InRetracement = true;
               RetracementStart = LastZigZagPeak;
               RetracementExtreme = currentPrice;
               RetracementDirection = 1; // Retracing up
               
               if(VerboseJournaling) 
                 Print("Retracement started - UP from low at " + DoubleToString(LastZigZagPeak, Digits));
              }
           }
        }
      else
        {
         // We are in retracement, track the extreme and check for end
         if(RetracementDirection == -1) // Retracing down from high
           {
            if(currentPrice < RetracementExtreme)
              {
               RetracementExtreme = currentPrice; // New low during retracement
              }
            else if(currentPrice > RetracementExtreme + RetracementEndThreshold * Point * P)
              {
               // Retracement ended, price moving back up - BUY SIGNAL
               InRetracement = false;
               retracementSignal = 1;
               
               if(VerboseJournaling) 
                 {
                  double retracementPips = (RetracementStart - RetracementExtreme) / (Point * P);
                  Print("Retracement ended - BUY SIGNAL after " + DoubleToString(retracementPips, 1) + " pip retracement");
                 }
              }
           }
         else if(RetracementDirection == 1) // Retracing up from low
           {
            if(currentPrice > RetracementExtreme)
              {
               RetracementExtreme = currentPrice; // New high during retracement
              }
            else if(currentPrice < RetracementExtreme - RetracementEndThreshold * Point * P)
              {
               // Retracement ended, price moving back down - SELL SIGNAL
               InRetracement = false;
               retracementSignal = 2;
               
               if(VerboseJournaling) 
                 {
                  double retracementPips = (RetracementExtreme - RetracementStart) / (Point * P);
                  Print("Retracement ended - SELL SIGNAL after " + DoubleToString(retracementPips, 1) + " pip retracement");
                 }
              }
           }
        }
     }
   
   return(retracementSignal);
  }
//+------------------------------------------------------------------+
//| End of RETRACEMENT DETECTION                                     |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| ENTRY SIGNAL                                                     |
//+------------------------------------------------------------------+
int EntrySignal(int CrossOccurred)
  {
// Type: Customisable 
// Modify this function to suit your trading robot

// This function checks for entry signals

   int   entryOutput=0;

   // Original PipFinite crossing signals
   if(CrossOccurred==1)
     {
      entryOutput=1; 
      if(VerboseJournaling) Print("Entry Signal - PipFinite BUY cross detected");
     }

   if(CrossOccurred==2)
     {
      entryOutput=2;
      if(VerboseJournaling) Print("Entry Signal - PipFinite SELL cross detected");
     }

   // Check for retracement-based entry signals
   int retracementSignal = DetectRetracementSignal();
   
   if(retracementSignal == 1) // Buy signal after retracement
     {
      entryOutput = 1;
      if(VerboseJournaling) Print("Entry Signal - BUY after retracement completion");
     }
   else if(retracementSignal == 2) // Sell signal after retracement
     {
      entryOutput = 2;
      if(VerboseJournaling) Print("Entry Signal - SELL after retracement completion");
     }

   // Check for support/resistance breakout signals
   int srBreakoutSignal = DetectSRBreakoutSignal();
   
   if(srBreakoutSignal == 1) // Buy signal from resistance breakout
     {
      entryOutput = 1;
      if(VerboseJournaling) Print("Entry Signal - BUY from resistance breakout");
     }
   else if(srBreakoutSignal == 2) // Sell signal from support breakout
     {
      entryOutput = 2;
      if(VerboseJournaling) Print("Entry Signal - SELL from support breakout");
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
   string exitReason = "";

   if(CrossOccurred==1)
     {
      ExitOutput=1;
      exitReason = "PipFinite Buy Signal (Exit Sell Positions)";
     }

   if(CrossOccurred==2)
     {
      ExitOutput=2;
      exitReason = "PipFinite Sell Signal (Exit Buy Positions)";
     }

   // Check if current price is near support/resistance levels
   bool nearSupportResistance = IsPriceNearSupportResistance(Bid, SupportResistanceThreshold);
   
   if(nearSupportResistance)
     {
      // If we have long positions and price is near resistance, signal exit
      if(CountPosOrders(MagicNumber,OP_BUY) > 0)
        {
         double nearestResistance = GetNearestResistanceLevel(Bid);
         if(nearestResistance > 0 && MathAbs(Bid - nearestResistance) <= SupportResistanceThreshold * Point * P)
           {
            ExitOutput = 2; // Exit long positions
            exitReason = "Price Near Resistance Level at " + DoubleToString(nearestResistance, Digits) + " (Distance: " + DoubleToString(MathAbs(Bid - nearestResistance) / (Point * P), 1) + " pips)";
            if(VerboseJournaling) Print("Exit signal - BUY position near resistance at " + DoubleToString(nearestResistance, Digits));
           }
        }
      
      // If we have short positions and price is near support, signal exit
      if(CountPosOrders(MagicNumber,OP_SELL) > 0)
        {
         double nearestSupport = GetNearestSupportLevel(Bid);
         if(nearestSupport > 0 && MathAbs(Bid - nearestSupport) <= SupportResistanceThreshold * Point * P)
           {
            ExitOutput = 1; // Exit short positions
            exitReason = "Price Near Support Level at " + DoubleToString(nearestSupport, Digits) + " (Distance: " + DoubleToString(MathAbs(Bid - nearestSupport) / (Point * P), 1) + " pips)";
            if(VerboseJournaling) Print("Exit signal - SELL position near support at " + DoubleToString(nearestSupport, Digits));
           }
        }
     }

   // Log the exit reason if VerboseJournaling is enabled and there's an exit signal
   if(VerboseJournaling && ExitOutput != 0)
     {
      Print("Exit Signal Generated - Reason: " + exitReason);
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

double GetLot(bool IsSizingOnTrigger,double FixedLots,double RiskPerTrade,int YenAdjustment,double STOP,int K) 
  {

   double output;

   if(IsSizingOnTrigger==true) 
     {
      output=RiskPerTrade*0.01*AccountBalance()/(MarketInfo(Symbol(),MODE_LOTSIZE)*MarketInfo(Symbol(),MODE_TICKVALUE)*STOP*K*Point); // Sizing Algo based on account size
      output=output*YenAdjustment; // Adjust for Yen Pairs
        } else {
      output=FixedLots;
     }
   output=NormalizeDouble(output,2); // Round to 2 decimal place
   return(output);
  }
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

   if(Journaling && LotToOpen!=Lot)Print("Trading Lot has been changed by CheckLot function. Requested lot: "+(string)Lot+". Lot to open: "+(string)LotToOpen);

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

   int result=False;
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
   double volume=CheckLot(LOT,Journaling);
   if(MarketInfo(symbol,MODE_MARGINREQUIRED)*volume>AccountFreeMargin())
     {
      if(Journaling) Print("Can not open a trade. Not enough free margin to open "+(string)volume+" on "+symbol);
      return(-1);
     }
   int slippage=Slip*K; // Slippage is in points. 1 point = 0.0001 on 4 digit broker and 0.00001 on a 5 digit broker
   string comment=" "+(string)TYPE+"(#"+(string)Magic+")";
   int magic=Magic;
   datetime expiration=0;
   color arrow_color=0;if(TYPE==OP_BUY)arrow_color=Blue;if(TYPE==OP_SELL)arrow_color=Green;
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
               if(Journaling && !ModifyOpen)Print("Take Profit and Stop Loss not set for Ticket " + string(Ticket) + ". Error Description: "+GetErrorDescription(GetLastError()));
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
   double volume=CheckLot(LOT,Journaling);
   if(MarketInfo(symbol,MODE_MARGINREQUIRED)*volume>AccountFreeMargin())
     {
      if(Journaling) Print("Can not open a trade. Not enough free margin to open "+(string)volume+" on "+symbol);
      return(-1);
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
            
            // Log detailed trade information before closing
            if(Journaling) 
              {
               double profit = OrderProfit() + OrderSwap() + OrderCommission();
               string tradeType = (TYPE==OP_BUY) ? "BUY" : "SELL";
               Print("Closing " + tradeType + " position - Ticket: " + string(OrderTicket()) + 
                     ", Lots: " + DoubleToString(OrderLots(),2) + 
                     ", Open Price: " + DoubleToString(OrderOpenPrice(), Digits) + 
                     ", Current Price: " + DoubleToString((TYPE==OP_BUY) ? Bid : Ask, Digits) + 
                     ", Profit: " + DoubleToString(profit, 2) + " " + AccountCurrency());
               Print("Trying to close position " + string(OrderTicket()) + " ...");
              }
              
            HandleTradingEnvironment(Journaling,RetryInterval);
            if(TYPE==OP_BUY)Price=Bid; if(TYPE==OP_SELL)Price=Ask;
            Closing=OrderClose(OrderTicket(),OrderLots(),Price,Slip*K,arrow_color);
            if(Journaling && !Closing)Print("Unexpected Error closing order " + string(OrderTicket()) + ". Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Closing)
              {
               Print("Position " + string(OrderTicket()) + " successfully closed at " + DoubleToString(Price, Digits));
              }
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
            if(Journaling && !Delete)Print("Unexpected Error deleting order " + string(OrderTicket()) + ". Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Delete)Print("Order " + string(OrderTicket()) + " successfully deleted.");
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
int GetP() 
  {
// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function returns P, which is used for converting pips to decimals/points

   int output;
   if(Digits==5 || Digits==3) output=10;else output=1;
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
  { // K represents our P multiplier to adjust for broker digits
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
  { // K represents our P multiplier to adjust for broker digits
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
// Cross                                                            
//+------------------------------------------------------------------+

// Type: Fixed Template 
// Do not edit unless you know what you're doing

// This function determines if a cross happened between 2 lines/data set

/* 

If Output is 0: No cross happened
If Output is 1: Line 1 crossed Line 2 from Bottom
If Output is 2: Line 1 crossed Line 2 from top 

*/

int Crossed(double close2, double close1, double pipFiniteLine)
  {

   static int CurrentDirection1=0;
   static int LastDirection1=0;
   static bool FirstTime1=true;

//---- Check crossing using Close[2] and Close[1] vs PipFinite line
   if(close2>pipFiniteLine && close1<pipFiniteLine)
      CurrentDirection1=2;  // Downtrend cross: Close crossed below PipFinite line
   else if(close2<pipFiniteLine && close1>pipFiniteLine)
      CurrentDirection1=1;  // Uptrend cross: Close crossed above PipFinite line
   else
      CurrentDirection1=0;  // No cross
//----
   if(FirstTime1==true) // Need to check if this is the first time the function is run
     {
      FirstTime1=false; // Change variable to false
      LastDirection1=CurrentDirection1; // Set new direction
      return (0);
     }

   if(CurrentDirection1!=0 && CurrentDirection1!=LastDirection1 && FirstTime1==false) // If not the first time and there is a direction change
     {
      LastDirection1=CurrentDirection1; // Set new direction
      return(CurrentDirection1); // 1 for up, 2 for down
     }
   else
     {
      return(0);  // No direction change
     }
  }
//+------------------------------------------------------------------+
// End of Cross                                                      
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Is Loss Limit Breached                                       
//+------------------------------------------------------------------+
bool IsLossLimitBreached(bool LossLimitActivated,double LossLimitPercentage,bool Journaling,int EntrySignalTrigger)
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

   profitAndLoss=(AccountEquity()/initialCapital)-1;

   if(profitAndLoss<-LossLimitPercentage/100)
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
  { // K represents our P multiplier to adjust for broker digits
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
  { // K represents our P multiplier to adjust for broker digits
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
         if(OrderType()==OP_SELL && OrderOpenPrice()-(orderTP*K*Point)>=Ask) 
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
            if(Journaling && !Modify)Print("Unexpected Error modifying order " + string(OrderTicket()) + " for breakeven. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Modify)Print("Order " + string(OrderTicket()) + " successfully modified, breakeven stop updated.");
           }
         if(OrderType()==OP_SELL && (OrderOpenPrice()-Ask)>(Breakeven_Buffer*K*Point))
           {
            if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Modify=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,CLR_NONE);
            if(Journaling && !Modify)Print("Unexpected Error modifying order " + string(OrderTicket()) + " for breakeven. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Modify)Print("Order " + string(OrderTicket()) + " successfully modified, breakeven stop updated.");
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
  { // K represents our P multiplier to adjust for broker digits
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
            if((OrderType()==OP_BUY && (Bid-OrderOpenPrice())>(Breakeven_Buffer*P*Point)) || (OrderType()==OP_SELL && (OrderOpenPrice()-Ask)>(Breakeven_Buffer*P*Point)))
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
            if(Journaling && !Modify)Print("Unexpected Error modifying order " + string(OrderTicket()) + " for trailing stop. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Modify)Print("Order " + string(OrderTicket()) + " successfully modified, trailing stop changed.");
           }
         if(OrderType()==OP_SELL && ((OrderStopLoss()-Ask>((TrailingStopDist+TrailingStopBuff)*K*Point)) || (OrderStopLoss()==0)))
           {
            if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
            HandleTradingEnvironment(Journaling,Retry_Interval);
            Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TrailingStopDist*K*Point,OrderTakeProfit(),0,CLR_NONE);
            if(Journaling && !Modify)Print("Unexpected Error modifying order " + string(OrderTicket()) + " for trailing stop. Error Description: "+GetErrorDescription(GetLastError()));
            if(Journaling && Modify)Print("Order " + string(OrderTicket()) + " successfully modified, trailing stop changed.");
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| End Trailing Stop
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

               doesHiddenTrailingRecordExist = True; 
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
               if(OrderType()==OP_BUY && (Bid-OrderStopLoss()>(VolTrailingDistMulti*VolTrailingList[x,1]+VolTrailingBuffMulti*VolTrailingList[x,1])*K*Point))
                 {
                  if(Journaling)Print("Trying to modify order "+(string)OrderTicket()+" ...");
                  HandleTradingEnvironment(Journaling,Retry_Interval);
                  Modify=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-VolTrailingDistMulti*VolTrailingList[x,1]*K*Point,OrderTakeProfit(),0,CLR_NONE);
                  if(Journaling && !Modify)Print("Unexpected Error has happened. Error Description: "+GetErrorDescription(GetLastError()));
                  if(Journaling && Modify)Print("Order successfully modified, volatility trailing stop changed.");
                 }
               if(OrderType()==OP_SELL && ((OrderStopLoss()-Ask>((VolTrailingDistMulti*VolTrailingList[x,1]+VolTrailingBuffMulti*VolTrailingList[x,1])*K*Point)) || (OrderStopLoss()==0)))
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

   double VolTrailingStopLevel;
   double VolTrailingStopDist;

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
//+------------------------------------------------------------------+
//| HANDLE TRADING ENVIRONMENT                                       
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
//| GET ZIGZAG HIGH VALUE                                            
//+------------------------------------------------------------------+
double GetZigZagHigh(int shift)
  {
// Helper function to get ZigZag high value at specific shift
   return(iCustom(NULL, 0, "ZigZag", ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep, 1, shift));
  }
//+------------------------------------------------------------------+
//| End of GET ZIGZAG HIGH VALUE                                     
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| GET ZIGZAG LOW VALUE                                             
//+------------------------------------------------------------------+
double GetZigZagLow(int shift)
  {
// Helper function to get ZigZag low value at specific shift
   return(iCustom(NULL, 0, "ZigZag", ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep, 2, shift));
  }
//+------------------------------------------------------------------+
//| End of GET ZIGZAG LOW VALUE                                      
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| GET NEAREST SUPPORT LEVEL                                        
//+------------------------------------------------------------------+
double GetNearestSupportLevel(double currentPrice)
  {
// This function returns the nearest support level below the current price
// Uses ZigZag indicator buffer 2 (lows) directly

   double nearestSupport = 0;
   double minDistance = 999999;
   
   // Look through recent ZigZag low points
   for(int i = 1; i < 500; i++) // Check last 500 bars
     {
      double zigZagLow = GetZigZagLow(i);
      
      if(zigZagLow != EMPTY_VALUE && zigZagLow != 0 && zigZagLow < currentPrice)
        {
         double distance = currentPrice - zigZagLow;
         if(distance < minDistance)
           {
            minDistance = distance;
            nearestSupport = zigZagLow;
           }
        }
     }
   
   return(nearestSupport);
  }
//+------------------------------------------------------------------+
//| End of GET NEAREST SUPPORT LEVEL                                 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| GET NEAREST RESISTANCE LEVEL                                     
//+------------------------------------------------------------------+
double GetNearestResistanceLevel(double currentPrice)
  {
// This function returns the nearest resistance level above the current price
// Uses ZigZag indicator buffer 1 (highs) directly

   double nearestResistance = 0;
   double minDistance = 999999;
   
   // Look through recent ZigZag high points
   for(int i = 1; i < 500; i++) // Check last 500 bars
     {
      double zigZagHigh = GetZigZagHigh(i);
      
      if(zigZagHigh != EMPTY_VALUE && zigZagHigh != 0 && zigZagHigh > currentPrice)
        {
         double distance = zigZagHigh - currentPrice;
         if(distance < minDistance)
           {
            minDistance = distance;
            nearestResistance = zigZagHigh;
           }
        }
     }
   
   return(nearestResistance);
  }
//+------------------------------------------------------------------+
//| End of GET NEAREST RESISTANCE LEVEL                              
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| IS PRICE NEAR SUPPORT RESISTANCE                                 
//+------------------------------------------------------------------+
bool IsPriceNearSupportResistance(double price, double threshold)
  {
// This function checks if the price is near any support or resistance level
// Uses ZigZag indicator buffers directly

   // Check recent ZigZag support levels (lows)
   for(int i = 1; i < 100; i++) // Check last 100 bars
     {
      double zigZagLow = GetZigZagLow(i);
      
      if(zigZagLow != EMPTY_VALUE && zigZagLow != 0)
        {
         if(MathAbs(price - zigZagLow) <= threshold * Point * P)
           {
            return(true);
           }
        }
     }
   
   // Check recent ZigZag resistance levels (highs)
   for(int i = 1; i < 100; i++) // Check last 100 bars
     {
      double zigZagHigh = GetZigZagHigh(i);
      
      if(zigZagHigh != EMPTY_VALUE && zigZagHigh != 0)
        {
         if(MathAbs(price - zigZagHigh) <= threshold * Point * P)
           {
            return(true);
           }
        }
     }
   
   return(false);
  }
//+------------------------------------------------------------------+
//| End of IS PRICE NEAR SUPPORT RESISTANCE                          
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| DISPLAY ZIGZAG SUPPORT RESISTANCE INFO                          
//+------------------------------------------------------------------+
void DisplayZigZagInfo()
  {
// This function displays current ZigZag support and resistance levels information

   string info = "\n=== ZigZag Support/Resistance Analysis ===\n";
   
   // Show current ZigZag values
   info += "Current ZigZag High: " + (ZigZagHighs != EMPTY_VALUE && ZigZagHighs != 0 ? DoubleToString(ZigZagHighs, Digits) : "None") + "\n";
   info += "Current ZigZag Low: " + (ZigZagLows != EMPTY_VALUE && ZigZagLows != 0 ? DoubleToString(ZigZagLows, Digits) : "None") + "\n";
   
   // Show nearest levels to current price
   double nearestSupport = GetNearestSupportLevel(Bid);
   double nearestResistance = GetNearestResistanceLevel(Bid);
   
   if(nearestSupport > 0)
      info += "Nearest Support: " + DoubleToString(nearestSupport, Digits) + " (Distance: " + DoubleToString((Bid - nearestSupport) / Point / P, 1) + " pips)\n";
   else
      info += "Nearest Support: None found\n";
      
   if(nearestResistance > 0)
      info += "Nearest Resistance: " + DoubleToString(nearestResistance, Digits) + " (Distance: " + DoubleToString((nearestResistance - Bid) / Point / P, 1) + " pips)\n";
   else
      info += "Nearest Resistance: None found\n";
   
   // Check if near S/R levels
   bool nearSR = IsPriceNearSupportResistance(Bid, SupportResistanceThreshold);
   info += "Near S/R Level: " + (nearSR ? "YES" : "NO") + "\n";
   info += "S/R Threshold: " + DoubleToString(SupportResistanceThreshold, 1) + " pips\n";
   
   Comment(info);
  }
//+------------------------------------------------------------------+
//| End of DISPLAY ZIGZAG SUPPORT RESISTANCE INFO                   
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| DISPLAY RETRACEMENT INFO                                        
//+------------------------------------------------------------------+
void DisplayRetracementInfo()
  {
// This function displays current retracement analysis information

   if(!UseRetracementEntry) return; // Skip if retracement trading disabled
   
   string info = "\n=== Retracement Analysis ===\n";
   
   // Show retracement settings
   info += "Retracement Trading: " + (UseRetracementEntry ? "ENABLED" : "DISABLED") + "\n";
   info += "Min Retracement: " + DoubleToString(MinRetracementPips, 1) + " pips\n";
   info += "End Threshold: " + DoubleToString(RetracementEndThreshold, 1) + " pips\n";
   
   // Show current retracement status
   if(LastZigZagPeak > 0)
     {
      string peakTypeStr = (LastPeakType == 1) ? "HIGH" : (LastPeakType == -1) ? "LOW" : "NONE";
      info += "Last ZigZag Peak: " + DoubleToString(LastZigZagPeak, Digits) + " (" + peakTypeStr + ")\n";
     }
   else
     {
      info += "Last ZigZag Peak: Not detected\n";
     }
   
   info += "In Retracement: " + (InRetracement ? "YES" : "NO") + "\n";
   
   if(InRetracement)
     {
      string directionStr = (RetracementDirection == 1) ? "UP (from LOW)" : (RetracementDirection == -1) ? "DOWN (from HIGH)" : "NONE";
      info += "Retracement Direction: " + directionStr + "\n";
      info += "Retracement Start: " + DoubleToString(RetracementStart, Digits) + "\n";
      info += "Retracement Extreme: " + DoubleToString(RetracementExtreme, Digits) + "\n";
      
      double currentRetracementPips = 0;
      if(RetracementDirection == -1) // Down from high
         currentRetracementPips = (RetracementStart - RetracementExtreme) / Point / P;
      else if(RetracementDirection == 1) // Up from low
         currentRetracementPips = (RetracementExtreme - RetracementStart) / Point / P;
         
      info += "Current Retracement: " + DoubleToString(currentRetracementPips, 1) + " pips\n";
     }
   
   Print("" + info);
  }
//+------------------------------------------------------------------+
//| End of DISPLAY RETRACEMENT INFO                                 
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| ENHANCED CROSS WITH ID                                          |
//+------------------------------------------------------------------+
int CrossedWithId(double close2, double close1, double line, int crossId)
  {
// Type: Fixed Template 
// Enhanced crossing function that can handle multiple lines simultaneously using arrays

// This function determines if a cross happened between 2 lines/data set for a specific ID

/* 
If Output is 0: No cross happened
If Output is 1: Price crossed line from Bottom (Bullish)
If Output is 2: Price crossed line from Top (Bearish)
*/

   if(crossId < 0 || crossId >= MaxCrossLines) return(0); // Invalid ID
   
   // Check crossing using Close[2] and Close[1] vs the provided line
   if(close2 > line && close1 < line)
      CrossCurrentDirection[crossId] = 2;  // Bearish cross: Price crossed below line
   else if(close2 < line && close1 > line)
      CrossCurrentDirection[crossId] = 1;  // Bullish cross: Price crossed above line
   else
      CrossCurrentDirection[crossId] = 0;  // No cross

   if(CrossFirstTime[crossId] == true) // Need to check if this is the first time the function is run for this ID
     {
      CrossFirstTime[crossId] = false; // Change variable to false
      CrossLastDirection[crossId] = CrossCurrentDirection[crossId]; // Set new direction
      return(0);
     }

   if(CrossCurrentDirection[crossId] != 0 && CrossCurrentDirection[crossId] != CrossLastDirection[crossId] && CrossFirstTime[crossId] == false) 
     {
      CrossLastDirection[crossId] = CrossCurrentDirection[crossId]; // Set new direction
      return(CrossCurrentDirection[crossId]); // 1 for bullish, 2 for bearish
     }
   else
     {
      return(0);  // No direction change
     }
  }
//+------------------------------------------------------------------+
//| End of ENHANCED CROSS WITH ID                                   
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| DETECT SUPPORT RESISTANCE LEVELS                                |
//+------------------------------------------------------------------+
void DetectSupportResistanceLevels()
  {
// This function detects support and resistance levels using ZigZag highs and lows

   if(!UseSRBreakoutEntry) return; // Skip if S/R breakout trading disabled
   
   CurrentSRCount = 0; // Reset current count
   
   // Clear existing S/R arrays
   ArrayInitialize(SRLevels, 0);
   ArrayInitialize(SRTypes, 0);
   ArrayInitialize(SRStrength, 0);
   
   // Look back through ZigZag points to identify S/R levels
   for(int i = 1; i <= SRLookbackPeriod && CurrentSRCount < MaxSRLevels; i++)
     {
      // Get ZigZag highs and lows at different shifts
      double zigzagHigh = iCustom(NULL, 0, "ZigZag", ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep, 1, i);
      double zigzagLow = iCustom(NULL, 0, "ZigZag", ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep, 2, i);
      
      // Check if we found a ZigZag high (resistance level)
      if(zigzagHigh != EMPTY_VALUE && zigzagHigh > 0)
        {
         bool levelExists = false;
         
         // Check if this level already exists (within threshold)
         for(int j = 0; j < CurrentSRCount; j++)
           {
            if(MathAbs(SRLevels[j] - zigzagHigh) <= SupportResistanceThreshold * Point * P)
              {
               levelExists = true;
               SRStrength[j]++; // Increase strength
               break;
              }
           }
         
         // Add new resistance level if it doesn't exist
         if(!levelExists && CurrentSRCount < MaxSRLevels)
           {
            SRLevels[CurrentSRCount] = zigzagHigh;
            SRTypes[CurrentSRCount] = 1; // Resistance
            SRStrength[CurrentSRCount] = 1;
            CurrentSRCount++;
           }
        }
      
      // Check if we found a ZigZag low (support level)
      if(zigzagLow != EMPTY_VALUE && zigzagLow > 0)
        {
         bool levelExists = false;
         
         // Check if this level already exists (within threshold)
         for(int j = 0; j < CurrentSRCount; j++)
           {
            if(MathAbs(SRLevels[j] - zigzagLow) <= SupportResistanceThreshold * Point * P)
              {
               levelExists = true;
               SRStrength[j]++; // Increase strength
               break;
              }
           }
         
         // Add new support level if it doesn't exist
         if(!levelExists && CurrentSRCount < MaxSRLevels)
           {
            SRLevels[CurrentSRCount] = zigzagLow;
            SRTypes[CurrentSRCount] = -1; // Support
            SRStrength[CurrentSRCount] = 1;
            CurrentSRCount++;
           }
        }
     }
   
  //  if(VerboseJournaling && CurrentSRCount > 0)
  //    Print("Detected " + (string)CurrentSRCount + " Support/Resistance levels");
  }
//+------------------------------------------------------------------+
//| End of DETECT SUPPORT RESISTANCE LEVELS                         
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| DETECT S/R BREAKOUT SIGNAL                                      |
//+------------------------------------------------------------------+
int DetectSRBreakoutSignal()
  {
// This function detects support and resistance breakout signals

   if(!UseSRBreakoutEntry) return(0); // Skip if S/R breakout trading disabled
   
   int breakoutSignal = 0;
   
   // Update S/R levels first
   DetectSupportResistanceLevels();
   
   if(CurrentSRCount == 0) return(0); // No S/R levels detected
   
   // Check each S/R level for breakouts
   for(int i = 0; i < CurrentSRCount; i++)
     {
      double srLevel = SRLevels[i];
      int srType = SRTypes[i];
      double breakoutThreshold = SRBreakoutBuffer * Point * P;
      
      // Use unique cross ID for each S/R level (starting from ID 10 to avoid conflicts)
      int crossId = 10 + i;
      
      // Check for breakout using the enhanced crossing function
      int crossResult = CrossedWithId(Close[2], Close[1], srLevel, crossId);
      
      if(crossResult != 0)
        {
         if(srType == 1 && crossResult == 1) // Resistance breakout (upward)
           {
            // Confirm breakout with buffer
            if(Close[1] > srLevel + breakoutThreshold)
              {
               breakoutSignal = 1; // Buy signal
               if(VerboseJournaling)
                  Print("Resistance Breakout detected at " + DoubleToString(srLevel, Digits) + 
                        " - BUY signal generated");
               break; // Exit loop after first valid signal
              }
           }
         else if(srType == -1 && crossResult == 2) // Support breakout (downward) 
           {
            // Confirm breakout with buffer
            if(Close[1] < srLevel - breakoutThreshold)
              {
               breakoutSignal = 2; // Sell signal
               if(VerboseJournaling)
                  Print("Support Breakout detected at " + DoubleToString(srLevel, Digits) + 
                        " - SELL signal generated");
               break; // Exit loop after first valid signal
              }
           }
        }
     }
   
   return(breakoutSignal);
  }
//+------------------------------------------------------------------+
//| End of DETECT S/R BREAKOUT SIGNAL                               
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| DISPLAY S/R INFO                                                |
//+------------------------------------------------------------------+
void DisplaySRInfo()
  {
// This function displays current support/resistance analysis information

   if(!UseSRBreakoutEntry) return; // Skip if S/R breakout trading disabled
   
   string info = "\n=== Support/Resistance Analysis ===\n";
   
   // Show S/R settings
   info += "S/R Breakout Trading: " + (UseSRBreakoutEntry ? "ENABLED" : "DISABLED") + "\n";
   info += "Lookback Period: " + (string)SRLookbackPeriod + " bars\n";
   info += "Breakout Buffer: " + DoubleToString(SRBreakoutBuffer, 1) + " pips\n";
   info += "Max S/R Levels: " + (string)MaxSRLevels + "\n";
   info += "S/R Threshold: " + DoubleToString(SupportResistanceThreshold, 1) + " pips\n";
   
   // Show detected S/R levels
   info += "Detected Levels: " + (string)CurrentSRCount + "\n";
   
   for(int i = 0; i < CurrentSRCount; i++)
     {
      string typeStr = (SRTypes[i] == 1) ? "RESISTANCE" : "SUPPORT";
      info += "Level " + (string)(i+1) + ": " + DoubleToString(SRLevels[i], Digits) + 
              " (" + typeStr + ", Strength: " + (string)SRStrength[i] + ")\n";
     }
   
   if(CurrentSRCount == 0)
     info += "No S/R levels detected in current lookback period\n";
   
   Print("" + info);
  }
//+------------------------------------------------------------------+
//| End of DISPLAY S/R INFO                                         
//+------------------------------------------------------------------+
