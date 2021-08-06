//----------------------------------------
// TestStructs

// a struct for testing whether values deviate from expectations
typedef struct(string type, string value, string attr) {
	local int tempLength;
	local string tempType = type;
	local double i = Atof( value );

	switch( type )
	{
		case "short": 
		case "int16":
			short val;
			tempLength = 2;
			break;
		case "int":
			int val;
			tempLength = 4;
			break;
		case "int64":
			int64 val;
			tempLength = 8;
			break;
		case "float":
			float val;
			tempLength = 4;
			break;
		case "double":
			double val;
			tempLength = 8;
			break;
	}

	local double x = val;
	if (x != i) {
		switch ( type ) 
		{
			default: 
				Printf( "\nUnexpected Value (%Ld) in '%s' (addr = %Ld)"
					, val, attr, FTell() - tempLength); break;
			case "float": 
			case "double":
				Printf( "\nUnexpected Value (%f) in '%s' (addr = %Ld)"
					, val, attr, FTell() - tempLength); break;
		}
	}
} knownValue <read=Read_knownValue>;


string Read_knownValue( knownValue &m ) {
	local string tempStr;
	switch( m.tempType ) 
	{
		default:
			SPrintf(tempStr, "%Ld (%s)", m.val, m.tempType); break;
		case "float": 
		case "double":
			SPrintf(tempStr, "%f (%s)", m.val, m.tempType); break;
	}
	return tempStr;
};


// struct for printing test vals
typedef struct(string type, string attr) {
	local int tempLength;
	local string tempType = type;

	switch( type )
	{
		case "short": 
		case "int16": 
			short val;
			tempLength = 2; 
			break;
		case "int": 
			int val;
			tempLength = 4;
			break;
		case "int64":
			int64 val;
			tempLength = 8;
			break;
		case "float": 
			float val;
			tempLength = 4;
			break;
		case "double":
			double val;
			tempLength = 8;
			break;
	}

	switch ( type ) 
	{
		case "float": 
		case "double":
			Printf("\nTest Val in '%s' = %f (addr = %Ld)"
				, attr, val, FTell() - tempLength); break;
		default:
			Printf("\nTest Val in '%s' = %Ld (addr = %Ld)"
				, attr, val, FTell() - tempLength); break;
	}
} testValue <read=Read_testValue>;


string Read_testValue( testValue &m ) {
	local string tempStr;
	switch( m.tempType ) 
	{
		default:
			SPrintf(tempStr, "%Ld (%s)", m.val, m.tempType); break;
		case "float": 
		case "double":
			SPrintf(tempStr, "%f (%s)", m.val, m.tempType); break;
	}
	return tempStr;
};