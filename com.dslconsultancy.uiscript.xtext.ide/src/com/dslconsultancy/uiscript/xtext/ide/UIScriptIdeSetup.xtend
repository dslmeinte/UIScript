/*
 * generated by Xtext 2.11.0
 */
package com.dslconsultancy.uiscript.xtext.ide

import com.dslconsultancy.uiscript.xtext.UIScriptRuntimeModule
import com.dslconsultancy.uiscript.xtext.UIScriptStandaloneSetup
import com.google.inject.Guice
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class UIScriptIdeSetup extends UIScriptStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new UIScriptRuntimeModule, new UIScriptIdeModule))
	}
	
}
