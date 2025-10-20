<?php
// ** MySQL settings - You can get this info from your .env file ** //
define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// ** Authentication Unique Keys and Salts. ** //
// You can generate these at https://api.wordpress.org/secret-key/1.1/salt/
define('AUTH_KEY',         '%bhpBpDb`S]x8uO2@rq[co*&*@2%TL&]ZYJLq!P?fk3kgW-alP#+[}sZz=uZ#g=z');
define('SECURE_AUTH_KEY',  'HGi6]G.K6NK`b]B^mU)kA&=!g?#$W:{b=_2/CKQRi)}V-SRDs,bvX#;a +2eam+w');
define('LOGGED_IN_KEY',    'mhM118t+SF$zh2?McfNSSB_VfsJPQ<z|K?n.U }3))|Ce*^}%vH&&m[9IO-<wU.0');
define('NONCE_KEY',        ')6!dX*ml1LoCowICC b%0gxP0Pefj=xVR3$KBH!SxxCVkt!PH_SB;c|.z8+GNv-~');
define('AUTH_SALT',        '--LLjFqKyrW{yB!$q)~P$>FV@f2RKHFO*~B[bUj)-bg^U`OC%!R!x>I&>wL`v~7X');
define('SECURE_AUTH_SALT', 'yJZP+qPm+#iN&e9ebZr=f,I<W%VVO3_9a_c?s.nDfJDC/i}>^Z47zxja^e*v?n?<');
define('LOGGED_IN_SALT',   'DfgIa{E,U7#Cz`]uba(#S%EFQ7l1fuc<6A)Vf6Ah~=CnK^H4,e4mcqG:jom5h8E2');
define('NONCE_SALT',       'G|LDRvV{kA+ckuOQ$mrRq!1vXJov7ypuk%FE$Thu,0XC&+q]4h?TpTDmhk6?<ABv');

$table_prefix = 'wp_';

define('WP_DEBUG', false);

if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}
require_once ABSPATH . 'wp-settings.php';
