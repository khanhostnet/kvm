if ARGV.size < 1
        print "Argument must be provide with the this program to work
       for example: lower.rb Filename\n\n"

else

userinput = ARGV[0]
fileHandle= File.read(userinput)
puts  fileHandle.to_s.downcase
end
