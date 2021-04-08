#!/usr/bin/php
<?php
// check these at the bottom as well
$f1='/home/zol/w/ifrc/go-api/CHANGELOG.md';
$f2='/home/zol/w/ifrc/CHANGELOG2.md';
$pre='1.1.';
$fp = fopen($f2, 'w');

$options= getopt('t:v:');
if (!empty($options['t'])) $t=$options['t']; else $t=''; // text
if (!empty($options['v'])) $v=$options['v']; else $v=''; // ver

define('d',".");
define('z',"]");
define('a',"'");
define('h',"#");
define('i','"');
define('n',"\n");
$f_=file($f1,FILE_IGNORE_NEW_LINES);

$next_row_is_important=false;
foreach($f_ as $i=>$f){
    if ($next_row_is_important) {
        $x=explode(d,str_replace(z,d,$f));
        fwrite($fp,$x[0].d.$x[1].d.$v.z.$x[3].d.$x[4].d.$x[5].d.$x[2].d.$x[7].d.$x[8].d.$x[9].d.$x[9].d.$v.n);
        fwrite($fp,$f.n);
        $next_row_is_important=false;
    } elseif (strpos($f, '## Unreleased') !== false) { // this is the addendum part of the changelog file
        fwrite($fp,$f.n.n.'## '.$pre.$v.n.n.'### Added'.n.' - '.$t.n);
    } elseif (strpos($f, '[Unreleased]:') !== false) { // https://github.com/IFRCGo/go-api/compare/1.1.44...HEAD)
        $x=explode(d,$f,5);
        fwrite($fp,$x[0].d.$x[1].d.$x[2].d.$v.d.$x[4].n);
        $next_row_is_important=true;
    } else {
        fwrite($fp,$f.n);
    }
}

//rename($f2, $f1);
fclose($fp);

$f1='/home/zol/w/ifrc/go-api/main/__init__.py';
$f2='/home/zol/w/ifrc/__init__.py2';
$fp = fopen($f2, 'w');
$f_=file($f1,FILE_IGNORE_NEW_LINES);

foreach($f_ as $i=>$f){
    if (strstr($f, 'version') !== false) {
        $x=explode(d,str_replace(a,d,$f));
        fwrite($fp,$x[0].a.$x[1].d.$x[2].d.$v.a.n);
    } else fwrite($fp,$f.n);
}

//rename($f2, $f1);
fclose($fp);
