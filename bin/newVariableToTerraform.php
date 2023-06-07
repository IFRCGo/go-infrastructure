#!/usr/bin/php
<?php
define('name', "Some new var");
define('variable', "HHHHHHHHHHH");
define('defaul', ''); // don't use the word default, it is forbidden as a keyword already
define('isSecret', false);

define('n',"\n");


$f0='docker-compose.yml'; $f1=$f0.'1';
fclose(STDOUT); $STDOUT = fopen($f1, 'w');
$f_=file($f0, FILE_IGNORE_NEW_LINES);

$d=':'; $needle='DJANGO_READ_ONLY'; $findval='false';
foreach($f_ as $i=>$f){
    $x=explode($d,$f);
    print implode($d,$x).n;
    if (trim($x[0])==$needle) {$f=str_replace($needle, variable, $f); $f=str_replace($findval, defaul, $f); print('    # '.name.n); print($f).n;}
}
rename($f1, $f0);


$f0='deploy/docker-compose.yml'; $f1=$f0.'1';
fclose($STDOUT); $STDOUT = fopen($f1, 'w');
$f_=file($f0, FILE_IGNORE_NEW_LINES);

$d='='; $pre='        - TF_VAR_'; $needle='DEBUG_EMAIL';
foreach($f_ as $i=>$f){
    $x=explode($d,$f);
    print implode($d,$x).n;
    if ($x[0]==$pre.$needle) {$f=str_replace($needle, variable, $f); print('        # '.name.n); print($f).n;}
}
rename($f1, $f0);


$f0='deploy/terraform/resources/helm-ifrcgo.tf'; $f1=$f0.'1';
fclose($STDOUT); $STDOUT = fopen($f1, 'w');
$f_=file($f0, FILE_IGNORE_NEW_LINES);

$row=0; $needle='DEBUG_EMAIL';
foreach($f_ as $i=>$f){
    print $f.n;
    if (strstr($f, $needle) || $row==1) $row++;
    if ($row==2) {print(n.'  set {'.n.'    name = "env.'.variable.'"'.n.'    value = var.'.variable.n.'  }'.n.n); $row=0;}
}
rename($f1, $f0);


$f0='deploy/terraform/resources/variables.tf'; $f1=$f0.'1';
fclose($STDOUT); $STDOUT = fopen($f1, 'w');
$f_=file($f0, FILE_IGNORE_NEW_LINES);

$row=0; $needle='DEBUG_EMAIL';
foreach($f_ as $i=>$f){
    print $f.n;
    if (strstr($f, $needle) || $row==1 || $row==2 || $row==3) $row++;
    if ($row==4) {print(n.'variable "'.variable.'" {'.n.'  type = string'.n.'  default = "'.defaul.'"'.n.'}'.n); $row=0;}
}
rename($f1, $f0);


$f0='deploy/terraform/main.tf'; $f1=$f0.'1';
fclose($STDOUT); $STDOUT = fopen($f1, 'w');
$f_=file($f0, FILE_IGNORE_NEW_LINES);

$needle='DEBUG_EMAIL';
foreach($f_ as $i=>$f){
    print $f.n;
    if (strstr($f, $needle)) {print('  '.variable.' = var.'.variable.n);}
}
rename($f1, $f0);


$f0='deploy/terraform/variables.tf'; $f1=$f0.'1';
fclose($STDOUT); $STDOUT = fopen($f1, 'w');
$f_=file($f0, FILE_IGNORE_NEW_LINES);

foreach($f_ as $i=>$f){
    print $f.n;
}
print(n.'variable "'.variable.'" {'.n.'  type = string'.n.'  default = "'.defaul.'"'.n.'}'.n); // post festa
rename($f1, $f0);


$f0='deploy/helm/ifrcgo-helm/values.yaml'; $f1=$f0.'1';
fclose($STDOUT); $STDOUT = fopen($f1, 'w');
$f_=file($f0, FILE_IGNORE_NEW_LINES);

$needle='DEBUG_EMAIL';
foreach($f_ as $i=>$f){
    print $f.n;
    if (strstr($f, $needle)) {print("  ".variable.": ''".n);}
}
rename($f1, $f0);


$f0 = isSecret ? 'deploy/helm/ifrcgo-helm/templates/config/secret.yaml' : 'deploy/helm/ifrcgo-helm/templates/config/configmap.yaml';
$f1 = $f0.'1';
fclose($STDOUT); $STDOUT = fopen($f1, 'w');
$f_=file($f0, FILE_IGNORE_NEW_LINES);

foreach($f_ as $i=>$f){
    print $f.n;
}
print(isSecret ? '  '.variable.': "{{ .Values.env.'.variable.' }}"'.n :
                 '  '.variable.': {{ .Values.env.'.variable.' | quote }}'.n); // post festa
rename($f1, $f0);
