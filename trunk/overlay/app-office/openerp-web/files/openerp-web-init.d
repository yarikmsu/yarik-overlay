#!/sbin/runscript

depend() {
	use net logger
	after openerp
}


start() {
	[ -n "${SERVER_CONF}" ] \
		&& SERVER_OPTS="${SERVER_OPTS} ${SERVER_CONF}" \
		|| SERVER_OPTS="${SERVER_OPTS} -c /etc/openerp/openerp-web.cfg"
								
	ebegin "Starting openERP"
	start-stop-daemon --start --background --make-pidfile --pidfile=/var/run/openerp/openerp-web.pid --exec /usr/bin/openerp-web -- ${SERVER_OPTS}
	eend $?
}


stop() {
	ebegin "Stopping openERP"
	start-stop-daemon --stop --quiet --pidfile=/var/run/openerp/openerp-web.pid
	eend $?
}

