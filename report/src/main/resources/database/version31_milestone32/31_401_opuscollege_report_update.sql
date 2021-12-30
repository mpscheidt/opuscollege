-- Opus College (c) UCI - Monique in het Veld March 2009
--
-- KERNEL opuscollege / MODULE report
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'report';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('report','A','Y',3.12);

