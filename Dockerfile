FROM google/cloud-sdk:alpine
LABEL maintainer="Manal Lamine <geekette86@gmail.com>"


#Choose directory where to work
WORKDIR /var

#Install mongodb tools ( e.g mongodump tool.. ) 
RUN apk update && apk add mongodb-tools && rm -rf /var/cache/apk/*
COPY backup.sh backup.sh
# Give execution permission to the script
RUN chmod +x backup.sh

#Launch script
CMD ["/var/backup.sh"]
