;Emails
	:*:mail??::%EMAIL_URL%
	
	:C*P1:j@::
	{
	
		SendMode Event
		SendRaw %EMAIL1%
		SendMode Input		
		return
		
	}
	
	:C*P1:c@::
	{
	
		SendMode Event
		SendRaw %EMAIL2%
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
		FormatTime, CurrentDateTime,, dd/MM/yyyy
		SendInput %CurrentDateTime%
	return
	
	;SHOT reverse DATE with - separator e.g 2013-05-09
	:*:datet::
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
	
	;Add space after slash
	#IfWinActive , Microsoft Visual Studio
	:*://::
	{
		SendInput,  //{SPACE}
	}
	#IfWinActive
		
	;Enable Paste CTRL+V Paste in the Windows Command Prompt
	#IfWinActive ahk_class ConsoleWindowClass
		^V::
		{
			SendInput {Raw}%clipboard%
			return
		}
	#IfWinActive
		
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

	; 27-09-2013 http://superuser.com/questions/258015/is-it-possible-to-search-an-outlook-folder-with-ctrl-f
	; Search an Outlook folder with Ctrl-F instead of F4
	#IfWinActive, ahk_class rctrl_renwnd32
		^f::Send, {CtrlDown}o{CtrlUp}{F4}
	#IfWinActive