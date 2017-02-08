package com.dslconsultancy.uiscript.extensions.impl

import com.dslconsultancy.uiscript.core.Expression
import com.dslconsultancy.uiscript.core.IteratorVariable
import com.dslconsultancy.uiscript.core.Method
import com.dslconsultancy.uiscript.core.Parameter
import com.dslconsultancy.uiscript.core.Referable
import com.dslconsultancy.uiscript.core.Value
import com.dslconsultancy.uiscript.expressions.AdditiveExpression
import com.dslconsultancy.uiscript.expressions.AdditiveOperators
import com.dslconsultancy.uiscript.expressions.ArithmeticBinaryOperatorExpression
import com.dslconsultancy.uiscript.expressions.BooleanBinaryOperatorExpression
import com.dslconsultancy.uiscript.expressions.BooleanLiteralExpression
import com.dslconsultancy.uiscript.expressions.BuiltinFunctionExpression
import com.dslconsultancy.uiscript.expressions.ComparisonExpression
import com.dslconsultancy.uiscript.expressions.DateExpression
import com.dslconsultancy.uiscript.expressions.DecisionExpression
import com.dslconsultancy.uiscript.expressions.EnumerationLiteralExpression
import com.dslconsultancy.uiscript.expressions.FeatureAccessExpression
import com.dslconsultancy.uiscript.expressions.IntegerLiteralExpression
import com.dslconsultancy.uiscript.expressions.ListLiteralExpression
import com.dslconsultancy.uiscript.expressions.MultiplicativeExpression
import com.dslconsultancy.uiscript.expressions.MultiplicativeOperators
import com.dslconsultancy.uiscript.expressions.NotExpression
import com.dslconsultancy.uiscript.expressions.NumberLiteralExpression
import com.dslconsultancy.uiscript.expressions.ReferenceExpression
import com.dslconsultancy.uiscript.expressions.SelectionExpression
import com.dslconsultancy.uiscript.expressions.StringLiteralExpression
import com.dslconsultancy.uiscript.expressions.StructureCreationExpression
import com.dslconsultancy.uiscript.expressions.TernaryExpression
import com.dslconsultancy.uiscript.expressions.aux.CallbackErrorResponseExpression
import com.dslconsultancy.uiscript.expressions.aux.CallbackExpression
import com.dslconsultancy.uiscript.expressions.aux.CallbackResponseExpression
import com.dslconsultancy.uiscript.expressions.aux.MethodCallExpression
import com.dslconsultancy.uiscript.expressions.aux.ServiceCallExpression
import com.dslconsultancy.uiscript.extensions.ExpressionExtensions
import com.dslconsultancy.uiscript.extensions.MethodExtensions
import com.dslconsultancy.uiscript.extensions.StatementExtensions
import com.dslconsultancy.uiscript.extensions.TypeCalculator
import com.dslconsultancy.uiscript.extensions.TypeExtensions
import com.dslconsultancy.uiscript.types.TypeLiteral
import com.dslconsultancy.uiscript.types.VoidLiteral
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton
import org.eclipse.emf.ecore.EObject

import static com.dslconsultancy.uiscript.types.BuiltinTypes.*

/**
 * This class computes types of {@link Expression expressions} and other
 * UIScript language constructs which can be construed as having an
 * (inferred) type. Types are represented by {@link TypeLiteral type
 * literals}. {@code void} is represented by {@link VoidLiteral}.
 * <p>
 * {@code null} represents the unknown/uncomputable type, usually
 * due to unresolved cross-references while in the context of
 * list types it corresponds to {@code ?}.
 * <p>
 * This class is used for custom validation, scoping for type
 * checking and the generator classes for type calculation.
 * 
 * @author Meinte Boersma
 */
@Singleton
class TypeCalculatorImpl implements TypeCalculator {

	@Inject extension TypeExtensions
	@Inject extension ReferableExtensionsImpl
	@Inject extension ExpressionExtensions
	@Inject extension StatementExtensions
	@Inject extension MethodExtensions

	@Inject extension XtextUtil


	/*
	 * +-------------+
	 * | expressions |
	 * +-------------+
	 * 
	 * Each method has an explicit return type to ensure we get
	 * an error as this mechanism breaks (by a dispatch function
	 * returning something else, causing the dispatcher to have
	 * Object as return type) + ensuring that it works in the
	 * face of recursion.
	 */

	override TypeLiteral type(Expression it) {
		if( it === null ) {
			System.err.println("WARNING	type calculation invoked on null; stacktrace:")
			new RuntimeException().printStackTrace(System.err)
			return null
		}
		try {
			type_
		} catch( IllegalArgumentException e ) {
			if( e.message.startsWith("Unhandled") ) {
				System.err.println('''WARNING	type calculation not complete for Expression of sub type «eClass.name»; stracktrace:''')
				e.printStackTrace(System.err)
			}
			return null
		}
	}

	def private dispatch type_(TernaryExpression it)				{ thenExpr.type }

	def private dispatch type_(BooleanBinaryOperatorExpression it)	{ BOOLEAN.createBuiltinTypeLiteral }
	def private dispatch type_(ComparisonExpression it)				{ BOOLEAN.createBuiltinTypeLiteral }

	def private dispatch type_(ArithmeticBinaryOperatorExpression it) {
		if( leftOperand.type.integerTyped && rightOperand.type.integerTyped && !division ) {
			INTEGER.createBuiltinTypeLiteral
		} else if( addition && leftOperand.type.textuallyTyped ) {
			STRING.createBuiltinTypeLiteral
		} else {
			NUMBER.createBuiltinTypeLiteral
		}
	}

	def private dispatch isDivision(AdditiveExpression it)			{ false }
	def private dispatch isDivision(MultiplicativeExpression it)	{ operator == MultiplicativeOperators.DIV }

	def private dispatch isAddition(AdditiveExpression it)			{ operator == AdditiveOperators.PLUS }
	def private dispatch isAddition(MultiplicativeExpression it)	{ false }

	def private dispatch type_(NotExpression it)					{ BOOLEAN.createBuiltinTypeLiteral }

	def private dispatch type_(FeatureAccessExpression it) {
		if( feature.eIsProxy ) null else feature.type
			// check for proxies to prevent scope provision from failing through an AssertionError about cyclic resolution
	}

	def private dispatch type_(StringLiteralExpression it)			{ STRING.createBuiltinTypeLiteral }
	def private dispatch type_(BooleanLiteralExpression it)			{ BOOLEAN.createBuiltinTypeLiteral }
	def private dispatch type_(IntegerLiteralExpression it)			{ INTEGER.createBuiltinTypeLiteral }
	def private dispatch type_(NumberLiteralExpression it)			{ NUMBER.createBuiltinTypeLiteral }
	def private dispatch type_(EnumerationLiteralExpression it)		{ enumeration.createDefinedTypeLiteral }

	def private dispatch type_(ListLiteralExpression it) {
		createListTypeLiteral(
			if( members.size == 0 ) {
				null
			} else {
				members.head.type
			}
		)
	}

	def private dispatch type_(CallbackResponseExpression it) {
		val interfaceCall = containerHaving(typeof(ServiceCallExpression))
		if( interfaceCall === null ) {
			unhandled
		} else {
			if( it == interfaceCall.getInput ) {
				// 'response' is used as the parameter to an interface call, so it's type is determined by the "outer" call:
				val outerCall = interfaceCall.eContainer.containerHaving(typeof(ServiceCallExpression))
				if( outerCall === null ) {
					unhandled
				} else {
					outerCall.getService.outputType
				}
			} else {
				interfaceCall.getService.outputType
			}
		}
	}

	def private dispatch type_(CallbackExpression it)				{ createCallbackLiteral }
	def private dispatch type_(CallbackErrorResponseExpression it)	{ createCallbackErrorResponseLiteral }
	def private dispatch type_(ServiceCallExpression it)			{ getService.outputType }
	def private dispatch type_(StructureCreationExpression it)		{ structure.createDefinedTypeLiteral }

	def private dispatch type_(ReferenceExpression it) {
		return if( ref === null || ref.eIsProxy ) null else ref.refType
	}

	def private dispatch type_(DateExpression it)					{ DATE.createBuiltinTypeLiteral }
	def private dispatch type_(BuiltinFunctionExpression it) {
		switch function {
			case COPY_OF:	argument.type
			case IS_SET:	BOOLEAN.createBuiltinTypeLiteral
			case TO_MILLIS:	NUMBER.createBuiltinTypeLiteral
			case ROUND:		INTEGER.createBuiltinTypeLiteral
			case CONFIRM:	BOOLEAN.createBuiltinTypeLiteral
			case IS_VALID:	BOOLEAN.createBuiltinTypeLiteral
			case ID:		STRING.createBuiltinTypeLiteral
			default:		null
		}
	}

	def private dispatch type_(SelectionExpression it) {
		null
	}

	def private dispatch type_(MethodCallExpression it)			{ method.refType }

	def private dispatch type_(DecisionExpression it) {
		if( cases.empty ) {
			defaultValueExpr?.type
		} else {
			cases.head.valueExpr.type
		}
	}


	/*
	 * +---------------------+
	 * | referable instances |
	 * +---------------------+
	 */

	def private TypeLiteral refType(Referable it) {
		switch it {
			Value:			if( declaration.declaredType === null ) { declaration.valueExpr?.type_ } else { declaration.declaredType }	// (returns null in case of parse/validation error)
			Parameter:		it.type
			IteratorVariable:	null	// FIXME
			Method:			it.returnType
			default:		{
								logProblem('''encountered «IF eIsProxy»unresolved proxy of «ENDIF»«eClass.name» in dispatch to TypeCalculator#refType'''.toString)
								null
							}
		}
	}

	override TypeLiteral returnType(Method it) {
		val statements = definition.statementBlock.statements
		if( !statements.empty && statements.last.hasResultValue ) {
			statements.last.resultType
			// FIXME  this computation doesn't deal with a recursive chain of method calls for which no type can inferred
			// TODO   detect recursive type computation and report suitably (but how to propagate to an error?!)
		} else {
			createVoidLiteral
		}
	}


	/*
	 * +------------------+
	 * | helper functions |
	 * +------------------+
	 */

	def private unhandled(EObject it) {
		println("WARNING\tdon't know how to compute type for instance of " + ^class.simpleName + " (returning Void)")
		createVoidLiteral
	}

}
