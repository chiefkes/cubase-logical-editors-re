void attr_LeContainerTypeValue() {
	int attrLength; // always 4

	if (Condition == 2) { // condition was ALL_TYPES so type of track is always 0
		int ALL_TYPES; return;
	}

	switch( ReadInt() )
	{
		case 0  : int FolderTrack; break;
		case 1  : int Track; break;
		case 2  : int Part; break;
		case 3  : int Event; break;
		default : int Undefined; Undefined("LeContainerTypeValue"); break;
	}
};


void attr_LeMediaTypeValue() {
	int attrLength; // always 4

	if (Condition == 2) { // condition was ALL_TYPES so type of track is always 0
		int ALL_TYPES; return;
	}

	switch( ReadInt() )
	{
		case 0  : int Audio; break;
		case 1  : int MIDI; break;
		case 2  : int Automation; break;
		case 3  : int Marker; break;
		case 4  : int Transpose; break;
		case 5  : int Arranger; break;
		case 6  : int Tempo; break;
		case 7  : int Signature; break;
		case 8  : int Chord; break;
		case 9  : int Scale_Event; break;
		case 10 : int Video; break;
		case 11 : int Group; break;
		case 12 : int Effect; break;
		case 13 : int Device; break;
		case 14 : int VCA; break;
		default : int Undefined; Undefined("LeMediaTypeValue"); break;
	}
};


void attr_LeFlagsValue() {
	int attrLength; // always 12
	knownValue _("int", "0", currAttr);
	switch( ReadInt() )
	{
		case 7: 
			int Logical_Editor;
			switch( ReadInt() ) 
			{
				case 0  : int Event_is_muted; break;
				case 1  : int Event_is_selected; break;
				case 2  : int Event_is_empty; break;
				case 3  : int Event_inside_NoteExp; break;
				case 4  : int Event_is_valid_VST3; break;
				case 5  : int Is_Part_of_Scale; break;
				case 6  : int Is_Part_of_Chord; break;
				case 7  : int Event_is_muted; break;
				default : int Undefined; Undefined("LeFlagsValue"); break;
			}
		break;

		case 8: 
			int Project_Logical_Editor;
			switch( ReadInt() ) 
			{
				case 0  : int Event_is_muted; break;
				case 1  : int Event_is_selected; break;
				case 2  : int Event_is_empty; break;
				case 3  : int Event_inside_NoteExp; break;
				case 4  : int Event_is_valid_VST3; break;
				case 5  : int Is_Hidden; break;
				case 6  : int Has_Track_Version; break;
				case 7  : int Follows_Chord_Track; break;
				case 8  : int Is_Disabled; break;
				default : int Undefined; Undefined("LeFlagsValue"); break;
			}
		break;
	}	
};


void attr_LeGenericOpValue() {
	int attrLength; // always 4

	if (Op == "Folder") {
		switch( ReadInt() )
		{
			case 0  : int OPEN; break;
			case 1  : int CLOSE; break;
			case 2  : int TOGGLE; break;
			default : int Undefined; Undefined("LeGenericOpValue"); break;
		}
	}
	else if (Op == "Time_Domain") {
		switch( ReadInt() )
		{
			case 0  : int MUSICAL; break;
			case 1  : int LINEAR; break;
			case 2  : int TOGGLE; break;
			default : int Undefined; Undefined("LeGenericOpValue"); break;
		}
	}
	else {
		switch( ReadInt() )
		{
			case 0  : int ENABLE; break;
			case 1  : int DISABLE; break;
			case 2  : int TOGGLE; break;
			default : int Undefined; Undefined("LeGenericOpValue"); break;
		}
	}
};


void attr_PMidiKeyValue() {
	int attrLength; // always 4
	knownValue _("int", "0", currAttr);
	knownValue _("int", "11", currAttr);
	int Scale_Root_note <read=Read_PMidiNoteValue>;
};


void attr_PMidiScaleValue() {
	int attrLength; // always 4
	knownValue _("int", "0", currAttr);
	knownValue _("int", "28", currAttr);
	switch( ReadInt() )
	{
		case 0  : int Major; break;
		case 1  : int Harmonic_Minor; break;
		case 2  : int Melodic_Minor; break;
		case 3  : int Blues_I; break;
		case 4  : int Pentatonic; break;
		case 5  : int Myxolydic9_11; break;
		case 6  : int Lydic_diminished; break;
		case 7  : int Blues_2; break;
		case 8  : int Major_Augmented; break;
		case 9  : int Arabian; break;
		case 10 : int Balinese; break;
		case 11 : int Hungarian; break;
		case 12 : int Oriental; break;
		case 13 : int RagaTodi; break;
		case 14 : int Chinese; break;
		case 15 : int Hungarian_2; break;
		case 16 : int Japanese_1; break;
		case 17 : int Japanese_2; break;
		case 18 : int Persian; break;
		case 19 : int Diminished; break;
		case 20 : int Whole_Tone; break;
		case 21 : int Blues_3; break;
		case 22 : int Dorian; break;
		case 23 : int Phrygian; break;
		case 24 : int Lydian; break;
		case 25 : int Myxolydian; break;
		case 26 : int Aeolian_(nat_minor); break;
		case 27 : int Locrian; break;
		case 28 : int No_Scale; break;
		default : int Undefined; Undefined("PMidiScaleValue"); break;
	}
};


void attr_LeTypeValue() {
	int attrLength;
	knownValue _("int", "0", currAttr);
	int NumOptions;
	switch( NumOptions )
	{
		case 8: // leTypesTarget - Type Is...
			switch( ReadInt() )
			{
				case 0  : int Note; break;
				case 1  : int Poly_Pressure; break;
				case 2  : int Controller; break;
				case 3  : int Program_Change; break;
				case 4  : int Aftertouch; break;
				case 5  : int Pitchbend; break;
				case 6  : int SysEx; break;
				case 7  : int SMF_Event; break;
				case 8  : int VST_3_Event; break;
				default : int Undefined; Undefined("LeTypeValue"); break;
			} 
		break;

		case 6: // leActionTargetTypes - Type > Set to fixed value
			switch( ReadInt() )
			{
				case 0  : int Note; break;
				case 1  : int Poly_Pressure; break;
				case 2  : int Controller; break;
				case 3  : int Program_Change; break;
				case 4  : int Aftertouch; break;
				case 5  : int Pitchbend; break;
				case 6  : int VST_3_Event; break;
				default : int Undefined; Undefined("LeTypeValue"); break;
			} 
		break;

		case 4: // leActionTargetNXPOp - Create One-Shot
			switch( ReadInt() )
			{
				case 0 : int Poly_Pressure; break;
				case 1 : int Controller; break;
				case 2 : int Aftetouch; break;
				case 3 : int Pitchbend; break;
				case 4 : int VST_3_Event; break;
			}
		break;

		default : int Undefined; Undefined("LeTypeValue"); break;
	}
};


void trunc_leTypesTarget() {
	currAttr = "leTypesTarget";
	knownValue _("int", "0", currAttr);
};


void trunc_leActionTargetTypes() {
	currAttr = "leActionTargetTypes";
	knownValue _("int", "0", currAttr);
};


void attr_LEMidiChannelValue() {
	int attrLength;
	knownValue _("int", "0", currAttr);
	knownValue _("int", "15", currAttr);
	int Channel_Minus_1;
};


void attr_PMidiNoteValue() {
	int attrLength;
	knownValue _("int", "0", currAttr);
	knownValue _("int", "127", currAttr);
	int UserVal <read=Read_PMidiNoteValue>;
};


void attr_PControllerValue() {
	int attrLength;
	knownValue _("int", "0", currAttr);
	knownValue _("int", "127", currAttr);
	int UserVal;
};


string Read_PMidiNoteValue( int i ) {
	// create a read function to return the note
	// (use modulus function for notes)
	local string tempStr, note;
	switch( i % 12 )
	{
		case 0  : note = "C"; break;
		case 1  : note = "C#"; break;
		case 2  : note = "D"; break;
		case 3  : note = "D#"; break;
		case 4  : note = "E"; break;
		case 5  : note = "F"; break;
		case 6  : note = "F#"; break;
		case 7  : note = "G"; break;
		case 8  : note = "G#"; break;
		case 9  : note = "A"; break;
		case 10 : note = "A#"; break;
		case 11 : note = "B"; break;
	}
	SPrintf( tempStr, "%s%Ld", note, Floor(i/12)-2 );
	return tempStr;
};


void attr_LeHistoryValue() {
	int attrLength;
	knownValue _("int", "0", currAttr);
	knownValue _("int", "4", currAttr);
	switch( ReadInt() )
	{
		case 0  : int Value_1; break;
		case 1  : int Value_2; break;
		case 2  : int MIDI_Status; break;
		case 3  : int Channel; break;
		case 4  : int Eventcounter; break;
		default : int Undefined; Undefined("LeHistoryValue"); break;
	}
};


void attr_LeAllroundValue() {
	int attrLength;
	knownValue _("int", "0", currAttr);
	knownValue _("int", "2147483647", currAttr);
	int UserVal <read=read_LeAllroundValue>;
};


string read_LeAllroundValue( int i ) {
	local string tempStr;
	SPrintf( tempStr, "%Ld/%s", i, Read_PMidiNoteValue( i ) );
	return tempStr;
};


void attr_leContextTypeTarget() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;
	knownValue _("int", "100", currAttr); // always 100
	logicalConditionInt();
	knownValue _("int", "0", currAttr);
	switch( ReadInt() )
	{
		case 0  : int Highest_Pitch; break;
		case 1  : int Lowest_Pitch; break;
		case 2  : int Average_Pitch; break;
		case 3  : int Highest_Velocity; break;
		case 4  : int Lowest_Velocity; break;
		case 5  : int Average_Velocity; break;
		case 6  : int Highest_CC_Value; break;
		case 7  : int Lowest_CC_Value; break;
		case 8  : int Average_CC_Value; break;
		case 9  : int No_of_Notes_in_Chord_Part; break;
		case 10 : int No_of_Voices_Part; break;
		case 11 : int Position_in_Chord_Part; break;
		case 12 : int Note_Number_in_Chord_lowest_equals_zero; break;
		case 13 : int Position_in_Chord_Chord_Track; break;
		case 14 : int Voice; break;
		default : int Undefined; Undefined("leContextTypeTarget"); break;
	}
	switch( ReadInt(FTell()-4) )
	{
		case 9: 
		case 10: 
		case 12:
			int UserVal; break;
		case 11: 
		case 13:
			switch( ReadInt() )
			{
				case 0  : int Root_Note; break;
				case 1  : int Minor_Second; break;
				case 2  : int Major_Second; break;
				case 3  : int Minor_Third; break;
				case 4  : int Major_Third; break;
				case 5  : int Fourth; break;
				case 6  : int Dim_Fifth; break;
				case 7  : int Fifth; break;
				case 8  : int Aug_Fifth; break;
				case 9  : int Sixth; break;
				case 10 : int Min_Seventh; break;
				case 11 : int Maj_Seventh; break;
			} 
		break;

		case 14:
			switch( ReadInt() )
			{
				case 0 : int Soprano; break;
				case 1 : int Alto; break;
				case 2 : int Tenor; break;
				case 3 : int Bass; break;
				case 4 : int Soprano_2; break;
				case 5 : int Alto_2; break;
				case 6 : int Tenor_2; break;
				case 7 : int Bass_2; break;
			} 
		break;
		
		default: knownValue _("int", "0", currAttr); break;
	}
};

void trunc_leColorTypeTarget() {
	currAttr = "leColorTypeTarget";
	knownValue _("int", "0", currAttr);
}