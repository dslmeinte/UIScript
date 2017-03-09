package com.dslconsultancy.uiscript.xtext.tests

import com.dslconsultancy.uiscript.components.ComponentsPackage
import com.dslconsultancy.uiscript.core.CorePackage
import com.dslconsultancy.uiscript.expressions.ExpressionsPackage
import com.dslconsultancy.uiscript.expressions.aux.AuxPackage
import com.dslconsultancy.uiscript.services.ServicesPackage
import com.dslconsultancy.uiscript.statements.StatementsPackage
import com.dslconsultancy.uiscript.structural.StructuralPackage
import com.dslconsultancy.uiscript.structural.UiModule
import com.dslconsultancy.uiscript.types.TypesPackage
import com.google.inject.Inject
import java.io.File
import org.apache.commons.io.FileUtils
import org.eclipse.emf.ecore.EPackage
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(UIScriptInjectorProvider)
class UIScriptParsingTest {

	@Inject
	ParseHelper<UiModule> parseHelper

	new() {
		val registry = EPackage.Registry.INSTANCE
		#[
			CorePackage.eINSTANCE,
			TypesPackage.eINSTANCE,
			ServicesPackage.eINSTANCE,
			ExpressionsPackage.eINSTANCE,
			AuxPackage.eINSTANCE,
			ComponentsPackage.eINSTANCE,
			StatementsPackage.eINSTANCE,
			StructuralPackage.eINSTANCE
		].forEach[registry.put(nsURI, it)]
	}

	@Test
	def void loadModel() {
		val file = FileUtils.readFileToString(new File("../uiscript-examples/model/todo-app.uiscript"))
		val result = parseHelper.parse(file)
		Assert.assertNotNull(result)
		println(result.eResource.errors.map[toString])
		Assert.assertTrue(result.eResource.errors.isEmpty)
	}

}
