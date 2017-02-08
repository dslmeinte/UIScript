package com.dslconsultancy.uiscript.extensions.impl

import com.dslconsultancy.uiscript.core.AbstractValueDeclaration
import com.dslconsultancy.uiscript.core.Value
import com.dslconsultancy.uiscript.core.ValueDeclaration
import com.dslconsultancy.uiscript.core.ValueSpecificationTypes
import com.dslconsultancy.uiscript.extensions.ReferableExtensions
import com.dslconsultancy.uiscript.statements.LocalValueDeclarationStatement
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import com.google.inject.Singleton

@Singleton
class ReferableExtensionsImpl implements ReferableExtensions {

	@Inject extension XtextUtil


	override declaration(Value it) {
		eContainer.checkedCast(typeof(AbstractValueDeclaration))
	}

	override isVariable(Value it) {
		switch d: it.declaration {
			ValueDeclaration:				d.valueSpecificationType == ValueSpecificationTypes.INITIALIZATION
			LocalValueDeclarationStatement:	false
			default:						throw new IllegalArgumentException("cannot handle Value of sub type " + ^class.simpleName)
		}
	}

}
