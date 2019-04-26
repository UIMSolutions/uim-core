module uim.core.classes.mixins;

// Simplifies class instance creation
template Shortcut(string className, string newName, string classParameters = "", string newParameters = "") {
	const char[] Shortcut = "auto "~newName~"("~newParameters~") { return new "~className~"("~classParameters~"); }";
}
