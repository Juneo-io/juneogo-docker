FROM ubuntu:latest

# Install ping and nano
RUN apt-get update && apt-get install -y iputils-ping nano systemd-timesyncd 

# Copy the current directory contents into the container at /root
COPY ./juneogo/ /root/
WORKDIR /root/
# Set the authorisation
RUN ls
RUN chmod +x juneogo
RUN chmod +x ./juneogo
RUN chmod -R +x ./.juneogo/plugins
