FROM node:latest

# install simple http server for serving static content
#RUN npm install -g http-server

# make the 'app' folder the current working directory
WORKDIR /app

RUN npm i -g @quasar/cli

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

# Add python to build node-gup
#RUN apk add --update python3 make g++ && rm -rf /var/cache/apk/*

# Add rights for npx cache
RUN chown -R 1000:1000 /root/

# Add git for npx install temp packages
#RUN apk add git

# install project dependencies
RUN npm install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

EXPOSE 8000

CMD ["npx", "quasar", "dev"]
