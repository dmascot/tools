
$config = New-PesterConfiguration
$config.Run.Path = "$PWD\tests\lib\windows\functions\","$PWD\tests\lib\windows\tools"
$config.Run.TestExtension = '.test.ps1'

Invoke-Pester -Configuration $config  