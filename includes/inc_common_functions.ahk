
CheckDownloadsFolder(tempFolder="C:\temp\Downloads")
{
	global LASTDOWNLOADFILE
	tempDataInputPrefix =temp_data
	tempDataOutputPrefix =test_data
	
	FormatTime, TimeString,, dd_MM_yyyy
	CopySourcePattern=%tempFolder%\*.zip
	
	Loop, %CopySourcePattern%, , 0  ; Recurse into sub-folders.
	{
	
		newFilePath=%A_LoopFileFullPath%

		varTime=%A_Now%
		varModified=%A_LoopFileTimeModified%
		; MsgBox, %varTime% 
		; MsgBox, %varModified% 
		EnvSub, varTime, %varModified%, Minutes
		; MsgBox, %varTime%

		;Only open files created in the last 2 minutes
		if varTime < 1
		{
			if LASTDOWNLOADFILE <> %A_LoopFileName%
			{
				LASTDOWNLOADFILE = %A_LoopFileName%
				DisplayNotice("New Zip File in Downloads folder","Click Here to unzip file","Infor",newFilePath)
			}
		}
	
		Sleep, 500
		
		if a_index > 20
			break  ; Terminate the loop
	}
	return
}

;
; Create a notes list based on the day of the week.
;
CreateToDoListForWeek()
{
	global NOTES_DIR
	
	; current date
	date:= a_now
	
	; day of week (subtract 2; if today is Monday no days should be subtracted)
	dayofwk := A_WDay-2 ; A_WDay is 2 for Monday

	If (A_WDay = 1) ; sun
		date +=1,days
	Else
		date += -%dayofwk%,days
		
	formattime, mmdd_start, %date%,MMMM yyyy_dddd_dd_MMM
	formattime, mmdd_start_title, %date%,MMMM yyyy dddd dd MMM
	
	; find date of following Friday
	date += 4,days
	formattime, mmdd_end, %date%, dddd dd MMM
	formattime, mmdd_end_title, %date%, dddd dd MMM yyyy
	filename=%NOTES_DIR%\NOTES %mmdd_start%_to_%mmdd_end%.txt
	title=NOTES %mmdd_start_title% to %mmdd_end_title%

	if not fileexist(filename)
	{
		fileappend,%title%, %filename%
		
		run %filename%
	}
}

;Check the temp folder for a file matching a pattern
CheckTempFolder(tempFolder="C:\TEMP")
{
	
	tempDataInputPrefix =temp_data
	tempDataOutputPrefix =test_data
	
	FormatTime, TimeString,, dd_MM_yyyy
	CopySourcePattern=%tempFolder%\%tempDataInputPrefix%_*%TimeString%*

	Loop, %CopySourcePattern%, , 1  ; Recurse into subfolders.
	{
		newFilePath = %A_LoopFileDir%\%tempDataOutputPrefix%_%TimeString%-%a_index%-%CurrentDateTime%.%A_LoopFileExt%
			
		while FileExist(newFilePath)
		{
			FormatTime, CurrentDateTime,, H_mm_ss
			newFilePath = %A_LoopFileDir%\%tempDataOutputPrefix%_%TimeString%-%a_index%-%CurrentDateTime%.%A_LoopFileExt%
		}

		;This should never happen 99.9 of the time.
		if FileExist(newFilePath)
		{
			FormatTime, CurrentDateTime,, h_mm_tt
			newFilePath = %A_LoopFileDir%\%tempDataOutputPrefix%_%TimeString%_%a_index%_%CurrentDateTime%.%A_LoopFileExt%
			MsgBox From %A_LoopFileFullPath% to %newFilePath%
		}
		
		FileMove,%A_LoopFileFullPath%,%newFilePath%
		
		if Not FileExist(newFilePath)
		{
			FileCopy,%A_LoopFileFullPath%,%newFilePath%
		}
		
		if FileExist(newFilePath)
		{
			DisplayNotice("New File in Temp folder","Click Here to open file","infor",newFilePath)
		}

		Sleep, 500
		;Run, %newFilePath%
		
		if a_index > 20
			break  ; Terminate the loop
	}
	return
}


DisplayNotice(NoticeTitle,NoticeMessage,MessageType="infor",filePath="EMPTY")
{
	global RESOURCE_DIR
	global TEMPFILE
	TEMPFILE = %filePath%
	
	if  (messageType = "error")
	{
		Gui, Add, Picture, x5 y15, %RESOURCE_DIR%\error-16.png
	}
    else if  (messageType = "warning")
	{
	
		Gui, Add, Picture, x5 y15, %RESOURCE_DIR%\warning-16.png
	} else
	{
		;MessageType = "infor"
				
		Gui, Add, Picture, x5 y15, %RESOURCE_DIR%\information-16.png
	}

	
	Gui, Font, bold
	Gui, Add, Text, cBlack x35 y10 w130 h12, %NoticeTitle%
	Gui, Font, norm
	;
	if  (filePath = "EMPTY" || filePath = "" )
	{
		Gui, Add, Text, cBlack x35 y28 w280 h13, %NoticeMessage%
		
	} else
	{
		Gui, Font, underline
		Gui, Add, Text, cBlue gOpenFileNoticeFile x35 y28 w280 h13, %NoticeMessage%
	}
	
	Gui, Font, norm
	Gui -Caption +Border +AlwaysOnTop
	;WinMove, Users,, (A_ScreenWidth*2)-(Width), (A_ScreenHeight)-(Height+10)
	;Get the X & Y position
	xPosition:= A_ScreenWidth-280-8
	yPosition:= A_ScreenHeight-60-35
	;Gui, Show, x%xPosition% y%yPosition% NoActivate h60 w180

	Gui, Color, White
	Gui +LastFound  ; Make the GUI window the last found window for use by the line below.
	
	Loop 22
	{
		num:=A_Index*3
		xPosition:= A_ScreenWidth-280-8
		yPosition:= A_ScreenHeight-30-num
		Gui, Show, x%xPosition% y%yPosition% NoActivate h60 w280
		
		;Gui Flash
		Sleep 10  ; It's quite sensitive to this value; altering it may change the behaviour in unexpected ways.
		
	}
	
	Sleep 6000
	
	Loop 22
	{
		num:=A_Index*3
		xPosition:= A_ScreenWidth-280-8
		yPosition:= A_ScreenHeight-30-66+num
		
		Gui, Show, x%xPosition% y%yPosition% NoActivate h60 w280
		
		;Gui Flash
		Sleep 10  ; It's quite sensitive to this value; altering it may change the behaviour in unexpected ways.
	}
	
	Gui, Destroy
	TEMPFILE = ""
}

DisplayFileNotice(filePath)
{
	global RESOURCE_DIR
	global TEMPFILE
	TEMPFILE = %filePath%
	
	Gui, Add, Picture, x5 y15, %RESOURCE_DIR%\downloadIcon.png
	Gui, Font, bold
	Gui, Add, Text, cBlack x35 y10 w130 h12, New File
	Gui, Font, norm
	Gui, Font, underline
	Gui, Add, Text, cBlue gOpenFileNoticeFile x35 y28 w140 h13, Click here to Open File.
	Gui, Font, norm
	Gui -Caption +Border
	;WinMove, Users,, (A_ScreenWidth*2)-(Width), (A_ScreenHeight)-(Height+10)
	;Get the X & Y position
	xPosition:= A_ScreenWidth-180-8
	yPosition:= A_ScreenHeight-60-35
	;Gui, Show, x%xPosition% y%yPosition% h60 w180

	Gui, Color, White
	Gui +LastFound  ; Make the GUI window the last found window for use by the line below.
	
	Loop 22
	{
		num:=A_Index*3
		xPosition:= A_ScreenWidth-180-8
		yPosition:= A_ScreenHeight-30-num
		Gui, Show, x%xPosition% y%yPosition% h60 w180
		
		;Gui Flash
		Sleep 10  ; It's quite sensitive to this value; altering it may change the behaviour in unexpected ways.
		
	}
	
	Sleep 3000
	
	Loop 22
	{
		num:=A_Index*3
		xPosition:= A_ScreenWidth-180-8
		yPosition:= A_ScreenHeight-30-66+num
		
		Gui, Show, x%xPosition% y%yPosition% h60 w180
		
		;Gui Flash
		Sleep 10  ; It's quite sensitive to this value; altering it may change the behavior in unexpected ways.
	}
	
	Gui, Destroy
	TEMPFILE = ""
}

OpenFileNoticeFile:
	;	global TEMPFILE
	
	SplitPath, TEMPFILE, name, dir, ext, name_no_ext, drive
	
	if ext = zip
	{
		RUN, %A_ScriptDir%\scripts\unzip.bat "%TEMPFILE%"
		
	} else
	{
		Run, %TEMPFILE%
	}
return

MonitorFolder()
{

	CopySourcePattern=C:\TEMP\monitor\*.*
	
	Loop, %CopySourcePattern%
	{
		Run, %A_LoopFileFullPath%,
		if a_index > 10
			break  ; Terminate the loop
	}

	return
}


SwitchOffMonitor()
{
	Sleep 1000
	; Turn Monitor Off 
	SendMessage, 0x112, 0xF170, 2,, Program Manager   

	; Turn 	Monitor On
	;SendMessage, 0x112, 0xF170, -1,, Program Manager  
	; (2 = off, 1 = standby, -1 = on)

}
	

SwitchOnMonitor()
{
	Sleep 1000 ; if you use this with a hotkey, not sleeping will make it so your keyboard input wakes up the monitor immediately
	; SendMessage 0x112, 0xF170, 1,,Program Manager ; send the monitor into standby (off) mode
	; SendMessage 0x112, 0xF140, 0, , Program Manager
		; Turn Monitor On
	SendMessage, 0x112, 0xF170, -1,, Program Manager  
	; (2 = off, 1 = standby, -1 = on)
}

LockComputer()
{
	DllCall("LockWorkStation")
}


;Sleeps for a specified number of minutes
SleepMinutes(minutes)
{
   SleepSeconds(minutes*60)
}

;Sleeps for a specified number of seconds
SleepSeconds(seconds)
{
   Sleep 1000*seconds
}

;Send a variable v1 to v5  & store the current variable in CurrentVar
SendVar(varIdex)
{
	global CurrentVar

	if varIdex < 0
	{
		AutoTrim, On
		ClipBoardVariable = %clipboard%
		AutoTrim, Off
		
		if (StrLen(ClipBoardVariable) > 0)
		{
			SendInput %ClipBoardVariable%
		}Else
		{
			global CurrentVar
			SendInput %CurrentVar%
		}
		
	}
	else if varIdex = 0
	{
		global CurrentVar
		SendInput %CurrentVar%
	}
	else if varIdex = 1
	{
		global VAR1
		SendInput %VAR1%
		CurrentVar := VAR1
	}
	else if varIdex = 2
	{
		global VAR2
		SendInput %VAR2%
		CurrentVar := VAR2
	}
	else if varIdex = 3
	{
		global VAR3
		SendInput %VAR3%
		CurrentVar := VAR3
	}
	
		else if varIdex = 4
	{
		global VAR4
		SendInput %VAR4%
		CurrentVar := VAR4
	}
	
		else if varIdex >= 5
	{
		global VAR5
		SendInput %VAR5%
		CurrentVar := VAR5
	}

}

	
