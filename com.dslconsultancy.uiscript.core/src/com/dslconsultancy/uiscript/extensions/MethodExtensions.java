package com.dslconsultancy.uiscript.extensions;

import java.util.Set;

import com.dslconsultancy.uiscript.core.Argument;
import com.dslconsultancy.uiscript.core.Expression;
import com.dslconsultancy.uiscript.core.Method;
import com.dslconsultancy.uiscript.core.MethodDefinition;
import com.dslconsultancy.uiscript.core.Viewable;
import com.dslconsultancy.uiscript.expressions.aux.MethodCallExpression;
import com.dslconsultancy.uiscript.extensions.impl.MethodExtensionsImpl;
import com.google.inject.ImplementedBy;

@ImplementedBy(MethodExtensionsImpl.class)
public interface MethodExtensions {

	/**
	 * @return The {@link MethodDefinition} defining the given {@link Method} - provides access to parameters and such.
	 */
	MethodDefinition definition(Method it);

	/**
	 * @return Whether the given {@link Method} is defined at top-level (as opposed to: inside a {@link Viewable}).
	 */
	boolean isTopLevel(Method it);

	/**
	 * @return Whether the indicated {@link Method} is actually a function.
	 */
	boolean isFunction(Method it);

	/**
	 * @return The {@link Argument arguments} of this {@link MethodCallExpression}.
	 */
	Iterable<Argument> arguments(MethodCallExpression it);

	/**
	 * @return The set of {@link Expression value expressions} to observe in this {@link MethodCallExpression}.
	 */
	Set<? extends Expression> valuesToObserve(MethodCallExpression it);

	/**
	 * @return Whether this {@link Method} is a pure function.
	 */
	boolean isPure(Method it);

}
