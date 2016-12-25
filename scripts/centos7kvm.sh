#!/bin/sh

# USAGE EXAMPLE:
# sh centoskvm.sh centos-gold-master

# ensure script is being run as root
if [ `whoami` != root ]; then
   echo "ERROR: This script must be run as root" 1>&2
   exit 1
fi

# check for image name
if [ -z "$1" ]; then
	echo "ERROR: No argument supplied. Please provide the image name."
	exit 1
fi

# name of the image
IMGNAME=$1

# default kickstart file
KICKSTART="centos7-base.cfg"

# VM image file extension
EXT="qcow2"

# Location Repository
LOCATION="http://192.168.122.1/repo/CentOS/7/os/x86_64/"

echo "Generating VM ..."

# create image file
virt-install \
--name $IMGNAME \
--ram 2048 \
--cpu host \
--vcpus 1 \
--nographics \
--os-type=linux \
--os-variant=rhel7 \
--location=$LOCATION \
--initrd-inject=../kickstarts/$KICKSTART \
--extra-args="ks=file:/$KICKSTART text console=tty0 utf8 console=ttyS0,115200" \
--disk path=/var/lib/libvirt/images/$IMGNAME.$EXT,size=16,bus=virtio,format=qcow2 \
--force \
--noreboot

# change directory
#cd /var/lib/libvirt/images/

# reset, unconfigure a virtual machine so clones can be made
#virt-sysprep --format=qcow2 --no-selinux-relabel -a $IMGNAME.$EXT

# SELinux: relabelling all filesystem
#guestfish --selinux -i $IMGNAME.$EXT <<EOF
#sh load_policy
#sh 'restorecon -R -v /'
#EOF

# make a virtual machine disk sparse
#virt-sparsify --compress --convert qcow2 --format qcow2 $IMGNAME.$EXT $IMGNAME-sparsified.$EXT

# remove original image
#rm -rf $IMGNAME.$EXT

# rename sparsified
#mv $IMGNAME-sparsified.$EXT $IMGNAME.$EXT

# set correct ownership for the VM image file
#chown qemu:qemu $IMGNAME.$EXT

#echo "Process Completed. Use the 'virt start $IMGNAME' command to start the newly created VM."

#==============================================================================+
# END OF FILE
#==============================================================================+
