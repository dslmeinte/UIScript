package com.dslconsultancy.uiscript.extensions;

import com.dslconsultancy.uiscript.extensions.impl.ServiceExtensionsImpl;
import com.dslconsultancy.uiscript.types.Structure;
import com.dslconsultancy.uiscript.types.TypeLiteral;
import com.google.inject.ImplementedBy;

@ImplementedBy(ServiceExtensionsImpl.class)
public interface ServiceExtensions {

	boolean isCorrectlyTypedOutput(TypeLiteral it);

	Structure effectiveOutputType(TypeLiteral it);

}
