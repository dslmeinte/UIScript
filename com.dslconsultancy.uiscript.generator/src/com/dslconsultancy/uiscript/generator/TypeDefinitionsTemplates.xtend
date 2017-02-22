package com.dslconsultancy.uiscript.generator

import com.dslconsultancy.uiscript.types.Enumeration
import com.dslconsultancy.uiscript.types.EnumerationLiteral
import com.dslconsultancy.uiscript.types.Feature
import com.dslconsultancy.uiscript.types.Structure
import com.google.inject.Inject

class TypeDefinitionsTemplates {

	@Inject extension TypeLiteralTemplates

	def dispatch asTs(Enumeration it) {
		'''
		export enum «name» {
			«FOR literal : literals SEPARATOR ", "»«literal.asTsEnumLiteral»«ENDFOR»
		}
		'''
	}

	private def asTsEnumLiteral(EnumerationLiteral it)
		'''«name» /* «displayName» */'''



	def dispatch asTs(Structure it) {
		'''
		export class «name» {
			«FOR feature : features»
				«feature.asFieldDeclaration»
			«ENDFOR»
		}
		'''
	}

	private def asFieldDeclaration(Feature<?> it)
		'''@observable «name»«IF optional»?«ENDIF»: «type.typeAsTs»;'''

}
