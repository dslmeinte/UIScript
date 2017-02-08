package com.dslconsultancy.uiscript.xtext.generator.tsx

import com.dslconsultancy.uiscript.core.DefinedViewable
import com.dslconsultancy.uiscript.core.ManualViewable
import com.dslconsultancy.uiscript.core.MethodDefinition
import com.dslconsultancy.uiscript.core.ValueSpecificationTypes
import com.google.inject.Inject

class ParametrisablesTemplates {

	@Inject extension TypeLiteralTemplates

	def dispatch asTsx(DefinedViewable it) {
		'''
		/** Defined viewable of type «type.literal». */
		export function «name»() {

			class Properties_«name» {
				values: {
					«FOR valueDeclaration : valuesBlock.declarations.filter[valueSpecificationType === ValueSpecificationTypes.INITIALIZATION]»
						«valueDeclaration.value.name»: «valueDeclaration.declaredType.typeAsTs»;
					«ENDFOR»
				};
			}

			@observer
			class View_«name» extends React.Component<any, {}> {
				render() {
					return (<div></div>);
				}
			}

			const values = observable(new Properties_«name»());
			return <View_«name» values={values} />;
		}
		'''
	}


	def dispatch asTsx(MethodDefinition it) {
		'''
		export function «method.name»() {	// defined method
			
		}
		'''
	}


	def dispatch asTsx(ManualViewable it) {
		'''
		export function «name»() {	// manual viewable of type «type.literal»
			
		}
		'''
	}

}
