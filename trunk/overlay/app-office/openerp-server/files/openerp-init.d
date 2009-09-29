#!/sbin/runscript

depend() {
	use net logger
	after postgresql
}


start() {
	[ -n "${SERVER_CONF}" ] \
		&& SERVER_OPTS="${SERVER_OPTS} --config=${SERVER_CONF}" \
		|| SERVER_OPTS="${SERVER_OPTS} --config=/etc/openerp/oerp_serverrc"
	[ -n "${SERVER_DB}" ] && SERVER_OPTS="${SERVER_OPTS} --database=${SERVER_DB}"
	[ -n "${SERVER_USER}" ] && SERVER_OPTS="${SERVER_OPTS} --db_user=${SERVER_USER}"
	[ -n "${SERVER_PW}" ] && SERVER_OPTS="${SERVER_OPTS} --db_password=${SERVER_PW}"
	[ -n "${SERVER_HOST}" ] && SERVER_OPTS="${SERVER_OPTS} --db_host=${SERVER_HOST}"
	[ -n "${SERVER_PORT}" ] && SERVER_OPTS="${SERVER_OPTS} --db_port=${SERVER_PORT}"
								
	ebegin "Starting openERP"
	start-stop-daemon --start --quiet --oknodo --background --chuid oerp:oerp --make-pidfile --pidfile=/var/run/openerp/openerp.pid --exec /usr/bin/openerp-server -- ${SERVER_OPTS} --logfile=/var/log/openerp/openerp.log
	eend $?
}


stop() {
	ebegin "Stopping openERP"
	start-stop-daemon --stop --quiet --pidfile=/var/run/openerp/openerp.pid
	eend $?
}


