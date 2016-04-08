$[/myProject/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMsg) = InvokeCommander("",
  'completeManualTask', "$[flowRuntimeId]", "$[stageName]", "$[taskName]",
  {
    gateType => 'PRE',
    actualParameter => [
  	  {actualParameterName => 'action', value => "$[action]"},
  	  {actualParameterName => 'evidence', value => "$[evidence]"}
    ]
  });


$[/myProject/scripts/perlLibJSON]

