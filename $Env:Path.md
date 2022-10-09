# $Env:Path

---

## List
|n|name|e.g.|O/P|
|-|----|----|---|
|1|default|echo $env:path||
|2|Increment Path|# Scope: machine, user <br/># add new folder <br/>  [Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";C:\terraform\", [EnvironmentVariableTarget]::Machine) |
