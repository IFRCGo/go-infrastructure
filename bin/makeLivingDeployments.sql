
--Preparation for restore afterwards:
drop table tmpdpd; create table tmpdpd as select * from deployments_personneldeployment;
drop table tmpnsa; create table tmpnsa as select * from notifications_surgealert;
drop table tmpdd; create table tmpdd as select * from deployments_deployedperson;

--pre-Checks
select id,created_at, start_date, end_date from deployments_personneldeployment;
select id, created_at, "end", closes,is_active from notifications_surgealert;
select * from deployments_deployedperson;

--Main date updates
update deployments_personneldeployment set created_at = current_date + interval '9 days' where created_at is not null;
update deployments_personneldeployment set end_date   = current_date + interval '9 days' where end_date is not null;
update notifications_surgealert        set "end"      = current_date + interval '9 days' where "end" is not null;
update notifications_surgealert        set created_at = current_date + interval '9 days' where created_at is not null;
update deployments_deployedperson      set end_date   = current_date + interval '9 days' where end_date is not null;

--Restore, if needed:
update deployments_personneldeployment
set end_date=d.end_date, created_at=d.created_at
from tmpdpd d where deployments_personneldeployment.id = d.id;

update notifications_surgealert
set "end"=d."end", created_at=d.created_at
from tmpnsa d where notifications_surgealert.id = d.id;

update deployments_deployedperson
set end_date=d.end_date
from tmpdpd d where deployments_deployedperson.id = d.id;
