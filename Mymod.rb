module Mymod

def self.getwwns()
  getwwns=`/opt/scripts/unix/getwwns`
end

def self.veri_node_match_email()
  #make sure the hostname in the email ticket is match with my assignment by current hostname,  this is a safety check if I work with many build at the same time
  p=IO.popen("grep Request tmp/lun_email |awk '{print $5}'").readlines.map(&:chomp).to_s
  #and alsol, I am working on to do away with the grep, used ruby native cmd. but for now I just want fast and dirty.
  c=IO.popen("hostname").readlines.map(&:chomp).to_s
  if c == p
    puts "hostname match between email ticket and current host, you are good to go."
  else
    puts "hostname not match.  Please manually verify the ticket before proceed"
  end
end

def self.getnewdisk()
  getnewdisk=`sudo /opt/scripts/sudo/unixspt/getnewdisk`
end

def self.veripath()
  mypath=File.open("tmp/CAP_LUN").readlines.to_s.downcase
  for name in mypath
    result=`ls /dev/mapper/|grep #{name}`
    puts result
  end
end



def self.sudolipclone()
  node =File.open("batch.lip").readlines.to_s.downcase
  for name, oslun, applun in node.split(' ')
    puts oslun
  end
end

def self.sudolipvg()
#create pv, vg and lv for the lun
  liparray =File.open("batch.lip").readlines
    mod="_m"
    dev="_d"
    reg="_r"
    pro="_p"
  for line in liparray
  node, oslun, applun, applun2 = line.split(' ')
# the following line is just to test the print capture
    rootvg="_rootvg"
    oslun=`cat tmp/oslun`.chomp
    mypath=`ls /dev/mapper/|grep #{oslun}`
    lunpath=mypath.sub(/....$/, '').chomp
    mapper="/dev/mapper\/" + lunpath
    oslv="_oslv"
    appfs="appjfs_1_l"
    appfs2="appjfs_2_l"
    puts "create first root lv"
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/pvcreate #{mapper}#{oslun}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/vgcreate #{node}#{rootvg} #{mapper}#{oslun}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/lvcreate -l 100%PVS -n #{oslun}#{oslv} #{node}#{rootvg}").readlines
   #now we do applun
    puts "create first app lv"
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/pvcreate #{mapper}#{applun}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/vgcreate #{node}#{pro}#{appfs} #{mapper}#{applun}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/lvcreate -l 100%PVS -n #{applun}  #{node}#{pro}#{appfs} #{mapper}#{applun}").readlines

  #now create the second applun
    puts "creating second app lv"
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/pvcreate #{mapper}#{applun2}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/vgcreate #{node}#{pro}#{appfs2} #{mapper}#{applun2}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/lvcreate -l 100%PVS -n #{applun2}  #{node}#{pro}#{appfs2} #{mapper}#{applun2}").readlines

  end
end

def self.verifywwns()
  #try to get user input lunid and verify if this has only one last 4 digit id exist
  #lunid = ARGV[0]
  p=IO.popen("ls /dev/mapper/|grep 0150|wc -l").readlines
  #p=IO.popen("ls /dev/mapper/|grep #{lunid}|wc -l").readlines
  n=p[0]
  i=n.to_i
  if i == 1
    puts "verify ok"
  else
    puts "not able to verify, exit program now"
    exit 7
  end
end
end
