#Requires AutoHotkey v2.0.11+
#SingleInstance Force

#include Array.ahk
;#include <peep>

/* months := ["Jan", "March", "April", "June"]
x := months.unshift("July", "August", "September")
msgbox(x)
msgbox(months.join())
peep(months) */

numbers := ["4", "5", "6", "7"]
moreNumbers := ["1", "2", "3"]
moreNumbers.push(numbers*) 				;push is working
msgbox('more:' moreNumbers.join())		;this correctly shows ["1", "2", "3", "4", "5", "6", "7"]
x := numbers.unshift(moreNumbers)				;this correctly returns 7 but does not mutate the array

msgbox(x)								;print => 7
MsgBox(numbers.join())					;prints => ["4", "5", "6", "7"] ????


;MsgBox(arr.every(value => (value < 4)))

;arr.fill(4)

;new := arr.filter(item => item < 4)

;peep(new)

/* flatArr := [1, [2, [5,6,7,8], 3], 4, [5, 6, 7]]
newArr := flatArr.flat() */

;Peep(newArr)



/*
Print(string){
	ListVars
	WinWait ahk_id %A_ScriptHwnd%
	ControlSetText Edit1, %string%
	WinWaitClose
}


PrintDebug(string:=""){
	Static
	string := string ? string . "`r`n" . lastStr : "", lastStr := string
	If !WinActive("ahk_class AutoHotkey"){
		ListVars
		WinWait('ahk_id' A_ScriptHwnd)
		title := WinGetTitle('ahk_id' A_ScriptHwnd)
	} else If !string{
		PostMessage(0x112, 0xF060,,, title) ; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
		Return
	}
	ControlSetText(string, , 'ahk_id' A_ScriptHwnd)
}


/*
StdExit(){
	If GetScriptParentProcess() = "cmd.exe"		;couldn't get this: 'DllCall("GenerateConsoleCtrlEvent", CTRL_C_EVENT, 0)' to work so...
		ControlSend('{Enter}', "ahk_pid " . GetParentProcess(GetCurrentProcess()))
}

Stdout(output:="", sciteCheck := true){	;output to console	-	sciteCheck reduces Stdout/Stdin performance,so where performance is necessary disable it accordingly
	Global ___console___																											;CONOUT$ is a special file windows uses to expose attached console output
	( output ? ( !___console___? (DllCall("AttachConsole", "int", -1) || DllCall("AllocConsole")) & (___console___:= true) : "" ) & FileAppend(output . "`n","CONOUT$") : DllCall("FreeConsole") & (___console___:= false) & StdExit() )
}
FileReadLine(file,lineNum){
	retVal := FileReadLine(file, lineNum)
	return retVal
}

ProcessExist(procName){
	if ProcessExist(procName)
	    return 0
    else
        return 1
}

GetScriptParentProcess(){
	return GetProcessName(GetParentProcess(GetCurrentProcess()))
}

GetParentProcess(PID)
{
	static function := DllCall("GetProcAddress", "ptr", DllCall("GetModuleHandle", "str", "kernel32.dll", "ptr"), "astr", "Process32Next" ("W"), "ptr")
	if !(h := DllCall("CreateToolhelp32Snapshot", "uint", 2, "uint", 0))
		return
	VarSetStrCapacity(&pEntry, sz := (A_PtrSize = 8 ? 48 : 36 ) + 520)
	Numput(sz, pEntry, 0, "uint")
	DllCall("Process32First" ("W"), "ptr", h, "ptr", &pEntry)
	loop
	{
		if (pid = NumGet(pEntry, 8, "uint") || !DllCall(function, "ptr", h, "ptr", &pEntry))
			break
	}
	DllCall("CloseHandle", "ptr", h)
	return Numget(pEntry, 16+2*A_PtrSize, "uint")
}

GetProcessName(PID)
{
	static function := DllCall("GetProcAddress", "ptr", DllCall("GetModuleHandle", "str", "kernel32.dll", "ptr"), "astr", "Process32Next" "W", "ptr")
	if !(h := DllCall("CreateToolhelp32Snapshot", "uint", 2, "uint", 0))
		return
	VarSetStrCapacity(&pEntry, sz := (A_PtrSize = 8 ? 48 : 36)+260*2)
	Numput(sz, pEntry, 0, "uint")
	DllCall("Process32First" "W", "ptr", h, "ptr", &pEntry)
	loop
	{
		if (pid = NumGet(pEntry, 8, "uint") || !DllCall(function, "ptr", h, "ptr", &pEntry))
			break
	}
	DllCall("CloseHandle", "ptr", h)
	return StrGet(pEntry+28+2*A_PtrSize, "utf-16")
}

GetCurrentProcess()
{
	return DllCall("GetCurrentProcessId")
}