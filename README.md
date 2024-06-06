# Slack file-sending bot

#### This application is created to parse variable groups of azure devops portal, check if they were assigned to release or release stage and output the CSV file with sending it as a bot in slack.


!!!

    * Pipeline is created for running in azure self-hosted agent (DevOps free account don't allow usage of Microsoft-Hosted agent) 
    * scripts in "./script" folder is tested on ubuntu 20.04 VM with python 3.9 version. apt dependencies in pipeline, unfortunatelly, don't allow run it on  some other VM types
    * For running this application you should manually (or with some IaC tools) launch VM, install microsoft self-hosted agent on it, create slack-bot with needed permissions
    * For running az commands properly you should create azuread_service_principal and grant them needed roles

### Creating a self-hosted agent for azure devops
##### 1) First things first you should run the virtual machine.
* I totally recommend to using some IaC tools to create VM properly cause beside the VM itself you should create resource group in which this VM existed, Nvirtual network, subnet, public IP, network security group for accessing VM by SSH, storage account for this VM and generate SSH key pair
##### 2) Install azure devops agent.   Actually I cannot provide documentation better than MicroSoft, so just place the link below: https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops
##### 3) Create service principal for executing az commands
* Simple example is just type `az ad sp create-for-rbac` in your terminal
* output will be in json format like 
>{  
>  "appId": "myAppId",  
>  "displayName": "myServicePrincipalName",  
>  "password": "myServicePrincipalPassword",  
>  "tenant": "myTentantId"  
>}
* You should save output and next assign it into pipeline variables
* For more information visit https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1?view=azure-cli-latest&tabs=bash#sign-in-using-a-service-principal
##### 4) Create slack app
* https://api.slack.com/apps click "create new app"
*  grant necessary permissions with app manifest. 
* if you done all correctly then in page "OAuth and permissions" you can see "Bot OAuth token"
* this token you should put into pipeline variable `SLACK_BOT_TOKEN`
##### 5) Run pipeline