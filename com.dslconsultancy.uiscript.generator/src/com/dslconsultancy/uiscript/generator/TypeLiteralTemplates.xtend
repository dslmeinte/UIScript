package com.dslconsultancy.uiscript.generator

import com.dslconsultancy.uiscript.types.BuiltinTypeLiteral
import com.dslconsultancy.uiscript.types.BuiltinTypes
import com.dslconsultancy.uiscript.types.DefinedTypeLiteral
import com.dslconsultancy.uiscript.types.ListTypeLiteral
import com.dslconsultancy.uiscript.types.TypeLiteral

class TypeLiteralTemplates {

	def CharSequence typeAsTs(TypeLiteral it) {
		switch it {
			BuiltinTypeLiteral: builtin.builtinAsTs
			DefinedTypeLiteral: type.name
			ListTypeLiteral: '''«itemType.typeAsTs»[]'''
			default: '''any // ERROR: no mapping to TS implemented for type literal of type «eClass.name»'''
		}
	}

	private def builtinAsTs(BuiltinTypes it) {
		switch it {
			case STRING: "string"
			case BOOLEAN: "boolean"
			default: '''any // ERROR: no mapping to TS implemented for built-in type «name()»'''
		}
	}

}
