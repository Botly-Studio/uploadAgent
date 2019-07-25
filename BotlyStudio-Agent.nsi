;======================================================
; Include
 
  !include "MUI.nsh"
 
;======================================================
; Installer Information
 
  Name "BotlyStudio-Agent"
  OutFile "BotlyStudio-Agent_Windows_x64_x86.exe"
  InstallDir $APPDATA\BotlyStudio-Agent
  
;======================================================
; Modern Interface Configuration
 
  !define MUI_HEADERIMAGE
  !define MUI_ABORTWARNING
  !define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
  !define MUI_FINISHPAGE
  !define MUI_UNINSTALLER
  !define MUI_FINISHPAGE_TEXT "Merci d'avoir installer BotlyStudio-Agent. \r\n"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "botly.bmp"
  !define MUI_ICON "tray_iconWin.ico"
  !define MUI_FINISHPAGE_RUN
  !define MUI_FINISHPAGE_RUN_TEXT "Lancer"
  !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"

 
;======================================================
; Pages
 
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
 
;======================================================
; Languages
 
  !insertmacro MUI_LANGUAGE "French"
 
 
;======================================================
; Sections
 
Section "Installation" fullInstallSection
 
  SetOutPath $INSTDIR
 
  File "BotlyStudio_Create_Bridge.exe"
  File "BotlyStudio_Create_Bridge_cli.exe"
  File "certmgr.exe"
  File "config.ini"
  File "tray_iconWin.ico"
 
 
;create startup shortcut
  CreateShortCut "$SMSTARTUP\BotlyStudio-Agent.lnk" "$INSTDIR\BotlyStudio_Create_Bridge.exe" ""
 
;create start-menu items
  CreateDirectory "$SMPROGRAMS\BotlyStudio-Agent"
  CreateShortCut "$SMPROGRAMS\BotlyStudio-Agent\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\BotlyStudio-Agent\BotlyStudio-Agent.lnk" "$INSTDIR\BotlyStudio_Create_Bridge.exe" "" "$INSTDIR\BotlyStudio_Create_Bridge.exe" 0
 
 
;write uninstall information to the registry
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BotlyStudio-Agent" "DisplayName" "BotlyStudio-Agent (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BotlyStudio-Agent" "UninstallString" "$INSTDIR\Uninstall.exe"
 
  WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd


;--------------------------------    
;Uninstaller Section  
Section "Uninstall"
 
	StrCpy $0 "BotlyStudio_Create_Bridge.exe"
    DetailPrint "Searching for processes called '$0'"
    KillProc::FindProcesses
    DetailPrint "-> Found $0 processes"
 
    Sleep 1500
  
	StrCpy $0 "BotlyStudio_Create_Bridge.exe"
    DetailPrint "Killing all processes called '$0'"
    KillProc::KillProcesses
    DetailPrint "-> Killed $0 processes, failed to kill $1 processes"
  
 
;Delete Files 
  RMDir /r "$INSTDIR\*.*"    
  RMDir /r "$PROFILE\.arduino-create\*.*"
 
;Remove the installation directory
  RMDir "$INSTDIR"
  RMDir "$PROFILE\.arduino-create"
 
;Delete Start Menu Shortcuts
  Delete "$SMSTARTUP\BotlyStudio-Agent.lnk"
  Delete "$SMPROGRAMS\BotlyStudio-Agent\*.*"
  RMDir  "$SMPROGRAMS\BotlyStudio-Agent"
 
 ;Delete Uninstaller And Unistall Registry Entries
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\BotlyStudio-Agent"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\BotlyStudio-Agent"  
 
SectionEnd
 
 
Function LaunchLink
  ExecShell "" "$SMPROGRAMS\BotlyStudio-Agent\BotlyStudio-Agent.lnk"
FunctionEnd