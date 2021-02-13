rem Script to Sync Files from Development Terminal to Version Control

@echo off
setlocal enabledelayedexpansion

:: Source Directory where Expert Advisor is located
set SOURCE_DIR="C:\Program Files (x86)\MetaTrader 4-2\MQL4\Experts\04_FALCON_B"
:: Destination Directory where Version Control Repository is located
set DEST_DIR="C:\Users\Ofer\trading\Lazy Trading course\FALCON_B"

:: Copy only files with *.mq4 extension
ROBOCOPY %SOURCE_DIR% %DEST_DIR% *.mq4