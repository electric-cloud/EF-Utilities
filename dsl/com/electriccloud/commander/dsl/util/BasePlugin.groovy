package com.electriccloud.commander.dsl.util

import groovy.io.FileType
import org.codehaus.groovy.control.CompilerConfiguration
import com.electriccloud.commander.dsl.DslDelegatingScript

abstract class BasePlugin extends DslDelegatingScript {

    def stepPicker (String pickerLabel, String pluginKey, String procedureName, String category, String description  = '') {
		property "/server/ec_customEditors/pickerStep/$pickerLabel",
			value:
				"""<step>
						<project>/plugins/$pluginKey/project</project>
						<procedure>$procedureName</procedure>
						<category>$category</category>
						<description>$description</description>
					</step>
				""".stripIndent()
	} 

	def setupCustomEditorData(String pluginName) {
		getProcedures(pluginName).each { proc ->
			getFormalParameters (pluginName, procedureName: proc.procedureName).each { param ->
				property 'ec_customEditorData', procedureName: proc.procedureName, {
				
				  property 'parameters', {
				
					property param.formalParameterName, {
					  formType = 'standard'
					  if ('checkbox'.equals(param.type)) {
						checkedValue = 'true'
						initiallyChecked = '0'
						uncheckedValue = 'false'
					  }
					}
				  }
				}
			}
		}
	}
	
	def loadProcedures(String pluginDir, String pluginKey, String pluginName) {
	
		// Loop over the sub-directories in the procedures directory
		// and evaluate procedures if a procedure.dsl file exists
		
		File procsDir = new File(pluginDir, 'dsl/procedures')
		procsDir.eachDir { 
			
			it.eachFile FileType.FILES, {
				if (it.name == 'procedure.dsl') {
					loadProcedure(pluginDir, pluginKey, pluginName, it.absolutePath)
				}
			}
		}
		
		// plugin boiler-plate
		setupCustomEditorData(pluginName)
	}
	
	def loadProcedure(String pluginDir, String pluginKey, String pluginName, String dslFile) {
		evalInlineDsl(dslFile, [pluginKey: pluginKey, pluginName: pluginName, pluginDir: pluginDir])
	}
	
	//Helper function to load another dsl script and evaluate it in-context
	def evalInlineDsl(String dslFile, Map bindingMap) {
		CompilerConfiguration cc = new CompilerConfiguration();
		cc.setScriptBaseClass(DelegatingScript.class.getName());
		GroovyShell sh = new GroovyShell(this.class.classLoader, bindingMap? new Binding(bindingMap) : new Binding(), cc);
		DelegatingScript script = (DelegatingScript)sh.parse(new File(dslFile))
		script.setDelegate(this);
		script.run();
	}
}