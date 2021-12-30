-- Opus College (c) UCI - Monique in het Veld March 2009
--
-- KERNEL opuscollege / MODULE report
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'report';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('report','A','Y',3.14);


INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('GENERATE_HISTORY_REPORTS','en','Y','Generate history reports');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin','GENERATE_HISTORY_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','GENERATE_HISTORY_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','GENERATE_HISTORY_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','GENERATE_HISTORY_REPORTS');

