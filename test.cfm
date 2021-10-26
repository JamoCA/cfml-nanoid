<cfscript>
nanoId = new nanoId();

numeric function getNano() hint="returns nano time (more accurate)" {
	return createObject("java", "java.lang.System").nanoTime();
}

maxResults = 5;

algorithms = nanoId.getAlgorithms();
writeOutput("<hr><h2>Algorithms</h2>");
writeOutput("<ol>");
for (algorithm in algorithms){
	writeOutput("<li><b>nanoId.generate(algorithm=""#algorithm#"");</b><ol>");
	nanoId.setAlgorithm(algorithm);
	for (i=1; i lte maxResults; i=i+1) {
		ns = getNano(); ms = getTickCount();
		id = nanoId.generate();
		ns = getNano()-ns; ms = getTickCount() - ms;
		writeOutput( "<li><tt>#id#</tt> <i>{len:#len(id)#, ns:#ns#, ms:#ms#}</i></li>");
	}
	writeOutput("</ol></li>");
}
writeOutput("</ol>");


dictionaries = nanoId.getDictionary();
dictionaries["abc123"] = "abc123"; /* custom (just pass 1 - 255 characters that you want to use */
nanoId.setAlgorithm("SHA1PRNG");
writeOutput("<hr><h2>Dictionaries</h2>");
writeOutput("<ol>");
for (dictionary in dictionaries){
	writeOutput("<li><b>nanoId.generate(alphabet=""#dictionary#"");</b> (<tt>#dictionaries[dictionary]#</tt>)<ol>");
	nanoId.setAlphabet(dictionary);
	for (i=1; i lte maxResults; i=i+1) {
		ns = getNano(); ms = getTickCount();
		id = nanoId.generate();
		ns = getNano()-ns; ms = getTickCount() - ms;
		writeOutput( "<li><tt>#id#</tt> <i>{len:#len(id)#, ns:#ns#, ms:#ms#}</i></li>");
	}
	writeOutput("</ol></li>");
}
writeOutput("</ol>");

sizes = [5, 10, 15, 20, 25, 30, 35, 50, 100, 125];
nanoId.setAlphabet("default");
nanoId.setAlgorithm("SHA1PRNG");
writeOutput("<hr><h2>Size</h2>");
writeOutput("<ol>");
for (size in sizes){
	writeOutput("<li><b>nanoId.generate(size=#size#);</b><ol>");
	nanoId.setSize(size);
	for (i=1; i lte maxResults; i=i+1) {
		ns = getNano(); ms = getTickCount();
		id = nanoId.generate();
		ns = getNano()-ns; ms = getTickCount() - ms;
		writeOutput( "<li><tt>#id#</tt> <i>{len:#len(id)#, ns:#ns#, ms:#ms#}</i></li>");
	}
	writeOutput("</ol></li>");
}
writeOutput("</ol>");

writeOutput("<hr><h2>Random Inline Options</h2>");
writeOutput("<ol>");
for (r=1; r lte 10; r=r+1) {
	alphabet = listGetAt(structKeyList(dictionaries), randRange(1, structCount(dictionaries), "SHA1PNG"));
	algorithm = algorithms[randRange(1, arrayLen(algorithms), "SHA1PNG")];
	size = sizes[randRange(1, arrayLen(sizes), "SHA1PNG")];
	writeOutput("<li><b>nanoId.generate(alphabet=""#alphabet#"", size=#size#, algorithm=""#algorithm#"")</b><ol>");
	for (i=1; i lte maxResults; i=i+1) {
		ns = getNano(); ms = getTickCount();
		id = nanoId.generate(alphabet=alphabet, size=size, algorithm=algorithm);
		ns = getNano()-ns; ms = getTickCount() - ms;
		writeOutput( "<li><tt>#id#</tt> <i>{len:#len(id)#, ns:#ns#, ms:#ms#}</i></li>");
	}
	writeOutput("</ol></li>");
}
writeOutput("</ol>");

</cfscript>
