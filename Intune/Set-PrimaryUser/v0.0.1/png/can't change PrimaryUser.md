````ps1
set-primaryUser.ps1
````

* O/P 
````txt
 Device name: <DeviceName>
Intune Device Primary User: <userId>
Response content:
{"error":{"code":"BadRequest","message":"{\r\n  \"_version\": 3,\r\n  \"Message\": \"An error has occurred - Operation ID (for customer support): 00000000-0000-0000-0000-000000000000 - Activ
ity ID: 698db83e-3824-4c65-8f51-67110a48d072 - Url: https://fef.msua08.manage.microsoft.com/DeviceFE/StatelessDeviceFEService/deviceManagement/managedDevices('ede1af1e-8163-4644-a637-bac1ec8
02aac')/users/$ref?api-version=5022-11-15\",\r\n  \"CustomApiErrorPhrase\": \"\",\r\n  \"RetryAfter\": null,\r\n  \"ErrorSourceService\": \"\",\r\n  \"HttpHeaders\": \"{}\"\r\n}","innerError
":{"date":"2023-02-26T22:47:17","request-id":"698db83e-3824-4c65-8f51-67110a48d072","client-request-id":"698db83e-3824-4c65-8f51-67110a48d072"}}}
Set-IntuneDevicePrimaryUser : Request to https://graph.microsoft.com/beta/deviceManagement/managedDevices('ede1af1e-8163-4644-a637-bac1ec802aac')/users/$ref failed with HTTP Status 
BadRequest Bad Request
At line:485 char:47
+ ... imaryUser = Set-IntuneDevicePrimaryUser -IntuneDeviceId $Device.id -u ...
+                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,Set-IntuneDevicePrimaryUser
 
Set-IntuneDevicePrimaryUser error
At line:388 char:3
+         throw "Set-IntuneDevicePrimaryUser error"
+         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : OperationStopped: (Set-IntuneDevicePrimaryUser error:String) [], RuntimeException
    + FullyQualifiedErrorId : Set-IntuneDevicePrimaryUser error
````
