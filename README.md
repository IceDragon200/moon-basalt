Basalt
======
Project Manager for Moon

## USAGE
```bash
basalt new NAME
# this will create a new basalt ready project
```

## CHANGELOG
* 12/02/2015 (0.10.1)
  * Added install_method setting for Basaltfile

    This allows the changing of the installation method for packages, by
    default this is 'ref', which means to symlink the package into the current
    package.
    Use 'copy' to copy the package instead.
    ```
    set install_method: 'copy'

    # insert your packaging here
    ```

    Please note you can overload the install_method per package by including
    it as an option.

    ```
    set install_method: 'copy'

    pkg 'my-awesome-package', install_method: 'ref' # will be symlinked from the repo
    pkg 'my-notso-awesome-package' # will be copied from the repo
    ```

  * New CLI options
    * -v, --verbose

      Verbose can be very talky, this is helpful when you need to debug its
      cluttered internals.

    * -i, --install-method=METHOD

      As with the previous addition, `install`, `update`, `sync` commands now
      use the --install-method option.

      ```
      basalt install -i copy
      ```

* 07/02/2015 (0.10.0)
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

