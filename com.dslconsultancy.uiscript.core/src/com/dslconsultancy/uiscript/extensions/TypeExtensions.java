package com.dslconsultancy.uiscript.extensions;

import java.util.List;

import com.dslconsultancy.uiscript.extensions.impl.TypeExtensionsImpl;
import com.dslconsultancy.uiscript.types.BuiltinTypeLiteral;
import com.dslconsultancy.uiscript.types.BuiltinTypes;
import com.dslconsultancy.uiscript.types.CallbackErrorResponseLiteral;
import com.dslconsultancy.uiscript.types.CallbackLiteral;
import com.dslconsultancy.uiscript.types.TypeDefinition;
import com.dslconsultancy.uiscript.types.DefinedTypeLiteral;
import com.dslconsultancy.uiscript.types.Enumeration;
import com.dslconsultancy.uiscript.types.Feature;
import com.dslconsultancy.uiscript.types.ListTypeLiteral;
import com.dslconsultancy.uiscript.types.Structure;
import com.dslconsultancy.uiscript.types.TypeLiteral;
import com.dslconsultancy.uiscript.types.VoidLiteral;
import com.google.inject.ImplementedBy;

/**
 * @author Meinte Boersma
 */
@ImplementedBy(TypeExtensionsImpl.class)
public interface TypeExtensions {

	boolean isBooleanTyped(TypeLiteral it);

	boolean isStringTyped(TypeLiteral it);

	boolean isTextTyped(TypeLiteral it);

	boolean isIntegerTyped(TypeLiteral it);

	boolean isNumberTyped(TypeLiteral it);

	boolean isDateTyped(TypeLiteral it);

	boolean isPasswordTyped(TypeLiteral it);

	boolean isEmailTyped(TypeLiteral it);

	boolean isSimpleTyped(TypeLiteral it);

	boolean isTextuallyTyped(TypeLiteral it);

	boolean isNumericallyTyped(TypeLiteral it);

	boolean isListTyped(TypeLiteral it);

	boolean isDefinedTyped(TypeLiteral it);

	boolean isStructureTyped(TypeLiteral it);

	boolean isEnumerationTyped(TypeLiteral it);

	boolean isCallback(TypeLiteral it);

	boolean isVaguelyTyped(TypeLiteral it);

	boolean isVoidTyped(TypeLiteral it);

	TypeLiteral listItemType(TypeLiteral it);

	Structure structure(TypeLiteral it);

	Enumeration enumeration(TypeLiteral it);

	List<Feature<TypeLiteral>> features(TypeLiteral it);

	Iterable<Feature<TypeLiteral>> simpleTypedFeatures(Structure it);

	Iterable<Feature<TypeLiteral>> linkedTypedFeatures(Structure it);

	Iterable<Feature<TypeLiteral>> listTypedFeatures(TypeDefinition it);

	Iterable<Feature<TypeLiteral>> structureTypedFeatures(TypeDefinition it);

	Iterable<Feature<TypeLiteral>> builtinTypedFeatures(Structure it);

	BuiltinTypeLiteral createBuiltinTypeLiteral(BuiltinTypes builtinType);

	DefinedTypeLiteral createDefinedTypeLiteral(TypeDefinition it);

	ListTypeLiteral createListTypeLiteral(TypeLiteral itemType);

	CallbackLiteral createCallbackLiteral();

	CallbackErrorResponseLiteral createCallbackErrorResponseLiteral();

	VoidLiteral createVoidLiteral();

	List<Feature<TypeLiteral>> featuresOf(TypeDefinition it);

	boolean isAssignableFrom(TypeLiteral target, TypeLiteral source);

	String toLiteral(TypeLiteral it);

}
