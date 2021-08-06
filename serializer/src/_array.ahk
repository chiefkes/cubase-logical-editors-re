HasVal(haystack, needle) {
   local
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

IsSimple(arr) {
   local
   For k, v in arr
      If (A_Index != k)
         Return 0
   Return 1
}
