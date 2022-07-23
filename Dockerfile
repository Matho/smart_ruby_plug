# Pull base image
ARG ARCH=aarch64
FROM mathosk/rpi-ruby-3.1.2-ubuntu-$ARCH:latest

MAINTAINER Martin Markech <martin.markech@matho.sk>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    vim \
    wget \
    git \
    build-essential \
    locales \
    cron \
    bash \
    libcurl4 \
    libcurl4-openssl-dev \
    gcc \
    doxygen \
    cmake \
    gdb \
    sudo \
    iputils-ping

RUN mkdir -p /home/ubuntu/smart_ruby_plug
WORKDIR /home/ubuntu/smart_ruby_plug

ENV GEM_HOME="/home/ubuntu/smart_ruby_plug/vendor/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

ARG C_BINARY_PATH

ADD ./Gemfile ./Gemfile
ADD ./Gemfile.lock ./Gemfile.lock
ADD ./smart_ruby_plug.gemspec ./smart_ruby_plug.gemspec
ADD ./lib/smart_ruby_plug/version.rb ./lib/smart_ruby_plug/version.rb

RUN gem install bundler -v '~> 2.3.0'
RUN bundle install --clean --path vendor/bundle --jobs 2

ADD . .

RUN rm --force /home/ubuntu/libsmart_plug_C.so

RUN cd /home/ubuntu && wget --output-document=/home/ubuntu/libsmart_plug_C.so $C_BINARY_PATH

RUN ln -s /home/ubuntu/libsmart_plug_C.so /home/ubuntu/smart_ruby_plug/lib/clibrary/libsmart_plug_C.so

WORKDIR /home/ubuntu/smart_ruby_plug

RUN bin/install_c_libraries.sh

CMD bundle exec bin/smart_ruby_plug start
