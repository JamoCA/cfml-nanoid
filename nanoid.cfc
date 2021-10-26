/**
 * Name: nanoid.cfc https://github.com/JamoCA/cfml-nanoid
 * Author: James Moberg (james@sunstarmedia.com)
 * Purpose: CFML implementation of Nano ID, secure URL-friendly unique ID generator
 * Date: 10/24/2021
 */
component accessors="true" singleton displayname="CF_NanoID" output="false" hint="CFML implementation of Nano ID, secure URL-friendly unique ID generator" {

	variables.alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-";
	variables.alphabetArray = listToArray(variables.alphabet, "");
	variables.size = 21;

	public nanoid function init(string alphabet="", numeric size=0) output=false {
		if (len(trim(arguments.alphabet))){
			setAlphabet(arguments.alphabet);
		}
		if (val(arguments.size) neq 0){
			setSize(arguments.size);
		}
		return this;
	}

	public void function setAlphabet(string alphabet=""){
		local.alphabet = listRemoveDuplicates(arrayToList(listToArray(arguments.alphabet, "")), ",", true);
		if (listLen(local.alphabet) lt 1 or listLen(local.alphabet) gt 255){
			throw(message = "alphabet must contain between 1 and 255 unique symbols.");
		}
		variables.alphabet = local.alphabet;
		variables.alphabetArray = listToArray(local.alphabetArray);
	}

	public void function setSize(numeric size=0){
		if (not isValid("integer", arguments.size) or val(arguments.size) lte 0){
			throw(message = "size must be a postive integer.");
		}
		variables.size = val(arguments.size);
	}

	public string function generate(string alphabet="", numeric size=0) output=false hint="Returns a tiny, secure, URL-friendly, unique string ID" {
		local.alphabetArray = variables.alphabetArray;
		local.size = variables.size;
		if (len(trim(arguments.alphabet))){
			local.alphabet = listRemoveDuplicates(arrayToList(listToArray(arguments.alphabet, "")), ",", true);
			if (listLen(local.alphabet) lt 1 or listLen(local.alphabet) gt 255){
				throw(message = "alphabet must contain between 1 and 255 unique symbols.");
			}
			local.alphabetArray = listToArray(local.alphabet);
		}
		if (val(arguments.size) neq 0){
			if (not isValid("integer", arguments.size) or val(arguments.size) lte 0){
				throw(message = "size must be a postive integer.");
			}
			local.size = val(arguments.size);
		}
		local.result = [];
		arrayResize(local.result, local.size);
		local.alphabitSize = arrayLen(local.alphabetArray);
		for (local.i=1; local.i lte local.size; local.i=local.i+1){
			local.result[local.i] = local.alphabetArray[randRange(1, local.alphabitSize, "SHA1PRNG")];
		}
		return arrayToList(local.result,"");
	}

}
