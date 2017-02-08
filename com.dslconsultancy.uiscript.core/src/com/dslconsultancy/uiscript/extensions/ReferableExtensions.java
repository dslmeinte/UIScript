package com.dslconsultancy.uiscript.extensions;

import com.dslconsultancy.uiscript.core.AbstractValueDeclaration;
import com.dslconsultancy.uiscript.core.Value;
import com.dslconsultancy.uiscript.extensions.impl.ReferableExtensionsImpl;
import com.google.inject.ImplementedBy;

@ImplementedBy(ReferableExtensionsImpl.class)
public interface ReferableExtensions {

	/**
	 * Inverse of {@link VariableDeclaration}{@code .variable}.
	 */
	AbstractValueDeclaration declaration(Value it);

	/**
	 * @return Whether this {@link Value} is variable, i.e. represents a variable.
	 */
	boolean isVariable(Value it);

}
