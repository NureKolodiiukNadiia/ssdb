#!/bin/bash

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Passw0rd" \
  -p 14331:1433 \
  --name ssdb-pz1 \
  -v ssdb-pz1-data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Passw0rd" \
  -p 14332:1433 \
  --name ssdb-pz2 \
  -v ssdb-pz2-data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Passw0rd" \
  -p 14333:1433 \
  --name ssdb-pz3 \
  -v ssdb-pz3-data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Passw0rd" \
  -p 14334:1433 \
  --name ssdb-pz4 \
  -v ssdb-pz4-data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Passw0rd" \
  -p 14335:1433 \
  --name ssdb-lab1 \
  -v ssdb-lab1-data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Passw0rd" \
  -p 14336:1433 \
  --name ssdb-lab2 \
  -v ssdb-lab2-data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Passw0rd" \
  -p 14337:1433 \
  --name ssdb-lab3 \
  -v ssdb-lab3-data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Passw0rd" \
  -p 14338:1433 \
  --name ssdb-sql-agent \
  -v ssdb-sql-agent-data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Passw0rd" \
  -p 14339:1433 \
  --name ssdb-partitioning \
  -v ssdb-partitioning-data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Passw0rd" \
  -p 14340:1433 \
  --name ssdb-policies \
  -v ssdb-policies-data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest