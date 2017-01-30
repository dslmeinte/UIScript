package com.dslconsultancy.uiscript.extensions;

import org.eclipse.emf.ecore.EObject;

import com.dslconsultancy.uiscript.core.Argument;
import com.dslconsultancy.uiscript.core.Method;
import com.dslconsultancy.uiscript.core.Parameter;
import com.dslconsultancy.uiscript.core.Parametrisable;
import com.dslconsultancy.uiscript.core.Viewable;
import com.dslconsultancy.uiscript.core.ViewableCallSite;
import com.dslconsultancy.uiscript.extensions.impl.StructuralExtensionsImpl;
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
