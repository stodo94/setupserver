$title = "AD Replication Health"
$message = "You want to Install Active Directory Replication Health?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$choice=$host.ui.PromptForChoice($title, $message, $options, 1)
$ErrorActionPreference = "SilentlyContinue"

if($choice -eq 0){

New-Item -Path "c:\" -Name "Service" -ItemType "directory" | Out-Null

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://download.microsoft.com/download/6/8/8/688FFD30-8FB8-47BC-AD17-0E5467E4E979/adreplstatusInstaller.msi -OutFile C:\service\adreplstatus.msi

Msiexec.exe /I C:\service\adreplstatus.msi

write-host("AD Replication Health wurde installiert")

}else {
   write-host("AD Replication Health wird nicht installiert")
}

$title = "DC Roles und RSAT"
$message = "You want to Install Active Directory Roles with RSAT?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$choice=$host.ui.PromptForChoice($title, $message, $options, 1)
$ErrorActionPreference = "SilentlyContinue"

if($choice -eq 0){

Install-WindowsFeature -Name AD-Domain-Services
Install-WindowsFeature -Name RSAT-AD-Tools -IncludeAllSubFeature
Install-WindowsFeature -Name DNS 
Install-WindowsFeature -Name RSAT-DNS-Server

write-host("AD Rolen wurden installiert")

}else {
   write-host("AD Rollen wird nicht installiert")
}


$title = "SMBv1"
$message = "You want to Install SMBv1?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$choice=$host.ui.PromptForChoice($title, $message, $options, 1)
$ErrorActionPreference = "SilentlyContinue"

if($choice -eq 0){

Install-WindowsFeature -Name FS-SMB1 -IncludeAllSubFeature


write-host("SMBv1 wurde installiert, bitte Neustart ausführen")

}else {
   write-host("SMBv1 wird nicht installiert")
}

$title = "Firewall disable"
$message = "You want to disable Widnows Firewall?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$choice=$host.ui.PromptForChoice($title, $message, $options, 1)
$ErrorActionPreference = "SilentlyContinue"

if($choice -eq 0){

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

write-host("Windows Firewall deaktiviert")

}else {
   write-host("Keine Änderung an der Windows Firewall")
}


pause