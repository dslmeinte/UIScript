package com.dslconsultancy.uiscript.xtext.validation

import org.eclipse.xtext.validation.ComposedChecks

/**
 * Class containing (the implementation of all) the validations for
 * {@code UIScript}.
 * <p>
 * The specification for these validations can be found in the grammar and the
 * implementation functions appear in that same order.
 * 
 * @author Meinte Boersma
 */
@ComposedChecks(validators=#[
	typeof(ElementValidator),
	typeof(ExpressionValidator),
	typeof(ServiceValidator),
	typeof(StatementValidator),
	typeof(StructuralValidator),
	typeof(TypeValidator)
])
class UIScriptValidator extends AbstractUIScriptValidator {}
