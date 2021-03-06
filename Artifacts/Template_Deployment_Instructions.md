# Getting Started

1. Clone the [whitepaper GitHub repository](https://github.com/solliancenet/microsoft-mysql-developer-guide.git) to your local machine. 

2. Install the [PowerShell Azure module](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-6.6.0) if you do not already have it.

    > [PowerShell Core](https://github.com/PowerShell/PowerShell)  is a cross-platform tool that is useful for managing Azure resources through the `Az` module.

    > Try the `-AllowClobber` flag if the install does not succeed.

3. Utilize the `Connect-AzAccount` to interactively authenticate the Azure PowerShell environment with Azure.

## Create a Lab Resource Group

1. Use Azure Powershell to create a new resource group. Substitute the `rgName` and `location` parameters with the name of your resource group and its location, respectively.

    ```powershell
    $rgName = ""
    $location = ""
    New-AzResourceGroup -Name $rgName -Location $location
    ```

## Deploy the ARM Template

1. There are two ARM templates provided with the whitepaper.

    - The secure deployment uses private endpoints to securely access the MySQL database instances through private IP addresses. It costs roughly ... per month.
    - The standard deployment routes traffic to the MySQL instances over the public internet. It costs roughly ... per month.

2. If you are deploying the [secure ARM template](../Artifacts/template-secure.json) (`template-secure.json`), edit the associated [parameters file](../Artifacts/template-secure.parameters.json) (`template-secure.parameters.json`).

    - The `prefix` specifies a unique identifier for Azure resources
    - The `administratorLogin` specifies the login for the Azure resources (such as MySQL and the VM)
    - The `administratorLoginPassword` specifies the password for the deployed Azure resources
    - The `location` should be set to an Azure region near you

3. If you are deploying the [insecure ARM template](../Artifacts/template.json) (`template.json`), edit the associated [parameters file](../Artifacts/template.parameters.json) (`template.parameters.json`).
    - The `uniqueSuffix` specifies a unique identifier for Azure resources
    - The `administratorLogin` specifies the login for the Azure resources (such as MySQL and the VM)
    - The `administratorLoginPassword` specifies the password for the deployed Azure resources
    - The `vmSize` specifies the VM tier
    - The `dnsPrefix` specifies the DNS prefix for the load balancer public IP address

4. If you are deploying the secure ARM template, issue the following command from the repository root.

    ```powershell
    New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile .\Artifacts\template-secure.json -TemplateParameterFile .\Artifacts\template-secure.parameters.json
    ```

    Use `template.json` and `template.parameters.json` for the insecure ARM template deployment.
