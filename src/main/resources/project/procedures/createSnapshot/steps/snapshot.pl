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
# required parameters
#
my $proj    = "$[projName]";
my $app     = "$[appName]";
my $snap    = "$[snapName]";
#
# optional parameters
#
my $force          = "$[force]";
my $env            = "$[envName]";
my $envProj        = "$[envProjName]";
my $compVersions   = "$[compVersions]"; # ec_comp1-version=1.1 ec_comp2-version=1.5

# delete a snapshot with the same name if force mode is on
if (($force eq "true") || ($force eq "1")) {
	my ($ok) = InvokeCommander("IgnoreError", 'getSnapshot', $proj, $app, $snap);
    if ($ok) {
     	printf("Deleting snapshot $snap\n");
    	$ec->deleteSnapshot($proj, $app, $snap);
    }
}

# capture optional arguments
my %optionalArgs;
if ($env) {
    $optionalArgs{environmentName} = $env;
}
if ($envProj) {
    $optionalArgs{environmentProjectName} = $envProj;
}
if ($compVersions) {
    printf("compVersions: ".$compVersions."\n");
    my @versions = split / /, $compVersions;

    foreach my $n (@versions) {
      my ($firstValue, $secondValue) = $n =~ m/(.*?)=(.*)/s;
      collectNameValuePairs(\%optionalArgs, 'componentVersion', 'componentVersionName',
                            'value', $firstValue, $secondValue);
    }
}

# create snapshot
$ec->createSnapshot($proj, $app, $snap, {%optionalArgs});
printf("Created snapshot $snap\n");


sub collectNameValuePairs {
    my ($optional, $key, $first, $second, $firstValue, $secondValue) = @_;
    $optional->{$key} = [] unless exists($optional->{$key});
    push @{$optional->{$key}}, {$first => $firstValue,
                                    $second => $secondValue};
}

$[/myProject/scripts/perlLibJSON]

