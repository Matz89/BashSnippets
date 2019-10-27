This tool will execute a given command on multiple servers

This will execute all args as a single cmd on each server listed in ./servers.txt (default)
Will execute as the user providing the command (cannot run as root)

Options:

-f FILE to override default ./servers.txt file

-n to perform a dry run.  Commands will be displayed instead of executed

-s Runs command as superuser on remote servers

-v Enable verbose mode


