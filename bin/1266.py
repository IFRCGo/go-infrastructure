#!/usr/bin/python3
import csv

fout= open("1266.sql","w")
print(f'begin;', file=fout)
print(f'insert into auth_group_permissions (group_id, permission_id) values ', file=fout)
delimiter = ''
with open('im.1266', 'r') as fimp: # ~354 group_id-s, query below
    readem = csv.reader(fimp)
    for m in readem:
        with open('in.1266', 'r') as finp:  # 86 permission_id-s, query below
            reader = csv.reader(finp)
            for n in reader:
                print(f'{delimiter}({m[0]}, {n[0]})', file=fout)
                delimiter = ','


print(f';', file=fout)
print(f'commit;', file=fout)

fout.close()

'''
select distinct group_id from auth_group_permissions a join auth_permission b on a.permission_id=b.id and codename like 'country_admin_%' order by 1;

select distinct id from auth_permission where codename in (
'add_action',
'change_action',
'delete_action',
'add_actionstaken',
'change_actionstaken',
'delete_actionstaken',
'add_event',
'change_event',
'delete_event',
'add_eventcontact',
'change_eventcontact',
'delete_eventcontact',
'add_fieldreport',
'change_fieldreport',
'delete_fieldreport',
'add_fieldreportcontact',
'change_fieldreportcontact',
'delete_fieldreportcontact',
'add_gdacsevent',
'change_gdacsevent',
'delete_gdacsevent',
'add_keyfigure',
'change_keyfigure',
'delete_keyfigure',
'change_situationreport',
'add_snippet',
'change_snippet',
'delete_snippet',
'add_source',
'change_source',
'delete_source',
'add_sourcetype',
'change_sourcetype',
'delete_sourcetype',
'add_adminkeyfigure',
'change_adminkeyfigure',
'delete_adminkeyfigure',
'add_countrysnippet',
'change_countrysnippet',
'delete_countrysnippet',
'add_regionsnippet',
'change_regionsnippet',
'delete_regionsnippet',
'add_countrykeyfigure',
'change_countrykeyfigure',
'delete_countrykeyfigure',
'add_regionkeyfigure',
'change_regionkeyfigure',
'delete_regionkeyfigure',
'view_action',
'view_actionstaken',
'view_event',
'view_eventcontact',
'view_fieldreport',
'view_fieldreportcontact',
'view_gdacsevent',
'view_keyfigure',
'view_situationreport',
'view_snippet',
'view_source',
'view_sourcetype',
'view_adminkeyfigure',
'view_countrysnippet',
'view_regionsnippet',
'view_countrykeyfigure',
'view_regionkeyfigure',
'add_regionprofilesnippet',
'change_regionprofilesnippet',
'delete_regionprofilesnippet',
'view_regionprofilesnippet',
'add_regionpreparednesssnippet',
'change_regionpreparednesssnippet',
'delete_regionpreparednesssnippet',
'view_regionpreparednesssnippet',
'add_regionemergencysnippet',
'change_regionemergencysnippet',
'delete_regionemergencysnippet',
'view_regionemergencysnippet',
'add_eventfeatureddocument',
'change_eventfeatureddocument',
'delete_eventfeatureddocument',
'view_eventfeatureddocument',
'add_eventlink',
'change_eventlink',
'delete_eventlink',
'view_eventlink') order by 1;


In case of conflict remove conflicting records, e.g.:
begin;
delete from auth_group_permissions where group_id=102 and permission_id <>260;
commit;

'''
