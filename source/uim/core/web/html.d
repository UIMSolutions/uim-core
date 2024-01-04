/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.web.html;

import uim.core;

@safe:
// #region createHtmlStartTag 
string createHtmlStartTag(string tag, bool close = false) {
	if (close)
		return "<" ~ tag ~ "/>";
	return "<" ~ tag ~ ">";
}

string createHtmlStartTag(string tag, STRINGAA attributes, bool close = false) {
	if (attributes) {
		string attValue = attributes.byKeyValue
			.map!(kv => `%s="%s"`.format(kv.key, kv.value))
			.join(" ");

		if (close)
			return "<%s %s/>".format(tag, attValue);
		return "<%s %s>".format(tag, attValue);
	}
	return createHtmlStartTag(tag, close);
}
// #endregion createHtmlStartTag 

// #region createHtmlEndTag 
string createHtmlEndTag(string tag) {
	return "</" ~ tag ~ ">";
}
// #endregion createHtmlEndTag 

string createHtmlDoubleTag(string tag, string[] content...) {
	if (content) {
		return createHtmlStartTag(tag) ~ content.join("") ~ createHtmlEndTag(tag);
	}
	return createHtmlStartTag(tag, true);
}

string createHtmlDoubleTag(string tag, STRINGAA attributes, string[] content...) {
	if (content) {
		return createHtmlStartTag(tag, attributes) ~ content.join("") ~ createHtmlEndTag(tag);
	}
	return createHtmlStartTag(tag, attributes, true);
}

string createHtmlSingleTag(string tag) {
	return createHtmlStartTag(tag);
}

string createHtmlSingleTag(string tag, STRINGAA attributes) {
	return createHtmlStartTag(tag, attributes);
}
