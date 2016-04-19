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

#
# Parameters
#
my $proj  = "$[projName]";
my $app   = "$[appName]";
my $snap  = "$[snapName]";
my $env   = "$[envName]";
my $force = "$[force]";

# delete a snapshot with the same name if force mode is on
if (($force eq "true") || ($force eq "1")) {
	my ($ok) = InvokeCommander("IgnoreError", 'getSnapshot', $proj, $app, $snap);
    if ($ok) {
    	printf("Deleting snapshot $snap\n");
    	$ec->deleteSnapshot($proj, $app, $snap);
    }
}
$ec->createSnapshot($proj, $app, $snap);
printf("Created snapshot $snap\n");

$[/myProject/scripts/perlLibJSON]

