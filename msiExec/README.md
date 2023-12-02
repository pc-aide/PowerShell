# msiExec

---

## Options
|n|name|e.g.|O/P|
|-|----|---|----|
|1|FindOut properties|`msiExec /i <msi_name> /lp! <msi_property_logFile>`||
|2|PassThru|ExitCode : 0 -- Successful<br/>`(start msiExec -args "/i app.msi /q /noRestart /l*v C:\Temp\Install_app_1.0.0.log" -Wait -PassThru).exitCode`|
