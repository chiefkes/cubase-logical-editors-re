;----- I/O: Data types for endian conversion -----
; Returns data read from this.bin at the current cursor position as recorded in this.binpos
; - return format: little-endian HEX form
; - Advances the file pointer: YES
;-------------------------------------------------

Short() {
   local
   vShort := RegExReplace(SubStr(this.bin, (this.binpos*2)+1, 4)
      , "(..)(..)"
      , "$2$1")
   , this.binpos += 2
   return vShort
}

Int() {
   local
   vInt := RegExReplace(SubStr(this.bin, (this.binpos*2)+1, 8)
      , "(..)(..)(..)(..)"
      , "$4$3$2$1")
   , this.binpos += 4
   return vInt
}

Float() {
   local
   vFloat := RegExReplace(SubStr(this.bin, (this.binpos*2)+1, 8)
      , "(..)(..)(..)(..)"
      , "$4$3$2$1")
   , this.binpos += 4
   return vFloat
}

Int64() {
   local
   vInt64 := RegExReplace(SubStr(this.bin, (this.binpos*2)+1, 16)
      , "(..)(..)(..)(..)(..)(..)(..)(..)"
      , "$8$7$6$5$4$3$2$1")
   , this.binpos += 8
   return vInt64
}

Double() {
   local
   vDouble := RegExReplace(SubStr(this.bin, (this.binpos*2)+1, 16)
      , "(..)(..)(..)(..)(..)(..)(..)(..)"
      , "$8$7$6$5$4$3$2$1")
   , this.binpos += 8
   return vDouble
}

String(str_len) {
   local
   vStr := SubStr(this.bin, (this.binpos*2)+1, str_len*2)
   , this.binpos += str_len
   return vStr
}

;----- I/O: Read data types -----
; Returns data read from this.bin at supplied address.
; Addresses correspond to byte positions as you would find in a HEX editor 
; If no pos is given, pos defaults to the current cursor position as recorded in this.binpos
;  - return format: integer or string
;  - Advances the file pointer: Not by default
;--------------------------------

ReadByte(pos:="") {
   local
   if (pos = "")
      pos := this.binpos
   UByte := Format("{:d}", "0x" SubStr(this.bin, (pos*2)+1, 2))
   return UByte<<56>>56
}

ReadShort(pos:="", adv:=0) {
   local
   if (pos = "")
      pos := this.binpos
   if adv
      this.binpos += 2
   UShort := Format("{:d}", "0x" SubStr(this.bin, (pos*2)+1, 4))
   return UShort<<48>>48
}

ReadInt(pos:="", adv:=0) {
   local
   if (pos = "")
      pos := this.binpos
   if adv
      this.binpos += 4
   UInt := Format("{:d}", "0x" SubStr(this.bin, (pos*2)+1, 8))
   return UInt<<32>>32
}

ReadInt64(pos:="") {
   local
   if (pos = "")
      pos := this.binpos
   UInt64 := Format("{:d}", "0x" SubStr(this.bin, (pos*2)+1, 16))
   return StrLen(UInt64) < 18 ? UInt64 : (SubStr(UInt64,1,StrLen(UInt64)-1)<<4) + abs("0x" . SubStr(UInt64,0))
}

ReadFloat(pos:="") {
   local
   if (pos = "")
      pos := this.binpos
   UInt := Format("{:d}", "0x" SubStr(this.bin, (pos*2)+1, 8))
   return (1-2*(UInt>>31)) * (2**((UInt>>23 & 255)-150)) * (0x800000 | UInt & 0x7FFFFF)
}

ReadDouble(pos:="") {
   local
   if (pos = "")
      pos := this.binpos
   UInt64 := Format("{:d}", "0x" SubStr(this.bin, (pos*2)+1, 16))
   return (2*(UInt64>0)-1) * (2**((UInt64>>52 & 0x7FF)-1075)) * (0x10000000000000 | UInt64 & 0xFFFFFFFFFFFFF)
}

ReadString(pos:="", maxlen:=30) {
   local
   vOutput := ""
   vpos := (pos!="") ? (pos*2)+1 : (this.binpos*2)+1
   Loop, % maxlen
   {
      vHex := SubStr(this.bin, vpos, 2)
      if (vHex = "00")
         break
      vOutput .= this.Hex2String( vHex )
      vpos += 2
   }
   return vOutput
}

ReadHexString(pos:="", maxlen:=30) {
   local
   vOutput := ""
   vpos := (pos!="") ? (pos*2)+1 : (this.binpos*2)+1
   Loop, % maxlen
   {
      vHex := SubStr(this.bin, vpos, 2)
      vOutput .= vHex
      if (vHex = "00")
         break
      vpos += 2
   }
   return vOutput
}

ReadHex(pos:="", vLen:="") {
   local
   if (pos = "")
      pos := this.binpos
   hex := SubStr(this.bin, (pos*2)+1, vLen*2)
   return hex
}

ReadStringLength(pos:="") {
   local
   if (pos = "")
      pos := this.binpos
   str_len := ((InStr(this.bin, "00",, (pos*2)+1)-1)//2)-pos+ 1
   return str_len
}

;----- Tool Functions -----

bin2str_pos(vPos) {
   local
   return (vPos*2)+1 
}

str2bin_pos(vPos) {
   local
   return (vPos-1)//2
}

FindStr(search_str, pos:=1) {
   local
   FoundPos := (InStr(this.bin, AscToHex(search_str),,pos)-1) // 2
   return FoundPos
}

FindHex(search_str, pos:=1) {
   local
   FoundPos := (InStr(this.bin, search_str,,pos)-1) // 2
   return FoundPos
}

Hex2String(x) {
   local
   str := ""
   Loop % StrLen(x)/2 ; 2-digit blocks
   {
      StringLeft hex, x, 2
      str .= Chr("0x" hex)
      StringTrimLeft x, x, 2
   }
   Return str
}

HexToFloat(x) {
   local
   Return (1-2*(x>>31)) * (2**((x>>23 & 255)-150)) * (0x800000 | x & 0x7FFFFF)
}

HexToDouble(x) { ; may be wrong at extreme values
   local
   Return (2*(x>0)-1) * (2**((x>>52 & 0x7FF)-1075)) * (0x10000000000000 | x & 0xFFFFFFFFFFFFF)
}