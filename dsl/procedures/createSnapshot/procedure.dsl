  procedure 'createSnapshot', {
  
	description = 'Create an environment snapshot'
    jobNameTemplate = 'EF-Utilities:$[/myProcedure/procedureName]_$[/increment /server/ec_counters/EF-Utilties/jobCounter]'
    timeLimitUnits = 'minutes'

	exposeToPlugin = '1'
	
    formalParameter 'appName', defaultValue: '$[/myApplication/applicationName]', {
      description = 'Name of the application'
      expansionDeferred = '0'
      required = '1'
      type = 'entry'
    }

    formalParameter 'envName', defaultValue: '$[/myEnvironment/environmentName]', {
      description = ''
      expansionDeferred = '0'
      required = '0'
      type = 'entry'
    }

    formalParameter 'force', defaultValue: 'false', {
      description = ''
      expansionDeferred = '0'
      required = '0'
      type = 'checkbox'
    }

    formalParameter 'projName', defaultValue: '$[/myParent/projectName]', {
      description = 'Name of the project'
      expansionDeferred = '0'
      required = '1'
      type = 'entry'
    }

    formalParameter 'snapName', defaultValue: '', {
      description = 'Name of the snapshot to create'
      expansionDeferred = '0'
      required = '0'
      type = 'entry'
    }

    step 'snapshot', {
      command =  new File(pluginDir + "/dsl/procedures/createSnapshot/steps/snapshot.pl").text
      errorHandling = 'failProcedure'
      exclusiveMode = 'none'
      releaseMode = 'none'
      shell = 'ec-perl'
      timeLimitUnits = 'minutes'
    }

  }
  
  stepPicker ('Flow Utilities - Create Snapshot', 
			pluginKey,
			'createSnapshot', 
			'Deploy', 
			'Create an environment snapshot')

