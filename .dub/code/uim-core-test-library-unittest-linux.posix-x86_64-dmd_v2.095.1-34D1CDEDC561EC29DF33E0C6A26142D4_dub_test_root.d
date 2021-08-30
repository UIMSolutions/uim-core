module dub_test_root;
import std.typetuple;
static import uim.core.classes.mixins;
static import uim.core.containers.aa;
static import uim.core.containers.array_;
static import uim.core.containers.stringaa;
static import uim.core.datatypes.boolean;
static import uim.core.datatypes.datetime;
static import uim.core.datatypes.floating;
static import uim.core.datatypes.general;
static import uim.core.datatypes.integral;
static import uim.core.datatypes.string_;
static import uim.core.datatypes.uuid;
static import uim.core.io.file;
static import uim.core.mixins.function_;
static import uim.core.mixins.properties.classical;
static import uim.core.mixins.property;
static import uim.core.web.html;
static import uim.core.web.json;
alias allModules = TypeTuple!(uim.core.classes.mixins, uim.core.containers.aa, uim.core.containers.array_, uim.core.containers.stringaa, uim.core.datatypes.boolean, uim.core.datatypes.datetime, uim.core.datatypes.floating, uim.core.datatypes.general, uim.core.datatypes.integral, uim.core.datatypes.string_, uim.core.datatypes.uuid, uim.core.io.file, uim.core.mixins.function_, uim.core.mixins.properties.classical, uim.core.mixins.property, uim.core.web.html, uim.core.web.json);

						import std.stdio;
						import core.runtime;

						void main() { writeln("All unit tests have been run successfully."); }
						shared @safe: 
static this() {
							version (Have_tested) {
								import tested;
								import core.runtime;
								import std.exception;
								Runtime.moduleUnitTester = () => true;
								enforce(runUnitTests!allModules(new ConsoleTestResultWriter), "Unit tests failed.");
							}
						}
					