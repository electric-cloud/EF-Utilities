$[/plugins[EC-Admin]project/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMSg) = InvokeCommander("",
  'setProperty', "/myPipelineStageRuntime/ec_summary/$[stage] Schedule",
  {
		value =>  '<html><pre>$[date] - $[time] UTC
<a href="/commander/link/editSchedule/projects/BoA Testing/schedules/$[/myPipelineRuntime]">Definition</a></pre></html>'
   });

$[/plugins[EC-Admin]project/scripts/perlLibJSON]

