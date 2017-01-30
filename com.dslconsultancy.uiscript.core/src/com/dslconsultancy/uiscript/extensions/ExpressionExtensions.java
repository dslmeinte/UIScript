package com.dslconsultancy.uiscript.extensions;

import java.util.LinkedHashSet;
import java.util.Set;

import com.dslconsultancy.uiscript.expressions.Expression;
import com.dslconsultancy.uiscript.expressions.FeatureAccessExpression;
import com.dslconsultancy.uiscript.expressions.ListLiteralExpression;
import com.dslconsultancy.uiscript.expressions.aux.MethodCallExpression;
import com.dslconsultancy.uiscript.extensions.impl.ExpressionExtensionsImpl;
import com.dslconsultancy.uiscript.types.TypeLiteral;
import com.dslconsultancy.uiscript.uidsl.Method;
import com.google.inject.ImplementedBy;

@ImplementedBy(ExpressionExtensionsImpl.class)
public interface ExpressionExtensions {

	/**
	 * @return Whether this {@link Expression} is observable or not (e.g., because of the use of a function that's not bi-directional).
	 */
	boolean isObservable(Expression it);

	/**
	 * @return A {@link Set} of {@link Expression expressions} to be observed  - set members are either {@link FeatureAccessExpression} or {@link ReferenceExpressions}.
	 */
	Set<? extends Expression> valuesToObserve(Expression it);

	/**
	 * @return The {@link Method} that's called.
	 */
	Method method(MethodCallExpression it);

	/**
	 * @return Whether the given {@link Expression rhs} can be assigned to a variable/value of the given {@link TypeLiteral},
	 * 	taking into account that the rhs can be an empty {@link ListLiteralExpression} (which is "vaguely-typed").
	 */
	boolean typeCompatible(TypeLiteral leftType, Expression right);

	/**
	 * @return An object representing the fact that something does not have any value to observable.
	 */
	LinkedHashSet<Expression> nothingToObserve();

	/**
	 * @return An object representing the fact that something has to observe the given {@link Expression value expression}.
	 */
	LinkedHashSet<Expression> observeSingleton(Expression it);

	boolean isLValue(Expression it);

}
