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
# Version 1.0.1 (April 26, 2016)
#-------------------------------------------------------------------------
use strict;
use ElectricCommander;
use XML::XPath;

my $ec = ElectricCommander->new();
$ec->abortOnError(0);

# Utility function to trim the string
#
sub trim {
	my $s = shift;
	$s =~ s/^\s+|\s+$//g;
	return $s;
}

# Utility function to get property value
#
sub getPropertyValue {
	my ($ec, $propertyName) = @_;
	return $ec->getProperty($propertyName)->findvalue("//value")->value();
}

my $envList = trim("$[EnvironmentList]");

#Check to see EnvironmentList is passed in
if ( $envList ne '' ) {
    print "Environment list: $envList\n";
	
	foreach my $environment (split /,/, $envList) {
        $environment = trim($environment);
        $environment =~ /\/projects\/(.+)\/environments\/(.+)/;
        my ($envProjectName, $envName) = (trim($1), trim($2));

        if($envProjectName eq '' or $envName eq '') {
            printf "Skipping incorrect environment path: '$environment'\n";
        }

        print "Tearing down environment: '$envName' in project: '$envProjectName'\n";
        $ec->tearDown(
            {
                environmentName => $envName,
                projectName => $envProjectName
            }
        );
    }

	exit 0;
}

# Collect all the jobId for the currentJob or jobId's for the current pipelineRun.
# The for each jobId check whether the propertySheet 'ProvisionedResources' exists.
# If it exists then check whether the 'environmentName' and 'environmentProjectName'
# property exists. If the environmentName, environmentProjectName properties exist then
# we should call the tearDown

# Check to see whether the scripts running in the context of pipeline or job
#
my $myEnvs;
my $flowRuntimeId = getPropertyValue($ec, '/myPipelineRuntime/id');

if ( $flowRuntimeId ne '' ) {
    print "Pipeline flowruntime id $flowRuntimeId\n";

	#Get the stage name
	my $stageName = getPropertyValue($ec, '/myStage/name');

 	print "Inside the pipeline use case  $flowRuntimeId $stageName\n";
	$myEnvs = $ec->getProvisionedEnvironments(
		{
			flowRuntimeId => $flowRuntimeId,
			stageName     => $stageName
		}
	);
} else {
	my $myJobId = getPropertyValue($ec, '/myJob/id');
	print "Inside the jobId $myJobId\n";

	#If the procedure is running outside the context of a pipeline
	$myEnvs = $ec->getProvisionedEnvironments( { jobId => $myJobId } );
}

my $envsDebug = $myEnvs->findvalue("//value")->value();
print "Before processing environments response: '$envsDebug'\n";

# For each of the dynamicEnvironments that are spun up, we will
# call tearDown
#
foreach my $myEnv ( $myEnvs->findnodes("//environment") ) {
	my $envName = $myEnv->findvalue("environmentName")->string_value;
	my $envProjectName = $myEnv->findvalue("projectName")->string_value;

	# Check to make sure envName and envProjectName is not empty
	if ( $envName ne '' and $envProjectName ne '' ) {
                # If the plugin is run in the context of a Pipeline do not create the jobStep
                if ( $flowRuntimeId ne '' )
                {
                      print "Tearing down environment: '$envName' in project: '$envProjectName'\n";
                      
                      #Call the tearDown API
                      $ec->tearDown({environmentName => $envName, projectName => $envProjectName});
                }
                else {
                      print "In the context of job. Creating a job step that tearDown environment\n";

		              # Create a Job step. This is more for visibility in the UI
		              $ec->createJobStep(
		                  {
				                jobStepName => "Decommissioning Environment $envName",
				                command => "ectool tearDown --environmentName $envName --projectName $envProjectName"
		                  }
		              );
                }

		#Check the Error msg
		my $msg = $ec->getError();
		if ( $msg ne "" ) {
		      print "Error from Commander after tearDown call :\n$msg\n";
		}
	} else {
		print  "Skipping teardown as the required information is not available\n";
	}
}
