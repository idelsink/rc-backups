# rc-backups

My personal configuration backup/scripts repository.  
I'm using [rc-backup](https://github.com/idelsink/rc-backup)
to backup my files.

## install

```sh
git clone git@github.com:idelsink/rc-backups.git
# or
git clone https://github.com/idelsink/rc-backups.git

cd rc-backups
sudo dnf install ruby
# or
sudo apt-get install ruby

sudo gem install iniparse OptionParser colorize fileutils

# restore settings
./rc-backup/rc-backup.rb ./rc-backup.ini -r

# set alias in .bash_aliases_system
rc_backup_location="${HOME}/dir_to_repo"
alias   rc-backup='${rc_backup_location}/rc-backup/rc-backup.rb ${rc_backup_location}/rc-backup.ini'
alias   rc-backup-restore='${rc_backup_location}/rc-backup/rc-backup.rb ${rc_backup_location}/rc-backup.ini -r'
alias   rc-backup-cd='cd ${rc_backup_location}'
```

## side note

I do not intend to keep this as a nicely laid out repository.  
This is purely functional to backup my settings and possible share my scripts.

I'm sure that all my commit messages will be short and not interesting.  
For That reason, please don't judge.

## License

> You can check out the full license [here](./LICENSE)

This project is licensed under the terms of the **MIT** license.
