/***********************************************************************************************
*	Copyright: © 2017-2021 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: Before 2022 UI Manufaktur UG Team / Since 2022 - Ozan Nurettin Süel (sicherheitsschmiede) 
*	Documentation [DE]: https://www.sicherheitsschmiede.de/docus/uim-core/containers/aa
************************************************************************************************/
module uim.core.classes.mixins;

deprecated
template Shortcut(string className, string newName, string classParameters = "", string newParameters = "") {
	const char[] Shortcut = "auto "~newName~"("~newParameters~") { return new "~className~"("~classParameters~"); }";
}
