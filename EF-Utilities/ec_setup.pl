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



$commander->setProperty("/projects/$pluginName/procedures/NoOpArtifact/ec_customEditorData/nameIdentifier", "artifact");
$commander->setProperty("/projects/$pluginName/procedures/NoOpArtifact/ec_customEditorData/versionIdentifier", "version");


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

$batch->deleteProperty("/server/ec_customEditors/pickerStep/Flow Utilities - Decommission Environments");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Flow Utilities - Create Snapshot");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Flow Utilities - Create Schedule To Trigger Gate");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/CD Utilities - Decommission Environments");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/CD Utilities - Create Snapshot");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/CD Utilities - Create Schedule To Trigger Gate");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/CD Utilities - Seed environment inventory");

# Data that drives the create step picker registration for this plugin.
my %decommissionEnvironments = (
	label       => "CD Utilities - Decommission Environments",
	procedure   => "Decommission Environments",
	description => "Decommission dynamic environments provisioned from pipeline, applications process or procedure",
    category    => "Deploy"
);

#my %createScheduleToTriggerGate = (
#  label       => "Flow Utilities - Create Schedule To Trigger Gate",
#  procedure   => "createScheduleToTriggerGate",
#  description => "Create a schedule that triggers a gate at a particular date and time",
#  category    => "Deploy"
#);

my %createSnapshot = (
    label       => "CD Utilities - Create Snapshot",
    procedure   => "Create Snapshot",
    description => "Create an environment snapshot",
    category    => "Deploy"
);

my %seedEnvironemnt = (
    label       => "CD Utilities - Seed environment inventory",
    procedure   => "Seed environment inventory",
    description => "Seed environment inventory",
    category    => "Deploy"
);

@::createStepPickerSteps = (
    \%decommissionEnvironments,
    \%createSnapshot,
    \%seedEnvironemnt
);

