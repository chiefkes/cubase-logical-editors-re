Pitch2Num(val) {
   local
	static p2n_array := {"C":0, "C#":1, "Db":1, "D":2, "D#":3, "Eb":3, "E":4, "F":5, "F#":6
		, "Gb":6, "G":7, "G#":8, "Ab":8, "A":9, "A#":10, "Bb":10, "B":11, "Cb":11}
	split_pos := RegExMatch(val, "(-[[:digit:]])|([[:digit:]])")
   pitchNum := (SubStr(val, split_pos)+2)*12 + p2n_array[SubStr(val, 1, split_pos - 1)]
	return pitchNum
}

PPQ_2_Ticks(PPQlen, Sig) {
   local
	oLen   := StrSplit(PPQlen, ".")
   , oSig := StrSplit(Sig, "/")
   , Len  := oLen[4] 
   , Len  += oLen[3]*120
   , Len  += oLen[2]*(1920//oSig[2])
   , Len  += oLen[1]*(Ceil(1920*(oSig[1]/oSig[2])))
	return Len
}