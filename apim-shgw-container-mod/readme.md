# Api Management Self-hosted gateway - Container Modifications

## Let APIM run with a custom user

```shell


```

## Helpers

```shell
# Download the SHGW image of choice and start it
docker run -it --name shgw_bash mcr.microsoft.com/azure-api-management/gateway:latest /bin/bash


# List users
cat /etc/passwd

# List groups
cat /etc/group

# Get current user
whoami

# Get the groups the current user belongs to
groups

# Create and connect to a new bash session in a docker container
docker container exec -it <container-name> /bin/bash
docker container exec -it shgw /bin/bash
# as root
docker container exec -u 0 -it shgw /bin/bash


```