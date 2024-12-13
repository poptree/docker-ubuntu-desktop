export USER=ubuntu
export PASSWORD=ubuntu 
export GID=1000
export NVIDIA_VISIBLE_DEVICES=all
export NVIDIA_DRIVER_CAPABILITIES=all
export HTTPS_CERT=/etc/ssl/certs/ssl-cert-snakeoil.pem
export HTTPS_CERT_KEY=/etc/ssl/private/ssl-cert-snakeoil.key
export VGL_DISPLAY=egl
export REMOTE_DESKTOP=kasmvnc
export VNC_THREADS=2

if [ ! -f "/docker_config/init_flag" ]; then
    # set python is python3
    update-alternatives --install /usr/bin/python python /usr/bin/python3 2
    # update /etc/environment
    export PATH=/usr/NX/scripts/vgl:$PATH
    env | grep -Ev "CMD=|PWD=|SHLVL=|_=|DEBIAN_FRONTEND=|USER=|HOME=|UID=|GID=|PASSWORD=" > /etc/environment
    # create user
    groupadd -g $GID $USER
    useradd --create-home --no-log-init -u 1000 -g $GID $USER
    usermod -aG sudo $USER
    usermod -aG ssl-cert $USER
    echo "root:$PASSWORD" | chpasswd
    echo "$USER:$PASSWORD" | chpasswd
    chsh -s /bin/bash $USER
    # extra env init for developer
    if [ -f "/docker_config/env_init.sh" ]; then
        bash /docker_config/env_init.sh
    fi
    # custom env init for user
    if [ -f "/docker_config/custom_env_init.sh" ]; then
        bash /docker_config/custom_env_init.sh
    fi
    echo  "ok" > /docker_config/init_flag
fi

/etc/init.d/dbus start

if [ ! -f "/home/$USER/.vnc/passwd" ]; then
    su $USER -c "echo -e \"$PASSWORD\n$PASSWORD\n\" | kasmvncpasswd -u $USER -o -w -r"
fi
rm -rf /tmp/.X1000-lock /tmp/.X11-unix/X1000
# start kasmvnc
su $USER -c "kasmvncserver :1000 -select-de xfce -interface 0.0.0.0 -websocketPort 4000 -cert $HTTPS_CERT -key $HTTPS_CERT_KEY -RectThreads $VNC_THREADS"
su $USER -c "pulseaudio --start"
tail -f /home/$USER/.vnc/*.log
su $USER -c "code-server --cert $HTTPS_CERT --cert-key $HTTPS_CERT_KEY --bind-addr=0.0.0.0:5000 &"