#!/bin/bash

curl -fsSL https://aka.ms/install-azd.sh | bash

dapr init
dapr --version