#!/usr/bin/env ruby

chap = []
vers = []
hash = {}
h = Hash.new { |hash, key| hash[key] = [] }
flag = false
file_name = ARGV[0]
l2 = ""
count = 0
book_name = ""
output_name = "#{File.basename(file_name, '.*')}.usfm"

output = File.open(output_name, 'w:utf-8')
	File.open(file_name, "r:utf-8") do |file|
	  book = file.first
	  book_name = "#{book.partition(" ").first}"

	  file.each_with_index do |line,i|
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

