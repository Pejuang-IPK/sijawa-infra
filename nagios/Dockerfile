FROM jasonrivers/nagios:latest

COPY nagios.cfg /opt/nagios/etc/nagios.cfg
COPY commands.cfg /opt/nagios/etc/objects/commands.cfg
COPY contacts.cfg /opt/nagios/etc/objects/contacts.cfg
COPY templates.cfg /opt/nagios/etc/objects/templates.cfg

COPY servers/ /opt/nagios/etc/servers/
