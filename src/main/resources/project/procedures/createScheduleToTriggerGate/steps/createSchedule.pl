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

$[/myProject/scripts/perlHeaderJSON]

my $tz='$[timeZone]';

# convert some common TZ abbreviation into what we accept
if    ($tz =~ /P[SD]T/i) { $tz='America/Los_Angeles' ;}
elsif ($tz =~ /M[SD]T/i) { $tz='America/Denver'; }
elsif ($tz =~ /C[SD]T/i) { $tz='America/Dallas'; }
elsif ($tz =~ /E[SD]T/i) { $tz='America/New_York'; }
elsif ($tz =~ /UTC/i)    { $tz='Other/UTC'; }

my ($ok, $json, $errCode, $errMsg) = InvokeCommander("",
  'createSchedule', "$[/myPipelineRuntime/projectName]", "$[stage]_$[/myPipelineRuntime]", {
    'beginDate'     => "$[date]",
    'startTime'     => "$[time]",
    'timeZone'      => $tz,
    'procedureName' => "/plugins/EF-Utilities/project/procedures/triggerPipelineGateOnSchedule",
    'misfirePolicy' => "runOnce",
    actualParameter => [
        {actualParameterName => 'stageName',     value => "$[stage]"},
        {actualParameterName => 'taskName',      value => "$[gate]"},
        {actualParameterName => 'action',        value => "approve"},
        {actualParameterName => 'evidence',      value => "$[evidence]"},
        {actualParameterName => 'flowRuntimeId', value => "$[/myPipelineRuntime/flowRuntimeId]"}
    ]
  });


$[/myProject/scripts/perlLibJSON]
