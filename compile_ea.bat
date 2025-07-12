@echo off
echo Compiling Falcon_B_PipFinite.mq4...

REM Try different possible MetaEditor paths
if exist "C:\Program Files\MetaTrader 4\metaeditor.exe" (
    "C:\Program Files\MetaTrader 4\metaeditor.exe" /compile:Falcon_B_PipFinite.mq4 /log:compilemql4.log
    goto :done
)

if exist "C:\Program Files (x86)\MetaTrader 4\metaeditor.exe" (
    "C:\Program Files (x86)\MetaTrader 4\metaeditor.exe" /compile:Falcon_B_PipFinite.mq4 /log:compilemql4.log
    goto :done
)

if exist "C:\Program Files\MetaTrader 4-2\metaeditor.exe" (
    "C:\Program Files\MetaTrader 4-2\metaeditor.exe" /compile:Falcon_B_PipFinite.mq4 /log:compilemql4.log
    goto :done
)

if exist "C:\Program Files (x86)\MetaTrader 4-2\metaeditor.exe" (
    "C:\Program Files (x86)\MetaTrader 4-2\metaeditor.exe" /compile:Falcon_B_PipFinite.mq4 /log:compilemql4.log
    goto :done
)

echo MetaEditor not found in standard paths
echo Please check if MetaTrader 4 is installed

:done
echo Compilation complete. Check compilemql4.log for results.
pause
