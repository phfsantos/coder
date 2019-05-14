# VS Code in a Container 🤯
Run VS Code in a container using [https://coder.com/](https://github.com/codercom/code-server) 


### Deployed Resources
- Microsoft.ContainerInstance/containerGroups

### Quick Deploy
[![deploy](https://raw.githubusercontent.com/benc-uk/azure-arm/master/etc/azuredeploy.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fphfsantos%2Fcoder%2Fmaster%2Fazuredeploy.json)  

### Parameters
- `storageAcctName`: Storage account name, should hold three shares called `code-server-proj`, `code-server-data`, `code-server-bin`
- `storageAcctKey`: Storage account key
- `password`: Password to protect and logon to web version of VS Code


### Outputs
- `codeServerURL`: URL to access VS Code in browser
