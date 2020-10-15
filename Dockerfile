FROM alpine:latest
MAINTAINER Wahyu Anggara <gaankdoank@gmail.com>
RUN apk update && apk upgrade && \
	apk add freeradius \
	freeradius-ldap \
	#samba samba-winbind \ 
	#samba-server-libs \
	#samba-libnss-winbind \ 
	#samba-winbind-clients \
	#krb5 \
	supervisor

#RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf
COPY --chown=root:radius raddb/mods-enabled/ldap /etc/raddb/mods-available/ldap
COPY --chown=root:radius raddb/mods-config/files/authorize /etc/raddb/mods-config/authorize
COPY --chown=root:radius raddb/clients.conf /etc/raddb/clients.conf
COPY --chown=root:radius raddb/sites-available/default /etc/raddb/sites-available/default
#COPY --chown=root:root samba/smb.conf /etc/samba/smb.conf
COPY --chown=root:root supervisord.conf /etc/supervisord.conf

RUN /bin/chmod 640 /etc/raddb/mods-available/ldap
RUN /bin/chmod 640 /etc/raddb/mods-config/authorize
RUN /bin/chmod 640 /etc/raddb/clients.conf
RUN /bin/chmod 640 /etc/raddb/sites-available/default
#RUN /bin/chmod 644 /etc/samba/smb.conf
RUN /bin/chmod 600 /etc/supervisord.conf

EXPOSE \
	1812/udp \
	1813/udp \
	18120

#RUN /usr/bin/net ads join -U Administrator%IBS@ibs123 ; sleep 10 
#RUN /usr/sbin/smbd --no-process-group --configfile /etc/samba/smb.conf
#RUN /usr/sbin/nmbd
#RUN /usr/sbin/winbindd
#CMD ["radiusd","-xx","-f"]
ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]
