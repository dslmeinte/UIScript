package com.dslconsultancy.uiscript.extensions.impl

import com.dslconsultancy.uiscript.extensions.ViewableExtensions
import com.dslconsultancy.uiscript.uidsl.DefinedViewable
import com.dslconsultancy.uiscript.uidsl.Element
import com.dslconsultancy.uiscript.uidsl.MethodDefinition
import com.dslconsultancy.uiscript.uidsl.Value
import com.dslconsultancy.uiscript.uidsl.Viewable
import com.dslconsultancy.uiscript.uidsl.ViewableTypes
import com.google.inject.Singleton

@Singleton
class ViewableExtensionsImpl implements ViewableExtensions {

	override isScreen(Viewable it) {
		type == ViewableTypes.SCREEN
	}

	override isComponent(Viewable it) {
		type == ViewableTypes.COMPONENT
	}

	override values(DefinedViewable it) {
		if( valuesBlock == null ) {
			<Value>emptyList
		} else {
			valuesBlock.declarations.map[value]
		}
	}

	override localMethodDefinitions(DefinedViewable it) {
		definitions.filter(typeof(MethodDefinition))
	}

	override elements(DefinedViewable it) {
		definitions.filter(typeof(Element))
	}

}
