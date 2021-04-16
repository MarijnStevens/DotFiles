#!/bin/bash

pacman -Qqd | awk -f process-package.awk 

