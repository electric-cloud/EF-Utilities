$[/plugins[EC-Admin]project/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMsg) = InvokeCommander("IgnoreError",
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
  printf("errCode: $errCode\n");
  printf("errMsg: $errMsg\n");
  exit(0) if ($errCode eq 'DuplicateAclEntry');
  
  printf("Error($errCode): $errMsg\n");
  exit(1);
}

  
$[/plugins[EC-Admin]project/scripts/perlLibJSON]



