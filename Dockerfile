FROM node:10.15.1

# Install VS Code's deps. These are the only two it seems we need.
RUN apt-get update && apt-get install -y \
	libxkbfile-dev \
	libsecret-1-dev \
	git

# Ensure latest yarn.
RUN npm install -g yarn@1.13 typescript mocha 

WORKDIR /src
RUN git clone https://github.com/cdr/code-server.git /src

# In the future, we can use https://github.com/yarnpkg/rfcs/pull/53 to make yarn use the node_modules
# directly which should be fast as it is slow because it populates its own cache every time.
RUN yarn && NODE_ENV=production yarn task build:server:binary

# We deploy with ubuntu so that devs have a familiar environment.
FROM ubuntu:18.04

# Install essentials
RUN apt-get update && apt-get install -y \
	openssl \
	net-tools \
	git \
	locales \
	sudo \
	dumb-init \
	vim \
	curl \
	wget

# Set up ubuntu to down load 10_x version of node
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

RUN apt-get update && apt-get install -y \
	nodejs \
	npm

# Install some global packages
RUN npm install -g typescript mocha eslint

RUN locale-gen en_US.UTF-8
# We unfortunately cannot use update-locale because docker will not use the env variables
# configured in /etc/default/locale so we need to set it manually.
ENV LC_ALL=en_US.UTF-8

# We create first instead of just using WORKDIR as when WORKDIR creates, the user is root.
RUN mkdir -p /root/project

WORKDIR /root/project

# This assures we have a volume mounted even if the user forgot to do bind mount.
# So that they do not lose their data if they delete the container.
VOLUME [ "/root/project", "/usr/local/lib/node_modules", "/root/.local/share/code-server" ]

COPY --from=0 /src/packages/server/cli-linux-x64 /usr/local/bin/code-server
EXPOSE 80

ENTRYPOINT ["dumb-init", "code-server"]
