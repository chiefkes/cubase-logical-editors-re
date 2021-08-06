ParseLogic() {
   local
   ; Parse actions
   this.NumActions := NumGet(&this.A_Entries + 4*A_PtrSize)

   ; Parse filters
   this.F_Entries := []

   for index, val in this.FilterLogic {
      tempLogicStr := StrReplace(val, "AND", "&")
      , tempLogicStr := StrReplace(tempLogicStr, "OR", "|")
      , parsePos := 0

      Loop, Parse, % tempLogicStr,()&|, %A_Space%
      {
         if (A_LoopField != "") {
            ; msgbox, % "Field = " A_LoopField
            this.F_Entries.push(A_LoopField)
         }

         parsePos += StrLen(A_LoopField) + 1
         , token  := SubStr(tempLogicStr, parsePos, 1)
         ; msgbox, % "token = " token

         if (token != "" && token != " ")
            this.F_Entries.push( token )
      }
   }

   this.NumFilters := NumGet(&this.F_Entries + 4*A_PtrSize)
}

BinAssembler() {
   local
   ; Write Header / Preset Name
   this.bin .= 0040000001000000
   if this.Preset_Name
   {
      this.bin .= Int_HexLE( StrLen(this.Preset_Name) + 4 )
                . AscToHex(this.Preset_Name) 
                . "00" 
                . this.BOM
   }
      
   else
      this.bin .= "00000000"
   

   ; Write Actions
   this.bin .= "0A0000000100" 
             . Int_HexLE(this.NumActions)

   if (this.NumActions != 0) 
   {
      this.missing_len := 0
      this.leActionBase()
      this.CmObject()

      for _, Action_logic in this.A_Entries
         if (Action_logic != "")
            this.ActionsJunction(Action_logic)
   }

   ; Write Filters
   this.bin .= "0A0000000100" 
             . Int_HexLE(this.NumFilters)

   if (this.NumFilters != 0) {
      this.missing_len := 0

      if (this.F_Entries[1] = "(") {
         this.CmObject()
         for k, v in this.F_Entries
         {
            if (v = "(") {
               this.F_Entries[k] := ""
               this.leToken(1, "(")
            }
            else
               break
         }
         this.leConditionTarget()

      } else {
         this.leConditionTarget()
         this.leToken(0, "")
         this.CmObject()
      }

      for _, filter_logic in this.F_Entries
         if (filter_logic != "")
            this.FiltersJunction(filter_logic)
   }

   ; Write Footer
   this.bin .= (this.LEType = "LE") ? "00000000" : Int_HexLE( StrLen(this.Macro)+4 ) 
                                                 . AscToHex(this.Macro) 
                                                 . "00" 
                                                 . this.BOM
   , this.bin .= Int_HexLE(this.PresetFunction_array[this.Function])
   , this.bin .= (this.LEType = "LE") ? "00000000" : "01000000"
   , this.bin .= "00000000000000000000000000000000"

}

ActionsJunction(action_logic) {
   local
   this.oLogic := StrSplit(action_logic, ",", " ")
   ; msgbox, % this.oLogic[1]

   switch this.LEType
   {
      case "PLE":
         switch (this.oLogic[1])
         {
            case "Position"             : this.TargetTypeAttr("leActionTargetStart")
            case "Length"               : this.TargetTypeAttr("leActionTargetLength")
            case "Track Operation"      : this.TargetTypeAttr("leActionTargetTrackOp")
            case "Name"                 : this.TargetTypeAttr("leActionTargetName")
            case "Trim"                 : this.TargetTypeAttr("leActionTargetTrim")
            case "Set Color"            : this.TargetTypeAttr("leActionTargetColor")
            default:
               MsgBox, Invalid PLE Action Target
               Exit
         }

      case "LE":
         switch (this.oLogic[1])
         {
            case "Position"             : this.TargetTypeAttr("leActionTargetStart")
            case "Length"               : this.TargetTypeAttr("leActionTargetLength")
            case "Value 1"              : this.crossAttrContext("leActionTargetValue1")
                                          this.TargetTypeAttr("leActionTargetValue1")
            case "Value 2"              : this.TargetTypeAttr("leActionTargetValue2")
            case "Value 3"              : this.TargetTypeAttr("leActionTargetValue3")
            case "Channel"              : this.TargetTypeAttr("leActionTargetChannel")
            case "Type"                 : this.TargetTypeAttr("leActionTargetTypes")
            case "NoteExp Operation"    : this.TargetTypeAttr("leActionTargetNXPOp")
            case "VST 3 Value Operation": this.TargetTypeAttr("leActionTargetFloat")
            default:
               MsgBox, Invalid LE Action Target
               Exit
         }
   }
}

FiltersJunction(filter_logic) {
   local
   this.oLogic := StrSplit(filter_logic, ",", " ")

   ; msgbox, % this.oLogic[1]

   switch this.LEType
   {
      case "PLE":
         switch (this.oLogic[1])
         {
            case "("                  : this.leToken(1, "(")
            case ")"                  : this.leToken(1, ")")
            case "&"                  : this.leToken(1, "&")
            case "|"                  : this.leToken(1, "|")
            case "Media Type is"      : this.TargetTypeAttr("leMediaTypeTarget")
            case "Container Type is"  : this.TargetTypeAttr("leContainerTypeTarget")
            case "Name"               : this.TargetTypeAttr("leNameTypeTarget")
            case "Position"           : this.TargetTypeAttr("lePositionTarget")
            case "Length"             : this.TargetTypeAttr("leLengthTarget")
            case "Color Name is"      : this.TargetTypeAttr("leColorTypeTarget")
            case "Property"           : this.TargetTypeAttr("leFlagsTarget")
            default:
               MsgBox, Invalid PLE Filter Target
               Exit
         }

      case "LE":
         switch (this.oLogic[1])
         {
            case "("                    : this.leToken(1, "(")
            case ")"                    : this.leToken(1, ")")
            case "&"                    : this.leToken(1, "&")
            case "|"                    : this.leToken(1, "|")
            case "Position"             : this.TargetTypeAttr("lePositionTarget")
            case "Length"               : this.TargetTypeAttr("leLengthTarget")
            case "Value 1"              : this.TargetTypeAttr("leValue1Target")
            case "Pitch"                : this.TargetTypeAttr("leValue1Target")
            case "MIDI Controller No."  : this.TargetTypeAttr("leValue1Target")
            case "Value 2"              : this.TargetTypeAttr("leValue2Target")
            case "Velocity"             : this.TargetTypeAttr("leValue2Target")
            case "MIDI Controller Value": this.TargetTypeAttr("leValue2Target")
            case "Value 3"              : this.TargetTypeAttr("leValue3Target")
            case "Off Velocity"         : this.TargetTypeAttr("leValue3Target")
            case "Channel"              : this.TargetTypeAttr("leChannelTarget")
            case "Last Event"           : this.TargetTypeAttr("leHistoryTarget")
            case "Context Variable"     : this.TargetTypeAttr("leContextTypeTarget")
            case "Property"             : this.TargetTypeAttr("leFlagsTarget")
            case "Type Is"              : this.TargetTypeAttr("leTypesTarget")
                                          this.crossAttrContext("leTypesTarget")
            default:
               MsgBox, Invalid LE Filter Target
               Exit
         }
   }
}

crossAttrContext(attr_ID) {
   switch (attr_ID)
   {
      case "leActionTargetValue1":
         for _, TypeVal in this.F_Entries 
         {
            if InStr(TypeVal, "Type Is") {
               if InStr(TypeVal, "Note")
                  this.LastTypeValue := "Note"
               else if InStr(TypeVal, "Controller")
                  this.LastTypeValue := "Controller"
               else
                  this.LastTypeValue := "default"
            }
         }

         if (this.oLogic[2] = "Mirror") && (this.LastTypeValue != "Note") {
            Msgbox, Oops - Mirror is only available for 'Type is Note'
            Exit
         }

      case "leTypesTarget":
         if ((this.oLogic[3] = "Note") || (this.oLogic[3] = "Controller"))
            this.LastTypeValue := this.oLogic[3]
         else
            this.LastTypeValue := "default"
   }
}

attr_header(isSet, attr_ID) {
   local
   if ( this.attrRecords[attr_ID].exists != true ) { ; new attribute
      headerLen := (StrLen( HLN := this.HLN[attr_ID] )//2) + 11
      this.attrLocationRecorder(true, attr_ID, headerLen)
      return ( (isSet = false) ? "FEFFFFFF" : "FFFFFFFF" )
           . HLN
           . "00" 
           . this.enumAttrDepth(attr_ID)
      
   } else { ; existing attribute
      this.attrLocationRecorder(false, attr_ID)
      return Short_HexLE( this.attrRecords[attr_ID].headerPos ) 
           . "0080"
   }
}

attrLocationRecorder(isNewAttr, attr_ID, headerLen:="") {
   local
   tempBinPos  := (StrLen(this.bin)//2) + this.missing_len

   if isNewAttr {
      this.attrRecords[attr_ID] := {}
      , this.attrRecords[attr_ID].exists     := true
      , this.attrRecords[attr_ID].headerPos  := tempBinPos
      , this.attrRecords[attr_ID].bodyPos    := tempBinPos + headerLen
      , this.missing_len += ( InStr(attr_ID, "Target") ) ? 4 : 0
   
   } else {
      this.attrRecords[attr_ID].bodyPos := tempBinPos + 8
      this.missing_len += ( InStr(attr_ID, "Target") ) ? 4 : 0
   }
}

enumAttrDepth(attr_ID) {
   local
   switch attr_ID 
   {
      ; special cases where this short is non-zero
      case "MTrackEvent"         : return Short_HexLE(2)
      case "MEvent"              : return Short_HexLE(1)
      case "MTempoTrackEvent"    : return Short_HexLE(2)
      case "MSignatureTrackEvent": return Short_HexLE(3)
      case "MTimeSignatureEvent" : return Short_HexLE(2)
      case "PMidiScaleValue"     : return Short_HexLE(1)
      ; should normally be zero
      default                    : return Short_HexLE(0)
   }
}

writeLen_Retro(attr_id) {
   local
   attr_len := Int_HexLE( (StrLen(this.bin)//2) - this.attrRecords[attr_id].bodyPos + this.missing_len )
   , this.missing_len -= 4
   , this.bin := bin_Insert( attr_len, this.bin, ( (this.attrRecords[attr_id].bodyPos-4-this.missing_len)*2)+1 )
}