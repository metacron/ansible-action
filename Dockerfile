FROM python:3-buster

ARG BITWARDEN_VERSION=1.13.3

RUN apt-get update -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	sshpass unzip wget build-essential libssl-dev libffi-dev python-dev

RUN pip install pip --upgrade
RUN pip install cryptography
RUN pip install ansible

################################
# Install Bitwarden
################################

RUN wget --progress=dot:mega https://github.com/bitwarden/cli/releases/download/v${BITWARDEN_VERSION}/bw-linux-${BITWARDEN_VERSION}.zip
RUN unzip bw-linux-${BITWARDEN_VERSION}.zip && \
	mv bw /usr/local/bin && \
	chmod +x /usr/local/bin/bw

WORKDIR /workspace

CMD [ "ansible-playbook", "-h" ]