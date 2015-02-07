Basalt
======
Project Manager for Moon

## USAGE
```bash
basalt new NAME
# this will create a new basalt ready project
```

## CHANGELOG
* 07/02/2015
  * module(s) -> package(s)
  * Basaltmods -> Basaltfile

    This change affects the entire codebase and CLI app, from here on,
    modules are not reffered to as packages instead.
    NOTE: no effort has been made to make this backwards compatable with
          the "modules" convention used previoiusly.

    ```bash
      basalt package new
        # new command for quickly creating new packages
      basalt package install
        # install a package into an existing project, this will read
        # an existing Basaltfile and install the package to the directory
        # specified
      basalt package uninstall
        # revserse of install, removes a package from the project
      basalt package sync
        # removes old packages and installs new packages
      basalt package update
        # same as sync
      basalt package list
        # lists both the available and installed packages, packages are
        # color-coded based on their state
      basalt package list-available
        # lists all available packages in the repo.
      basalt package list-installed
        # lists all currently installed packages in the project.
        # NOTE: this will only read the existing Basaltfile and report what
        #       has been chosen.
        #       The package, MAY or MAY NOT be installed at all until basalt
        #       package update has been ran
    ```

