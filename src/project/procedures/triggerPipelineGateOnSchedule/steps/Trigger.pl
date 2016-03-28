$[/plugins[EC-Admin]project/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMsg) = InvokeCommander("",
  'completeManualTask', "$[flowRuntimeId]", "$[stageName]", "$[taskName]",
  {
    gateType => 'PRE',
    actualParameter => [
  	  {actualParameterName => 'action', value => "$[action]"},
  	  {actualParameterName => 'evidence', value => "$[evidence]"}
    ]
  });
  

$[/plugins[EC-Admin]project/scripts/perlLibJSON]

