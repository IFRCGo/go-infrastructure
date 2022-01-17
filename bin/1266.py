#!/usr/bin/python3
import csv

fout= open("1266.sql","w")
print(f'begin;', file=fout)
print(f'insert into auth_group_permissions (group_id, permission_id) values ', file=fout)
delimiter = ''
with open('im.1266', 'r') as fimp: # ~354 group_id-s, query below
    readem = csv.reader(fimp)
    for m in readem:
        with open('in.1266', 'r') as finp:  # 58 permission_id-s, query below
            reader = csv.reader(finp)
            for n in reader:
                print(f'{delimiter}({m[0]}, {n[0]})', file=fout)
                delimiter = ','


print(f';', file=fout)
print(f'commit;', file=fout)

fout.close()

'''
select distinct group_id from auth_group_permissions a join auth_permission b on a.permission_id=b.id and codename like 'country_admin_%' order by 1;

-- if generated from admin page, you can use "view source".
select distinct id from auth_permission where codename in (
'add_actionstaken',          'change_actionstaken',          'delete_actionstaken',          'view_actionstaken',
'add_countrykeyfigure',      'change_countrykeyfigure',      'delete_countrykeyfigure',      'view_countrykeyfigure',
'add_countrysnippet',        'change_countrysnippet',        'delete_countrysnippet',        'view_countrysnippet',
'add_event',                 'change_event',                 'delete_event',                 'view_event',
'add_eventcontact',          'change_eventcontact',          'delete_eventcontact',          'view_eventcontact',
'add_eventfeatureddocument', 'change_eventfeatureddocument', 'delete_eventfeatureddocument', 'view_eventfeatureddocument',
'add_eventlink',             'change_eventlink',             'delete_eventlink',             'view_eventlink',
'add_fieldreport',           'change_fieldreport',           'delete_fieldreport',           'view_fieldreport',
'add_fieldreportcontact',    'change_fieldreportcontact',    'delete_fieldreportcontact',    'view_fieldreportcontact',
'add_keyfigure',             'change_keyfigure',             'delete_keyfigure',             'view_keyfigure',
'add_situationreport',       'change_situationreport',       'delete_situationreport',       'view_situationreport',
'add_snippet',               'change_snippet',               'delete_snippet',               'view_snippet',
'add_source',                'change_source',                'delete_source',                'view_source',
'add_sourcetype',            'change_sourcetype',            'delete_sourcetype',            'view_sourcetype',
'view_country',
'view_gdacsevent')
order by 1;


In case of conflict remove conflicting records, e.g.:
begin;
delete from auth_group_permissions where group_id=102 and permission_id <>260;
commit;

Or full tabula rasa, leaving only the country_admin_* permissions:
begin;
delete from auth_group_permissions where group_id in
(select distinct group_id from auth_group_permissions
 where permission_id  in (select id from auth_permission where codename like 'country_admin_%')) 
and permission_id not in (select id from auth_permission where codename like 'country_admin_%');
commit;

'''
