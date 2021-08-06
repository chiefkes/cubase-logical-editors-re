//----------------------------------------
// CONSTRUCTOR FUNCTIONS

void mainBinTraverser( int64 boundary, string attr ) 
{
	while ( FTell() < boundary )
	{
		if ( existingAttrCheck( FTell() ) == 1 ) 
		{
			switch( sectionType ) 
			{
				case 0: CONT_ATTR action( boundary ); break;
				case 1: CONT_ATTR filter( boundary ); break;
			}
			continue;
		}

		else if ( newAttrCheck( FTell() ) == 1 ) 
		{
			switch( sectionType ) 
			{
				case 0: ATTR action( boundary ); break;
				case 1: ATTR filter( boundary ); break;
			}
			continue;
		}

		else 
		{
			short unk; Printf("\nUnexpected data at the end of %s (addr = %Ld)", attr, FTell() );
		}
	}
};


// sets any flags (based on attrID) that affect the behaviour of attrJunction branches
void setAttrFlags( string attrID ) 
{
	local int size;
	if (RegExSearch(attrID, "Target", size) >= 0) {
    TypeTarget = attrID;
		return;
	}

	switch( attrID )
	{
		case "MTempoTrackNode"      : TTNode     = "true"; break;
		case "MSignatureTrackNode"  : STNode     = "true"; break;
		// case "MTempoTrackEvent"     : MTrackType = "MTempoTrackEvent"; break;
		// case "MSignatureTrackEvent" : MTrackType = "MSignatureTrackEvent"; break;
	}
};

void attrJunction( int64 boundary ) 
{
		local int size;
		if (RegExSearch(currAttr, "ActionTarget", size) >= 0) 
		{
			switch( NestedStruct ) 
			{ 
				case 0: actionTarget(); break;
				case 1: ACTION_TARGET content <open=true>; break;
			}
			return;
		}

		else if (RegExSearch(currAttr, "Target", size) >= 0)
		{
			switch( NestedStruct ) 
			{
				case 0: filterTarget(); break;
				case 1: FILTER_TARGET content <open=true>; break;
			} 
			return;
		}

		switch( currAttr )
		{
			//---------------------------------------------
			// Common
			case "leToken"                   : attr_leToken(); break;
			case "LeUIntValue"               : attr_LeUIntValue(); break;
			case "UFloatValue"               : attr_UFloatValue(); break;
			case "LeUFloatValue"             : attr_LeUFloatValue(); break;
			case "UIntValue"                 : attr_UIntValue(); break;
			case "UStringValue"              : attr_UStringValue(); break;
			case "LeTTimeDiffValue"          : attr_LeTTimeDiffValue(); break;
			case "LeTTimeValue"              : attr_LeTTimeValue(); break;
			case "FAttributes"               : attr_FAttributes(); break;
			case "MSignatureTrackEvent"      : attr_MSignatureTrackEvent(); break;
			case "MTempoTrackEvent"          : attr_MTempoTrackEvent(); break;
			case "MTrackVariationCollection" : attr_MTrackVariationCollection(); break;
			case "MTrackVariation"           : attr_MTrackVariation(); break;
			case "MTempoTrackNode"           : attr_MTempoTrackNode(); break;
			case "MTempoEvent"               : attr_MTempoEvent(); break;
			case "MSignatureTrackNode"       : attr_MSignatureTrackNode(); break;
			case "MTimeSignatureEvent"       : attr_MTimeSignatureEvent(); break;
			case "PatternDesc"               : attr_PatternDesc(); break;
			//---------------------------------------------
			// Logical Editor
			case "LeTypeValue"               : attr_LeTypeValue(); break;
			case "LEMidiChannelValue"        : attr_LEMidiChannelValue(); break;
			case "PMidiNoteValue"            : attr_PMidiNoteValue(); break;
			case "PControllerValue"          : attr_PControllerValue(); break;
			case "PMidiKeyValue"             : attr_PMidiKeyValue(); break;
			case "PMidiScaleValue"             : attr_PMidiScaleValue(); break;
			case "LeHistoryValue"            : attr_LeHistoryValue(); break;
			case "LeAllroundValue"           : attr_LeAllroundValue(); break;
			case "leContextTypeTarget"       : attr_leContextTypeTarget(); break;
			//---------------------------------------------
			// Project Logical Editor
			case "LeContainerTypeValue"      : attr_LeContainerTypeValue(); break;
			case "LeMediaTypeValue"          : attr_LeMediaTypeValue(); break;
			case "LeFlagsValue"              : attr_LeFlagsValue(); break;
			case "LeGenericOpValue"          : attr_LeGenericOpValue(); break;
			case "LeDomainTypeValue"         : attr_LeDomainTypeValue(); break;

			default: short unknown; break;
	}
};
