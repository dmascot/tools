BeforeAll {
    . $PWD\scripts\windows\tools.ps1
}

Describe "Install-Pyenv" -Tag 'Integration' {

    it "should install Pyenv" {
        Install-Pyenv

        isCommandInstalled -commandName 'pyenv' | Should -BeExactly $true
    }
}