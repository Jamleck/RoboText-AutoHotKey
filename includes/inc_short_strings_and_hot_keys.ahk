;Emails
	:*:mail??::%EMAIL_URL%
	
	:C*P1:a@::
	{
	
		SendMode Event
		SendRaw %EMAIL%
		SendMode Input		
		return
		
	}
	
	:C*P1:b@::
	{
	
		SendMode Event
		SendRaw %EMAIL2%
		SendMode Input		
		return
		
	}

	:C*P1:c@::
	{
	
		SendMode Event
		SendRaw %EMAIL3%
		SendMode Input		
		return
		
	}
	
;DATE & TIME hotkeys

	;YEAR - e.g.  2012
	:*:yyy::
		SendInput %A_YYYY%
	return
	
	;MONTH - e.g. May
	:*:Month?::
	:*:mmm::
		SendInput %A_MMMM%
	return

	;DAY e.g Fri
	:*:day??::
		SendInput %A_DDD%
	return
	
	;TIME e.g 3:47 PM
	:*:time??::
	:*:itime::
	:*:tttt::
		FormatTime, CurrentDateTime,, Time
		SendInput %CurrentDateTime%
	return

	;LONG DATEl
	:*:dddd::
	:*:d8::
	:*:ldate::
		FormatTime, CurrentDateTime,, LongDate
		SendInput %CurrentDateTime%
	return

	;SHOT DATE with _ separator for Naming Files e.g 09_01_2012
	:*:datef::
	:*:d8_::
	:*:date_::
		FormatTime, CurrentDateTime,, dd_MM_yyyy
		SendInput %CurrentDateTime%
	return
	
	;SHOT DATE with - separator for Naming Files
	:*:date-::
	:*:d8-::
		FormatTime, CurrentDateTime,, dd-MM-yyyy
		SendInput %CurrentDateTime%
	return
	
	;SHOT DATE with / separator
	:*:date/::
	:*:d8/::
		FormatTime, CurrentDateTime,, dd/MM/yyyy
		SendInput %CurrentDateTime%
	return
	
	;SHOT reverse DATE with - separator e.g 2013-05-09
	:*:datet::
	:*:d8r::
	:*:daterr::
		FormatTime, CurrentDateTime,, yyyy-MM-dd
		SendInput %CurrentDateTime%
	return

	;;SHOT DATE with -  & DATES 
	:*:date??::
	:*:datess::
		FormatTime, CurrentDateTime,, ShortDate
		SendInput %CurrentDateTime%
	return
	
	;SHOT DATE- for notes 
	:*:ndate::
		FormatTime, CurrentDateTime,, M/d/yyyy h:mm tt  ; It will look like 6/29/2008 10:35 AM
		SendInput %CurrentDateTime%
	return
	
	;Comm With Abbreviation & Date
	:*:JM??::
	{
		FormatTime, CurrentDateTime,, d-MMM-yy
		SendInput //%CurrentDateTime% %Abbreviation%
		return
	}

	;Multi-line comment
	:*:/*::
		SendInput,  /* */{LEFT 3}
	return
	
	;Add space after slash
	#IfWinActive , Microsoft Visual Studio
	:*://::
	{
		SendInput,  //{SPACE}
	}
	#IfWinActive
	
	;Poor man's SnagIt. - Ctrl + Shift + P
	^+p::
	Send !{PrintScreen}
	sleep 200
	
	IfWinExist, Untitled - Paint
		WinActivate ; use the window found above
	else
	{
		Run, mspaint.exe
		sleep 200
		WinActivate, Untitled - Paint
	}
	
	WinWaitActive, ahk_class MSPaintApp
	{
		Sendinput !
		sleep 1000
		Sendinput ^v
		sleep 100
		;;Save image using control s
		;Sendinput {Ctrl down}{s down}{s up}{Ctrl up}
	}
	return
	
	;Enable Paste CTRL+V Paste in the Windows Command Prompt
	#IfWinActive ahk_class ConsoleWindowClass
		^V::
		{
			SendInput {Raw}%clipboard%
			return
		}
	#IfWinActive
	
	;Use the insert key to paste the current clipboard contents
	*Insert::
		Send ^v
	return

	; Transparent using CTRL + ALt + Shift
	^!Space::WinSet, Transparent, 125, A
	^!Space UP::WinSet, Transparent, OFF, A
		
	;Mute Sound by pressing pause once.
	;Start media player by pressing pause twice.
	*Pause::
		if (A_PriorHotkey <> "*Pause" or A_TimeSincePriorHotkey > 500)
		{
			;You Pressed pause once so just toggle the state of the media player
			Send {Media_Play_Pause}
			return
		}
		;Check if WindowsPlayer is active

		;Check if the media player is running
		Process, Exist, wmplayer.exe
		if not ErrorLevel  ; No PID for wmplayer.exe was found.
		{
		
			if FileExist("C:\Program Files\Windows Media Player\wmplayer.exe") 
			{
				if FileExist("C:\Users\jamleckn\Music\Playlists\recently_played_songs.wpl") 
				{
					Run  C:\Program Files\Windows Media Player\wmplayer.exe /open C:\Users\jamleckn\Music\Playlists\recently_played_songs.wpl, C:\Program Files\Windows Media Player\,,
				}else
				{
					Run  C:\Program Files\Windows Media Player\wmplayer.exe
				}

			}
			
		}

	return

	
	;Previous Song -> Win + Left
	#left::
		Send {Media_Prev}
	return

	;Next Song  -> Win + Right
	#right::
		Send {Media_Next}
	return	

	
	;Minimize by pressing Escape twice
	~Esc::
	if (A_PriorHotkey <> "~Esc" or A_TimeSincePriorHotkey > 400)
	{
		; Too much time between presses, so this isn't a double-press.
		KeyWait, Esc
		return
	}
	
	WinMinimize, A
	
	return
	
	:*:temp??::
	{
		FormatTime, TimeString,, dd_MM_yyyy
		
		;The initial file pattern
		FilePattern=C:\TEMP\temp_data_%TimeString%.CSV
		
		count=1
		TempFile := FileExist(FilePattern)
		
		;Don't overwrite the existing files
		While StrLen(TempFile) > 0
		{
			;Add suffix which is the count
			FilePattern=C:\TEMP\temp_data_%TimeString%_%count%.CSV
			TempFile := FileExist(FilePattern)
			count +=1
		}

		FileName=%FilePattern%
		SendInput, %FileName%
		
		return
	}
	
	:*:back??::
	:*:iback::
	{
		FormatTime, TimeString,, dd_MM_yyyy
		
		;The initial file pattern
		FilePattern=C:\data\backups\backup_%TimeString%.CSV
		
		count=1
		TempFile := FileExist(FilePattern)
		
		;Don't overite the existing files
		While StrLen(TempFile) > 0
		{
			;Add suffix which is the count
			FilePattern=C:\data\backups\backup_%TimeString%_%count%.CSV
			TempFile := FileExist(FilePattern)
			count +=1
		}

		FileName=%FilePattern%
		SendInput, %FileName%
		
		return
	}

	

	; 27-09-2013 http://superuser.com/questions/258015/is-it-possible-to-search-an-outlook-folder-with-ctrl-f
	; Search an Outlook folder with Ctrl-F instead of F4
	#IfWinActive, ahk_class rctrl_renwnd32
		^f::Send, {CtrlDown}o{CtrlUp}{F4}
	#IfWinActive

;---------------------------------
; GENERIC VARIBLES
;---------------------------------

	;VAR 0
	*ScrollLock::
	{
		SendVar(0)
		return
	}
	
	;VAR 0
	:*:VV0::
	:*:VVV::
	{
		SendVar(0)
		return
	}

	;VAR 1
	:*:VV1::
	{
		SendVar(1)
		return
	}
	
	;VAR 2
	:*:VV2::
	{
		SendVar(2)
		return
	}

	;VAR 3
	:*:VV3::
	{
		SendVar(3)
		return
	}

	;VAR 4
	:*:VV4::
	{
		SendVar(4)
		return
	}

	;VAR 5
	:*:VV5::
	{
		SendVar(5)
		return
	}
