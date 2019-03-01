FROM node:8.9-alpine AS base
WORKDIR /app

FROM base AS server_deps
# We need python in order to build bcrypt and other bindings
RUN apk --no-cache add g++ gcc libgcc libstdc++ linux-headers make python
# Install dependencies for middleware
COPY ./package*.json /app/
RUN npm install

FROM node:8.9-alpine as web_deps
WORKDIR /web
COPY ./package*.json /web/
RUN npm install -f
COPY ./ /web/
RUN cd /web; npm run build

FROM node:8.9-alpine AS release
WORKDIR /app
# Copy node modules
COPY --from=server_deps /app/ /app/
# Copy rest of server code
COPY ./ /app/
# Copy web UI
#COPY --from=web_deps /web/dist/ /app/publicweb

# Install ssh service
RUN apk update --no-cache \
     && echo "root:Docker!" | chpasswd \
     && apk add openssh \
     && apk add openrc \
     && apk add bash 

COPY sshd_config /etc/ssh/
COPY ssh_setup.sh /tmp
RUN chmod -R +x /tmp/ssh_setup.sh \
   && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null) 

COPY init_container.sh /app/
RUN chmod +x /app/init_container.sh
EXPOSE 2222 3000 

#CMD ["npm", "start"] 
ENTRYPOINT ["/app/init_container.sh"]
