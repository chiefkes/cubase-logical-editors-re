//----------------------------------------
// TRUNC ARRAYS

// increase for preset with an extreme number of tokens
local int arraysize = 30;
local int oAttr_addr[arraysize];
local int oAttr_bound[arraysize];

//----------------------------------------
// TRUNC FUNCTIONS


// records the start and end addresses of attributes than can potentially "truncate"
void truncAttrLocationRecorder( string attrID, int attrAddress ) {
	switch( attrID )
	{
		case "leColorTypeTarget":
		case "leTypesTarget":
		case "leActionTargetTypes":
		case "LeTTimeDiffValue": 
		case "LeTTimeValue":
		case "MTempoTrackEvent":
		case "MTempoTrackNode": 
		case "MSignatureTrackEvent":
		case "MSignatureTrackNode":
		case "MTrackVariation": 
			break;
		default: return;
	}

	local int i;
	for( i = 0; i < arraysize; i++ )
	{
		if (oAttr_addr[i] == 0) {
			oAttr_addr[i] = attrAddress + 1;
			oAttr_bound[i] = FTell() + ReadInt() + 4;
			return;
		}
	}
};

// if we've passed the attribute boundary and the next bytes aren't a valid
// attribute header, check for the most recently "truncatable" attribute and construct accordingly
void truncAttrCheck( int64 TargetBoundary ) {
	if ( (FTell() >= TargetBoundary) 
	&& (allTypesCheck( FTell() ) == 0) ) {
    local int i, temp_sectionType = sectionType;

		for( i = arraysize-1; i >= 0; i-- )
    {
      if ( FTell() < oAttr_bound[i] ) {
        local string attrID;
        attrID = attrID_lookup( oAttr_addr[i] - 1 );
        switch( temp_sectionType ) 
        {
          case 0: TRUNC_ATTR action( attrID ); break;
          case 1: TRUNC_ATTR filter( attrID ); break;
        }
        return;
      }
    }
	}
};