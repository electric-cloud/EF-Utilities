# promote/demote action
if ($promoteAction eq 'promote') {
    my @objTypes = ('resources', 'workspaces');
    foreach my $type (@objTypes) {
           $batch->createAclEntry('user', "project: $pluginName",
                 {
                    systemObjectName => $type,
                    readPrivilege => 'allow',
                    modifyPrivilege => 'inherit',
                    executePrivilege => 'allow',
                    changePermissionsPrivilege => 'inherit'
                 }
                );
        }
    @objTypes = ('projects');
    foreach my $type (@objTypes) {
         $batch->createAclEntry('user', "project: $pluginName",
                 {
                    systemObjectName => $type,
                    readPrivilege => 'allow',
                    modifyPrivilege => 'allow',
                    executePrivilege => 'allow',
                    changePermissionsPrivilege => 'inherit'
                 }
                );
        }
}

# Data that drives the create step picker registration for this plugin.
my %createScheduleToTriggerGate = ( 
  label       => "EF-Utilities - createScheduleToTriggerGate", 
  procedure   => "createScheduleToTriggerGate", 
  description => "Create a schedule that trigger a gate at a particular time and date", 
  category    => "Deploy" 
);

my %createSnapshot = ( 
  label       => "EF-Utilities - createSnapshot", 
  procedure   => "createSnapshot", 
  description => "create an environment snapshot", 
  category    => "Deploy" 
);

@::createStepPickerSteps = (\%createScheduleToTriggerGate, \%createSnapshot);
