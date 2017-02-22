package com.dslconsultancy.uiscript.extensions.impl

import com.dslconsultancy.uiscript.core.MethodDefinition
import com.dslconsultancy.uiscript.core.Parameter
import com.dslconsultancy.uiscript.core.Parametrisable
import com.dslconsultancy.uiscript.extensions.StructuralExtensions
import com.dslconsultancy.uiscript.structural.UiModule
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton
import org.eclipse.emf.ecore.EObject

@Singleton
class StructuralExtensionsImpl implements StructuralExtensions {

	@Inject extension XtextUtil


	override name(UiModule it) {
		eResource.fileName
	}
	
	override topLevelMethods(UiModule it) {
		parametrisables.filter(typeof(MethodDefinition)).map[method]
	}

	override containingModule(EObject it) {
		eResource.contents.head.checkedCast(typeof(UiModule))
	}


	/*
	 * +--------------------------+
	 * | parameters and arguments |
	 * +--------------------------+
	 * 
	 * The reuse of parameter and argument lists into separate type rules
	 * (and thus: types) is essentially a grammar engineering matter and
	 * clients of types having such lists shouldn't be burdened with that
	 * choice.
	 */

	override parameters(Parametrisable it) {
		parameterList.parameters as Iterable<Parameter>
	}

}
