package com.dslconsultancy.uiscript.xtext.validation

import com.dslconsultancy.uiscript.core.CorePackage
import com.dslconsultancy.uiscript.extensions.TypeExtensions
import com.dslconsultancy.uiscript.structural.UiModule
import com.dslconsultancy.uiscript.types.DefinedTypeLiteral
import com.dslconsultancy.uiscript.types.Enumeration
import com.dslconsultancy.uiscript.types.Feature
import com.dslconsultancy.uiscript.types.ListTypeLiteral
import com.dslconsultancy.uiscript.types.Structure
import com.dslconsultancy.uiscript.types.SyntheticTypeLiteral
import com.dslconsultancy.uiscript.types.TypesPackage
import com.dslconsultancy.uiscript.types.VoidLiteral
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.validation.Check

class TypeValidator extends ValidatorSupport {

	@Inject extension TypeExtensions
	@Inject extension XtextUtil

	val typesPackage = TypesPackage.eINSTANCE
	val corePackage = CorePackage.eINSTANCE

	@Check
	def structure_has_features(Structure it) {
		if( features.size == 0 ) {
			warning("structure is useless without features", this)
		}
	}

	@Check
	def persistent_structure_only_refers_persistents(Feature<?> it) {
		if( (eContainer as Structure).persistent && type.structureTyped ) {
			val reffedStructure = (type as DefinedTypeLiteral).type as Structure
			if( !reffedStructure.persistent ) {
				error("structures (transitively -unchecked) referred to by a persistent structure must be persistent as well", typesPackage.feature_Type)
			}
		}
	}

	@Check
	def enumeration_has_literals(Enumeration it) {
		if( literals.size == 0 ) {
			warning("enumeration is useless without literals", this)
		}
	}

	// TODO  remove when 'id' is not generated in POJOs anymore
	@Check
	def feature_name_is_not_id(Feature<?> it) {
		if( name == "id" ) {
			error( "feature cannot be named 'id' (reserved keyword)", corePackage.named_Name )
		}
	}

	@Check
	def structure_name_starts_with_upper_capital(Structure it) {
		if( !capitalized ) {
			warning( "the name of a structure should start with an upper case character", corePackage.named_Name )
		}
	}

	@Check
	def feature_name_starts_with_lower_capital(Feature<?> it) {
		if( !it.uncapitalized ) {
			warning( "the name of a feature should start with a lower case character", corePackage.named_Name )
		}
	}

	@Check
	def lists_not_directly_nested(ListTypeLiteral it) {
		if( itemType.listTyped ) {
			error( "lists may not be (directly) nested", typesPackage.listTypeLiteral_ItemType )
		}
	}

	@Check
	def synthetic_type_not_used_here(SyntheticTypeLiteral it) {
		if( !voidTyped && EcoreUtil.getRootContainer(it) instanceof UiModule ) {
			error("synthetic callback types can not be used in SimScript-Structure", this)
		}
	}

	@Check
	def void_type_not_used_here(VoidLiteral it) {
		error("the void literal is synthetic and only for internal purposes and may not be used anywhere", this)
	}

}
