#!/bin/bash

#TARGET="aarch-unknown-linux-gnueabi" R3/4 64build
#TARGET="armv7-unknown-linux-gnueabif" # R2/R3
TARGET="arm-unknown-linux-gnueabif" # R 0/1

cargo build --target=$TARGET
