# Stream-Analytics-Automation
Automation PowerShell scripts for Azure stream analytics

# Stream-Analytics-Automation via PowerShell

## Use the PowerShell scripts along-with JSON files to automate input sources, output sinks and query transformations on a stream analytics job.

The sample scripts will use Event hubs as input source, Azure Data Lake (protected by AAD application) and Azure table storage as output sinks & sample dummy queries for creating sample stream analytics jobs.

_**Note : All components like event hubs, azure table storage & azure data lake account protected by native AAD application must be pre-provisioned along with service principal account / co-owner credentials in default AD domain for silent sign-in against the azure subscription in order to run the scripts.**_

## 1. AlertEventsCmdResposeSaAutomation.ps1

This script will provision a stream analytics job using the provided configuration and populating the input, output json configs, dummy query and other query parameter format schema files using the JSON files in AlertEventsCmdResponseSa folder.

The following are the necessary arguments for the script:

* resourceGroupName = name of target resource group
* jobName = name of SA job
* jobLocation = SA Job location
* inputName = Name of SA Job input
* inputEventHubName = Name of input event hub for input stream
* inputEventHubNamespace = Input event hub namespace name
* serviceBusNameSpace = Name of the service bus to which the event hub belongs to
* outputDataLakeAccount = Name of the output Data Lake account
* AADClientAppId = AAD application ID configured for the Data Lake Account 
* outputDataLake1Name = Name of the output Data Lake account
* outputDataLake1Prefix = Filepath prefix for output Data Lake account
* outputDataLake2Name = Name of the output Data Lake account
* outputDataLake2Prefix = Filepath prefix for output Data Lake account
* outputDataLake3Name = Name of the output Data Lake account
* outputDataLake3Prefix = Filepath prefix for output Data Lake account
* transformationName = Name of Query transformation
* userName = username of co-owner of subscription / service principal app ID
* password = password of co-owner of subscription / service principal app Key
* subscriptionName = Name of Azure Subscription

_On executing the script a dummy SA job with an event hub source and 3 output Azure Data lake sinks & a transformation query would be generated._

_**Note : This script is only an example to show event hub as input and azure data lake as output. Also, Modify the transformation query to your custom logic in the query.txt file.******_

## 2. DefalteTelemetrySa.ps1

This script will provision a stream analytics job using the provided configuration and populating the input, output json configs, dummy query and other query parameter format schema files using the JSON files in DefalteTelemetrySafolder.

The following are the necessary arguments for the script:

* resourceGroupName = name of target resource group
* jobName = name of SA job
* jobLocation = SA Job location
* inputName = Name of SA Job input
* inputEventHubName = Name of input event hub for input stream
* inputEventHubNamespace = Input event hub namespace name
* serviceBusNameSpace = Name of the service bus to which the event hub belongs to
* outputStorageAccount= Name of the output storage account
* output1Name = Name of output
* outputTable1Name = Name of output table in the output storage account
* outputTable1PartitionKey = Partition key of output table 1
* outputTable1RowKey = Row key of output table 1
* output2Name = Name of output
* outputTable2Name = Name of output table in the output storage account
* outputTable2PartitionKey = Partition key of output table 1
* outputTable2RowKey = Row key of output table 1
* outputDataLakeAccount = Name of the output Data Lake account
* AADClientAppId = AAD application ID configured for the Data Lake Account 
* outputDataLake1Name = Name of the output Data Lake account
* outputDataLake1Prefix = Filepath prefix for output Data Lake account
* outputDataLake2Name = Name of the output Data Lake account
* outputDataLake2Prefix = Filepath prefix for output Data Lake account
* transformationName = Name of Query transformation
* userName = username of co-owner of subscription / service principal app ID
* password = password of co-owner of subscription / service principal app Key
* subscriptionName = Name of Azure Subscription

_On executing the script a dummy SA job with an event hub source and 2 output Azure Data lake sinks / 2 output Azure table storage sinks & a transformation query would be generated._

_**Note : This script is only an example to show event hub as input and azure data lake, Azure table storage as output. Also, Modify the transformation query to your custom logic in the query.txt file.******_
