
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
	
