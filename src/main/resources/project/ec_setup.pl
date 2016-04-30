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

# promote/demote action
if ( $promoteAction ne '' ) {
	my @objTypes = ( 'projects', 'resources', 'workspaces' );
	my $query    = $commander->newBatch();

	my @reqs     = map {
		$query->getAclEntry(
			'user',
			"project: $pluginName",
			{ systemObjectName => $_ }
		  )
	} @objTypes;

	push @reqs, $query->getProperty('/server/ec_hooks/promote');
	$query->submit();

	foreach my $type (@objTypes) {
		if ( $query->findvalue( shift @reqs, 'code' ) ne 'NoSuchAclEntry' ) {
			$batch->deleteAclEntry(
				'user',
				"project: $pluginName",
				{ systemObjectName => $type }
			);
		}
	}

	if ( $promoteAction eq 'promote' ) {
		@objTypes = ( 'resources', 'workspaces' );
		foreach my $type (@objTypes) {
			$batch->createAclEntry(
				'user',
				"project: $pluginName",
				{
					systemObjectName           => $type,
					readPrivilege              => 'allow',
					modifyPrivilege            => 'allow',
					executePrivilege           => 'allow',
					changePermissionsPrivilege => 'allow'
				}
			);
		}

		@objTypes = ('projects');
		foreach my $type (@objTypes) {
			$batch->createAclEntry(
				'user',
				"project: $pluginName",
				{
					systemObjectName           => $type,
					readPrivilege              => 'allow',
					modifyPrivilege            => 'allow',
					executePrivilege           => 'allow',
					changePermissionsPrivilege => 'allow'
				}
			);
		}
	}
}

# Data that drives the create step picker registration for this plugin.
my %decommissionEnvironments = (
	label     => "EF-Utilities - Decommission Environments",
	procedure => "Decommission Environments",
	description => "Decommission dynamic environments provisioned from pipeline, applications process or procedure",
	category => "Deploy"
);

my %createScheduleToTriggerGate = (
  label       => "EF-Utilities - createScheduleToTriggerGate",
  procedure   => "createScheduleToTriggerGate",
  description => "Create a schedule that trigger a gate at a particular time and date",
  category    => "Deploy"
);

#my %createSnapshot = (
#  label       => "EF-Utilities - createSnapshot",
#  procedure   => "createSnapshot",
#  description => "create an environment snapshot",
#  category    => "Deploy"
#);

@::createStepPickerSteps = ( \%decommissionEnvironments );
