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
if ($force eq "true") {
	my ($ok) = InvokeCommander("IgnoreError", 'getSnapshot', $proj, $app, $snap);
    if ($ok) {
    	$ec->deleteSnapshot($proj, $app, $snap);
    }
}
$ec->createSnapshot($proj, $app, $snap);

$[/plugins[EC-Admin]project/scripts/perlLibJSON]

