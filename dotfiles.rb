#!/usr/bin/env ruby

require 'fileutils'
require 'tempfile'

def main(profile, action)
    if action == nil
        puts "usage goes here"
        exit
    end

    rejoin = action == 'rejoin'

    placeholder_expanded = 'xxx'
    placeholder_base = nil
    `git ls-files`.split("\n").each() do |file_name|
        target_dir = File.expand_path('~/')
        if file_name.start_with?('rootfs/')
            target_dir = '/'
        end

        case file_name
        when /README/
            # skip readme
        when /(dotfiles|bootstrap).rb$/
            # skip self
        when /(.*)\.(\$.*$)/
            placeholder_base = $1
            placeholder_expanded = file_name.sub($2, profile)
        when /^#{placeholder_expanded}$/
            install_file(file_name, target_dir + placeholder_base)
        when /^#{placeholder_base}\./
            # skip
        when /\.template$/
            install_template(file_name,
                target_dir + file_name.sub(/\.template$/, ''))
        else
            install_file(file_name, target_dir + file_name)
        end
    end

    if rejoin
        exec('git status -s')
    end
end

def ensure_dir(file_name)
    dir_name = File.dirname(file_name)
    `mkdir -p #{dir_name}`
end

def remove_rootfs_prefix(source)
    if source.start_with?('/rootfs')
        return source[6..-1], true
    else
        return source, false
    end
end

def files_are_identical(source, destination)
    if not File.exist?(destination)
        return false
    end

    if FileUtils.identical?(source, destination)
        return true
    end

    return false
end

def install_file(source, destination)
    destination, rootfs = remove_rootfs_prefix(destination)

    if files_are_identical(source, destination)
        return
    end

    if rootfs
        puts("sudo cp: #{source} -> #{destination}")
        `sudo cp #{source} #{destination}`
    else
        puts("symlink: #{source} -> #{destination}")
        `ln -Tsf #{File.realdirpath(source)} #{destination}`
    end
end

def rejoin_file(source, destination)
    destination, _ = remove_rootfs_prefix(destination)
    if File.exist?(destination)
        `cp #{destination} #{source}`
    end
end

def get_user_input(prompt, silent)
    flag = silent ? 's' : ''
    value = `read -#{flag}p"#{promopt}" && echo -n $REPLY`
    if silent
        puts
    end
    return value
end

def is_file_newer(source, destination)
    if not File.exist?(destination)
        return true
    end

    if File.ctime(destination) >= File.ctime(source)
        return false
    end

    return true
end

def filter_lines(lines, template)
    return lines.select{|l| not l[/^#{template}$/]}
end

def rejoin_template(source, destination)
    if not File.exist?(destination)
        return
    end

    filtered_source = File.open(source).each_line()
    filtered_destination = File.open(destination).each_line()

    File.open(source).each_line() do |line|
        pattern = line.split(/{{.+?}}/).map{|p| Regexp.escape(p)}.join('.*')

        if pattern[/\.\*/]
            filtered_source = filter_lines(filtered_source, pattern)
            filtered_destination = filter_lines(filtered_destination, pattern)
        end
    end

    s = Tempfile.new('dotfiles_s')
    d = Tempfile.new('dotfiles_d')

    s.write(filtered_source.join("\n"))
    d.write(filtered_destination.join("\n"))

    s.close()
    d.close()

    puts `diff #{s.path} #{d.path}`
end

def query_all_placeholders(line, cache)
    while line =~ /({{.+?}})/
        placeholder = $1

        value = cache[placeholder]
        if not value
            value = get_user_input("#{placeholder}: ",
                placeholder =~ /PASSWORD/)
            cache[placeholder] = value
        end

        line = line.sub(placeholder, value)
    end

    return line
end

def install_template(source, destination)
    ensure_dir(source)

    if not is_file_newer(source, destination)
        return
    end

    puts("generating: #{destination}")

    destination_temp = Tempfile.new('dotfiles')

    cache = {}
    File.open(source).each_line() do |line|
        destination_temp.write(query_all_placeholders(line, cache))
    end

    destination_temp.close()

    `mv #{destination_temp.path} #{destination}`
end

main(ARGV[0], ARGV[1])
