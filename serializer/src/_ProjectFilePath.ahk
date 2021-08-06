getProjectPathFromMenu(filename) {
   local
   Prev_DetectHiddenWindows := A_DetectHiddenWindows
   DetectHiddenWindows, On
   WinGet, Hwnd, ID, ahk_class SmtgMain MenuWindowClass
   DetectHiddenWindows, %Prev_DetectHiddenWindows%
   VarSetCapacity(menuStr, 260)
   menuHWnd            := DllCall("GetMenu", UInt, Hwnd, Uint) 
   , fileSubMenuHwnd   := DllCall("GetSubMenu", UInt, menuHwnd , int, 0) 
   , recentSubMenuHwnd := DllCall("GetSubMenu", UInt, fileSubMenuHwnd , int, 20)
   loop, 10 {
      submenuid          := DllCall("GetMenuItemID", Uint, recentSubMenuHwnd, Uint, A_Index-1, uint)
      , menuStringResult := DllCall("GetMenuString" , Uint, recentSubMenuHwnd, uint, submenuid, "str", menuStr, int, 260, uint, 0x0000)
      if InStr(menuStr, filename . ".cpr") {
         RegExMatch(menuStr, "(?<=\s)(.*?(?=$|\\" . filename . "\.cpr))", projectpath)
         return projectpath
      } 
   }
   return ""
}

getProjectPathFromLnk(filename) {
   local
	static recentPath := A_AppData . "\Microsoft\Windows\Recent\"
	lnkFile := FileOpen(recentPath . filename . ".cpr.lnk", "r")
	If !IsObject(lnkFile)
		return ""
	lnkFile.Pos := 76, lnkBinData := ""
	lnkFile.RawRead(rawBin, lnkFile.length - 76)
	loop, % lnkFile.length - 80
		lnkBinData .= Format("{:02X}", NumGet(&rawBin + 0, A_Index - 1, "UChar"))
	lnkFile.close()
	readPos := StrLen(lnkBinData)-1
	loop
	{
		if (SubStr(lnkBinData, readPos, 2) = "3A")
			break
		if ((readPos -= 2) < 1)
			return ""
	}
	spacedHex := SubStr(lnkBinData, readPos-4)
	, workingDirStr := "", ascHex := ""
   Loop, Parse, spacedHex
   {
      if (Mod(A_Index, 4) = 1)
         ascHex := A_LoopField
      if (Mod(A_Index, 4) = 2)
      {
         ascHex .= A_LoopField
         , workingDirStr .= Chr("0x" ascHex)
      }
   }
   return workingDirStr
}

getProjectPathFromXML(filename, cubaseVersion) {
   local
	FileRead, defaultsdotxml, %A_AppData%\Steinberg\Cubase %cubaseVersion%_64\Defaults.xml
	readPos := InStr(defaultsdotxml, filename ".cpr")
	RegExMatch(defaultsdotxml, "(?<=Path"" value="")(.*?(?="" wide))", wpath, readPos)
	return (wPath) ? wPath : 0
}

getProjectPathFromOpenHandles(procName:="Cubase10.5.exe") {
   local
	; Requires that you have a blank "frozen" audio track in the project
	; SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX
	; https://www.geoffchappell.com/studies/windows/km/ntoskrnl/api/ex/sysinfo/handle_ex.htm
	; https://www.geoffchappell.com/studies/windows/km/ntoskrnl/api/ex/sysinfo/handle_table_entry_ex.htm
	static PROCESS_DUP_HANDLE := 0x0040, SystemExtendedHandleInformation := 0x40, DUPLICATE_SAME_ACCESS := 0x2
		  , FILE_TYPE_DISK := 1, structSize := A_PtrSize*3 + 16 ; size of SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX
	Process, Exist, % procName
	if !(PID := ErrorLevel)
		return
	hProcess := DllCall("OpenProcess", "UInt", PROCESS_DUP_HANDLE, "UInt", 0, "UInt", PID)
	arr := {}, lpTargetHandle := ""
	res := size := 1
	while res != 0 {
		VarSetCapacity(buff, size, 0)
		res := DllCall("ntdll\NtQuerySystemInformation", "Int", SystemExtendedHandleInformation, "Ptr", &buff, "UInt", size, "UIntP", size, "UInt")
	}
	NumberOfHandles := NumGet(buff)
	VarSetCapacity(filePath, 1026)
	Loop % NumberOfHandles - 50000 {
		ProcessId := NumGet(buff, A_PtrSize*2 + structSize*(A_Index + 50000) + A_PtrSize, "UInt")
		if (PID = ProcessId) {
			HandleValue := NumGet(buff, A_PtrSize*2 + structSize*(A_Index + 50000) + A_PtrSize*2)
			DllCall("DuplicateHandle", "Ptr", hProcess, "Ptr", HandleValue, "Ptr", DllCall("GetCurrentProcess")
											 , "PtrP", lpTargetHandle, "UInt", 0, "UInt", 0, "UInt", DUPLICATE_SAME_ACCESS)
			if DllCall("GetFileType", "Ptr", lpTargetHandle) = FILE_TYPE_DISK
				&& DllCall("GetFinalPathNameByHandle", "Ptr", lpTargetHandle, "Str", filePath, "UInt", 512, "UInt", 0)
					if InStr(filepath, "Freeze") {
						RegExMatch(filepath, "(?<=\\\\\?\\)(.*)(?=Freeze)", match)
						DllCall("CloseHandle", "Ptr", lpTargetHandle)
						break
					}
			DllCall("CloseHandle", "Ptr", lpTargetHandle)
		}
	}
	DllCall("CloseHandle", "Ptr", hProcess)
	Return match
}

getFileDateModified(inFile) {
   local
	Static bSize := (A_PtrSize=8)?40:36
	VarSetCapacity(bFileAttribs,bSize,0) ; https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfileattributesexw
	if !( r := DllCall("GetFileAttributesExW","Str","\\?\" inFile,"Int",0,"Ptr",p2 := &bFileAttribs) ) ; (A_IsUnicode ? "W" : "A") ; (A_IsUnicode ? "\\?\" : "")
		return 0

	VarSetCapacity(SYSTEMTIME,16,0) ; https://docs.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-systemtime
	r := DllCall("FileTimeToSystemTime","Ptr",p2+20,"Ptr",&SYSTEMTIME) ; https://docs.microsoft.com/en-us/windows/win32/api/timezoneapi/nf-timezoneapi-filetimetosystemtime
  
	year  := NumGet(SYSTEMTIME,"UShort"),                     hour   := Format("{:02d}",NumGet(SYSTEMTIME,8,"UShort"))
	month := Format("{:02d}",NumGet(SYSTEMTIME,2,"UShort")),  minute := Format("{:02d}",NumGet(SYSTEMTIME,10,"UShort"))
	day   := Format("{:02d}",NumGet(SYSTEMTIME,6,"UShort")),  second := Format("{:02d}",NumGet(SYSTEMTIME,12,"UShort"))
	 
	return year month day hour minute second
}