$choicemain=$null
$choice1=$null
$choice2=$null
$choice3=$null
$choice4=$null
$choice5=$null

Clear-Host
write-host -ForegroundColor Red "
Server SetupScript by Stefan Becker
Please use Numbers to get trough the menu
"

function readinput (){
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Main Menu
   Choose from the following Number
   1) Active Directory Health Tool
   2) Active Directory Services
   3) DHCP Server
   4) Disable Firewall
   5) Windows Patches
   
   0) Abbrechen
   "
   $choiceread=Read-Host
   return $choiceread
}

function readinputad (){
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Active Directory Services
   Choose the following Number
   1) Active Directory Services
   2) Active Directory Services incl Management
   3) Active Directory Management
   
   0) Abbrechen
   "
   $choiceread=Read-Host
   return $choiceread
}

function readinputfirewall (){
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenu Disable Firewall
   Are you sure?
   1) YES

   0) Abbrechen
   "
   $choiceread=Read-Host
   return $choiceread
}

function readinputdhcp {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue DHCP Services
   Choose the following Number
   1) DHCP Service
   2) DHCP Service incl Management
   3) DHCP Management

   0) Abbrechen
   "
   $choiceread=Read-Host
   return $choiceread
}

function readinputwindowspatch {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Windows Patches
   Choose the following Number
   1) Install Windows Patch Management Tools (required once)
   2) Search for Windows Updates
   3) Install Windows Updates

   0) Abbrechen
   "
   $choiceread=Read-Host
   return $choiceread
}

function InstallAdHealth {
   New-Item -Path "c:\" -Name "Service" -ItemType "directory" | Out-Null

   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   Invoke-WebRequest -Uri https://download.microsoft.com/download/6/8/8/688FFD30-8FB8-47BC-AD17-0E5467E4E979/adreplstatusInstaller.msi -OutFile C:\service\adreplstatus.msi
   
   Msiexec.exe /I C:\service\adreplstatus.msi   
}

function InstallADServices {
   Install-WindowsFeature -Name AD-Domain-Services
   Install-WindowsFeature -Name DNS 
}

function InstallADManagement {
   Install-WindowsFeature -Name RSAT-AD-Tools -IncludeAllSubFeature
   Install-WindowsFeature -Name RSAT-DNS-Server
}

function InstallDHCP {
   Install-WindowsFeature -Name DHCP   
}

function InstallDHCPManagement {
   Install-WindowsFeature -Name RSAT-DHCP   
}

function InstallSMBv1 {
   Install-WindowsFeature -Name FS-SMB1 -IncludeAllSubFeature
}
Start-Sleep -Seconds 5

function DisableFirewall {
   Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False   
}

function wait {
   Start-Sleep -Seconds 2   
}

do {
   $choicemain=readinput
   switch ($choicemain)
   {
   0 { Break mylabel }
   1 {
      Write-Host "  Aktuell nicht umgesetzt"
      wait
      $choicemain=$null
   }
   2 { $choice2=readinputad
       switch ($choice2) {
         1 {
            InstallADServices
            wait
         }
         2 {
            InstallADServices
            InstallADManagement
            wait
         }
         3 {
            InstallADManagement
            wait
         }
      }
      $choice2=$null
      $choicemain=$null
   }
   3 {
      $choice3=readinputdhcp
      switch ($choice3) {
         1 {
            InstallDHCP
            wait
         }
         2 {
            InstallDHCP
            InstallDHCPManagement
            wait
         }
         3 {
            InstallDHCPManagement
            wait
         }
      }
      $choice3=$null
      $choicemain=$null
   }
   4{
      $choice4=readinputfirewall
      switch ($choice4) {
         1 {
            DisableFirewall
            wait
         }
      } 
   }
   5{
      Write-Host "  Aktuell nicht umgesetzt"
      wait
      $choicemain=$null
      $choice5=$null
   }
   }
} until ( $choice1 -eq 0 )