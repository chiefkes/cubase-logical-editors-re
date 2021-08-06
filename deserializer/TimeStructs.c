//----------------------------------------
// FAttribute
 
typedef struct {
	local string tempStr;
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "2", "F_SignatureEvent");
	knownValue  _("short", "201", "F_SignatureEvent");
	int Num_SignatureTrackEvents;
	knownValue  _("short", "20", "F_SignatureEvent");
} F_SignatureEvent <read=ReadF_SignatureEvent> ;

string ReadF_SignatureEvent( F_SignatureEvent &m ) {
	return m.sub_attrID;
};


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	int64 MTimeSignatureEvent_ID;
	int     Num_SubStructs;
	// this number is the how many FAttribute sub structs follow
	// (7 first time, 6 for proceeding times as F_Flags is only set once)
} F_MTimeSignatureEvent <read=ReadF_MTimeSignatureEvent>;

string ReadF_MTimeSignatureEvent( F_MTimeSignatureEvent &m ) {
	return m.sub_attrID;
};


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "F_Flags");
	knownValue  _("int64", "8", "F_Flags"); // always seems to be 8
} F_Flags <read=ReadF_Flags>;

string ReadF_Flags( F_Flags &m ) {
	return m.sub_attrID;
};


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "4", "F_Start");
	double  start_bar;
} F_Start <read=ReadF_Start>;

string ReadF_Start( F_Start &m ) {
	return m.sub_attrID;
};


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "4", "F_Length");
	knownValue  _("double", "1", "F_Length"); // length is always 1?
} F_Length <read=ReadF_Length>;

string ReadF_Length( F_Length &m ) {
	return m.sub_attrID;
};


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "F_Bar");
	int64     start_bar;
	// knownValue  _("int", "0", "F_Bar");
} F_Bar <read=ReadF_Bar>;

string ReadF_Bar( F_Bar &m ) {
	return m.sub_attrID;
};


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "F_Numerator");
	int64     Numerator;
	// knownValue  _("int", "0", "F_Numerator");
} F_Numerator <read=ReadF_Numerator>;

string ReadF_Numerator( F_Numerator &m ) {
	local string tempStr;
	SPrintf(tempStr, "Numerator = %Ld", m.Numerator);
	return tempStr;
};


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "F_Denominator");
	int64     Denominator;
	// knownValue  _("int", "0", "F_Denominator");
} F_Denominator <read=ReadF_Denominator>;

string ReadF_Denominator( F_Denominator &m ) {
	local string tempStr;
	SPrintf(tempStr, "Denominator = %Ld", m.Denominator);
	return tempStr;
};


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "F_Position");
	int64     Ticks_from_origin;
	// knownValue  _("int", "0", "F_Position");
} F_Position <read=ReadF_Position>;

string ReadF_Position( F_Position &m ) {
	return m.sub_attrID;
};


//----------------------------------------
// MTempoTrackEvent


typedef struct {
	float   Sixty_Div_By_BPM;
	double  Seconds_from_origin;
	double  Ticks_from_origin;
	short   NodeType <read=Read_TempoTEventType>;
} TempoTEvent <read=Read_TempoTEvent>;

string Read_TempoTEventType( int16 i ) {
	switch( i )
	{
		case 0: return "Jump";
		case 1: return "Ramp";
	}
};

string Read_TempoTEvent( TempoTEvent &m ) {
	local float BPM;
	local string tempStr;
	BPM = 60 / m.Sixty_Div_By_BPM;
	SPrintf(tempStr, "%.3f BPM", BPM);
	return tempStr;
};


typedef struct {
	char    TTlB[4];
	knownValue  _("short", "1", "TT_LowerBound");
	int64   Lower_Bound;
} TT_LowerBound <read=Read_TT_LowerBound>;

string Read_TT_LowerBound( TT_LowerBound &m ) {
	local string tempStr;
	SPrintf(tempStr, "%Ld", m.Lower_Bound);
	return tempStr;
};


typedef struct {
	char    TTuB[4];
	knownValue  _("short", "1", "TT_UpperBound");
	int64   Upper_Bound;
} TT_UpperBound <read=Read_TT_UpperBound>;

string Read_TT_UpperBound( TT_UpperBound &m ) {
	local string tempStr;
	SPrintf(tempStr, "%Ld", m.Upper_Bound);
	return tempStr;
};


typedef struct {
	char    Lock[4];
	knownValue  _("short", "2049", "Lock");
	int64   Flag;
} TT_Lock <read=Read_TT_Lock>;

string Read_TT_Lock( TT_Lock &m ) {
	local string tempStr;
	switch( m.Flag ) 
	{
		case 0     : SPrintf(tempStr, "NOT SET"); break;
		case 16456 : SPrintf(tempStr, "SET"); break;
		default    : SPrintf(tempStr, "UNKNOWN"); Undefined("TT_Lock"); break;
	}
	return tempStr;
};


//----------------------------------------
// MSignatureTrackEvent


typedef struct {
	int     Ticks_from_origin;
	short   Numerator;
	short   Denominator;
	knownValue  _("int", "0", "SigTEvent");
	knownValue  _("short", "0", "SigTEvent");
	// testValue _("short", "SigTEvent");
	short   flags; // not 100% but think this is a reference to "flags"
} SigTEvent <read=Read_SigTEvent>;

string Read_SigTEvent( SigTEvent &m ) {
	local string tempStr;
	SPrintf(tempStr, "%Ld/%Ld", m.Numerator, m.Denominator);
	return tempStr;
};


typedef struct {
	char    LocS[4];
	knownValue  _("short", "2049", "LocS");
	int64   Flag;
} ST_LocS <read=Read_ST_LocS>;

string Read_ST_LocS( ST_LocS &m ) {
	local string tempStr;
	switch( m.Flag ) 
	{
		case 0: 	SPrintf(tempStr, "NOT SET"); break;
		case 16456: SPrintf(tempStr, "SET"); break;
		default: SPrintf(tempStr, "UNKNOWN"); Undefined("ST_LocS"); break;
	}
	return tempStr;
};


typedef struct {
	char    Clks[4];
	short   NumClks;
} ST_Clks <read=Read_ST_Clks>;

string Read_ST_Clks( ST_Clks &m ) {
	local string tempStr;
	SPrintf(tempStr, "%Ld", m.NumClks);
	return tempStr;
};


//----------------------------------------
// Common TrackEvents


typedef struct {
	char    TLID[4];
	knownValue  _("short", "1", "TLID");
	knownValue  _("int64", "1", "TLID");
} TLID;


typedef struct {
	char    Thid[4];
	knownValue  _("short", "1", "Thid");
	knownValue  _("int64", "1", "Thid");
} Thid;


typedef struct {
	char    Farb[4];
	knownValue  _("short", "1", "Farb");
	int64   TrackColour; // number corresponds to colour grid (0-indexed)
	// knownValue  _("int", "0", "Farb");
} Farb <read=Read_Farb>;

string Read_Farb( Farb &m ) {
	local string tempStr;
	SPrintf(tempStr, "Track Colour No = %Ld", m.TrackColour);
	return tempStr;
};


typedef struct {
	char    TTNE[4];
	knownValue  _("short", "1", "TTNE");
	int64   TTCurrNodeType <read=Read_TTNE1>;
} TTNE <read=Read_TTNE2>;

string Read_TTNE1( int i ) {
	switch( i )
	{
		case 0: return "Jump";
		case 1: return "Ramp";
		case 2: return "Ramp";
	}
};

string Read_TTNE2( TTNE &m ) {
	return Read_TTNE1(m.TTCurrNodeType);
};


typedef struct {
	char    Eths[4];
	knownValue  _("short", "1", "Eths");
	knownValue  _("int64", "-260498236", "Eths");
	// knownValue  _("int", "-1", "Eths");
} Eths;


typedef struct {
	char    TVCi[4];
	knownValue  _("short", "34", "TVCi");
} TVCi;



//----------------------------------------
// FAttribiutes - Additional Attributes


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "2", "F_Additional_Attributes");
	knownValue  _("short", "6", "F_Additional_Attributes");
	
	int     Num_AdditionalAttributes; 
	// Farb counts as one
	// All the custom click attributes count as one
	FAttr_Add_SubConstructor();

} F_Additional_Attributes;


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "2", "FA_Clik");
	knownValue  _("short", "20", "FA_Clik");
} FA_Clik;

typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	int64   PatternDesc_ID;
	int     Num_PatternDescEntries;
} FA_PatternDesc;


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "FA_base");
	int64   BaseValue;
} FA_base;


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "FA_userLength");
	int64   userLengthValue;
} FA_userLength;


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "FA_Accent");
	int64   AccentLevel;
} FA_Accent <read=ReadFA_Accent>;

string ReadFA_Accent( FA_Accent &m ) {
	local string tempStr;
	SPrintf(tempStr, "Accent Level = %Ld", m.AccentLevel);
	return tempStr;
};


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "8", "FA_Info");
	int     str_len;
	if (str_len != 0)
		ASCII unk;
} FA_Info;


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "FA_sd");
	int64   sdValue;
} FA_sd;


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "4", "FA_tempoLeft");
	double  tempoLeftValue;
} FA_tempoLeft;


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "4", "FA_tempoRight");
	double  tempoRightValue;
} FA_tempoRight;


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "FA_numerator");
	int64   Numerator;
} FA_numerator <read=ReadFA_numerator>;

string ReadFA_numerator( FA_numerator &m ) {
	local string tempStr;
	SPrintf(tempStr, "Numerator = %Ld", m.Numerator);
	return tempStr;
};


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "FA_denominator");
	int64   Denominator;
} FA_denominator <read=ReadFA_denominator>;

string ReadFA_denominator( FA_denominator &m ) {
	local string tempStr;
	SPrintf(tempStr, "Denominator = %Ld", m.Denominator);
	return tempStr;
};


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	short   unk;
	knownValue  _("int64", "0", "FA_isDefault");
} FA_isDefault;


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	short   unk;
	int     str_len;
	if (str_len != 0)
		ASCII unk;
} FA_Name;


typedef struct {
	int     attrIdLength;
	string  sub_attrID;
	knownValue  _("short", "1", "Farb");
	int64   TrackColour; // number corresponds to colour grid (0-indexed)
} FA_Farb <read=Read_FA_Farb>;

string Read_FA_Farb( FA_Farb &m ) {
	local string tempStr;
	SPrintf(tempStr, "Colour No = %Ld", m.TrackColour);
	return tempStr;
};


//----------------------------------------
// MTimeSignatureEvent

typedef struct {
	char    Clik[4];
	knownValue  _("short", "34", "MTSE_Clik");
} MTSE_Clik;


