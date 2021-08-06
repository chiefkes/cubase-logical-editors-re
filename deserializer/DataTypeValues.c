void attr_UFloatValue() {
	int attrLength; // always 4
	switch( TypeTarget ) 
	{
		case "leActionTargetColor": 
			knownValue _("int", "0", currAttr); 
		break;

		case "leActionTargetName":
		case "leActionTargetTrim":
		case "leActionTargetStart": 
			// if Action target position / trim is defined as "not set", two UFloatValue sections are spawned
			// one with a float value, and one blank
			// float value	
			FLOAT UserVal; 
		break;

		default : 
			int Undefined; Undefined("UFloatValue"); 
		break;
	}
};


void attr_LeUFloatValue() {
	int attrLength; // always 12
	// for position this represents multipication / division
	// for trim this represent min value
	switch( TypeTarget ) 
	{
		case "leActionTargetFloat":
			int min_val; // 0 for everything except "Set relative random values between" which is -1
			int max_val; // 1 for Add, Subtract, 4 for Multiply, Divide
		break;

		case "leActionTargetTrim":
			knownValue _("int", "-100", currAttr); // min val
			knownValue _("int", "100", currAttr); // max val
		break;

		case "leActionTargetLength":
		case "leActionTargetStart":
			switch( ReadInt() )
			{
				case 1  : int DIVIDE; break;
				case 0  : int MULTIPLY; break;            			
				default : int Undefined; Undefined("LeUFloatValue"); break;
			}
			knownValue _("int", "100", currAttr); // max val
		break;

		case "leActionTargetValue1":
      case "leActionTargetValue2":
      case "leActionTargetValue3":
			knownValue _("int", "0", currAttr); // min val
			knownValue _("int", "127", currAttr); // max val
		break;
	}
	FLOAT UserVal;
};


void attr_UIntValue() {
	int attrLength; //always 4
	switch( TypeTarget )
	{
		// if track op is left as default "Record" it spawns a UIntValue with a zero value / padding
		// if the trackop is manually set to "Record" it spawns a LeUIntValue cont as usual 
		case "leActionTargetTrackOp" : int Padding; break;
		case "leActionTargetLength"  : int PARAM1_VAL; break;
		default : int Undefined; Undefined("UIntValue"); break;
	}
};


void attr_LeUIntValue() {
	int attrLength; // always 12

	switch( TypeTarget ) 
	{
		//---------------------------------------------
		// Logical Editor
		case "leActionTargetTypes":
		case "leTypesTarget":
			knownValue _("int", "0", currAttr);
			knownValue _("int", "2147483647", currAttr);
			knownValue _("int", "0", currAttr);
			TruncAttr = 1;
		break;

		case "leActionTargetValue1":
		case "leActionTargetValue2":
		case "leActionTargetValue3":
			switch(Op)
			{
				case "Set_relative_random_values_between": 
				case "Relative_Change_in_Loop_Range": 
					knownValue _("int", "-100", currAttr); 
				break;

				default: 
					knownValue _("int", "0", currAttr); 
				break;
			}
			knownValue _("int", "127", currAttr);
			int UserVal;
		break;

		case "leValue1Target":
		case "leValue2Target":
		case "leValue3Target":
			knownValue _("int", "0", currAttr);
			knownValue _("int", "127", currAttr);
			int UserVal;
		break;

		case "leActionTargetChannel":
			knownValue _("int", "0", currAttr);
			knownValue _("int", "15", currAttr);
			int UserVal;
		break;

		case "leActionTargetNXPOp":
			knownValue _("int", "0", currAttr);
			switch( Op )
			{
				case "Remove_NoteExp":
				case "Reverse":
					knownValue _("int", "1", currAttr);
				break;

				case "Create_One_Shot": 
					knownValue _("int", "2147483647", currAttr); 
				break;
			}
			knownValue _("int", "0", currAttr);
		break;

		case "lePositionTarget":
			knownValue _("int", "0", currAttr);
			int Ticks_Per_Bar; // ( 16 * TickResolution(120) ) * (Numerator / Denominator)
			int UserVal;
		break;


		//---------------------------------------------
		// Project Logical Editor
		case "leNameTypeTarget":
			knownValue _("int", "0", currAttr);
			switch( ReadInt() ) 
			{
				case 255 : int NAME_EQUAL; break;
				case 1   : int NAME_CONTAINS_OR_CONTAINS_NOT; break;
				default  : int Undefined; Undefined("LeUIntValue"); break;
			}
			knownValue _("int", "0", currAttr);
		break;

		case "leFlagsTarget":
			knownValue _("int", "0", currAttr);
			switch( ReadInt() )
			{
				case 2147483647 : int PROPERTY_IS_OR_IS_NOT_SET; break;
				default         : int Undefined; Undefined("LeUIntValue"); break;
			}
			knownValue _("int", "0", currAttr);
		break;

		case "leActionTargetName":
			knownValue _("int", "0", currAttr); // MIN VAL
			knownValue _("int", "1000", currAttr); // MAX VAL
			int Num_Param2;
		break;

		case "leActionTargetLength":
		case "leActionTargetStart":
			switch( Op ) 
			{
				case "Multiply":
				case "Divide":
					knownValue _("int", "0", currAttr); // NULL_MIN_VAL
					knownValue _("int", "0", currAttr); // NULL_MAX_VAL
					knownValue _("int", "0", currAttr); // NULL_PARAM1_VAL
				break;

				case "Set_relative_random_values_between":
					knownValue _("int", "-100", currAttr); // MIN VAL
					knownValue _("int", "200", currAttr); // MAX VAL
					int     PARAM1_VAL;
				break;

				case "Set_Random_Values_Between":
					knownValue _("int", "0", currAttr);
					knownValue _("int", "8388607", currAttr);
					int     UserVal;
				break;

				case "Round_by":
				case "Add_Length":
					knownValue _("int", "0", currAttr); // MIN VAL
					if ( TypeTarget == "leActionTargetStart") {
						knownValue _("int", "134217727", currAttr); // MAX VAL
					}
					if ( TypeTarget == "leActionTargetLength") {
						knownValue _("int", "8388607", currAttr); // MAX VAL
					}
					int PARAM1_VAL;
				break;
			}
		break;

		case "leActionTargetColor":
		case "leActionTargetTrim":
			knownValue _("int", "0", currAttr);
			knownValue _("int", "127", currAttr); // always 127
			knownValue _("int", "0", currAttr);
		break;

		case "leActionTargetTrackOp":
			knownValue _("int", "0", currAttr);
			knownValue _("int", "1", currAttr); // always 1
			knownValue _("int", "0", currAttr);
		break;

		case "leMediaTypeTarget" :
			knownValue _("int", "0", currAttr); 
			switch( ReadInt() ) 
			{
				case 255        : int MEDIA_EQUAL; break;
				case 2147483647 : int MEDIA_UNEQUAL_OR_ALL_TYPES; break;
				default         : int Undefined; Undefined("LeUIntValue"); break;
			}
			knownValue _("int", "0", currAttr);
		break;

		case "leContainerTypeTarget" :
			knownValue _("int", "0", currAttr);
			switch( ReadShort() ) 
			{
				case 255 : int CONTAINER_EQUAL; break;
				case 1   : int CONTAINER_UNEQUAL_OR_ALL_TYPES; break;
				default  : int Undefined; Undefined("LeUIntValue"); break;
			}
			knownValue _("int", "0", currAttr);
		break;

		default : 
			int Undefined; 
			int Undefined; 
			int Undefined; 
			Undefined("LeUIntValue");
		break;
	}
};


void attr_UStringValue() {
	int attrLength;
	TargetBoundary = FTell() + attrLength;
	int Strlen; // string length + 4 (for 0-termination and BOM)
	if (Strlen != 0) {
		STRING UserVal;
		if (ReadShort() == -17425)
			BOM utf8;
	}
	truncAttrCheck( TargetBoundary ); // for leColorTypeTarget
};