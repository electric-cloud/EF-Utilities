
project 'EF-Utilities-0.0.0.1', {
  description = ''
  resourceName = ''
  workspaceName = ''

  // Custom properties

  property 'ec_utility_plugin', {
    description = 'This represents that the plugin is a utility plugin'

    // Custom properties

    property 'operations', {
      description = ''

      // Custom properties

      property 'decommissionEnvironments', {
        description = 'Metadata for the decomission Environment procedure'

        // Custom properties

        property 'parameterRefs', {
          propertyType = 'sheet'
        }

        property 'ui_formRefs', {
          description = ''

          // Custom properties
          parameterForm = 'ui_forms/DecomissionEnvironmentForm'
        }
      }
    }
    displayName = 'Utilities'
    hasConfiguration = '0'
  }

  property 'ui_forms', {
    description = 'Property sheet to store custom parameter form defntions'

    // Custom properties
    DecomissionEnvironmentForm = '''<!--

       Copyright 2015 Electric Cloud, Inc.

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

           http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.

        -->
        <editor>
            <formElement>
                <type>entry</type>
                <label>Configuration Name:</label>
                <property>config</property>
                <value></value>
                <required>0</required>
                <documentation>Provide a unique name for the connection, keeping in mind that you may need to create additional connections over time.</documentation>
            </formElement>
        </editor>
      '''
  }

  procedure 'DecomissionEnvironments', {
    description = 'Decommission the environment'
    jobNameTemplate = ''
    resourceName = ''
    timeLimit = ''
    timeLimitUnits = 'minutes'
    workspaceName = ''

    // Custom properties

    property 'ec_customEditorData', {

      // Custom properties

      property 'parameters', {

        // Custom properties

        property 'environmentList', {

          // Custom properties
          formType = 'standard'
        }
      }
    }
    ec_customParameterForm = '''<editor>
            <help>/commander/pages/EC-UTILITY-2.2.3.85167/EC-UTILITY_help?s=Administration&amp;ss=Plugins#DecomissionEnvironment</help>
            <formElement>
                <type>entry</type>
                <label>Environment List</label>
                <property>environmentList</property>
                <required>1</required>
                <documentation>Reference to the property shotcut to get a list of Dynamic environments.</documentation>
            </formElement>
        </editor>'''

    formalParameter 'environmentList', defaultValue: '', {
      description = 'Comma seperated list of environments/projects that needs to be retired. eg: ENV1/DEAFULT, ENV2/TESTPROJ'
      expansionDeferred = '0'
      label = null
      orderIndex = null
      required = '0'
      type = 'entry'
    }

    step 'callTearDown', {
      description = ''
      alwaysRun = '0'
      broadcast = '0'
      command = '''#-------------------------------------------------------------------------
#           Decommission Environment - A new beginning 
#
# This procedure will allow users to create a process step easily using
# the new utility procedure which will tearDown all the dynamically 
# created environments. 
#
# This procedure can work in the context of either Piepline or a Job 
# (Process or Procedure). 
#
# Copyright (c) 2006-2009 Electric Cloud, Inc.
# All rights reserved
# Version 1.0.0 (April 2, 2014)
#-------------------------------------------------------------------------
use strict;
use ElectricCommander;
use XML::XPath;

# Set to 0 for quit; 1 for informative messages
my $verbose = 0;

my @myJobIds;
my $myPipelineRuntimeId;

my $ec = ElectricCommander->new();

$ec->abortOnError(0);

# Check for the OS Type
my $osIsWindows = $^O =~ /MSWin/;


# Utility function to trim the string
#
sub  trim { 
     my $s = shift; 
     $s =~ s/^\\s+|\\s+$//g; 
     return $s 
};

# Get the environmentList parameter and see whether user has explictly specified 
# any dynamic environments to decomission
# 
my $envList = "$[environmentList]";
# my $envList = "ENV 1/TEST1, ENV 2/TEST 2";
if ( $envList ne "" ) {
     print "Environments are passed in \\n";
     my @environments = split(\',\', $envList);
     foreach my $environment (@environments) {
         my ($envName, $envProjectName) = split(\'/\', $environment);
         $envName = trim($envName);
         $envProjectName = trim($envProjectName);
         print "Env Name " . $envName . " Project Name " . $envProjectName . "\\n";
         $ec->tearDown({environmentName => trim($envName), projectName => trim($envProjectName)});
     }
     exit 0;
}


# Overall logic is pretty staright forward
#
# Collect all the jobId for the currentJob or jobId\'s for the current pipelineRun. 
# The for each jobId check whether the propertySheet \'ProvisionedResources\' exists. 
# If it exists then check whether the \'environmnetName\' and \'environmnetProjectName\' 
# property exists. If the environmentName, environmnetProjectName proerties exist then 
# we should call the tearDown

# Check to see whether the scriptis running in the context of a pipeline or 
# Process ( procedure ) 
#
my $pipeline = $ec->getProperty("/myPipelineRuntime")->findvalue("//value")->value();
if ( $pipeline ne "") {
    # Get all the jobId\'s related to this pipeline and set the $myJobIds array
    # It would be nice if Jobs table stores the pipleineRunTime association and we can 
    # further filter Jobs by app process that uses dynamic enviroment. Otherwise
    # it is inefficient but still doable by ignoring the jobs that do not have a property 

    # Mock for my testing
    push( @myJobIds, "70b7ebaf-f2d7-11e5-a6e1-08002714ebc4");
    push( @myJobIds, "83768132-f2d7-11e5-9420-08002714ebc4");
    push( @myJobIds, "b70a5518-f504-11e5-839b-08002714ebc4");
    push( @myJobIds, "20270625-f508-11e5-85c5-08002714ebc4");
} else {
	  # If the procedure is running outside the context of a pipeline
    push(@myJobIds, "$[/myJob/id]");
}

# Loop through all the jobs
foreach my $myJobId( @myJobIds ) {
   print $myJobId . "\\n";

   # Check for properties under propertySheet \'ProvisionedResources\'
   my $properties = $ec->getProperties({jobId => $myJobId, path => "ProvisionedResources"});

   my $msg = $ec->getError();

   my $envName = "";
   my $envProjectName = "";

   if ($msg eq "") {
   		print "PROPERTY FOUND" . "\\n";
        # print "Return data from Commander:\\n" . $properties->findnodes_as_string("//property"). "\\n";
        foreach my $property($properties->findnodes("//property")) {
        	my $temp = $property->findvalue("propertyName")->string_value;

        	# Collect environmnetName and environmnetProjectName required for tearDown
        	if ( $temp eq "environmentName") {
        		$envName = $property->findvalue("value")->string_value;
        	} elsif ( $temp eq "envProjectName" ) {
        		$envProjectName = $property->findvalue("value")->string_value;
        	}
        }	

        # Check to make sure envName and envProjectName is not empty 
        if ( $envName ne "" and $envProjectName ne "" ) {
            print "PropertyName $envName -> " . $envName . 
                  " $envProjectName -> " . $envProjectName . "\\n";

            #Call the tearDown API
            $ec->tearDown({environmentName => $envName, projectName => $envProjectName});

            # Create a Job step. This is more for 
            # $ec->createJobStep({
            #    jobStepName => "Decommision ". $envName,
            #    command =>"ectool tearDown --environmentName ". $envName . " --projectName " . $envProjectName});    


            #Check the Error msg
            $msg = $ec->getError();
            if ($msg ne "") {
               print "Error from Commander after tearDown call :\\n" . $msg . "\\n";
            } 
        } else {
   	        print "Skipping teardown for job as the required property do not exist" . "\\n";
        }
    } else {
    	print "Property not found for job - " . $myJobId . "\\n";
    }    
}'''
      condition = ''
      errorHandling = 'failProcedure'
      exclusiveMode = 'none'
      logFileName = ''
      parallel = '0'
      postProcessor = ''
      precondition = ''
      releaseMode = 'none'
      resourceName = ''
      shell = 'ec-perl'
      subprocedure = null
      subproject = null
      timeLimit = ''
      timeLimitUnits = 'minutes'
      workingDirectory = ''
      workspaceName = ''
    }
  }
}

plugin 'EF-Utilities', version: '0.3.4.44', projectName: 'EF-Utilities-0.0.0.1', {
  description = 'A set of commone procedures for Deploy projects'
  pluginName = 'EF-Utilities-0.0.0.1'
  author = 'L. Rochette'
  label = 'EF-Utilities'
}
