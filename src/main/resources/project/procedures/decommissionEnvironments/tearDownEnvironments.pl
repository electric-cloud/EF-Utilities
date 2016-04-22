#-------------------------------------------------------------------------
#           Decommission Environment - A new beginning
#
# This procedure will allow users to create a process step easily using
# the new utility procedure which will tearDown all the dynamically
# created environments.
#
# This procedure can work in the context of either Piepline or a Job
# (Process or Procedure).
#
# Copyright (c) 2006-2016 Electric Cloud, Inc.
# All rights reserved
# Version 1.0.0 (April 2, 2014)
#-------------------------------------------------------------------------
use strict;
use ElectricCommander;
use XML::XPath;
use strict;
use Data::Dumper;

# Set to 0 for quit; 1 for informative messages
my $verbose = 0;
my $msg;
my $myPipelineRuntimeId;

my $ec = ElectricCommander->new();

$ec->abortOnError(0);

# Check for the OS Type
my $osIsWindows = $^O =~ /MSWin/;

# Utility function to trim the string
#
sub trim {
	my $s = shift;
	$s =~ s/^\s+|\s+$//g;
	return $s;
}

# Get the 'Environment List' parameter and see whether user has explictly specified
# any dynamic environments to decomission
#
# my $envList = "ENV 1/TEST1, ENV 2/TEST 2";
#
my $envList = $ec->getActualParameter('Environment List', {jobStepId => '$[/myParent/jobStepId]'})->findvalue('//value');

if ( $envList ne "" ) {
	print "Environments are passed in:\n";
	
	my @environments = split( ',', $envList );
	foreach my $environment (@environments) {
		my ( $envName, $envProjectName ) = split( '/', $environment );
		$envName = trim($envName);
		$envProjectName = trim($envProjectName);
		
		print "Environment Name: $envName, Project Name: $envProjectName";
		$ec->tearDown(
			{
				environmentName => $envName,
				projectName => $envProjectName
			}
		);
	}
	
	exit 0;
}

# Overall logic is pretty staright forward
#
# Collect all the jobId for the currentJob or jobId's for the current pipelineRun.
# The for each jobId check whether the propertySheet 'ProvisionedResources' exists.
# If it exists then check whether the 'environmnetName' and 'environmnetProjectName'
# property exists. If the environmentName, environmnetProjectName proerties exist then
# we should call the tearDown

# Check to see whether the scriptis running in the context of pipeline or job
#
my $myEnvs;
my $flowRuntimeId =  $ec->getProperty("/myPipelineRuntime/id")->findvalue("//value")->value();

if ( $flowRuntimeId ne '' ) {
    print "Flowruntime id $flowRuntimeId\n";
	print "Inside the pipeline use case\n";

	#Get the stage name
	my $stageName =
	  $ec->getProperty("/myStage/name")->findvalue("//value")->value();

	$myEnvs = $ec->getProvisionedEnvironments(
		{
			flowRuntimeId => $flowRuntimeId,
			stageName     => $stageName
		}
	);
}
else {
	my $myJobId = $ec->getProperty("/myJob/id")->findvalue("//value")->value();
	print "Inside the jobId $myJobId\n";

	#If the procedure is running outside the context of a pipeline
	$myEnvs = $ec->getProvisionedEnvironments( { jobId => $myJobId } );
}

# For each of the dynamicEnvironmnets that are spun up, we will
# call tearDown
#
foreach my $myEnv ( $myEnvs->findnodes("//environment") ) {
	my $envName = $myEnv->findvalue("environmentName")->string_value;
	my $envProjectName = $myEnv->findvalue("projectName")->string_value;

	# Check to make sure envName and envProjectName is not empty
	if ( $envName ne "" and $envProjectName ne "" ) {
		print "environmentName -> $envName environmentProjectName -> $envProjectName\n";

  #Call the tearDown API
  #$ec->tearDown({environmentName => $envName, projectName => $envProjectName});

		# Create a Job step. This is more for visibility in the UI
		$ec->createJobStep(
			{
				jobStepName => "Decommissioning Environment $envName",
				command => "ectool tearDown --environmentName $envName --projectName $envProjectName"
			}
		);

		#Check the Error msg
		$msg = $ec->getError();
		if ( $msg ne "" ) {
			print "Error from Commander after tearDown call :\n$msg\n";
		}
	}
	else {
		print
		  "Skipping teardown as the required information is not available\n";
	}
}
