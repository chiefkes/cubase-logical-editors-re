#include "TimeStructs.c"


void attr_LeDomainTypeValue() {
	int attrLength;
	timeBaseInt();
};

void timeBaseInt() {
	switch( ReadInt() ) 
	{
		case 0 	: int       PPQ; temp_TimeBase =     "PPQ"; break;
		case 1 	: int   Seconds; temp_TimeBase = "Seconds"; break;
		case 2 	: int   Samples; temp_TimeBase = "Samples"; break;
		case 3 	: int    Frames; temp_TimeBase =  "Frames"; break;
		default : int Undefined; Undefined("TimeBase"); break;
	}
};


//----------------------------------------
// LeTTimeDiffValue
void attr_LeTTimeDiffValue() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;

	knownValue _("int", "0", currAttr);
	knownValue _("int", "0", currAttr);
	int TimeBase <read=read_TimeBase>;

	// when is this the case?
	if ( allTypesCheck( FTell() ) == 1 ) {
		if (NestedStruct == 1) {
			mainBinTraverser( TargetBoundary, "LeTTimeDiffValue" );
		}
		return;
	}

	if (TimeBase == 0) {
		int MTrackAddr <read=read_MTrackOffset>;
		int MTrackAddr <read=read_MTrackOffset>;
		double UserVal;
		knownValue _("int", "0", currAttr);
		int MTrackAddr <read=read_MTrackOffset>;
		int MTrackAddr <read=read_MTrackOffset>;
		knownValue _("int", "0", currAttr);
	}

	else {
		double TimeBaseUnit <read=read_LeTTimeDiffUnit>; 
		double UserVal;
		int TimeBase <read=read_TimeBase>;
		double TimeBaseUnit <read=read_LeTTimeDiffUnit>;
		knownValue _("int", "0", currAttr);
	}
};

void trunc_LeTTimeDiffValue() {
	currAttr = "LeTTimeDiffValue";
	if (TTNode == "true") {
		int MTrackAddr <read=read_MTrackOffset>; 
		// if tempo track versions are present, an additional
		// reference to MSignatureTrackEvent is necessary 
		// (presumably because it is embedded within the 
		// MTempoTrackEvent attribute in this case)
	}
	double UserVal;
	knownValue _("int", "0", currAttr);
	int MTrackAddr <read=read_MTrackOffset>;
	int MTrackAddr <read=read_MTrackOffset>;
	knownValue _("int", "0", currAttr);
};

string read_TimeBase( int i ) {
	switch( i ) 
	{
		case 0 	: temp_TimeBase =     "PPQ"; return "(0) PPQ";
		case 1 	: temp_TimeBase = "seconds"; return "(1) seconds";
		case 2 	: temp_TimeBase =  "frames"; return "(2) 24 fps";
		case 3 	: temp_TimeBase =  "frames"; return "(3) 25 fps";
		case 4 	: temp_TimeBase =  "frames"; return "(4) 29.97 fps";
		case 5 	: temp_TimeBase =  "frames"; return "(5) 30 fps";
		case 6 	: temp_TimeBase =  "frames"; return "(6) 29.97 dfps";
		case 7 	: temp_TimeBase =  "frames"; return "(7) 30 dfps";
		case 10	: temp_TimeBase = "samples"; return "(10) samples";
		case 12	: temp_TimeBase =  "frames"; return "(12) 23.98 fps";
		case 13	: temp_TimeBase =  "frames"; return "(13) 24.98 fps";
		case 14	: temp_TimeBase =  "frames"; return "(14) 50 fps";
		case 15	: temp_TimeBase =  "frames"; return "(15) 59.94 fps";
		case 16	: temp_TimeBase =  "frames"; return "(16) 60 fps";
		default : Undefined("LeTTimeTimeBase"); return "Undefined";
	}
};

string read_LeTTimeDiffUnit( double i ) {
	local string tempStr;
	local double tempval; tempval = 1 / i;
	// for frames this is 1 / FPS
	// for samples this is 1 / sample rate
	// for seconds this is 1 ( 1 / 1)
	switch( temp_TimeBase ) 
	{
		case "PPQ": return "PPQ"; // this might be redundant
		case "seconds":
			SPrintf(tempStr, "%.1f secs", tempval); return tempStr;
		case "frames":
			SPrintf(tempStr, "%.0f fps (1 frame = %e s)", tempval, i); return tempStr;
		case "samples":
			SPrintf(tempStr, "%.0f hz (1 sample = %e s)", tempval, i); return tempStr;
	}
}

string read_MTrackOffset( int i ) {
	local string tempStr;
	local int tempPos, tempLength;
	tempPos = i - 2 + globalOffset;
	while ( tempPos > 0 ) {
		tempLength = ReadStringLength(tempPos, -1);
		if ( ReadInt(tempPos-4) == tempLength ) {
			break;
		}
		--tempPos;
	}
	SPrintf(tempStr, "(%Ld) '%s'", i, ReadString( tempPos ) );
	return tempStr;
}


//----------------------------------------
// LeTTimeValue
void attr_LeTTimeValue() {
	currAttr = "LeTTimeValue";
	int attrLength;
	TargetBoundary = FTell() + attrLength;

	knownValue _("int", 	"0", currAttr);
	knownValue _("int", 	"0", currAttr);
	knownValue _("int", 	"1", currAttr);
	knownValue _("double", "1", currAttr);

	double 	doublefloat; 
	// relation to number of seconds in a year
	// some kind of rounding error related to BPM?
	// might not be important

	knownValue _("int", 	"1", currAttr);
	knownValue _("double", "1", currAttr);
	double 	UserVal;

	int TimeBase <read=read_TimeBase>;

	// is the number of these predictable?
	while ( (FTell() < TargetBoundary) && (allTypesCheck( FTell() ) == 0) )
	{
		if (TimeBase == 0)
			int MTrackAddr <read=read_MTrackOffset>;
		else
			double TimeBaseUnit <read=read_LeTTimeDiffUnit>;
	}
};

void trunc_LeTTimeValue() {
	int MTrackAddr <read=read_MTrackOffset>; // if tempo track versions are present this
};


//----------------------------------------
// FAttributes
void attr_FAttributes() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;

	knownValue _("int", "1", currAttr);

	FAttrSubConstructor();
	// 	F_SignatureEvent;
	// 	F_MTimeSignatureEvent;
	// 	F_Flags;
	// 	F_Start;
	// 	F_Length;
	//	F_Additional_Attributes --- if they are set
	// 	F_Bar;
	// 	F_Numerator;
	// 	F_Denominator;
	// 	F_Position

	local int i;

	for ( i = 0; i < (Num_SignatureTrackEvents-1); i++ )
	{
		knownValue _("short", "20", currAttr);
		FAttrSubConstructor();
	// 	F_MTimeSignatureEvent;
	// 	F_Start;
	// 	F_Length;
	//	F_Additional_Attributes --- if they are set
	// 	F_Bar;
	// 	F_Numerator;
	// 	F_Denominator;
	// 	F_Position;
	}

	truncAttrCheck( TargetBoundary );

};

void FAttrSubConstructor() {
	local int SubAttr = 1;
	while (SubAttr == 1)
	{
		switch( ReadString( FTell()+4, -1) )
		{
			case "SignatureEvent": F_SignatureEvent _; break;
			case "MTimeSignatureEvent": F_MTimeSignatureEvent _; break;
			case "Flags": F_Flags _; break;
			case "Start": F_Start _; break;
			case "Length": F_Length _; break;
			case "Bar": F_Bar _; break;
			case "Numerator": F_Numerator _; break;
			case "Denominator": F_Denominator _; break;
			case "Position": F_Position _; break;
			case "Additional Attributes": F_Additional_Attributes _; break;
			default: SubAttr = 0; break;
		}
	}
}


void FAttr_Add_SubConstructor() {
	local int SubAttr = 1;
	while (SubAttr == 1)
	{
		switch( ReadString( FTell()+4, -1) )
		{
			case "Clik": FA_Clik _; break;
			case "PatternDesc": FA_PatternDesc _; break;
			case "base": FA_base _; break;
			case "userLength": FA_userLength _; break;

			case "Accent1": case "Accent2": case "Accent3":
			case "Accent4": case "Accent5": case "Accent6":
			case "Accent7": case "Accent8": case "Accent9":
			case "Accent10": case "Accent11": case "Accent12":
			case "Accent13": case "Accent14": case "Accent15":
			case "Accent16": FA_Accent _; break;

			case "Info": FA_Info _; break;
			
			case "sd1":
			case "sd2":
			case "sd3":
			case "sd4": FA_sd _; break;

			case "tempoLeft": FA_tempoLeft _; break;
			case "tempoRight": FA_tempoRight _; break;
			case "numerator": FA_numerator _; break;
			case "denominator": FA_denominator _; break;
			case "isDefault": FA_isDefault _; break;
			case "Name": FA_Name _; break;
			case "Farb": FA_Farb _; break;

			default: SubAttr = 0; break;
		}
	}
};


//----------------------------------------
// MTempoTrackEvent
void attr_MTempoTrackEvent() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;

	int Num_TempoTrackEvents;
	local int i;
	for ( i = 0; i < Num_TempoTrackEvents; i++ ) {
		TempoTEvent node;
	}

	float Tick_Resolution_120;
	switch( ReadShort() )
	{
		case 0: short TT_ENABLED; break;
		case 1: short TT_DISABLED; break;
	}

	int Num_SubAttributes; // number of sub-structures (including within trunc sections)
	MTrackSubConstructor();

	mainBinTraverser( TargetBoundary, "MTempoTrackEvent" );
};


void trunc_MTempoTrackEvent() {
	currAttr = "MTempoTrackEvent";
	MTrackSubConstructor();
	truncAttrCheck( TargetBoundary );
};

void MTrackSubConstructor() {
	local int SubAttr = 1;
	local string tempStr;

	while (SubAttr == 1)
	{
		if (isLE == 1 )
			tempStr = ReadString( FTell(), 4);
		else
			tempStr = RevString( ReadString( FTell(), 4) );

		switch( tempStr )
		{
			case "TLID": TLID _; break;
			case "Farb": Farb _; break; 
			// appears when track has a non-default colour
			// value defines track colour
			case "TTNE": TTNE _; break;
			// appears when there are tempo ramps
			case "Eths": Eths _; break;
			case "TVCi": TVCi _; break;
			case "Thid": Thid _; break; 
			// appears when track is hidden
			case "TTlB": TT_LowerBound _; break;
			// appears when tempo bounds are non-default
			case "TTuB": TT_UpperBound _; break;
			// appears when tempo bounds are non-default
			case "Lock": TT_Lock _; break;
			// defines the lock state of the Tempo Track
			case "LocS": ST_LocS _; break;
			// defines the lock state of the Sig Track
			case "Clks": ST_Clks _; break;
			default: SubAttr = 0; break;
		}
	}
};


void attr_MTrackVariationCollection() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;
	knownValue 	_("int", "10", currAttr);
	knownValue 	_("short", "2", currAttr);
	int Total_TrackVersions;
	TTVersions = Total_TrackVersions;
	// knownValue 	_("short", "0", currAttr);
	mainBinTraverser( TargetBoundary, "MTrackVariationCollection" );
};


void attr_MTrackVariation() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;
	int str_len;
	if (str_len != 0)
		ASCII TrackVersionName;

	if (allTypesCheck( FTell() ) == 0) { // if check fails this is the track variation that is active
		knownValue _("int", "0", currAttr);
		int NumTrackVersion;
	}

	mainBinTraverser( TargetBoundary, "MTrackVariation" );
	truncAttrCheck( TargetBoundary );
};

void trunc_MTrackVariation() {
	currAttr = "MTrackVariation";
	// knownValue 	_("int", "1", currAttr);
	// int 		TrackV_Num_TempoTrackEvents;
	// testValue 	_("int", currAttr);
	int TrackVersionIndex;
};


void attr_MTempoTrackNode() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;
	int str_len;
	if (str_len != 0)
		ASCII Tempo;
	knownValue _("int", "0", currAttr);
	int MTrackAddr <read=read_MTrackOffset>; // refers to MTempoTrackEvent
	if (allTypesCheck( FTell() ) == 0) {
		// if the first MTempoTrackNode is interrupted by an MSignatureTrackEvent
		//
		// subsequent nodes refer to its address alone 
		int MTrackAddr <read=read_MTrackOffset>;
		int TrackV_Num_TempoTrackEvents;
		// testValue _("int", currAttr);
	}
	mainBinTraverser( TargetBoundary, "MTempoTrackNode" );
};


void trunc_MTempoTrackNode() {
	currAttr = "MTempoTrackNode";
	// knownValue 	_("int", "1", currAttr);
	int TrackV_Num_TempoTrackEvents; // the number of tempo track events in the track version
	// testValue 	_("int", currAttr);
};


void attr_MTempoEvent() {
	int attrLength;
	float Sixty_Div_By_BPM;
	double Seconds_from_origin;
	double Ticks_from_origin;
	int NodeType <read=Read_TempoTEventType>;
	truncAttrCheck( TargetBoundary );
};


//----------------------------------------
// MSignatureTrackEvent
void attr_MSignatureTrackEvent() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;

	int Num_SignatureTrackEvents;
	local int i;
	for ( i = 0; i < Num_SignatureTrackEvents; i++ ) 
	{
		SigTEvent node;
	}
	int Num_SubAttributes;
	MTrackSubConstructor();
	mainBinTraverser( TargetBoundary, "MSignatureTrackEvent" );
};

void trunc_MSignatureTrackEvent() {
	currAttr = "MSignatureTrackEvent";
	MTrackSubConstructor();
};


void attr_MSignatureTrackNode() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;
	int str_len;
	if (str_len != 0)
		ASCII Signature;
	knownValue _("int", "17", currAttr);
	int MTrackAddr <read=read_MTrackOffset>; // refers to MTempoTrackEvent
	if (allTypesCheck( FTell() ) == 0) {
		int MTrackAddr <read=read_MTrackOffset>;
		int TrackV_Num_SigTrackEvents;
	}
	mainBinTraverser( TargetBoundary, "MSignatureTrackNode" );
};

void trunc_MSignatureTrackNode() {
	currAttr = "MSignatureTrackNode";
	// knownValue _("int", "1", currAttr);
	int TrackV_Num_SigTrackEvents;
	// testValue _("int", currAttr);
};

void attr_MTimeSignatureEvent() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;
	int64 Bars_from_origin;
	// knownValue 	_("int", "0", currAttr);
	short  Numerator;
	short  Denominator;
	knownValue _("int", "0", currAttr);
	knownValue _("short", "0", currAttr);
	short flags; // not 100% but think this is a reference to "flags"
	int Num_SubAttributes;
	if (Num_SubAttributes != 0) {
		// these will appear if a non-active Time Sig track version event has a custom metronome pattern.
		MTSE_SubConstructor();
		mainBinTraverser( TargetBoundary, "MTimeSignatureEvent" );
	}

	truncAttrCheck( TargetBoundary );
};

// testValue _("int", currAttr);
// knownValue _("int", "1", currAttr);

void attr_PatternDesc() {
	int attrLength;
	short	NumClicks;
	short Unk;

	local int i;
	for ( i = 0; i < (NumClicks); i++ )
	{
		short	AccentLevel;
	}

	short	unk;
	int	unk;
	double unk;
	double unk;
	short	unk;
	short	unk;
};

void MTSE_SubConstructor() {
	local int SubAttr = 1;
	local string tempStr;

	while (SubAttr == 1)
	{
		if (isLE == 1 )
			tempStr = ReadString( FTell(), 4);
		else
			tempStr = RevString( ReadString( FTell(), 4) );

		switch( tempStr )
		{
			case "Farb": Farb _; break;
			case "Clik": MTSE_Clik _; break;
			default: SubAttr = 0; break;
		}
	}
};
