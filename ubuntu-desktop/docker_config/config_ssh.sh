# RUN mkdir -p /var/run/sshd && \
#     sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
#     sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd && \
      sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
      cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
      echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
      mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config 
# mkdir -p /var/run/sshd && \
#       sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
#       cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
#       echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
#       mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config && \
#       sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd