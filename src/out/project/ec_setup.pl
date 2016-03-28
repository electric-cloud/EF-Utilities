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
