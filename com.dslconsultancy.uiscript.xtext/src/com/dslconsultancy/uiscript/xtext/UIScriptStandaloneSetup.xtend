/*
 * generated by Xtext 2.10.0
 */
package com.dslconsultancy.uiscript.xtext


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class UIScriptStandaloneSetup extends UIScriptStandaloneSetupGenerated {

	def static void doSetup() {
		new UIScriptStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}