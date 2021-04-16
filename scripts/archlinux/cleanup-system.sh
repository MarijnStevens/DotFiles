#!/bin/bash
# Cleanup orphan packages.

sudo pacman -Rs $(pacman -Qqtd) 
