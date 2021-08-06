
//----------------------------------------
// TYPEDEFS

//End of string Byte-orde-mark
typedef char BOM[3] <fgcolor=cGreen>;

typedef string STRING <fgcolor=cWhite, bgcolor=cBlue>;

typedef float FLOAT <fgcolor=cGreen, bgcolor=cDkGray>;

// a null terminated string followed by a UTF-8 BOM
typedef struct {
	string AsciiStr <fgcolor=cWhite, bgcolor=cBlue>;
	BOM utf8 <comment="Byte Order Mark", open=suppress>; 
} ASCII <read=Read_ASCII>;


string Read_ASCII( ASCII &m ) {
	// returns the Ascii Str
	return m.AsciiStr;
};