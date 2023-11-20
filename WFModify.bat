@echo off
cls
echo ----------------------------------------
echo Windows Firewall Rules Modification Script
echo Created by Andrew Cross
echo Version: 1.0
echo GitHub: https://github.com/crossat/ETCMC-Node-Helper-script
echo ----------------------------------------

setlocal enabledelayedexpansion

set SCRIPT_DIR=%~dp0
set RULES_FILE=%SCRIPT_DIR%FirewallRules.txt

if not exist %RULES_FILE% (
    echo Error: Rules file not found!
    exit /b 1
)

echo - Firewall rules to be added:
echo - 

for /f "tokens=1,2,3" %%a in (%RULES_FILE%) do (
    set PORT=%%a
    set PROTOCOL=%%b
    set DIRECTIONS=%%c

    echo Allow Port !PORT! Inbound Protocol: !PROTOCOL!
    echo Allow Port !PORT! Outbound Protocol: !PROTOCOL!
)

set /p CONFIRM=Do you want to apply these firewall rules? (Y/N):

if /i "%CONFIRM%" equ "Y" (
    cls
    echo ----------------------------------------
    echo Windows Firewall Rules Modification Script
    echo Created by Andrew Cross
    echo Version: 1.0
    echo GitHub: https://github.com/crossat/ETCMC-Node-Helper-script
    echo ----------------------------------------
    echo Step 1 - Applying firewall rules...
    for /f "tokens=1,2,3" %%a in (%RULES_FILE%) do (
        set PORT=%%a
        set PROTOCOL=%%b
        set DIRECTIONS=%%c

        powershell -command "& { New-NetFirewallRule -DisplayName 'Allow Port !PORT! Inbound' -Direction Inbound -LocalPort !PORT! -Protocol !PROTOCOL! -Action Allow }" >nul
        powershell -command "& { New-NetFirewallRule -DisplayName 'Allow Port !PORT! Outbound' -Direction Outbound -LocalPort !PORT! -Protocol !PROTOCOL! -Action Allow }" >nul
    )

    echo Step 2 - Verifiying Firewall rules have been applied...
    echo -

    for /f "tokens=1,2,3" %%a in (%RULES_FILE%) do (
        set PORT=%%a
        set PROTOCOL=%%b
        set DIRECTIONS=%%c

        set INBOUND_RULE_FOUND=false
        set OUTBOUND_RULE_FOUND=false

        for /f "delims=" %%i in ('powershell -command "& { Get-NetFirewallRule -DisplayName 'Allow Port !PORT! Inbound' }"') do set INBOUND_RULE_FOUND=true
        for /f "delims=" %%i in ('powershell -command "& { Get-NetFirewallRule -DisplayName 'Allow Port !PORT! Outbound' }"') do set OUTBOUND_RULE_FOUND=true

        if !INBOUND_RULE_FOUND! equ true (
            echo Allow Port !PORT! Inbound Protocol: !PROTOCOL! - applied successfully.
        ) else (
            echo Allow Port !PORT! Inbound Protocol: !PROTOCOL! - NOT applied.
        )

        if !OUTBOUND_RULE_FOUND! equ true (
            echo Allow Port !PORT! Outbound Protocol: !PROTOCOL! - applied successfully.
        ) else (
            echo Allow Port !PORT! Outbound Protocol: !PROTOCOL! - NOT applied.
        )
    )
    
    echo -
    echo - Firewall rules verification complete.
    echo - 
    pause
) else (
    echo Operation cancelled by user.
)

endlocal
