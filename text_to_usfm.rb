#!/usr/bin/env ruby

Dir.glob("**/*.txt") do |file|
  chap = []
  vers = []
  hash = {}
  h = Hash.new { |hash, key| hash[key] = [] }
  flag = false
  flag1 = false
  l2 = ""
  count = 0
  book_name = ""
  file_name = file

  directory_name = "output_folder"
  Dir.mkdir(directory_name) unless File.exists?(directory_name)

  output_name = "#{directory_name}/#{File.basename(file_name, '.*')}.usfm"
  output = File.open("#{output_name}", 'w:utf-8')

  text = File.open(file_name, "r:utf-8").read
  text.gsub!(/\r\n?/, "\n")

  book_name = "#{text.partition(" ").first}"

  text.each_line do |line|
    line.split("\r").each_with_index do |l, i|
      if l.include? "अध्याय"
        flag = true
        l2 = l.partition(" ").last
        count = 0
        vers = []
      end
      if flag and !(l.include? "अध्याय")
        count = 1
        if count != 0
          vers  << l
          h.store(l2, vers.delete_if{|x| x == "\n" })
        end
      end
      chap = []
    end
  end
  hash.store(book_name, h)

  hash.each do|k, v|
    output << "\\id #{k}\n"
    v.each do |k, v|
      output << "\\c #{k}"
      v.each do |k, v|
        output << "\\v #{k}"
      end
    end
  end
  output.close
end

