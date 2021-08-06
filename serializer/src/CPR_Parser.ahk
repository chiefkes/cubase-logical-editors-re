class CPR_Parser {
   #include src\Import_MTrack.ahk
   #include src\_CPR_io.ahk

   __New(CubaseVersion) {
      this.CubaseVersion := CubaseVersion
      this.UpdateFilePath()
   }

   UpdateFilePath() {
      if !this.GetActiveProjectFilePath() {
         Msgbox, Failed to Update Project File Path
         Exit
      }
      return 1
   }

   getActiveProjectFilePath() {
      ; add logic for if window title name contains .bak to skip checking most recent and directly open the .bak
      ; remove RunCMD
      local
      if !WinExist("ahk_class SteinbergWindowClass")
         return 0
      WinGetTitle, title, ahk_group ProjectWindow
      if !(title := RegExReplace(title, ".*(?= - ) - "))
         return 0
      if (title != this.Curr_title) {
         this.Curr_title := title

         ; first try matching to a recent project path listed under File > Recent Projects
         if (wPath := getProjectPathFromMenu(title))
            this.Curr_FilePathNoExt := wpath . "\" . title

         ; try matching to an .lnk in the %AppData%\Microsoft\Windows\Recent\ directory
         else if (wPath := getProjectPathFromLnk(title))
            this.Curr_FilePathNoExt := wpath . "\" . title

         ; try the Cubase defaults.xml
         else if ( wPath := getProjectPathFromXML(title, this.CubaseVersion) )
            this.Curr_FilePathNoExt := wpath . title

         ; try via a list of Open file handles (only works if the project has some audio or dummy audio files)
         else if ( wPath := getProjectPathFromOpenHandles("Cubase" this.CubaseVersion ".exe") )
            this.Curr_FilePathNoExt := wpath . title
            
         ; else if ( filePath := StrSplit(RunCmd(A_MyDocuments . "\ES-1.1.0.18\es.exe " . title . ". !.lnk -sort date-modified-descending"), "`n", "`r" )[1] ) 
         ; {
         ;    SplitPath, filePath,, wpath
         ;    this.Curr_FilePathNoExt := wpath . "\" . title
         ;    , this.Curr_FilePath := filePath
         ;    return 1
         ; }

         else {
            this.Curr_title := ""
            , this.Curr_DateModified := ""
            return 0
         }
      }

      dm_Cpr   := getFileDateModified(this.Curr_FilePathNoExt . ".cpr")
      , dm_Bak := getFileDateModified(this.Curr_FilePathNoExt . ".bak")

      if !dm_Cpr && !dm_Bak 
      {
         this.Curr_DateModified := ""
         this.Curr_title := ""
         return 0
      }

      this.Curr_FilePath := (dm_Cpr > dm_Bak) ? this.Curr_FilePathNoExt . ".cpr" : this.Curr_FilePathNoExt . ".bak"
      , this.Curr_DateModified := (dm_Cpr > dm_Bak) ? dm_Cpr : dm_Bak
      return 1
   }

   GetFrameRate() {
      local
      static prev_DateModified
      if (this.Curr_DateModified = prev_DateModified)
         return this.Curr_FrameRate
      this.OpenProjectFile()
      this.Incremental_Read(350, "4D47726F75704576656E74")
      this.Read_Raw(this.ReadInt(this.FindHex("50417272616E67656D656E7400", 200) + 15), 200)
      this.CloseFile()
      this.Curr_FrameRate := this.ReadInt(this.FindHex("473B8000") - 8)
      prev_DateModified := this.Curr_DateModified
      return this.Curr_FrameRate
   }

   GetSampleRate() {
      local
      static prev_DateModified
      if (this.Curr_DateModified = prev_DateModified)
         return this.Curr_SampleRate
      this.OpenProjectFile()
      this.Read_Raw(this.pFile.Length - 1200, 500)
      this.CloseFile()
      this.Curr_SampleRate := this.ReadDouble(this.FindHex("466C6F617400") + 8)
      prev_DateModified := this.Curr_DateModified
      return this.Curr_SampleRate
   }

   Read_Raw(pos:="", length:="") {
      local
      s:= ""
      if pos
         this.pFile.Pos := pos
      this.pFile.RawRead(bin, length)
      loop % length
         s .= Format("{:02X}", NumGet(&bin + 0, A_Index - 1, "UChar"))
      this.bin := s
   }

   OpenProjectFile() {
      this.pFile       := FileOpen(this.Curr_FilePath, "r")
      , this.pFile.Pos := 0
   }

   Incremental_Read(read_increment, needle) {
      local
      s:= ""
      while !this.pFile.AtEOF {
         this.pFile.RawRead(bin, read_increment)
         loop % read_increment
            s .= Format("{:02X}", NumGet(&bin + 0, A_Index - 1, "UChar"))
         if InStr(s, needle,, ((A_Index-1)*read_increment*2)+1)
         {
            this.bin_length := read_increment*A_Index
            , this.bin      := s
            return true
         }
      }
      return false
   }

   CloseFile() {
      this.pFile.Close()
      this.pFile := ""
   }

   __Delete() {
      If IsObject(this.pFile) {
         this.CloseFile()
      }
   }
}