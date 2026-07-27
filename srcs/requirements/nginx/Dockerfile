FROM debian:bookworm
EXPOSE 443

RUN apt-get update -y 
RUN apt-get install -y nginx openssl
RUN rm -rf /var/lib/apt/lists/*

# TLS part
RUN mkdir -p /etc/nginx/ssl

# we generate an SSL certificate with a precise format (-x509), -nodes allows us to bypass the password
# asked by the command, with -out and -keyout, we give the storing places for the certificate and the key,
# at this point, the command would ask us for informations on the user for the certificate, to avoid the build
# from being interrupted, we add -subj to give them directly in the command (see IBM link for details)
RUN openssl req -x509 -nodes \
        -out /etc/nginx/ssl/apeuget.42.fr.crt \
        -keyout /etc/nginx/ssl/apeuget.42.fr.key \
        -subj "/C=FR/L=Marseille/O=42/CN=apeuget.42.fr/"

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
# tells nginx to run in the foreground instead of the background like a daemon (whence the daemon off)
# to prevent it from exiting abruptly after turning it on
