@files = (
	['//project/propertySheet/property[propertyName="ec_setup"]/value', 'ec_setup.pl'],
	['//project/procedure[procedureName="createScheduleToTriggerGate"]/step[stepName="createSchedule"]/command', 'procedures/createScheduleToTriggerGate/steps/createSchedule.pl'],
	['//project/procedure[procedureName="createScheduleToTriggerGate"]/step[stepName="createLink"]/command', 'procedures/createScheduleToTriggerGate/steps/createLink.sh'],
	['//project/procedure[procedureName="createScheduleToTriggerGate"]/step[stepName="addPermission"]/command', 'procedures/createScheduleToTriggerGate/steps/addPermission.pl'],
	['//project/procedure[procedureName="createSnapshot"]/step[stepName="snapshot"]/command', 'procedures/createSnapshot/steps/snapshot.pl'],
	['//project/procedure[procedureName="triggerPipelineGateOnSchedule"]/step[stepName="Trigger"]/command', 'procedures/triggerPipelineGateOnSchedule/steps/Trigger.pl'],
	['//project/procedure[procedureName="triggerPipelineGateOnSchedule"]/step[stepName="Delete Schedule"]/command', 'procedures/triggerPipelineGateOnSchedule/steps/Delete Schedule.sh'],
);
