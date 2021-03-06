package com.dslconsultancy.uiscript.extensions;

import com.dslconsultancy.uiscript.core.Expression;
import com.dslconsultancy.uiscript.core.Method;
import com.dslconsultancy.uiscript.extensions.impl.TypeCalculatorImpl;
import com.dslconsultancy.uiscript.types.TypeLiteral;
import com.google.inject.ImplementedBy;

@ImplementedBy(TypeCalculatorImpl.class)
public interface TypeCalculator {

	TypeLiteral type(Expression it);
	TypeLiteral returnType(Method it);

}
