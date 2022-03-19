package FlowPlugin::EFUtilities;
use strict;
use warnings;
use base qw/FlowPDF/;
use FlowPDF::Log;

# Feel free to use new libraries here, e.g. use File::Temp;

# Service function that is being used to set some metadata for a plugin.
sub pluginInfo {
    return {
        pluginName          => '@PLUGIN_KEY@',
        pluginVersion       => '@PLUGIN_VERSION@',
        configFields        => ['config'],
        configLocations     => ['ec_plugin_cfgs'],
        defaultConfigValues => {}
    };
}

## === check connection ends ===

# Auto-generated method for the procedure Zero artifact retrieval/Zero artifact retrieval
# Add your code into this method and it will be called when step runs
# $self - reference to the plugin object
# $p - step parameters

# $sr - StepResult object
sub zeroArtifactRetrieval {
    my ($self, $p, $sr) = @_;

    my $context = $self->getContext();
    logInfo("Current context is: ", $context->getRunContext());
    logInfo("Step parameters are: ", $p);


    $sr->setJobSummary("No op artifact retrieval procedure");
}
# Auto-generated method for the procedure Create Snapshot/Create Snapshot
# Add your code into this method and it will be called when step runs
# $self - reference to the plugin object
# $p - step parameters
# Parameter: ApplicationName
# Parameter: ServiceName
# Parameter: ProjectName
# Parameter: SnapshotName
# Parameter: EnvironmentName
# Parameter: EnvironmentProjectName
# Parameter: ComponentVersions
# Parameter: Overwrite

# $sr - StepResult object
sub createSnapshot {
    my ($self, $p, $sr) = @_;

    my $context = $self->getContext();
    logInfo("Current context is: ", $context->getRunContext());
    logInfo("Step parameters are: ", $p);

    my $configValues = $context->getConfigValues();
    logInfo("Config values are: ", $configValues);

    $sr->setJobStepOutcome('warning');
    $sr->setJobSummary("This is a job summary.");
}


# Auto-generated method for the procedure Decommission Environments/Decommission Environments
# Add your code into this method and it will be called when step runs
# $self - reference to the plugin object
# $p - step parameters
# Parameter: EnvironmentList

# $sr - StepResult object
sub decommissionEnvironments {
    my ($self, $p, $sr) = @_;

    my $context = $self->getContext();
    logInfo("Current context is: ", $context->getRunContext());
    logInfo("Step parameters are: ", $p);

    my $configValues = $context->getConfigValues();
    logInfo("Config values are: ", $configValues);

    $sr->setJobStepOutcome('warning');
    $sr->setJobSummary("This is a job summary.");
}
# Auto-generated method for the procedure NoOpArtifact/NoOpArtifact
# Add your code into this method and it will be called when step runs
# $self - reference to the plugin object
# $p - step parameters
# Parameter: artifact
# Parameter: version

# $sr - StepResult object
sub noOpArtifact {
    my ($self, $p, $sr) = @_;

    my $context = $self->getContext();
    logInfo("Current context is: ", $context->getRunContext());
    logInfo("Step parameters are: ", $p);

    my $configValues = $context->getConfigValues();
    logInfo("Config values are: ", $configValues);

    $sr->setJobStepOutcome('warning');
    $sr->setJobSummary("This is a job summary.");
}
# Auto-generated method for the procedure Seed environment inventory/Seed environment inventory
# Add your code into this method and it will be called when step runs
# $self - reference to the plugin object
# $p - step parameters

# $sr - StepResult object
sub seedEnvironmentInventory {
    my ($self, $p, $sr) = @_;

    my $context = $self->getContext();
    logInfo("Current context is: ", $context->getRunContext());
    logInfo("Step parameters are: ", $p);

    my $ec = ElectricCommander->new();
    my $regexp = $p->{regexp};

    my $output = $p->{output};

    my $appProjectName = $ec->getPropertyValue('/myApplication/projectName');
    my $appName = $ec->getPropertyValue('/myApplication/name');
    my $envName = $ec->getPropertyValue('/myEnvironment/name');
    my $procName = $ec->getPropertyValue('/myJob/processName');
    my $resName = $ec->getPropertyValue('/myResource/name');
    my $componentName = $ec->getPropertyValue('/myComponent/name');

    logInfo "Application project: $appProjectName";
    logInfo "Application name: $appName";
    logInfo "Environment name: $envName";
    logInfo "Process name: $procName";
    logInfo "Resource name: $resName";
    logInfo "Component name: $componentName";

    my %params = (
      projectName => $appProjectName,
      applicationName => $appName,
      environmentName => $envName,
      applicationProcessName => $procName,
      status        => 'success',
      resourceNames => $resName,
      componentName => $componentName,
    );

    if ($regexp && $output) {
        while($output =~ m/$regexp/cg) {
            my $name = $1;
            my $version = $2;
            if ($name && $version) {
                print "Found artifact $name, $version\n";
                my $result = $ec->seedEnvironmentInventory({
                    %params,
                    artifactName => $name,
                    artifactVersion => $version
                });
            }
        }
    }

    if (my $artifactNames = $p->{artifactNames}) {
        my $artifacts;
        eval {
            $artifacts = decode_json($artifactNames);
            1;
        } or do {
            print "Failed to decode artifacts as JSON\n";
            my @lines = split(/\n+/ => $artifactNames);
            for (@lines) {
                my ($name, $version) = split(/:/, $_);
                print "Seeding artifact version: $name:$version\n";
                my $result = $ec->seedEnvironmentInventory({
                    %params,
                    artifactName => $name,
                    artifactVersion => $version
                });
            }
        };

    }
}
## === step ends ===
# Please do not remove the marker above, it is used to place new procedures into this file.


1;
