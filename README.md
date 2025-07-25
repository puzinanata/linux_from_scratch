#### This is project by book Linux from scratch to develop my own distributive to run my site:


- `main.sh` for main logic
- `steps/` for installation scripts step by step

#### to run project : 
docker run -d --privileged                              \
     -v /home/puzinanata/linux_from_scratch:/home/lfs   \
     -v /var/lib/lfs:/var/lib/lfs                       \
     -v /mnt/new_root_dir/:/mnt/new_root_dir/           \
     -v /dev:/dev                                       \
      debian bash -c 'cd /home/lfs/; time bash main.sh'


#### To clean system and disk after unfinished/ unsuccessful installation
losetup -f --show "/var/lib/lfs/lfs.img" # to check name of disk for lfs

losetup -D /dev/loopXX       # Detach disk from output this command losetup -f --show "/var/lib/lfs/lfs.img"

rm -fv /var/lib/lfs/lfs.img    # Delete the image


