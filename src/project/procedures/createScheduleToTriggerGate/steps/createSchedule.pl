$[/myProject/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMsg) = InvokeCommander("",
  'createSchedule', "$[/myPipelineRuntime/projectName]", "$[stage]_$[/myPipelineRuntime]", {
    'beginDate' => "$[date]",
    'startTime' => "$[time]",
    'procedureName' => "/plugins/EF-Utilities/project/procedures/triggerPipelineGateOnSchedule",
    'misfirePolicy' => "runOnce",
    actualParameter => [
        {actualParameterName => 'stageName', value => "$[stage]"},
        {actualParameterName => 'taskName', value => "$[gate]"},
        {actualParameterName => 'action', value => "approve"},
        {actualParameterName => 'evidence', value => "$[evidence]"},
        {actualParameterName => 'flowRuntimeId', value => "$[/myPipelineRuntime/flowRuntimeId]"}
    ]
  });


$[/pmyProject/scripts/perlLibJSON]

