# rc-backups

My personal configuration backup repository.  
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
alias   rc-backup='~/dir_to_repo/rc-backups/rc-backup/rc-backup.rb ~/dir_to_repo/rc-backups/rc-backup.ini'
```

## side note

I do not intend to has this as a nicely laid out repository.  
I'm sure that all my commit messages will be short and not that interesting.  
For That reason, please don't judge.

## License

> You can check out the full license [here](./LICENSE)

This project is licensed under the terms of the **MIT** license.
