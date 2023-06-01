FROM ubuntu:latest

# Install certbot
RUN apt-get update && \
    apt-get install -y certbot

# Install ping and nano
RUN apt-get update && apt-get install -y iputils-ping nano systemd-timesyncd 

# Copy the current directory contents into the container at /root
COPY ./juneogo/ /root/
WORKDIR /root/
# Set the authorisation
RUN ls
RUN chmod +x obtain-ssl-certificates.sh
RUN chmod +x juneogo
RUN chmod +x ./juneogo
RUN chmod -R +x plugins
