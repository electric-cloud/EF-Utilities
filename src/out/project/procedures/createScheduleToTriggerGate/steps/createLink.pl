$[/myProject/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMSg) = InvokeCommander("",
  'setProperty', "/myPipelineStageRuntime/ec_summary/$[stage] Schedule $[date] $[time]",
  {
		value =>  '<html><a href="/commander/link/editSchedule/projects/$[/myPipelineRuntime/projectName]/schedules/$[stage]_$[/myPipelineRuntime]">Definition</a></html>'
   });

$[/myProject/scripts/perlLibJSON]

