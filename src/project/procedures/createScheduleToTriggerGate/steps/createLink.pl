$[/plugins[EC-Admin]project/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMSg) = InvokeCommander("",
  'setProperty', "/myPipelineStageRuntime/ec_summary/$[stage] Schedule $[date] $[time]",
  {
		value =>  '<html><a href="/commander/link/editSchedule/projects/BoA Testing/schedules/$[/myPipelineRuntime]">Definition</a></html>'
   });

$[/plugins[EC-Admin]project/scripts/perlLibJSON]

