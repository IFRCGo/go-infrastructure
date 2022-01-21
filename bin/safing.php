#!/usr/bin/php
<?php
// Works only on linux
fclose(STDOUT); $STDOUT = fopen('proddump.sql', 'w');
$f_=file('proddumpINPUT.sql',FILE_IGNORE_NEW_LINES);

define('d',"\t");
define('n',"\n");
$nopassw = $skip = false;

foreach($f_ as $i=>$f){
    if (substr($f,0,22)=='COPY public.auth_user ') {$nopassw = true;}
    elseif (substr($f,0,27)=='COPY public.django_session ' ||
            substr($f,0,29)=='COPY public.django_admin_log ' ||
            substr($f,0,24)=='COPY public.api_authlog ' ||
            substr($f,0,43)=='COPY public.notifications_notificationguid ' ||
            substr($f,0,22)=='COPY public.reversion_') {$skip = true; print ("-- SKIPPING...\n");}
    if     (substr($f,0,2)=='\.') {$nopassw = false;}
    elseif (substr($f,0,2)=='--') {$skip = false;}
    if ($skip) {continue;}
    if ($nopassw) {
        $x=explode(d,$f);
	if (
           (sizeof($x)>7) &&
           ($x[7] != 'an_email_addr_to_keep_locally@...') &&
           ($x[7] != 'another_email_address_to_keep@...')
           )
            {$x[1]='-'; $x[7]='none@of.your.business';}
        print implode(d,$x).n;}
    else print $f.n;
}
