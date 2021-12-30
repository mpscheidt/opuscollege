-- Opus College (c) UCI - Monique in het Veld March 2009
--
-- KERNEL opuscollege / MODULE report
-- 

-------------------------------------------------------
-- table appVersions
-------------------------------------------------------

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'report';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('report','A','Y',3.0);


-------------------------------------------------------
-- sequence reportProperties
-------------------------------------------------------
DROP SEQUENCE IF EXISTS opuscollege.reportPropertySeq CASCADE;

CREATE SEQUENCE opuscollege.reportPropertySeq;
ALTER TABLE opuscollege.reportPropertySeq OWNER TO postgres;

DROP TABLE IF EXISTS opuscollege.reportProperty CASCADE;


------------------------------------------------------
-- table reportProperty
-------------------------------------------------------

CREATE TABLE opuscollege.reportProperty (
    id INTEGER NOT NULL DEFAULT NEXTVAL('opuscollege.reportPropertySeq'),
    reportName VARCHAR NOT NULL,
    propertyName VARCHAR NOT NULL,
    propertyType VARCHAR NOT NULL,
    propertyFile BYTEA,
    propertyText VARCHAR ,
    visible BOOLEAN NOT NULL DEFAULT TRUE,
    active CHAR(1) NOT NULL DEFAULT 'Y',
    writeWho VARCHAR NOT NULL DEFAULT 'opuscollege',
    writeWhen TIMESTAMP NOT NULL DEFAULT now(),
    --
    PRIMARY KEY(id),
    UNIQUE(reportName , propertyName)
);
ALTER TABLE opuscollege.reportProperty OWNER TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, TRIGGER ON TABLE opuscollege.reportProperty TO postgres;


DROP TABLE IF EXISTS opuscollege.report CASCADE;
DROP SEQUENCE IF EXISTS opuscollege.reportSeq CASCADE;