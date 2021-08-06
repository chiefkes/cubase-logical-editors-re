void attr_leToken() {
	int attrLength; // always 4
	switch( ReadInt() ) 
	{
		case 101 : int OPEN_PAREN; break;
		case 102 : int CLOSE_PAREN; break;
		case 103 : int LOGICAL_AND; break;
		case 104 : int LOGICAL_OR; break;
		default  : int Undefined; Undefined("leToken"); break;
	}
};


void logicalConditionInt() {
	// Condition variable is set to single out cases where the condition 
	// is "ALL_TYPES", affecting the possible Container / Media type values
	switch( ReadInt() ) {
		case 200 : int EQUAL; Condition = 1; break;
		case 201 : int UNEQUAL; Condition = 1; break;
		case 202 : int BIGGER; Condition = 1; break;
		case 203 : int BIGGER_OR_EQUAL; Condition = 1; break;
		case 204 : int LESS; Condition = 1; break;
		case 205 : int LESS_OR_EQUAL; Condition = 1; break;
		case 206 : int INSIDE_BAR_RANGE; Condition = 1; break;
		case 207 : int INSIDE_RANGE; Condition = 1; break;
		case 208 : int OUTSIDE_BAR_RANGE; Condition = 1; break;
		case 209 : int OUTSIDE_RANGE; Condition = 1; break;
		case 210 : int CONTAINS; Condition = 1; break;
		case 211 : int PROPERTY_IS_SET; break;
		case 212 : int PROPERT_IS_NOT_SET; break;
		case 213 : int NOTE_IS_EQUAL_TO; Condition = 1; break;
		case 214 : int ALL_TYPES; Condition = 2; break;
		case 215 : int Every_other_Event; Condition = 2; break;
		case 216 : int BEFORE_CURSOR; Condition = 1; break;
		case 217 : int BEYOND_CURSOR; Condition = 1; break;
		case 218 : int INSIDE_CYCLE; Condition = 1; break;
		case 219 : int INSIDE_TRACK_LOOP; Condition = 1; break;
		case 220 : int EXACTLY_MATCHING_CYCLE; Condition = 1; break;
		case 221 : int CONTAINS_NOT; Condition = 1; break;
		default  : int Undefined; Undefined("condition"); break;

	}
};


void logicalOperatorInt() {
	switch( ReadShort() ) 
	{
		case 222 : int Not_Set; Op = "Not_Set"; break;

		//leActionTargetStart & leActionTargetTrim 
		case 304 : int Add; Op = "Add"; break;
		case 306 : int Subtract; Op = "Subtract"; break;
		case 307 : int Multiply; Op = "Multiply"; break;
		case 308 : int Divide; Op = "Divide"; break;
		case 309 : int Round_by; Op = "Round_by"; break;
		case 310 : int Set_Random_Values_Between; Op = "Set_Random_Values_Between"; break;
		case 311 : int Set_relative_random_values_between; Op = "Set_relative_random_values_between"; break;
		case 312 : int Set_to_fixed_value; Op = "Set_to_fixed_value"; break;

		case 313 : int Mirror; Op = "Mirror"; break;
		case 314 : int Transpose_to_Scale; Op = "Transpose_to_Scale"; break;
		case 315 : int Use_Value_1; Op = "Use_Value_1"; break;
		case 316 : int Use_Value_2; Op = "Use_Value_2"; break;
		case 317 : int Linear_Change_in_Loop_Range; Op = "Linear_Change_in_Loop_Range"; break;
		case 318 : int Relative_Change_in_Loop_Range; Op = "Relative_Change_in_Loop_Range"; break;
		//leActionTargetFloat
		case 320 : int Invert; Op = "Invert"; break;
		case 325 : int Add_Length; Op = "Add_Length"; break;
		// leActionTargetName
		case 326 : int Replace; Op = "Replace"; break;
		case 327 : int Append; Op = "Append"; break;
		case 328 : int Prepend; Op = "Prepend"; break;
		case 329 : int Generate_Name; Op = "Generate_Name"; break;
		case 330 : int Replace_Search_String; Op = "Replace_Search_String"; break;
		
		// leActionTargetTrackOp
		case 331 : int Folder; Op = "Folder"; break;
		case 332 : int Record; Op = "Record"; break;
		// Record is the only TrackOp that is associated with a UIntValue continuation section instead of LeUIntValue
		case 333 : int Monitor; Op = "Monitor"; break;
		case 334 : int Solo; Op = "Solo"; break;
		case 335 : int Mute; Op = "Mute"; break;
		// case 336 : int Not_Set; Op = "Not_Set"; break;
		case 337 : int Read; Op = "Read"; break;
		case 338 : int Write; Op = "Write"; break;
		case 339 : int EQ_Bypass; Op = "EQ_Bypass"; break;
		case 340 : int Inserts_Bypass; Op = "Inserts_Bypass"; break;
		case 341 : int Sends_Bypass; Op = "Sends_Bypass"; break;
		case 342 : int Lanes_Active; Op = "Lanes_Active"; break;
		case 343 : int Hide_Track; Op = "Hide_Track"; break;
		case 344 : int Time_Domain; Op = "Time_Domain"; break;

		// leActionTargetNXPOp
		case 355 : int Remove_NoteExp; Op = "Remove_NoteExp"; break;
		case 356 : int Reverse; Op = "Reverse"; break;
		case 357 : int Create_One_Shot; Op = "Create_One_Shot"; break;

		case 359 : int Not_Set; Op = "Not_Set"; break;

		// default
		default  : int Undefined; Op = "Undefined"; Undefined("leActionOp"); break;
	}
};