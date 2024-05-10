# Use a base image with the desired OS (e.g., Ubuntu, Debian, etc.)
FROM ubuntu:latest
# Install SSH server
RUN apt-get update && \
 apt-get install -y openssh-server
# Create an SSH user
RUN useradd -rm -d /home/inofensivo -s /bin/bash -g root -G sudo -u 1000 inofensivo
# Set the SSH user's password (replace "password" with your desired password)
RUN echo 'inofensivo:password' | chpasswd
# Allow SSH access
RUN mkdir /var/run/sshd
# Expose the SSH port
EXPOSE 22
# Start SSH server on container startup
CMD ["/usr/sbin/sshd", "-D"]
