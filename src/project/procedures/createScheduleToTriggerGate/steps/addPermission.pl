$[/plugins[EC-Admin]project/scripts/perlHeaderJSON]

my ($ok, $json, $errCode, $errMsg) = InvokeCommander("",
  'createAclEntry', 'user', "project: $[/myProject/projectName]", 
  {
     projectName => "$[/myPipelineRuntime/projectName]",
     flowRuntimeName => "$[/myPipelineRuntime]", 
     readPrivilege    => "allow",
     executePrivilege => "allow",
     modifyPrivilege  => "allow",
     changePermissionsPrivilege => "inherit"
  });


#($ok, $json, $errCode, $errMsg) = InvokeCommander("",
#  'createAclEntry', 'user', "project: $[/myProject/projectName]", 
#  {
#     projectName => "$[/myPipelineRuntime/projectName]",
#     pipelineName => "$[/myPipelineRuntime/pipelineName]", 
#     taskName => "$[gate]",
#     stageName => "$[stage]",
#     readPrivilege    => "allow",
#     executePrivilege => "allow",
#     modifyPrivilege  => "allow",
#     changePermissionsPrivilege => "inherit"
#  });
  
$[/plugins[EC-Admin]project/scripts/perlLibJSON]

