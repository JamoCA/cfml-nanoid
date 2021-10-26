/**
 * Name: nanoid.cfc https://github.com/JamoCA/cfml-nanoid
 * Author: James Moberg (james@sunstarmedia.com)
 * Purpose: CFML implementation of Nano ID, secure URL-friendly unique ID generator
 * Date: 10/24/2021 Initial function
 * 10/26/2021 Added dictionary and support for different algorithms.
 */
component accessors="true" singleton displayname="CF_NanoID" output="false" hint="CFML implementation of Nano ID, secure URL-friendly unique ID generator" {

	variables.size = 21;
	variables.algorithms = ["SHA1PRNG", "IBMSecureRandom", "NativePRNG", "NativePRNGBlocking", "NativePRNGNonBlocking"];
	variables.algorithm = variables.algorithms[1];
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
	variables.alphabet = variables.dictionary["default"];

	public nanoid function init(string alphabet="", numeric size=0, string algorithm="SHA1PRNG") output=false {
		if (len(trim(arguments.alphabet))){
			setAlphabet(arguments.alphabet);
		}
		if (val(arguments.size) neq 0){
			setSize(arguments.size);
		}
		if (len(arguments.algorithm)){
			setAlgorithm(arguments.algorithm);
		}
		return this;
	}

	public void function setAlphabet(string alphabet=""){
		variables.alphabet = initAlphabet(arguments.alphabet);
	}

	public void function setSize(numeric size=0){
		variables.size = initSize(arguments.size);
	}

	public void function setAlgorithm(string algorithm="SHA1PRNG"){
		variables.algorithm = initAlgorithm(arguments.algorithm);
	}

	public array function getAlgorithms(){
		return variables.algorithms;
	}

	public struct function getDictionary(){
		return variables.dictionary;
	}

	private string function initAlphabet(string alphabet) output=true {
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

	private string function initAlgorithm(string algorithm){
		local.algorithm = variables.algorithm;
		if (len(arguments.algorithm)){
			if (not arrayFindNoCase(variables.algorithms, arguments.algorithm)){
				throw(message = "algorithm must be one of #arrayToList(variables.algorithms)#.");
			}
			local.algorithm = arguments.algorithm;
		}
		return local.algorithm;
	}

	private numeric function initSize(numeric size=0){
		local.size = val(variables.size);
		if (val(arguments.size) neq 0){
			if (not isValid("integer", arguments.size) or val(arguments.size) lte 0){
				throw(message = "size must be a postive integer.");
			}
			local.size = val(arguments.size);
		}
		return javacast("int", local.size);
	}

	public string function generate(string alphabet="", numeric size=0, string algorithm="") output=true hint="Returns a tiny, secure, URL-friendly, unique string ID" {
		local.alphabet = javacast("string", initAlphabet(arguments.alphabet)).replaceAll(",", "");
		local.alphabet = listToArray(local.alphabet, "");
		local.alphabitSize = arrayLen(local.alphabet);
		local.size = initSize(arguments.size);
		local.algorithm = initAlgorithm(arguments.algorithm);
		local.result = [];
		arrayResize(local.result, local.size);
		//writeDump(local.alphabet);
		for (local.i=1; local.i lte local.size; local.i=local.i+1){
			arrayAppend(local.result, local.alphabet[randRange(1, local.alphabitSize, local.algorithm)]);
		}
		return arrayToList(local.result,"");
	}

}
