;--------------------------
; Static / Empty Attributes

CmObject() {
   local
   if (this.attrRecords.CmObject.exists != true) {
      this.bin .= "FEFFFFFF09000000436D4F626A656374000000"
      , this.attrRecords.CmObject := {}
      , this.attrRecords.CmObject.exists := true
   }
}

leConditionTarget() {
   local
   this.bin .= "FEFFFFFF120000006C65436F6E646974696F6E546172676574000000"
}

leActionBase() {
   local
   this.bin .= "FEFFFFFF0D0000006C65416374696F6E42617365000000"
}

MTrackEvent(set_flag) {
   local
   ; msgbox, here
   if (this.attrRecords.MTrackEvent.exists != true) {
      this.bin .= "FEFFFFFF0C0000004D547261636B4576656E74000200"
      , this.attrRecords.MTrackEvent := {}
      , this.attrRecords.MTrackEvent.exists := true
   }
}

MEvent(set_flag) {
   local
   if (this.attrRecords.MEvent.exists != true) {
      this.bin .= "FEFFFFFF070000004D4576656E74000100"
      , this.attrRecords.MEvent := {}
      , this.attrRecords.MEvent.exists := true
   }
}

CmIDLink(set_flag) {
   local
   if (this.attrRecords.CmIDLink.exists != true) {
      this.bin .= "FEFFFFFF09000000436D49444C696E6B000000"
      , this.attrRecords.CmIDLink := {}
      , this.attrRecords.CmIDLink.exists := true
   }
}


;--------------------------
; Value Type Attributes


leToken(set_flag, token) {
   local
   static leToken_array := {"(": 101, ")": 102, "&": 103, "|": 104}
   this.bin .= this.attr_header(set_flag, "leToken")
   if (set_flag = 0)
      return
   this.bin .= "04000000" . Int_HexLE(leToken_array[token])
}

UIntValue(parentAttr, attr_val:="") {
   local
   this.bin .= "04000000"

   switch parentAttr
   {
      case "leActionTargetTrackOp": this.bin .= "00000000"
      case "leActionTargetLength" : this.bin .= Int_HexLE(attr_val)
   }
}

UFloatValue(parentAttr, attr_val:="") {
   local
   this.bin .= "04000000"

   attr_val := (attr_val = "") ? 0 : this.oLogic[attr_val]
   switch parentAttr
   {
      case "leActionTargetColor": this.bin .= "00000000"
      case "leActionTargetName", "leActionTargetTrim", "leActionTargetStart": 
         this.bin .= Float_HexLE(attr_val)
   }
}

; LeUFloat / leActionTargetFloat needs rethinking to be consistent with other LeUFloat attributes
LeUFloatValue(parentAttr, op:="", attr_val:="") {
   local
   this.bin .= "0C000000" ; attrlength = 12
   
   attr_val := (attr_val = "") ? "" : this.oLogic[attr_val]

   switch parentAttr
   {
      case "leActionTargetFloat":
         switch this.oLogic[op]
         {
            case "Set relative random values between":
               this.bin .= Int_HexLE(-1)

            default: this.bin .= "00000000"
         }

         if (attr_val != "")
            switch this.oLogic[op]
            {
               case "Multiply by", "Divide by":
                  this.bin .= "04000000"

               default: this.bin .= "01000000"
            }
         else
            this.bin .= "01000000"

      case "leActionTargetTrim": 
         this.bin .= Int_HexLE(-100) 
                   . Int_HexLE(100)

      case "leActionTargetLength", "leActionTargetStart":
         switch this.oLogic[op]
         {
            case "Divide by"  : this.bin .= "01000000"
            case "Multiply by": this.bin .= "00000000"
         }
         this.bin .= Int_HexLE(100)

      case "leActionTargetValue1", "leActionTargetValue2", "leActionTargetValue3":
         this.bin .= "00000000" 
                   . Int_HexLE(127)
   }

   this.bin .= Float_HexLE(attr_val)
}

UValue(set_flag) {
}

UStringValue(parentAttr, attr_val:="") {
   local
   attr_val := (attr_val != "") ? this.oLogic[attr_val] : ""

   tempbin := Int_HexLE( StrLen(attr_val) + 4 )
   if attr_val
      tempbin .= AscToHex( attr_val ) 
               . "00" 
               . this.BOM

   tempbin_len := StrLen(tempbin) // 2
   this.bin    .= Int_HexLE( tempbin_len )
   this.bin    .= tempbin_len ? tempbin : ""
}

LeUIntValue(parentAttr, op:="", attr_val:="") {
   local
   this.bin .= "0C000000" ; attrlength = 12
   if !(attr_val := this.oLogic[attr_val])
      attr_val := 0

   switch parentAttr
   {
      case "leMediaTypeTarget":
         this.bin .= "00000000" 
         switch this.oLogic[op]
         {
            case "Equal"               : this.bin .= Int_HexLE(255)
            case "Unequal", "All Types": this.bin .= Int_HexLE(2147483647)
         }
         this.bin .= "00000000"

      case "leFlagsTarget", "leTypesTarget", "leActionTargetTypes":
         this.bin .= "00000000"
                    . Int_HexLE(2147483647)
                    . "00000000"

      case "leContainerTypeTarget":
         this.bin .= "00000000"
         switch this.oLogic[op]
         {
            case "Equal"               : this.bin .= Int_HexLE(255)
            case "Unequal", "All Types": this.bin .= Int_HexLE(1)
         }
         this.bin .= "00000000"

      case "leNameTypeTarget":
         this.bin .= "00000000"
         switch this.oLogic[op]
         {
            case "Equal"                   : this.bin .= Int_HexLE(255)
            case "Contains", "Contains not": this.bin .= Int_HexLE(1)
         }
         this.bin .= "00000000"

      case "leActionTargetValue1", "leActionTargetValue2", "leActionTargetValue3":
         switch this.oLogic[op]
         {
            case "Set relative random values between"
               , "Relative Change in Loop Range":
               this.bin .= Int_HexLE(-100)
            
            default:
               this.bin .= "00000000"
         }
         this.bin .= Int_HexLE(127)
                   . Int_HexLE(attr_val)

      case "leValue1Target", "leValue2Target", "leValue3Target":
         this.bin .= "00000000"
                   . Int_HexLE(127)
                   . Int_HexLE(attr_val)

      case "leActionTargetTrackOp":
         this.bin .= "00000000"
                   . "01000000"
                   . "00000000"

      case "leActionTargetName":
         this.bin .= "00000000"
                   . Int_HexLE(1000)
                   . Int_HexLE(attr_val)

      case "leActionTargetColor","leActionTargetTrim":
         this.bin .= "00000000"
                   . Int_HexLE(127)
                   . "00000000"

      case "leActionTargetChannel":
         this.bin .= "00000000"
                   . Int_HexLE(15)
                   . Int_HexLE(attr_val)

      case "leActionTargetNXPOp":
         this.bin .= "00000000"
         switch this.oLogic[op]
         {
            case "Create One-Shot":
               this.bin .= Int_HexLE(2147483647)

            default:
               this.bin .= "01000000"
         }
         this.bin .= "00000000"

      case "leActionTargetLength"
         , "leActionTargetStart":
         switch this.oLogic[op]
         {
            case "Multiply by", "Divide by":
               this.bin .= "00000000"
                         . "00000000"
                         . "00000000"

            case "Round_by", "Add_Length":
               this.bin .= "00000000"
               switch parentAttr
               {
                  case "leActionTargetStart":
                     this.bin .= Int_HexLE(134217727)

                  case "leActionTargetLength":
                     this.bin .= Int_HexLE(8388607)
               }
               this.bin .= Int_HexLE(attr_val)

            case "Set relative random values between":
               this.bin .= Int_HexLE(-100)
                         . Int_HexLE(200)
                         . Int_HexLE(attr_val)

            case "Set Random Values Between":
               this.bin .= Int_HexLE(0)
                         . Int_HexLE(8388607)
                         . Int_HexLE(attr_val)
         }

      case "lePositionTarget":
         this.bin .= "00000000"
                   . Int_HexLE(1920)
                   . Int_HexLE(attr_val)
   }
}

LeTTimeValue(parentAttr, op, val:="") {
   local
   this.missing_len += 4
   , this.bin .= "00000000" 
               . "00000000"
               . "01000000"                ; TimeBase (1)
               . "000000000000F03F"        ; TimeBase Unit = 1 / 1
               . "0000000038137E41"        ; 31536000
               . "01000000"                ; TimeBase (1)
               . "000000000000F03F"        ; TimeBase Unit = 1 / 1

   val := (val = "") ? 0 : this.oLogic[val]

   switch this.oLogic[op]
   {
      case "Seconds":
         this.bin .= Double_HexLE(val)
                   . "01000000"            ; TimeBase (1)
                   . "000000000000F03F"    ; TimeBase Unit = 1 / 1

      case "Samples":
         temp_sr  := Double_HexLE( 1 / this.checkSampleRate() )
         , this.bin .= Double_HexLE(val)
                     . "0A000000"          ; TimeBase (10)
                     . temp_sr             ; TimeBase Unit = 1 / SampleRateinHz

      case "Frames":
         temp_fr        := this.checkFrameRate()
         , temp_fr_unit := this.FrameRate_array[temp_fr]
         , this.bin     .= Double_HexLE(val)
                         . Int_HexLE(temp_fr)
                         . temp_fr_unit    ; TimeBase Unit = 1 / FrameRateinFPS

      case "PPQ":
         this.bin .= Double_HexLE(val)
                   . "00000000"            ; TimeBase (0) = PPQ
         this.MasterTrack()
   }

   this.writeLen_Retro("LeTTimeValue")
}

LeDomainTypeValue(parentAttr) {
   local
   this.bin .= Int_HexLE(4)

   switch this.oLogic[4]
   {
      case "PPQ"    : this.bin .= "00000000"
      case "Seconds": this.bin .= "01000000"
      case "Samples": this.bin .= "02000000"
      case "Frames" : this.bin .= "03000000"
   }
}

LeTTimeDiffValue(parentAttr, op, val:="") {
   local
   this.missing_len += 4
   , this.bin .= "00000000" 
               . "00000000"

   val := (val = "") ? 0 : this.oLogic[val]

   switch this.oLogic[op]
   {
      case "Seconds":
         this.bin .= "01000000"            ; TimeBase (1)
                   . "000000000000F03F"    ; TimeBase Unit = 1 / 1
                   . Double_HexLE(val)
                   . "01000000"            ; TimeBase (1)
                   . "000000000000F03F"    ; TimeBase Unit = 1 / 1
                   . "00000000"

      case "Samples":
         temp_sr :=  Double_HexLE( 1 / this.checkSampleRate() )
         , this.bin .= "0A000000"          ; TimeBase (10)
                      . temp_sr            ; TimeBase Unit = 1 / SampleRateinHz
                      . Double_HexLE(val)
                      . "0A000000"         ; TimeBase (10)
                      . temp_sr            ; TimeBase Unit = 1 / SampleRateinHz
                      . "00000000"

      case "Frames":
         temp_fr        := this.checkFrameRate()
         , temp_fr_unit := this.FrameRate_array[temp_fr]
         , this.bin     .= Int_HexLE(temp_fr)
                         . temp_fr_unit         ; TimeBase Unit = 1 / FrameRateinFPS
                         . Double_HexLE(val)
                         . Int_HexLE(temp_fr)
                         . temp_fr_unit         ; TimeBase Unit = 1 / FrameRateinFPS
                         . "00000000"

      case "PPQ":
         this.bin .= "00000000" ; TimeBase (0) = PPQ
         this.MasterTrack()
         this.bin .= Double_HexLE(val)
                   . "00000000" ; TimeBase (0) = PPQ
                   . Int_HexLE(this.attrRecords.MTTEaddr)
                   . Int_HexLE(this.attrRecords.MSTEaddr)
                   . "00000000"
   }

   this.writeLen_Retro("LeTTimeDiffValue")
}

MasterTrack() {
   local
   this.MTrackEvent(0)
   this.MEvent(0)
   this.CmIDLink(0)
   Curr_Pos := StrLen(this.bin)//2
   if !this.attrRecords.MTTEaddr {
      this.CPR.UpdateFilePath()
      this.bin .= this.CPR.ImportMTrack(Curr_Pos + this.missing_len)
      this.attrRecords.MTTEaddr := this.CPR.MTempoTrackEvent_MAddr
      this.attrRecords.MSTEaddr := this.CPR.MSignatureTrackEvent_MAddr
      if this.CPR.nestedST
         this.bin .= Int_HexLE(this.attrRecords.MSTEaddr)
   } else {
      this.bin .= Int_HexLE(this.attrRecords.MTTEaddr)
      this.bin .= Int_HexLE(this.attrRecords.MSTEaddr)
   }
}

PMidiKeyValue(parentAttr) {
   local
   this.bin .= Int_HexLE(12)
             . "00000000"
             . Int_HexLE(11)
             . Int_HexLE(this.note_array[this.oLogic[3]])
}

PMidiScaleValue(parentAttr) {
   local
   this.bin .= Int_HexLE(12)
             . "00000000"
             . Int_HexLE(28)
             . Int_HexLE(this.scale_array[this.oLogic[4]])
}

LeGenericOpValue(parentAttr) {
   local
   this.bin .= Int_HexLE(4)

   switch this.oLogic[2]
   {
      case "Folder":
         switch this.oLogic[3]
         {
            case "Open"  : this.bin .= Int_HexLE(0)
            case "Close" : this.bin .= Int_HexLE(1)
            case "Toggle": this.bin .= Int_HexLE(2)
         }
      case "Time Domain":
         switch this.oLogic[3]
         {
            case "Musical": this.bin .= Int_HexLE(0)
            case "Linear" : this.bin .= Int_HexLE(1)
            case "Toggle" : this.bin .= Int_HexLE(2)
         }
      default:
         switch this.oLogic[3]
         {
            case "Enable" : this.bin .= Int_HexLE(0)
            case "Disable": this.bin .= Int_HexLE(1)
            case "Toggle" : this.bin .= Int_HexLE(2)
         }
   }
}

LeAllroundValue(parentAttr) {
   local
   this.bin .= Int_HexLE(12)
             . Int_HexLE(0)
             . Int_HexLE(2147483647)
   val := this.oLogic[4]
   if val is not number
      val := Pitch2Num(val)
   this.bin .= Int_HexLE(val)
}

LeHistoryValue(parentAttr) {
   local
   this.bin .= Int_HexLE(12)
             . Int_HexLE(0)
             . Int_HexLE(4)
   switch this.oLogic[3]
   {
      case "Value 1"     : this.bin .= Int_HexLE(0)
      case "Value 2"     : this.bin .= Int_HexLE(1)
      case "MIDI Status" : this.bin .= Int_HexLE(2)
      case "Channel"     : this.bin .= Int_HexLE(3)
      case "Eventcounter": this.bin .= Int_HexLE(4)
   }
}

LEMidiChannelValue(parentAttr, val:="") {
   local
   val := (val := this.oLogic[val]) ? val - 1 : 0
   this.bin .= Int_HexLE(12)
             . "00000000"
             . Int_HexLE(15)
             . Int_HexLE(val)

}

LeTypeValue(parentAttr) {
   local
   this.bin .= Int_HexLE(12)
             . "00000000"

   switch this.oLogic[1]
   {
      case "Type Is":
         this.bin .= Int_HexLE(8)
         switch this.oLogic[3]
         {
            case "Note"          : this.bin .= Int_HexLE(0)
            case "Poly Pressure" : this.bin .= Int_HexLE(1)
            case "Controller"    : this.bin .= Int_HexLE(2)
            case "Program Change": this.bin .= Int_HexLE(3)
            case "Aftertouch"    : this.bin .= Int_HexLE(4)
            case "Pitchbend"     : this.bin .= Int_HexLE(5)
            case "SysEx"         : this.bin .= Int_HexLE(6)
            case "SMF Event"     : this.bin .= Int_HexLE(7)
            case "VST 3 Event"   : this.bin .= Int_HexLE(8)
         }

      case "Type":
         this.bin .= Int_HexLE(6)
         switch this.oLogic[3]
         {
            case "Note"          : this.bin .= Int_HexLE(0)
            case "Poly Pressure" : this.bin .= Int_HexLE(1)
            case "Controller"    : this.bin .= Int_HexLE(2)
            case "Program Change": this.bin .= Int_HexLE(3)
            case "Aftertouch"    : this.bin .= Int_HexLE(4)
            case "Pitchbend"     : this.bin .= Int_HexLE(5)
            case "VST 3 Event"   : this.bin .= Int_HexLE(6)
         }

      case "NoteExp Operation":
         this.bin .= Int_HexLE(4)
         switch this.oLogic[3]
         {
            case "Poly Pressure": this.bin .= Int_HexLE(0)
            case "Controller"   : this.bin .= Int_HexLE(1)
            case "Aftertouch"   : this.bin .= Int_HexLE(2)
            case "Pitchbend"    : this.bin .= Int_HexLE(3)
            case "VST 3 Event"  : this.bin .= Int_HexLE(4)
         }
   }
}

PMidiNoteValue(parentAttr:="", val:="") {
   local
   this.bin .= Int_HexLE(12)
             . "00000000"
             . Int_HexLE(127)

   if !(val := this.oLogic[val])
      val := 0
   if val is not number
      val := Pitch2Num(val)
   this.bin .= Int_HexLE(val)
}

PControllerValue(parentAttr:="", val:="") {
   local
   this.bin .= Int_HexLE(12)
             . "00000000"
             . Int_HexLE(127)

   val := (val = "") ? 0 : this.oLogic[val]
   this.bin .= Int_HexLE(val)
}

nullspawn(parentAttr) {
   this.bin .= "00000000"
}

LeContainerTypeValue(parentAttr) {
   local
   this.bin .= Int_HexLE(4)

   switch this.oLogic[3]
   {
      case "FolderTrack": this.bin .= Int_HexLE(0)
      case "Track"      : this.bin .= Int_HexLE(1)
      case "Part"       : this.bin .= Int_HexLE(2)
      case "Event"      : this.bin .= Int_HexLE(3)
   }
}

LeMediaTypeValue(parentAttr) {
   local
   this.bin .= Int_HexLE(4)

   switch this.oLogic[3]
   {
      case ""          : this.bin .= Int_HexLE(0)
      case "Audio"     : this.bin .= Int_HexLE(0)
      case "MIDI"      : this.bin .= Int_HexLE(1)
      case "Automation": this.bin .= Int_HexLE(2)
      case "Marker"    : this.bin .= Int_HexLE(3)
      case "Transpose" : this.bin .= Int_HexLE(4)
      case "Arranger"  : this.bin .= Int_HexLE(5)
      case "Tempo"     : this.bin .= Int_HexLE(6)
      case "Signature" : this.bin .= Int_HexLE(7)
      case "Chord"     : this.bin .= Int_HexLE(8)
      case "Scale"     : this.bin .= Int_HexLE(9)
      case "Video"     : this.bin .= Int_HexLE(10)
      case "Group"     : this.bin .= Int_HexLE(11)
      case "Effect"    : this.bin .= Int_HexLE(12)
      case "Device"    : this.bin .= Int_HexLE(13)
      case "VCA"       : this.bin .= Int_HexLE(14)
   }
}

LeFlagsValue(parentAttr) {
   local
   this.bin .= Int_HexLE(12)
             . Int_HexLE(0)
             
   switch this.LEType
   {
      case "PLE":
         this.bin .= Int_HexLE(8)
         switch this.oLogic[3]
         {
            case "Event is muted"      : this.bin .= Int_HexLE(0)
            case "Event is selected"   : this.bin .= Int_HexLE(1)
            case "Event is empty"      : this.bin .= Int_HexLE(2)
            case "Event inside NoteExp": this.bin .= Int_HexLE(3)
            case "Event is valid VST 3": this.bin .= Int_HexLE(4)
            case "Is Hidden"           : this.bin .= Int_HexLE(5)
            case "Has Track Version"   : this.bin .= Int_HexLE(6)
            case "Follows Chord Track" : this.bin .= Int_HexLE(7)
            case "Is Disabled"         : this.bin .= Int_HexLE(8)
         }

      case "LE":
         this.bin .= Int_HexLE(7)
         switch this.oLogic[3]
         {
            case "Event is muted"      : this.bin .= Int_HexLE(0)
            case "Event is selected"   : this.bin .= Int_HexLE(1)
            case "Event is empty"      : this.bin .= Int_HexLE(2)
            case "Event inside NoteExp": this.bin .= Int_HexLE(3)
            case "Event is valid VST 3": this.bin .= Int_HexLE(4)
            case "Is Part of Scale"    : this.bin .= Int_HexLE(5)
            case "Is Part of Chord"    : this.bin .= Int_HexLE(6)
            case "Event is muted"      : this.bin .= Int_HexLE(7)
         }
   }
}

leContextTypeTarget_Value(parentAttr := "") {
   local
   switch this.oLogic[3]
   {
      case "Highest Pitch"                    : this.bin .= Int_HexLE(0) . Int_HexLE(0)
      case "Lowest Pitch"                     : this.bin .= Int_HexLE(1) . Int_HexLE(0)
      case "Average Pitch"                    : this.bin .= Int_HexLE(2) . Int_HexLE(0)
      case "Highest Velocity"                 : this.bin .= Int_HexLE(3) . Int_HexLE(0)
      case "Lowest Velocity"                  : this.bin .= Int_HexLE(4) . Int_HexLE(0)
      case "Average Velocity"                 : this.bin .= Int_HexLE(5) . Int_HexLE(0)
      case "Highest CC Value"                 : this.bin .= Int_HexLE(6) . Int_HexLE(0)
      case "Lowest CC Value"                  : this.bin .= Int_HexLE(7) . Int_HexLE(0)
      case "Average CC Value"                 : this.bin .= Int_HexLE(8) . Int_HexLE(0)
      case "No. of Notes in Chord - Part"     : this.bin .= Int_HexLE(9) . Int_HexLE(this.oLogic[4])
      case "No. of Voices - Part"             : this.bin .= Int_HexLE(10) . Int_HexLE(this.oLogic[4])
      case "Note Number in Chord - lowest = 0": this.bin .= Int_HexLE(12) . Int_HexLE(this.oLogic[4])
      case "Position in Chord - Part"         : 
         this.bin .= Int_HexLE(11)
         if (ct_int := this.ct_intervals[this.oLogic[4]])
            this.bin .= Int_HexLE( ct_int )
         else
            msgbox, Invalid Positon in Chord

      case "Position in Chord - Chord Track": 
         this.bin .= Int_HexLE(13)
         if (ct_int := this.ct_intervals[this.oLogic[4]])
            this.bin .= Int_HexLE( ct_int )
         else
            msgbox, Invalid Positon in Chord

      case "Voice": 
         this.bin .= Int_HexLE(14)
         if (ct_voice := this.ct_voices[this.oLogic[4]])
            this.bin .= Int_HexLE( ct_op )
         else
            msgbox, Invalid Voice
   }
}