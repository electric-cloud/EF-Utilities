$[/plugins[EC-Admin]project/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMsg) = InvokeCommander("",
  'createSchedule', "$[/myProject/projectName]", "$[/myPipelineRuntime]", {
    'beginDate' => "$[date]",
    'startTime' => "$[time]",
    'procedureName' => "triggerPipelineGateOnSchedule",
    'misfirePolicy' => "runOnce",
    actualParameter => [
        {actualParameterName => 'stageName', value => "$[stage]"},
        {actualParameterName => 'taskName', value => "$[task]"},
        {actualParameterName => 'gateType', value => "PRE"},
        {actualParameterName => 'action', value => "approve"},
        {actualParameterName => 'evidence', value => "$[evidence]"},
        {actualParameterName => 'flowRuntimeId', value => "$[/myPipelineRuntime/flowRuntimeId]"}
    ]
  });
  

$[/plugins[EC-Admin]project/scripts/perlLibJSON]

