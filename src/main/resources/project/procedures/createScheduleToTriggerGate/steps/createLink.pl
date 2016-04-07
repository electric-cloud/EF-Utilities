#
#  Copyright 2016 Electric Cloud, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

$[/plugins[EC-Admin]project/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMSg) = InvokeCommander("",
  'setProperty', "/myPipelineStageRuntime/ec_summary/$[stage] Schedule $[date] $[time]",
  {
		value =>  '<html><a href="/commander/link/editSchedule/projects/BoA Testing/schedules/$[stage]_$[/myPipelineRuntime]">Definition</a></html>'
   });

$[/plugins[EC-Admin]project/scripts/perlLibJSON]


