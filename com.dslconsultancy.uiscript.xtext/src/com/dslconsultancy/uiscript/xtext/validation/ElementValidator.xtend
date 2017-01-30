package com.dslconsultancy.uiscript.xtext.validation

import com.dslconsultancy.uiscript.core.Argument
import com.dslconsultancy.uiscript.core.CorePackage
import com.dslconsultancy.uiscript.core.Method
import com.dslconsultancy.uiscript.elements.Binding
import com.dslconsultancy.uiscript.elements.BlockElement
import com.dslconsultancy.uiscript.elements.ButtonElement
import com.dslconsultancy.uiscript.elements.ComponentInvocation
import com.dslconsultancy.uiscript.elements.ElementBody
import com.dslconsultancy.uiscript.elements.ElementsPackage
import com.dslconsultancy.uiscript.elements.ImageElement
import com.dslconsultancy.uiscript.elements.InputElement
import com.dslconsultancy.uiscript.elements.ListElement
import com.dslconsultancy.uiscript.elements.StructureOption
import com.dslconsultancy.uiscript.elements.WhenElement
import com.dslconsultancy.uiscript.extensions.ExpressionExtensions
import com.dslconsultancy.uiscript.extensions.MethodExtensions
import com.dslconsultancy.uiscript.extensions.StructuralExtensions
import com.dslconsultancy.uiscript.extensions.TypeCalculator
import com.dslconsultancy.uiscript.extensions.TypeExtensions
import com.dslconsultancy.uiscript.extensions.ViewableExtensions
import com.dslconsultancy.uiscript.types.Structure
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton
import org.eclipse.xtext.validation.Check

@Singleton
class ElementValidator extends ValidatorSupport {

	@Inject extension TypeCalculator
	@Inject extension TypeExtensions
	@Inject extension StructuralExtensions
	@Inject extension ExpressionExtensions
	@Inject extension ViewableExtensions
	@Inject extension MethodExtensions

	@Inject extension XtextUtil

	val corePackage = CorePackage.eINSTANCE
	val elementsPackage = ElementsPackage.eINSTANCE


	@Check
	def void warn_if_body_has_no_elements(ElementBody it) {
		if( elements.size == 0 ) {
			warning("body is useless without elements", elementsPackage.elementBody_Elements)
		}
	}

	@Check
	def void check_component_invocation_invokes_component(ComponentInvocation it) {
		if( viewable.screen ) {
			error("can only invoke components, not screens", corePackage.viewableCallSite_Viewable)
		}
	}

	@Check
	def void check_parameters_and_arguments_are_1_to_1(ComponentInvocation it) {
		check_parameters_and_arguments_are_1_to_1(viewable.parameters, it.arguments, "embedding", corePackage.viewableCallSite_Viewable, corePackage.viewableCallSite_ArgumentList)
	}

	@Check
	def void check_argument_assignment_is_type_compatible(Argument it) {
		if( !parameter.type.isAssignableFrom(valueExpr.type) ) {
			error(
				'''parameter must be type-compatible with value: «parameter.type.toLiteral» (param) vs. «valueExpr.type.toLiteral» (arg)'''.toString,
				corePackage.argument_ValueExpr
			)
		}
	}

	@Check
	def void check_bind_site_is_primitive_typed(Binding it) {
		if( !bindSite.isObservable ) {
			error("the bind site of a binding must be observable", elementsPackage.binding_BindSite)
		}
	}

	@Check
	def void check_button_onClick_is_callback(ButtonElement it) {
		if( !action.type.callback ) {
			error("onClick must be a Callback", elementsPackage.buttonElement_Action)
		}
	}

	@Check
	def void check_block_onClick_is_callback(BlockElement it) {
		if( onClick != null && !onClick.type.callback ) {
			error("onClick must be a Callback", elementsPackage.blockElement_OnClick)
		}
	}

	@Check
	def void check_list_element_works_on_list_expression(ListElement it) {
		if( !listExpression.type.listTyped ) {
			error('''list expression must be list-typed, but is «listExpression.type.toLiteral»'''.toString, elementsPackage.listElement_ListExpression)
		}
	}

	@Check
	def void check_bind_site_of(InputElement it) {	// explicit void return type because otherwise inferred return type is Object
		if( !bindSite.isLValue ) {
			error("the bind site of an input must be a valid l-value", elementsPackage.inputElement_BindSite)
		}
		val type = bindSite.type
		if( !(type.simpleTyped || type.definedTyped) ) {
			error("the bind site of an input must be simple-typed (primitive, built-in), enumeration-typed or structure-typed", elementsPackage.inputElement_BindSite)
		}
		if( type.structureTyped && structureOption == null ) {
			error("structure options (syntax: \"source={ <source-expression> -> <display function> }\") must be present for structure-typed bind site", elementsPackage.inputElement_BindSite)
		}
	}

	@Check
	def void check_options_of(InputElement it) {	// explicit void return type because otherwise inferred return type is Object
		val type = bindSite.type

		if( hint != null ) {
			if( !( type.stringTyped || type.textTyped || type.emailTyped || type.integerTyped || type.numberTyped ) ) {
				warning("hint not supported (yet) for this type of input", elementsPackage.inputElement_Hint)
			}	// (password widget has placeholder but it's shown as *****...)
		}

		if( type.numericallyTyped ) {
			if( minValue != null && !minValue.type.numericallyTyped ) {
				error("min-value must be numerically-typed", elementsPackage.inputElement_MinValue)
			}
			if( maxValue != null && !maxValue.type.numericallyTyped ) {
				error("max-value must be numerically-typed", elementsPackage.inputElement_MaxValue)
			}
		} else {
			if( minValue != null ) {
				error("min-value can only be used with a numerically-typed bind site", elementsPackage.inputElement_MinValue)
			}
			if( maxValue != null ) {
				error("max-value can only be used with a numerically-typed bind site", elementsPackage.inputElement_MaxValue)
			}
		}

		if( radioOption != null ) {
			if( !type.booleanTyped ) {
				error("radio option is only valid for a boolean-typed bind site", elementsPackage.inputElement_RadioOption)
			}
		}

		if( onChange != null ) {
			if( !onChange.type.callback ) {
				error("onChange must be a Callback", elementsPackage.inputElement_OnChange)
			}
			warning("onChange not supported (yet)", elementsPackage.inputElement_OnChange)
		}

		if( onSubmit != null ) {
			if( !onSubmit.type.callback ) {
				error("onSubmit must be a Callback", elementsPackage.inputElement_OnSubmit)
			}
			if( !type.emailTyped ) {
				warning('''onSubmit not supported (yet) on this type («type.toLiteral»)'''.toString, elementsPackage.inputElement_OnSubmit)
			}
		}
	}

	@Check
	def void check_structure_option(StructureOption it) {
		val type = eContainer.checkedCast(typeof(InputElement)).bindSite.type
		if( !type.structureTyped ) {
			error("structure options can only be used with a bind site that is a structure", this)
		} else {
			if( !(sourceExpr.type.listTyped && sourceExpr.type.listItemType.structure == type.structure) ) {
				error('''source expression must be list-typed with structure «type.structure.name» as item type'''.toString, elementsPackage.structureOption_SourceExpr)
			}
			if( !displayFunction.isDisplayComputationFunction(type.structure) ) {
				error("display function-option does not reference a valid display computation function", elementsPackage.structureOption_DisplayFunction)
			}
		}
	}

	def private isDisplayComputationFunction(Method method, Structure structure) {
		val it = method.definition
		val param1 = parameters.head

		   param1 != null
		&& param1.type.structureTyped
		&& param1.type.structure == structure
		&& method.function
		&& method.returnType.stringTyped
	}

	@Check
	def void check_when_condition_is_boolean_typed(WhenElement it) {
		if( !condition.type.booleanTyped ) {
			error("condition of when-element must be boolean-typed", elementsPackage.whenElement_Condition)
		}
	}

	@Check
	def void check_image_arguments(ImageElement it) {
		if( !sourceUrl.type.stringTyped ) {
			error("source of image-element must be string-typed", elementsPackage.imageElement_SourceUrl)
		}
		if( !height.type.integerTyped) {
			error("height of image-element must be integer-typed", elementsPackage.imageElement_Height)
		}
		if( !width.type.integerTyped) {
			error("width of image-element must be integer-typed", elementsPackage.imageElement_Width)
		}
	}

}
