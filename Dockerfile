FROM centos:7
MAINTAINER igor.katson@gmail.com zjrobin.z@163.com

# This is needed in for xz compression in case you can't install EPEL.
# See https://github.com/ikatson/docker-reviewboard/issues/10
RUN yum install -y pyliblzma

RUN yum install -y epel-release && \
    yum install -y ReviewBoard uwsgi \
      uwsgi-plugin-python python-ldap python-pip python2-boto && \
    yum install -y postgresql && \
    yum clean all

ENV PIPURL "https://pypi.tuna.tsinghua.edu.cn/simple"

# ReviewBoard runs on django 1.6, so we need to use a compatible django-storages
# version for S3 support.

RUN pip install -i ${PIPURL} -U pip && \
    rm -rf /usr/lib/python2.7/site-packages/Pygments-2.2.0-py2.7.egg && \
    pip install  -i ${PIPURL} 'pygments>2.0' 'django-storages<1.3'

ADD start.sh /start.sh
ADD uwsgi.ini /uwsgi.ini
ADD shell.sh /shell.sh

RUN chmod +x start.sh shell.sh

VOLUME ["/root/.ssh", "/media/"]

EXPOSE 8000

CMD /start.sh
