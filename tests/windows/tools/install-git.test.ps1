BeforeAll {
    . $PWD\scripts\windows\tools.ps1
}

Describe "Install-Git" -Tag 'Integration' {

    it "should install git scm and , add path to environmnet" {
        Install-Git

        isCommandInstalled -commandName 'git' | Should -BeExactly $true

        $env:Path -match  [regex]::Escape("C:\Program Files\Git\cmd") | Should -BeExactly $true
    }
}