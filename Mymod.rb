module Mymod

def self.getwwns()
  getwwns=`/opt/scripts/unix/getwwns`
end

def self.veri_node_match_email()
  #make sure the hostname in the email ticket is match with my assignment by current hostname,  this is a safety check if I work with many build at the same time
  p=IO.popen("grep 'Web Storage Request' tmp/lun_email |awk '{print $5}'").readlines.map(&:chomp).to_s
  #and alsol, I am working on to do away with the grep, used ruby native cmd. but for now I just want fast and dirty.
  c=IO.popen("hostname").readlines.map(&:chomp).to_s
  if c == p
    puts "#{p} hostname match between email ticket and current host, you are good to go."
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

def self.sudolirvg()
#create pv, vg and lv for the lun
  liparray =File.open("batch.lir").readlines
    mod="_m"
    dev="_d"
    reg="_r"
    prod="_p"
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
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/vgcreate #{node}#{reg}#{appfs} #{mapper}#{applun}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/lvcreate -l 100%PVS -n #{applun}  #{node}#{reg}#{appfs} #{mapper}#{applun}").readlines

  #now create the second applun
    puts "creating second app lv"
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/pvcreate #{mapper}#{applun2}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/vgcreate #{node}#{reg}#{appfs2} #{mapper}#{applun2}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/lvcreate -l 100%PVS -n #{applun2}  #{node}#{reg}#{appfs2} #{mapper}#{applun2}").readlines

  end
end

def self.sudolipvg()
#create pv, vg and lv for the lun
  liparray =File.open("batch.lip").readlines
    mod="_m"
    dev="_d"
    reg="_r"
    prod="_p"
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
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/vgcreate #{node}#{prod}#{appfs} #{mapper}#{applun}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/lvcreate -l 100%PVS -n #{applun}  #{node}#{prod}#{appfs} #{mapper}#{applun}").readlines

  #now create the second applun
    puts "creating second app lv"
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/pvcreate #{mapper}#{applun2}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/vgcreate #{node}#{prod}#{appfs2} #{mapper}#{applun2}").readlines
    p = IO.popen("sudo /opt/scripts/sudo/unixspt/lvcreate -l 100%PVS -n #{applun2}  #{node}#{prod}#{appfs2} #{mapper}#{applun2}").readlines

    end
  end

end
