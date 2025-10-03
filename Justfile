@default:
	just --list

build oci_name="ghcr.io/digabi/digabi2-bootc" oci_version="latest" raw_name="digabi2-bootc.raw":
	podman build . \
		--tag "{{ oci_name }}" \
		--build-arg BUILD_REVISION=$(git rev-parse --short --verify HEAD) \
		--build-arg BUILD_TIMESTAMP=$(date -Iseconds)
	truncate -s 8G "{{ raw_name }}"
	podman run \
		--rm \
		--privileged \
		--pid=host \
		--security-opt label=type:unconfined_t \
		-v /dev:/dev \
		-v /var/lib/containers:/var/lib/containers \
		-v .:/output \
		"{{ oci_name }}":"{{ oci_version }}" \
			bootc install to-disk \
				--generic-image \
				--karg=quiet --karg=rhgb \
				--via-loopback \
				--filesystem btrfs \
				--wipe /output/"{{ raw_name }}"

run raw_name="digabi2-bootc.raw":
	(sleep 30 && xdg-open "http://localhost:8006") & \
	( \
		(podman kill --signal 9 $(podman ps --filter label=fi.digabi.digabi2-bootc --format '{''{.ID}''}') || true) && \
		podman run \
			--rm \
			--privileged \
			--publish "127.0.0.1:8006:8006" \
			--env "CPU_CORES=4" \
			--env "RAM_SIZE=8G" \
			--env "DISK_SIZE=16G" \
			--env "TPM=Y" \
			--env "GPU=Y" \
			--device=/dev/kvm \
			--volume ./"{{ raw_name }}":"/boot.raw" \
			--label fi.digabi.digabi2-bootc \
			docker.io/qemux/qemu \
	)
