#!/usr/bin/php
<?php
$f1='/home/some_path_under_go_root/deployment/env2';
$f2='/home/some_path_under_go_root/deployment/env2_new';
fclose(STDOUT); $STDOUT = fopen($f2, 'w');

$options= getopt('d:');
if (!empty($options['d'])) $d=true; else $d=false; // decrease

define('d',".");
define('h',"#");
define('i','"');
define('n',"\n");
$f_=file($f1,FILE_IGNORE_NEW_LINES);


foreach($f_ as $i=>$f){
    if (strpos($f, 'API_DOCKER_IMAGE') !== false) { // this is version row
        $x=explode(d,$f);
        $y=$x[2];
        $y=explode(i,$y);
        $new_version=$y[0]+($d?-1:1);
        print $x[0].d.$x[1].d.$new_version.i.$y[1].n; // This $y is due to non-numeric $x[2], because it contains " too.
    } else {
        print $f.n;
    }
}

fclose($STDOUT); $STDOUT = fopen('/tmp/GoVersion', 'w');
echo $new_version;
echo n;
fclose($STDOUT);
rename($f2, $f1);
?>
