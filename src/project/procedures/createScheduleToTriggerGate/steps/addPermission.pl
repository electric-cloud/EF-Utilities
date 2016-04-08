$[/myProject/scripts/perlHeaderJSON]

my ($ok, $json, $errMsg, $errCode) = InvokeCommander("IgnoreError",
  'createAclEntry', 'user', "project: $[/myProject/projectName]",
  {
     projectName => "$[/myPipelineRuntime/projectName]",
     flowRuntimeName => "$[/myPipelineRuntime]",
     readPrivilege    => "allow",
     executePrivilege => "allow",
     modifyPrivilege  => "allow",
     changePermissionsPrivilege => "inherit"
  });

# check for error
if (! $ok) {
  # ignore duplicate entry: Issue #9
  exit(0) if ($errCode eq 'DuplicateAclEntry');

  printf("Error($errCode): $errMsg\n");
  exit(1);
}


$[/myProject/scripts/perlLibJSON]

