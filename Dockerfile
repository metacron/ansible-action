FROM centos:8

ARG BITWARDEN_VERSION=1.13.3

ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_RETRY_FILES_ENABLED false

RUN yum check-update; \
  yum install -y gcc libffi-devel python3 epel-release; \
  yum install -y openssh-clients; \
  yum install -y sshpass; \
  yum install -y wget; \
  yum install -y unzip; \
  pip3 install --upgrade pip; \
  pip3 install ansible

################################
# Install Bitwarden
################################

RUN wget --progress=dot:mega https://github.com/bitwarden/cli/releases/download/v${BITWARDEN_VERSION}/bw-linux-${BITWARDEN_VERSION}.zip
RUN unzip bw-linux-${BITWARDEN_VERSION}.zip && \
	mv bw /usr/local/bin && \
	chmod +x /usr/local/bin/bw && \
	bw -v

WORKDIR /workspace

CMD [ "ansible-playbook", "-h" ]