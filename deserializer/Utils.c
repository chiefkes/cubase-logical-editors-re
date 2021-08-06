// reverse a string
string RevString(string str) {
	local int i;
	local string tempStr;
	local int strlen = Strlen( str );
	for( i = strlen-1; i >= 0; i-- ) {
		Strcat( tempStr, str[i] );
	}
	return tempStr;
};

void Undefined(string attr) 
{
	Printf("\nUndefined %s", attr);
	return;
};