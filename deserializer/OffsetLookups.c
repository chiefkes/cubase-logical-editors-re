// function: returns the footer offset
int64 getFooterOffset() 
{
	local int64 tempPos, tempLength;
	if (ReadShort(FileSize()-28) == 0) {
		return ( FileSize()-28 );
	}
	// go backwards until we find a string with a valid strlen represented four bytes before it 
	tempPos = FileSize()-16;
	while ( tempPos > 0 ) 
	{
		tempLength = ReadStringLength(tempPos, -1);
		if ( (ReadByte(tempPos-4)-3) == tempLength ) {
			return (tempPos-4);
		}
		--tempPos;    
	}
};

// function: returns the filter targets offset
int64 getFilterOffset() 
{
	local int64 tempPos = FTell();
	while( tempPos < FileSize() ) 
	{
		// check for 0A 00 00 00, followed by 00 or 01
		if ((ReadInt(tempPos) == 10)
		&& (ReadShort(tempPos+4) == 0 || ReadShort(tempPos+4) == 1)
		&& (newAttrCheck(tempPos+10) == 1 || tempPos+10 == Foot_offset)) {
			return tempPos;
		}
		++tempPos;
	}
};

// returns the attribute id at a given offset address
string attrID_lookup( int attrAddress ) 
{
	local string attrID;
	if (newAttrCheck( attrAddress ) == 1) {
		attrID = ReadString( attrAddress + 8, -1);
	}
	else if (existingAttrCheck( attrAddress ) == 1) {
		switch( isLE )
		{
			case 1:
				attrID = ReadString( ReadShort(attrAddress) + 8 + globalOffset, -1);
			break;

			case 0:
				attrID = ReadString( ReadShort(attrAddress + 2) + 8 + globalOffset, -1);
			break;
		}
	}
	return attrID;
};