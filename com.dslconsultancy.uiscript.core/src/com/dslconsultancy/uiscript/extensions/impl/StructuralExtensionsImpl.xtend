package com.dslconsultancy.uiscript.extensions.impl

import com.dslconsultancy.uiscript.core.Argument
import com.dslconsultancy.uiscript.core.MethodDefinition
import com.dslconsultancy.uiscript.core.Parameter
import com.dslconsultancy.uiscript.core.Parametrisable
import com.dslconsultancy.uiscript.core.Viewable
import com.dslconsultancy.uiscript.core.ViewableCallSite
import com.dslconsultancy.uiscript.extensions.StructuralExtensions
import com.dslconsultancy.uiscript.extensions.ViewableExtensions
import com.dslconsultancy.uiscript.statements.GotoModuleStatement
import com.dslconsultancy.uiscript.statements.GotoScreenStatement
import com.dslconsultancy.uiscript.structural.UiModule
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton
import java.util.Set
import org.eclipse.emf.ecore.EObject

@Singleton
class StructuralExtensionsImpl implements StructuralExtensions {

	@Inject extension ViewableExtensions
	@Inject extension XtextUtil


	override name(UiModule it) {
		eResource.fileName
	}
	
	override viewables(UiModule it) {
		parametrisables.filter(typeof(Viewable))
	}

	override topLevelMethods(UiModule it) {
		parametrisables.filter(typeof(MethodDefinition)).map[method]
	}

	override firstScreen(UiModule it) {
		viewables.findFirst[screen]
	}

	override calledModules(UiModule it) {
		eAllContents.filter(typeof(GotoModuleStatement)).map[targetModule].toSet
	}

	override module(Viewable it) {
		eContainer.checkedCast(typeof(UiModule))
	}

	override referredModules(UiModule it) {
		val result = eAllContents.filter(typeof(GotoScreenStatement)).map[viewable.module].toSet
		result.addAll(calledModules)
		result.remove(it)
		result.remove(null)		// FIXME  this should not be necessary!
		return result
	}

	override allReferredModules(UiModule it) {
		val modules = <UiModule>newHashSet as Set<UiModule>
		visitModules(modules)
		return modules
	}

	def private void visitModules(UiModule currentModule, Set<UiModule> visitedModules) {
		val referredModules = currentModule.referredModules
		visitedModules += currentModule
		referredModules.filter[!visitedModules.contains(it)].forEach[visitModules(visitedModules)]
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

	override arguments(ViewableCallSite it) {
		argumentList.arguments as Iterable<Argument>
	}

}
