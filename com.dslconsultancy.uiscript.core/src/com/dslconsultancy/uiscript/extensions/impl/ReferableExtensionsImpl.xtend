package com.dslconsultancy.uiscript.extensions.impl

import com.dslconsultancy.uiscript.core.AbstractValueDeclaration
import com.dslconsultancy.uiscript.core.Value
import com.dslconsultancy.uiscript.core.ValueDeclaration
import com.dslconsultancy.uiscript.core.ValueSpecificationTypes
import com.dslconsultancy.uiscript.elements.ListElement
import com.dslconsultancy.uiscript.extensions.ReferableExtensions
import com.dslconsultancy.uiscript.extensions.TypeCalculator
import com.dslconsultancy.uiscript.extensions.TypeExtensions
import com.dslconsultancy.uiscript.statements.LocalValueDeclarationStatement
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton
import com.dslconsultancy.uiscript.core.IteratorVariable

@Singleton
class ReferableExtensionsImpl implements ReferableExtensions {

	@Inject extension TypeCalculator
	@Inject extension TypeExtensions

	@Inject extension XtextUtil


	override declaration(Value it) {
		eContainer.checkedCast(typeof(AbstractValueDeclaration))
	}

	/**
	 * @return The {@link ListElement} defining the given {@link ListVariable}.
	 */
	def private definingElement(IteratorVariable it) {
		eContainer.checkedCast(typeof(ListElement))
	}

	override <T> ifIndexVarThenElse(IteratorVariable it, (ListElement) => T indexFunc, (ListElement) => T valueFunc) {
		val listElement = definingElement

		if( it == listElement.indexVariable ) {
			indexFunc.apply(listElement)
		} else {
			valueFunc.apply(listElement)
		}
	}


	override isVariable(Value it) {
		switch d: it.declaration {
			ValueDeclaration:				d.valueSpecificationType == ValueSpecificationTypes.INITIALIZATION
			LocalValueDeclarationStatement:	false
			default:						throw new IllegalArgumentException("cannot handle Value of sub type " + ^class.simpleName)
		}
	}

	override valueVariableType(ListElement it) {
		return listExpression.type.listItemType
	}

}
