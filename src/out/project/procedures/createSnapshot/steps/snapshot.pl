$[/plugins[EC-Admin]project/scripts/perlHeaderJSON]

#
# Parameters
#
my $proj  = "$[projName]";
my $app   = "$[appName]";
my $snap  = "$[snapName]";
my $env   = "$[envName]";

$ec->createSnapshot($proj, $app, $snap);

