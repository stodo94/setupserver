$choicemain = $null
$actualversion = "v0.4.0"
Clear-Host
write-host -ForegroundColor Green "
Server SetupScript by Stefan Becker
Please use Numbers to get trough the menu

Version: $actualversion
Loading, please Wait....
"
New-Item -Path "c:\" -Name "Service" -ItemType "directory" -ErrorAction SilentlyContinue | Out-Null
New-Item -Path "c:\Service" -Name "setupserver" -ItemType "directory" -ErrorAction SilentlyContinue | Out-Null
New-Item -Path "c:\service\setupserver" -Name "bin" -ItemType "directory" -ErrorAction SilentlyContinue | Out-Null

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Variables for Script2
$HOSTCOMPLETE = Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object Name, Domain
$var_hostname = $HOSTCOMPLETE.Name
$var_domain = $HOSTCOMPLETE.Domain
$HOSTIP = Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"}
$ipaddress = $HOSTIP.IPv4Address.IPAddress

function readinput () {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   ----------------------------------------
   Server Hostname:  $var_hostname
   Server Domain:    $var_domain
   Server IP:        $ipaddress
   ----------------------------------------
   Main Menu
   Choose from the following Number
   1) Software
   2) Windows Server Roles / Features
   3) Disable Firewall
   4) Windows Patches
   5) Tools
   6) Community (to be anounced)

   9) Selfupdate
   10) Logout User
   11) Restart Server/PC
   0) Cancel
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}

#Software
function readinputsoftware {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object '
   Submenu Software
   Choose the following Number
   1) Active Directory Health Tool
   2) Microsoft Edge
   3) Download SQL Express 2019
   4) SQL Management Studio
   5) .net Framework 4.8
   6) 7zip

   0) to continue...'   
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}

#Active Directory Roles und Features
function readinputroles {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Windows Server Roles and Features
   Choose from the following Number
   1) Active Directory
   2) DHCP Server
   3) Printserver
   4) DFS Replication / Namespace
   5) Group Policy Management
   6) NPS Server
   7) ...

   0) Cancel
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread   
}

function readinputad () {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Active Directory Services
   Choose the following Number
   1) Active Directory Services
   2) Active Directory Services incl Management
   3) Active Directory Management
   
   0) Cancel
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
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
   $choiceread = Read-Host -Prompt 'Please input Number'
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
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}

function readinputdfs {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue DFS Serverroles
   Choose the following Number
   1) DFS Replication / DFS Namespace
   2) DFS Replication / DFS Namespace incl Management
   3) DFS Replication / DFS Namespace Management Tools Only

   0) Cancel
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread 
}

function readinputgpmc () {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenu Group Policy Management
   Do you want to Install GPMC?
   1) YES
   0) NO
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}

function readinputnps () {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Network Policy Server
   Choose the following Number
   1) Network Policy Server
   2) Network Policy Server incl Management
   3) Network Policy Server Management only
   
   0) Cancel
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}


#Firewall
function readinputfirewall () {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenu Disable Firewall
   Are you sure?
   1) YES

   0) Cancel
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}

#Windows Patches
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
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}

#Tools
function readinputtools {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Tools
   Choose the following Number
   1) Clean System Drive
   2) Get-DHCP Leases (DHCP-RSAT Tools must be Installed)
      Get them from Main Menu 2-2-3 (in Progress)
   3) ...

   0) Cancel
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}

#Clean Systemdrive Menu
function readinput_cleansystemdrive {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Tools - Clean System Drive
   Choose the following Number
   1) Clean Old Service Pack Files
   2) DISM AnalyzeComponentstore
   3) DISM StartComponentCleanup
   4) Automatic Clean with CLEANMGR.EXE

   0) Cancel
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}

#Clean Service Pack Files
function readinput_cleanservicepack {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Tools - Clean Old Service Pack Files
   Run DISM to Clean Old Service Pack Files?
   1) YES
   0) NO
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}

# DISM AnalyzeComponentstore
function readinput_analyze {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Tools - DISM AnalyzeComponentStore
   Run DISM AnalyzeComponentStore?
   1) YES
   0) NO
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}
# DISM StartComponentCleanup

function readinput_stcomclean{
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Tools - DISM StartComponentCleanup
   Run DISM StartComponentCleanup?
   1) YES
   0) NO
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}

#Clean with cleanmgr.exe
function readinput_cleanmgr {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Tools - Run Cleanmgr.exe
   Run cleanmgr with automatic?
   1) YES
   0) NO
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}



function readinputlogoff {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Logoff
   Do You Want To Logoff Now
   0) NO
   1) YES
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
}

function readinputrestart {
   Clear-Host
   Write-Host -ForegroundColor Yellow -Object "
   Submenue Restart
   Do You Want To Restart Now
   0) NO
   1) YES
   "
   $choiceread = Read-Host -Prompt 'Please input Number'
   return $choiceread
   
}

# Module / Funktionen
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
   Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False   
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
   Start-Process msiexec.exe -Wait -ArgumentList '/i C:\service\setupserver\bin\edgex64.msi /qn'
}

function checkversion {
   InstallWGet
   C:\service\setupserver\bin\wget.exe https://raw.githubusercontent.com/stodo94/setupserver/main/src/version.csv -q -O C:\service\setupserver\bin\version.csv
   $version = Import-CSV -Path C:\service\setupserver\bin\version.csv
   $newversion = $version.Version
   $newversion
   Remove-Item C:\Service\setupserver\bin\version.csv
   if ($newversion -notlike $actualversion) {
      C:\service\setupserver\bin\wget.exe https://raw.githubusercontent.com/stodo94/setupserver/$newversion/setupserver.ps1 -q --show-progress -O C:\service\setupserver\setupserver.ps1
      #Write-Host -ForegroundColor Red "Please Load Newest Release"
      wait
      Set-Variable -Name choicemain -Value "0" -Scope 1
      Write-Host -ForegroundColor Cyan "Update Downloaded Run From C:\Service\setupserver"
      Start-Sleep -Seconds 10
   }
   else {
      Write-Host -ForegroundColor Yellow "NO UPDATE NEEDED"
   }
}

function downloadsqlexpress {
   #Write-Host -ForegroundColor Yellow "  Development in Progress"
   Write-Host -ForegroundColor Cyan -Object "  Download Path C:\Service\SQL2019Express"
   waitforenter
   InstallWGet
   New-Item -Path "c:\Service" -Name "SQL2019Express" -ItemType "directory" -ErrorAction SilentlyContinue | Out-Null
   C:\service\setupserver\bin\wget.exe https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SQLEXPRADV_x64_ENU.exe -q --show-progress -P C:\Service\SQL2019Express
}

function installssms {
   InstallWGet
   C:\service\setupserver\bin\wget.exe https://aka.ms/ssmsfullsetup -q --show-progress -O C:\Service\setupserver\bin\smssfull.exe
   Start-Process 'C:\Service\setupserver\bin\smssfull.exe' -Wait -ArgumentList '/install /quiet /norestart'
}

function InstallDotNet48 {
   InstallWGet
   C:\Service\setupserver\bin\wget.exe https://go.microsoft.com/fwlink/?linkid=2088631 -q -O C:\service\setupserver\bin\dotnet48.exe --show-progress
   Start-Process 'C:\Service\setupserver\bin\dotnet48.exe' -Wait -ArgumentList '/q /norestart'
   Write-Host -ForegroundColor Green "  Reboot and Windows Updates recommended"
}

function Install7zip {
   InstallWGet
   C:\Service\setupserver\bin\wget.exe https://7-zip.org/a/7z2201-x64.msi -q -O C:\service\setupserver\bin\7z2201-x64.msi --show-progress  --no-check-certificate
   Start-Process 'msiexec.exe' -Wait -ArgumentList '/I C:\Service\setupserver\bin\7z2201-x64.msi /qn'
}

function InstallDFS {
   Install-WindowsFeature -Name FS-DFS-Namespace, FS-DFS-Replication   
}

function InstallDFSMgmt {
   Install-WindowsFeature -Name RSAT-DFS-Mgmt-Con   
}

function InstallGPMC {
   Install-WindowsFeature -Name GPMC   
}

function InstallNPS {
   Install-WindowsFeature -Name NPAS   
}

function InstallNPSMgmt {
   Install-WindowsFeature -Name RSAT-NPAS   
}

function wait {
   Start-Sleep -Seconds 2   
}

function waitforenter {
   Write-Host -ForegroundColor Green -NoNewLine 'Press any key to continue...';
   $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');   
}

function fu_dism_cleanservicepack {
   DISM /online /Cleanup-Image /SpSuperseded
}
function fu_dism_analzyze {
   dism /Online /Cleanup-Image /AnalyzeComponentStore
}
function fu_dism_stcomclean {
   dism /online /Cleanup-Image /StartComponentCleanup
}
function fu_diskclean {
   cleanmgr.exe /AUTOCLEAN
   Wait-Process -Name cleanmgr
   cleanmgr.exe /VERYLOWDISK
   Wait-Process -Name cleanmgr
}

function fu_getalldhcpleases {
   Get-DhcpServerv4Scope | Get-DhcpServerv4Lease | Sort-Object Hostname
}

#UserFrontend
waitforenter

do {
   switch (readinput) {
      # Abbruch
      0 {
         Break mylabel
      }
      # Software
      1 {
         switch (readinputsoftware) {
            #ActiveDirectory Health Tool
            1 {
               Write-Host -ForegroundColor Red "  Not functional at the Moment"
               Write-Host -ForegroundColor Red "  Microsoft is having issues at the Moment"
               Write-Host -ForegroundColor Red "  If Microsoft will fix it, the Installation"
               Write-Host -ForegroundColor Red "  will be available"
               waitforenter
            }
            #MS Edge Setup
            2 { 
               InstallMSEdge
               waitforenter
            }
            # Download SQL Express 2019
            3 {
               downloadsqlexpress
               waitforenter
            }
            #Download and Install SQL Managment Studio
            4 {
               installssms
               waitforenter
            }
            #Download and Install .net 4.8
            5 {
               InstallDotNet48
               waitforenter
            }
            #Download and Install 7zip
            6 {
               Install7zip
               waitforenter
            }
         }
      }
      #Windows Server Roles / Features
      2 { 
         switch (readinputroles) {
            #Active Directory
            1 {
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
            #DHCPServer
            2 {
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
            #Printserver
            3 {
               switch (readinputprintserver) {
                  1 {
                     InstallPrintserver
                     waitforenter
                  }
                  2 {
                     InstallPrintserver
                     InstallPrintMgmt
                     waitforenter
                  }
                  3 {
                     InstallPrintMgmt
                     waitforenter
                  }
               }
            }
            #DFS Replicaton
            4 {
               switch (readinputdfs) {
                  1 {
                     InstallDFS
                     waitforenter
                  }
                  2 {
                     InstallDFS
                     InstallDFSMgmt
                     waitforenter
                  }
                  3 {
                     InstallDFSMgmt
                     waitforenter
                  }
               }
            }
            #GPMC Console
            5 {
               switch (readinputgpmc) {
                  1 {
                     InstallGPMC
                     waitforenter
                  }
               }
            }
            #NPS Server
            6 {
               switch (readinputnps) {
                  1 {
                     InstallNPS
                     waitforenter
                  }
                  2 {
                     InstallNPS
                     InstallNPSMgmt
                     waitforenter
                  }
                  3 {
                     InstallNPSMgmt
                     waitforenter
                  }
               }
            }
         }
       
      }
      #Disable Firewall
      3 {
         switch (readinputfirewall) {
            1 {
               DisableFirewall
               waitforenter
            }
         } 
      }
      #Windows Updates
      4 {
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
      #Tools
      5 {
         switch (readinputtools) {
            1 {
               #Clean Systemdrive
               switch (readinput_cleansystemdrive) {
                  #Clean Old Servicepack Files
                  1 {
                     switch (readinput_cleanservicepack) {
                        1 {
                           fu_dism_cleanservicepack
                           waitforenter
                        }
                     }
                  }
                  # DISM AnalyzeComponentStore
                  2{
                     switch (readinput_analyze) {
                        1 {
                           fu_dism_analzyze
                           waitforenter
                        }
                     }
                  }
                  # DISM StartComponentCleanup
                  3{
                     switch (readinput_stcomclean) {
                        1{
                           fu_dism_stcomclean
                           waitforenter
                        }
                     }
                  }
                  #Clean with cleanmgr.exe
                  4{
                     switch (readinput_cleanmgr) {
                        1 {
                           fu_diskclean
                           waitforenter
                        }
                     }
                  }
               }         
            } 
         }
      }
      6 {
      
      }
      7 {
      
      }
      #Selfupdate
      9 {
         checkversion
         waitforenter
      }
      #Logoff Current User
      10 {
         switch (readinputlogoff) {
            1 {
               logoff.exe
            }
         }
      }
      #Restart Server / Computer
      11 {
         switch (readinputrestart) {
            1 {
               Restart-Computer
            }
         }
      }
   }
} until ($choicemain -eq 0)
