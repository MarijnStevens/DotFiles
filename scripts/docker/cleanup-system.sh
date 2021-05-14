#!/bin/bash

# GO AWAY, bad guys.
$(docker rmi -f $(docker images -a -q))
