package com.dslconsultancy.uiscript.xtext.generator

import com.dslconsultancy.uiscript.generator.UiModuleTemplates
import com.dslconsultancy.uiscript.structural.UiModule
import com.dslconsultancy.uiscript.util.XtextUtil
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

class UIScriptGenerator extends AbstractGenerator {

	@Inject extension XtextUtil
	@Inject extension UiModuleTemplates

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val uiModule = resource.contents.head as UiModule;
		fsa.generateFile('''«resource.fileName».tsx''', uiModule.generateTsxForUiModule)
	}

}
