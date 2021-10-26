/**
 * Name: nanoid.cfc https://github.com/JamoCA/cfml-nanoid
 * Author: James Moberg (james@sunstarmedia.com)
 * Purpose: CFML implementation of Nano ID, secure URL-friendly unique ID generator
 * Date: 10/24/2021 Initial function
 * 10/26/2021 Added dictionary and support for secure / non-secure
 */
component accessors="true" singleton displayname="CF_NanoID" output="false" hint="CFML implementation of Nano ID, secure URL-friendly unique ID generator" {

	variables.type = "non-secure";
	variables.size = 21;
	variables.dictionary = [
		"default" = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-",
		"numbers" = "0123456789",
		"hexadecimalLowercase" = "0123456789abcdef",
		"hexadecimalUppercase" = "0123456789ABCDEF",
		"lowercase" = "abcdefghijklmnopqrstuvwxyz",
		"uppercase" = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
		"alphanumeric" = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
		"nolookalikes" = "346789ABCDEFGHJKLMNPQRTUVWXYabcdefghijkmnpqrtwxyz",
		"nolookalikesSafe" = "6789BCDFGHJKLMNPQRTWbcdfghjkmnpqrtwz"
	];
	variables.alphabetArray = [];
	variables.alphabet = variables.dictionary["default"];

	public nanoid function init(string alphabet="", numeric size=0, string type="non-secure") output=false {
		if (len(trim(arguments.alphabet))){
			setAlphabet(arguments.alphabet);
		}
		if (val(arguments.size) neq 0){
			setSize(arguments.size);
		}
		if (len(arguments.type)){
			setType(arguments.type);
		}
		return this;
	}

	public void function setAlphabet(string alphabet=""){
		variables.dictionary = initAlphabet(arguments.alphabet);
		variables.alphabetArray = listToArray(local.alphabetArray);
	}

	public void function setSize(numeric size=0){
		variables.size = initSize(arguments.type);
	}

	public void function setType(string type="non-secure"){
		variables.type = initType(arguments.type);
	}

	public string function generate(string alphabet="", numeric size=0, string type="") output=true hint="Returns a tiny, secure, URL-friendly, unique string ID" {
		local.alphabet = initAlphabet(arguments.alphabet);
		local.size = initSize(arguments.size);
		local.type = initType(arguments.type);
		if (local.type is "secure"){
			return generate_secure(local.alphabet, local.size);
		} else {
			//TODO use hardward random generation
			return generate_nonsecure(local.alphabet, local.size);
		}
	}

	private string function initAlphabet(string alphabet){
		local.alphabet = variables.alphabet;
		if (len(trim(arguments.alphabet))){
			if (variables.dictionary.keyExists(arguments.alphabet)){
				arguments.alphabet = variables.dictionary[arguments.alphabet];
			}
			local.alphabet = listRemoveDuplicates(arrayToList(listToArray(arguments.alphabet, "")), ",", true);
			if (listLen(local.alphabet) lt 1 or listLen(local.alphabet) gt 255){
				throw(message = "alphabet must contain between 1 and 255 unique symbols.");
			}
		}
		return local.alphabet;
	}

	private string function initType(string type){
		local.type = variables.type;
		if (len(arguments.type)){
			if (not listFindNoCase("secure,non-secure", arguments.type)){
				throw(message = "type must be secure or non-secure.");
			}
			local.type = arguments.type;
		}
		return local.type;
	}

	private numeric function initSize(string size){
		local.size = val(variables.size);
		if (val(arguments.size) neq 0){
			if (not isValid("integer", arguments.size) or val(arguments.size) lte 0){
				throw(message = "size must be a postive integer.");
			}
			local.size = val(variables.size);
		}
		return javacast("int", local.size);
	}

	private string function generate_secure(required string alphabet, required numeric size) output=true hint="generates fast, non-secure id" {
		local.alphabetArray = listToArray(arguments.alphabet,"");
		local.alphabitSize = arrayLen(local.alphabetArray);
		local.sr = createObject( "java", "java.security.SecureRandom" ).getInstance(javacast( "string", "SHA1PRNG" ),javacast( "string", "SUN" ));
		local.result = [];
		while (true) {
			local.rnd = int(local.sr.nextDouble() * (local.alphabitSize-1));
			if (local.rnd gt 0){
				arrayAppend(local.result, local.alphabetArray[local.rnd]);
				if (arrayLen(local.result) gte arguments.size){
					return arrayToList(local.result,"");
				}
			}
		}
	}

	private string function generate_nonsecure(required string alphabet, required numeric size) output=true hint="generates fast, non-secure id" {
		local.alphabetArray = listToArray(arguments.alphabet,"");
		local.alphabitSize = arrayLen(local.alphabetArray);
		local.result = [];
		arrayResize(local.result, arguments.size);
		/* shuffle to create extrea randomness */
		createObject( "java", "java.util.Collections" ).Shuffle(local.alphabetArray);
		for (local.i=1; local.i lte arguments.size; local.i=local.i+1){
			local.result[local.i] = local.alphabetArray[randRange(1, local.alphabitSize, "SHA1PRNG")];
		}
		return arrayToList(local.result,"");
	}

}
