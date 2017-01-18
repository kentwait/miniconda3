FROM kentwait/alpine-glibc

MAINTAINER Kent Kawashima <kentkawashima@gmail.com>

ENV CONDA_DIR=/opt/conda \
 CONDA_VERSION=4.2.12 \
 PATH=/opt/conda/bin:$PATH \
 WORKDIR=/root

RUN apk update && apk upgrade \
 # essentials
 && apk add --no-cache --virtual temp-pkgs build-base python 

RUN cd ${WORKDIR} \
 # Miniconda
 && wget "https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh" -O installer.sh \
 && bash installer.sh -b -p ${CONDA_DIR} \
 && echo "export PATH=${CONDA_DIR}/bin:$PATH" > /etc/profile.d/conda.sh \
 # remove packages and clean up 
 && apk del temp-pkgs \
 && find /opt -name __pycache__ | xargs rm -r \
 && rm -rf /tmp/* /var/cache/apk/* /opt/conda/pkgs/* /root/.wget-hsts /root/.[acpw]* /root/installer.sh 

VOLUME ${WORKDIR}/notebooks
WORKDIR ${WORKDIR}/notebooks
ENTRYPOINT ["/init"]
CMD ["bash"]
