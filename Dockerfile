FROM alpine:latest
MAINTAINER Gaank Doank <gaankdoank@gmail.com>
RUN apk update && apk upgrade && \
	apk add freeradius \
	freeradius-ldap \
	supervisor

COPY --chown=root:radius raddb/mods-enabled/ldap /etc/raddb/mods-available/ldap
COPY --chown=root:radius raddb/mods-config/files/authorize /etc/raddb/mods-config/authorize
COPY --chown=root:radius raddb/clients.conf /etc/raddb/clients.conf
COPY --chown=root:radius raddb/sites-available/default /etc/raddb/sites-available/default
COPY --chown=root:root supervisord.conf /etc/supervisord.conf

RUN /bin/chmod 640 /etc/raddb/mods-available/ldap
RUN /bin/chmod 640 /etc/raddb/mods-config/authorize
RUN /bin/chmod 640 /etc/raddb/clients.conf
RUN /bin/chmod 640 /etc/raddb/sites-available/default
RUN /bin/chmod 600 /etc/supervisord.conf

EXPOSE \
	1812/udp \
	1813/udp \
	18120

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]
