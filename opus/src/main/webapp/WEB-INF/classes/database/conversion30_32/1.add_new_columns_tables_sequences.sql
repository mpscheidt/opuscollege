
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

