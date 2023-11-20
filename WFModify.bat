@echo off
setlocal enabledelayedexpansion

set SCRIPT_DIR=%~dp0
set RULES_FILE=%SCRIPT_DIR%FirewallRules.txt

if not exist %RULES_FILE% (
    echo Error: Rules file not found!
    exit /b 1
)

echo Firewall rules to be added:

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
    echo Applying firewall rules...
    for /f "tokens=1,2,3" %%a in (%RULES_FILE%) do (
        set PORT=%%a
        set PROTOCOL=%%b
        set DIRECTIONS=%%c

        powershell -command "& { New-NetFirewallRule -DisplayName 'Allow Port !PORT! Inbound' -Direction Inbound -LocalPort !PORT! -Protocol !PROTOCOL! -Action Allow }"
        powershell -command "& { New-NetFirewallRule -DisplayName 'Allow Port !PORT! Outbound' -Direction Outbound -LocalPort !PORT! -Protocol !PROTOCOL! -Action Allow }"
    )

    cls
    echo Verifiying Firewall rules have been applied...

    for /f "tokens=1,2,3" %%a in (%RULES_FILE%) do (
        set PORT=%%a
        set PROTOCOL=%%b
        set DIRECTIONS=%%c

        set INBOUND_RULE_FOUND=false
        set OUTBOUND_RULE_FOUND=false

        for /f "delims=" %%i in ('powershell -command "& { Get-NetFirewallRule -DisplayName 'Allow Port !PORT! Inbound' }"') do set INBOUND_RULE_FOUND=true
        for /f "delims=" %%i in ('powershell -command "& { Get-NetFirewallRule -DisplayName 'Allow Port !PORT! Outbound' }"') do set OUTBOUND_RULE_FOUND=true

        if !INBOUND_RULE_FOUND! equ true (
            echo Allow Port !PORT! Inbound Protocol: !PROTOCOL! applied successfully.
        ) else (
            echo Allow Port !PORT! Inbound Protocol: !PROTOCOL! NOT applied.
        )

        if !OUTBOUND_RULE_FOUND! equ true (
            echo Allow Port !PORT! Outbound Protocol: !PROTOCOL! applied successfully.
        ) else (
            echo Allow Port !PORT! Outbound Protocol: !PROTOCOL! NOT applied.
        )
    )

    echo Firewall rules verification complete.
    pause
) else (
    echo Operation cancelled by user.
)

endlocal
