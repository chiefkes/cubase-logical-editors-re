//----------------------------------------
// HEADER - static
typedef struct { 
	char magic[8];
} HEADER;

//----------------------------------------
// PRESET NAME
typedef struct { 
    int nameLength <fgcolor=cGreen, bgcolor=cBlue>; //
    if ( nameLength != 0 ) {
    	string Preset_Name <fgcolor=cWhite, bgcolor=cBlue>; 
    	BOM utf8 <comment="Byte Order Mark">;
    }
} NAME <read=Read_NAME>;


string Read_NAME( NAME &m ) {
	// returns the PLE / LE preset name for display
	if ( m.nameLength != 0 ) {
		local string tempStr;
		SPrintf(tempStr, "Preset: %s", m.Preset_Name);
		return tempStr;
	}
	else {
		return "";
	}
};

//----------------------------------------
// FOOTER
typedef struct {
	int macroLength <fgcolor=cGreen, bgcolor=cBlue>;

	if ( macroLength != 0 ) {
		string Macro <fgcolor=cWhite, bgcolor=cBlue>; 
		BOM utf8;
	}

	int presetFunction <read=Read_presetFunction>;
    int editorType <read=Read_editorType>; // 1 = PLE, 0 = LE
    int Ending[4]; 
} FOOTER <read=Read_FOOTER>;


string Read_FOOTER( FOOTER &m ) {
	local string tempStr;
	// local string function = ;
	// returns the PLE / LE preset name for display
	if ( m.macroLength != 0 ) {
		SPrintf(tempStr, "%s | Function:%s | Macro: %s"
			, Read_editorType( m.editorType )
			, Read_presetFunction( m.presetFunction )
			, m.Macro);
	} else {
		SPrintf(tempStr, "%s | Function: %s"
			, Read_editorType( m.editorType )
			, Read_presetFunction( m.presetFunction ) );
	} return tempStr;
};


string Read_presetFunction( int i ) {
	switch( i ) {
		case 0 :  return "Delete";
		case 1 :  return "Transform";
		case 2 :  return "Insert";
		case 3 :  return "Insert Exclusive";
		case 4 :  return "Copy";
		case 5 :  return "Extract";
		case 6 :  return "Select";
		default : return "Undefined";
	}
};

string Read_editorType( int i ) {
	switch( i ) {
		case 0 :  return "LE";
		case 1 :  return "PLE";
		default : return "Undefined";
	}
};


//----------------------------------------
// ACTION / FILTER HEADERS
typedef struct {
	AT_offset = FTell();
	int Targets_Header;
	// short 	Action_Flag <read=Read_targetflag, comment="Not sure what this indicates yet...">;
	knownValue _("short", "1", "Actions Header");
	int NumActions <comment="Total number of Action Targets">;
	Num_Actions = NumActions;
	sectionType = 0;
} ACTION_HEADER;


// filter targets struct 
typedef struct { 
	int Targets_Header;
	// short 	Filter_Flag <read=Read_targetflag, comment="Not sure what this indicates yet...">;
	knownValue _("short", "1", "Filters Header");
	int NumFilters <comment="Total number of Filter Target objects including parens">;
	Num_Filters = NumFilters;
	sectionType = 1;
} FILTER_HEADER;


string Read_targetflag( int16 i ) {
	// returns the state of the target flag - unclear what this means
	switch( i ) 
	{
		case 0 :  return "NOT SET";
		case 1 :  return "SET";
		default : return "Undefined";
	}
};



//----------------------------------------
// NEW ATTRIBUTE
typedef struct (int64 boundary) {
	newAttrColours();
	local int attrLength;
	local int attrAddress = FTell();

	// whether the attribute is "set" or "unset"
	int attrFlag <read=Read_attrFlag>;

	// ASCII stirng identifying the attribute 
	int attrIdLength;
	string attrID;
	currAttr = attrID;
	setAttrFlags( currAttr ); // sets any flags (based on attrID) that affect attrcheck behaviour
	enumAttrDepth( attrID );

	if (attrFlag == -2) {// Flag is not set so return
		return;
	}
	truncAttrLocationRecorder( currAttr, attrAddress );
	attrJunction( boundary );
} ATTR <read=Read_attrname>;


string Read_attrname( ATTR &m ) {
	// read-function: returns the attribute name and whether it is set or not 
	local int boundary;
	local string tempStr, tempFlag;
	tempFlag = Read_attrFlag( m.attrFlag );
	if (tempFlag == "SET") {
		boundary = m.attrAddress + m.attrIdLength + m.attrLength + 14;
		SPrintf(tempStr, "(%s) '%s'                  /%Ld/", tempFlag, m.attrID, boundary);
	}
	else {
		SPrintf(tempStr, "__________'%s'", m.attrID);
	}
	return tempStr;
	// m.attrID;
};

void newAttrColours() {
	if (ReadInt() !=  -2)
		switch( sectionType )
		{
			case 0: SetForeColor( cAqua ); break;
			case 1: SetForeColor( cYellow ); break;
		}
	else 
		SetForeColor( cGray ); // Attribute
};


string Read_attrFlag( int i ) {
	switch( i ) 
	{
		case -1 : return "SET";
		case -2 : return "NOT SET";
		default : return "Undefined";
	}
};


void enumAttrDepth( string attrID ) {
	switch( attrID ) 
	{
		// special cases where this short is non-zero
		case "MTrackEvent":          knownValue _("short", "2", attrID); break;
		case "MEvent":               knownValue _("short", "1", attrID); break;
		case "MTempoTrackEvent":     knownValue _("short", "2", attrID); break;
		case "MSignatureTrackEvent": knownValue _("short", "3", attrID); break;
		case "MTimeSignatureEvent":  knownValue _("short", "2", attrID); break;
		case "PMidiScaleValue":      knownValue _("short", "1", attrID); break;
		// should normally be zero
		default:                     knownValue _("short", "0", attrID); break;
	}
};



//----------------------------------------
// EXISTING ATTRIBUTE
typedef struct (int64 boundary) {
	existingAttrColours();
	// SetForeColor( cDkYellow ); // Attribute 
	local int attrLength;
	local int attrAddress = FTell();

	if (isLE == 0)
		short Const_minus_32768; // 0x0080	

	short Offset_Addr <read=Read_cont_attrname2>;
	currAttr = ReadString(Offset_Addr + 8 + globalOffset, -1); //  reads in the name of the attribute that the offset refers to
	setAttrFlags( currAttr ); // sets any flags (based on attrID) that affect attrcheck behaviour

	if (isLE == 1)
		short Const_minus_32768; // 0x0080

	truncAttrLocationRecorder( currAttr, attrAddress );

	attrJunction( boundary );
} CONT_ATTR <read=Read_cont_attrname>;

void existingAttrColours() {
	switch( sectionType )
	{
		case 0: SetForeColor( cLtBlue ); break;
		case 1: SetForeColor( cLtYellow ); break;
	}
};

string Read_cont_attrname( CONT_ATTR &m ) {
	// returns the continuation attribuate name
	local string tempStr;
	tempStr = ReadString(m.Offset_Addr + 8 + globalOffset, -1);
	
	local int boundary;
	boundary = m.attrAddress + m.attrLength + 8;
	
	SPrintf(tempStr, "    (...) '%s'                  /%Ld/", tempStr, boundary);
	return tempStr;
};

string Read_cont_attrname2( short i ) {
	// read function: returns the name of the attribute at the given offset
	return ReadString(i + 8 + globalOffset, -1);
};



//----------------------------------------
// TRUNCATED ATTRIBUTES
typedef struct (string attrID) {
	local string tempStr;
	tempStr = attrID;
	switch( attrID )
	{
		case "leColorTypeTarget":    trunc_leColorTypeTarget(); break;
		case "leTypesTarget":        trunc_leTypesTarget(); break;
		case "leActionTargetTypes":  trunc_leActionTargetTypes(); break;
		case "LeTTimeDiffValue":     trunc_LeTTimeDiffValue(); break;
		case "LeTTimeValue":         trunc_LeTTimeValue(); break;
		case "MTempoTrackEvent":     trunc_MTempoTrackEvent(); break;
		case "MTempoTrackNode":      trunc_MTempoTrackNode(); break;
		case "MSignatureTrackEvent": trunc_MSignatureTrackEvent(); break;
		case "MSignatureTrackNode":  trunc_MSignatureTrackNode(); break;
		case "MTrackVariation":      trunc_MTrackVariation(); break;
	}
} TRUNC_ATTR <read=ReadTRUNC_ATTR>;

void TruncAttrColours() {
	switch( sectionType )
	{
		case 0: SetForeColor( cLtBlue ); break;
		case 1: SetForeColor( cLtYellow ); break;
	}
};

string ReadTRUNC_ATTR( TRUNC_ATTR &m ) {
	local string tempStr;
	SPrintf(tempStr, "    (***) TRUNC: '%s'", m.tempStr);
	return tempStr;
};


//----------------------------------------
// ACTION / FILTER TARGET STRUCTS

// action target - nested STRUCT version
typedef struct {
	int attrLength;
	TargetBoundary = FTell() + attrLength;
	knownValue _("short", "0", currAttr);
	logicalOperatorInt();
	int targetID <read=Read_targetID>;

	Printf("\nTargetBoundary=%Ld", TargetBoundary);
	attrJunction( TargetBoundary, currAttr );
} ACTION_TARGET <open=true>;


// action target - FUNC version
void actionTarget() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;
	knownValue _("short", "0", currAttr);
	logicalOperatorInt();
	int targetID <read=Read_targetID>;
	// Printf("\nTargetBoundary=%Ld", TargetBoundary);
};


// return targetID constant
string Read_targetID( int i ) {
	switch( i ) 
	{
		case 4000 : return "(4000) leActionTargetStart";
		case 4001 : return "(4001) leActionTargetLength";
		case 4002 : return "(4002) leActionTargetValue1";
		case 4003 : return "(4003) leActionTargetValue2";
		case 4004 : return "(4004) leActionTargetValue3";
		case 4005 : return "(4005) leActionTargetChannel";
		case 4006 : return "(4006) leActionTargetTypes";
		case 4007 : return "(4007) leActionTargetName";
		case 4012 : return "(4012) leActionTargetTrackOp";
		case 4013 : return "(4013) leActionTargetTrim";
		case 4014 : return "(4014) leActionTargetColor";
		case 4016 : return "(4016) leActionTargetNXPOp";
		case 4017 : return "(4017) leActionTargetFloat";
		default   : Undefined("action targetID"); return "Undefined action targetID";
	}
};


// filter target - nested STRUCT version
typedef struct {
	int attrLength;
	TargetBoundary = FTell() + attrLength;
	knownValue _("int", "100", currAttr); // always 100
	logicalConditionInt();

	if ( (TypeTarget == "lePositionTarget") || (TypeTarget == "leLengthTarget") ) {
		timeBaseInt();
	}
	else {
		knownValue _("int", "0", temmpattr);
	}
	attrJunction( TargetBoundary, currAttr );
} FILTER_TARGET <open=true>;


// filter target - FUNC version
void filterTarget() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;
	knownValue _("int", "100", currAttr); // always 100
	logicalConditionInt();

	if ( (TypeTarget == "lePositionTarget") || (TypeTarget == "leLengthTarget") ) {
		timeBaseInt();
	}
	else {
		knownValue _("int", "0", currAttr);
	};
};