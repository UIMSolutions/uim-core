/***********************************************************************************************
*	Copyright: © 2017-2020 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
*	Documentation [DE]: https://ui-manufaktur.com/docu/uim-core/containers/stringaa
************************************************************************************************/
module uim.core.containers.stringaa;

import std.algorithm : startsWith, endsWith; 
import uim.core; 

alias StringAA = string[string];

	StringAA addKeyPrefix(StringAA entries, string prefix) {
		StringAA results;
		foreach(k, v; entries) results[prefix~k] = v;
		return results;
	}
	unittest {
		/// TODO
	}

	/// Selects only entries, where key starts with prefix. Creates a new StringAA
	@safe StringAA selectStartsWith(StringAA entries, string prefix) {  
		StringAA results;
		foreach(k, v; entries) if (k.startsWith(prefix)) results[k] = v;
		return results;
	}
	unittest {
		assert(selectStartsWith(["preA":"a", "b":"b"], "pre") == ["preA":"a"]);
		assert(["preA":"a", "b":"b"].selectStartsWith("pre") == ["preA":"a"]);
	}

	/// Opposite of selectStartsWith: Selects only entries, where key starts not with prefix. Creates a new StringAA
	StringAA selectsStartsNotWith(StringAA entries, string prefix) {  // right will overright left
		StringAA results;
		foreach(k, v; entries) if (!k.startsWith(prefix)) results[k] = v;
		return results;
	}
	unittest {
		assert(selectsStartsNotWith(["preA":"a", "b":"b"], "pre") == ["b":"b"]);
		assert(["preA":"a", "b":"b"].selectsStartsNotWith("pre") == ["b":"b"]);
	}

	StringAA endsWith(StringAA entries, string postfix) {  // right will overright left
		StringAA results;
		foreach(k, v; entries) if (k.endsWith(postfix)) results[k] = v;
		return results;
	}
	unittest {
		/// TODO
	}

	StringAA endsNotWith(StringAA entries, string postfix) {  // right will overright left
		StringAA results;
		foreach(k, v; entries) if (!k.endsWith(postfix)) results[k] = v;
		return results;
	}
	unittest {
		/// TODO
	}

	StringAA selectKeys(StringAA entries, string[] keys) {
		StringAA results;
		foreach(k; keys) if (k in entries) results[k] = entries[k];
		return results;
	}
	unittest {
		/// TODO
	}

	StringAA selectNotKeys(StringAA entries, string[] keys) {
		StringAA results = entries.dup;
		foreach(k; keys) if (k in entries) results.remove(k);
		return results;
	}
	unittest {
		/// TODO
	}

	StringAA selectValues(StringAA entries, string[] values) {
		StringAA results;
		foreach(val; values) {
			foreach(k, v; entries) {
				if (v == val) results[k] = entries[k];
			}
		}
		return results;
	}
	unittest {
		/// TODO
	}

	string toString(string[string] aa) {
		import std.string; 
		return "%s".format(aa);
	}

	string aa2String(STRINGAA atts, string sep = "=") {
		string[] strings;
		foreach(k, v; atts) strings ~= k~sep~"\""~v~"\"";
		return strings.join(" ");
	}
	unittest {
		/// TODO
	}

