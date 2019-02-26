FROM ubuntu:16.04

# Install prerequisites
RUN apt update && \
	apt-get install -y build-essential wget unzip python2.7 \
	python-dev git python-pip bats awscli curl ncbi-blast+ \
	lbzip2 pigz autoconf autogen libssl-dev

# Use /share as the working directory
RUN mkdir /share
WORKDIR /share

# Install DIAMOND v0.9.23
RUN mkdir /usr/diamond
RUN cd /usr/diamond && \
	wget https://github.com/bbuchfink/diamond/releases/download/v0.9.23/diamond-linux64.tar.gz && \
	tar xzvf diamond-linux64.tar.gz && \
	mv diamond /usr/bin/ && \
	rm diamond-linux64.tar.gz

# Install BBTools
RUN cd /usr && \
	wget "https://downloads.sourceforge.net/project/bbmap/BBMap_38.41.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fbbmap%2Ffiles%2FBBMap_38.41.tar.gz%2Fdownload&ts=1550861989" && \
	tar xzvf BBMap_38.41.tar.gz* && \
	export PATH=$PATH:/usr/bbmap/ && \
	rm BBMap_38.41.tar.gz*

# Install Megahit
RUN cd /usr && \
	wget https://github.com/voutcn/megahit/releases/download/v1.1.4/megahit_v1.1.4_LINUX_CPUONLY_x86_64-bin.tar.gz && \
	tar xzvf megahit_v1.1.4_LINUX_CPUONLY_x86_64-bin.tar.gz && \
	ln -s $PWD/megahit_v1.1.4_LINUX_CPUONLY_x86_64-bin/megahit /usr/local/bin/ && \
	cd && megahit -h

# Install khmer
RUN pip install khmer

# Install vsearch
RUN cd /usr && \
	wget https://github.com/torognes/vsearch/archive/v2.11.0.tar.gz && \
	tar xzf v2.11.0.tar.gz && \
	cd vsearch-2.11.0 && \
	./autogen.sh && \
	./configure && \
	make && \
	make install

# Install zstd
RUN cd /usr && \
	git clone https://github.com/facebook/zstd.git && \
	cd zstd && \
	make install

# Install modules from CPAN
RUN cpan App::cpanminus && \
	cpanm Net::SSLeay \
	OpenSourceOrg::API \
	Text::Levenshtein::Damerau::XS \
	Text::Levenshtein::XS

RUN cpanm --force Sereal \
	Sereal::Decoder \
	Compress::Zstd \
	POSIX::1003::Sysconf \
	POSIX::RT::Semaphore \
	RocksDB

RUN cd /etc/perl && \
	wget http://korflab.ucdavis.edu/Unix_and_Perl/FAlite.pm && \
	chmod +x FAlite.pm

RUN cd /usr/local/bin/ && \
	git clone https://github.com/cmmr/virmap.git && \
	cd virmap && \
	export PATH=$PATH:$PWD && \
	Virmap.pl --help
