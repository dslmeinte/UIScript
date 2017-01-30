package com.dslconsultancy.uiscript.extensions.impl

import com.dslconsultancy.uiscript.core.DefinedViewable
import com.dslconsultancy.uiscript.core.Element
import com.dslconsultancy.uiscript.core.MethodDefinition
import com.dslconsultancy.uiscript.core.Value
import com.dslconsultancy.uiscript.core.Viewable
import com.dslconsultancy.uiscript.core.ViewableTypes
import com.dslconsultancy.uiscript.extensions.ViewableExtensions
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
