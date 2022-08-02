
$config = New-PesterConfiguration
$config.Run.Path = "$PWD\tests\windows\functions\","$PWD\tests\windows\tools"
$config.Run.TestExtension = '.test.ps1'

Invoke-Pester -Configuration $config  