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
;;  Date: 		13/03/2017	- Brunching testing

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
	CONFIGFILE = %A_ScriptDir%\RoboText.ini

;Email addresses 
	EMAIL1=email_1@example.com
	EMAIL2=email_2@example.com
	
if NOT FileExist(CONFIGFILE)
{
	;Write Settings to the ini file.
	IniWrite, %A_Now%, %CONFIGFILE%, RoboText,CONFIGFILE_CREATED
	IniWrite, %EMAIL1%, %CONFIGFILE%,RoboText, EMAIL1
	IniWrite, %EMAIL2%, %CONFIGFILE%,RoboText, EMAIL2
	TrayTip, RoboText Config File Created, %CONFIGFILE%, 10, 1
} else
{
	IniRead, EMAIL1, %CONFIGFILE%,RoboText, EMAIL1
	IniRead, EMAIL2, %CONFIGFILE%,RoboText, EMAIL2
}

IfNotExist, %NOTES_DIR%
		FileCreateDir, %NOTES_DIR%
			
;---------------------------------
; SET UP TIMERS
;---------------------------------
SetTimer, FiveMinutesTimer, 300000    		; Five Minute timer 5min * 60secs * 1000millesecs = 300000

;---------------------------------
; SET UP MENU
;---------------------------------
Menu, Tray, Tip, RoboText 					 ; Change the tray tip
Menu, Tray, add  							 ; Create a separator line.

;---------------------------------
; AutohotKey OTHER SCRIPTS
;---------------------------------

;Speaker Volume OSD
;  SetWorkingDir %DOWNLOADS_DIR%
;	Run %DOWNLOADS_DIR%\VolumeOSD.ahk

;---------------------------------
; Handle script exit
;---------------------------------

OnExit, ExitSub

;---------------------------------
; SUBROUTINES: Timers
;---------------------------------
FiveMinutesTimer:
	SetTimer, fiveMinutesTimer, Off ;the timer turns itself off here.
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