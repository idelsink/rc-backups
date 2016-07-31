# rc-backup

A simple tool to backup and restore configuration files to a certain directory.

This can be useful to synchronize configuration files files
via some kind of version control system.
For example GIT.  

## Usage

```text
Usage: rc-backup.rb [options] config.ini
    -g, --generate-config            generate config file
    -h, --help                       print help
    -r, --restore                    restore backups
    -v, --[no-]verbose               run verbosely
        --version                    show version
```

Make your own repo,
include this as a submodule or just an folder
and setup a configuration file that will sit inside the git repository.

Whenever you want to backup run

```sh
./rc-backup path_to_dir/rc-backup.ini
```

This will copy all the files from all the places into the backup location.  
When setting up a new machine,
just pull your repository with this script included
and run:

```sh
./rc-backup path_to_dir/rc-backup.ini --restore
```

This will backup all original files to a hidden folder in the script directory
and then it will restore all the backups to their relative places.

## Setup

```sh
git clone https://github.com/idelsink/rc-backup.git         # download the repository
sudo apt-get install ruby                                   # install ruby
sudo dnf install ruby                                       # or for rpm based machines
gem install iniparse optparse colorize fileutils            # install ruby packages `iniparse`, `optparse`, `colorize` and `fileutils`.
```

Setup a backup location with the configuration file.  
An example file can be generated with the following command:

```sh
touch path_to_dir/rc-backup.ini
./rc-backup --generate-config > path_to_dir/rc-backup.ini
```

## License

> You can check out the full license [here](./LICENSE)

This project is licensed under the terms of the **MIT** license.
