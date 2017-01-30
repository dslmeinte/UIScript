package com.dslconsultancy.uiscript.extensions;

import org.eclipse.xtext.xbase.lib.Functions.Function1;

import com.dslconsultancy.uiscript.core.AbstractValueDeclaration;
import com.dslconsultancy.uiscript.core.IteratorVariable;
import com.dslconsultancy.uiscript.core.Value;
import com.dslconsultancy.uiscript.elements.ListElement;
import com.dslconsultancy.uiscript.extensions.impl.ReferableExtensionsImpl;
import com.dslconsultancy.uiscript.types.TypeLiteral;
import com.google.inject.ImplementedBy;

@ImplementedBy(ReferableExtensionsImpl.class)
public interface ReferableExtensions {

	/**
	 * Inverse of {@link VariableDeclaration}{@code .variable}.
	 */
	AbstractValueDeclaration declaration(Value it);

	/**
	 * Finds the {@link ListElement} which defines the given {@link IteratorVariable}
	 * and performs the given Xtend functions for the case when it's the index or
	 * the value variable.
	 */
	<T extends Object> T ifIndexVarThenElse(IteratorVariable it,
			Function1<? super ListElement, ? extends T> indexFunc,
			Function1<? super ListElement, ? extends T> valueFunc);

	/**
	 * @return Whether this {@link Value} is variable, i.e. represents a variable.
	 */
	boolean isVariable(Value it);

	/**
	 * @return The type of the <em>value</em> {@link IteratorVariable} of the {@link ListElement} given.
	 */
	TypeLiteral valueVariableType(ListElement it);

}
