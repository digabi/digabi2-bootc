

@default:
	just --list

build:
	podman build . -t localhost/lmao
	truncate -s 10G lol.raw
	podman run --rm --privileged --pid=host --security-opt label=type:unconfined_t -v /dev:/dev -v /var/lib/containers:/var/lib/containers -v .:/output localhost/lmao:latest bootc install to-disk --generic-image --via-loopback --filesystem btrfs --wipe /output/lol.raw

run:
	qemu-system-x86_64 -enable-kvm -M q35 -cpu host -smp 6 -m 4G -net nic,model=virtio -net user,hostfwd=tcp::2222-:22 -display gtk,show-cursor=on -drive format=raw,file=lol.raw
