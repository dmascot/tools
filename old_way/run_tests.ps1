# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT


$config = New-PesterConfiguration
$config.Run.Path = "$PWD\tests\lib\windows\functions\","$PWD\tests\lib\windows\tools"
$config.Run.TestExtension = '.test.ps1'

Invoke-Pester -Configuration $config  