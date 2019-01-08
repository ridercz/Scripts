# VSO2GH

Script to migrate simple repository from Azure DevOps to GitHub.

    vso2gh hostname username vsoproject [ghproject]

* `hostname` is the custom part of *.visualstudio.com
* `username` is GitHub user name
* `vsoproject` is repository name in Azure DevOps/VSO
* `ghproject` is empty GitHub project name, defaults to `vsoproject` if not specified