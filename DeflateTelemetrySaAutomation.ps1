﻿param
(
<#    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputDir,
#>
    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $resourceGroupName,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $jobName,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $jobLocation,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $inputName,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $inputEventHubName,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $inputEventHubNamespace,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $serviceBusNameSpace,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputStorageAccount,
        
    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $output1Name,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputTable1Name,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputTable1PartitionKey,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputTable1RowKey,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $output2Name,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputTable2Name,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputTable2PartitionKey,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputTable2RowKey,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputDataLakeAccount,

    [parameter(ParameterSetName='Customize',Mandatory=$false)]
    [string]
    $AADClientAppId = "",

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputDataLake1Name,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputDataLake1Prefix,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputDataLake2Name,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $outputDataLake2Prefix,

    [parameter(ParameterSetName='Customize',Mandatory=$true)]
    [string]
    $transformationName,
	
	[Parameter(ParameterSetName='Customize',Mandatory=$true)]
	[String]
    $userName,

    [Parameter(ParameterSetName='Customize',Mandatory=$true)]
	[String]
    $password,

    [Parameter(ParameterSetName='Customize',Mandatory=$true)]
	[String]
    $subscriptionName
    
)

<#function to create the sa job#>
function CreateNewSAJob()
{
    <#setting up the file paths#>
    $localFilePath  = [System.io.path]::combine($PSScriptRoot,'DefalteTelemetrySa','JobParameters.json')
    $outFilePath = [System.io.path]::combine($outputDir,'DefalteTelemetrySaOutput','JobParameters.json')

    <#create a new file item to store the sa job template#>
    $null = New-Item -Path $outFilePath -ItemType File -Force

    <#replacing the default values with the script arguments#>
	(Get-Content $localFilePath).replace('@Location', $jobLocation) | Set-Content $outFilePath

    New-AzureRmStreamAnalyticsJob -File $outFilePath -ResourceGroupName $resourceGroupName -Name $jobName -Force

}

<#function to create the sa job input#>
function CreateNewSAInput()
{
    <#setting up the file pathss#>
    $localFilePath  = [System.io.path]::combine($PSScriptRoot,'DefalteTelemetrySa','InputParameters.json')
    $outFilePath = [System.io.path]::combine($outputDir,'DefalteTelemetrySaOutput','InputParameters.json')

    <#create a new file item to store the sajob input template#>
    $null = New-Item -Path $outFilePath -ItemType File -Force

    $key = Get-AzureRmEventHubNamespaceKey -ResourceGroupName $resourceGroupName -NamespaceName $inputEventHubNamespace -AuthorizationRuleName TMLSAJobRootManageSharedAccessKey
    $consumerGroup = Get-AzureRmEventHubConsumerGroup -ResourceGroupName $resourceGroupName -NamespaceName $inputEventHubNamespace -EventHubName $inputEventHubName
    
    <#replacing the default values with the script arguments#>
  	(Get-Content $localFilePath).replace('@ConsumerGroupName', $consumerGroup[1].Name) | Set-Content $outFilePath
	(Get-Content $outFilePath).replace('@EventHubName', $inputEventHubName) | Set-Content $outFilePath
    (Get-Content $outFilePath).replace('@EventHubccessPolicyName', $key.KeyName) | Set-Content $outFilePath
    (Get-Content $outFilePath).replace('@EventHubAccessPolicyKey', $key.PrimaryKey) | Set-Content $outFilePath
    (Get-Content $outFilePath).replace('@ServiceBusNamespace', $serviceBusNameSpace) | Set-Content $outFilePath

    New-AzureRmStreamAnalyticsInput -File $outFilePath -ResourceGroupName $resourceGroupName -JobName $jobName -Name $inputName -Force
}

<#function to create the sa table output#>
function CreateNewTableOutput()
{
    param
    (
        [parameter(ParameterSetName='Customize',Mandatory=$true)]
        [string]
        $outputName,

        [parameter(ParameterSetName='Customize',Mandatory=$true)]
        [string]
        $TableName,

        [parameter(ParameterSetName='Customize',Mandatory=$true)]
        [string]
        $TablePartitionKey,

        [parameter(ParameterSetName='Customize',Mandatory=$true)]
        [string]
        $TableRowKey
    )

    <#setting up the file pathss#>
    $localFilePath  = [System.io.path]::combine($PSScriptRoot,'DefalteTelemetrySa','TableOutputParameters.json')
    $outFilePath = [System.io.path]::combine($outputDir,'DefalteTelemetrySaOutput','TableOutputParameters.json')

    <#create a new file item to store the sajob table output template#>
    $null = New-Item -Path $outFilePath -ItemType File -Force

    $key = Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $outputStorageAccount

    <#replacing the default values with the script arguments#>
  	(Get-Content $localFilePath).replace('@AccountName', $outputStorageAccount) | Set-Content $outFilePath
	(Get-Content $outFilePath).replace('@AccountKey', $key[0].Value) | Set-Content $outFilePath
    (Get-Content $outFilePath).replace('@Table', $TableName) | Set-Content $outFilePath
    (Get-Content $outFilePath).replace('@PartitionKey', $TablePartitionKey) | Set-Content $outFilePath
    (Get-Content $outFilePath).replace('@RowKey', $TableRowKey) | Set-Content $outFilePath

    New-AzureRmStreamAnalyticsOutput -File $outFilePath -ResourceGroupName $resourceGroupName -JobName $jobName -Name $outputName -Force
}

<#function to create the sa datalake output#>
function CreateNewDataLakeOutput()
{
    param
    (
        [parameter(ParameterSetName='Customize',Mandatory=$true)]
        [string]
        $outputDataLakeName,

        [parameter(ParameterSetName='Customize',Mandatory=$true)]
        [string]
        $outputDataLakePrefix
    )

    $localFilePath  = [System.io.path]::combine($PSScriptRoot,'DefalteTelemetrySa','DataLakeOutputParameters.json')
    $outFilePath = [System.io.path]::combine($outputDir,'DefalteTelemetrySaOutput','DataLakeOutputParameters.json')

    <#create a new file item to store the sajob datalake output template#>
    $null = New-Item -Path $outFilePath -ItemType File -Force

    <#replacing the default values with the script arguments#>
  	(Get-Content $localFilePath).replace('@AccountName', $outputDataLakeAccount) | Set-Content $outFilePath
	(Get-Content $outFilePath).replace('@TenantId', $tenantId) | Set-Content $outFilePath
    (Get-Content $outFilePath).replace('@FilePathPrefix', $outputDataLakePrefix) | Set-Content $outFilePath
    (Get-Content $outFilePath).replace('@AccessToken', $accessToken) | Set-Content $outFilePath
    (Get-Content $outFilePath).replace('@RefreshToken', $refreshToken) | Set-Content $outFilePath
    
    New-AzureRmStreamAnalyticsOutput -File $outFilePath -ResourceGroupName $resourceGroupName -JobName $jobName -Name $outputDataLakeName -Force
}

<#geeting the access token and refresh tokens required dor datalake output#>
function GetAADTokens()
{
    $AccountName = $userName
    $Password = $password
 
    $PayLoad="resource=https://management.core.windows.net/&client_id=1950a258-227b-4e31-a9cf-717495945fc2&grant_type=password&username="+$AccountName+"&scope=openid&password="+$Password
 
    $Response=Invoke-WebRequest -Uri "https://login.microsoftonline.com/Common/oauth2/token" -Method POST -Body $PayLoad
 
    $ResponseJSON=$Response|ConvertFrom-Json

    $global:refreshToken = $ResponseJSON.access_token
    $global:accessToken = $ResponseJSON.refresh_token
}


<#function for creating a query#>

function CreateNewQuery()
{
    $localFilePath  = [System.io.path]::combine($PSScriptRoot,'DefalteTelemetrySa','QueryParameters.json')
    $outFilePath = [System.io.path]::combine($outputDir,'DefalteTelemetrySaOutput','QueryParameters.json')
    $queryFilePath  = [System.io.path]::combine($PSScriptRoot,'DefalteTelemetrySa','query.txt')
    
    <#create a new file item to store the sajob query template#>
    $null = New-Item -Path $outFilePath -ItemType File -Force

    $query = Get-Content $queryFilePath

    <#replacing the default values with the script arguments#>
  	(Get-Content $localFilePath).replace('@Query', $query) | Set-Content $outFilePath

    New-AzureRmStreamAnalyticsTransformation -File $outFilePath -ResourceGroupName $resourceGroupName -JobName $jobName -Name $transformationName -Force
}


$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($userName, $secpasswd)
Login-AzureRmAccount -Credential $mycreds -SubscriptionName $subscriptionName

$currentContext = Get-AzureRmContext
$tenantId = $currentContext.Subscription.TenantId

CreateNewSAJob 

CreateNewSAInput


CreateNewTableOutput -outputName $output1Name -TableName $outputTable1Name -TablePartitionKey $outputTable1PartitionKey -TableRowKey $outputTable1RowKey

CreateNewTableOutput -outputName $output2Name -TableName $outputTable2Name -TablePartitionKey $outputTable2PartitionKey -TableRowKey $outputTable2RowKey


GetAADTokens

CreateNewDataLakeOutput -outputDataLakeName $outputDataLake1Name -outputDataLakePrefix $outputDataLake1Prefix

CreateNewDataLakeOutput -outputDataLakeName $outputDataLake2Name -outputDataLakePrefix $outputDataLake2Prefix

CreateNewQuery 
