FROM centos:8

ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_RETRY_FILES_ENABLED false

RUN yum check-update; \
  yum install -y gcc libffi-devel python3 epel-release; \
  yum install -y openssh-clients; \
  yum install -y sshpass; \
  pip3 install --upgrade pip; \
  pip3 install ansible

WORKDIR /workspace

CMD [ "ansible-playbook", "-h" ]

LABEL org.opencontainers.image.source https://github.com/metacron/ansible-action