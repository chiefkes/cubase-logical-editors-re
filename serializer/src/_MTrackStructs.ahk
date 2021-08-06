MTempoTrackEvent() {
   local
   this.abs_MTTE_Addr            := this.binpos
   , this.MTempoTrackEvent_MAddr := this.abs_MTTE_Addr + this.curr_pos
   , attr_length                 := this.ReadInt(,1)
   , attr_boundary               := attr_length + this.binpos

   if this.TTNode
      attr_length += 20

   if (this.STNode && this.nestedST)
      attr_length += 20

   this.nbin   .= Int_HexLE(attr_length)
   , this.nbin .= Int_HexLE(Num_TempoTrackEvents := this.ReadInt(,1))

   loop, % Num_TempoTrackEvents
      this.TempoTEvent()

   this.nbin .= this.Float() 
              . this.Short() 
              . this.Int()

   this.MTrackSubConstructor()
   this.childAttrBuilder(attr_boundary, "MTempoTrackEvent")
}


trunc_MTempoTrackEvent() {
   this.MTrackSubConstructor()
   this.truncAttrCheck( this.binpos )
}


TempoTEvent() {
   this.nbin .= this.Float() 
              . this.Double() 
              . this.Double() 
              . this.Short()
}


MTrackVariationCollection() {
   local
   attr_length     := this.ReadInt(,1)
   , attr_boundary := attr_length + this.binpos
   
   if !this.MSignatureTrackEvent_MAddr {
      if this.TTNode
         attr_length += 20

      if (this.STNode && this.nestedST)
         attr_length += 20
   }
   
   else if this.STNode
      attr_length += 20

   this.nbin .= Int_HexLE(attr_length) 
              . this.Int() 
              . this.Short() 
              . this.Int()

   this.childAttrBuilder(attr_boundary, "MTrackVariationCollection")
}


MTrackVariation() {
   local
   attr_length     := this.ReadInt(,1)
   , attr_boundary := attr_length + this.binpos
   , tempbin       := Int_HexLE(str_len := this.ReadInt(,1))

   if (str_len != 0 )
      tempbin   .= this.String(str_len)

   if (this.all_attrHeaderCheck( this.binpos ) = 0) {
      tempbin   .= this.Int() 
                 . this.Int()
      this.nbin .= Int_HexLE(attr_length) 
                 . tempbin

      this.childAttrBuilder(attr_boundary, "MTrackVariation")
      this.truncAttrCheck( attr_boundary )
      return
   }

   if !this.MSignatureTrackEvent_MAddr {
      if (this.TTNode && !this.MDataNode_pos) {
         tempbin              .= "FEFFFFFF0B0000004D41727261794E6F6465000000" ;MArrayNode
         , this.MDataNode_pos := this.binpos + 21
         , this.binpos        += 21
         , tempbin            .= "FEFFFFFF0A0000004D446174614E6F6465000000" ;MDataNode
         , this.missing_len   += 20
         , attr_length        += 20

         if (this.STNode && this.nestedST) {
            attr_length += 20
         }
      }
   }

   else if (this.STNode && !this.MListNode_pos) {
      this.MListNode_pos := this.binpos
      , tempbin          .= "FEFFFFFF0A0000004D4C6973744E6F6465000000" ;MListNode
      , this.missing_len += 20
      , attr_length      += 20
   }

   this.nbin .= Int_HexLE(attr_length) . tempbin
   this.childAttrBuilder(attr_boundary, "MTrackVariation")
   this.truncAttrCheck( attr_boundary )
}


MTempoTrackNode() {
   local
   attr_length     := this.ReadInt(,1)
   , attr_boundary := attr_length + this.binpos

   if (this.STNode && this.nestedST)
      attr_length += 20

   this.nbin .= Int_HexLE(attr_length)

   , this.nbin .= Int_HexLE(str_len := this.ReadInt(,1))
   if (str_len != 0 )
      this.nbin .= this.String(str_len)

   this.nbin .= this.Int() 
              . Int_HexLE(this.MTempoTrackEvent_MAddr)

   this.MTTE_array.push(this.binpos + this.missing_len)
   this.binpos += 4


   if (this.all_attrHeaderCheck(this.binpos) = 0 ) {
      this.nbin   .= Int_HexLE(this.MSignatureTrackEvent_MAddr)
      this.MSTE_array.push(this.binpos + this.missing_len)
      this.binpos += 4
      , this.nbin .= this.Int()
   }

   this.childAttrBuilder(attr_boundary, "MTempoTrackNode")
}


trunc_Int() {
   this.nbin .= this.Int()
}


MTempoEvent() {
   local
   this.nbin       .= Int_HexLE(attr_length := this.ReadInt(,1))
   , attr_boundary := attr_length + this.binpos

   this.nbin .= this.Float() 
              . this.Double() 
              . this.Double() 
              . this.Int()

   this.truncAttrCheck( attr_boundary )
}


MTrackSubConstructor() {
   local
   SubAttr := 1
   while (SubAttr = 1 )
   {
      switch this.ReadHex(, 4)
      {
         case "44494C54": this.MTrackSub_L("544C4944") ;TLID
         case "454E5454": this.MTrackSub_L("54544E45") ;TTNE
         case "62726146": this.MTrackSub_L("46617262") ;Farb
         case "73687445": this.MTrackSub_L("45746873") ;Eths
         case "69435654": this.MTrackSub_S("54564369") ;TVCi
         case "64696854": this.MTrackSub_L("54686964") ;Thid
         case "426C5454": this.MTrackSub_L("54546C42") ;TTlB
         case "42755454": this.MTrackSub_L("54547542") ;TTuB
         case "6B636F4C": this.MTrackSub_L("4C6F636B") ;Lock
         case "53636F4C": this.MTrackSub_L("4C6F6353") ;LocS
         case "736B6C43": this.MTrackSub_S("436C6B73") ;Clks
         default: SubAttr := 0
      }
   }
}


MTrackSub_L(hex_str) {
   this.binpos += 4
   this.nbin   .= hex_str 
                . this.Short() 
                . this.Int64()
}


MTrackSub_S(hex_str) {
   this.binpos += 4
   this.nbin   .= hex_str 
                . this.Short()
}


MSignatureTrackEvent() {
   local
   this.abs_MSTE_Addr := this.binpos + this.missing_len
   , this.MSignatureTrackEvent_MAddr := this.abs_MSTE_Addr + this.curr_pos
   , attr_length      := this.ReadInt(,1)
   , attr_boundary    := attr_length + this.binpos

   if this.STNode
      attr_length += 20

   this.nbin .= Int_HexLE(attr_length)
              . Int_HexLE( this.Num_SigTrackEvents := this.ReadInt(,1) )

   loop, % this.Num_SigTrackEvents
      this.SigTEvent()

   this.nbin .= this.Int()

   this.MTrackSubConstructor()
   this.childAttrBuilder(attr_boundary, "MSignatureTrackEvent")
}


trunc_MSignatureTrackEvent() {
   this.MTrackSubConstructor()
}


SigTEvent() {
   this.nbin .= this.Int() 
              . this.Short() 
              . this.Short() 
              . this.Int() 
              . this.Short() 
              . this.Short()
}


MSignatureTrackNode() {
   local
   this.nbin       .= Int_HexLE(attr_length := this.ReadInt(,1))
   , attr_boundary := attr_length + this.binpos
   , this.nbin     .= Int_HexLE(str_len := this.ReadInt(,1))

   if (str_len != 0 )
      this.nbin .= this.String(str_len)

   this.nbin .= this.Int() 
              . Int_HexLE(this.MTempoTrackEvent_MAddr)

   this.MTTE_array.push(this.binpos + this.missing_len)
   this.binpos += 4

   if (this.all_attrHeaderCheck( this.binpos ) = 0) {
      this.nbin     .= Int_HexLE(this.MSignatureTrackEvent_MAddr)
      , this.binpos += 4
      , this.nbin   .= this.Int()
   }

   this.childAttrBuilder(attr_boundary, "MSignatureTrackNode")
}


MTimeSignatureEvent() {
   local
   this.nbin       .= Int_HexLE(attr_length := this.ReadInt(,1))
   , attr_boundary := attr_length + this.binpos

   , this.nbin .= this.Int64() 
                . this.Short() 
                . this.Short() 
                . this.Int() 
                . this.Short() 
                . this.Short()
                . Int_HexLE( Num_SubAttributes := this.ReadInt(,1) )

   if (Num_SubAttributes != 0) {
      this.MTSE_SubConstructor()
      this.childAttrBuilder(attr_boundary, "MTimeSignatureEvent")
   }

   this.truncAttrCheck( attr_boundary )
}


PatternDesc() {
   local
   this.nbin    .= this.Int()
   , Num_Clicks := this.ReadShort(,1)

   , this.nbin  .= Short_HexLE(Num_Clicks) 
                . this.Short()
   
   loop, % Num_Clicks
      this.nbin .= this.Short()

   this.nbin .= this.Short() 
              . this.Int() 
              . this.Double() 
              . this.Double() 
              . this.Short() 
              . this.Short()
}


MTSE_SubConstructor() {
   local
   SubAttr := 1
   while (SubAttr = 1 )
   {
      switch this.ReadHex(, 4)
      {
         case "62726146": this.MTrackSub_L("46617262") ; Farb
         case "6B696C43": this.MTrackSub_S("436C696B") ; Clik
         default: SubAttr := 0
      }
   }
}


FAttributes() {
   local
   this.nbin       .= Int_HexLE(attr_length := this.ReadInt(,1))
   , attr_boundary := attr_length + this.binpos
   , this.nbin     .= this.Int()

   this.FAttrSubConstructor()

   loop, % this.Num_SigTrackEvents-1
   {
      this.nbin .= this.Short()
      this.FAttrSubConstructor()
   }

   this.truncAttrCheck( attr_boundary )
}


FAttrSubConstructor() {
   local
   SubAttr := 1
   while (SubAttr = 1 )
   {
      tempstrlen := this.ReadInt()
      switch (subattrid := this.ReadHex(this.binpos+4, tempstrlen))
      {
         case "5369676E61747572654576656E7400"              : this.F_SignatureEvent()
         case "4D54696D655369676E61747572654576656E7400"    : this.F_MTimeSignatureEvent()
         case "466C61677300"                                : this.F_SubAttr(subattrid) ; F_Flags
         case "537461727400"                                : this.F_SubAttr(subattrid) ; F_Start
         case "4C656E67746800"                              : this.F_SubAttr(subattrid) ; F_Length
         case "42617200"                                    : this.F_SubAttr(subattrid) ; F_Bar
         case "4E756D657261746F7200"                        : this.F_SubAttr(subattrid) ; F_Numerator
         case "44656E6F6D696E61746F7200"                    : this.F_SubAttr(subattrid) ; F_Denominator
         case "506F736974696F6E00"                          : this.F_SubAttr(subattrid) ; F_Position
         case "4164646974696F6E616C204174747269627574657300": this.F_Additional_Attributes()
         default: SubAttr := 0
      }
   }
}


F_SignatureEvent() {
   this.nbin .= this.Int()
              . "5369676E61747572654576656E7400"
   , this.binpos += 15
   , this.nbin .= this.Short() 
                . this.Short() 
                . this.Int() 
                . this.Short()
}


F_MTimeSignatureEvent() {
   this.nbin .= this.Int()
              . "4D54696D655369676E61747572654576656E7400"
   , this.binpos += 20
   , this.nbin .= this.Int64() 
                . this.Int()
}


F_SubAttr(subattrstr) {
   local
   this.nbin .= this.Int()
              . subattrstr
   , this.binpos += (StrLen(subattrstr)//2)
   , this.nbin .= this.Short() 
                . this.Int64()
}


F_Additional_Attributes() {
   this.nbin .= this.Int()
              . "4164646974696F6E616C204174747269627574657300"
   , this.binpos += 22
   , this.nbin .= this.Short() 
                . this.Short() 
                . this.Int()
   this.FAttr_Add_SubConstructor()
}


FAttr_Add_SubConstructor() {
   local
   SubAttr := 1
   while (SubAttr = 1 )
   {
      tempstrlen := this.ReadInt()

      if InStr((subattrid := this.ReadHex(this.binpos+4, tempstrlen)), "416363656E74") {
         this.F_Add_SubAttr(subattrid)
         continue
      }

      switch subattrid
      {
         case "436C696B00"              : this.FA_Clik()
         case "5061747465726E4465736300": this.FA_PatternDesc()
         case "6261736500"              : this.F_Add_SubAttr(subattrid)       ;base
         case "757365724C656E67746800"  : this.F_Add_SubAttr(subattrid)       ;userLength
         case "496E666F00"              : this.FA_Ascii(subattrid)            ;Info
         case "73643100", "73643200"
            , "73643300", "73643400"    : this.F_Add_SubAttr(subattrid)       ;sd1, sd2 etc
         case "74656D706F4C65667400"    : this.F_Add_SubAttr(subattrid)       ;tempoLeft
         case "74656D706F526967687400"  : this.F_Add_SubAttr(subattrid)       ;tempoRight
         case "6E756D657261746F7200"    : this.F_Add_SubAttr(subattrid)       ;numerator
         case "64656E6F6D696E61746F7200": this.F_Add_SubAttr(subattrid)       ;denominator
         case "697344656661756C7400"    : this.F_Add_SubAttr(subattrid)       ;isDefault
         case "4E616D6500"              : this.FA_Ascii(subattrid)            ;Name
         case "4661726200"              : this.F_Add_SubAttr(subattrid)       ;Farb
         default: SubAttr := 0
      }
   }
}


FA_Clik() {
   this.nbin .= this.Int()
              . "436C696B00"
   , this.binpos += 5
   , this.nbin .= this.Short() 
                . this.Short()
}


FA_PatternDesc() {
   this.nbin .= this.Int()
              . "5061747465726E4465736300"
   , this.binpos += 12
   , this.nbin .= this.Int64() 
                . this.Int()
}


F_Add_SubAttr(subattrid) {
   local
   this.nbin .= this.Int()
              . subattrid
   , this.binpos += (StrLen(subattrid)//2)
   , this.nbin .= this.Short() 
                . this.Int64()
}


FA_Ascii(subattrid) {
   local
   this.nbin .= this.Int()
              . subattrid         
   , this.binpos += (StrLen(subattrid)//2)

   , this.nbin .= this.Short()
                . Int_HexLE( str_len := this.ReadInt(,1) )
                  
   if (str_len != 0 )
      this.nbin .= this.String(str_len)
}