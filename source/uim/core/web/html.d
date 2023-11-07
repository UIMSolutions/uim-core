/***********************************************************************************************************************
*	Copyright: © 2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: UI Manufaktur UG Team, Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.web.html;

import uim.core;

string htmlStartTag(string tag, bool close = false) { 
	if (close) return "<"~tag~"/>"; 
	return "<"~tag~">"; 
}
string htmlStartTag(string tag, string[string] attributes, bool close = false) { 
	if (attributes) {
		string[] atts; 
		foreach(k, v; attributes) atts ~= `%s="%s"`.format(k, v);
		if (close) return "<"~tag~" "~atts.join(" ")~"/>"; 
		return "<"~tag~" "~atts.join(" ")~">"; 
	}
	return htmlStartTag(tag, close); 
}
string htmlEndTag(string tag) { return "</"~tag~">"; }

string htmlDoubleTag(string tag, string[] content...) {
	if (content) return htmlStartTag(tag) ~ content.join("") ~ htmlEndTag(tag);
	return htmlStartTag(tag, true);
}

string htmlDoubleTag(string tag, string[string] attributes, string[] content...) {
	if (content) return htmlStartTag(tag, attributes) ~ content.join("") ~ htmlEndTag(tag);
	return htmlStartTag(tag, attributes, true);
}

string htmlSingleTag(string tag) { return htmlStartTag(tag); }
string htmlSingleTag(string tag, string[string] attributes) { return htmlStartTag(tag, attributes); }