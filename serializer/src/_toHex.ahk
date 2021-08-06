;-----------------------
; Number to Hex Little Endian - fastest methods
Short_HexLE(Num) {
   local
	VarSetCapacity(LE, A_PtrSize, 0)
	NumPut(Num, LE, "Short")
	return RegExReplace(Format("{:04X}", NumGet(LE, "Int64"))
		, "(..)(..)"
		, "$2$1")
}
; (approx 0.001234 ms)

Int_HexLE(Num) {
   local
	VarSetCapacity(LE, A_PtrSize, 0)
	NumPut(Num, LE, "Int")
	return RegExReplace(Format("{:08X}", NumGet(LE, "Int64"))
		, "(..)(..)(..)(..)"
		, "$4$3$2$1")
}

Int64_HexLE(Num) {
   local
	VarSetCapacity(LE, A_PtrSize, 0)
	NumPut(Num, LE, "Int64")
	return RegExReplace(Format("{:016X}", NumGet(LE, "Int64"))
		, "(..)(..)(..)(..)(..)(..)(..)(..)"
		, "$8$7$6$5$4$3$2$1")
}
; (approx 0.001344 ms)

Float_HexLE(float) {
   local
	VarSetCapacity(f, A_PtrSize, 0)
	NumPut(float, f, "Float")
	return RegExReplace(Format("{:08X}", NumGet(f, "Int64"))
		, "(..)(..)(..)(..)"
		, "$4$3$2$1")
}
; (approx 0.00175 ms)

Double_HexLE(double) {
   local
	VarSetCapacity(d, A_PtrSize, 0)
	NumPut(double, d, "Double")
	return RegExReplace(Format("{:016X}", NumGet(d, "Int64"))
		, "(..)(..)(..)(..)(..)(..)(..)(..)"
		, "$8$7$6$5$4$3$2$1")
}
; (approx 0.00234 ms)

AscToHex(needle) {
   local
	Hex := ""
	Loop, Parse, needle
		Hex .= Format("{:02X}", Asc(A_LoopField))
	return Hex
}
; (approx 0.002953 ms)