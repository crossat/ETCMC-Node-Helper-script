@echo off
setlocal enabledelayedexpansion

set RULES_FILE=FirewallRules.txt

if not exist %RULES_FILE% (
    echo Error: Rules file not found!
    exit /b 1
)

echo Firewall rules to be added:

for /f "tokens=1,2,3" %%a in (%RULES_FILE%) do (
    set PORT=%%a
    set PROTOCOL=%%b
    set DIRECTIONS=%%c

    for %%d in (!DIRECTIONS!) do (
        if /i %%d equ inbound (
            echo Allow Port !PORT! Inbound Protocol: !PROTOCOL!
        ) else (
            if /i %%d equ outbound (
                echo Allow Port !PORT! Outbound Protocol: !PROTOCOL!
            ) else (
                echo Invalid direction: %%d
            )
        )
    )
)

set /p CONFIRM=Do you want to apply these firewall rules? (Y/N):

if /i "%CONFIRM%" equ "Y" (
    for /f "tokens=1,2,3" %%a in (%RULES_FILE%) do (
        set PORT=%%a
        set PROTOCOL=%%b
        set DIRECTIONS=%%c

        for %%d in (!DIRECTIONS!) do (
            if /i %%d equ inbound (
                netsh advfirewall firewall add rule name="Allow Port !PORT! Inbound" dir=in action=allow protocol=!PROTOCOL! localport=!PORT!
            ) else (
                if /i %%d equ outbound (
                    netsh advfirewall firewall add rule name="Allow Port !PORT! Outbound" dir=out action=allow protocol=!PROTOCOL! localport=!PORT!
                ) else (
                    echo Invalid direction: %%d
                )
            )
        )
    )
    echo Firewall rules added successfully.
) else (
    echo Operation cancelled by user.
)

endlocal
