sudo mount --bind /mnt/hd /srv/nfs/hd
sudo exportfs -rav
systemctl start nfs-server
