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

EXPOSE 3000
CMD ["npm", "start"]
