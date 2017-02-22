package com.dslconsultancy.uiscript.xtext.validation

import com.dslconsultancy.uiscript.core.StatementBlock
import com.dslconsultancy.uiscript.expressions.FeatureAccessExpression
import com.dslconsultancy.uiscript.expressions.ReferenceExpression
import com.dslconsultancy.uiscript.extensions.ExpressionExtensions
import com.dslconsultancy.uiscript.extensions.TypeCalculator
import com.dslconsultancy.uiscript.extensions.TypeExtensions
import com.dslconsultancy.uiscript.statements.AssignmentOperator
import com.dslconsultancy.uiscript.statements.AssignmentOrExpressionStatement
import com.dslconsultancy.uiscript.statements.IfStatement
import com.dslconsultancy.uiscript.statements.ListRemoveStatement
import com.dslconsultancy.uiscript.statements.StatementsPackage
import com.dslconsultancy.uiscript.statements.UnsetStatement
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton
import org.eclipse.xtext.validation.Check

@Singleton
class StatementValidator extends ValidatorSupport {

	@Inject extension TypeCalculator
	@Inject extension TypeExtensions
	@Inject extension ExpressionExtensions

	@Inject extension XtextUtil

	val statementsPackage = StatementsPackage.eINSTANCE


	@Check
	def void warn_for_empty_statement_block(StatementBlock it) {
		if( statements.empty ) {
			warning("empty statement block is useless", this)
		}
	}

	@Check
	def void check_lhs_is_a_valid_l_value(AssignmentOrExpressionStatement it) {
		if( rhs !== null && !lhs.isLValue ) {
			error("lhs must be a valid l-value", statementsPackage.assignmentOrExpressionStatement_Lhs)
		}
	}

	@Check
	def void check_lhs_is_list_typed_if_add_operator_is_used(AssignmentOrExpressionStatement it) {
		if( rhs !== null && operator == AssignmentOperator.ADD ) {
			val type = lhs.type
			if( !(type.listTyped || type.numericallyTyped || type.stringTyped) ) {
				error("lhs must have a sensible addition if you are using the += operator", statementsPackage.assignmentOrExpressionStatement_Lhs)
			}
		}
	}

	@Check
	def void check_lhs_is_type_compatible_with_rhs(AssignmentOrExpressionStatement it) {
		if( rhs !== null ) {
			if( switch operator {
					case ASSIGN:	!lhs.type.isAssignableFrom(rhs.type)
					case ADD:		lhs.type.listTyped && !lhs.type.listItemType.isAssignableFrom(rhs.type)
					default:		throw new IllegalArgumentException("cannot handle AssignmentOperator " + operator.name())
				} )
			{
				error('''lhs must be type-compatible with rhs: «lhs.type.toLiteral» (l) vs. «rhs.type.toLiteral» (r)'''.toString, statementsPackage.assignmentOrExpressionStatement_Rhs)
			}
		}
	}

	@Check
	def void check_lhs_is_nullable(UnsetStatement it) {
		switch lhs {
			FeatureAccessExpression:	{
				if( !(lhs as FeatureAccessExpression).feature.optional ) {
					error("feature to unset must be optional", statementsPackage.unsetStatement_Lhs)
				}
			}
			ReferenceExpression:		{
				val t = (lhs as ReferenceExpression).type
				if( !(t.stringTyped || t.structureTyped) ) {
					error("value to unset must be a string or a structure", statementsPackage.unsetStatement_Lhs)
				}
			}
			default:
				error("value to unset must be a valid l-value", statementsPackage.unsetStatement_Lhs)
		}
	}

	@Check
	def void check_condition_is_a_Boolean_expression(IfStatement it) {
		if( !condition.type.booleanTyped ) {
			error("condition of an if-statement must be boolean-typed", statementsPackage.ifStatement_Condition)
		}
	}

	@Check
	def void check_list_remove_statements(ListRemoveStatement it) {
		if( listExpr.type.listTyped ) {
			if( !listExpr.type.listItemType.structureTyped ) {
				error('''list expression must yield a structure-typed list (instead of a «listExpr.type.listItemType.toLiteral»)'''.toString, statementsPackage.listRemoveStatement_ListExpr)
			}
		} else {
			error('''list expression must yield a list (instead of a «listExpr.type.toLiteral»)'''.toString, statementsPackage.listRemoveStatement_ListExpr)
		}

		if( feature !== null && !feature.type.isAssignableFrom(valueExpr.type) ) {
			error('''value expression is not type-compatible with feature type: «feature.type.toLiteral» (f) vs. «valueExpr.type.toLiteral» (v)'''.toString, statementsPackage.listRemoveStatement_ValueExpr)
		}
	}

}
