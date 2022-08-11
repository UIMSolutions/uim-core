﻿/***********************************************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: UI Manufaktur UG Team, Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.core.io.file;

import std.file;
import uim.core;

version(linux) {
	bool copy(string fileName, string fromDir, string toDir, bool createMissingDirs = true, bool overwriteExistingFile = true) {
		if (fileName.length == 0) return false;
		if (fromDir.length == 0) return false;
		if (toDir.length == 0) return false;

		string from = fromDir;
		if (from[$-1] != '/') from ~= "/";

		if (!exists(from~fileName)) return false;

		string to = toDir; 
		if (to[$-1] != '/') to ~= "/";

		if (createMissingDirs) {
			if (!exists(from)) mkdir(from);
			if (!exists(to)) mkdir(to);
		}
		else {
			if (!exists(from)) return false;
			if (!exists(to)) return false;
		}

		if (!overwriteExistingFile && exists(to~fileName)) return false;

		try { std.file.copy(from~fileName, to~fileName); }
		catch(Exception e) { return false; }

		return true;
	}
}

version(linux) {
	bool move(string fileName, string fromDir, string toDir, bool createMissingDirs = true, bool overwriteExistingFile = true) {
		if (fileName.length == 0) return false;
		if (fromDir.length == 0) return false;
		if (toDir.length == 0) return false;
		
		string from = fromDir;
		if (from[$-1] != '/') from ~= "/";
		
		if (!exists(from~fileName)) return false;
		
		string to = toDir; 
		if (to[$-1] != '/') to ~= "/";
		
		if (createMissingDirs) {
			if (!exists(from)) mkdir(from);
			if (!exists(to)) mkdir(to);
		}
		else {
			if (!exists(from)) return false;
			if (!exists(to)) return false;
		}
		
		if (!overwriteExistingFile && exists(to~fileName)) return false;
		
		try { fileName.copy(from, to); }
		catch(Exception e) { return false; }

		try { std.file.remove(from~fileName); }
		catch(Exception e) { return false; }

		return true;
	}
}
version(test_uim_core) { unittest {
	// Todo
}}

auto dirEntryInfos(string path) {
  FileInfo[] results;
  bool dirEntryInfo(FileInfo info) { results ~= info; return true; }
  listDirectory(path, &dirEntryInfo);
  return results;
}

auto dirNames(string path, bool fullName = false) {
  string[] results = dirEntryInfos(path).filter!(a => a.isDirectory).map!(a => a.name).array;
  if (fullName) results = results.map!(a => path~"/"~a).array;
  return results;
}

auto linkNames(string path, bool fullName = false) {
  string[] results = dirEntryInfos(path).filter!(a => a.isSymlink).map!(a => a.name).array;
  if (fullName) results = results.map!(a => path~"/"~a).array;
  return results;
}
  
auto fileNames(string path, bool fullName = false) {
  string[] results = dirEntryInfos(path).filter!(a => a.isFile).map!(a => a.name).array;
  if (fullName) results = results.map!(a => path~"/"~a).array;
  return results;
}

