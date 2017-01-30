package com.dslconsultancy.uiscript.xtext.validation

import com.dslconsultancy.uiscript.core.Argument
import com.dslconsultancy.uiscript.core.Named
import com.dslconsultancy.uiscript.core.Parameter
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.validation.AbstractDeclarativeValidator

abstract class ValidatorSupport extends AbstractDeclarativeValidator {

	def protected isUncapitalized(Named it) {
		Character.isLowerCase(name.charAt(0))
	}

	def protected isCapitalized(Named it) {
		Character.isUpperCase(name.charAt(0))
	}

	def protected void check_parameters_and_arguments_are_1_to_1(
		Iterable<Parameter> parameters, Iterable<Argument> arguments, String callDescription,
		EReference headFeature, EReference argumentsListFeature
	) {
		val unassignedParameters = parameters.filter[ p | arguments.filter[ Argument a | a.parameter == p ].size == 0 ]
		val duplicateAssignees   = parameters.filter[ p | arguments.filter[ Argument a | a.parameter == p ].size > 1 ]
		if( !unassignedParameters.empty ) {
			error(
				"the following parameters were not assigned in " + callDescription + " call: " + unassignedParameters.map[name].join(", "),
				headFeature
			)
		}
		if( !duplicateAssignees.empty ) {
			error(
				"the following parameters were duplicately assigned in " + callDescription + " call: " + duplicateAssignees.map[name].join(", "),
				argumentsListFeature
			)
		}
	}

}
