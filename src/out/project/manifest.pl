@files = (
	['//project/propertySheet/property[propertyName="ec_setup"]/value', 'ec_setup.pl'],
	['//project/procedure[procedureName="createScheduleToTriggerGate"]/step[stepName="Create Schedule"]/command', 'procedures/createScheduleToTriggerGate/steps/Create Schedule.pl'],
	['//project/procedure[procedureName="createScheduleToTriggerGate"]/step[stepName="Create Link"]/command', 'procedures/createScheduleToTriggerGate/steps/Create Link.sh'],
	['//project/procedure[procedureName="createSnapshot"]/step[stepName="snapshot"]/command', 'procedures/createSnapshot/steps/snapshot.pl'],
	['//project/procedure[procedureName="triggerPipelineGateOnSchedule"]/step[stepName="Trigger"]/command', 'procedures/triggerPipelineGateOnSchedule/steps/Trigger.sh'],
	['//project/procedure[procedureName="triggerPipelineGateOnSchedule"]/step[stepName="Delete Schedule"]/command', 'procedures/triggerPipelineGateOnSchedule/steps/Delete Schedule.sh'],
);
