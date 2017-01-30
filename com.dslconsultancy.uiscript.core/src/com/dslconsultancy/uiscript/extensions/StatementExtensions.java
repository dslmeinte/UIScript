package com.dslconsultancy.uiscript.extensions;

import java.util.Set;

import com.dslconsultancy.uiscript.core.Expression;
import com.dslconsultancy.uiscript.core.Method;
import com.dslconsultancy.uiscript.core.Statement;
import com.dslconsultancy.uiscript.core.StatementBlock;
import com.dslconsultancy.uiscript.core.Value;
import com.dslconsultancy.uiscript.extensions.impl.StatementExtensionsImpl;
import com.dslconsultancy.uiscript.statements.AssignmentOrExpressionStatement;
import com.dslconsultancy.uiscript.types.TypeLiteral;
import com.google.inject.ImplementedBy;

@ImplementedBy(StatementExtensionsImpl.class)
public interface StatementExtensions {

	/**
	 * @return The locally-defined {@link Value values} preceding this {@link Statement} in its {@link StatementBlock}.
	 */
	Iterable<Value> precedingLocalValues(Statement it);

	/**
	 * @return Whether this {@link AssignmentOrExpressionStatement} is (actually) an assignment.
	 */
	boolean isAssignment(AssignmentOrExpressionStatement it);

	/**
	 * @return Whether this {@link AssignmentOrExpressionStatement} is a (lone) expression.
	 */
	boolean isExpression(AssignmentOrExpressionStatement it);

	/**
	 * @return Whether this {@link Statement} has a (non-void) result value.
	 * (This is relevant for determining whether a {@link Method} is a function or a procedure.)
	 */
	boolean hasResultValue(Statement it);

	/**
	 * @return The result type of this {@link Statement}.
	 */
	TypeLiteral resultType(Statement it);

	/**
	 * @return A set of {@link Expression expressions} which are observed by the given {@link Statement}.
	 */
	Set<? extends Expression> valuesToObserve(Statement it);

	/**
	 * @return Whether this {@link Statement} can be considered to be a pure (i.e., side-effect free) functional statement.
	 */
	boolean isPure(Statement it);

}
