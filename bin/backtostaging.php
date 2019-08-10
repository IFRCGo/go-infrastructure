#!/usr/bin/php
<?php
$f1='/home/some_path_under_go_root/deployment/env2';
$f2='/home/some_path_under_go_root/env2_new';
fclose(STDOUT); $STDOUT = fopen($f2, 'w');

define('d',".");
define('h',"#");
define('i','"');
define('n',"\n");
$f_=file($f1,FILE_IGNORE_NEW_LINES);


foreach($f_ as $i=>$f){
    if ($i==0) $f=h.str_replace(h,'',$f);
    if ($i==1) $f=str_replace(h,'',$f);
    print $f.n;
}

rename($f2, $f1);
?>
