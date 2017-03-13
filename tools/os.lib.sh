#!/bin/sh


# OS: files, paths

# Combined dirname/basename to replace .ext
basepath()
{
	echo "$(dirname "$1")/$(basename "$1" "$2")$3"
}

# Id: node-sitefile/0.0.6-dev tools/os.lib.sh
