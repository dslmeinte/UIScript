package com.dslconsultancy.uiscript.extensions;

import java.util.List;

import com.dslconsultancy.uiscript.extensions.impl.ViewableExtensionsImpl;
import com.dslconsultancy.uiscript.uidsl.DefinedViewable;
import com.dslconsultancy.uiscript.uidsl.Element;
import com.dslconsultancy.uiscript.uidsl.MethodDefinition;
import com.dslconsultancy.uiscript.uidsl.Value;
import com.dslconsultancy.uiscript.uidsl.Viewable;
import com.google.inject.ImplementedBy;

@ImplementedBy(ViewableExtensionsImpl.class)
public interface ViewableExtensions {

	/**
	 * @return The {@link Element elements} contained in this {@link Viewable}.
	 */
	Iterable<Element> elements(DefinedViewable it);

	/**
	 * @return The local {@link MethodDefinition method definitions} contained in this {@link Viewable}.
	 */
	Iterable<MethodDefinition> localMethodDefinitions(DefinedViewable it);

	/**
	 * @return The {@link Value values} declared in the <b>values</b>-block of this {@link Viewable}.
	 */
	List<Value> values(final DefinedViewable it);

	/**
	 * @return Whether this {@link Viewable} is a re-usable component (not a screen).
	 */
	boolean isComponent(final Viewable it);

	/**
	 * @return Whether this {@link Viewable} is a screen.
	 */
	boolean isScreen(final Viewable it);

}
