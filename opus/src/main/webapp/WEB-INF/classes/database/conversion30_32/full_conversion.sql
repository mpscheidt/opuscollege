
-- #########
-- ### 1 ###
-- #########


SET search_path = opuscollege, pg_catalog;


CREATE SEQUENCE appconfigseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE cardinaltimeunitseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE cardinaltimeunitresultseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE cardinaltimeunitstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE cardinaltimeunitstudygradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE daypartseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE endgradeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE endgradegeneralseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE endgradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE failgradeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE gradedsecondaryschoolsubjectseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE groupedsecondaryschoolsubjectseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE htmlfieldseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE opusprivilegeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE opusrole_privilegeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE organizationalunitacademicyearseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE progressstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE requestforchangeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE rfcstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE secondaryschoolsubjectseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE secondaryschoolsubjectgroupseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE studentexpulsionseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE studentstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE studentstudentstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE studyplancardinaltimeunitseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE studyplanstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE thesisseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE thesisresultseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE thesisstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


CREATE TABLE appconfig (
    id integer DEFAULT nextval('appconfigseq'::regclass) NOT NULL,
    appconfigattributename character varying DEFAULT ''::character varying NOT NULL,
    appconfigattributevalue character varying DEFAULT ''::character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE authorisation (
    code character varying NOT NULL,
    description character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE cardinaltimeunit (
    id integer DEFAULT nextval('cardinaltimeunitseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    nrofunitsperyear integer DEFAULT 0 NOT NULL
);

CREATE TABLE cardinaltimeunitresult (
    id integer DEFAULT nextval('cardinaltimeunitresultseq'::regclass) NOT NULL,
    studyplanid integer DEFAULT 0 NOT NULL,
    studyplancardinaltimeunitid integer DEFAULT 0 NOT NULL,
    cardinaltimeunitresultdate date,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    passed character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    mark character varying,
    endgradecomment character varying
);

CREATE TABLE cardinaltimeunitstatus (
    id integer DEFAULT nextval('cardinaltimeunitstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    obsolete character(1) DEFAULT 'N'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL
);

CREATE TABLE cardinaltimeunitstudygradetype (
    id integer DEFAULT nextval('cardinaltimeunitstudygradetypeseq'::regclass) NOT NULL,
    studygradetypeid integer NOT NULL,
    cardinaltimeunitnumber integer DEFAULT 0 NOT NULL,
    numberofelectivesubjectblocks integer DEFAULT 0 NOT NULL,
    numberofelectivesubjects integer DEFAULT 0 NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE daypart (
    id integer DEFAULT nextval('daypartseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE endgrade (
    id integer DEFAULT nextval('endgradeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    endgradetypecode character varying NOT NULL,
    gradepoint numeric(5,2),
    percentagemin numeric(5,2),
    percentagemax numeric(5,2),
    comment character varying,
    description character varying,
    temporarygrade character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    passed character(1) DEFAULT 'N'::bpchar NOT NULL
);

CREATE TABLE endgradegeneral (
    id integer DEFAULT nextval('endgradegeneralseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    comment character varying,
    description character varying,
    temporarygrade character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE endgradetype (
    id integer DEFAULT nextval('endgradetypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE examinationresulthistory (
    id integer NOT NULL,
    examinationid integer NOT NULL,
    subjectid integer NOT NULL,
    studyplandetailid integer NOT NULL,
    examinationresultdate date,
    attemptnr integer NOT NULL,
    mark character varying,
    staffmemberid integer NOT NULL,
    active character(1) NOT NULL,
    writewho character varying NOT NULL,
    passed character(1) NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE failgrade (
    id integer DEFAULT nextval('failgradeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    comment character varying,
    description character varying,
    temporarygrade character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE gradedsecondaryschoolsubject (
    id integer DEFAULT nextval('gradedsecondaryschoolsubjectseq'::regclass) NOT NULL,
    secondaryschoolsubjectid integer NOT NULL,
    studyplanid integer NOT NULL,
    grade character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    secondaryschoolsubjectgroupid integer DEFAULT 0 NOT NULL
);

CREATE TABLE groupedsecondaryschoolsubject (
    id integer DEFAULT nextval('groupedsecondaryschoolsubjectseq'::regclass) NOT NULL,
    secondaryschoolsubjectid integer NOT NULL,
    secondaryschoolsubjectgroupid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    weight integer DEFAULT 0 NOT NULL,
    minimumgradepoint integer DEFAULT 0 NOT NULL,
    maximumgradepoint integer DEFAULT 0 NOT NULL
);

CREATE TABLE opusprivilege (
    id integer DEFAULT nextval('opusprivilegeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    validfrom date,
    validthrough date
);

CREATE TABLE opusrole_privilege (
    id integer DEFAULT nextval('opusrole_privilegeseq'::regclass) NOT NULL,
    privilegecode character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    "role" character varying,
    validfrom date,
    validthrough date,
    active character varying(1) DEFAULT 'Y'::character varying NOT NULL
);

CREATE TABLE organizationalunitacademicyear (
    id integer DEFAULT nextval('organizationalunitacademicyearseq'::regclass) NOT NULL,
    organizationalunitid integer NOT NULL,
    academicyearid integer NOT NULL,
    startofregistration date,
    endofregistration date,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE progressstatus (
    id integer DEFAULT nextval('progressstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    continuing character(1) DEFAULT 'N'::bpchar NOT NULL,
    increment character(1) DEFAULT 'N'::bpchar NOT NULL,
    graduating character(1) DEFAULT 'N'::bpchar NOT NULL,
    carrying character(1) DEFAULT 'N'::bpchar NOT NULL
);

CREATE TABLE requestadmissionperiod (
    startdate date NOT NULL,
    enddate date NOT NULL,
    academicyearid integer NOT NULL,
    numberofsubjectstograde integer,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE requestforchange (
    id integer DEFAULT nextval('requestforchangeseq'::regclass) NOT NULL,
    requestinguserid integer DEFAULT 0 NOT NULL,
    respondinguserid integer DEFAULT 0 NOT NULL,
    rfc text,
    comments text,
    entityid integer DEFAULT 0 NOT NULL,
    entitytypecode character varying NOT NULL,
    rfcstatuscode character varying NOT NULL,
    expirationdate date,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE rfcstatus (
    id integer DEFAULT nextval('rfcstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE secondaryschoolsubject (
    id integer DEFAULT nextval('secondaryschoolsubjectseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE secondaryschoolsubjectgroup (
    id integer DEFAULT nextval('secondaryschoolsubjectgroupseq'::regclass) NOT NULL,
    groupnumber integer NOT NULL,
    minimumnumbertograde integer NOT NULL,
    maximumnumbertograde integer NOT NULL,
    studygradetypeid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE studentexpulsion (
    id integer DEFAULT nextval('studentexpulsionseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    startdate date,
    enddate date,
    expulsiontypecode character varying,
    reasonforexpulsion character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE studentstatus (
    id integer DEFAULT nextval('studentstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE studentstudentstatus (
    id integer DEFAULT nextval('studentstudentstatusseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    startdate date,
    studentstatuscode character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE studygradetypeprerequisite (
    studygradetypeid integer NOT NULL,
    requiredstudygradetypeid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE studyplancardinaltimeunit (
    id integer DEFAULT nextval('studyplancardinaltimeunitseq'::regclass) NOT NULL,
    studyplanid integer NOT NULL,
    cardinaltimeunitnumber integer DEFAULT 0 NOT NULL,
    progressstatuscode character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    studygradetypeid integer DEFAULT 0 NOT NULL,
    cardinaltimeunitstatuscode character varying
);

CREATE TABLE studyplanresult (
    id integer DEFAULT nextval('examseq'::regclass) NOT NULL,
    studyplanid integer NOT NULL,
    examdate date,
    finalmark character(1) DEFAULT 'N'::bpchar NOT NULL,
    mark character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    passed character(1) DEFAULT 'N'::bpchar NOT NULL
);

CREATE TABLE studyplanstatus (
    id integer DEFAULT nextval('studyplanstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE subjectblockprerequisite (
    subjectblockid integer NOT NULL,
    subjectblockstudygradetypeid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE subjectprerequisite (
    subjectid integer NOT NULL,
    subjectstudygradetypeid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE thesis (
    id integer DEFAULT nextval('thesisseq'::regclass) NOT NULL,
    thesiscode character varying NOT NULL,
    thesisdescription character varying,
    thesiscontentdescription character varying,
    studyplanid integer NOT NULL,
    creditamount integer NOT NULL,
    brsapplyingtothesis character varying,
    brspassingthesis character varying,
    keywords character varying,
    researchers character varying,
    supervisors character varying,
    publications character varying,
    readingcommittee character varying,
    defensecommittee character varying,
    statusofclearness character varying,
    thesisstatuscode character varying NOT NULL,
    thesisstatusdate date DEFAULT now() NOT NULL,
    startacademicyearid integer,
    affiliationfee numeric(10,2) DEFAULT 0.00 NOT NULL,
    research character varying,
    nonrelatedpublications character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE thesisresult (
    id integer DEFAULT nextval('thesisresultseq'::regclass) NOT NULL,
    studyplanid integer DEFAULT 0 NOT NULL,
    thesisresultdate date,
    mark character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    passed character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    thesisid integer DEFAULT 0 NOT NULL
);

CREATE TABLE thesisstatus (
    id integer DEFAULT nextval('thesisstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);

ALTER TABLE academicfield
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: academicfield original: character(2) new: character(6) */;

ALTER TABLE academicyear
    ADD COLUMN startdate date,
    ADD COLUMN enddate date,
    ADD COLUMN nextacademicyearid integer DEFAULT 0 NOT NULL;

ALTER TABLE addresstype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: addresstype original: character(2) new: character(6) */;

ALTER TABLE administrativepost
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: administrativepost original: character(2) new: character(6) */;

ALTER TABLE appointmenttype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: appointmenttype original: character(2) new: character(6) */;

ALTER TABLE blocktype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: blocktype original: character(2) new: character(6) */;

ALTER TABLE bloodtype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: bloodtype original: character(2) new: character(6) */;

ALTER TABLE civilstatus
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: civilstatus original: character(2) new: character(6) */;

ALTER TABLE civiltitle
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: civiltitle original: character(2) new: character(6) */;

ALTER TABLE contractduration
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: contractduration original: character(2) new: character(6) */;

ALTER TABLE contracttype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: contracttype original: character(2) new: character(6) */;

ALTER TABLE country
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: country original: character(2) new: character(6) */;

ALTER TABLE district
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: district original: character(2) new: character(6) */;

ALTER TABLE educationtype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: educationtype original: character(2) new: character(6) */;

ALTER TABLE examinationtype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: examinationtype original: character(2) new: character(6) */;

ALTER TABLE examtype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: examtype original: character(2) new: character(6) */;

ALTER TABLE expellationtype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: expellationtype original: character(2) new: character(6) */;

ALTER TABLE fieldofeducation
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: fieldofeducation original: character(2) new: character(6) */;

ALTER TABLE frequency
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: frequency original: character(2) new: character(6) */;

ALTER TABLE "function"
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: function original: character(2) new: character(6) */;

ALTER TABLE functionlevel
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: functionlevel original: character(2) new: character(6) */;

ALTER TABLE gender
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: gender original: character(2) new: character(6) */;

ALTER TABLE gradetype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: gradetype original: character(2) new: character(6) */;

ALTER TABLE identificationtype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: identificationtype original: character(2) new: character(6) */;

ALTER TABLE "language"
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: language original: character(2) new: character(6) */;

ALTER TABLE levelofeducation
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: levelofeducation original: character(2) new: character(6) */;

ALTER TABLE masteringlevel
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: masteringlevel original: character(2) new: character(6) */;

ALTER TABLE nationality
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: nationality original: character(2) new: character(6) */;

ALTER TABLE opususer
    ADD COLUMN lang character(5) DEFAULT 'en'::bpchar NOT NULL,
    ADD COLUMN preferredorganizationalunitid integer DEFAULT 0 NOT NULL;

ALTER TABLE opususerrole
    ADD COLUMN validfrom date DEFAULT now() NOT NULL,
    ADD COLUMN validthrough date,
    ADD COLUMN organizationalunitid integer DEFAULT 0 NOT NULL,
    ADD COLUMN active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    ADD COLUMN institutionid integer DEFAULT 0 NOT NULL,
    ADD COLUMN branchid integer DEFAULT 0 NOT NULL;

ALTER TABLE profession
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: profession original: character(2) new: character(6) */;

ALTER TABLE province
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: province original: character(2) new: character(6) */;

ALTER TABLE relationtype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: relationtype original: character(2) new: character(6) */;

ALTER TABLE rigiditytype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: rigiditytype original: character(2) new: character(6) */;

ALTER TABLE "role"
    ADD COLUMN "level" integer NOT NULL DEFAULT 0, /*Default is removed later in other script */
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: role original: character(2) new: character(6) */;

ALTER TABLE staffmember
    ADD COLUMN startworkday time(5) without time zone,
    ADD COLUMN endworkday time(5) without time zone,
    ADD COLUMN teachingdaypartcode character varying,
    ADD COLUMN supervisingdaypartcode character varying;

ALTER TABLE stafftype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: stafftype original: character(2) new: character(6) */;

ALTER TABLE status
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: status original: character(2) new: character(6) */;

ALTER TABLE student
    ADD COLUMN foreignstudent character(1) DEFAULT 'N'::bpchar NOT NULL;

ALTER TABLE studyform
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: studyform original: character(2) new: character(6) */;

ALTER TABLE studygradetype
    ADD COLUMN studytimecode character varying,
    ADD COLUMN currentacademicyearid integer DEFAULT 0 NOT NULL,
    ADD COLUMN cardinaltimeunitcode character varying DEFAULT ''::character varying NOT NULL,
    ADD COLUMN numberofcardinaltimeunits integer DEFAULT 0 NOT NULL,
    ADD COLUMN maxnumberofcardinaltimeunits integer DEFAULT 0 NOT NULL,
    ADD COLUMN numberofsubjectspercardinaltimeunit integer DEFAULT 0 NOT NULL,
    ADD COLUMN maxnumberofsubjectspercardinaltimeunit integer DEFAULT 0 NOT NULL,
    ADD COLUMN brspassingsubject character varying,
    ADD COLUMN studyformcode character varying,
    ADD COLUMN maxnumberoffailedsubjectspercardinaltimeunit integer DEFAULT 0 NOT NULL;

ALTER TABLE studyplan
    ADD COLUMN studyplanstatuscode character varying,
    ADD COLUMN studyid integer DEFAULT 0 NOT NULL,
    ADD COLUMN gradetypecode character varying,
    ADD COLUMN minor1id integer DEFAULT 0 NOT NULL,
    ADD COLUMN major2id integer DEFAULT 0 NOT NULL,
    ADD COLUMN minor2id integer DEFAULT 0 NOT NULL,
    ADD COLUMN applicationnumber integer DEFAULT 0 NOT NULL;

ALTER TABLE studyplandetail
    ADD COLUMN studyplancardinaltimeunitid integer DEFAULT 0 NOT NULL,
    ADD COLUMN studygradetypeid integer DEFAULT 0 NOT NULL;

ALTER TABLE studytime
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: studytime original: character(2) new: character(6) */;

ALTER TABLE studytype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: studytype original: character(2) new: character(6) */;

ALTER TABLE subject
    ADD COLUMN currentacademicyearid integer DEFAULT 0 NOT NULL,
    ALTER COLUMN freechoiceoption SET DEFAULT 'N'::bpchar,
    ALTER COLUMN creditamount TYPE numeric(4,1) /* TYPE change - table: subject original: integer new: numeric(4,1) */,
    ALTER COLUMN creditamount DROP NOT NULL;

ALTER TABLE subjectblock
    ADD COLUMN brsapplyingtosubjectblock character varying,
    ADD COLUMN brspassingsubjectblock character varying,
    ADD COLUMN blocktypecode character varying,
    ADD COLUMN brsmaxcontacthours character varying,
    ADD COLUMN studytimecode character varying,
    ADD COLUMN currentacademicyearid integer DEFAULT 0 NOT NULL,
    ADD COLUMN primarystudyid integer DEFAULT 0 NOT NULL,
    ADD COLUMN importancecode character varying,
    ADD COLUMN freechoiceoption character(1) DEFAULT 'N'::bpchar,
    ALTER COLUMN targetgroupcode DROP NOT NULL;

ALTER TABLE subjectblockstudygradetype
    ADD COLUMN cardinaltimeunitnumber integer DEFAULT 0 NOT NULL,
    ADD COLUMN rigiditytypecode character varying;

ALTER TABLE subjectimportance
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: subjectimportance original: character(2) new: character(6) */;

ALTER TABLE subjectstudygradetype
    ADD COLUMN cardinaltimeunitnumber integer DEFAULT 0 NOT NULL,
    ADD COLUMN rigiditytypecode character varying;

ALTER TABLE targetgroup
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: targetgroup original: character(2) new: character(6) */;

ALTER TABLE timeunit
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: timeunit original: character(2) new: character(6) */;

ALTER TABLE unitarea
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: unitarea original: character(2) new: character(6) */;

ALTER TABLE unittype
    ALTER COLUMN lang TYPE character(6) /* TYPE change - table: unittype original: character(2) new: character(6) */;



-- #########
-- ### 2 ###
-- #########

-- delete studyplandetails without valid academic year info
DELETE FROM opuscollege.studyplandetail
WHERE academicyearcode = '-'
   OR academicyearcode = '0';

/**
Deletes duplicated academic years **/
DELETE FROM     "opuscollege".academicyear
        WHERE id NOT IN
    (SELECT MAX(id)
        FROM "opuscollege".academicyear AS dup
        GROUP BY dup.description);


/**
Finds tables with academicyearcode column and replace it with academicyearid
Replace codes with ids 

**/

CREATE OR REPLACE FUNCTION opuscollege.rename_col_academicyearcode_to_academicyearid()
  RETURNS integer AS
$BODY$
DECLARE
    mviews RECORD;
BEGIN
    

    FOR mviews IN select table_name from information_schema.columns where table_schema = 'opuscollege' and column_name = 'academicyearcode' and table_name != 'node_relationships_n_level' LOOP

   EXECUTE 'ALTER TABLE opuscollege.' || mviews.table_name || ' ADD COLUMN academicYearId INTEGER';
    EXECUTE 'UPDATE opuscollege.' || mviews.table_name || ' SET academicYearId = academicyear.id  FROM (SELECT id,code,description FROM opuscollege.academicyear 
    ) AS academicyear WHERE ' || mviews.table_name || '.academicyearcode = academicyear.code';
 EXECUTE 'ALTER TABLE opuscollege.' || mviews.table_name || '  DROP academicYearCode ';
    
    END LOOP;


    RETURN 1;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION opuscollege.rename_col_academicyearcode_to_academicyearid() OWNER TO postgres;

SELECT opuscollege.rename_col_academicyearcode_to_academicyearid();

DROP function opuscollege.rename_col_academicyearcode_to_academicyearid();

--ALTER table opuscollege.academicyear ADD column startDate DATE;
--ALTER table opuscollege.academicyear ADD column endDate DATE;

--ALTER table opuscollege.academicyear DROP column lang;
--ALTER table opuscollege.academicyear DROP column code;


-- set start date to 1st January for years like '2005', '2006'
UPDATE opuscollege.academicyear SET startDate =     
CAST((academicyear.description || '-01-01') AS DATE)
WHERE length(academicyear.description) <= 4;

-- set start date to 1st July for years like '2005/06', '2006/07'
UPDATE opuscollege.academicyear SET startDate =     
CAST((substring(academicyear.description from 1 for 4) || '-07-01') AS DATE)
WHERE length(academicyear.description) > 4;

-- set end date to 31st Dezember for years like '2005', '2006'
UPDATE opuscollege.academicyear SET endDate =   
CAST((academicyear.description || '-12-31') AS DATE)
WHERE length(academicyear.description) <= 4;

-- set end date to 30th June for years like '2005/06', '2006/07'
UPDATE opuscollege.academicyear SET endDate =
(CAST((substring(academicyear.description from 1 for 4) || '-06-30') AS DATE) + interval '1 year')
WHERE length(academicyear.description) > 4;

-------------------------------------------------------
-- table studyyear
-------------------------------------------------------
ALTER table opuscollege.studyyear ADD column academicYearId INTEGER  ;


DELETE FROM opuscollege.lookuptable WHERE lower(tablename) = 'academicyear';
DELETE FROM opuscollege.tabledependency WHERE lookuptableid = (SELECT id FROM opuscollege.LookupTable WHERE lower(LookupTable.tablename) = 'academicyear');



-- ##############
-- #### 3.0 #####
-- ##############


SET search_path = opuscollege, pg_catalog;


ALTER TABLE opususerrole
    DROP CONSTRAINT opususerrole_role_key;

ALTER TABLE opususerrole
    DROP CONSTRAINT opususerrole_lang_fkey;

ALTER TABLE subject
    DROP CONSTRAINT subject_subjectcode_key;

ALTER TABLE subjectblock
    DROP CONSTRAINT subjectblock_subjectblockcode_key;

ALTER TABLE subjectblockstudygradetype
    DROP CONSTRAINT subjectblockstudygradetype_subjectblockid_key;

ALTER TABLE subjectblockstudyyear
    DROP CONSTRAINT subjectblockstudyyear_studyyearid_fkey;


ALTER TABLE opuscollege.role ALTER column level DROP DEFAULT;


---##### Studyplan 

-- ##############
-- #### 3.1 #####
-- ##############


---##### Studyplan 

--status.code  to studyplanstatuscode mappings

---     -----------------------------------------------------------------------------------------
--      |statuscode|  status.description  | studyplanstatus.code | studyplanstatus.description |
----    -----------------------------------------------------------------------------------------
--      |    1      |  Active              |        3             |  Approved Initial Admission |
        -----------------------------------------------------------------------------------------
--      |    2      |  temporary inactive  |        10            |  temporary inactive |
        -----------------------------------------------------------------------------------------
--      |    4      |  Graduated           |        11            |    Graduated        |
        -----------------------------------------------------------------------------------------
--      |    6      |  Withdrawn           |        12            |     Withdrawn       |
--      -----------------------------------------------------------------------------------------
--      |    7      |   Reprovado          |         4            |  Rejected Initial Admission    |
--      -----------------------------------------------------------------------------------------
--      |    8      |  nunca frequentou    |        12             |   Withdrawn   |
--      -----------------------------------------------------------------------------------------
--      |    9      |    Anula Matricula   |        12            |      Withdrawn              |
--      -----------------------------------------------------------------------------------------
--      |    11     |Approved Registration |         3            | Approved Initial Admission  |
--      -----------------------------------------------------------------------------------------
--      |    12     |  Actively Registered |         3            |  Approved Initial Admission |
--      -----------------------------------------------------------------------------------------
--      |    null   |                      |         3            |  Approved Initial Admission |
--      -----------------------------------------------------------------------------------------

--migrate from Student.status to studyplan.statuscode
-- old code 1 (active) -> new code 3 (Approved initial admission)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '3'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '1')
 );
-- old code 2 (temporary inactive) -> new code 10 (temporary inactive)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '10'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '2')
 );
-- old code 4 (graduated) -> new code 11 (graduated)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '11'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '4')
 );
-- old code 6 (desistiu) -> new code 12 (withdrawn)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '12'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '6')
 );
-- old code 7 (reprovado) -> new code 4 (rejected initial admission)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '4'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '7')
 );
-- old code 8 (nunca frequentou) -> new code 12 (withdrawn)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '12'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '8')
 );
-- old code 9 (anula matricula) -> new code 12 (withdrawn)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '12'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '9')
 );
-- old code 11 (Approved Registration) -> new code 3 (Approved initial admission)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '3'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '11')
 );
-- old code 12 (actively registered) -> new code 3 (Approved initial admission)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '3'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode = '12')
 );
-- old code null -> new code 3 (Approved initial admission)
UPDATE opuscollege.StudyPlan SPa
SET studyplanStatusCode = '3'
WHERE EXISTS (
SELECT id FROM opuscollege.StudyPlan  SPb
INNER JOIN opuscollege.Student Student ON Student.studentId = SPb.studentId
WHERE (SPa.id = SPb.id)  AND (Student.statusCode is null)
 );


--######################### StudyGradeType #################################################

-- field numberOfYears has been removed in favor of numberOfCardinalTimeUnits
UPDATE opuscollege.StudyGradeType SET numberOfCardinalTimeUnits = numberOfYears;

-- set a high max number of subjects per year unit that won't be surpassed
---UPDATE opuscollege.StudyGradeType SET maxnumberofsubjectspercardinaltimeunit = 20;

-- set max number of failed subjects per year
UPDATE opuscollege.StudyGradeType SET maxnumberoffailedsubjectspercardinaltimeunit = 3;

--new field studyTimeCode takes its value from studyyear with same studygradetype(.id)
--new field studyTimeCode takes its value from studyyear with same studygradetype(.id)
UPDATE opuscollege.StudyGradeType SET studyTimeCode =
(SELECT studyTimeCode FROM opuscollege.StudyYear 
WHERE (StudyYear.studyGradeTypeId = StudyGradeType.Id)
ORDER BY StudyYear.id DESC
LIMIT 1
);
--following two statements copied from 30_030_opuscollege_update.sql , line 21
-- set default value for cardinalTimeUnitCode of existing records to studyyear (code '1'):
UPDATE opuscollege.studyGradeType SET cardinalTimeUnitCode = '1';
-- set default value for maxNumberOfCardinalTimeUnits of existing records to 7:
UPDATE opuscollege.studyGradeType SET maxNumberOfCardinalTimeUnits = 7;

----Create a copy of each studygradetype to each academic year
/*INSERT INTO opuscollege.StudyGradeType(
studyId
, gradeTypeCode
, active
, contactId
, registrationDate
, studyTimeCode
, currentAcademicYearId
, cardinalTimeUnitCode
, numberOfCardinalTimeUnits
, maxNumberOfCardinalTimeUnits
, numberOfSubjectsPerCardinalTimeUnit 
, maxNumberOfSubjectsPerCardinalTimeUnit
, brsPassingSubject
, studyFormCode
, maxNumberOfFailedSubjectsPerCardinalTimeUnit
) 
SELECT  
studyId
, gradeTypeCode
, StudyGradeType.active
, contactId
, registrationDate
, studyTimeCode
, AcademicYear.Id
, cardinalTimeUnitCode
, numberOfCardinalTimeUnits
, maxNumberOfCardinalTimeUnits
, numberOfSubjectsPerCardinalTimeUnit 
, maxNumberOfSubjectsPerCardinalTimeUnit
, brsPassingSubject
, studyFormCode
, maxNumberOfFailedSubjectsPerCardinalTimeUnit

FROM opuscollege.AcademicYear,opuscollege.StudyGradeType ;*/

ALTER TABLE opuscollege.StudyGradeType ADD COLUMN originalStudyGradeTypeId Integer NOT NULL DEFAULT 0;
INSERT INTO opuscollege.StudyGradeType(
studyId
, gradeTypeCode
, active
, contactId
, registrationDate
, studyTimeCode
, currentAcademicYearId
, cardinalTimeUnitCode
, numberOfCardinalTimeUnits
, maxNumberOfCardinalTimeUnits
, numberOfSubjectsPerCardinalTimeUnit 
, maxNumberOfSubjectsPerCardinalTimeUnit
, brsPassingSubject
, studyFormCode
, maxNumberOfFailedSubjectsPerCardinalTimeUnit
, originalStudyGradeTypeId
)  SELECT distinct
     
 StudygradeType.studyId
, StudygradeType.gradeTypeCode
, StudyGradeType.active
, contactId
, StudygradeType.registrationDate
, StudygradeType.studyTimeCode
, AcademicYear.Id
, cardinalTimeUnitCode
, numberOfCardinalTimeUnits
, maxNumberOfCardinalTimeUnits
, numberOfSubjectsPerCardinalTimeUnit 
, maxNumberOfSubjectsPerCardinalTimeUnit
, brsPassingSubject
, '1' -- study form: regular learning
, maxNumberOfFailedSubjectsPerCardinalTimeUnit
, StudyGradeType.id
    
FROM
     "opuscollege".StudyPlanDetail StudyPlanDetail 
     INNER JOIN "opuscollege".StudyPlan StudyPlan ON StudyPlanDetail.studyPlanId  = StudyPlan.id
     INNER JOIN "opuscollege".AcademicYear AcademicYear ON AcademicYear."id" = StudyPlanDetail."academicyearid"
     INNER JOIN "opuscollege".StudyYear StudyYear ON studyplandetail."studyyearid" = studyyear."id"
     INNER JOIN "opuscollege".StudyGradeType StudyGradeType ON ((StudyYear."studygradetypeid" = studygradeType."id")
     OR (StudyPlan.studyGradeTypeId = StudyGradeType.id))
          
     ORDER BY AcademicYear.id;

--replicate studyyears
--old study years (those which are not replicated ) will be removed at the end of the scripts so it doesnt break any dependencies
ALTER TABLE opuscollege.StudyYear ADD COLUMN originalStudyGradeTypeId Integer NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.StudyYear ADD COLUMN originalStudyYearId Integer NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.StudyYear ADD COLUMN currentAcademicYearId Integer; --to be used later when converting study years to subject blocks, subject
ALTER TABLE opuscollege.StudyYear ADD COLUMN primaryStudyId Integer; --to be used later when converting study years to subject blocks, subject blocks have a primaryStudyId

INSERT INTO opuscollege.StudyYear(
      studygradetypeid
    , yearnumber
    , yearnumbervariation
    , coursestructurevalidfromyear
    , coursestructurevalidthroughyear
    , creditamountoverall
    , creditamountperccompulsory
    , creditamountperccompulsoryfromlist
    , creditamountpercfreechoice
    , studyformcode
    , studytimecode
    , targetgroupcode
    , brsmaxcontacthours
    , brspassingstudyyear
    , registrationdate
    , originalStudyGradeTypeId
    , originalStudyYearId
    , currentAcademicYearId
    , primaryStudyId
)

SELECT distinct

     StudyGradeType.id
    , StudyYear.yearnumber
    , StudyYear.yearnumbervariation
    , StudyYear.coursestructurevalidfromyear
    , StudyYear.coursestructurevalidthroughyear
    , StudyYear.creditamountoverall
    , StudyYear.creditamountperccompulsory
    , StudyYear.creditamountperccompulsoryfromlist
    , StudyYear.creditamountpercfreechoice
    , StudyYear.studyformcode
    , StudyYear.studytimecode
    , StudyYear.targetgroupcode
    , StudyYear.brsmaxcontacthours
    , StudyYear.brspassingstudyyear
    , StudyYear.registrationdate
    , StudyYear.studygradetypeid -- originalStudyGradeTypeId
    , StudyYear.id -- originalStudyYearId
    , StudyGradeType.currentAcademicYearId
    , StudygradeType.studyId

    FROM opuscollege.StudyYear 
    INNER JOIN opuscollege.StudyGradeType ON (
      (StudyYear.studyGradeTypeId = StudyGradeType.originalStudyGradeTypeId)
        AND (StudyGradeType.originalStudyGradeTypeId != 0)
      )
    INNER JOIN opuscollege.studyplandetail ON studyplandetail.studyyearid = studyyear.id AND studyplandetail.academicyearid = studygradetype.currentAcademicYearId
;

--temporary column to be removed on drop columns script
ALTER TABLE opuscollege.Subject ADD COLUMN originalSubjectId Integer NOT NULL DEFAULT 0;

-- Create a copy of each Subject for which studyplandetails exist
INSERT INTO opuscollege.Subject(

     subjectcode
    , subjectdescription
    , subjectcontentdescription
    , primarystudyid
    , active
    , targetgroupcode
    , freechoiceoption
    , creditamount
    , hourstoinvest
    , frequencycode
    , studytimecode
    , examtypecode
    , maximumparticipants
    , brspassingsubject
    , registrationdate
    , currentacademicyearid
    , originalSubjectId
)

SELECT distinct
--   subjectcode || '_' || AcademicYear.description 
     subjectcode
    , subjectdescription
    , subjectcontentdescription
    , Subject.primarystudyid
    , Subject.active
    , Subject.targetgroupcode
    , Subject.freechoiceoption
    , creditamount
    , hourstoinvest
    , frequencycode
    , Subject.studytimecode
    , examtypecode
    , maximumparticipants
    , brspassingsubject
    , Subject.registrationdate
    , studyplandetail.academicYearid
    , Subject.id
  FROM --opuscollege.AcademicYear, opuscollege.Subject;
  opuscollege.studyplandetail
  LEFT OUTER JOIN opuscollege.studyyear studyyear ON studyplandetail.studyyearid = studyyear.id
  LEFT OUTER JOIN opuscollege.subjectstudyyear subjectstudyyear ON studyyear.id = subjectstudyyear.studyyearid

  INNER JOIN opuscollege.subject subject ON subjectstudyyear.subjectid = subject.id
             OR subject.id = studyplandetail.subjectid;


--SubjectStudyGradeType : set the SubjectId and StudyGradeTypeId according to academic year
UPDATE opuscollege.SubjectStudyGradeType SET 
subjectId = Subject.Id
,studyGradeTypeId = StudyGradeType.Id
,rigiditytypecode = '1'

FROM opuscollege.Subject,opuscollege.StudyGradeType
WHERE
    subjectId = Subject.originalSubjectId
AND studyGradeTypeId = StudyGradeType.originalStudyGradeTypeId
AND Subject.currentAcademicYearId = StudyGradeType.currentAcademicYearId
; 

--########################## Study Plan ############################################
--migrate from studyplan.studygradetypeid to studyplan.study.id & studyplan.gradetypecode
UPDATE opuscollege.StudyPlan SPa
SET gradeTypeCode = 
 (SELECT StudyGradeType.gradeTypeCode FROM opuscollege.StudyPlan SPb 
INNER JOIN  opuscollege.StudyGradeType ON SPa.studyGradeTypeId = StudyGradeType.id AND SPb.id = SPa.id
);

UPDATE opuscollege.StudyPlan SPa
SET studyId = 
 (SELECT StudyGradeType.studyId FROM opuscollege.StudyPlan SPb 
INNER JOIN  opuscollege.StudyGradeType ON SPa.studyGradeTypeId = StudyGradeType.id AND SPb.id = SPa.id
);

--##########################StudyPlanCardinalTimeUnit###############################

--Delete loose StudyPlanDetails
DELETE
FROM opuscollege.StudyPlanDetail
WHERE 
(subjectId = 0 AND studyYearId = 0)
OR (subjectId IS NULL AND studyYearId IS NULL)
OR (subjectId IS NULL AND studyYearId = 0)
OR (subjectId = 0 AND studyYearId IS NULL);


--set StudyGradeType on StudyPlanDetail according to academic year
UPDATE opuscollege.StudyPlanDetail SET StudyGradeTypeId =
StudyGradeType.id
FROM opuscollege.studyPlan, opuscollege.StudyGradeType
WHERE 
studyplandetail.studyplanid = studyplan.id
AND (StudyGradeType.currentAcademicYearId = StudyPlanDetail.academicYearId)
AND (StudyGradeType.gradeTypeCode = studyplan.gradeTypeCode)
AND (StudyGradeType.studyId = studyplan.studyId)
;

--create a new StudyPlanCardinalTimeUnit for each StudyPlanDetail
--create temporary StudyPlanDetailId column , to be used later
ALTER TABLE opuscollege.StudyPlanCardinalTimeUnit ADD COLUMN studyPlanDetailId Integer;

INSERT INTO opuscollege.StudyPlanCardinalTimeUnit(
  studyPlanId
, cardinalTimeUnitNumber
, studyGradeTypeId
, studyPlanDetailId
, cardinaltimeunitstatuscode
)
SELECT StudyPlanDetail.studyPlanId
    , StudyYear.yearNumber
    , StudyPlanDetail.studyGradeTypeId
    , StudyPlanDetail.id
    , '10'
FROM opuscollege.StudyPlanDetail StudyPlanDetail
INNER JOIN opuscollege.StudyPlan StudyPlan ON StudyPlanDetail.studyPlanId = StudyPlan.Id
INNER JOIN opuscollege.StudyYear ON StudyPlanDetail.studyYearId = StudyYear.id
WHERE (studyPlanDetail.studyYearId != 0) AND (studyPlanDetail.studyYearId IS NOT NULL)
;

--loose subjects
UPDATE opuscollege.StudyPlanDetail SET subjectId = Subject.id
FROM opuscollege.Subject 
WHERE 
(Subject.originalSubjectId = StudyPlandetail.subjectId)
AND (Subject.currentAcademicYearId = StudyPlanDetail.academicYearId)
;

--#### New StudyPlanDetail structure

--studyGradeTypeId maps to old studyplan.studyGradeTypeId
/* StudyPlanDetail.studyGradeTypeId is already done a few steps earlier
UPDATE opuscollege.StudyPlanDetail SPDa
SET studyGradeTypeId = 
(
SELECT studyPlan.studyGradeTypeId
FROM opuscollege.StudyPlanDetail SPDb
 INNER JOIN opuscollege.StudyPlan ON SPDb.studyPlanId = studyPlan.id AND SPDa.id = SPDb.id
);*/

--New StudyPlandetails reference StudyPlanCardinalTimeUnit and not StudyPlan
UPDATE opuscollege.StudyPlanDetail 
SET studyPlanCardinalTimeUnitId = StudyPlanCardinalTimeUnit.id 
FROM opuscollege.StudyPlanCardinalTimeUnit 
WHERE StudyPlanCardinalTimeUnit.studyPlanDetailid = StudyPlanDetail.id
;


--map old StudyYear to CardinalTimeUnits
INSERT INTO opuscollege.CardinalTimeUnitStudyGradeType(studyGradeTypeId, cardinalTimeUnitNumber)
SELECT distinct StudyYear.studyGradeTypeId, StudyYear.yearNumber FROM opuscollege.StudyYear StudyYear WHERE originalStudyYearId != 0; --include only new studyyears

--since studyyears have been replicated because of academic years the ids must be updated so the studyyearid on studyplandetail reflects those changes
--new version of opus has subjectblockid instead of studyyearid, however studyyearid is kept in this script for later ops
UPDATE opuscollege.StudyPlanDetail SET studyYearId = StudyYear.id, subjectBlockId = StudyYear.id
FROM opuscollege.StudyYear 
WHERE (StudyPlanDetail.StudyYearId = StudyYear.originalStudyYearId)
AND (StudyYear.currentAcademicYearId = StudyPlanDetail.academicYearId)
--AND (StudyYear.originalStudyYearId != 0) --include only new studyyears
;


-- ##############
-- #### 3.2 #####
-- ##############


-- subject teachers
-- following columns will be dropped later
ALTER TABLE opuscollege.subjectteacher ADD migrated boolean NOT NULL DEFAULT false;

INSERT INTO opuscollege.subjectTeacher (
  staffmemberid
, subjectid
, active
, migrated
) SELECT 
  staffmemberid
, subject.id
, subjectTeacher.active
, true
FROM opuscollege.subjectTeacher
INNER JOIN opuscollege.subject ON subjectTeacher.subjectId = subject.originalsubjectId;

DELETE FROM opuscollege.subjectTeacher WHERE migrated = false;


-- didactical forms for subject (subjectstudytype)
-- following columns will be dropped later
ALTER TABLE opuscollege.subjectStudyType ADD migrated boolean NOT NULL DEFAULT false;

INSERT INTO opuscollege.subjectStudyType (
  subjectid
, studytypecode
, active
, migrated
) SELECT
  subject.id
, studytypecode
, subjectStudyType.active
, true
FROM opuscollege.subjectStudyType
INNER JOIN opuscollege.subject ON subjectStudyType.subjectId = subject.originalsubjectId;

DELETE FROM opuscollege.subjectStudyType WHERE migrated = false;


-- subject results:
-- first mark subject results that are currently invisible (probably unintentionally)
-- and include subjects related to invisible subject results in migration
-- column will be dropped later
/*ALTER TABLE opuscollege.subjectResult ADD COLUMN invisible boolean NOT NULL DEFAULT false;
UPDATE opuscollege.subjectResult SET invisible = true
WHERE id in (
    select distinct subjectresult.id from opuscollege.subjectresult
    inner join opuscollege.studyplandetail on subjectresult.studyplandetailid = studyplandetail.id
    where not exists (
    select * from opuscollege.subject where subject.originalsubjectid = subjectresult.subjectid
      and subject.currentacademicyearid = studyplandetail.academicyearid
    )
);*/


-- Recover 'invisible subject results':
-- Transfer subjects related to invisible subject results (to avoid losing these subject results)
/*INSERT INTO opuscollege.Subject(

     subjectcode
    , subjectdescription
    , subjectcontentdescription
    , primarystudyid
    , active
    , targetgroupcode
    , freechoiceoption
    , creditamount
    , hourstoinvest
    , frequencycode
    , studytimecode
    , examtypecode
    , maximumparticipants
    , brspassingsubject
    , registrationdate
    , currentacademicyearid
    , originalSubjectId
)

SELECT distinct
--   subjectcode || '_' || AcademicYear.description 
     subjectcode
    , subjectdescription
    , subjectcontentdescription
    , Subject.primarystudyid
    , Subject.active
    , Subject.targetgroupcode
    , Subject.freechoiceoption
    , creditamount
    , hourstoinvest
    , frequencycode
    , Subject.studytimecode
    , examtypecode
    , maximumparticipants
    , brspassingsubject
    , Subject.registrationdate
    , studyplandetail.academicYearid
    , Subject.id
  FROM opuscollege.SubjectResult
  INNER JOIN opuscollege.subject ON subjectresult.subjectid = subject.id
  INNER JOIN opuscollege.studyplandetail ON subjectresult.studyplandetailid = studyplandetail.id 
  WHERE subjectresult.invisible = true
;*/


-- subject results
UPDATE opuscollege.subjectResult SET subjectId = subject.id
FROM opuscollege.studyplandetail, opuscollege.subject
WHERE subjectResult.studyPlanDetailId = studyPlanDetail.id
and Subject.originalSubjectId = subjectResult.subjectId
AND Subject.currentAcademicYearId = StudyPlanDetail.academicYearId;





--###########Replicate exams for each Subject/AcademicYear

--### following columns will be dropped later
ALTER TABLE opuscollege.Examination ADD originalExaminationId Integer NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.Examination ADD currentAcademicYearId Integer NOT NULL DEFAULT 0;

INSERT INTO opuscollege.Examination(
    examinationcode
    , examinationdescription
    , subjectid
    , examinationtypecode
    , numberofattempts
    , weighingfactor
    , brspassingexamination
    , active
    , originalExaminationId
    , currentAcademicYearId
    )
  
SELECT 
    Examination.examinationCode
    , Examination.examinationDescription
    , Subject.id
    , Examination.examinationTypeCode
    , Examination.numberOfAttempts
    , Examination.weighingFactor
    , Examination.brsPassingExamination
    , Examination.active
    , Examination.id
    , Subject.currentAcademicYearId
FROM opuscollege.Examination
INNER JOIN opuscollege.Subject ON Subject.originalSubjectId = Examination.subjectId
;


--#tables that depend on examination

-- examinationteacher 
-- examinationresult
-- test
-- testteacher
-- testresult

--UPDATE opuscollege.ExaminationTeacher SET ExaminationId = Examination.id
--FROM opuscollege.Examination 
--WHERE Examination.originalExaminationId = examinationId;

-- following columns will be dropped later
ALTER TABLE opuscollege.ExaminationTeacher ADD migrated boolean NOT NULL DEFAULT false;

INSERT INTO opuscollege.ExaminationTeacher (
  staffmemberid
, examinationid
, active
, migrated
) SELECT 
  staffmemberid
, examination.id
, ExaminationTeacher.active
, true
FROM opuscollege.ExaminationTeacher
INNER JOIN opuscollege.Examination ON ExaminationTeacher.examinationId = examination.originalExaminationId;

DELETE FROM opuscollege.ExaminationTeacher WHERE migrated = false;


--##############################################################################################################################################
--####set the right examination for the right academic year


UPDATE opuscollege.examinationresult
    SET examinationId = Examination.id
        ,subjectId  = Subject.id

FROM opuscollege.Subject, opuscollege.Examination, opuscollege.StudyPlanDetail

WHERE (Subject.originalSubjectId = ExaminationResult.subjectId) 
AND (ExaminationResult.examinationId = Examination.originalExaminationId)
AND (Examination.currentAcademicYearId = Subject.currentAcademicYearId)
AND (Subject.currentAcademicYearId = StudyPlanDetail.academicYearId)
AND (ExaminationResult.studyPlanDetailId = StudyPlanDetail.id)
;

--##############################################################################################################################################

--### following columns will be dropped later
ALTER TABLE opuscollege.Test ADD originalTestId Integer NOT NULL DEFAULT 0;
ALTER TABLE opuscollege.Test ADD currentAcademicYearId Integer NOT NULL DEFAULT 0;

INSERT INTO opuscollege.Test(           
        testCode
           , testDescription
           , examinationId
           , examinationTypeCode
           , numberofAttempts
           , weighingFactor
           , minimumMark
           , maximumMark
           , brsPassingTest
           , active
           , originalTestId
       , currentAcademicYearId
    )
SELECT testCode
    , testDescription
    , Examination.id
    , Test.examinationTypeCode
    , Test.numberOfAttempts
    , Test.weighingFactor
    , minimumMark
    , maximummark
    , brsPassingTest
    , Test.active
    , test.id
    , Examination.currentAcademicYearId
  FROM opuscollege.test
  INNER JOIN opuscollege.Examination ON Examination.originalExaminationId = Test.examinationId
;


-- test teacher
-- following columns will be dropped later
ALTER TABLE opuscollege.testTeacher ADD migrated boolean NOT NULL DEFAULT false;

INSERT INTO opuscollege.testTeacher (
  staffmemberid
, testid
, active
, migrated
) SELECT 
  staffmemberid
, test.id
, testTeacher.active
, true
FROM opuscollege.testTeacher
INNER JOIN opuscollege.test ON testTeacher.testId = test.originalTestId;

DELETE FROM opuscollege.testTeacher WHERE migrated = false;


UPDATE opuscollege.TestResult 
    SET testId = Test.id, examinationId = Examination.id
FROM opuscollege.Test, opuscollege.examination, opuscollege.StudyPlanDetail
WHERE       (TestResult.testId = Test.originalTestId)
    AND (TestResult.studyPlanDetailId = StudyPlanDetail.id)
    AND (Test.currentAcademicYearId = StudyPlanDetail.academicYearId)
    AND TestResult.examinationId = examination.originalExaminationId
    AND examination.currentAcademicYearId = StudyPlanDetail.academicYearId;




-- ###########
-- ### 4.0 ###
-- ###########

--Migrate data from study years to subject blocks
--ALTER TABLE opuscollege.SubjectBlock ADD COLUMN originalStudyYearId Integer;
INSERT INTO opuscollege.SubjectBlock(
          id
    , subjectBlockCode
    , subjectBlockDescription
    , active
    , targetGroupCode
    , registrationDate
    , brsPassingSubjectBlock
    , blockTypeCode
    , brsMaxContactHours
    , studyTimeCode
    , currentAcademicYearId
    , primaryStudyId
    , freeChoiceOption
)
SELECT StudyYear.id
    , 'SB' || StudyYear.id
    --, yearNumber || '° ano'
    , yearNumberVariation
    , 'Y'
    , StudyYear.targetGroupCode
    , StudyYear.registrationDate
    , StudyYear.brsPassingStudyYear
    , '2' /*study year*/
    , StudyYear.studyTimeCode
    , StudyYear.brsMaxContactHours
    , StudyYear.currentAcademicYearId
    , StudyYear.primaryStudyId 
    , 'Y'
  FROM opuscollege.StudyYear
  WHERE StudyYear.originalStudyYearId != 0 --include only new studyyears
;

-- because the id has been hard-coded, the next value for the sequence needs to be set manually
SELECT setval('opuscollege.subjectblockseq', (select max(id) from opuscollege.subjectblock));

--Migrate from SubjectStudyYear to SubjectBlock
--To do SubjectStudyYear combination for each academic year
INSERT INTO opuscollege.SubjectSubjectBlock (
    subjectId, subjectBlockId
    )
SELECT Subject.id, studyyear.id
FROM opuscollege.SubjectStudyYear
INNER JOIN opuscollege.Subject ON Subject.originalSubjectId = SubjectStudyYear.subjectId
INNER JOIN opuscollege.studyyear ON studyyear.originalStudyYearId = SubjectStudyYear.studyYearId
WHERE Subject.currentAcademicYearId = studyyear.currentAcademicYearid
;

-- recover invisible subject results by adding respective subjects to subject blocks
/*INSERT INTO opuscollege.SubjectSubjectBlock (
    subjectId
  , subjectBlockId
)
SELECT DISTINCT 
    subjectResult.subjectId
  , studyplandetail.subjectBlockId
  FROM opuscollege.subjectResult
  inner join opuscollege.studyplandetail studyplandetail on subjectresult.studyplandetailid = studyplandetail.id
WHERE subjectresult.invisible = true
and studyplandetail.subjectBlockId != 0
;*/

/*INSERT INTO opuscollege.studyplandetail (
    studyPlanId
  , subjectId
  , studyplancardinaltimeunitid
  , studyGradeTypeid
  , acadedemicYearId
)
SELECT 
    origSPD.studyPlanId
  , subjectResult.subjectId
  , origSPD.studyPlanCardinalTimeUnitId
  , origSPD.studyGradeTypeId
  , origSPD.academicyearid
  FROM opuscollege.subjectResult
    inner join opuscollege.studyplandetail origSPD on subjectresult.studyplandetailid = origSPD.id
--  INNER JOIN opuscollege.subject ON subjectresult.subjectid = subject.Id
WHERE subjectresult.invisible = true
;*/

-- subjectblock associations with studygradetypes
INSERT INTO opuscollege.subjectBlockStudyGradeType (
    subjectblockid
  , studygradetypeid
  , cardinaltimeunitnumber
  , rigiditytypecode
)
SELECT
    studyyear.id
  , studyyear.studygradetypeid
  , studyyear.yearnumber
  , '1'
FROM opuscollege.studyyear
WHERE originalstudyyearid != 0
;

    
-- ###########
-- ### 5.0 ###
-- ###########

-----
----Copy lang values from OpusUserRole.lang to OpusUser.lang
---

UPDATE opuscollege.OpusUser SET lang = (SELECT lang FROM opuscollege.OpusUserRole WHERE OpusUserRole.username = OpusUser.username);



----
---Set the organizationalId role for staff users
UPDATE opuscollege.OpusUserRole SET organizationalUnitId = 
primaryUnitOfAppointmentId
FROM opuscollege.StaffMember, opuscollege.OpusUser

WHERE (StaffMember.personId = OpusUser.personId)
     AND (OpusUser.userName = OpusUserRole.userName);


----
---Set the organizationalId role for student users
UPDATE opuscollege.OpusUserRole SET organizationalUnitId = 
Study.organizationalUnitId
FROM opuscollege.Student, opuscollege.OpusUser, opuscollege.Study

WHERE (Student.personId = OpusUser.personId)
     AND (OpusUser.userName = OpusUserRole.userName)
     AND (Study.id = Student.primaryStudyId);


UPDATE opuscollege.OpusUserRole SET organizationalUnitId = 0 WHERE organizationalUnitId is NULL;

--assign a preferedOrganizationalUnit, the first in the list
UPDATE opuscollege.OpusUser OUa SET preferredOrganizationalUnitId = 
(SELECT organizationalUnitId FROM opuscollege.OpusUserRole
INNER JOIN opuscollege.OpusUser OUb ON 
((OUb.userName = OpusUserRole.UserName) AND (OUa.userName = OUb.userName))
 LIMIT 1
 );


UPDATE opuscollege.role SET level=1 WHERE role='admin';
UPDATE opuscollege.role SET level=2 WHERE role='admin-C';
UPDATE opuscollege.role SET level=3 WHERE role='admin-B';
UPDATE opuscollege.role SET level=4 WHERE role='admin-D';
UPDATE opuscollege.role SET level=5 WHERE role='teacher' OR role='staff';
UPDATE opuscollege.role SET level=6 WHERE role='student';
UPDATE opuscollege.role SET level=7 WHERE role='guest';


-- ###########
-- ### 6.2 ###
-- ###########

--drop records with no academicyear associated
DELETE FROM opuscollege.StudyGradeType WHERE originalStudyGradeTypeId = 0;
DELETE FROM opuscollege.Examination WHERE originalExaminationId = 0;
DELETE FROM opuscollege.Test WHERE originalTestId = 0;
DELETE FROM opuscollege.Subject WHERE originalSubjectId = 0 ;


-- ###########
-- ### 6.3 ###
-- ###########

SET search_path = opuscollege, pg_catalog;
/*
ALTER TABLE opususerrole
    DROP CONSTRAINT opususerrole_role_key;

ALTER TABLE opususerrole
    DROP CONSTRAINT opususerrole_lang_fkey;

ALTER TABLE subject
    DROP CONSTRAINT subject_subjectcode_key;

ALTER TABLE subjectblock
    DROP CONSTRAINT subjectblock_subjectblockcode_key;

ALTER TABLE subjectblockstudygradetype
    DROP CONSTRAINT subjectblockstudygradetype_subjectblockid_key;

ALTER TABLE subjectblockstudyyear
    DROP CONSTRAINT subjectblockstudyyear_studyyearid_fkey;
*/
DROP TABLE exam;

DROP TABLE markevaluation;

DROP TABLE studyyear CASCADE;

DROP TABLE subjectstudyyear;

DROP SEQUENCE markevaluationseq;

DROP SEQUENCE studyyearseq;

DROP SEQUENCE subjectstudyyearseq;

ALTER TABLE academicyear
    DROP COLUMN code,
    DROP COLUMN lang;

ALTER TABLE opususerrole
    DROP COLUMN lang;

ALTER TABLE student
    DROP COLUMN statuscode;

ALTER TABLE studygradetype
    DROP COLUMN numberofyears;

ALTER TABLE studyplan
    DROP COLUMN studygradetypeid;

ALTER TABLE studyplandetail
    DROP COLUMN studyyearid;

ALTER TABLE subject
    DROP COLUMN rigiditytypecode,
    DROP COLUMN subjectimportancecode,
    DROP COLUMN studyformcode,
    DROP COLUMN brsapplyingtosubject,
    DROP COLUMN subjectstructurevalidfromyear,
    DROP COLUMN subjectstructurevalidthroughyear;

ALTER TABLE subjectblock
    DROP COLUMN brsapplyingtoblock,
    DROP COLUMN subjectblockstructurevalidfromyear,
    DROP COLUMN subjectblockstructurevalidthroughyear;


--drop temporary columns
ALTER TABLE Examination DROP COLUMN originalExaminationId;
ALTER TABLE Examination DROP COLUMN currentAcademicYearId;

ALTER TABLE Test DROP COLUMN originalTestId;
ALTER TABLE Test DROP COLUMN currentAcademicYearId;



ALTER TABLE opuscollege.Subject DROP COLUMN originalSubjectId;
ALTER TABLE opuscollege.StudyGradeType DROP COLUMN originalStudyGradeTypeId;


ALTER TABLE opuscollege.StudyPlanCardinalTimeUnit DROP COLUMN studyPlanDetailId ;


ALTER TABLE opuscollege.subjectteacher DROP COLUMN migrated;
ALTER TABLE opuscollege.subjectStudyType DROP COLUMN migrated;
ALTER TABLE opuscollege.ExaminationTeacher DROP COLUMN migrated;
ALTER TABLE opuscollege.testTeacher DROP COLUMN migrated;



-- #########
-- ### 7 ###
-- #########




ALTER TABLE appconfig
    ADD CONSTRAINT appconfig_pkey PRIMARY KEY (appconfigattributename);

ALTER TABLE authorisation
    ADD CONSTRAINT authorisation_pkey PRIMARY KEY (code);

ALTER TABLE cardinaltimeunit
    ADD CONSTRAINT cardinaltimeunit_pkey PRIMARY KEY (id, lang);

ALTER TABLE cardinaltimeunitresult
    ADD CONSTRAINT cardinaltimeunitresult_pkey PRIMARY KEY (id);

ALTER TABLE cardinaltimeunitstatus
    ADD CONSTRAINT cardinaltimeunitstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE cardinaltimeunitstudygradetype
    ADD CONSTRAINT cardinaltimeunitstudygradetype_pkey PRIMARY KEY (id);

ALTER TABLE daypart
    ADD CONSTRAINT daypart_pkey PRIMARY KEY (id, lang);

ALTER TABLE endgrade
    ADD CONSTRAINT endgrade_pkey PRIMARY KEY (id);

ALTER TABLE endgradegeneral
    ADD CONSTRAINT endgradegeneral_pkey PRIMARY KEY (id);

ALTER TABLE endgradetype
    ADD CONSTRAINT endgradetype_pkey PRIMARY KEY (id, lang);

ALTER TABLE failgrade
    ADD CONSTRAINT failgrade_pkey PRIMARY KEY (id);

ALTER TABLE gradedsecondaryschoolsubject
    ADD CONSTRAINT gradedsecondaryschoolsubject_pkey PRIMARY KEY (id);

ALTER TABLE groupedsecondaryschoolsubject
    ADD CONSTRAINT groupedsecondaryschoolsubject_pkey PRIMARY KEY (id);

ALTER TABLE opusprivilege
    ADD CONSTRAINT opusprivilege_pkey PRIMARY KEY (id, lang);

ALTER TABLE opusrole_privilege
    ADD CONSTRAINT opusrole_privilege_pkey PRIMARY KEY (id);

ALTER TABLE organizationalunitacademicyear
    ADD CONSTRAINT organizationalunitacademicyear_pkey PRIMARY KEY (organizationalunitid, academicyearid);

ALTER TABLE progressstatus
    ADD CONSTRAINT progressstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE requestadmissionperiod
    ADD CONSTRAINT requestadmissionperiod_pkey PRIMARY KEY (startdate, enddate, academicyearid);

ALTER TABLE requestforchange
    ADD CONSTRAINT requestforchange_pkey PRIMARY KEY (id);

ALTER TABLE rfcstatus
    ADD CONSTRAINT rfcstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE secondaryschoolsubject
    ADD CONSTRAINT secondaryschoolsubject_pkey PRIMARY KEY (id, lang);

ALTER TABLE secondaryschoolsubjectgroup
    ADD CONSTRAINT secondaryschoolsubjectgroup_pkey PRIMARY KEY (id);

ALTER TABLE studentexpulsion
    ADD CONSTRAINT studentexpulsion_pkey PRIMARY KEY (id);

ALTER TABLE studentstatus
    ADD CONSTRAINT studentstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE studentstudentstatus
    ADD CONSTRAINT studentstudentstatus_pkey PRIMARY KEY (id);

ALTER TABLE studygradetypeprerequisite
    ADD CONSTRAINT studygradetypeprerequisite_pkey PRIMARY KEY (studygradetypeid, requiredstudygradetypeid);

ALTER TABLE studyplancardinaltimeunit
    ADD CONSTRAINT studyplancardinaltimeunit_pkey PRIMARY KEY (id);

ALTER TABLE studyplanresult
    ADD CONSTRAINT exam_pkey PRIMARY KEY (id);

ALTER TABLE studyplanstatus
    ADD CONSTRAINT studyplanstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE subjectblockprerequisite
    ADD CONSTRAINT subjectblockprerequisite_pkey PRIMARY KEY (subjectblockid, subjectblockstudygradetypeid);

ALTER TABLE subjectprerequisite
    ADD CONSTRAINT subjectprerequisite_pkey PRIMARY KEY (subjectid, subjectstudygradetypeid);

ALTER TABLE thesis
    ADD CONSTRAINT thesis_pkey PRIMARY KEY (id);

ALTER TABLE thesisresult
    ADD CONSTRAINT thesisresult_pkey PRIMARY KEY (id);

ALTER TABLE thesisstatus
    ADD CONSTRAINT thesisstatus_pkey PRIMARY KEY (id, lang);

ALTER TABLE cardinaltimeunit
    ADD CONSTRAINT cardinaltimeunit_id_key UNIQUE (id);

ALTER TABLE cardinaltimeunitresult
    ADD CONSTRAINT cardinaltimeunitresult_studyplanid_key UNIQUE (studyplanid, studyplancardinaltimeunitid);

ALTER TABLE cardinaltimeunitstatus
    ADD CONSTRAINT cardinaltimeunitstatus_id_key UNIQUE (id);

ALTER TABLE cardinaltimeunitstudygradetype
    ADD CONSTRAINT cardinaltimeunitstudygradetype_studygradetypeid_fkey FOREIGN KEY (studygradetypeid) REFERENCES studygradetype(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE daypart
    ADD CONSTRAINT daypart_id_key UNIQUE (id);

ALTER TABLE endgradetype
    ADD CONSTRAINT endgradetype_id_key UNIQUE (id);

ALTER TABLE examinationresulthistory
    ADD CONSTRAINT examinationresulthistory_examinationid_fkey FOREIGN KEY (examinationid) REFERENCES examination(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE examinationresulthistory
    ADD CONSTRAINT examinationresulthistory_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE examinationresulthistory
    ADD CONSTRAINT examinationresulthistory_studyplandetailid_fkey FOREIGN KEY (studyplandetailid) REFERENCES studyplandetail(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE examinationresulthistory
    ADD CONSTRAINT examinationresulthistory_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE gradedsecondaryschoolsubject
    ADD CONSTRAINT gradedsecondaryschoolsubject_secondaryschoolsubjectid_key UNIQUE (secondaryschoolsubjectid, studyplanid);

ALTER TABLE groupedsecondaryschoolsubject
    ADD CONSTRAINT groupedsecondaryschoolsubject_secondaryschoolsubjectid_key UNIQUE (secondaryschoolsubjectid, secondaryschoolsubjectgroupid);

ALTER TABLE opusprivilege
    ADD CONSTRAINT opusprivilege_id_key UNIQUE (id);

ALTER TABLE opusprivilege
    ADD CONSTRAINT opusprivilege_lang_key UNIQUE (lang, code);

ALTER TABLE opususerrole
    ADD CONSTRAINT user_organizationalunit_unique_constraint UNIQUE (username, organizationalunitid);

ALTER TABLE organizationalunitacademicyear
    ADD CONSTRAINT organizationalunitacademicyear_academicyearid_fkey FOREIGN KEY (academicyearid) REFERENCES academicyear(id);

ALTER TABLE organizationalunitacademicyear
    ADD CONSTRAINT organizationalunitacademicyear_organizationalunitid_fkey FOREIGN KEY (organizationalunitid) REFERENCES organizationalunit(id);

ALTER TABLE progressstatus
    ADD CONSTRAINT progressstatus_id_key UNIQUE (id);

ALTER TABLE rfcstatus
    ADD CONSTRAINT rfcstatus_id_key UNIQUE (id);

ALTER TABLE secondaryschoolsubject
    ADD CONSTRAINT secondaryschoolsubject_id_key UNIQUE (id);

ALTER TABLE secondaryschoolsubjectgroup
    ADD CONSTRAINT secondaryschoolsubjectgroup_groupnumber_key UNIQUE (groupnumber, studygradetypeid);

ALTER TABLE studentexpulsion
    ADD CONSTRAINT studentexpulsion_startdate_key UNIQUE (startdate, enddate);

ALTER TABLE studentexpulsion
    ADD CONSTRAINT studentexpulsion_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE studentstatus
    ADD CONSTRAINT studentstatus_id_key UNIQUE (id);

ALTER TABLE studentstudentstatus
    ADD CONSTRAINT studentstudentstatus_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE studygradetype
    ADD CONSTRAINT study_gradetype_studyform_studytime_academicyear_key UNIQUE (studyid, gradetypecode, studyformcode, studytimecode, currentacademicyearid);

ALTER TABLE studyplancardinaltimeunit
    ADD CONSTRAINT studyplancardinaltimeunit_studyplanid_fkey FOREIGN KEY (studyplanid) REFERENCES studyplan(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE studyplanresult
    ADD CONSTRAINT exam_studyplanid_key UNIQUE (studyplanid);

ALTER TABLE studyplanresult
    ADD CONSTRAINT exam_studyplanid_fkey FOREIGN KEY (studyplanid) REFERENCES studyplan(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE studyplanstatus
    ADD CONSTRAINT studyplanstatus_id_key UNIQUE (id);

ALTER TABLE subject
    ADD CONSTRAINT subject_subjectcode_subjectdescription_currentacademicyearid_ke UNIQUE (subjectcode, subjectdescription, currentacademicyearid);

ALTER TABLE subjectblock
    ADD CONSTRAINT subjectblock_subjectblockcode_currentacademicyearid_key UNIQUE (subjectblockcode, currentacademicyearid);

ALTER TABLE subjectblockstudygradetype
    ADD CONSTRAINT subjectblockstudygradetype_subjectblockid_key UNIQUE (subjectblockid, studygradetypeid, cardinaltimeunitnumber, rigiditytypecode);

ALTER TABLE thesis
    ADD CONSTRAINT thesis_thesiscode_key UNIQUE (thesiscode);

ALTER TABLE thesisresult
    ADD CONSTRAINT thesisresult_studyplanid_key UNIQUE (studyplanid);

ALTER TABLE thesisstatus
    ADD CONSTRAINT thesisstatus_id_key UNIQUE (id);

    
-- #########
-- ### 9 ###
-- #########

DELETE FROM  opuscollege.opusprivilege where lang = 'en';

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('ADMINISTER_SYSTEM','en','Y','Perform changes on system configuration');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('APPROVE_SUBJECT_SUBSCRIPTIONS','en','Y','Approve subject subscriptions');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('GENERATE_STUDENT_REPORTS','en','Y','Generate student reports');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('GENERATE_STATISTICS','en','Y','Generate statistics');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ACADEMIC_YEARS','en','Y','Create academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_BRANCHES','en','Y','Create branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_CHILD_ORG_UNITS','en','Y','Show child organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_EXAMINATIONS','en','Y','Create exams');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_EXAMINATION_SUPERVISORS','en','Y','Assign examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FEES','en','Y','Create fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FOREIGN_STUDYPLAN_DETAILS','en','Y','Create studyplan details from other universities in a studyplan');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_FOREIGN_STUDYPLAN_RESULTS','en','Y','Create studyplan results for studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_INSTITUTIONS','en','Y','Create institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_LOOKUPS','en','Y','Create lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ORG_UNITS','en','Y','Create organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL','en','Y','Allow each student to subscribe to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_ROLES','en','Y','Create roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SECONDARY_SCHOOLS','en','Y','Create organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBERS','en','Y','Create Staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBER_ADDRESSES','en','Y','Create staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STAFFMEMBER_CONTRACTS','en','Y','Create staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENTS','en','Y','Create all students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDY_PLANS','en','Y','Create study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_ABSENCES','en','Y','Create student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDENT_ADDRESSES','en','Y','Create student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDIES','en','Y','Create studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDY_ADDRESSES','en','Y','Create study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYGRADETYPES','en','Y','Create study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTS','en','Y','Create subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_PREREQUISITES','en','Y','Define subjects prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_STUDYGRADETYPES','en','Y','Assign subjects to study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_SUBJECTBLOCKS','en','Y','Assign subjects to subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECT_TEACHERS','en','Y','Assign subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCKS','en','Y','Create subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCK_PREREQUISITES','en','Y','Define subject block prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_SUBJECTBLOCK_STUDYGRADETYPES','en','Y','Assign subject blocks to study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLAN_RESULTS','en','Y','Create studyplan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLANDETAILS','en','Y','Subscribe students to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_STUDYPLANDETAILS_PENDING_APPROVAL','en','Y','Subscribe students to subjects and subject blocks pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_TEST_SUPERVISORS','en','Y','Assign test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('CREATE_USER_ROLES','en','Y','Create what roles users are assigned to');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ACADEMIC_YEARS','en','Y','Delete academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_BRANCHES','en','Y','Delete branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_CHILD_ORG_UNITS','en','Y','Delete child organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_EXAMINATIONS','en','Y','Delete examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_EXAMINATION_SUPERVISORS','en','Y','Delete examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_FEES','en','Y','Delete fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_INSTITUTIONS','en','Y','Delete institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_LOOKUPS','en','Y','Delete lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SECONDARY_SCHOOLS','en','Y','Delete organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ORG_UNITS','en','Y','Delete organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_ROLES','en','Y','Delete roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBERS','en','Y','Delete staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBER_CONTRACTS','en','Y','Delete staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STAFFMEMBER_ADDRESSES','en','Y','Delete staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENTS','en','Y','Delete students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_SUBSCRIPTION_DATA','en','Y','Delete student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_ABSENCES','en','Y','Delete student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDENT_ADDRESSES','en','Y','Delete student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDIES','en','Y','Delete studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDY_ADDRESSES','en','Y','Delete study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDYGRADETYPES','en','Y','Delete study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_STUDY_PLANS','en','Y','Delete study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTS','en','Y','Delete subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_PREREQUISITES','en','Y','Remove subject prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_STUDYGRADETYPES','en','Y','Remove subjects from study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_SUBJECTBLOCKS','en','Y','Remove subjects from subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECT_TEACHERS','en','Y','Delete subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCKS','en','Y','Delete subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCK_PREREQUISITES','en','Y','Remove subject block prerequisites');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_SUBJECTBLOCK_STUDYGRADETYPES','en','Y','Remove subject blocks from study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_TESTS','en','Y','Delete tests');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_TEST_SUPERVISORS','en','Y','Delete test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('DELETE_USER_ROLES','en','Y','Remove roles form users');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('FINALIZE_ADMISSION_FLOW','en','Y','Make final progression step in the admission flow');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('FINALIZE_CONTINUED_REGISTRATION_FLOW','en','Y','Make final progression step in the continued registration flow');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('PROGRESS_ADMISSION_FLOW','en','Y','Make progression steps in the admission flow');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('PROGRESS_CONTINUED_REGISTRATION_FLOW','en','Y','Make progression steps in the continued registration flow');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ACADEMIC_YEARS','en','Y','View academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_BRANCHES','en','Y','View branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_EXAMINATIONS','en','Y','View examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_EXAMINATION_SUPERVISORS','en','Y','View examination supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_FEES','en','Y','View fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_INSTITUTIONS','en','Y','View institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_LOOKUPS','en','Y','View lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_OPUSUSER','en','Y','View Opususer data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ORG_UNITS','en','Y','View organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_OWN_STUDYPLAN_RESULTS','en','Y','View own study plan results for subjects teacher teaches or student');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_PRIMARY_AND_CHILD_ORG_UNITS','en','Y','View primary organizational unit and its children');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_ROLES','en','Y','View roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SECONDARY_SCHOOLS','en','Y','View organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBERS','en','Y','View Staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBER_CONTRACTS','en','Y','Read staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STAFFMEMBER_ADDRESSES','en','Y','Read staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENTS','en','Y','View all students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENTS_SAME_STUDYGRADETYPE','en','Y','View only students in the study grade type');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_SUBSCRIPTION_DATA','en','Y','View student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_ABSENCES','en','Y','View student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_ADDRESSES','en','Y','View student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDENT_MEDICAL_DATA','en','Y','View student medical data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDIES','en','Y','View studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDY_ADDRESSES','en','Y','Read study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDYGRADETYPES','en','Y','View study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDY_PLANS','en','Y','View study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_STUDYPLAN_RESULTS','en','Y','View study plan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTBLOCKS','en','Y','View subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTS','en','Y','View subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_TEACHERS','en','Y','View subject teachers');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_STUDYGRADETYPES','en','Y','View associations subject / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECT_SUBJECTBLOCKS','en','Y','View associations subject / subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_SUBJECTBLOCK_STUDYGRADETYPES','en','Y','View associations subject block / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_TESTS','en','Y','View tests');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_TEST_SUPERVISORS','en','Y','View test supervisors');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('READ_USER_ROLES','en','Y','View what roles users are assigned to');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('RESET_PASSWORD','en','Y','Reset passwords');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('SET_CARDINALTIMEUNIT_ACTIVELY_REGISTERED','en','Y','Set the cardinal time unit status to actively registered');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TOGGLE_CUTOFFPOINT','en','Y','Set the cut-off point for applying students');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ACADEMIC_YEARS','en','Y','Update academic years');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_BRANCHES','en','Y','Update branches');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_EXAMINATIONS','en','Y','Update Examinations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FEES','en','Y','Update fees');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FOREIGN_STUDYPLAN_DETAILS','en','Y','Update studyplan with studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_FOREIGN_STUDYPLAN_RESULTS','en','Y','Update studyplan results for studyplan details from other universities');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_INSTITUTIONS','en','Y','Update institutions');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_LOOKUPS','en','Y','Update lookups');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SECONDARY_SCHOOLS','en','Y','Update organizations');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OPUSUSER','en','Y','Update Opususer data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ORG_UNITS','en','Y','Update organizational units');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OWN_STUDYPLAN_RESULTS_PENDING_APPROVAL','en','Y','Allow each teachert to update subjects and subject block results pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL','en','Y','Allow each student to update subjects and subject block subscriptions pending approval');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_PRIMARY_AND_CHILD_ORG_UNITS','en','Y','Update primary organizational unit and its children');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_PROGRESS_STATUS','en','Y','Update student progress status');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_ROLES','en','Y','Update roles');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBERS','en','Y','Update staff members');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBER_CONTRACTS','en','Y','Update staff member contracts');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STAFFMEMBER_ADDRESSES','en','Y','Update staff member addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENTS','en','Y','Update students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_SUBSCRIPTION_DATA','en','Y','View student subscription data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_ABSENCES','en','Y','Delete student absences');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_ADDRESSES','en','Y','Delete student addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDENT_MEDICAL_DATA','en','Y','Update student medical data');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDIES','en','Y','Update studies');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDY_ADDRESSES','en','Y','Create study addresses');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDY_PLANS','en','Y','Update study plans');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYPLAN_RESULTS','en','Y','Update studyplan results');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL','en','Y','Update studyplan results upon appeal');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYGRADETYPE_RFC','en','Y','Update RFCs for a study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_STUDYGRADETYPES','en','Y','Update study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTS','en','Y','Update subjects');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECT_STUDYGRADETYPES','en','Y','Update associations subject / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECT_SUBJECTBLOCKS','en','Y','Update associations subject / subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTBLOCK_STUDYGRADETYPES','en','Y','Update associations subject block / study grade types');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_SUBJECTBLOCKS','en','Y','Update subject blocks');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('UPDATE_USER_ROLES','en','Y','Update user roles');

INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_CURRICULUM','en','Y','Transfer curriculum');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_STUDENTS','en','Y','Transfer students');
INSERT INTO opuscollege.opusprivilege(code,lang,active,description) VALUES('TRANSFER_SUBJECTS','en','Y','Transfer selectted and elective subjects to next ctu');


-- ##########
-- ### 10 ###
-- ##########

truncate opuscollege.opusrole_privilege;

-- gives every privilege to admin user 
INSERT INTO opuscollege.opusrole_privilege(privilegecode,role) SELECT distinct code,'admin' FROM opuscollege.opusprivilege;

-- registry of an institution 

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','ADMINISTER_SYSTEM');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','APPROVE_SUBJECT_SUBSCRIPTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_FEES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_FOREIGN_STUDYPLAN_DETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDYPLANDETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','CREATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','DELETE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','RESET_PASSWORD');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_OPUSUSER');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','UPDATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','TRANSFER_CURRICULUM');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','TRANSFER_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('registry','TRANSFER_SUBJECTS');

-- central administrator of an institution 
-- (almost identical to registry, except creation of foreign subjects and studyplan details)
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','APPROVE_SUBJECT_SUBSCRIPTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_FEES');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_FOREIGN_STUDYPLAN_DETAILS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDYPLANDETAILS_PENDING_APPROVAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDYPLANDETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','CREATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','DELETE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','FINALIZE_ADMISSION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','PROGRESS_ADMISSION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','RESET_PASSWORD');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_EXAMINATIONS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_OPUSUSER');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','UPDATE_USER_ROLES');

--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','TOGGLE_CUTOFFPOINT');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','TRANSFER_CURRICULUM');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','TRANSFER_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-C','TRANSFER_SUBJECTS');

-- dvc (read copy of admin-C):
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dvc','UPDATE_BRANCHES');

-- internal audit of an institution 
-- initially read copy of admin-C, must develop
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_BRANCHES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_TESTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','UPDATE_BRANCHES');

-- head of 1st level unit - dean, asst. dean
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','APPROVE_SUBJECT_SUBSCRIPTIONS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_STUDYPLANDETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','CREATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','DELETE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','FINALIZE_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','PROGRESS_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_OPUSUSER');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','TOGGLE_CUTOFFPOINT');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_FOREIGN_STUDYPLAN_DETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_USER_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-S','UPDATE_SUBJECTBLOCK_STUDYGRADETYPES');

-- branch administrator
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','APPROVE_SUBJECT_SUBSCRIPTIONS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_STUDYPLANDETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','CREATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','DELETE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','FINALIZE_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','PROGRESS_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_OPUSUSER');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','TOGGLE_CUTOFFPOINT');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_FOREIGN_STUDYPLAN_DETAILS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_FOREIGN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDENT_SUBSCRIPTION_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDYGRADETYPE_RFC');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_USER_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-B','UPDATE_SUBJECTBLOCK_STUDYGRADETYPES');

-- decentral administrator of an organizational unit
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','APPROVE_SUBJECT_SUBSCRIPTIONS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDYPLANDETAILS_PENDING_APPROVAL');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','CREATE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECT_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECTBLOCK_PREREQUISITES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','DELETE_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_ACADEMIC_YEARS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_EXAMINATION_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_OPUSUSER');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECT_TEACHERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_TEST_SUPERVISORS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','READ_USER_ROLES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','PROGRESS_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_EXAMINATIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_LOOKUPS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_PRIMARY_AND_CHILD_ORG_UNITS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_PROGRESS_STATUS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_ROLES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STAFFMEMBER_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('admin-D','UPDATE_SUBJECTBLOCK_STUDYGRADETYPES');


-- teacher of an organizational unit
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_ACADEMIC_YEARS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_OWN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','READ_SUBJECTBLOCKS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('teacher','UPDATE_OWN_STUDYPLAN_RESULTS_PENDING_APPROVAL');

-- student
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_OWN_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_STUDENTS_SAME_STUDYGRADETYPE');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','READ_STUDY_ADDRESSES');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('student','UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL');

-- guest
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('guest','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('guest','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('guest','READ_STUDIES');

-- financial officer
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','FINALIZE_ADMISSION_FLOW');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','FINALIZE_CONTINUED_REGISTRATION_FLOW');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_ACADEMIC_YEARS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('finance','READ_SUBJECTBLOCKS');

-- librarian
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_ACADEMIC_YEARS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('library','READ_SUBJECTBLOCKS');

-- internal audit
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_ACADEMIC_YEARS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STAFFMEMBER_CONTRACTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('audit','READ_SUBJECTBLOCKS');

-- dean of students
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','GENERATE_STUDENT_REPORTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_ACADEMIC_YEARS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SECONDARY_SCHOOLS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDY_PLANS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDYPLAN_RESULTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDENT_ABSENCES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDENT_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDENT_MEDICAL_DATA');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('dos','READ_SUBJECTBLOCKS');

-- PR & Communication
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','GENERATE_STATISTICS');

INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_ACADEMIC_YEARS');
--INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_INSTITUTIONS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_STAFFMEMBERS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_STUDENTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_STUDIES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_STUDY_ADDRESSES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_SUBJECTS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_SUBJECT_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_SUBJECT_SUBJECTBLOCKS');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_SUBJECTBLOCK_STUDYGRADETYPES');
INSERT INTO opuscollege.opusrole_privilege(role,privilegecode) VALUES('pr','READ_SUBJECTBLOCKS');


-- ##########
-- ### 11 ###
-- ##########

-- The final DB version (includes all scripts up to college module version 3.2.0

DELETE FROM opuscollege.appVersions WHERE lower(module) = 'college';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('college','A','Y',3.26);


-- ##########
-- ### 12 ###
-- ##########


-- cardinaltimeunit
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('cardinaltimeunit', 'Lookup8', 'Y');
-- data
DELETE FROM opuscollege.cardinaltimeunit;
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('en','1','Year', 1);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('en','2','Semester', 2);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('en','3','Trimester', 3);

INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('pt','1','Ano', 1);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('pt','2','Semestre', 2);
INSERT INTO opuscollege.cardinaltimeunit (lang,code,description, nrOfUnitsPerYear) VALUES ('pt','3','Trimestre', 3);


-- dayPart
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('daypart', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.daypart;
INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('en','1','Morning');
INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('en','2','Afternoon');
INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('en','3','Evening');

INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('pt','1','Manh&atilde;');
INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('pt','2','Tarde');
INSERT INTO opuscollege.daypart (lang,code,description) VALUES ('pt','3','Noite');


-- thesisStatus
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('thesisstatus', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.thesisStatus;
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('en','1','Admission requested');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('en','2','Proposal cleared');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('en','3','Thesis accepted');

INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('pt','1','Admission requested');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('pt','2','Proposal cleared');
INSERT INTO opuscollege.thesisStatus (lang,code,description) VALUES ('pt','3','Thesis accepted');


-- studyPlanStatus
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('studyplanstatus', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.studyPlanStatus;
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','1','Start initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','2','Waiting for payment initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','3','Approved initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','4','Rejected initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','10','Temporarily inactive');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','11','Graduated');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('en','12','Withdrawn');

INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','1','Waiting for payment');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','2','Waiting for selection');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','3','Approved initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','4','Rejected initial admission');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','10','Temporarily inactive');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','11','Graduated');
INSERT INTO opuscollege.studyPlanStatus (lang,code,description) VALUES ('pt','12','Withdrawn');


-- studentStatus
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('studentstatus'   , 'Lookup'  , 'Y');
-- data
DELETE FROM opuscollege.studentStatus;
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','1','Active');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','5','Deceased');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','101','Expelled');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('en','102','Suspended');

INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','1','Activo');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','5','Falecido');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','101','Expulso');
INSERT INTO opuscollege.studentStatus (lang,code,description) VALUES ('pt','102','Suspenso');


-- progressStatus
INSERT INTO opuscollege.lookupTable(tableName , lookupType , active) VALUES ('progressstatus', 'Lookup7', 'Y');
-- data
DELETE FROM opuscollege.progressStatus;
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','01','Clear pass','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','27','Proceed & Repeat','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','29','To Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','19','At Part-time','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','31','To Full-time','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','03','Repeat','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','35','Exclude program','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','34','Exclude school','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','22','Exclude university','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','23','Withdrawn with permission','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('en','25','Graduate','N','N','Y','N');

INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','01','Passar (todas cadeiras aprovadas)','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','27','Continuar & repetir','Y','Y','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','29','Para tempo parcial','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','19','No tempo parcial','Y','N','N','S');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','31','Para tempo inteiro','Y','Y','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','03','Repetir todas cadeiras','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','35','Excluir do programa','Y','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','34','Excluir da eschola','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','22','Excluir da universidade','N','N','N','N');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','23','Ausen&ccedil;a autorizada','Y','N','N','A');
INSERT INTO opuscollege.progressStatus (lang,code,description,continuing,increment,graduating,carrying) VALUES ('pt','25','Graduar','N','N','Y','N');


-- rfcStatus
INSERT INTO opuscollege.lookupTable(tableName , lookupType , active) VALUES ('rfcstatus', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.rfcStatus;
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('en','1','New');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('en','2','Resolved');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('en','3','Refused');

INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('pt','1','Novo');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('pt','2','Resolvido');
INSERT INTO opuscollege.rfcStatus (lang,code,description) VALUES ('pt','3','Recusado');


-- cardinalTimeUnitStatus
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('cardinaltimeunitstatus', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.cardinalTimeUnitStatus;
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','5','Start continued registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','6','Waiting for approval of registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','7','Request for change');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','8','Rejected registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','9','Approved registration (waiting for payment)');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('en','10','Actively registered');

INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','5','Start continued registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','6','Waiting for approval of registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','7','Rejected registration');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','8','Approved registration (waiting for payment)');
INSERT INTO opuscollege.cardinalTimeUnitStatus (lang,code,description) VALUES ('pt','9','Actively registered');

-- endGradeType
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('endgradetype', 'Lookup', 'Y');
-- data
DELETE FROM opuscollege.endGradeType;
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','CA','Continuous assessment');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','SE','Sessional examination');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','SR','Subject result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','PC','Project course result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','AR','Attachment result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','CTU','Cardinal time unit endgrade');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','TR','Thesis result');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','BSC','Bachelor of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','BA','Bachelor of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','MSC','Master of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','MA','Master of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','PHD','Doctor');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('en','LIC','Licentiate');

INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','CA','Avalia&ccedil;&atilde;o cont&iacute;nua');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','SE','Exame');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','SR','Resultado da cadeira');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','PC','Resultado do projecto');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','AR','Resultado do est&aacute;gio');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','CTU','Nota final do semestre/ano');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','TR','Resultado da tese');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','BSC','Bachelor of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','BA','Bachelor of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','MSC','Master of science');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','MA','Master of art');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','PHD','Doctor');
INSERT INTO opuscollege.endGradeType (lang,code,description) VALUES ('pt','LIC','Licenciatura');


-- secondarySchoolSubject
INSERT INTO opuscollege.lookuptable(tableName , lookupType , active) VALUES ('secondaryschoolsubject', 'Lookup', 'N');
-- no data in Mozambique


-- endgrade
-- EN
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','26', 'LIC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','25', 'LIC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','24', 'BSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','25', 'BSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','22', 'MSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','21', 'MSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','20', '',20, 0.0, 0.0, '20','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','19', '',19, 0.0, 0.0, '19','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','18', '',18, 0.0, 0.0, '18','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','17', '',17, 0.0, 0.0, '17','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','16', '',16, 0.0, 0.0, '16','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','15', '',15, 0.0, 0.0, '15','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','14', '',14, 0.0, 0.0, '14','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','13', '',13, 0.0, 0.0, '13','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','12', '',12, 0.0, 0.0, '12','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','11', '',11, 0.0, 0.0, '11','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','10', '',10, 0.0, 0.0, '10','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','09', '',9, 0.0, 0.0, '9','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','08', '',8, 0.0, 0.0, '8','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','07', '',7, 0.0, 0.0, '7','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','06', '',6, 0.0, 0.0, '6','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','05', '',5, 0.0, 0.0, '5','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','04', '',4, 0.0, 0.0, '4','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','03', '',3, 0.0, 0.0, '3','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','02', '',2, 0.0, 0.0, '2','N','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('en','01', '',1, 0.0, 0.0, '1','N','','N');

-- PT
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','26', 'LIC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','25', 'LIC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','24', 'BSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','25', 'BSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','22', 'MSC', 0.0, 0.0, 50.0, 'Fail','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','21', 'MSC', 0.0, 50.0, 100.0, 'Satisfactory','Y','','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','20', '',20, 0.0, 0.0, '20','Y','20','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','19', '',19, 0.0, 0.0, '19','Y','19','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','18', '',18, 0.0, 0.0, '18','Y','18','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','17', '',17, 0.0, 0.0, '17','Y','17','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','16', '',16, 0.0, 0.0, '16','Y','16','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','15', '',15, 0.0, 0.0, '15','Y','15','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','14', '',14, 0.0, 0.0, '14','Y','14','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','13', '',13, 0.0, 0.0, '13','N','13','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','12', '',12, 0.0, 0.0, '12','N','12','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','11', '',11, 0.0, 0.0, '11','N','11','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','10', '',10, 0.0, 0.0, '10','N','10','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','09', '',9, 0.0, 0.0, '9','N','9','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','08', '',8, 0.0, 0.0, '8','N','8','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','07', '',7, 0.0, 0.0, '7','N','7','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','06', '',6, 0.0, 0.0, '6','N','6','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','05', '',5, 0.0, 0.0, '5','N','5','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','04', '',4, 0.0, 0.0, '4','N','4','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','03', '',3, 0.0, 0.0, '3','N','3','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','02', '',2, 0.0, 0.0, '2','N','2','N');
INSERT INTO opuscollege.endGrade (lang,code,endGradeTypeCode,gradePoint,percentageMin,percentageMax,comment,passed,description,temporaryGrade) VALUES('pt','01', '',1, 0.0, 0.0, '1','N','1','N');


-- gradetype
DELETE FROM opuscollege.gradeType;

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','SEC','Secondary school','sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','BSC','Bachelor of science','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','LIC','Licentiate','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MSC','Master of science','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','PHD','Doctor','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','BA','Bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','MA','Master of art','M.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','DAP','Diploma Ano Propedeutico','Ano-P.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('en','LICBSC','Licenciate (pre-req: bac.)','Lic-Bac.');

INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','SEC','Ensino secund&aacute;rio','Ensino sec.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','BSC','Bacharelato','B.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','LIC','Licentiatura','Lic..');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','MSC','Mestre','M.Sc.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','PHD','Ph.D.','Ph.D.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','BA','Bachelor of art','B.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','MA','master of art','M.A.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','DAP','Diploma Ano Propedeutico','Ano-P.');
INSERT INTO opuscollege.gradeType (lang,code,description,title) VALUES ('pt','LICBSC','Licenciatura (pre-req: bac.)','Lic-Bac.');

UPDATE opuscollege.studyGradeType set gradeTypeCode = 'SEC' where gradeTypeCode = '2';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'BSC' where gradeTypeCode = '3';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'LIC' where gradeTypeCode = '4';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'MSC' where gradeTypeCode = '5';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'PHD' where gradeTypeCode = '6';
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'DAP' where gradeTypeCode = '7';    -- "diploma ano propedeutico"
UPDATE opuscollege.studyGradeType set gradeTypeCode = 'LICBSC' where gradeTypeCode = '8'; -- "licenciate (pre-req: bac.)"

UPDATE opuscollege.studyPlan set gradeTypeCode = 'SEC' where gradeTypeCode = '2';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'BSC' where gradeTypeCode = '3';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'LIC' where gradeTypeCode = '4';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'MSC' where gradeTypeCode = '5';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'PHD' where gradeTypeCode = '6';
UPDATE opuscollege.studyPlan set gradeTypeCode = 'DAP' where gradeTypeCode = '7';    -- "diploma ano propedeutico"
UPDATE opuscollege.studyPlan set gradeTypeCode = 'LICBSC' where gradeTypeCode = '8'; -- "licenciate (pre-req: bac.)"

UPDATE opuscollege.person set gradeTypeCode = 'SEC' where gradeTypeCode = '2';
UPDATE opuscollege.person set gradeTypeCode = 'BSC' where gradeTypeCode = '3';
UPDATE opuscollege.person set gradeTypeCode = 'LIC' where gradeTypeCode = '4';
UPDATE opuscollege.person set gradeTypeCode = 'MSC' where gradeTypeCode = '5';
UPDATE opuscollege.person set gradeTypeCode = 'PHD' where gradeTypeCode = '6';
UPDATE opuscollege.person set gradeTypeCode = 'DAP' where gradeTypeCode = '7';    -- "diploma ano propedeutico"
UPDATE opuscollege.person set gradeTypeCode = 'LICBSC' where gradeTypeCode = '8'; -- "licenciate (pre-req: bac.)"

-------------------------------------------------------
-- table authorisation
-------------------------------------------------------
DELETE FROM opuscollege.authorisation;

INSERT INTO opuscollege.authorisation(code, description) VALUES('E', 'editable');
INSERT INTO opuscollege.authorisation(code, description) VALUES('V', 'visible');
INSERT INTO opuscollege.authorisation(code, description) VALUES('H', 'hidden');

-------------------------------------------------------
-- DOMAIN TABLE endGradeGeneral (applicable for all endgradetypes)
-------------------------------------------------------
DELETE FROM opuscollege.endGradeGeneral;

-- EN
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('en','WP','Withdrawn from course with permission','','N');
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('en','DC','Deceased during course','','N');
-- PT
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('pt','WP','Withdrawn from course with permission','','N');
INSERT INTO opuscollege.endGradeGeneral (lang,code,comment,description,temporaryGrade) VALUES ('pt','DC','Deceased during course','','N');

-------------------------------------------------------
-- DOMAIN TABLE failGrade
-------------------------------------------------------
DELETE FROM opuscollege.failGrade;
-- EN
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','U','Unsatisfactory, Fail in a Practical Course','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','NE','No Examination Taken','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','WD','Withdrawn from the course with penalty for unsatisfactory academic progress','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','LT','Left the course during the semester without permission','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','DQ','Disqualified in a course by Senate Examination','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','DR','Deregistered for failure to pay fees','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','RS','Re-sit course examination only','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','IN','Incomplete','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','DF','Deferred Examination','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('en','SP','Supplementary Examination','','Y');
-- PT
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','U','Unsatisfactory, Fail in a Practical Course','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','NE','No Examination Taken','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','WD','Withdrawn from the course with penalty for unsatisfactory academic progress','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','LT','Left the course during the semester without permission','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','DQ','Disqualified in a course by Senate Examination','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','DR','Deregistered for failure to pay fees','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','RS','Re-sit course examination only','','N');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','IN','Incomplete','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','DF','Deferred Examination','','Y');
INSERT INTO opuscollege.failGrade (lang,code,comment,description,temporaryGrade) VALUES ('pt','SP','Supplementary Examination','','Y');


-- 30_C01002_opuscollege_mozambique_update_lookups.sql
--
-- Introduce a "MZ-" prefix to all province, district and
-- administrative post lookups and the corresponding
-- references in other tables (person, address, etc.)
--
-- This script can be run more than once without wreaking havoc.
-- This script can be run at any time - no dependencies on other scripts.
--

-- 1. Update provinces

-- update person.provinceofbirthcode
update opuscollege.person
set provinceofbirthcode='MZ-' || provinceofbirthcode
from opuscollege.province
where provinceofbirthcode = province.code
and SUBSTR (provinceofbirthcode, 1, 3) <> 'MZ-'
and countrycode = '508';

-- update person.provinceoforigincode
update opuscollege.person
set provinceoforigincode='MZ-' || provinceoforigincode
from opuscollege.province
where provinceoforigincode = province.code
and SUBSTR (provinceoforigincode, 1, 3) <> 'MZ-'
and countrycode = '508';

-- update address.provincecode
update opuscollege.address
set provincecode='MZ-' || provincecode
from opuscollege.province
where provincecode = province.code
and SUBSTR (provincecode, 1, 3) <> 'MZ-'
and province.countrycode = '508';

-- update district.provincecode
update opuscollege.district
set provincecode='MZ-' || provincecode
from opuscollege.province
where provincecode = province.code
and SUBSTR (provincecode, 1, 3) <> 'MZ-'
and province.countrycode = '508';

-- update institution.provincecode
update opuscollege.institution
set provincecode='MZ-' || provincecode
from opuscollege.province
where provincecode = province.code
and SUBSTR (provincecode, 1, 3) <> 'MZ-'
and province.countrycode = '508';

-- update the province.code
update opuscollege.province
set code='MZ-' || code
where SUBSTR (code, 1, 3) <> 'MZ-'
and province.countrycode = '508';


-- 2. Update districts

-- update person.districtofbirthcode
update opuscollege.person
set districtofbirthcode='MZ-' || districtofbirthcode
from opuscollege.district,
opuscollege.province
where districtofbirthcode = district.code
and SUBSTR (districtofbirthcode, 1, 3) <> 'MZ-'
and district.provincecode = province.code and province.lang = 'pt'
and province.countrycode = '508';

-- update person.districtoforigincode
update opuscollege.person
set districtoforigincode='MZ-' || districtoforigincode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code and province.countrycode = '508'
where districtoforigincode = district.code
)
and SUBSTR (districtoforigincode, 1, 3) <> 'MZ-';

-- update address.districtcode
update opuscollege.address
set districtcode='MZ-' || districtcode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code and province.countrycode = '508'
where districtcode = district.code
)
and SUBSTR (districtcode, 1, 3) <> 'MZ-';

-- update administrativepost.districtcode
update opuscollege.administrativepost
set districtcode='MZ-' || districtcode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code and province.countrycode = '508'
where districtcode = district.code
)
and SUBSTR (districtcode, 1, 3) <> 'MZ-';

-- update district.code
update opuscollege.district
set code='MZ-' || code
where SUBSTR (code, 1, 3) <> 'MZ-'
and exists (
select * from opuscollege.province
where district.provincecode = province.code and province.countrycode = '508'
);

-- 3. Update administrative posts

-- update address.administrativepostcode
update opuscollege.address
set administrativepostcode='MZ-' || administrativepostcode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code 
inner join opuscollege.administrativepost on administrativepost.districtcode = district.code
where administrativepostcode = administrativepost.code
and province.countrycode = '508'
)
and SUBSTR (administrativepostcode, 1, 3) <> 'MZ-';

-- update person.administrativepostoforigincode
update opuscollege.person
set administrativepostoforigincode='MZ-' || administrativepostoforigincode
where exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code 
inner join opuscollege.administrativepost on administrativepost.districtcode = district.code
where administrativepostoforigincode = administrativepost.code
and province.countrycode = '508'
)
and SUBSTR (administrativepostoforigincode, 1, 3) <> 'MZ-';

-- update administrativepost.code
update opuscollege.administrativepost
set code='MZ-' || code
where SUBSTR (code, 1, 3) <> 'MZ-'
and exists (
select * from opuscollege.province
inner join opuscollege.district on district.provincecode = province.code 
where district.provincecode = province.code and province.countrycode = '508'
);


-------------------------------------------------------
-- table appVersions
-------------------------------------------------------
DELETE FROM opuscollege.appVersions WHERE lower(module) = 'mozambique';

INSERT INTO opuscollege.appVersions (module,state,db,dbVersion) VALUES('mozambique','A','Y',3.12);


-------------------------------------------------------
-- table district: updated City of Maputo districts
-------------------------------------------------------
DELETE FROM opuscollege.district where code like 'MZ-11-%';

INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-01','Municipal KaMfumo (DU 1)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-02','Municipal de Nhlamankulo (DU 2)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-03','Municipal KaMaxakeni (DU 3)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-04','Municipal Ka Mavota (DU 4)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-05','Municipal KaMubukwana (DU 5)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-06','Municipal KaTembe','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('pt','MZ-11-07','Municipal de Inhaca','MZ-11');

INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-01','Municipal KaMfumo (DU 1)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-02','Municipal de Nhlamankulo (DU 2)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-03','Municipal KaMaxakeni (DU 3)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-04','Municipal Ka Mavota (DU 4)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-05','Municipal KaMubukwana (DU 5)','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-06','Municipal KaTembe','MZ-11');
INSERT INTO opuscollege.district (lang,code,description,provinceCode) VALUES('en','MZ-11-07','Municipal de Inhaca','MZ-11');


DELETE FROM opuscollege.role;

-- EN
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin', 'Functional administrator and registry', 1);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-C', 'Academic affairs office', 2);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-B', 'Branch', 3);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-D', 'Head of 2nd level unit', 4);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','teacher', 'Lecturer', 5);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','student', 'Student', 6);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','guest', 'System guest', 7);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','finance', 'Financial officer', 8);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','dvc', 'Deputy vice chancellor', 9);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','library', 'Librarian', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','audit', 'Internal audit', 11);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','dos', 'Dean of Students', 12);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','pr', 'PR / communication', 13);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','registry', 'registry office', 14);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','admin-S', 'Head of 1st level unit - dean etc.', 15);

-- not (yet) implemented
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','staff', 'staff member', 16);
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('en','alumnus', 'alumnus', 17);

-- PT
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin', 'Functional administrator and registry', 1);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-C', 'Academic affairs office', 2);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-B', 'Branch', 3);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-D', 'Head of 2nd level unit', 4);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','teacher', 'Lecturer', 5);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','student', 'Student', 6);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','guest', 'System guest', 7);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','finance', 'Financial officer', 8);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','dvc', 'Deputy vice chancellor', 9);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','library', 'Librarian', 10);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','audit', 'Internal audit', 11);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','dos', 'Dean of Students', 12);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','pr', 'PR / communication', 13);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','registry', 'Registry office', 14);
INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','admin-S', 'Head of 1st level unit - dean etc.', 15);

-- not (yet) implemented
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','staff', 'staff member', 16);
--INSERT INTO opuscollege.role (lang,role,roleDescription,level) VALUES('pt','alumnus', 'alumnus', 17);

-- switch current roles 'staff' to 'teacher'
UPDATE opuscollege.opususerrole set role = 'teacher' where role = 'staff';


-- ##########
-- ### 13 ###
-- ##########

-- study time is mandatory, so set a default value (1 = daytime)
update opuscollege.subject set studyTimeCode = '1' where studyTimeCode = '0' or studyTimeCode = '';

-- study time is mandatory, so set a default value (1 = daytime)
update opuscollege.subjectblock set studyTimeCode = '1' where studyTimeCode = '0' or studyTimeCode = '';

-- all lookup table entries: lowercase
update opuscollege.lookuptable set tablename = lower(tablename);
