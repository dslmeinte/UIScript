package com.dslconsultancy.uiscript.extensions.impl

import com.dslconsultancy.uiscript.expressions.Expression
import com.dslconsultancy.uiscript.expressions.aux.MethodCallExpression
import com.dslconsultancy.uiscript.extensions.ExpressionExtensions
import com.dslconsultancy.uiscript.extensions.MethodExtensions
import com.dslconsultancy.uiscript.extensions.StatementExtensions
import com.dslconsultancy.uiscript.uidsl.Argument
import com.dslconsultancy.uiscript.uidsl.Method
import com.dslconsultancy.uiscript.uidsl.MethodDefinition
import com.dslconsultancy.uiscript.uidsl.UiModule
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton
import java.util.Set

@Singleton
class MethodExtensionsImpl implements MethodExtensions {

	@Inject extension ExpressionExtensions
	@Inject extension StatementExtensions

	@Inject extension XtextUtil


	override definition(Method it) {
		eContainer.checkedCast(typeof(MethodDefinition))
	}

	override isTopLevel(Method it) {
		definition.eContainer instanceof UiModule
	}

	override isFunction(Method it) {
		val last = definition.statementBlock.statements.last
		if( last == null ) false else last.hasResultValue
	}

	override arguments(MethodCallExpression it) {
		argumentList.arguments as Iterable<Argument>
	}

	override valuesToObserve(MethodCallExpression it) {
		arguments.map[it.valueExpr.valuesToObserve].flatten.toSet as Set<? extends Expression>	// (cast required for Xtend2.2 compatibility)
//			+ method.definition.statementBlock.statements.map[it.valuesToObserve].flatten.toSet
	}

	override isPure(Method it) {
		function && definition.statementBlock.statements.forall[it.isPure]
	}

}
