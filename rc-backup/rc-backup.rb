#!/usr/bin/env ruby
##########################################################################
# script name: rc-backup
# script version: 1.0.0
# script date: 30 Juli 2016
# website: https://github.com/idelsink/rc-backup
##########################################################################
#
# A simple script to backup configuration files to a certain directory.
#
##########################################################################
# MIT License
#
# Copyright (c) 2016 Ingmar Delsink
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##########################################################################
# --- include files -------------------------------------------------
begin
    require 'iniparse'
rescue LoadError
    abort("error while loading 'iniparse'")
end
begin
    require 'optparse'
rescue LoadError
    abort("error while loading 'optparse'")
end
begin
    require 'colorize'
rescue LoadError
    abort("error while loading 'colorize'")
end
begin
    require 'fileutils'
rescue LoadError
    abort("error while loading 'fileutils'")
end
# -------------------------------------------------------------------
class RCbackup
    # @description backup files to a directory
    # the config_file is in a .ini format.
    # see the example directory for an example
    def initialize(config_file)
        @_home = File.expand_path('~')
        @_backup_dir=""
        @_config_file=""
        @_ini=""
        raise ArgumentError, "no config file given".red if is_empty(config_file)
        raise ArgumentError, "supplied config file doesn't exists".red if ! file_exists(config_file)
        @_config_file=config_file
        begin
            @_ini = IniParse.parse( File.read(@_config_file) ) # load file
        rescue IniParse::IniParseError
            puts "Error parsing the INI file".red
            @_ini = ""
        end
    end
    def backup()
        process_backup(true)
    end
    def restore()
        process_backup(false)
    end

    private
    @_home
    @_backup_dir
    @_config_file
    @_ini
    def file_exists(file)
        return File.exist?(file)
    end
    def is_empty(string)
        if string.to_s.empty?
            return true
        elsif string == ''
            return true
        end
        return false
    end
    def copy_with_path(src, dst, overwrite=false)
        FileUtils.mkdir_p(File.dirname(dst))
        if overwrite
            FileUtils.copy_entry(src, dst, remove_destination=true)
        else
            FileUtils.cp(src, dst)
        end
    end
    def process_backup(backup)
        # run the backup/restore
        # backup = true: backup
        # backup = false: restore
        return 1 if is_empty(@_ini)
        @_ini.to_hash.each do |section, hash|
            if section == 'GLOBAL'
                # set backup directory
                if ! is_empty(hash.fetch("backup-directory", "").gsub('"', ''))
                    @_backup_dir=File.expand_path(hash.fetch("backup-directory", "").gsub('"', ''))
                else
                    @_backup_dir=File.dirname(File.expand_path(@_config_file))
                end
            else
                disable = hash.fetch("disable", "")
                if disable != true
                    puts "[#{section}]".light_black
                    files = hash.fetch("file", "")
                    unless files == ''
                        files_arr = []
                        if files.kind_of?(Array)
                            files_arr += files
                        else
                            files_arr << files
                        end
                        for file in files_arr
                            file = File.expand_path(file.gsub('"', ''))
                            if file =~ /^#{@_home}/
                                # file resides in the home dir
                                # path format:
                                # backupdir/_USER_/sectionname/pathtofile minus userhomedir
                                backup_file = "#{@_backup_dir}/_USER_/#{section}/#{file.sub("#{@_home}/", "")}"
                                # original backup location:
                                # scriptdir/.oldfiles/sectionname/pathtofile
                                original_backup = "#{File.expand_path(File.dirname(__FILE__))}/.oldfiles/#{section}#{file}"
                                if backup # backup
                                    if file_exists(file)
                                        puts "backup "+"'#{file}'".light_cyan+" -> "+"#{backup_file}".blue
                                        # copy file to backup (overwrite? yes)
                                        copy_with_path(file, backup_file, true)
                                    else
                                        puts "file '#{file} does not exists'".red
                                    end
                                elsif ! backup # restore
                                    if file_exists(backup_file)
                                        # check if file in original exists
                                        if ! file_exists(original_backup)
                                            if file_exists(file)
                                                puts "making backup of original file -> "+"#{original_backup}".green
                                                copy_with_path(file, original_backup)
                                            end
                                        end
                                        # copy backup to file (overwrite? yes?)
                                        puts "restore "+"'#{file}'".blue+" <- "+"'#{backup_file}'".light_cyan
                                        copy_with_path(backup_file, file, true)
                                    else
                                        puts "backup '#{backup_file} does not exists'".red
                                    end
                                end
                            else
                                # file does not resides in the home dir
                                # (root or something)
                                # path format:
                                # backupdir/sectionname/pathtofile
                                backup_file = "#{@_backup_dir}/#{section}#{file}"
                                # original backup location:
                                # scriptdir/.oldfiles/sectionname/pathtofile
                                original_backup = "#{File.expand_path(File.dirname(__FILE__))}/.oldfiles/#{section}#{file}"
                                if backup # backup
                                    if file_exists(file)
                                        puts "backup "+"'#{file}'".light_cyan+" -> "+"#{backup_file}".blue
                                        # copy file to backup (overwrite? yes)
                                        copy_with_path(file, backup_file, true)
                                    else
                                        puts "file '#{file} does not exists'".red
                                    end
                                elsif ! backup # restore
                                    if file_exists(backup_file)
                                        # check if file in original exists
                                        if ! file_exists(original_backup)
                                            if file_exists(file)
                                                puts "making backup of original file -> "+"#{original_backup}".green
                                                copy_with_path(file, original_backup)
                                            end
                                        end
                                        # copy backup to file (overwrite? yes?)
                                        puts "restore "+"'#{file}'".blue+" <- "+"'#{backup_file}'".light_cyan
                                        copy_with_path(backup_file, file, true)
                                    else
                                        puts "backup '#{backup_file} does not exists'".red
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

# --- process arguments --------------------------------------------------
ARGV << '-h' if ARGV.empty? # no arguments? show help
options = {}
OptionParser.new do |opts|
    opts.version = "1.0.0"
    opts.program_name="rc-backup"
    opts.banner = "Usage: rc-backup.rb [options] config.ini"
    opts.on("-g", "--generate-config", "generate config file") do |g|
        config=[
            "; rc-backup configuration file.",
            "; github.com/idelsink/rc-backup",
            "",
            "[GLOBAL]",
            "backup-directory=\"\" ; if none set, directory of this file is used",
            "",
            "; for sorting, different sections can be used",
            ";[example-set]",
            ";disable=false               ; set this to true and this section will be disabled/ignored",
            ";file=\"~/.bashrc\"            ; example of a use case",
            ";file=\"/home/user/.bashrc\"   ; this yields the same result as above"
        ].join("\n") + "\n"
        puts config
        exit 0
    end
    opts.on("-h", "--help", "print help") do |h|
        opts.summarize([], opts.summary_width, opts.summary_width ) { |helpline|
            puts helpline
        }
        exit 0
    end
    opts.on("-r", "--restore", "restore backups. Before the files are restored,\
    \n                                     the original files will be backed up to the \
    \n                                     folder displayed on screen.") do |r|
        options[:restore] = r
    end
    opts.on("-v", "--[no-]verbose", "run verbosely") do |v|
        options[:verbose] = v
    end
    opts.on("--version", "show version") do
        puts "#{opts.program_name} v#{opts.version}"
        exit 0
    end
end.parse!

# --- start of main body -------------------------------------------------
begin
    rc_backup = RCbackup.new(ARGV[0])
    if (options[:"restore"] == true)
        rc_backup.restore
    else
        rc_backup.backup
    end
rescue Exception => e
    puts e.message
    puts "backtrace:\n\t#{e.backtrace.join("\n\t")}"
end
