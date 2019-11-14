#!/bin/bash

SUFFIX=$(openssl rand -hex 5)
RG_NAME=Test-$SUFFIX
REGION=EastUS
PLAN_NAME=TestPlan-$SUFFIX
PLAN_SKU=B1
APPSERVICE_NAME=Test$SUFFIX
SQL_SERVER=test$SUFFIX
SQL_USER=test$SUFFIX
SQL_PASSWORD=$(openssl rand -base64 18 | sed "s|[+/]|x|g")
SQL_DB=test$SUFFIX

# Display intentions and ask user if they want to proceed
echo "This will create the following Windows App Service:"
echo "  Name:           $APPSERVICE_NAME.azurewebsites.net"
echo "  Region:         $REGION"
echo "  Resource Group: $RG_NAME"
echo "  SQL Server:     $SQL_SERVER.database.windows.net"
echo "  SQL Database:   $SQL_DB"
echo "  SQL User:       $SQL_USER"
echo "  SQL Password:   $SQL_PASSWORD"
echo
read -p "Do you want to continue (y/n)? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Create resource group
echo "Creating the resource group..."
az group create -n $RG_NAME -l $REGION

# Create app service plan
echo "Creating appservice plan..."
az appservice plan create -g $RG_NAME -n $PLAN_NAME -l $REGION --sku $PLAN_SKU

# Create app service (website)
az webapp create -g $RG_NAME -p $PLAN_NAME -n $APPSERVICE_NAME

# Create SQL server
az sql server create -g $RG_NAME -n $SQL_SERVER -l $REGION \
    --admin-user $SQL_USER --admin-password $SQL_PASSWORD

# Allow access from Azure services
az sql server firewall-rule create -g $RG_NAME -s $SQL_SERVER \
    -n AllowAzureServices --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

# Create database
az sql db create -g $RG_NAME -s $SQL_SERVER -n $SQL_DB --collation Czech_CI_AI

# Show connection string
az sql db show-connection-string -s $SQL_SERVER -n $SQL_DB -c ado.net

# Assign connection string to web app
az webapp config connection-string set -g $RG_NAME -n $APPSERVICE_NAME -t SQLAzure \
    --settings DefaultConnection="Server=tcp:$SQL_SERVER.database.windows.net,1433;Database=$SQL_DB;User ID=$SQL_USER;Password=$SQL_PASSWORD;Encrypt=true;Connection Timeout=30;"

# Display result
echo "The following Windows App Service has been created:"
echo "  Name:           $APPSERVICE_NAME.azurewebsites.net"
echo "  Region:         $REGION"
echo "  Resource Group: $RG_NAME"
echo "  SQL Server:     $SQL_SERVER.database.windows.net"
echo "  SQL Database:   $SQL_DB"
echo "  SQL User:       $SQL_USER"
echo "  SQL Password:   $SQL_PASSWORD"