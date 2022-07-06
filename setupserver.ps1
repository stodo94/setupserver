$choice=0
write-host @"
Server Installationsscript von Stefan Becker
Bitte verwenden Sie die Zifferntasten um durch
das Menue zu navigieren


"@

function readinput {
   
   Write-Host -ForegroundColor Yellow -Object "
   Bitte whlen Sie aus folgenden Mglichkeiten
   1) Active Directory Health Tool
   2) Active Directory Services
   3) DHCP Server
   
   0) Abbrechen
   "

}

function InstallAdHealth {
   New-Item -Path "c:\" -Name "Service" -ItemType "directory" | Out-Null

   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   Invoke-WebRequest -Uri https://download.microsoft.com/download/6/8/8/688FFD30-8FB8-47BC-AD17-0E5467E4E979/adreplstatusInstaller.msi -OutFile C:\service\adreplstatus.msi
   
   Msiexec.exe /I C:\service\adreplstatus.msi   
}

function InstallADServices {
   Install-WindowsFeature -Name AD-Domain-Services
   Install-WindowsFeature -Name RSAT-AD-Tools -IncludeAllSubFeature
   Install-WindowsFeature -Name DNS 
   Install-WindowsFeature -Name RSAT-DNS-Server
}

function InstallSMBv1 {
   Install-WindowsFeature -Name FS-SMB1 -IncludeAllSubFeature
}
Start-Sleep -Seconds 5

function DisableFirewall {
   Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False   
}

readinput

$choice= Read-Host

switch ($choice)
{
   0 { Break mylabel }
   1 {
      pause
      Break mylabel
   }
}


$title = "Firewall disable"
$message = "You want to disable Widnows Firewall?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$choice=$host.ui.PromptForChoice($title, $message, $options, 1)
$ErrorActionPreference = "SilentlyContinue"

if($choice -eq 0){



write-host("Windows Firewall deaktiviert")

}else {
   write-host("Keine nderung an der Windows Firewall")
}



pause