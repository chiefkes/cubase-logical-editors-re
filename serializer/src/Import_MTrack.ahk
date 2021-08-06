/*
improvements
- add an addrRecord array for all addresses
- clarify variable names - bin and nbin ---> binstream ....
*/

#Include src/_MTrackStructs.ahk

importMTrack(curr_pos) {
   local
   static prev_DateModified
   if (this.Curr_DateModified = prev_DateModified)
      return this.UpdateMTrack(curr_pos)

   this.OpenProjectFile()
   if !this.Incremental_Read(300, "000000074D547261636B00")
      Msgbox, Failed to find MTrack Boundary
   this.CloseFile()
   this.MTrackOffsets()

   ; this could be a seperate function....
   this.bin := SubStr(this.bin, (this.MTTE_pos*2)+1
                    , (this.bin_length := this.end_pos - this.MTTE_pos)*2)
   if (this.bin = this.old_bin)
      return this.UpdateMTrack(curr_pos)
   ;;;;;;;;;;;;;;;;;;;;

   this.MTrackAddresses := {}
   ; wrap all the addr stuff in an array
   this.nbin := ""                                      ; new binary data to return
   , this.binpos := 0                                   ; simulating a cursor position for parsing this.bin
   , this.missing_len := 0                              ; variable to account for length discrepancies (caused by addition of MDataNode and MListNode)
   , this.trunc_addr := []                              ; an array of 'truncated' attribute address
   , this.trunc_bound := []                             ; an array of 'truncated' attribute boundaries
   , this.MTempoTrackEvent_MAddr := ""                  ; the adjusted MTempoTrackEvent address
   , this.MSignatureTrackEvent_MAddr := ""              ; the adjusted MSignatureTrackEvent address
   , this.MDataNode_pos := ""                           ; address of MDataNode attribute for ex_attr offset correction
   , this.MListNode_pos := ""                           ; address of MListNode_pos attribute for ex_attr offset correction
   , this.TruncAttr := 0                                ; flag to indicate that an truncated attribute continuation should follow
   , this.exAttrOffsets := {}                           ; array of ex_attribute addresses and offsets for the UpdateMTrack() method
   , this.MTTE_array := []                              ; array of MTrackOffset addresses for the UpdateMTrack() method
   , this.MSTE_array := []                              ; // //
   , this.curr_pos := curr_pos                          ; set the current cursor position as reported by the PresetSerializer.BinaryAssembler()

   this.checkMTrackNodes()
   this.childAttrBuilder( this.bin_length, "MTrackRoot" )
   this.old_bin := this.bin
   prev_DateModified := this.Curr_DateModified
   return this.nbin
}

updateMTrack(new_offset) {
   local
   for prev_nbinPos, abs_OffsetAddr in this.exAttrOffsets
      this.nbin := bin_overwrite( Short_HexLE(abs_OffsetAddr + new_offset), this.nbin, (prev_nbinPos*2)+1 )

   for MTTE_index, MTTE_addr in this.MTTE_array
      this.nbin := bin_overwrite( Int_HexLE(this.MTempoTrackEvent_MAddr := this.abs_MTTE_Addr + new_offset)
                                          , this.nbin, (MTTE_addr*2)+1 )

   for MSTE_index, MSTE_addr in this.MSTE_array
      this.nbin := bin_overwrite( Int_HexLE(this.MSignatureTrackEvent_MAddr := this.abs_MSTE_Addr + new_offset)
                                          , this.nbin, (MSTE_addr*2)+1 )
   return this.nbin
}

checkMTrackNodes() {
   ; "nodes" are Steinberg lingo for trackversions
   this.TTNode := (this.FindHex("4D54656D706F547261636B4E6F646500")) ? true : false
   this.STNode := (this.FindHex("4D5369676E6174757265547261636B4E6F646500")) ? true : false
}

MTrackOffsets() {
   this.gdoc_offset  := this.FindHex("47446F63756D656E74") - 8                       ; GDocument
   , this.MTTE_pos   := this.FindHex("4D54656D706F547261636B4576656E74") - 8         ; MTempoTrackEvent
   , this.MTTE_bound := this.MTTE_pos + this.ReadInt( this.MTTE_pos + 27 ) + 31
   , this.MSTE_pos   := this.FindHex("4D5369676E6174757265547261636B4576656E74") - 8 ; MSignatureTrackEvent
   , this.MSTE_bound := this.MSTE_pos + this.ReadInt( this.MSTE_pos + 31 ) + 35
   , this.nestedST   := (this.MTTE_bound >= this.MSTE_bound) ? true : false          ; whether MSignatureTrackEvent is nested within MTempoTrackEvent
   , this.end_pos    := (this.nestedST) ? this.MTTE_bound : this.MSTE_bound
   , this.g_offset   := this.gdoc_offset - this.MTTE_pos
}

newAttr() {
   local
   attraddress := this.binpos
   , this.nbin .= (attr_flag := this.Int()) ; FFFFFFFF = set, FEFFFFFF = not set
                . Int_HexLE(attrstrlen := this.ReadInt(,1))
                . (attr_id := this.String(attrstrlen))
                . this.Short()
   
   if (attr_flag = "FEFFFFFF")
      return

   ; msgbox, % attr_id
   this.truncAttrRecord( attr_id, attraddress )
   this.attrJunction( attr_id )
}

exAttr() {
   local
   attraddress  := this.binpos
   , OffsetAddr := abs_OffsetAddr := this.ReadShort(this.binpos+2,1) + this.g_offset
   
   if this.MDataNode_pos
      abs_OffsetAddr += (OffsetAddr > this.MDataNode_pos) ? 20 : 0

   if this.MListNode_pos
      abs_OffsetAddr += (OffsetAddr > this.MListNode_pos) ? 20 : 0
   
   this.nbin     .= Short_HexLE(abs_OffsetAddr + this.curr_pos) . "0080"
   , this.binpos += 2
   , attr_id     := this.ReadHexString(OffsetAddr + 8)
   , this.exAttrOffsets[this.binpos + this.missing_len - 4] := abs_OffsetAddr

   this.truncAttrRecord( attr_id, attraddress )
   this.attrJunction( attr_id )
}

attrJunction( attr_id ) {
   local
   switch attr_id
   {
      case "4D54656D706F547261636B4576656E7400"                  : this.MTempoTrackEvent()
      case "4D547261636B566172696174696F6E436F6C6C656374696F6E00": this.MTrackVariationCollection()
      case "4D547261636B566172696174696F6E00"                    : this.MTrackVariation()
      case "4D54656D706F547261636B4E6F646500"                    : this.MTempoTrackNode()
      case "4D54656D706F547261636B4576656E7400"                  : this.MTempoTrackEvent()
      case "4D5369676E6174757265547261636B4576656E7400"          : this.MSignatureTrackEvent()
      case "4D54696D655369676E61747572654576656E7400"            : this.MTimeSignatureEvent()
      case "4D5369676E6174757265547261636B4E6F646500"            : this.MSignatureTrackNode()
      case "464174747269627574657300"                            : this.FAttributes()
      case "5369676E61747572654576656E7400"                      : this.SignatureEvent()
      case "4D54656D706F4576656E7400"                            : this.MTempoEvent()
      case "5061747465726E4465736300"                            : this.PatternDesc()

      default: 
         Msgbox, Unknown attr_id in attrJunction
         Exit
   }
}

childAttrBuilder(boundary, attr) {
   local
   while (this.binpos < boundary)
   {
      if (this.TruncAttr = 1)
         this.truncAttrBuilder()

      else if (this.new_attrHeaderCheck( this.binpos ) = 1)
         this.newAttr()

      else if (this.ex_attrHeaderCheck( this.binpos ) = 1)
         this.exAttr()

      else
         Msgbox, Unexpected data at the end of %attr%
   }
}

new_attrHeaderCheck( temp_pos ) {
   local
   if (( this.ReadInt( temp_pos ) = -1 || this.ReadInt( temp_pos ) = -2 )
   && this.ReadInt( temp_pos + 4 ) = this.ReadStringLength( temp_pos + 8 ))
      return 1
   return 0
}

ex_attrHeaderCheck( temp_pos ) {
   local
   if (( this.ReadShort( temp_pos ) = -32768 )
   &&  ( this.ReadInt( vtpos := this.ReadShort( temp_pos + 2 ) + this.g_offset ) = -1 || this.ReadInt( vtpos ) = -2 )
   &&  ( this.ReadInt( vtpos + 4 ) = this.ReadStringLength( vtpos + 8 ) ))
      return 1
   return 0
}

all_attrHeaderCheck( temp_pos ) {
   local
   if (this.TruncAttr=1 || this.new_attrHeaderCheck( temp_pos )=1 || this.ex_attrHeaderCheck( temp_pos )=1)
      return 1
   return 0
}

attr_id_lookup( attraddress ) {
   local
   if (this.new_attrHeaderCheck( attraddress ) = 1) {
      tempstrlen := this.ReadInt( attraddress + 4 )
      return SubStr(this.bin, this.bin2str_pos(attraddress+8), tempstrlen*2)
      
   } else if (this.ex_attrHeaderCheck( attraddress ) = 1) {
      tempaddr     := this.ReadShort(attraddress + 2) + 4 + this.g_offset
      , tempstrlen := this.ReadInt( tempaddr )
      return SubStr(this.bin, this.bin2str_pos(tempaddr+4), tempstrlen*2)
   }
   return 0
}

static trunc_id_array := ["4D54656D706F547261636B4E6F646500"               ;"MTempoTrackNode"
                        , "4D5369676E6174757265547261636B4576656E7400"     ;"MSignatureTrackEvent"
                        , "4D547261636B566172696174696F6E00"               ;"MTrackVariation"
                        , "4D54656D706F547261636B4576656E7400"             ;"MTempoTrackEvent"
                        , "4D5369676E6174757265547261636B4E6F646500"]      ;"MSignatureTrackNode"

truncAttrRecord( attr_id, tempattraddress ) {
   local
   if HasVal(this.trunc_id_array, attr_id) {
      this.trunc_addr.push( tempattraddress )
      this.trunc_bound.push( this.binpos + this.ReadInt() + 4 )
   }  
}

truncAttrBuilder() {
   local
   this.TruncAttr   := 0
   , truncAttrIndex := NumGet(&this.trunc_addr + 4*A_PtrSize)

   while( truncAttrIndex > 0 )
   {
      if (this.binpos < this.trunc_bound[truncAttrIndex]) {
         this.truncAttrJunction( this.attr_id_lookup(this.trunc_addr[truncAttrIndex]) )
         return
      }
      truncAttrIndex--
   }
}

truncAttrJunction( attr_id ) {
   local
   switch attr_id
   {
      case "4D54656D706F547261636B4E6F646500"           : this.trunc_Int()
      case "4D54656D706F547261636B4576656E7400"         : this.trunc_MTempoTrackEvent()
      case "4D547261636B566172696174696F6E00"           : this.trunc_Int()
      case "4D5369676E6174757265547261636B4576656E7400" : this.trunc_MSignatureTrackEvent()
      case "4D5369676E6174757265547261636B4E6F646500"   : this.trunc_Int()
   }
}

truncAttrCheck( boundary ) {
   local
   if ( (this.binpos >= boundary) 
   && (this.all_attrHeaderCheck( this.binpos ) = 0) )
      this.TruncAttr := 1
}