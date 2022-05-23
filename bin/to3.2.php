#!/usr/bin/php
<?php
fclose(STDOUT); $STDOUT = fopen('out', 'w');

$options= getopt('f:'); //itt is allitando, ha uj parameter merul föl
#debug $options['f'] = 'go-api/databank/models.py';
$f_=file($options['f']  ,FILE_IGNORE_NEW_LINES);
$isMigration = (strpos($options['f'], 'migrations') > 0);
$isApps = (strpos($options['f'], 'apps.py') > 0);
$isSettings = (strpos($options['f'], 'settings.py') > 0);
$isDeploymentsModels = (strpos($options['f'], 'eployments/models.py') > 0);
$isDatabankModels = (strpos($options['f'], 'atabank/models.py') > 0);  # avoid that, does not use enum
$isFlashUpdateApps = (strpos($options['f'], 'flash_update/apps.py') > 0);
$PersonnelRR =                 (strpos($options['f'], 'api/drf_views.py') > 0);
$PersonnelRR = $PersonnelRR || (strpos($options['f'], 'deployments/drf_views.py') > 0);
$PersonnelRR = $PersonnelRR || (strpos($options['f'], 'api/management/commands/sync_molnix.py') > 0);
$choicesParentheses =                        (strpos($options['f'], 'api/admin.py') > 0);
$choicesParentheses = $choicesParentheses || (strpos($options['f'], 'deployments/drf_views.py') > 0);
$choicesParentheses = $choicesParentheses || (strpos($options['f'], 'deployments/filters.py') > 0);
$choicesParentheses = $choicesParentheses || (strpos($options['f'], 'deployments/forms.py') > 0);
$choicesParentheses = $choicesParentheses || (strpos($options['f'], 'deployments/models.py') > 0);

define('d',"=");
define('n',"\n");
//     class Status(IntegerChoices):
function camel($m){
    return $m[1].strtolower($m[2]).'Choices.choices';
}

$C = $M = false;
$coll1 = $coll2 = [];
$skipme = 0;
$indent = '';

if ($isFlashUpdateApps) print 'from django.utils.translation import ugettext_lazy as _'.n;  # before the first row

foreach($f_ as $i=>$f){
    if ($isMigration) {
        if ($f == 'import enumfields.fields') continue; // delete
        $f = preg_replace('/enum=(\w+\.\w+\.\w+)/', 'choices=\1.choices', $f);
        // $f = preg_replace('/\)\).choices,\n/.choices)),\n/', '', $f);
        if (strpos($f, 'enumfields.fields.Enum') > 0) {
            $f = preg_replace('/enumfields.fields.Enum/', 'models.', $f);
            if (strpos($f, 'default') === false) $f = str_replace('.choices', '.choices, default=0', $f);
        }
        print $f.n;
        continue; // ***************************** ^ migrations ^ *****************************
    } elseif ($isApps) {
        if (strpos($f, 'name') === false) {
            print $f.n;
        } else {
            $name = explode("'", substr($f, strpos($f, 'name')+5));
            print "    name = '" . trim($name[1]) . "'".n;
            print "    verbose_name = _('" . str_replace('_', ' ', trim($name[1])) . "')".n;
        }
        continue; // ***************************** ^ apps ^ *****************************
    } elseif ($isDeploymentsModels) {
        if ((strpos($f, ', choices=') > 0) && (strpos($f, '_CHOICES') > 0)) {
            $f = preg_replace_callback('/(\w)(\w+)_CHOICES/', 'camel', $f);
        }
    } elseif ($PersonnelRR || $choicesParentheses) {
        if (strpos($f, 'Personnel.RR'))
            $f = str_replace('Personnel.RR', 'Personnel.TypeChoices.RR', $f);
        if (strpos($f, '.choices()'))
            $f = str_replace('.choices()', '.choices', $f);
        print $f.n; continue;
    } elseif ($isSettings) {
        print $f.n;
        if (substr($f, 0, 8) == 'BASE_DIR')
            print "DEFAULT_AUTO_FIELD='django.db.models.AutoField'".n;
        continue;
    }


if ($skipme > 0) {$skipme--; continue;}
if (strpos($f, "FIXME") > 0) {print $f.n; continue;}           // leave it as it is
if ($f == 'class GeoSerializerMixin:') {print $f.n; continue;} // leave it as it is

if ($f == 'from enumfields import IntEnum, EnumIntegerField') continue; // delete
if ($f == 'from enumfields.drf.serializers import EnumSupportSerializerMixin') continue; // delete
if ($f == 'from enumfields import EnumIntegerField') continue; // delete
if ($f == 'from enumfields import IntEnum') continue; // delete
if ($f == 'from dref.enums import IntegerChoices') continue; // delete
if ($f == 'from .enums import TextChoices, IntegerChoices') continue; // delete
if ($f == "    NTLS = 'NTLS'") {
print 
"    class OrgTypes(models.TextChoices):
         NTLS = 'NTLS', _('National Society')
         DLGN = 'DLGN', _('Delegation')
         SCRT = 'SCRT', _('Secretariat')
         ICRC = 'ICRC', _('ICRC')
         OTHR = 'OTHR', _('Other')
"; $skipme = 12; continue; // replacing directly
}

if ($f == '    epi_figures_source = EnumIntegerField(') {
    print('    epi_figures_source = models.IntegerField('.n);
    print("        choices=EPISourceChoices.choices, verbose_name=_('figures source (epidemic)'), null=True, blank=True".n);
    $skipme = 1; continue;
}
$f = str_replace('EnumSupportSerializerMixin, ', '', $f);
$f = str_replace('EnumSupportSerializerMixin,', '', $f);
$f = str_replace('EnumSupportSerializerMixin', '', $f);
$f = str_replace('ORGANIZATION_TYPES', 'OrgTypes', $f);
$f = str_replace('(IntegerChoices)', '(models.IntegerChoices)', $f);
$f = str_replace('(TextChoices)', '(models.TextChoices)', $f);
$f = str_replace('class VisibilityCharChoices():', 'class VisibilityCharChoices:', $f); //tricky change to eliminate ()
# $f = str_replace('class PastCrisesEvent():', 'class PastCrisesEvent:', $f); //tricky change to eliminate ()
# $f = str_replace('class PastEpidemic():', 'class PastEpidemic:', $f); //tricky change to eliminate ()
# $f = str_replace('class InformIndicator():', 'class InformIndicator:', $f); //tricky change to eliminate ()

$f = preg_replace('/choices=(.*?)\.CHOICES/', 'choices=$1.choices', $f); // choices=ActionOrg.CHOICES

if ((strpos($f, ' Meta') === false) && (strpos($f, '(') === false) && (strpos($f, ':') > 0))
    $f = preg_replace('/(class +\w+)/', '$0(TextEnum)', $f);
$f = str_replace('    CHOICES = (', 'class Lab:', $f); //tricky change
$f = preg_replace('/^ +\(\w+,( _.*)../', 'x = $1', $f); //         (HEALTH, _('Health')),

$m1 = preg_match('/(^class) +(.*).(IntEnum)(.*)/', $f, $matches); //  class RegionName(IntEnum):
$m2 = preg_match('/(^class) +(.*).(TextEnum)(.*)/', $f, $m2tches); //  class RegionName(IntEnum):
$m3 = preg_match('/(.*)(EnumIntegerField.)(\w+)(.*)/', $f, $m3tches);    //  status = EnumIntegerField(CronJobStatus, verbose_name=_('status'), default=-1)
$m4 = preg_match('/(.*)(EnumTextField.)(\w+)(.*)/', $f, $m4tches);

$f = str_replace('    TYPE_CHOICES = (', 'class Lab:', $f);
$f = str_replace('    STATUS_CHOICES = (', 'class Lab:', $f);

if (trim($f) == "PENDING = 'pending'") {
    $m2 = true; $C = false; $m2tches[2] = 'ProjImpStatus'; $coll1[] = explode(d,$f); $indent = '    ';}
elseif (trim($f) == "FACT = 'fact'") {
    $m2 = true; $C = false; $m2tches[2] = 'TypeChoices';   $coll1[] = explode(d,$f); $indent = '    ';}
elseif ((trim($f) == "ACTIVE = 'active'") && !$isDatabankModels) {
    $m2 = true; $C = false; $m2tches[2] = 'StatusChoices'; $coll1[] = explode(d,$f); $indent = '    ';}


if ($M) {

    if ($C)
        $coll2[] = explode(d,$f);
    else {
        if ((strpos($f, '=') === false) && (trim($f)!='') && !preg_match('/class /', $f))
            print $f.n;
        else
            $coll1[] = explode(d,$f);
    }
    if (preg_match('/class /', $f)) $C = true;
    $cond1 = (($f_[$i+1] == '    LABEL_MAP = {') || (trim($f)==''));
    if ($cond1 && $C) {
        foreach ($coll1 as $i=>$c){
            if (empty($c[0]) || empty($coll2[$i][1])) break; 
            print $indent.'    '.trim($c[0]).' = '.trim(preg_replace('/\#.*/', '', $c[1])).', '.trim($coll2[$i][1]).n; 
            # Manual afterburning:
            #      EVENT = 0, _('event')                # will be obsolete, migrated to NEW_EMERGENCIES
            #      APPEAL = 1, _('appeal')              # will be obsolete, migrated to NEW_OPERATIONS
            #      FIELD_REPORT = 2, _('field report')  # will be obsolete, migrated to NEW_EMERGENCIES
        }
    }
    if ($cond1 && $C) {
        $C = $M = false;
        $coll1 = $coll2 = [];
        $indent = '';
        print n;
    }
} elseif ($m1) {
    print $indent."class ".$matches[2]."(models.IntegerChoices):".n;
    $M=true;
} elseif ($m2) {
    print $indent."class ".$m2tches[2]."(models.TextChoices):".n;
    $M=true;
} elseif ($m3) {
    $f = $m3tches[1].'models.IntegerField(choices='.$m3tches[3].'.choices'.$m3tches[4].n;
    if (strpos($f, 'default') === false) $f = str_replace('.choices', '.choices, default=0', $f);
    print $f;
} elseif ($m4) {
    $f = $m4tches[1].'models.TextField(choices='.$m4tches[3].'.choices'.$m4tches[4].n;
    if (strpos($f, 'default') === false) $f = str_replace('.choices', '.choices, default=0', $f);
    print $f;
} else {
    if     (strpos($f, "choices=StatusChoices.choices, default=PENDING") > 0)
        $f=str_replace("choices=StatusChoices.choices, default=PENDING", "choices=ProjImpStatus.choices, default=ProjImpStatus.PENDING", $f);
    elseif (strpos($f, "choices=StatusChoices.choices, default=ACTIVE") > 0)
        $f=str_replace("choices=StatusChoices.choices, default=ACTIVE", "choices=StatusChoices.choices, default=StatusChoices.ACTIVE", $f);
        
    $x=explode(d,$f);
    print implode(d,$x).n;
}
} // foreach
