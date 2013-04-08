kvm
===

kvm guest deployment with virsh and ruby

this is high level step to build guest:

1. create LUNs  (optional, depending on what your envirometn's requirement.)
I put the hostname, guest Lun, and Guest application LUN in a configuration file to be call from the script.
for example,  my batch.lip looks like this:
cat batch.lip

lip178a1        e18b    e07c

lip179a1        e18c    e07d

lip180a1        e151    e06e

lip182a1        e183    e071

lip183a1        e184    e079

lip184a1        e185    e07a

#step 1, create pv, vg and lv
$ruby mygem.rb  sudolipvg
call sudo create pv, vg and logical volume
create first root lv
Password:
  Writing physical volume data to disk "/dev/mapper/36005076308ffc75d000000000000e18b"
create first app lv
  Writing physical volume data to disk "/dev/mapper/36005076308ffc75d000000000000e07c"
creating second app lv

#step 2. clone image
$ ruby mygem.rb  sudolipclone
call clone
Password:








