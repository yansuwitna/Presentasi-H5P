!include LogicLib.nsh
!include x64.nsh
!include FileFunc.nsh
!insertmacro GetParameters

; Tentukan nama aplikasi dan versi
Name "H5P Presentasi"
OutFile "Setup Presentasi H5P.exe"
InstallDir "C:\h5p"
InstallDirRegKey HKLM "Software\h5p" "Install_Dir"

; Tentukan halaman
Page directory
Page instfiles

Var ARCHITECTURE
Var NODE_INSTALLED

Function .onInit
    ; Check system architecture
    ${If} ${RunningX64}
        StrCpy $ARCHITECTURE "x64"
    ${Else}
        StrCpy $ARCHITECTURE "x86"
    ${EndIf}
FunctionEnd

; Tentukan pengaturan default
Section "MainSection" SEC01
    CreateDirectory "C:\h5p\public"
    CreateDirectory "C:\h5p\node_modules"
    CreateDirectory "C:\h5p\uploads"

  ; Tentukan file yang akan disalin
  SetOutPath "C:\h5p"
  File "nodejs-setup32.msi"
  File "nodejs-setup64.msi"
  File "server.exe"
  File "server.js"
  File "package.json"
  File "package-lock.json"

    SetOutPath "C:\h5p\public"
  File /r "public\*.*"

    SetOutPath "C:\h5p\node_modules"
  File /r "node_modules\*.*"
  
  
  ; Instal Node.js
  nsExec::ExecToStack "cmd /C node -v"
    Pop $0
    Pop $1

    ${If} $0 == 0
        StrCpy $NODE_INSTALLED 1
    ${Else}
        StrCpy $NODE_INSTALLED 0
    ${EndIf}

    ${If} $NODE_INSTALLED == 0
        ; Node.js not found, download and install it
        MessageBox MB_OK "Node.js not found. Installing Node.js..."
        
        ; Define Node.js version and URL based on architecture
        ${If} $ARCHITECTURE == "x64"
            ;StrCpy $0 "node-v14.17.0-x64.msi"
            ;StrCpy $1 "https://nodejs.org/dist/v14.17.0/$0"
            StrCpy $0 "nodejs-setup64.msi"
        ${Else}
            ;StrCpy $0 "node-v14.17.0-x86.msi"
            ;StrCpy $1 "https://nodejs.org/dist/v14.17.0/$0"
            StrCpy $0 "nodejs-setup32.msi"
        ${EndIf}
        
        ; Download Node.js installer
        ;nsExec::ExecToLog "powershell -command ""& {Invoke-WebRequest -Uri $1 -OutFile $0}"""
        
        ; Install Node.js
        nsExec::ExecToLog "msiexec /i $0 /quiet"
    ${Else}
        MessageBox MB_OK "Node.js is already installed."
    ${EndIf}
  
  ; Buat shortcut di desktop
  CreateShortCut "$DESKTOP\H5P Presentasi.lnk" "C:\h5p\server.exe"
  CreateShortCut "$DESKTOP\H5P Guru.lnk" "http://localhost:3000/guru"

  ; Create shortcut in the Start Menu
    CreateDirectory "$SMPROGRAMS\H5P"
    CreateShortcut "$SMPROGRAMS\H5P\Server H5P.lnk" "C:\h5p\server.exe" "" "C:\h5p\server.exe" 0
    CreateShortCut "$SMPROGRAMS\H5P\H5P Guru.lnk" "http://localhost:3000/guru"

    WriteUninstaller "C:\h5p\Hapus Presentasi H5P.exe"
    CreateShortcut "$SMPROGRAMS\H5P\Hapus Server H5P.lnk" "C:\h5p\Hapus Presentasi H5P.exe"

SectionEnd

Section "Uninstall"
    ; Remove shortcuts
    Delete "$DESKTOP\H5P.lnk"
    Delete "$DESKTOP\H5P Guru.lnk"
    Delete "$SMPROGRAMS\H5P\Server H5P.lnk"
    Delete "$SMPROGRAMS\H5P\H5P Guru.lnk"
    Delete "$SMPROGRAMS\H5P\Hapus Server H5P.lnk"
    RMDir /r "$SMPROGRAMS\H5P"
    RMDir /r "$INSTDIR"
    ; Finish uninstallation
    MessageBox MB_OK "Uninstallation complete."
SectionEnd