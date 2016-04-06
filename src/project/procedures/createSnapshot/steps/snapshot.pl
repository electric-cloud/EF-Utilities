$[/plugins[EC-Admin]project/scripts/perlHeaderJSON]

#
# Parameters
#
my $proj  = "$[projName]";
my $app   = "$[appName]";
my $snap  = "$[snapName]";
my $env   = "$[envName]";
my $force = "$[force]";

# delete a snapshot with the same name if force mode is on
if (($force eq "true") || ($force eq "1")) {
	my ($ok) = InvokeCommander("IgnoreError", 'getSnapshot', $proj, $app, $snap);
    if ($ok) {
    	printf("Deleting snapshot $snap\n");
    	$ec->deleteSnapshot($proj, $app, $snap);
    }
}
$ec->createSnapshot($proj, $app, $snap);
printf("Created snapshot $snap\n");

$[/plugins[EC-Admin]project/scripts/perlLibJSON]



