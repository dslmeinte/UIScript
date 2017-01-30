package com.dslconsultancy.uiscript.services

import com.dslconsultancy.uiscript.types.TypeExtensions
import com.dslconsultancy.uiscript.types.TypeLiteral
import com.google.inject.Inject
import com.google.inject.Singleton

@Singleton
class ServiceExtensionsImpl implements ServiceExtensions {

	@Inject extension TypeExtensions

	override isCorrectlyTypedOutput(TypeLiteral it) {
		switch it {
			case structureTyped: 							true
			case listTyped && listItemType.structureTyped:	true
			default:										false
		}
	}

	override effectiveOutputType(TypeLiteral it) {
		switch it {
			case structureTyped:							structure
			case listTyped && listItemType.structureTyped:	listItemType.structure
			default:										null
		}
	}

}
