[![Actions Status](https://github.com/GS-MAFTech/iac-tf-env/workflows/InfraPipeline/badge.svg)](https://github.com/GS-MAFTech/iac-tf-env)

## REPO Structure
This repository contains the Cloud Infrastructure for the projects. It has 2 subdirectories - aws & azure. Terraform state file is stored in the remote backend as defined in each project.

aws

    - account1
              - Project1
                        -env1
                        -env2
    - account2
              - Project1
                        -env1

azure

    - subscription1
              - Project1
                        -env1
                        -env2
    - subscription2
              - Project1
                        -env1

example: -
```

├───aws
│   └───MAF-AWS-Analytics-Governance
│       └───dev
└───azure
    └───MAFGS-Analytics
        ├───bi-synapse
        │   └───prod
        └───shared-network
            └───prod
## Instructions to update the repo
- fork the repo https://github.com/GS-MAFTech/iac-tf-env
- commit the changes in the local branch
- push the changes to personal[forked] repo.
- Create a Pull Request.
