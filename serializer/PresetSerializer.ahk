/*
Ideas for improvement

- Implement a logging system
   - project file parsing etc...
- Move away from Msgbox/Exit to Exceptions
- look at other serializer classes for structuring naming of functions
- finish off PPQ stuff
- Add fall-back behaviour for when CPRParsing = false or upon failure to get project file
- Think about how to implement an update preset method
- method / module names
   - Folders for Serializer / Deserializer
   - CPR deserializer
   - tokenizer
   - io
   - location recorder
   - stub
   - Printer
   - Field
   - Project File Handling
   - IO_serialiazer
   - IO_deserializer

- have a seperate class object that records all used attr locations, flags etc.
   - would remove the need for a used attr record as the class could just be removed each time.

- read up on "Tree Traversal"
- need to rethink the TargetAttr data structure to handle double branching elegantly
- probably need a new spawnHandler method

- need to refine the preset path stuff

- rename bin to buffer

*/

#Include src\_BinThings.ahk
#Include src\_array.ahk
#Include src\_JSON.ahk
#Include src\_Musical.ahk
#Include src\_ProjectFilePath.ahk
; #Include src\_RunCMD.ahk
#Include src\_toHex.ahk


class PresetSerializer {
   #Include src\_Serializer.ahk
   #Include src\CPR_Parser.ahk
   #include src\_TargetAttributes.ahk
   #include src\_ValueStructs.ahk
   #include src\_MiscData.ahk
   #Include src\_targetAttrMaps.ahk

   static LEPath        := "Logical Edit\"
        , PLEPath       := "Project Logical Editor\"
        , BOM           := "EFBBBF"
        , CubaseVersion := "10.5"
        , LEType        := "PLE"
        , Preset_Folder := ""
        , Preset_Name   := "Default"
        , Function      := "Select"
        , Macro         := "Not set"
        , CPRParsing    := false

   __New() {
      local
      if !( this.CubaseVersion := this.getHighestCubaseVersion() ) {
         Msgbox, "No Cubase Installation Found"
         Exit
      }
      ; this.loadJSON()
   }

   loadJSON() {

      ; scrap the JSON
   }

   getHighestCubaseVersion() {
      local
      Loop, Reg, HKCU\Software\Steinberg Media Technologies GmbH, K
      {
         RegExMatch(A_LoopRegName, "(?<=Steinberg Cubase )(.*?(?=$|\s))", tempVersion)
         if (tempVersion > maxVersion)
            maxVersion := tempVersion
      }
      return maxVersion ? maxVersion : 0
   }

   setCubaseVersion(version) {
      local
      this.CubaseVersion := version

   }

   setCPRParsing(value) {
      local
      if (this.CPRParsing := value)
         this.CPR := new this.CPR_Parser(this.CubaseVersion)
   }

   setEditorType(type) {
      local
      if ((type = "LE") || (type = "PLE"))
         this.LEType := type
      
      else 
      {
         Msgbox, Invalid LEType
         Exit
      }
   }

   setPresetName(name) {
      local
      this.Preset_Name := name
   }

   setPresetFunction(function) {
      local
      if !HasVal(this[this.LEType . "funcs"], function) {
         Msgbox, Invalid Preset Function
         Exit
      }

      else
         this.Function := function
   }

   setPresetMacro(macro) {
      local
      this.Macro := macro
   }

   setPresetSubFolder(folder) {
      local
      if (SubStr(folder, 0, 1) != "/")
         this.Preset_Folder := folder . "/"
      else
         this.Preset_Folder := folder
      this.checkPresetPath()
   }

   checkPresetPath() {
      local
      this.Preset_Path := A_AppData 
                          . "\Steinberg\Cubase " 
                          . this.CubaseVersion 
                          . "_64\Presets\" 
                          . this[this.LEType . "Path"] 
                          . this.Preset_Folder

      if !FileExist(this.Preset_Path)
         FileCreateDir, % this[Preset_Path]
   }

   checkSampleRate() {
      local
      this.CPR.UpdateFilePath()
      if !(temp_sr := this.CPR.GetSampleRate()) {
         Msgbox, Failed to get sample rate from project file
         Exit
      }
      return temp_sr
   }

   checkFrameRate() {
      local
      this.CPR.UpdateFilePath()
      if !(temp_fr := this.CPR.GetFrameRate()) {
         Msgbox, Failed to get frame rate from project file
         Exit
      }
      return temp_fr
   }

   NewPreset(byref logic) {
      local
      StringCaseSense, On
      this.bin                  := "" 
      , this.attrRecords        := {}   
      , this.LastTypeValue := "default"
      , this.A_Entries     := logic.Actions
      , this.FilterLogic   := logic.Filters

      this.openPresetFile()
      this.appendXMLHeader()

      ; build the binary data
      this.ParseLogic()
      this.BinAssembler()
      this.appendBinaryData()

      this.appendXMLFooter()
      this.closePresetFile()
   }

   UpdatePreset(new_value) {
      /*

      create a function that is called in every place where values are written
      append value with a special symbol to designate it as a variable ($ for example)
      record the binposition and type of value so that it can be overwritten

      * have a way of marking that the preset is static, then it just reads in xml and edits at the right place

      how to deal with variable number of arguments?
      
      could move towards passing in args as linenumbers
      i.e:

         args.Filters[1] := 
         args.Filters[2] :=

         args.Fiters[line++] := 
         args.Fiters[line++]
         args.Fiters[line++]
         args.Fiters[line++]
         args.Fiters[line++]

      and then parse each line into F/A_Entries
      
      */
   }

   OpenPresetFile() {
      this.pFile := FileOpen(this.Preset_Path . this.Preset_Name ".xml", "w")
   }

   appendXMLHeader() {
      this.pFile.write(this[this.LEType . "header"] . "`r`n`t`t")
   }

   appendBinaryData() {
      ; Linewrap the binary data
      this.bin := bin_lineWrap(this.bin, 64, "`t`t")

      ; write to the file
      this.pFile.write(this.bin)
   }

   appendXMLFooter() {
      this.pFile.write(this[this.LEType . "footer"])
   }

   ClosePresetFile() {
      this.pFile.Close()
      this.pFile := ""
   }

   __Delete() {
      if IsObject(this.pFile)
         this.ClosePresetFile()
   }
}