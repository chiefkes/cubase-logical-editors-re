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


// 1 - attr spawns are nested inside target structs
// 0 - no nesting
local int NestedStruct = 0;
local int isLE = 1;
local int64 globalOffset = 0;


// Define the headers
LittleEndian();
SetForeColor( cWhite );
SetBackColor( cBlack );
HEADER header;


// Define the name
SetForeColor( cGreen );
NAME name;


// Define the action targets header
SetForeColor( cWhite );
SetBackColor( cDkRed );
ACTION_HEADER ah;
SetForeColor( cWhite );
SetBackColor( cBlack );


// Determine root section addresses
Foot_offset = getFooterOffset();
FT_offset = getFilterOffset();


// Output printing
Printf("\n//---------------------------------------------");
Printf("\n// ROOT SECTION OFFSETS\n");

Printf("\nActions Root Address = %Ld", AT_offset);
Printf("\nFilters Root Address = %Ld", FT_offset);
Printf("\nFooters Address = %Ld", Foot_offset);

Printf("\n\n//---------------------------------------------");
Printf("\n// VALUE INFO\n");


// Define Action target attributes if they exist
if ( Num_Actions !=0 ) {
	mainBinTraverser( FT_offset, "Actions Root" );     
}


// Define the filter targets header
SetForeColor( cWhite );
SetBackColor( cDkRed );
FILTER_HEADER fh;
SetForeColor( cWhite );
SetBackColor( cBlack );


// Define Filter target attributes if they exist
if ( Num_Filters !=0 ) {
	mainBinTraverser( Foot_offset, "Filters Root" );
}


// Define the footer
SetForeColor( cWhite );
FOOTER footer;


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