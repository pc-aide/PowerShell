# $Variables

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1|default|echo $env:path||
|2|Increment Path|# Scope: machine, user <br/># add new folder <br/>  [Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";C:\terraform\", [EnvironmentVariableTarget]::Machine)<br/><br/>$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts" |
|3|cmd : to refence the current location<br/>`%~dp0`|`$MyInvocation.MyCommand.Path \| Split-Path -Parent`|
|4|$PSScriptRoot|
