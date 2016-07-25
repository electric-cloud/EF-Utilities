import groovy.transform.BaseScript
import com.electriccloud.commander.dsl.util.BasePlugin

//noinspection GroovyUnusedAssignment
@BaseScript BasePlugin baseScript

// Variables available for use in DSL code
def pluginName = args.pluginName
def pluginKey = getProject("/plugins/$pluginName/project").pluginKey
def pluginDir = getProperty("/server/settings/pluginsDirectory").value + "/" + pluginName

project pluginName, {
	
	description = 'A set of common procedures used in Deploy project'
	ec_visibility = 'pickListOnly'
	
	property 'scripts', {
    
		perlHeaderJSON = new File(pluginDir + "/dsl/properties/scripts/perlHeaderJSON.txt").text
		perlLibJSON = new File(pluginDir + "/dsl/properties/scripts/perlLibJSON.txt").text
	}
	
	loadProcedures(pluginDir, pluginKey, pluginName)
}

//Grant permissions to the plugin project
def objTypes = ['resources', 'workspaces', 'projects'];

objTypes.each { type ->
		aclEntry principalType: 'user', 
			 principalName: "project: $pluginName",
			 systemObjectName: type,
             objectType: 'systemObject',
			 readPrivilege: 'allow', 
			 modifyPrivilege: 'allow',
			 executePrivilege: 'allow',
			 changePermissionsPrivilege: 'allow'
	}
	

    		
