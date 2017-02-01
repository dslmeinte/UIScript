package com.dslconsultancy.uiscript.xtext.validation

import com.dslconsultancy.uiscript.core.AbstractValueDeclaration
import com.dslconsultancy.uiscript.core.CorePackage
import com.dslconsultancy.uiscript.core.DefinedViewable
import com.dslconsultancy.uiscript.core.ValueDeclaration
import com.dslconsultancy.uiscript.extensions.ExpressionExtensions
import com.dslconsultancy.uiscript.extensions.StructuralExtensions
import com.dslconsultancy.uiscript.extensions.TypeCalculator
import com.dslconsultancy.uiscript.extensions.TypeExtensions
import com.dslconsultancy.uiscript.extensions.ViewableExtensions
import com.dslconsultancy.uiscript.structural.UiModule
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton
import org.eclipse.xtext.validation.Check

@Singleton
class StructuralValidator extends ValidatorSupport {

	@Inject extension TypeCalculator
	@Inject extension TypeExtensions
	@Inject extension StructuralExtensions
	@Inject extension ViewableExtensions
	@Inject extension ExpressionExtensions

	@Inject extension XtextUtil

	val corePackage = CorePackage.eINSTANCE


	@Check
	def void check_at_least_one_screen(UiModule it) {
		if( firstScreen === null ) {
			error("UI module must have at least one screen", this)
		}
	}

	@Check
	def void warn_if_body_has_no_elements(DefinedViewable it) {
		if( elements.size == 0 ) {
			warning( (if(screen) "screen" else "component") + " is useless without elements", corePackage.named_Name )
		}
	}

	@Check
	def void check_well_definedness_of(ValueDeclaration it) {
		switch valueSpecificationType {
			case INITIALIZATION: {
				if( declaredType === null && valueExpr === null ) {
					error("variable declaration must have either a declared type, a defined initialisation value (or both)", this)
				}
			}
			case INVARIANT: {
				if( valueExpr === null ) {
					error("derived value must have a declared expression", this)
				} else {
					if( !valueExpr.isObservable ) {
						error("derived value must have an observable expression", this)
					}
				}
			}
		}
	}

	@Check
	def void check_declared_type_is_compatible_with_initialisation_value(AbstractValueDeclaration it) {
		if( valueExpr !== null && declaredType !== null ) {
			val initType = valueExpr.type
			if( !declaredType.typeCompatible(valueExpr) ) {
				error(
					'''declared type («declaredType.toLiteral») must be compatible with type («initType.toLiteral») of value'''.toString,
					corePackage.abstractValueDeclaration_DeclaredType
				)
			}
		}
	}

}
