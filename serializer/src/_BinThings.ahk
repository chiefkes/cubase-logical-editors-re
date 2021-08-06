;-----------------------
; Bin String Things Functions

bin_lineWrap(string, column := 56, indentChar := "") {
   local
	CharLength := StrLen(indentChar)
	columnSpan := column ;- CharLength ; removing CharLength provides expected results when indenting with `t ...?
 , Ptr := A_PtrSize ? "Ptr" : "UInt"
 , NewLineType := A_IsUnicode ? "UShort" : "UChar"
 , UnicodeModifier := A_IsUnicode ? 2 : 1
 , VarSetCapacity(out, (StrLen(string) + (Ceil(StrLen(string) / columnSpan) * (column + CharLength + 1))) * UnicodeModifier, 0)
 , A := &out

	loop, parse, string, `n, `r
	If ((FieldLength := StrLen(ALoopField := A_LoopField)) > column)
	{
		DllCall("RtlMoveMemory", Ptr, A, Ptr, &ALoopField, "UInt", column * UnicodeModifier)
		, A += column * UnicodeModifier
		, NumPut(10, A+0, 0, NewLineType)
		, A += UnicodeModifier
		, Pos := column

		While (Pos < FieldLength)
		{
			If CharLength
				DllCall("RtlMoveMemory", Ptr, A, Ptr, &indentChar, "UInt", CharLength * UnicodeModifier)
				, A += CharLength * UnicodeModifier

			If (Pos + columnSpan > FieldLength)
				DllCall("RtlMoveMemory", Ptr, A, Ptr, &ALoopField + (Pos * UnicodeModifier), "UInt", (FieldLength - Pos) * UnicodeModifier)
				, A += (FieldLength - Pos) * UnicodeModifier
				, Pos += FieldLength - Pos
			Else
				DllCall("RtlMoveMemory", Ptr, A, Ptr, &ALoopField + (Pos * UnicodeModifier), "UInt", columnSpan * UnicodeModifier)
				, A += columnSpan * UnicodeModifier
				, Pos += columnSpan

			NumPut(10, A+0, 0, NewLineType)
			, A += UnicodeModifier
		}
	} 
	Else
		DllCall("RtlMoveMemory", Ptr, A, Ptr, &ALoopField, "UInt", FieldLength * UnicodeModifier)
	 , A += FieldLength * UnicodeModifier
	 , NumPut(10, A+0, 0, NewLineType)
	 , A += UnicodeModifier

	VarSetCapacity(out, -1)
	Return SubStr(out,1, -1)
}

bin_overwrite(overwrite, into, pos=1) {
   local
	If (abs(pos) > StrLen(into))
		return 0
	else If (pos>0)
		return substr(into, 1, pos-1) . overwrite . substr(into, pos+StrLen(overwrite))
	else If (pos<0)
		return SubStr(into, 1, pos) . overwrite . SubStr(into " ",(abs(pos) > StrLen(overwrite) ? pos+StrLen(overwrite) : 0),abs(pos+StrLen(overwrite)))
	else If (pos=0)
		return into . overwrite
}

bin_Insert(insert,input,pos=1) {
   local
	Length := StrLen(input)
	((pos > 0) ? (pos2 := pos - 1) : (((pos = 0) ? (pos2 := StrLen(input),Length := 0) : (pos2 := pos))))
	output := SubStr(input, 1, pos2) . insert . SubStr(input, pos, Length)
	If (StrLen(output) > StrLen(input) + StrLen(insert))
		((Abs(pos) <= StrLen(input)/2) ? (output := SubStr(output, 1, pos2 - 1) . SubStr(output, pos + 1, StrLen(input))) : (output := SubStr(output, 1, pos2 - StrLen(insert) - 2) . SubStr(output, pos - StrLen(insert), StrLen(input))))
	return output
}