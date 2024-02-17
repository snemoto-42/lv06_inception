<?php

define('DB_NAME', 'wordpress_db');
define('DB_USER', 'wordpress_user');
define('DB_PASSWORD', 'wordpress_password');
define('DB_HOST', 'mariadb_container');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

define('AUTH_KEY', 'msg1');
define('SECURE_AUTH_KEY', 'msg2');
define('LOGGED_IN_KEY', 'msg3');
define('NONCE_KEY', 'msg4');
define('AUTH_SALT', 'msg5');
define('SECURE_AUTH_SALT', 'msg6');
define('LOGGED_IN_SALT', 'msg7');
define('NONCE_SALT', 'msg8');

$table_prefix = 'wp_';

define('WP_DEBUG', true);

if (!defined('ABSPATH'))
{
	define('ABSPATH', dirname(__FILE__) . '/');
}

require_once(ABSPATH . 'wp-setting.php');
