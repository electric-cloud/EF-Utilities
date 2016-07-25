	procedure 'Decommission Environments', {
		description = 'Decommission dynamic environments provisioned from pipeline, applications process or procedure'
		timeLimitUnits = 'minutes'

		exposeToPlugin = '1'
		
		property 'stepPicker', {
			label = 'Flow Utilities - Decommission Environments'
		}
		
		
		formalParameter 'EnvironmentList', defaultValue: null, {
		  description = 'Provide comma separated list of environments to tear down, in a form of \'/projects/[Project Name]/environments/[Environment Name]\'.'
		  expansionDeferred = '0'
		  required = '0'
		  type = 'entry'
		}

		step 'Tear Down Environments', {
		  description = 'This step will allow users to create a process step easily using the new utility procedure which will tearDown all the dynamically created environments. '
		  command = new File(pluginDir + "/dsl/procedures/decommissionEnvironments/steps/tearDownEnvironments.pl").text
		  errorHandling = 'failProcedure'
		  exclusiveMode = 'none'
		  postProcessor = 'postp'
		  releaseMode = 'none'
		  shell = 'ec-perl'
		  timeLimitUnits = 'minutes'
		}
  }
  
  stepPicker ('Flow Utilities - Decommission Environments', 
			pluginKey,
			'Decommission Environments', 
			'Deploy',
			'Decommission dynamic environments provisioned from pipeline, applications process or procedure')


