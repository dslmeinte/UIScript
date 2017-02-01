package com.dslconsultancy.uiscript.xtext.validation

import com.dslconsultancy.uiscript.core.CorePackage
import com.dslconsultancy.uiscript.extensions.ServiceExtensions
import com.dslconsultancy.uiscript.services.Service
import com.dslconsultancy.uiscript.services.ServicesPackage
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import org.eclipse.xtext.validation.Check

class ServiceValidator extends ValidatorSupport {

	@Inject extension ServiceExtensions
	@Inject extension XtextUtil

	val servicesPackage = ServicesPackage.eINSTANCE
	val corePackage = CorePackage.eINSTANCE

	@Check
	def void url_ends_in_trailing_slash(Service it) {
		if( !urlPattern.nullOrEmpty && !urlPattern.endsWith("/") ) {
			error("baseURL must end on trailing slash", servicesPackage.service_UrlPattern)
		}
	}

	@Check
	def check_service_name_starts_with_lower_capital(Service it) {
		if( !uncapitalized ) {
			warning( "the name of a service (interface) should start with a lower case character", corePackage.named_Name )
		}
	}

	@Check
	def check_output_type_of_interface(Service it) {
		if( outputType !== null && !outputType.correctlyTypedOutput ) {
			error("output type of an interface must be a structure or a list of structures", servicesPackage.service_OutputType)
		}
	}

	@Check
	def check_non_sensical_definition(Service it) {
		if( inputType === null && outputType === null ) {
			error("interface must have either an input, an output or both", this)
		}
	}

}
