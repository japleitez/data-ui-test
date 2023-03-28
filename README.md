# Data collection UI test

This repository is for UI testing the Data Collection

**assumptions**

The test needs the database filled with the following data:

Table Acquisition should be provided with records with "id" from 1 to 30
Table Crawler should be provided with records with "id" from 1 to 30 and names
reneging from crawler1 to crawler30
Table Source should be provided with records with "id" from 1 to 30 and names
reneging from source1 to source30

These tables and the dependent ones, are considered immutable and shouldn't be modified 
by the user or from the devSecOps during experiments.

**Create new tests**
- Split tests per domain (see folders acquisitions, crawlers etc)
- If more than 3 features in a folder, then split is sets
- Update gitlab to run in set separately to speed up the process

**Run docker**  
`docker-compose -f docker-compose-local.yml up`

- Update hosts file (C:\Windows\System32\drivers\etc)
  `127.0.0.1 host.docker.internal`
- Move to folder
  `dataCollection\data-collection-ui-test`
- Start docker compose __with proxy__. This will start karate container with HTTP and HTTPS proxy and keycloak container. Keycloak configuration can be found in /realm-config folder \
  `docker-compose up`  
- Start docker compose __without proxy__. This will start karate container and keycloak.  
  Karate will be connected to network without HTTP or HTTPS proxy
  Keycloak configuration can be found in /realm-config folder   
  `docker-compose -f docker-compose-local.yml up`

**Run local**
- To run the UI tests:   
`docker exec -it -w /src karate ./karate -e local ui-tests/`
- To run the API tests:   
`docker exec -it -w /src karate ./karate -e local api-tests/`
- To run an individual test:   
  `docker exec -it -w /src karate ./karate -e local api-tests/folder/WIH-XXX.feature`

**Run test locally against AWS environment**  
You have to be connected to the VPN and the call the karate_proxy script for execution
- To run the UI tests:   
  `docker exec -it -w /src karate ./karate_proxy -e development ui-tests/`
- To run the API tests:   
  `docker exec -it -w /src karate ./karate_proxy -e development api-tests/`
- To run an individual test:   
  `docker exec -it -w /src karate ./karate_proxy -e development api-tests/folder/WIH-XXX.feature`

**Common Errors**  
- OCI runtime exec failed: exec failed: container_linux.go:367: starting container process caused: exec: "/karate": stat /karate: no such file or directory: unknown  
  Solution  
  _On command line execute: dos2unix karate_  
