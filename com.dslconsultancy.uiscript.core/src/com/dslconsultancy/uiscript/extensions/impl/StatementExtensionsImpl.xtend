package com.dslconsultancy.uiscript.extensions.impl

import com.dslconsultancy.uiscript.extensions.ExpressionExtensions
import com.dslconsultancy.uiscript.extensions.StatementExtensions
import com.dslconsultancy.uiscript.extensions.TypeCalculator
import com.dslconsultancy.uiscript.extensions.TypeExtensions
import com.dslconsultancy.uiscript.types.VoidLiteral
import com.dslconsultancy.uiscript.uidsl.AssignmentOrExpressionStatement
import com.dslconsultancy.uiscript.uidsl.LocalValueDeclarationStatement
import com.dslconsultancy.uiscript.uidsl.Statement
import com.dslconsultancy.uiscript.uidsl.StatementBlock
import com.dslconsultancy.uiscript.uidsl.UnsetStatement
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton

@Singleton
class StatementExtensionsImpl implements StatementExtensions {

	@Inject extension TypeCalculator
	@Inject extension TypeExtensions
	@Inject extension ExpressionExtensions

	@Inject extension XtextUtil


	override precedingLocalValues(Statement it) {
		val statements = eContainer.checkedCast(typeof(StatementBlock)).statements
		val index = statements.indexOf(it)
			// indices are 0-based so taking an `index` # of elements excludes the current Statement
		statements.take(index).filter(typeof(LocalValueDeclarationStatement)).map[value]
	}


	override isAssignment(AssignmentOrExpressionStatement it) {
		rhs != null
	}


	override isExpression(AssignmentOrExpressionStatement it) {
		rhs == null
	}


	override hasResultValue(Statement it) {
		switch resultType {
			VoidLiteral:	false
			UnsetStatement: false
			default:		true
		}
	}


	override resultType(Statement it) {
		switch it {
			AssignmentOrExpressionStatement case assignment:	createVoidLiteral
			AssignmentOrExpressionStatement case expression:	it.lhs.type
			default:											createVoidLiteral
		}
	}


	override valuesToObserve(Statement it) {
		switch it {
			AssignmentOrExpressionStatement case expression:	it.lhs.valuesToObserve
			LocalValueDeclarationStatement:						it.valueExpr.valuesToObserve
			default:											nothingToObserve
		}
	}


	override isPure(Statement it) {
		switch it {
			AssignmentOrExpressionStatement:	it.expression
			LocalValueDeclarationStatement:		true
			default:							false
		}
	}

}
