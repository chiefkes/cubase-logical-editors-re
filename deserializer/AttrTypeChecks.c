// checks for all types of attributes
int allTypesCheck( int64 tempPos ) 
{
	if ( (existingAttrCheck( tempPos )==1) || (newAttrCheck( tempPos )==1) ) {
		return 1;
	}
	return 0;
};


// checks for a valid "new attribute" header followed by length prefixed ascii id
int newAttrCheck( int64 tempPos ) 
{
	if (( ReadInt(tempPos) == -1 || ReadInt(tempPos) == -2 )
	&& ( ReadInt(tempPos+4) == ReadStringLength(tempPos+8) )) {
		return 1;
	}
	return 0;
};


// checks for a valid "existing attribute" header that references a location with a length prefixed ascii id
int existingAttrCheck( int64 tempPos ) 
{
	switch( isLE )
	{
		case 1:
			if (( ReadShort(tempPos+2)==-32768 )
			&& ( ReadInt(ReadShort( tempPos )) == -1 || ReadInt(ReadShort( tempPos )) == -2 )
			&& ( ReadInt(ReadShort( tempPos )+4) == ReadStringLength(ReadShort( tempPos )+8) )) {
				return 1;
			}
			return 0;
		break;

		case 0:
			if (( ReadShort(tempPos)==-32768 )
			&& ( ReadInt(ReadShort( tempPos + 2 )+ globalOffset) == -1 || ReadInt(ReadShort( tempPos + 2 ) + globalOffset) == -2 )
			&& ( ReadInt(ReadShort( tempPos + 2 )+ 4 + globalOffset) == ReadStringLength(ReadShort( tempPos + 2 ) + 8 + globalOffset) )) {
				return 1;
			}
			return 0;
		break;
	}
};