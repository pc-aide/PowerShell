# operatingSytem

---

## get-member
````ps1
gwmi win32_operatingSystem | get-member

TypeName : System.Management.ManagementObject#root\cimv2\Win32_OperatingSystem

Name                                      MemberType    Definition
----                                      ----------    ----------
PSComputerName                            AliasProperty PSComputerName = __SERVER
BootDevice                                Property      string BootDevice {get;set;}
BuildNumber                               Property      string BuildNumber {get;set;}
BuildType                                 Property      string BuildType {get;set;}
Caption                                   Property      string Caption {get;set;}
CodeSet                                   Property      string CodeSet {get;set;}
CountryCode                               Property      string CountryCode {get;set;}
CreationClassName                         Property      string CreationClassName {get;set;}
CSCreationClassName                       Property      string CSCreationClassName {get;set;}
CSDVersion                                Property      string CSDVersion {get;set;}
CSName                                    Property      string CSName {get;set;}
CurrentTimeZone                           Property      int16 CurrentTimeZone {get;set;}
DataExecutionPrevention_32BitApplications Property      bool DataExecutionPrevention_32BitAppli...
DataExecutionPrevention_Available         Property      bool DataExecutionPrevention_Available ...
DataExecutionPrevention_Drivers           Property      bool DataExecutionPrevention_Drivers {g...
DataExecutionPrevention_SupportPolicy     Property      byte DataExecutionPrevention_SupportPol...
Debug                                     Property      bool Debug {get;set;}
Description                               Property      string Description {get;set;}
Distributed                               Property      bool Distributed {get;set;}
EncryptionLevel                           Property      uint32 EncryptionLevel {get;set;}
ForegroundApplicationBoost                Property      byte ForegroundApplicationBoost {get;set;}
FreePhysicalMemory                        Property      uint64 FreePhysicalMemory {get;set;}
FreeSpaceInPagingFiles                    Property      uint64 FreeSpaceInPagingFiles {get;set;}
FreeVirtualMemory                         Property      uint64 FreeVirtualMemory {get;set;}
InstallDate                               Property      string InstallDate {get;set;}
LargeSystemCache                          Property      uint32 LargeSystemCache {get;set;}
LastBootUpTime                            Property      string LastBootUpTime {get;set;}
LocalDateTime                             Property      string LocalDateTime {get;set;}
Locale                                    Property      string Locale {get;set;}
Manufacturer                              Property      string Manufacturer {get;set;}
MaxNumberOfProcesses                      Property      uint32 MaxNumberOfProcesses {get;set;}
MaxProcessMemorySize                      Property      uint64 MaxProcessMemorySize {get;set;}
MUILanguages                              Property      string[] MUILanguages {get;set;}
Name                                      Property      string Name {get;set;}
NumberOfLicensedUsers                     Property      uint32 NumberOfLicensedUsers {get;set;}
NumberOfProcesses                         Property      uint32 NumberOfProcesses {get;set;}
NumberOfUsers                             Property      uint32 NumberOfUsers {get;set;}
OperatingSystemSKU                        Property      uint32 OperatingSystemSKU {get;set;}
Organization                              Property      string Organization {get;set;}
OSArchitecture                            Property      string OSArchitecture {get;set;}
OSLanguage                                Property      uint32 OSLanguage {get;set;}
OSProductSuite                            Property      uint32 OSProductSuite {get;set;}
OSType                                    Property      uint16 OSType {get;set;}
OtherTypeDescription                      Property      string OtherTypeDescription {get;set;}
PAEEnabled                                Property      bool PAEEnabled {get;set;}
PlusProductID                             Property      string PlusProductID {get;set;}
PlusVersionNumber                         Property      string PlusVersionNumber {get;set;}
PortableOperatingSystem                   Property      bool PortableOperatingSystem {get;set;}
Primary                                   Property      bool Primary {get;set;}
ProductType                               Property      uint32 ProductType {get;set;}
RegisteredUser                            Property      string RegisteredUser {get;set;}
SerialNumber                              Property      string SerialNumber {get;set;}
ServicePackMajorVersion                   Property      uint16 ServicePackMajorVersion {get;set;}
ServicePackMinorVersion                   Property      uint16 ServicePackMinorVersion {get;set;}
SizeStoredInPagingFiles                   Property      uint64 SizeStoredInPagingFiles {get;set;}
Status                                    Property      string Status {get;set;}
SuiteMask                                 Property      uint32 SuiteMask {get;set;}
SystemDevice                              Property      string SystemDevice {get;set;}
SystemDirectory                           Property      string SystemDirectory {get;set;}
SystemDrive                               Property      string SystemDrive {get;set;}
TotalSwapSpaceSize                        Property      uint64 TotalSwapSpaceSize {get;set;}
TotalVirtualMemorySize                    Property      uint64 TotalVirtualMemorySize {get;set;}
TotalVisibleMemorySize                    Property      uint64 TotalVisibleMemorySize {get;set;}
Version                                   Property      string Version {get;set;}
WindowsDirectory                          Property      string WindowsDirectory {get;set;}
__CLASS                                   Property      string __CLASS {get;set;}
__DERIVATION                              Property      string[] __DERIVATION {get;set;}
__DYNASTY                                 Property      string __DYNASTY {get;set;}
__GENUS                                   Property      int __GENUS {get;set;}
__NAMESPACE                               Property      string __NAMESPACE {get;set;}
__PATH                                    Property      string __PATH {get;set;}
__PROPERTY_COUNT                          Property      int __PROPERTY_COUNT {get;set;}
__RELPATH                                 Property      string __RELPATH {get;set;}
__SERVER                                  Property      string __SERVER {get;set;}
__SUPERCLASS                              Property      string __SUPERCLASS {get;set;}
````

---

## Properties
|n|name|e.g.|O/P|
|-|----|----|---|
|1|default|# O/P: SystemDirectory, Organization, BuildNumber, REgisterUser, SerialNumber, Version<br/>`gwmi win32_operatingSystem`

---

## Methods
|n|name|e.g.|O/P|
|-|----|----|---|
