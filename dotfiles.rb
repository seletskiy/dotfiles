#!/usr/bin/env ruby

require 'fileutils'
require 'tempfile'

def ensure_dir(file_name)
    dir_name = File.dirname(file_name)
    `mkdir -p #{dir_name}`
end

def install_file(source, destination, rejoin)
    if destination.start_with?('/rootfs')
        destination = destination[7..-1]
        rootfs = true
    else
        rootfs = false
    end

    destination = File.expand_path(destination)

    if File.exist?(destination)
        if File.realdirpath(source) == File.realdirpath(destination)
            return
        end

        if FileUtils.identical?(source, destination)
            return
        end
    end

    if rejoin
        `sudo cp #{destination} #{source}`
    elsif rootfs
        puts("sudo cp: #{source} -> #{destination}")
        `sudo cp #{source} #{destination}`
    else
        puts("symlink: #{source} -> #{destination}")
        `ln -Tsf #{File.realdirpath(source)} #{destination}`
    end
end

def install_template(source, destination, rejoin)
    ensure_dir(source)

    destination = File.expand_path(destination)
    if not rejoin and File.exist?(destination)
        if File.ctime(destination) >= File.ctime(source)
            return
        end
    end

    puts("generating: #{destination}")

    destination_temp = Tempfile.new('dotfiles')
    if rejoin
        filtered_source = File.open(source).each_line()
        filtered_destination = File.open(destination).each_line()
    end

    values = {}
    File.open(source).each_line() do |line|
        placeholder = nil
        if rejoin
            line = line.split(/{{.+?}}/).map{|p| Regexp.escape(p)}.join('.*')
        else
            while line =~ /({{.+?}})/
                placeholder = $1
                if placeholder =~ /PASSWORD/
                    flag = 's'
                else
                    flag = ''
                end

                value = values[placeholder]
                if not value
                    value = `read -#{flag}p"#{placeholder}: " && echo -n $REPLY`
                    values[placeholder] = value
                end

                if flag == 's'
                    puts
                end

                line = line.sub(Regexp.escape(placeholder), value)
            end
        end

        if rejoin and placeholder
            filtered_source = filtered_source.select{|l| not l[/^#{line}$/]}
            filtered_destination = filtered_destination.select{|l| not l[/^#{line}$/]}
        else
            destination_temp.write(line)
        end
    end

    p 'SOURCE'
    puts filtered_source

    destination_temp.close()

    `mv #{destination_temp.path} #{destination}`
end

def main
    if ARGV[1] == nil
        puts "usage goes here"
        exit
    end

    profile = ARGV[0]
    rejoin = ARGV[1] == 'rejoin'

    placeholder_expanded = 'xxx'
    placeholder_base = nil
    `git ls-files`.split("\n").each() do |file_name|
        target_dir = '~/'
        if file_name.start_with?('rootfs/')
            target_dir = '/'
        end

        case file_name
        when /README/
            # skip readme
        when /^[^\/]+\.rb$/
            # skip self
        when /(.*)\.(\$.*$)/
            placeholder_base = $1
            placeholder_expanded = file_name.sub($2, profile)
        when /^#{placeholder_expanded}$/
            install_file(file_name, target_dir + placeholder_base, rejoin)
        when /^#{placeholder_base}\./
            # skip
        when /\.template$/
            install_template(file_name,
                target_dir + file_name.sub(/\.template$/, ''), rejoin)
        else
            install_file(file_name, target_dir + file_name, rejoin)
        end
    end

    if rejoin
        exec('git status -s')
    end
end

main()
