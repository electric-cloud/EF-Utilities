	procedure 'createScheduleToTriggerGate', {
  
		description = '[Experimental] Create a schedule that trigger a gate at a particular time and date'
		jobNameTemplate = 'EF-Utilities:$[/myProcedure/procedureName]_$[/increment /server/ec_counters/EF-Utilties/jobCounter]'
		timeLimitUnits = 'seconds'
		
		exposeToPlugin = '1'

		property 'stepPicker', {
			label = "Flow Utilities - Create Schedule To Trigger Gate"
			category = 'Deploy'
			description = 'Create a schedule that triggers a gate at a particular date and time'
		}

		formalParameter 'date', {
		  description = 'The date at which to trigger the gate. Format is "YYYY-MM-dd".'
		  expansionDeferred = '0'
		  required = '1'
		}

		formalParameter 'evidence', defaultValue: '', {
		  description = 'Text to set on the approval of the gate.'
		  expansionDeferred = '0'
		  required = '1'
		  type = 'entry'
		}

		formalParameter 'gate', defaultValue: '', {
		  description = 'The name of the gate to trigger.'
		  expansionDeferred = '0'
		  required = '1'
		  type = 'entry'
		}

		formalParameter 'stage', defaultValue: '', {
		  description = 'The name of the stage where the gate is located. Typically the next stage.'
		  expansionDeferred = '0'
		  required = '1'
		  type = 'entry'
		}

		formalParameter 'time', defaultValue: null, {
		  description = 'The time at which to trigger the gate. Format is "HH:mm" (24 hours).'
		  expansionDeferred = '0'
		  required = '1'
		}

		formalParameter 'timeZone', defaultValue: '', {
		  description = 'Timezone to express the date and time. Default is the server timezone. The format is the standard continent/city like "America/New_York". For convenience some abbreviations are converted automatically like "PST" to "America/Los_Angeles".'
		  expansionDeferred = '0'
		  required = '0'
		  type = 'entry'
		}

		step 'createSchedule', {
		  command = new File(pluginDir + "/dsl/procedures/createScheduleToTriggerGate/steps/createSchedule.pl").text
		  errorHandling = 'failProcedure'
		  exclusiveMode = 'none'
		  releaseMode = 'none'
		  shell = 'ec-perl'
		  timeLimitUnits = 'minutes'
		}

		step 'createLink', {
		  command = new File(pluginDir + "/dsl/procedures/createScheduleToTriggerGate/steps/createLink.pl").text
		  errorHandling = 'failProcedure'
		  exclusiveMode = 'none'
		  releaseMode = 'none'
		  shell = 'ec-perl'
		  timeLimitUnits = 'minutes'
		}

		step 'addPermission', {
		  command = new File(pluginDir + "/dsl/procedures/createScheduleToTriggerGate/steps/addPermission.pl").text
		  errorHandling = 'failProcedure'
		  exclusiveMode = 'none'
		  releaseMode = 'none'
		  shell = 'ec-perl'
		  timeLimitUnits = 'minutes'
		}
	}