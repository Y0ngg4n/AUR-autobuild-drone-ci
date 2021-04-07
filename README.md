# Automated AUR Build Pipeline with Drone CI
This Repository wants to achieve a simple building of packages with Drone CI, Docker and Nexus.


# Prerequisites

- [Drone CI Instance](https://www.drone.io/)
- [Nexus Instance](https://www.sonatype.com/products/repository-oss?topnav=true)

# Installation

1. Fork the Repository
2. Connect Drone CI with your Git Repository and activate it
3. Clone your Repository
4. Remove ananicy package from the repository (it is just a example package)
5. Add the packages you want
```
git submodule add https://aur.archlinux.org/timeshift.git timeshift
```
6. Register the Packages you want in the _packages.txt_. You can add commands that should be executed first, before building the package with an ^. So for example if you want to install nano before installing timeshift register the package like this in the _packages.txt_ (every package in a single line).
7. Change the variables in the _buildDrone.sh_. For example the volumepath describes where the shared volume for all pipeline steps is mounted. This is important because this i later the name you add into your _pamac.conf_. Also change the _apiurl_ to the API URL of your Nexus Instance.
8. Change _buildjob.txt_ to your needs. So for example change the environemt variables to your Nexus instance and change the mountpoint in the commands to your repo name.
9. run _buildDrone.sh_ and push the changes to your repository.

10. Change timeout of the Drone Repository, because it may take longer than 60 minutes to build your packages.

11. Add anonymous role in your Nexus Repository so your raw Nexus Repository can be read by anybody.

The pipeline should build your packages and pushs the packages to your Nexus Raw Repository.
