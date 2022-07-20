$choicemain=$null
$actualversion="v0.2.2"
Clear-Host
write-host -ForegroundColor Green "
Server SetupScript by Stefan Becker
Please use Numbers to get trough the menu

Version: $actualversion
"
New-Item -Path "c:\" -Name "Service" -ItemType "directory" -ErrorAction SilentlyContinue | Out-Null
New-Item -Path "c:\Service" -Name "setupserver" -ItemType "directory" -ErrorAction SilentlyContinue | Out-Null
New-Item -Path "c:\service\setupserver" -Name "bin" -ItemType "directory" -ErrorAction SilentlyContinue | Out-Null

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function readinput (){
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Main Menu
   Choose from the following Number
   1) Software
   2) Active Directory Services
   3) DHCP Server
   4) Disable Firewall
   5) Windows Patches
   6) Printserver

   
   9) Selfupdate
   0) Cancel
   "
   $choiceread=Read-Host -Prompt 'Please input Number'
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
   
   0) Cancel
   "
   $choiceread=Read-Host -Prompt 'Please input Number'
   return $choiceread
}

function readinputfirewall (){
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenu Disable Firewall
   Are you sure?
   1) YES

   0) Cancel
   "
   $choiceread=Read-Host -Prompt 'Please input Number'
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

   0) Cancel
   "
   $choiceread=Read-Host -Prompt 'Please input Number'
   return $choiceread
}

function readinputsoftware {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object '
   Submenu Software
   Choose the following Number
   1) Active Directory Health Tool
   2) Microsoft Edge
   3) Download SQL Express 2019
   4) .net Framework 4.8
   5) 7zip

   6) to continue...'   
   $choiceread=Read-Host -Prompt 'Please input Number'
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

   0) Cancel
   "
   $choiceread=Read-Host -Prompt 'Please input Number'
   return $choiceread
}

function readinputprintserver {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Printserverroles
   Choose the following Number
   1) Print Service
   2) Print Service incl Management
   3) Print Management

   0) Cancel
   "
   $choiceread=Read-Host -Prompt 'Please input Number'
   return $choiceread
}

function InstallAdHealth {
   New-Item -Path "c:\" -Name "Service" -ItemType "directory" | Out-Null
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

function InstallPrintserver {
   Install-WindowsFeature -Name Print-Server  
}

function InstallPrintMgmt {
   Install-WindowsFeature -Name RSAT-Print-Services
}

function InstallSMBv1 {
   Install-WindowsFeature -Name FS-SMB1 -IncludeAllSubFeature
}


function DisableFirewall {
   Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False   
}

function InstallWGet {
   $wgetbin = "C:\service\setupserver\bin\wget.exe"

   #If the file does not exist, create it.
   if (-not(Test-Path -Path $wgetbin -PathType Leaf)) {
     try {
      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri https://github.com/webfolderio/wget-windows/releases/download/v1.21.3.june.21.2022/wget-gnutls-x64.exe -OutFile C:\service\setupserver\bin\wget.exe | Out-Null
      $ProgressPreference = 'Continue'
     }
     catch {
         throw $_.Exception.Message
     }
   }
   # If the file already exists, show the message and do nothing.
   else {   
   }
}

function InstallMSEdge {
   InstallWGet
   C:\service\setupserver\bin\wget.exe http://go.microsoft.com/fwlink/?LinkID=2093437 -q --show-progress -O C:\service\setupserver\bin\edgex64.msi
   Msiexec.exe /i C:\service\setupserver\bin\edgex64.msi /qn
}

function checkversion {
   InstallWGet
   C:\service\setupserver\bin\wget.exe https://raw.githubusercontent.com/stodo94/setupserver/main/src/version.csv -q -O C:\service\setupserver\bin\version.csv
   $version=Import-CSV -Path C:\service\setupserver\bin\version.csv
   $newversion=$version.Version
   $newversion
   Remove-Item C:\Service\setupserver\bin\version.csv
   if ($newversion -notlike $actualversion) {
      C:\service\setupserver\bin\wget.exe https://raw.githubusercontent.com/stodo94/setupserver/$newversion/setupserver.ps1 -q --show-progress -O C:\service\setupserver\setupserver.ps1
      #Write-Host -ForegroundColor Red "Please Load Newest Release"
      wait
      Set-Variable -Name choicemain -Value "0" -Scope 1
      Write-Host -ForegroundColor Red "Update Downloaded Run From C:\Service\setupserver"
      Start-Sleep -Seconds 10
   }
   else {
      Write-Host -ForegroundColor Yellow "NO UPDATE NEEDED"
   }
}

function downloadsqlexpress {
   #Write-Host -ForegroundColor Yellow "  Development in Progress"
   Write-Host -ForegroundColor Blue -Object "  Download Path C:\Service\SQL2019Express"
   waitforenter
   InstallWGet
   New-Item -Path "c:\Service" -Name "SQL2019Express" -ItemType "directory" -ErrorAction SilentlyContinue | Out-Null
   C:\service\setupserver\bin\wget.exe https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SQLEXPRADV_x64_ENU.exe -q --show-progress -P C:\Service\SQL2019Express
}

function InstallDotNet48 {
   InstallWGet
   C:\Service\setupserver\bin\wget.exe https://go.microsoft.com/fwlink/?linkid=2088631 -q -O C:\service\setupserver\bin\dotnet48.exe --show-progress
   C:\Service\setupserver\bin\dotnet48.exe /q /norestart
   Write-Host -ForegroundColor Green "  Reboot and Windows Updates recommended"
   Start-Sleep -Seconds 6
}

function Install7zip {
   InstallWGet
   C:\Service\setupserver\bin\wget.exe https://7-zip.org/a/7z2201-x64.msi -q -P C:\Service\setupserver\bin --show-progress
   msiexec.exe /I C:\Service\setupserver\bin\7z2201-x64.msi /qn   
}

function wait {
   Start-Sleep -Seconds 2   
}

function waitforenter {
   Write-Host -ForegroundColor Green -NoNewLine 'Press any key to continue...';
   $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');   
}

waitforenter

do {
   switch (readinput) {
   # Abbruch
   0 {
      Break mylabel
   }
   # Software
   1 {
      switch(readinputsoftware) {
         #ActiveDirectory Health Tool
         1{
            Write-Host -ForegroundColor Red "  Not functional at the Moment"
            Write-Host -ForegroundColor Red "  Microsoft is having issues at the Moment"
            Write-Host -ForegroundColor Red "  If Microsoft will fix it, the Installation"
            Write-Host -ForegroundColor Red "  will be available"
            waitforenter
         }
         2{
            InstallMSEdge
            waitforenter
         }
         3{
            downloadsqlexpress
            waitforenter
         }
         4{
            InstallDotNet48
            waitforenter
         }
         5{
            Install7zip
            waitforenter
         }
      }
   }
   2 { 
       switch (readinputad) {
         1 {
            InstallADServices
            waitforenter
         }
         2 {
            InstallADServices
            InstallADManagement
            waitforenter
         }
         3 {
            InstallADManagement
            waitforenter
         }
      }
   }
   3 {
      switch (readinputdhcp) {
         1 {
            InstallDHCP
            waitforenter
         }
         2 {
            InstallDHCP
            InstallDHCPManagement
            waitforenter
         }
         3 {
            InstallDHCPManagement
            waitforenter
         }
      }
   }
   4{
      switch (readinputfirewall) {
         1 {
            DisableFirewall
            waitforenter
         }
      } 
   }
   5{
      switch (readinputwindowspatch) {
         1 {
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
            Install-Module PSWindowsUpdate -Force -SkipPublisherCheck
            waitforenter
         }
         2 {
            Get-WindowsUpdate -NotCategory 'Drivers' | Format-Table
            waitforenter
         }
         3 {
            Install-WindowsUpdate -AcceptAll -Install -IgnoreReboot -NotCategory 'Drivers' | Format-Table
            waitforenter
         }
      }
   }
   6{
      switch (readinputprintserver) {
         1{
            InstallPrintserver
            waitforenter
         }
         2{
            InstallPrintserver
            InstallPrintMgmt
            waitforenter
         }
         3{
            InstallPrintMgmt
            waitforenter
         }
      }
   }
   9 {
      checkversion
      waitforenter
   }
   }
} until ($choicemain-eq 0)
