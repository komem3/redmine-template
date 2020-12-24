#!/bin/bash

# Usage:
# ./deirectory_hash.sh $directory

ls $1/* | git hash-object --stdin-paths | git hash-object --stdin
