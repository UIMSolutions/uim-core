/***********************************************************************************************
*	Copyright: © 2017-2021 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: Before 2022 UI Manufaktur UG Team / Since 2022 - Ozan Nurettin Süel (sicherheitsschmiede) 
*	Documentation [DE]: https://ui-manufaktur.com/docu/uim-core/web/html
************************************************************************************************/
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