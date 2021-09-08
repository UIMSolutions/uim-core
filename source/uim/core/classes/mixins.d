/***********************************************************************************************
*	Copyright: © 2017-2021 UI Manufaktur UG
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
*	Documentation [DE]: https://ui-manufaktur.com/docu/uim-core/containers/aa
************************************************************************************************/
module uim.core.classes.mixins;

deprecated
template Shortcut(string className, string newName, string classParameters = "", string newParameters = "") {
	const char[] Shortcut = "auto "~newName~"("~newParameters~") { return new "~className~"("~classParameters~"); }";
}
