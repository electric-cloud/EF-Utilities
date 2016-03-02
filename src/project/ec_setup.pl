# Data that drives the create step picker registration for this plugin.
my %createSnapshot = ( 
  label       => "EF-Utilities - createSnapshot", 
  procedure   => "createSnapshot", 
  description => "create an environment snapshot", 
  category    => "Deploy" 
);

@::createStepPickerSteps = (\%createSnapshot);
