$[/plugins[EC-Admin]project/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMsg) = InvokeCommander("",
  'completeManualTask', "$[flowRuntimeId]", "$[stageName]", "$[taskName]",
  {actualParameter => [
  	{actualParameterName => 'action', value => "$[action]"},
  	{actualParameterName => 'evidence', value => "$[evidence]"},
  	{actualParameterName => 'gateType', value => "$[gateType]"},
    ]
  });
  

$[/plugins[EC-Admin]project/scripts/perlLibJSON]

