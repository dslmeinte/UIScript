package com.dslconsultancy.uiscript.extensions;

import java.util.Set;

import org.eclipse.emf.ecore.EObject;

import com.dslconsultancy.uiscript.core.Argument;
import com.dslconsultancy.uiscript.core.Method;
import com.dslconsultancy.uiscript.core.Parameter;
import com.dslconsultancy.uiscript.core.Parametrisable;
import com.dslconsultancy.uiscript.core.Viewable;
import com.dslconsultancy.uiscript.core.ViewableCallSite;
import com.dslconsultancy.uiscript.extensions.impl.StructuralExtensionsImpl;
import com.dslconsultancy.uiscript.statements.GotoModuleStatement;
import com.dslconsultancy.uiscript.statements.GotoScreenStatement;
import com.dslconsultancy.uiscript.structural.UiModule;
import com.google.inject.ImplementedBy;

@ImplementedBy(StructuralExtensionsImpl.class)
public interface StructuralExtensions {

	/**
	 * @return The effective name of the {@link UiModule}, derived from its file name.
	 */
	String name(UiModule it);

	/**
	 * @return All the {@link Viewable}s of the module.
	 */
	Iterable<Viewable> viewables(UiModule it);

	/**
	 * @return All the {@link Method methods} of the module.
	 */
	Iterable<Method> topLevelMethods(UiModule it);

	/**
	 * @return The first actual screen of this module.
	 */
	Viewable firstScreen(UiModule it);

	/**
	 * @return A {@link Set} of all modules explicitly called by this module,
	 * 	through a {@code goto-module} {@link GotoModuleStatement statement}.
	 */
	Set<UiModule> calledModules(UiModule it);

	/**
	 * @return The {@link UiModule UI module} this {@link Viewable} resides in.
	 */
	UiModule module(Viewable it);

	/**
	 * @return A {@link Set} of all modules referenced by this {@link UiModule UI module}
	 * 	either explicitly through a {@code goto-module} {@link GotoModuleStatement statement}
	 * 	or implicitly through a {@code goto(-screen)} {@link GotoScreenStatement statement}
	 * 	where the target screen is located in another module.
	 */
	Set<UiModule> referredModules(UiModule it);

	/**
	 * @return A {@link Set} of all modules (transitively) referred to by/from this module.
	 */
	Set<UiModule> allReferredModules(UiModule it);

	/**
	 * @return The containing {@link UiModule}.
	 */
	UiModule containingModule(EObject it);

	/**
	 * +--------------------------+
	 * | parameters and arguments |
	 * +--------------------------+
	 * 
	 * The reuse of parameter and argument lists into separate type rules
	 * (and thus: types) is essentially a grammar engineering matter and
	 * clients of types having such lists shouldn't be burdened with that
	 * choice.
	 */
	Iterable<Parameter> parameters(Parametrisable it);

	Iterable<Argument> arguments(ViewableCallSite it);

}
