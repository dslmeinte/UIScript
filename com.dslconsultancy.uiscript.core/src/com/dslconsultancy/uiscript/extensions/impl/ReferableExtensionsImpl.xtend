package com.dslconsultancy.uiscript.extensions.impl

import com.dslconsultancy.uiscript.extensions.ReferableExtensions
import com.dslconsultancy.uiscript.extensions.TypeCalculator
import com.dslconsultancy.uiscript.extensions.TypeExtensions
import com.dslconsultancy.uiscript.statements.LocalValueDeclarationStatement
import com.dslconsultancy.uiscript.uidsl.AbstractValueDeclaration
import com.dslconsultancy.uiscript.uidsl.ListElement
import com.dslconsultancy.uiscript.uidsl.ListVariable
import com.dslconsultancy.uiscript.uidsl.Value
import com.dslconsultancy.uiscript.uidsl.ValueDeclaration
import com.dslconsultancy.uiscript.uidsl.ValueSpecificationTypes
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton

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
	def private definingElement(ListVariable it) {
		eContainer.checkedCast(typeof(ListElement))
	}

	override <T> ifIndexVarThenElse(ListVariable it, (ListElement) => T indexFunc, (ListElement) => T valueFunc) {
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
