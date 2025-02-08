FROM ubuntu:latest
LABEL authors="tintang"

USER cloudflare
RUN usermod -aG sudo cloudflare

#install cloudflared
#sudo mkdir -p --mode=0755 /usr/share/keyrings
 #curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

RUN mkdir -p --mode=0755 /usr/share/keyrings
RUN apt-get update && apt-get install -y curl gnupg
RUN curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | gpg --dearmor | tee /usr/share/keyrings/cloudflare-main-archive-keyring.gpg >/dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
RUN apt-get update && apt-get install -y cloudflared


# Copy the Cloudflare Tunnel configuration file
COPY ./cloudflared/config.yml /etc/cloudflared/config.yml
