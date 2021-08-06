//------------------------------------------------
//--- 010 Editor v10.0 Binary Template
//
//      File: Cubase PLE/LE Preset Binaries
//   Authors: Max Liefkes
//   Version: 
//   Purpose: 
//  Category: 
// File Mask: 
//  ID Bytes: 
//   History: 
//------------------------------------------------


#include "TypeDefs.c"
#include "TestStructs.c"
#include "MainStructs.c"
#include "Traversal.c"
#include "AttrTypeChecks.c"
#include "OffsetLookups.c"
#include "TruncatedAttr.c"
#include "Utils.c"
#include "GlobalValues.c"
#include "DataTypeValues.c"
#include "FilterTypeValues.c"
#include "TimeTypeValues.c"


//---------------------------------------------
// Local Template Variables
local int Num_Actions
		, Num_Filters
		, AT_offset
		, FT_offset
		, Foot_offset
		, tempoffset
		, currAttrAddress
		, TrackOp
		, Condition
		, sectionType
		, TruncAttr
		, TTVersions
		, TargetBoundary;

		
local string currAttr
			, temp_TimeBase
			, FAttributes
			, TTNode
			, STNode
			, MTrackType
			, Op
			, TypeTarget = "";


// ======================
// = Start of main code =
// ======================

LittleEndian();
// 1 - attr spawns are nested inside target structs
// 0 - no nesting
local int NestedStruct = 0;
local int isLE = 1;
local int64 globalOffset = 0;

local int64 MTTE_pos = FindFirst("MTempoTrackEvent", true, true, 0, 0.0, 1, 0, 0, 24) - 8;
local int64 MTTE_bound = 31 + MTTE_pos + ReadInt( MTTE_pos + 27 );
local int64 MSTE_pos = FindFirst("MSignatureTrackEvent", true, true, 0, 0.0, 1, 0, 0, 24) - 8;
local int64 MSTE_bound = 35 + MSTE_pos + ReadInt( MSTE_pos + 31 );
if (MTTE_bound > MSTE_bound)
	local int endpos = MTTE_bound;
else
	local int endpos = MSTE_bound;


// Output printing
Printf("\n//---------------------------------------------");
Printf("\n// ROOT SECTION OFFSETS\n");

Printf("\nActions Root Address = %Ld", AT_offset);
Printf("\nFilters Root Address = %Ld", FT_offset);
Printf("\nFooters Address = %Ld", Foot_offset);

Printf("\n\n//---------------------------------------------");
Printf("\n// VALUE INFO\n");



mainBinTraverser( endpos, "MTrack Root" );
char rest_of_file[FileSize() - FTell()] <fgcolor=cDkGray, bgcolor=cBlack>;


// Print info for potentially truncated attributes
Printf("\n\n//---------------------------------------------");
Printf("\n// TRUNCATION INFO\n");
local int i;
for( i = 0; i < arraysize; i++ ) 
{
	if (oAttr_addr[i] != 0) {
		Printf("\nTrunc%Ld = %s, Addr = %Ld, Bound = %Ld"
			, i+1, attrID_lookup( oAttr_addr[i] - 1 ), oAttr_addr[i]-1, oAttr_bound[i]);
	}
}