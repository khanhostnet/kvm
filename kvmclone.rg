require 'optparse'
require 'Mymod'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: opt_parser COMMAND [OPTIONS]"
  opt.separator  ""
  opt.separator  "Commands"
  opt.separator  "     start: start server"
  opt.separator  "     stop: stop server"
  opt.separator  "     restart: restart server"
  opt.separator  "     veri_node_match_email: to match your email ticket host with current host, this you need to copy and paste on the close lun ticket on tmp/lun_email"
  opt.separator  "     getwwns: igetwwwns4u"
  opt.separator  "     getnewdisk: iget new disk"
  opt.separator  "     verifywwns: verify"
  opt.separator  "     veripath: verify path"
  opt.separator  "     lower: lower case file. example: mygem.rb lower CAP_FILE"
  opt.separator  "     sudolipvg: sudo create lvm for you accourding to company rule"
  opt.separator  "     sudolipclone: sudo clone lip image"
  opt.separator  "     sudosetlipnet: sudo set lip network for you"
  opt.separator  ""
  opt.separator  "Options"

  opt.on("-e","--environment ENVIRONMENT","which environment you want server run") do |environment|
    options[:environment] = environment
  end

  opt.on("-d","--daemon","runing on daemon mode?") do
    #options[:daemon] = true
    puts "fork daemon"
  end

  opt.on("-h","--help","help") do
    puts opt_parser
  end
end

opt_parser.parse!

case ARGV[0]
when "start"
  puts "call start on options #{options.inspect}"
when "stop"
  puts "call stop on options #{options.inspect}"
when "restart"
  puts "call restart on options #{options.inspect}"
when "getwwns"
  puts "call getwwns on options "
  mywwns=Mymod.getwwns
  puts mywwns
when "veri_node_match_email"
  puts "call veri_node_match_email on options "
  mynode=Mymod.veri_node_match_email
  puts mynode
when "getnewdisk"
  puts "call getnewdisk on options "
  mywwns=Mymod.getnewdisk
  puts mywwns
when "veripath"
  puts "call veripath on options "
  veripath=Mymod.veripath
  puts veripath
when "verifywwns"
  puts "call verify wwn on options "
  myverify=Mymod.verifywwns
  puts myverify
when "lower"
  #puts "call lower option"
  fh=ARGV.last
  result=`python newplylower #{fh}`
  puts result


when "sudolipvg"
  puts "call sudo create pv, vg and logical volume"
  lipvg=Mymod.sudolipvg

when "sudolipclone"
  puts "call clone"
  p=IO.popen("perl sudolipclone").readlines
  puts p

when "sudosetlipnet"
  puts "call setlip network"
  p=IO.popen("perl sudosetlipnet.pl").readlines

  #def verifywwns(lunid)
  #try to get user input lunid and verify if this has only one last 4 digit id exist
  #    lunid = ARGV[1]
  #    #p=IO.popen("ls /dev/mapper/|grep 0150|wc -l").readlines
  #    puts lunid
  #    p=IO.popen("ls /dev/mapper/|grep #{lunid}|wc -l").readlines
  #    n=p[0]
  #    i=n.to_i
  #    if i == 1
  #         puts "verify ok"
  #    else
  #        puts "not able to verify, exit program now"
  #        exit 7

  #    end
  #end
  #lunid = ARGV[1]
  #verifywwns(lunid)
  #puts verify
else
  puts opt_parser
end
