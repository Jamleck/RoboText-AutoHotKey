;;
;; RoboText.ahk
;;	
;;	Purpose:    My collection of AutohotKey scripts and hotkeys
;;
;;  Author:     Jamleck - Jamleck.com
;;  Date:		20/01/2010  - Start
;;  Date:		20/09/2012  - Added timers.
;;  Date:		08/05/2013  - Joined CC
;;  Date: 		09/05/2014	- Rewritten to use a .ini file for configuration.

;---------------------------------
; CONFIGURATION
;---------------------------------
	SetBatchLines -1
	ListLines Off
	#NoEnv
	#SingleInstance force
	#WinActivateForce
	#Persistent
	SendMode Input				;superior speed and reliability.
	SetWorkingDir %A_ScriptDir%	; Ensures a consistent starting directory.
	Process,Priority,,High
	
;---------------------------------
; VARIABLES
;---------------------------------
	RESOURCE_DIR=%A_ScriptDir%\resources
	INCLUDES_DIR= %A_ScriptDir%\includes
	DOWNLOADS_DIR=  %A_ScriptDir%\downloaded-ahk-scripts
	WORDLIST = %RESOURCE_DIR%\word_list.txt
	CONFIGFILE = %A_ScriptDir%\RoboText.ini
	TEMP_DIR = %A_ScriptDir%\temp_files 	; temporally directory
	TEMPFILE = C:\TEMP\TEMPFILE.txt
	LOGFILE = %TEMP_DIR%\RoboTextLog.log 	;Log File
	ABBREVIATION	= ABBREVIATION
	PROJECTS_DIR = C:\projects
	NOTES_DIR = %PROJECTS_DIR%\Notes
	WORK_COMPUTER = COMPUTER-WORK
	HOME_COMPUTER = COMPUTER-HOME
	EMAIL_URL = gmail.com

;DEFAULT VARIABLES - VAR 1 to 5.
	VAR1 = SETVAR1
	VAR2 = SETVAR2
	VAR3 = SETVAR3
	VAR4 = SETVAR4
	VAR5 = SETVAR5
	CURRENTVAR:= VAR1
	
;Email addresses - Email 1 to 4
	EMAIL=email_1@example.com
	EMAIL2=email_2@example.com
	EMAIL3=email_3@example.com
	EMAIL4=email_4@example.com
	
if NOT FileExist(CONFIGFILE)
{
	;Write Settings to the ini file.
	IniWrite, %A_Now%, %CONFIGFILE%, RoboText,CONFIGFILE_CREATED
	IniWrite, %WORDLIST%, %CONFIGFILE%, RoboText, WORDLIST
	IniWrite, %ABBREVIATION%, %CONFIGFILE%, RoboText, ABBREVIATION
	IniWrite, %TEMP_DIR%, %CONFIGFILE%, RoboText, TEMP_DIR
	IniWrite, %EMAIL_URL%, %CONFIGFILE%, RoboText,EMAIL_URL
	IniWrite, %EMAIL%, %CONFIGFILE%,RoboText, EMAIL
	IniWrite, %EMAIL2%, %CONFIGFILE%,RoboText, EMAIL2
	IniWrite, %EMAIL3%, %CONFIGFILE%,RoboText, EMAIL3
	IniWrite, %EMAIL4%, %CONFIGFILE%,RoboText, EMAIL4
	IniWrite, %LOGFILE%, %CONFIGFILE%,RoboText, LOGFILE
	IniWrite, %INCLUDES_DIR%, %CONFIGFILE%, RoboText,INCLUDES_DIR
	IniWrite, %DOWNLOADS_DIR%, %CONFIGFILE%, RoboText, DOWNLOADS_DIR
	IniWrite, %PROJECTS_DIR%, %CONFIGFILE%, RoboText, PROJECTS_DIR
	IniWrite, %NOTES_DIR%, %CONFIGFILE%, RoboText, NOTES_DIR
	IniWrite, %VAR1%, %CONFIGFILE%, VARIABLES,VAR1
	IniWrite, %VAR2%, %CONFIGFILE%, VARIABLES,VAR2
	IniWrite, %VAR3%, %CONFIGFILE%, VARIABLES,VAR3
	IniWrite, %VAR4%, %CONFIGFILE%, VARIABLES,VAR4
	IniWrite, %VAR5%, %CONFIGFILE%, VARIABLES,VAR5
	IniWrite, %VAR5%, %CONFIGFILE%, VARIABLES,VAR5
	
	TrayTip, RoboText Config File Created, %CONFIGFILE%, 10, 1
} else
{
	IniRead, WORDLIST, %CONFIGFILE%, RoboText, WORDLIST
	IniRead, ABBREVIATION, %CONFIGFILE%, RoboText, ABBREVIATION
	IniRead, TEMP_DIR, %CONFIGFILE%, RoboText, TEMP_DIR
	IniRead, EMAIL_URL, %CONFIGFILE%,RoboText, EMAIL_URL
	IniRead, EMAIL, %CONFIGFILE%,RoboText, EMAIL
	IniRead, EMAIL2, %CONFIGFILE%,RoboText, EMAIL2
	IniRead, EMAIL3, %CONFIGFILE%,RoboText, EMAIL3
	IniRead, EMAIL4, %CONFIGFILE%,RoboText, EMAIL4
	IniRead, LOGFILE, %CONFIGFILE%,RoboText, LOGFILE
	IniRead, LOGFILE, %CONFIGFILE%,RoboText, LOGFILE
	IniRead, INCLUDES_DIR, %CONFIGFILE%, RoboText,INCLUDES_DIR
	IniRead, DOWNLOADS_DIR, %CONFIGFILE%, RoboText, DOWNLOADS_DIR
	IniRead, PROJECTS_DIR, %CONFIGFILE%, RoboText, PROJECTS_DIR
	IniRead, NOTES_DIR, %CONFIGFILE%, RoboText, NOTES_DIR
	IniRead, VAR1, %CONFIGFILE%, VARIABLES,VAR1
	IniRead, VAR2, %CONFIGFILE%, VARIABLES,VAR2
	IniRead, VAR3, %CONFIGFILE%, VARIABLES,VAR3
	IniRead, VAR4, %CONFIGFILE%, VARIABLES,VAR4
	IniRead, VAR5, %CONFIGFILE%, VARIABLES,VAR5
	IniRead, CURRENTVAR, %CONFIGFILE%, VARIABLES,CURRENTVAR
}

;CREATE DIRECTORIES IF THEY ARE MISSING
IfNotExist, %RESOURCE_DIR%
		FileCreateDir, %RESOURCE_DIR%

IfNotExist, %TEMP_DIR%
		FileCreateDir, %TEMP_DIR%

IfNotExist, %INCLUDES_DIR%
		FileCreateDir, %INCLUDES_DIR%

IfNotExist, %DOWNLOADS_DIR%
		FileCreateDir, %DOWNLOADS_DIR%

IfNotExist, %PROJECTS_DIR%
		FileCreateDir, %PROJECTS_DIR%
		
IfNotExist, %NOTES_DIR%
		FileCreateDir, %NOTES_DIR%
			
;---------------------------------
; SET UP TIMERS
;---------------------------------
SetTimer, TwoFiftyMillisecond, 250    		; 250 Millisecond timer
SetTimer, OneSecondTimer, 1000		  		; 1 Second timer or 1000 Millisecond timer
SetTimer, FiveSecondsTimer, 5000 	  		; 5 Second timer
SetTimer, FiveMinutesTimer, 300000    		; Five Minute timer 5min * 60secs * 1000millesecs = 300000
SetTimer, TenMinutesTimer, 600000 	  		; Ten Minute timer 10min * 60secs * 1000millesecs = 600000
SetTimer, SixHourTimer, 21600000 	  		; 6 hrs = 6 * 60min * 60secs * 1000millesecs = 21600000

;---------------------------------
; SET UP MENU
;---------------------------------
Menu, Tray, Tip, RoboText 					 ; Change the tray tip
Menu, Tray, add  							 ; Create a separator line.
Menu, Tray, add, Set Variable, MenuHandler   ; Create a new menu item.

;---------------------------------
; AutohotKey OTHER SCRIPTS
;---------------------------------

;AutoCorrect for English
 SetWorkingDir %DOWNLOADS_DIR%
	Run %DOWNLOADS_DIR%\AutoCorrect.ahk

;Speaker Volume OSD
  SetWorkingDir %DOWNLOADS_DIR%
	Run %DOWNLOADS_DIR%\VolumeOSD.ahk

;CreateToDoListForWeek()

;---------------------------------
; Handle script exit
;---------------------------------

OnExit, ExitSub

;---------------------------------
; SUBROUTINES: Timers
;---------------------------------
twoFiftyMillisecond:

	SetTimer, twoFiftyMillisecond, Off ;the timer turns itself off here.
	
return


OneSecondTimer:

	CheckDownloadsFolder()
	CheckTempFolder()
	
return


FiveSecondsTimer:

	;SetTimer, fiveSecondsTimer, Off ;the timer turns itself off here.
	
return


FiveMinutesTimer:

	SetTimer, fiveMinutesTimer, Off ;the timer turns itself off here.
	
return


TenMinutesTimer:

	;If the computer has been idle for 30 minutes switch of the monitor
	;3600000=60 Minutes *60Seconds *1000 MilliSeconds
	IfGreater, A_TimeIdle, 3600000
	{
		DllCall("LockWorkStation")
		Sleep 500
		SwitchOffMonitor()
		;MsgBox Monitor Switched off...

	}
	
	;SetTimer, TenMinutesTimer, Off ;the timer turns itself off here.
	CreateToDoListForWeek()

return


SixHourTimer:

	;1800000=30 Minutes *60Seconds *1000 MilliSeconds
	IfGreater, A_TimeIdle, 1800000
	{

	}

return


MenuHandler:

	AutoTrim, On
	ClipBoardVariable = %clipboard%
	AutoTrim, Off

	InputBox, UserInput, Variable, Please enter the default variable., , 250, 120,A_ScreenWidth-255,A_ScreenHeight-150,,,%ClipBoardVariable%

	if ErrorLevel || StrLen(UserInput) <= 0
	{
		; Do nothing.
	}
	else
	{

		VAR5=%VAR4%
		VAR4=%VAR3%
		VAR3=%VAR2%
		VAR2=%VAR1%
		VAR1=%UserInput%
		CURRENTVAR:= VAR1
		IniWrite, %VAR1%, %CONFIGFILE%, VARIABLES,VAR1
		IniWrite, %VAR2%, %CONFIGFILE%, VARIABLES,VAR2
		IniWrite, %VAR3%, %CONFIGFILE%, VARIABLES,VAR3
		IniWrite, %VAR4%, %CONFIGFILE%, VARIABLES,VAR4
		IniWrite, %VAR5%, %CONFIGFILE%, VARIABLES,VAR5
		IniWrite, %CURRENTVAR%, %CONFIGFILE%, VARIABLES,CURRENTVAR

		; Add to log what variable we just used for future reference.
		FormatTime, CurrentDateTime,, ddd MMM dd yyyy HH:mm:ss
		; It will look like 6/29/2008 10:35 AM
		FileAppend, [%CurrentDateTime%] `tUsing variable %VAR1%.`n, %LOGFILE%

	}

return


ExitSub:
	if A_ExitReason not in Logoff,Shutdown  ; Avoid spaces around the comma in this line.
	{
		SetTitleMatchMode 2
		;Terminate all open scripts
		DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
		SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
		WinClose  AutoCorrect.ahk  ; Update this to reflect the script's name (case sensitive).
		WinClose VolumeOSD.ahk  ; Update this to reflect the script's name (case sensitive).
	}
	ExitApp
return

;---------------------------------
; INCLUDE FILES HOTKEYS
;---------------------------------
#include includes\inc_short_strings_and_hot_keys.ahk ; various short string & hot keys
#include includes\inc_common_functions.ahk ;various functions

^#x::ExitApp   		;Ctrl + Win + X terminate the script
^#space::Pause 		;Ctrl + Win + Space to pause the script
^#r::Reload  		;Ctrl + Win + r restart the script
^#e::edit  ;ad  	;Ctrl + Win + e opens the script for editing

;---------------------------------
; PERFORM DAILY TESTS
;---------------------------------



;IDEAS
;BACKUP CHECK
;PERFORM DAILY AND WEEKLY TESTS
;DaysSinceLastBackupCheck = %A_Now%
;EnvSub, DaysSinceLastBackupCheck,  %LAST_BACKUP_CHECK%, days
;
;if DaysSinceLastBackupCheck >= 1
;{
;	CheckBackups(0)
;}
