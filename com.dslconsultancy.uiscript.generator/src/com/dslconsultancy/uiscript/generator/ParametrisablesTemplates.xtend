package com.dslconsultancy.uiscript.generator

import com.dslconsultancy.uiscript.components.ComponentDefinition
import com.dslconsultancy.uiscript.core.MethodDefinition
import com.dslconsultancy.uiscript.core.ValueSpecificationTypes
import com.google.inject.Inject

class ParametrisablesTemplates {

	@Inject extension TypeLiteralTemplates

	def dispatch asTsx(ComponentDefinition it) {
		'''
		export function «name»() {

			class Properties_«name» {
				values: {
					«FOR valueDeclaration : stateDeclarations.filter[valueSpecificationType === ValueSpecificationTypes.INITIALIZATION]»
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

}
