export USER=ubuntu
export PASSWORD=ubuntu 
export UID=1000
export GID=1000
export NVIDIA_VISIBLE_DEVICES=all
export NVIDIA_DRIVER_CAPABILITIES=all
export HTTPS_CERT=/etc/ssl/certs/ssl-cert-snakeoil.pem
export HTTPS_CERT_KEY=/etc/ssl/private/ssl-cert-snakeoil.key
export VGL_DISPLAY=egl
export REMOTE_DESKTOP=kasmvnc
export VNC_THREADS=2

bash /docker_config/entrypoint_autodl.sh