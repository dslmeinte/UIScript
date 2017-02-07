package com.dslconsultancy.uiscript.xtext.generator

import com.dslconsultancy.uiscript.core.DefinedViewable
import com.dslconsultancy.uiscript.core.ManualViewable
import com.dslconsultancy.uiscript.core.MethodDefinition

class ParametrisablesGenerator {

	def dispatch generateTsx(DefinedViewable it) {
		'''
		export function «name»() {	// defined viewable of type «type.literal»
			return (
				<div>
				</div>
			);
		}
		'''
	}

	def dispatch generateTsx(MethodDefinition it) {
		'''
		export function «method.name»() {	// defined method
			
		}
		'''
	}

	def dispatch generateTsx(ManualViewable it) {
		'''
		export function «name»() {	// manual viewable of type «type.literal»
			
		}
		'''
	}

}
