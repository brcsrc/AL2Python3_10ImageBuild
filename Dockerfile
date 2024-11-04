FROM amazonlinux:2

RUN yum install -y gcc make curl tar gzip perl zlib-devel zip libffi-devel

RUN curl -LO https://www.openssl.org/source/openssl-1.1.1t.tar.gz && \
    tar -xzf openssl-1.1.1t.tar.gz && \
    cd openssl-1.1.1t && \
    ./config --prefix=/usr/local/openssl && \
    make && \
    make install

ENV LD_LIBRARY_PATH="/usr/local/openssl/lib:${LD_LIBRARY_PATH}"

RUN curl -O https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz && \
    tar -xzf Python-3.10.0.tgz && \
    cd Python-3.10.0 && \
    ./configure --enable-optimizations --with-openssl=/usr/local/openssl && \
    make altinstall

RUN /usr/local/bin/python3.10 -m venv /application/.venv && \
    . /application/.venv/bin/activate && \
    /application/.venv/bin/pip install --upgrade
