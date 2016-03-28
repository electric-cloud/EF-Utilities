$[/plugins[EC-Admin]project/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMsg) = InvokeCommander("",
  'createAclEntry', 'user', "project: $[/myProject/projectName]", 
  {
     pipelineName => "$[/myPipelineRuntime]", 
     readPrivilege    => "allow",
     executePrivilege => "allow",
     modifyPrivilege  => "allow",
     changePermissionsPrivilege => "inherit"
  });

$[/plugins[EC-Admin]project/scripts/perlLibJSON]

