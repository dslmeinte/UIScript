package com.dslconsultancy.uiscript.xtext.validation

import com.dslconsultancy.uiscript.core.Expression
import com.dslconsultancy.uiscript.core.Method
import com.dslconsultancy.uiscript.core.ValueDeclaration
import com.dslconsultancy.uiscript.core.ValueSpecificationTypes
import com.dslconsultancy.uiscript.expressions.AdditiveExpression
import com.dslconsultancy.uiscript.expressions.AdditiveOperators
import com.dslconsultancy.uiscript.expressions.BooleanBinaryOperatorExpression
import com.dslconsultancy.uiscript.expressions.BuiltinFunctionExpression
import com.dslconsultancy.uiscript.expressions.Comparator
import com.dslconsultancy.uiscript.expressions.ComparisonExpression
import com.dslconsultancy.uiscript.expressions.DecisionCase
import com.dslconsultancy.uiscript.expressions.DecisionExpression
import com.dslconsultancy.uiscript.expressions.ExpressionsPackage
import com.dslconsultancy.uiscript.expressions.FeatureAccessExpression
import com.dslconsultancy.uiscript.expressions.FeatureAssignment
import com.dslconsultancy.uiscript.expressions.ListLiteralExpression
import com.dslconsultancy.uiscript.expressions.MultiplicativeExpression
import com.dslconsultancy.uiscript.expressions.NotExpression
import com.dslconsultancy.uiscript.expressions.ReferenceExpression
import com.dslconsultancy.uiscript.expressions.SelectionExpression
import com.dslconsultancy.uiscript.expressions.StructureCreationExpression
import com.dslconsultancy.uiscript.expressions.TernaryExpression
import com.dslconsultancy.uiscript.expressions.aux.AuxPackage
import com.dslconsultancy.uiscript.expressions.aux.CallbackErrorResponseExpression
import com.dslconsultancy.uiscript.expressions.aux.CallbackExpression
import com.dslconsultancy.uiscript.expressions.aux.CallbackResponseExpression
import com.dslconsultancy.uiscript.expressions.aux.MethodCallExpression
import com.dslconsultancy.uiscript.expressions.aux.ServiceCallExpression
import com.dslconsultancy.uiscript.extensions.ExpressionExtensions
import com.dslconsultancy.uiscript.extensions.MethodExtensions
import com.dslconsultancy.uiscript.extensions.StructuralExtensions
import com.dslconsultancy.uiscript.extensions.TypeCalculator
import com.dslconsultancy.uiscript.extensions.TypeExtensions
import com.dslconsultancy.uiscript.statements.AssignmentOrExpressionStatement
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.ValidationMessageAcceptor

import static com.dslconsultancy.uiscript.expressions.BuiltinFunctions.*

@Singleton
class ExpressionValidator extends ValidatorSupport {

	@Inject extension TypeCalculator
	@Inject extension TypeExtensions
	@Inject extension ExpressionExtensions
	@Inject extension MethodExtensions
	@Inject extension StructuralExtensions

	@Inject extension XtextUtil

	val exprPackage = ExpressionsPackage.eINSTANCE
	val exprAuxPackage = AuxPackage.eINSTANCE


	@Check
	def void check_types_of_members_of_ternary_operator(TernaryExpression it) {
		if( !guard.type.booleanTyped ) {
			error("guard of ternary operator must be boolean-typed", exprPackage.ternaryExpression_Guard)
		}
		if( !thenExpr.type.isAssignableFrom(elseExpr.type) ) {
			error(
				'''then and else members of ternary operator must be type-compatible: «thenExpr.type.toLiteral» (then) vs. «elseExpr.type.toLiteral» (else)'''.toString,
				exprPackage.ternaryExpression_ElseExpr
			)
		}
	}

	@Check
	def void check_operands_of_boolean_binary_operators_are_boolean_typed(BooleanBinaryOperatorExpression it) {
		if( !leftOperand.type.booleanTyped ) {
			error("operand of boolean binary operator must be boolean-typed", exprPackage.binaryOperatorExpression_LeftOperand)
		}
		if( !rightOperand.type.booleanTyped ) {
			error("operand of boolean binary operator must be boolean-typed", exprPackage.binaryOperatorExpression_RightOperand)
		}
	}

	@Check
	def void check_types_of_operands_of(ComparisonExpression it) {
		if (comparator == Comparator.IS_IN) {
			if (!rightOperand.type.listTyped) {
				error(
					'the right operand of the isIn comparison should be list-typed',
					exprPackage.binaryOperatorExpression_RightOperand
				)
			} else if (!leftOperand.type.isAssignableFrom(rightOperand.type.listItemType)) {
				error(
					'the left operand of the isIn comparator should be assignable from ' + rightOperand.type.listItemType.toLiteral,
					exprPackage.binaryOperatorExpression_LeftOperand
				)
			}
		} else {
			if( !(leftOperand.type.isAssignableFrom(rightOperand.type)) ) {
				error(
					'''operands must be type-compatible: «leftOperand.type.toLiteral» (l) vs. «rightOperand.type.toLiteral» (r)'''.toString,
					exprPackage.binaryOperatorExpression_LeftOperand
				)
			}
			leftOperand.checkIsComparable(exprPackage.binaryOperatorExpression_LeftOperand)
			rightOperand.checkIsComparable(exprPackage.binaryOperatorExpression_RightOperand)
		}
	}

	def private void checkIsComparable(Expression it, EReference reference) {
		if( !(type.numericallyTyped || type.textuallyTyped || type.enumerationTyped) ) {
			error("operand of comparative expression must be comparably-typed (Integer, Number, String, Text or an enumeration)", eContainer, reference, ValidationMessageAcceptor.INSIGNIFICANT_INDEX)
		}
	}

	@Check
	def void check_type_compatibility_additive_binary_operator(AdditiveExpression it) {
		if( operator == AdditiveOperators.PLUS ) {
			// Note: we check that a concatenation of strings starts with a string, so mapping to JS is easy.
			if( leftOperand.type.numericallyTyped ) {
				rightOperand.checkIsNumerical(exprPackage.binaryOperatorExpression_RightOperand)
			} else if( leftOperand.type.textuallyTyped ) {
				rightOperand.checkIsAddable(exprPackage.binaryOperatorExpression_RightOperand)
			} else {
				leftOperand.checkIsAddable(exprPackage.binaryOperatorExpression_LeftOperand)
				rightOperand.checkIsAddable(exprPackage.binaryOperatorExpression_RightOperand)
			}
		} else {
			leftOperand.checkIsNumerical(exprPackage.binaryOperatorExpression_LeftOperand)
			rightOperand.checkIsNumerical(exprPackage.binaryOperatorExpression_RightOperand)
		}
	}

	@Check
	def void check_type_compatibility_multiplicative_binary_operator(MultiplicativeExpression it) {
		leftOperand.checkIsNumerical(exprPackage.binaryOperatorExpression_LeftOperand)
		rightOperand.checkIsNumerical(exprPackage.binaryOperatorExpression_RightOperand)
	}

	def private void checkIsNumerical(Expression it, EReference reference) {
		if( !type.numericallyTyped ) {
			error("operand of arithmetic expression must be numerically-typed (Integer or Number)", eContainer, reference, ValidationMessageAcceptor.INSIGNIFICANT_INDEX)
		}
	}

	def private void checkIsAddable(Expression it, EReference reference) {
		if( !(type.numericallyTyped || type.textuallyTyped) ) {
			error("operand of additive expression must be addably-typed (Integer, Number, String or Text)", eContainer, reference, ValidationMessageAcceptor.INSIGNIFICANT_INDEX)
		}
	}

	@Check
	def check_not_operand_is_boolean(NotExpression it) {
		if( !operand.type.booleanTyped ) {
			error("operand must be boolean-typed instead of " + operand.type.toLiteral, exprPackage.notExpression_Operand)
		}
	}

	@Check
	def void check_argument_count_matches_parameters(ServiceCallExpression it) {
		if( service.inputType === null && getInput !== null ) {
			error("this interface has no input type, so there is no sense in giving it stuff", exprAuxPackage.serviceCallExpression_Input)
		}
	}

	@Check
	def void check_parameters_and_arguments_are_type_compatible(ServiceCallExpression it) {
		// ASSUMES that if inputType == null, it means the service expected no input (or was a legacy servlet, which was handled above):
		if( service.inputType !== null && !service.inputType.isAssignableFrom(getInput.type) ) {
			error(
				'''input to interface call must be type-compatible with declared input type: «service.inputType.toLiteral» (param) vs. «getInput.type.toLiteral» (arg)'''.toString,
				exprAuxPackage.serviceCallExpression_Input
			)
		}
	}

	@Check
	def void check_interface_call_expression_is_only_used_in_an_asynchronous_context(ServiceCallExpression it) {
		switch eContainer {
			Expression:			error("interface cannot be called inside an expression", this)
			ValueDeclaration:	if( (eContainer as ValueDeclaration).valueSpecificationType != ValueSpecificationTypes.INITIALIZATION ) {
									error("interface can only be called as initialisation of a variable", this)
								}
			AssignmentOrExpressionStatement:
								/* it's OK */ {}
			default:			error("interface can only be called asynchronously (hint: use callback)", this)
		}
	}


	@Check
	def void check_feature_access_operator_invoked_on_something_having_features(FeatureAccessExpression it) {
		val hasFeatures = switch it {
			ReferenceExpression:		true
			FeatureAccessExpression:	true
			SelectionExpression:		true
			default:					false
		}
		if( !hasFeatures ) {
			error("feature access operator ('.') can only be invoked on something having features", exprPackage.featureAccessExpression_Previous)
		}
	}

	@Check
	def void check_argument_of(BuiltinFunctionExpression it) {
		switch function {
			case CONFIRM:	{
				if( !argument.type.textuallyTyped ) {
					error("argument of confirm must be textually-typed", exprPackage.builtinFunctionExpression_Argument)
				}
				warning("use of confirm is quasi-deprecated: use show-modal instead", exprPackage.builtinFunctionExpression_Function)
			}
			case TO_MILLIS: if( !argument.type.dateTyped ) {
								error("argument of toMillis function must be date-typed", exprPackage.builtinFunctionExpression_Argument)
							}
			case ROUND:		if( !argument.type.numberTyped ) {
								error("argument of round function must be number-typed", exprPackage.builtinFunctionExpression_Argument)
							}
			case IS_SET:	if( argument.type.structureTyped ) {
								warning("isSet of a structure is always true (null objects do not quite exist in observable JS space)", exprPackage.builtinFunctionExpression_Argument)
							}
			case IS_VALID:	if( !argument.type.emailTyped ) {
								error("argument of isValid function must be email-typed", exprPackage.builtinFunctionExpression_Argument)
							}
			case ID:		if( !argument.type.structureTyped ) {
								error("argument of id function must be structure-typed", exprPackage.builtinFunctionExpression_Argument)
							}
			default:		{ /* nothing to check */ }
		}
		if( function != SORT && sortFeature !== null ) {
			error("sort feature can only be specified for the sort function", exprPackage.builtinFunctionExpression_SortFeature)
		}
	}

	@Check
	def void check_members_of_a_list_literal_expression_are_type_compatible(ListLiteralExpression it) {
		if( members.size > 1 ) {
			val firstMemberType = members.head.type
			members.drop(1).forEach[
				if( !firstMemberType.isAssignableFrom(it.type) ) {
					it.error("member not type-compatible with first member", this)
				}
			]
		}
	}

	@Check
	def void check_callback_values_may_only_be_used_within_callbacks(CallbackErrorResponseExpression it) {
		if( containerHaving(typeof(CallbackExpression)) === null ) {
			error("callback error response may only be used within a callback", this)
		}
	}

	@Check
	def void check_callback_values_may_only_be_used_within_callbacks(CallbackResponseExpression it) {
		if( containerHaving(typeof(CallbackExpression)) === null ) {
			error("callback response may only be used within a callback", this)
		}
	}

	@Check
	def void check_assignments_and_features_are_1_to_1(StructureCreationExpression it) {
		val duplicateAssignees = structure.features.filter[ f | assignments.filter[ a | a.feature == f ].size > 1 ]
		if( duplicateAssignees.size > 0 ) {
			error(
				"the following features were duplicately assigned in structure creation: " + duplicateAssignees.map[name].join(", "),
				exprPackage.structureCreationExpression_Assignments
			)
		}
	}

	@Check
	def void check_feature_assignment_has_type_compatibility(FeatureAssignment it) {
		if( !feature.type.typeCompatible(valueExpr) ) {
			error(
				'''feature must be type-compatible with assigned value: «feature.type.toLiteral» (f) vs. «valueExpr.type.toLiteral» (v)'''.toString,
				exprPackage.featureAssignment_ValueExpr
			)
		}
	}

	@Check
	def void check_method_call_references_a_method(MethodCallExpression it) {
		if( !(methodRef.ref instanceof Method) ) {
			error("method call must reference a method", exprAuxPackage.methodCallExpression_MethodRef)
		}
	}

	@Check
	def void check_parameters_and_arguments_are_1_to_1(MethodCallExpression it) {
		check_parameters_and_arguments_are_1_to_1(method.definition.parameters, it.arguments, "method", exprAuxPackage.methodCallExpression_MethodRef, exprAuxPackage.methodCallExpression_ArgumentList)
	}

	@Check
	def void check_reference_expression_cannot_reference_a_method(ReferenceExpression it) {
		if( ref instanceof Method && !(eContainer instanceof MethodCallExpression) ) {
			error("method can only be referenced by a method call (use parentheses)", this)
		}
	}

	@Check
	def void check_decision_expression_has_cases_and_valid_default(DecisionExpression it) {
		if( cases.empty ) {
			warning("decision expression is useless without cases", this)
		}
		if( defaultValueExpr !== null && !type.isAssignableFrom(defaultValueExpr.type) ) {
			error('''default value expression is not type-compatible with return type: «type.toLiteral» (r) vs. «defaultValueExpr.type.toLiteral» (v)'''.toString, exprPackage.decisionExpression_DefaultValueExpr)
		}
	}

	@Check
	def void check_types_in_decision_case(DecisionCase it) {
		if( !guardExpr.type.booleanTyped ) {
			error('''guard expression of decision case must be boolean-typed (instead of «guardExpr.type.toLiteral»)'''.toString, exprPackage.decisionCase_GuardExpr)
		}
		val decisionExpr = eContainer.checkedCast(typeof(DecisionExpression))
		if( !decisionExpr.type.isAssignableFrom(valueExpr.type) ) {
			error('''value expression is not type-compatible with return type: «decisionExpr.type.toLiteral» (r) vs. «valueExpr.type.toLiteral» (v)'''.toString, exprPackage.decisionCase_ValueExpr)
		}
	}

}
