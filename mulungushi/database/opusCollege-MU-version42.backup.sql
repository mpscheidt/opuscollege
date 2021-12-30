--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.4
-- Dumped by pg_dump version 9.2.4
-- Started on 2014-03-28 13:44:26

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 6 (class 2615 OID 125639)
-- Name: audit; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA audit;


ALTER SCHEMA audit OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 125640)
-- Name: opuscollege; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA opuscollege;


ALTER SCHEMA opuscollege OWNER TO postgres;

--
-- TOC entry 524 (class 3079 OID 11727)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 524
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = opuscollege, pg_catalog;

--
-- TOC entry 170 (class 1259 OID 125641)
-- Name: organizationalunitseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE organizationalunitseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.organizationalunitseq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 171 (class 1259 OID 125643)
-- Name: organizationalunit; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE organizationalunit (
    id integer DEFAULT nextval('organizationalunitseq'::regclass) NOT NULL,
    organizationalunitcode character varying NOT NULL,
    organizationalunitdescription character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    branchid integer NOT NULL,
    unitlevel integer DEFAULT 0 NOT NULL,
    parentorganizationalunitid integer DEFAULT 0 NOT NULL,
    unitareacode character varying NOT NULL,
    unittypecode character varying NOT NULL,
    academicfieldcode character varying NOT NULL,
    directorid integer NOT NULL,
    registrationdate date DEFAULT now() NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.organizationalunit OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 125656)
-- Name: node_relationships_n_level; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE node_relationships_n_level (
    level integer
)
INHERITS (organizationalunit);


ALTER TABLE opuscollege.node_relationships_n_level OWNER TO postgres;

--
-- TOC entry 537 (class 1255 OID 125669)
-- Name: crawl_tree(integer, integer); Type: FUNCTION; Schema: opuscollege; Owner: postgres
--

CREATE FUNCTION crawl_tree(integer, integer) RETURNS SETOF node_relationships_n_level
    LANGUAGE plpgsql
    AS $_$DECLARE
temp RECORD;
child RECORD;
BEGIN
  SELECT INTO temp *, $2 AS level FROM opuscollege.organizationalunit WHERE
id = $1;

  IF FOUND THEN
    RETURN NEXT temp;
      FOR child IN SELECT id FROM opuscollege.organizationalunit WHERE
parentorganizationalunitid = $1 ORDER BY unitlevel LOOP
        FOR temp IN SELECT * FROM opuscollege.crawl_tree(child.id, $2 +
1) LOOP
            RETURN NEXT temp;
        END LOOP;
      END LOOP;
   END IF;
END;
$_$;


ALTER FUNCTION opuscollege.crawl_tree(integer, integer) OWNER TO postgres;

--
-- TOC entry 538 (class 1255 OID 125670)
-- Name: remove_diacritics(character varying); Type: FUNCTION; Schema: opuscollege; Owner: postgres
--

CREATE FUNCTION remove_diacritics(character varying) RETURNS character varying
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT translate(
    $1,
    'Ã¡Ã Ã¢Ã£Ã¤Ã¥Ã¦Ã�Ã€Ã‚ÃƒÃ„Ã…Ã†Ã§Ã‡Ã¨Ã©ÃªÃ«Ã‰ÃˆÃ¬Ã­Ã®Ã¯ÃŒÃ�ÃŽÃ�Ã±Ã‘Ã³Ã´ÃµÃ¶Ã¸Ã’Ã“Ã”Ã•Ã–Ã˜Ã¹ÃºÃ»Ã¼Å©Ã™ÃšÃ›ÃœÅ¨Ã½Ã�',
    'aaaaaaaAAAAAAAcCeeeeEEiiiiIIIInNoooooOOOOOOuuuuuUUUUUyY'
);
$_$;


ALTER FUNCTION opuscollege.remove_diacritics(character varying) OWNER TO postgres;

--
-- TOC entry 539 (class 1255 OID 125671)
-- Name: rename_col_academicyearcode_to_academicyearid(); Type: FUNCTION; Schema: opuscollege; Owner: postgres
--

CREATE FUNCTION rename_col_academicyearcode_to_academicyearid() RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION opuscollege.rename_col_academicyearcode_to_academicyearid() OWNER TO postgres;

--
-- TOC entry 540 (class 1255 OID 125672)
-- Name: rename_col_obsolete_to_active(); Type: FUNCTION; Schema: opuscollege; Owner: postgres
--

CREATE FUNCTION rename_col_obsolete_to_active() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    mviews RECORD;
BEGIN
    --PERFORM cs_log('Refreshing materialized views...');

    FOR mviews IN select table_name from information_schema.columns where column_name = 'obsolete' and table_name != 'node_relationships_n_level' LOOP

        -- Now "mviews" has one record from cs_materialized_views

       -- PERFORM cs_log('Refreshing materialized view ' || quote_ident(mviews.table_name) || ' ...');
        EXECUTE 'ALTER TABLE opuscollege.' || mviews.table_name || ' RENAME COLUMN obsolete TO active';
	EXECUTE 'ALTER TABLE opuscollege.' || mviews.table_name || ' ALTER COLUMN active SET DEFAULT ''Y''';
	EXECUTE 'update opuscollege.' || mviews.table_name || ' set active = ''J'' where active = ''N''';
	EXECUTE 'update opuscollege.' || mviews.table_name || ' set active = ''N'' where active = ''Y''';
	EXECUTE 'update opuscollege.' || mviews.table_name || ' set active = ''Y'' where active = ''J''';

    END LOOP;

  --  PERFORM cs_log('Done refreshing materialized views.');
    RETURN 1;
END;
$$;


ALTER FUNCTION opuscollege.rename_col_obsolete_to_active() OWNER TO postgres;

--
-- TOC entry 541 (class 1255 OID 125673)
-- Name: sha1(bytea); Type: FUNCTION; Schema: opuscollege; Owner: postgres
--

CREATE FUNCTION sha1(bytea) RETURNS character
    LANGUAGE plpgsql
    AS $_$
BEGIN
RETURN ENCODE(DIGEST($1, 'sha1'), 'hex');
END;
$_$;


ALTER FUNCTION opuscollege.sha1(bytea) OWNER TO postgres;

SET search_path = audit, pg_catalog;

--
-- TOC entry 173 (class 1259 OID 125674)
-- Name: acc_accommodationfee_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_accommodationfee_hist (
    operation character(1) NOT NULL,
    accommodationfeeid integer,
    hosteltypecode character varying,
    roomtypecode character varying,
    feeid integer,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT acc_accommodationfee_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.acc_accommodationfee_hist OWNER TO postgres;

--
-- TOC entry 174 (class 1259 OID 125682)
-- Name: acc_block_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_block_hist (
    operation character(1) NOT NULL,
    id integer,
    code character varying(30),
    description character varying(255),
    hostelid integer,
    numberoffloors integer,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    active character(1),
    CONSTRAINT acc_block_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.acc_block_hist OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 125690)
-- Name: acc_hostel_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_hostel_hist (
    operation character(1) NOT NULL,
    id integer,
    code character varying,
    description character varying,
    numberoffloors integer,
    hosteltypecode character varying,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    active character(1),
    CONSTRAINT acc_hostel_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.acc_hostel_hist OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 125698)
-- Name: acc_room_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_room_hist (
    operation character(1) NOT NULL,
    id integer,
    code character varying,
    description character varying,
    numberofbedspaces integer,
    hostelid integer,
    blockid integer,
    floornumber integer,
    writewho character varying,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    active character(1),
    availablebedspace integer,
    roomtypecode character varying,
    CONSTRAINT acc_room_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.acc_room_hist OWNER TO postgres;

--
-- TOC entry 177 (class 1259 OID 125706)
-- Name: acc_studentaccommodation_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_studentaccommodation_hist (
    operation character(1) NOT NULL,
    id integer,
    studentid integer,
    bednumber integer,
    academicyearid integer,
    dateapplied date,
    dateapproved date,
    approved character(1),
    approvedbyid integer,
    accepted character(1),
    dateaccepted date,
    reasonforapplyingforaccommodation character varying,
    comment character varying,
    roomid integer,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    allocated character(1),
    datedeallocated date,
    CONSTRAINT acc_studentaccommodation_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.acc_studentaccommodation_hist OWNER TO postgres;

--
-- TOC entry 178 (class 1259 OID 125714)
-- Name: cardinaltimeunitresult_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE cardinaltimeunitresult_hist (
    operation character(1) NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    studyplanid integer DEFAULT 0 NOT NULL,
    studyplancardinaltimeunitid integer DEFAULT 0 NOT NULL,
    cardinaltimeunitresultdate date,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    passed character(1) DEFAULT 'N'::bpchar NOT NULL,
    mark character varying,
    endgradecomment character varying,
    CONSTRAINT cardinaltimeunitresult_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.cardinaltimeunitresult_hist OWNER TO postgres;

--
-- TOC entry 179 (class 1259 OID 125726)
-- Name: endgrade_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE endgrade_hist (
    operation character(1) NOT NULL,
    id integer,
    code character varying,
    lang character(6),
    active character(1),
    endgradetypecode character varying,
    gradepoint numeric(5,2),
    percentagemin numeric(5,2),
    percentagemax numeric(5,2),
    comment character varying,
    description character varying,
    temporarygrade character(1),
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    passed character(1),
    academicyearid integer,
    CONSTRAINT endgrade_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.endgrade_hist OWNER TO postgres;

--
-- TOC entry 180 (class 1259 OID 125734)
-- Name: examinationresult_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE examinationresult_hist (
    operation character(1) NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    examinationid integer NOT NULL,
    subjectid integer NOT NULL,
    studyplandetailid integer NOT NULL,
    examinationresultdate date,
    attemptnr integer NOT NULL,
    mark character varying,
    staffmemberid integer NOT NULL,
    active character(1) NOT NULL,
    passed character(1) NOT NULL,
    subjectresultid integer DEFAULT 0 NOT NULL,
    CONSTRAINT examinationresult_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.examinationresult_hist OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 125743)
-- Name: fee_fee_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE fee_fee_hist (
    operation character(1) NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    feedue numeric(10,2) DEFAULT 0.00 NOT NULL,
    deadline date DEFAULT now() NOT NULL,
    categorycode character varying(4),
    subjectblockstudygradetypeid integer DEFAULT 0 NOT NULL,
    subjectstudygradetypeid integer DEFAULT 0 NOT NULL,
    studygradetypeid integer DEFAULT 0 NOT NULL,
    academicyearid integer DEFAULT 0 NOT NULL,
    numberofinstallments integer DEFAULT 0 NOT NULL,
    tuitionwaiverdiscountpercentage integer DEFAULT 0 NOT NULL,
    fulltimestudentdiscountpercentage integer DEFAULT 0 NOT NULL,
    localstudentdiscountpercentage integer DEFAULT 0 NOT NULL,
    continuedregistrationdiscountpercentage integer DEFAULT 0 NOT NULL,
    postgraduatediscountpercentage integer DEFAULT 0 NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    accommodationfeeid integer DEFAULT 0 NOT NULL,
    branchid integer DEFAULT 0 NOT NULL,
    CONSTRAINT fee_fee_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.fee_fee_hist OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 125766)
-- Name: fee_payment_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE fee_payment_hist (
    operation character(1) NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    paydate date DEFAULT now() NOT NULL,
    studentid integer NOT NULL,
    feeid integer DEFAULT 0 NOT NULL,
    studentbalanceid integer DEFAULT 0 NOT NULL,
    installmentnumber integer DEFAULT 0 NOT NULL,
    sumpaid numeric(10,2) DEFAULT 0.00 NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    CONSTRAINT fee_payment_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.fee_payment_hist OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 125780)
-- Name: financialrequest_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE financialrequest_hist (
    operation character(1) NOT NULL,
    writewho character varying NOT NULL,
    id integer NOT NULL,
    requestid character varying,
    requesttypeid integer DEFAULT 0,
    financialrequestid character varying,
    statuscode integer NOT NULL,
    timestampreceived timestamp without time zone,
    requestversion character varying,
    requeststring character varying,
    timestampmodified timestamp without time zone,
    errorcode integer NOT NULL,
    processedtofinancetransaction character(1) DEFAULT 'N'::bpchar NOT NULL,
    errorreportedtofinancialsystem character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT financialrequest_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.financialrequest_hist OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 125791)
-- Name: financialtransaction_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE financialtransaction_hist (
    operation character(1) NOT NULL,
    writewho character varying NOT NULL,
    id integer NOT NULL,
    transactiontypeid integer NOT NULL,
    financialrequestid character varying NOT NULL,
    requestid character varying NOT NULL,
    statuscode integer NOT NULL,
    errorcode integer NOT NULL,
    nationalregistrationnumber character varying NOT NULL,
    academicyearid integer,
    timestampprocessed timestamp without time zone,
    amount numeric(10,2) NOT NULL,
    name character varying NOT NULL,
    cell character varying,
    requeststring character varying NOT NULL,
    processedtostudentbalance character(1) DEFAULT 'N'::bpchar NOT NULL,
    errorreportedtofinancialbankrequest character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    studentcode character varying,
    CONSTRAINT financialtransaction_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.financialtransaction_hist OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 125801)
-- Name: gradedsecondaryschoolsubject_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE gradedsecondaryschoolsubject_hist (
    operation character(1) NOT NULL,
    id integer NOT NULL,
    secondaryschoolsubjectid integer NOT NULL,
    studyplanid integer NOT NULL,
    grade character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    secondaryschoolsubjectgroupid integer DEFAULT 0 NOT NULL,
    level character(1)
);


ALTER TABLE audit.gradedsecondaryschoolsubject_hist OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 125810)
-- Name: opususerprivilege_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE opususerprivilege_hist (
    operation character(1) NOT NULL,
    id integer,
    userid integer,
    privilegecode character varying,
    organizationalunitid integer,
    validfrom date,
    validthrough date,
    active character(1),
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT opususerprivilege_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.opususerprivilege_hist OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 125818)
-- Name: staffmember_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE staffmember_hist (
    operation character(1) NOT NULL,
    staffmemberid integer NOT NULL,
    staffmembercode character varying NOT NULL,
    personid integer NOT NULL,
    dateofappointment date DEFAULT now(),
    appointmenttypecode character varying,
    stafftypecode character varying,
    primaryunitofappointmentid integer DEFAULT 0 NOT NULL,
    educationtypecode character varying,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    startworkday time(5) without time zone,
    endworkday time(5) without time zone,
    teachingdaypartcode character varying,
    supervisingdaypartcode character varying,
    id integer NOT NULL,
    personcode character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    surnamefull character varying NOT NULL,
    surnamealias character varying,
    firstnamesfull character varying NOT NULL,
    firstnamesalias character varying,
    nationalregistrationnumber character varying,
    civiltitlecode character varying,
    gradetypecode character varying,
    gendercode character varying DEFAULT '3'::character varying,
    birthdate date DEFAULT now() NOT NULL,
    nationalitycode character varying,
    placeofbirth character varying,
    districtofbirthcode character varying,
    provinceofbirthcode character varying,
    countryofbirthcode character varying,
    cityoforigin character varying,
    administrativepostoforigincode character varying,
    districtoforigincode character varying,
    provinceoforigincode character varying,
    countryoforigincode character varying,
    civilstatuscode character varying,
    housingoncampus character(1),
    identificationtypecode character varying,
    identificationnumber character varying,
    identificationplaceofissue character varying,
    identificationdateofissue date,
    identificationdateofexpiration date,
    professioncode character varying,
    professiondescription character varying,
    languagefirstcode character varying,
    languagefirstmasteringlevelcode character varying,
    languagesecondcode character varying,
    languagesecondmasteringlevelcode character varying,
    languagethirdcode character varying,
    languagethirdmasteringlevelcode character varying,
    contactpersonemergenciesname character varying,
    contactpersonemergenciestelephonenumber character varying,
    bloodtypecode character varying,
    healthissues character varying,
    photograph bytea,
    remarks character varying,
    registrationdate date DEFAULT now() NOT NULL,
    photographname character varying,
    photographmimetype character varying,
    publichomepage character(1) DEFAULT 'N'::bpchar NOT NULL,
    socialnetworks character varying,
    hobbies character varying,
    motivation character varying
);


ALTER TABLE audit.staffmember_hist OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 125832)
-- Name: student_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE student_hist (
    operation character(1) NOT NULL,
    studentid integer NOT NULL,
    studentcode character varying,
    personid integer NOT NULL,
    dateofenrolment date DEFAULT now(),
    primarystudyid integer DEFAULT 0 NOT NULL,
    expellationdate date,
    reasonforexpellation character varying,
    previousinstitutionid integer NOT NULL,
    previousinstitutionname character varying,
    previousinstitutiondistrictcode character varying,
    previousinstitutionprovincecode character varying,
    previousinstitutioncountrycode character varying,
    previousinstitutioneducationtypecode character varying,
    previousinstitutionfinalgradetypecode character varying,
    previousinstitutionfinalmark character varying,
    previousinstitutiondiplomaphotograph bytea,
    scholarship character(1) DEFAULT 'N'::bpchar NOT NULL,
    fatherfullname character varying,
    fathereducationcode character varying DEFAULT '0'::character varying,
    fatherprofessioncode character varying DEFAULT '0'::character varying,
    fatherprofessiondescription character varying,
    motherfullname character varying,
    mothereducationcode character varying DEFAULT '0'::character varying,
    motherprofessioncode character varying DEFAULT '0'::character varying,
    motherprofessiondescription character varying,
    financialguardianfullname character varying,
    financialguardianrelation character varying,
    financialguardianprofession character varying,
    writewho character varying,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    expellationenddate date,
    expellationtypecode character varying,
    previousinstitutiondiplomaphotographremarks character varying,
    previousinstitutiondiplomaphotographname character varying,
    previousinstitutiondiplomaphotographmimetype character varying,
    subscriptionrequirementsfulfilled character(1) DEFAULT 'Y'::bpchar NOT NULL,
    secondarystudyid integer DEFAULT 0 NOT NULL,
    foreignstudent character(1) DEFAULT 'N'::bpchar NOT NULL,
    nationalitygroupcode character varying,
    fathertelephone character varying,
    mothertelephone character varying,
    relativeofstaffmember character(1) DEFAULT 'N'::bpchar NOT NULL,
    ruralareaorigin character(1) DEFAULT 'N'::bpchar NOT NULL,
    id integer NOT NULL,
    personcode character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    surnamefull character varying NOT NULL,
    surnamealias character varying,
    firstnamesfull character varying NOT NULL,
    firstnamesalias character varying,
    nationalregistrationnumber character varying,
    civiltitlecode character varying,
    gradetypecode character varying,
    gendercode character varying DEFAULT '3'::character varying,
    birthdate date DEFAULT now() NOT NULL,
    nationalitycode character varying,
    placeofbirth character varying,
    districtofbirthcode character varying,
    provinceofbirthcode character varying,
    countryofbirthcode character varying,
    cityoforigin character varying,
    administrativepostoforigincode character varying,
    districtoforigincode character varying,
    provinceoforigincode character varying,
    countryoforigincode character varying,
    civilstatuscode character varying,
    housingoncampus character(1),
    identificationtypecode character varying,
    identificationnumber character varying,
    identificationplaceofissue character varying,
    identificationdateofissue date,
    identificationdateofexpiration date,
    professioncode character varying,
    professiondescription character varying,
    languagefirstcode character varying,
    languagefirstmasteringlevelcode character varying,
    languagesecondcode character varying,
    languagesecondmasteringlevelcode character varying,
    languagethirdcode character varying,
    languagethirdmasteringlevelcode character varying,
    contactpersonemergenciesname character varying,
    contactpersonemergenciestelephonenumber character varying,
    bloodtypecode character varying,
    healthissues character varying,
    photograph bytea,
    remarks character varying,
    registrationdate date DEFAULT now() NOT NULL,
    photographname character varying,
    photographmimetype character varying,
    publichomepage character(1) DEFAULT 'N'::bpchar NOT NULL,
    socialnetworks character varying,
    hobbies character varying,
    motivation character varying,
    employeenumberofrelative character varying
);


ALTER TABLE audit.student_hist OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 125856)
-- Name: studentabsence_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE studentabsence_hist (
    operation character(1) NOT NULL,
    id integer NOT NULL,
    studentid integer NOT NULL,
    startdatetemporaryinactivity date,
    enddatetemporaryinactivity date,
    reasonforabsence character varying,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE audit.studentabsence_hist OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 125863)
-- Name: studentbalance_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE studentbalance_hist (
    operation character(1) NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    studentid integer DEFAULT 0 NOT NULL,
    feeid integer DEFAULT 0 NOT NULL,
    studyplancardinaltimeunitid integer DEFAULT 0 NOT NULL,
    studyplandetailid integer DEFAULT 0 NOT NULL,
    academicyearid integer DEFAULT 0 NOT NULL,
    exemption character(1) DEFAULT 'N'::bpchar NOT NULL,
    studentaccommodationid integer DEFAULT 0 NOT NULL,
    CONSTRAINT studentbalance_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.studentbalance_hist OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 125878)
-- Name: studentexpulsion_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE studentexpulsion_hist (
    operation character(1) NOT NULL,
    id integer NOT NULL,
    studentid integer NOT NULL,
    startdate date,
    enddate date,
    expulsiontypecode character varying,
    reasonforexpulsion character varying,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE audit.studentexpulsion_hist OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 125885)
-- Name: studyplanresult_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE studyplanresult_hist (
    operation character(1) NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    studyplanid integer NOT NULL,
    examdate date,
    finalmark character(1) NOT NULL,
    mark character varying,
    active character(1) NOT NULL,
    passed character(1) NOT NULL,
    CONSTRAINT studyplanresult_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.studyplanresult_hist OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 125893)
-- Name: subjectresult_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectresult_hist (
    operation character(1) NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    subjectid integer NOT NULL,
    studyplandetailid integer NOT NULL,
    subjectresultdate date,
    mark character varying,
    staffmemberid integer NOT NULL,
    active character(1) NOT NULL,
    passed character(1) NOT NULL,
    endgradecomment character varying,
    CONSTRAINT subjectresult_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.subjectresult_hist OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 125901)
-- Name: testresult_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE testresult_hist (
    operation character(1) NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    testid integer NOT NULL,
    examinationid integer NOT NULL,
    studyplandetailid integer NOT NULL,
    testresultdate date,
    attemptnr integer NOT NULL,
    mark character varying,
    passed character(1) NOT NULL,
    staffmemberid integer NOT NULL,
    active character(1) NOT NULL,
    examinationresultid integer DEFAULT 0 NOT NULL,
    CONSTRAINT testresult_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.testresult_hist OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 125910)
-- Name: thesisresult_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE thesisresult_hist (
    operation character(1) NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    studyplanid integer NOT NULL,
    thesisid integer NOT NULL,
    thesisresultdate date,
    mark character varying,
    active character(1) NOT NULL,
    passed character(1) NOT NULL,
    CONSTRAINT thesisresult_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.thesisresult_hist OWNER TO postgres;

SET search_path = opuscollege, pg_catalog;

--
-- TOC entry 196 (class 1259 OID 125918)
-- Name: academicfieldseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE academicfieldseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.academicfieldseq OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 125920)
-- Name: academicfield; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE academicfield (
    id integer DEFAULT nextval('academicfieldseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.academicfield OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 125930)
-- Name: academicyearseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE academicyearseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.academicyearseq OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 125932)
-- Name: academicyear; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE academicyear (
    id integer DEFAULT nextval('academicyearseq'::regclass) NOT NULL,
    description character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    startdate date,
    enddate date,
    nextacademicyearid integer DEFAULT 0 NOT NULL
);


ALTER TABLE opuscollege.academicyear OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 125943)
-- Name: acc_accommodationfeeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_accommodationfeeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_accommodationfeeseq OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 125945)
-- Name: acc_accommodationfee; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_accommodationfee (
    accommodationfeeid integer DEFAULT nextval('acc_accommodationfeeseq'::regclass) NOT NULL,
    hosteltypecode character varying NOT NULL,
    roomtypecode character varying NOT NULL,
    feeid integer NOT NULL
);


ALTER TABLE opuscollege.acc_accommodationfee OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 125952)
-- Name: acc_accommodationfeepaymentseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_accommodationfeepaymentseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_accommodationfeepaymentseq OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 125954)
-- Name: acc_accommodationresourceseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_accommodationresourceseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_accommodationresourceseq OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 125956)
-- Name: acc_accommodationresource; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_accommodationresource (
    id integer DEFAULT nextval('acc_accommodationresourceseq'::regclass) NOT NULL,
    name character varying NOT NULL,
    description character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege-accommodation'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.acc_accommodationresource OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 125966)
-- Name: acc_accommodationselectioncriteriaseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_accommodationselectioncriteriaseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_accommodationselectioncriteriaseq OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 125968)
-- Name: acc_blockseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_blockseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_blockseq OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 125970)
-- Name: acc_block; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_block (
    id integer DEFAULT nextval('acc_blockseq'::regclass) NOT NULL,
    code character varying(30) NOT NULL,
    description character varying(255) NOT NULL,
    hostelid integer NOT NULL,
    numberoffloors integer NOT NULL,
    writewho character varying DEFAULT 'opuscollege-accommodation'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL
);


ALTER TABLE opuscollege.acc_block OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 125980)
-- Name: acc_hostelseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_hostelseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_hostelseq OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 125982)
-- Name: acc_hostel; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_hostel (
    id integer DEFAULT nextval('acc_hostelseq'::regclass) NOT NULL,
    code character varying DEFAULT 0.00 NOT NULL,
    description character varying NOT NULL,
    numberoffloors integer DEFAULT 1 NOT NULL,
    hosteltypecode character varying DEFAULT 0 NOT NULL,
    writewho character varying DEFAULT 'opuscollege-accommodation'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL
);


ALTER TABLE opuscollege.acc_hostel OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 125995)
-- Name: acc_hosteltypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_hosteltypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_hosteltypeseq OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 125997)
-- Name: acc_hosteltype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_hosteltype (
    id integer DEFAULT nextval('acc_hosteltypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    description character varying NOT NULL,
    lang character varying DEFAULT 'en'::character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege-accommodation'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL
);


ALTER TABLE opuscollege.acc_hosteltype OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 126008)
-- Name: acc_roomseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_roomseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_roomseq OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 126010)
-- Name: acc_room; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_room (
    id integer DEFAULT nextval('acc_roomseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    description character varying NOT NULL,
    numberofbedspaces integer DEFAULT 1 NOT NULL,
    hostelid integer NOT NULL,
    blockid integer DEFAULT 0,
    floornumber integer NOT NULL,
    writewho character varying DEFAULT 'opuscollege-accommodation'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    availablebedspace integer DEFAULT 0,
    roomtypecode character varying DEFAULT ''::character varying NOT NULL
);


ALTER TABLE opuscollege.acc_room OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 126024)
-- Name: acc_roomtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_roomtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_roomtypeseq OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 126026)
-- Name: acc_roomtype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_roomtype (
    id integer DEFAULT nextval('acc_roomtypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.acc_roomtype OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 126036)
-- Name: acc_studentaccommodationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_studentaccommodationseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_studentaccommodationseq OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 126038)
-- Name: acc_studentaccommodation; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_studentaccommodation (
    id integer DEFAULT nextval('acc_studentaccommodationseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    bednumber integer DEFAULT 0 NOT NULL,
    academicyearid integer NOT NULL,
    dateapplied date DEFAULT now() NOT NULL,
    dateapproved date,
    approved character(1) DEFAULT 'N'::bpchar NOT NULL,
    approvedbyid integer DEFAULT 0 NOT NULL,
    accepted character(1) DEFAULT 'N'::bpchar NOT NULL,
    dateaccepted date,
    reasonforapplyingforaccommodation character varying,
    comment character varying,
    roomid integer DEFAULT 0 NOT NULL,
    writewho character varying DEFAULT 'opuscollege-accommodation'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    allocated character(1) DEFAULT 'N'::bpchar NOT NULL,
    datedeallocated date
);


ALTER TABLE opuscollege.acc_studentaccommodation OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 126054)
-- Name: acc_studentaccommodationresourceseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_studentaccommodationresourceseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_studentaccommodationresourceseq OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 126056)
-- Name: acc_studentaccommodationresource; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_studentaccommodationresource (
    id integer DEFAULT nextval('acc_studentaccommodationresourceseq'::regclass) NOT NULL,
    studentaccommodationid integer NOT NULL,
    accommodationresourceid integer DEFAULT 0 NOT NULL,
    datecollected timestamp without time zone DEFAULT now() NOT NULL,
    datereturned timestamp without time zone,
    commentwhencollecting character varying(255),
    commentwhenreturning character varying(255),
    returned character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege-accommodation'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.acc_studentaccommodationresource OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 126068)
-- Name: acc_studentaccommodationselectioncriteriaseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_studentaccommodationselectioncriteriaseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_studentaccommodationselectioncriteriaseq OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 126070)
-- Name: addressseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE addressseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.addressseq OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 126072)
-- Name: address; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE address (
    id integer DEFAULT nextval('addressseq'::regclass) NOT NULL,
    addresstypecode character varying NOT NULL,
    personid integer DEFAULT 0,
    studyid integer DEFAULT 0,
    organizationalunitid integer DEFAULT 0,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    street character varying,
    number integer DEFAULT 0 NOT NULL,
    numberextension character varying,
    zipcode character varying,
    pobox character varying,
    city character varying,
    administrativepostcode character varying,
    districtcode character varying NOT NULL,
    provincecode character varying NOT NULL,
    countrycode character varying NOT NULL,
    telephone character varying,
    faxnumber character varying,
    mobilephone character varying,
    emailaddress character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.address OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 126086)
-- Name: addresstypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE addresstypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.addresstypeseq OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 126088)
-- Name: addresstype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE addresstype (
    id integer DEFAULT nextval('addresstypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.addresstype OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 126098)
-- Name: administrativepostseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE administrativepostseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.administrativepostseq OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 126100)
-- Name: administrativepost; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE administrativepost (
    id integer DEFAULT nextval('administrativepostseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    districtcode character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.administrativepost OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 126110)
-- Name: organizationalunitacademicyearseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE organizationalunitacademicyearseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.organizationalunitacademicyearseq OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 126112)
-- Name: admissionregistrationconfig; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE admissionregistrationconfig (
    id integer DEFAULT nextval('organizationalunitacademicyearseq'::regclass) NOT NULL,
    organizationalunitid integer NOT NULL,
    academicyearid integer NOT NULL,
    startofregistration date,
    endofregistration date,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    startofadmission date,
    endofadmission date,
    startofrefundperiod date,
    endofrefundperiod date
);


ALTER TABLE opuscollege.admissionregistrationconfig OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 126122)
-- Name: appconfigseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE appconfigseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.appconfigseq OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 126124)
-- Name: appconfig; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE appconfig (
    id integer DEFAULT nextval('appconfigseq'::regclass) NOT NULL,
    appconfigattributename character varying DEFAULT ''::character varying NOT NULL,
    appconfigattributevalue character varying DEFAULT ''::character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    startdate date NOT NULL,
    enddate date
);


ALTER TABLE opuscollege.appconfig OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 126135)
-- Name: applicantcategoryseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE applicantcategoryseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.applicantcategoryseq OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 126137)
-- Name: applicantcategory; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE applicantcategory (
    id integer DEFAULT nextval('applicantcategoryseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.applicantcategory OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 126147)
-- Name: appointmenttypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE appointmenttypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.appointmenttypeseq OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 126149)
-- Name: appointmenttype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE appointmenttype (
    id integer DEFAULT nextval('appointmenttypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.appointmenttype OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 126159)
-- Name: appversionsseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE appversionsseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.appversionsseq OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 126161)
-- Name: appversions; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE appversions (
    id integer DEFAULT nextval('appversionsseq'::regclass) NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    module character varying DEFAULT ''::character varying NOT NULL,
    state character(1) DEFAULT 'N'::bpchar NOT NULL,
    db character(1) DEFAULT 'N'::bpchar NOT NULL,
    dbversion numeric(10,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE opuscollege.appversions OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 126174)
-- Name: authorisation; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE authorisation (
    code character varying NOT NULL,
    description character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.authorisation OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 126183)
-- Name: blocktypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE blocktypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.blocktypeseq OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 126185)
-- Name: blocktype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE blocktype (
    id integer DEFAULT nextval('blocktypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.blocktype OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 126195)
-- Name: bloodtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE bloodtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.bloodtypeseq OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 126197)
-- Name: bloodtype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE bloodtype (
    id integer DEFAULT nextval('bloodtypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.bloodtype OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 126207)
-- Name: branchseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE branchseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.branchseq OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 126209)
-- Name: branch; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE branch (
    id integer DEFAULT nextval('branchseq'::regclass) NOT NULL,
    branchcode character varying NOT NULL,
    branchdescription character varying,
    institutionid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    registrationdate date DEFAULT now() NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.branch OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 126220)
-- Name: branchacademicyeartimeunitseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE branchacademicyeartimeunitseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.branchacademicyeartimeunitseq OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 126222)
-- Name: branchacademicyeartimeunit; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE branchacademicyeartimeunit (
    id integer DEFAULT nextval('branchacademicyeartimeunitseq'::regclass) NOT NULL,
    branchid integer NOT NULL,
    academicyearid integer NOT NULL,
    cardinaltimeunitcode character varying NOT NULL,
    cardinaltimeunitnumber integer NOT NULL,
    resultspublishdate date,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL
);


ALTER TABLE opuscollege.branchacademicyeartimeunit OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 126230)
-- Name: cardinaltimeunitseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE cardinaltimeunitseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.cardinaltimeunitseq OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 126232)
-- Name: cardinaltimeunit; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

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


ALTER TABLE opuscollege.cardinaltimeunit OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 126243)
-- Name: cardinaltimeunitresultseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE cardinaltimeunitresultseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.cardinaltimeunitresultseq OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 126245)
-- Name: cardinaltimeunitresult; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

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


ALTER TABLE opuscollege.cardinaltimeunitresult OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 126258)
-- Name: cardinaltimeunitstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE cardinaltimeunitstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.cardinaltimeunitstatusseq OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 126260)
-- Name: cardinaltimeunitstatus; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE cardinaltimeunitstatus (
    id integer DEFAULT nextval('cardinaltimeunitstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    description character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.cardinaltimeunitstatus OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 126270)
-- Name: cardinaltimeunitstudygradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE cardinaltimeunitstudygradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.cardinaltimeunitstudygradetypeseq OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 126272)
-- Name: cardinaltimeunitstudygradetype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

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


ALTER TABLE opuscollege.cardinaltimeunitstudygradetype OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 126285)
-- Name: careerpositionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE careerpositionseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.careerpositionseq OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 126287)
-- Name: careerposition; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE careerposition (
    id integer DEFAULT nextval('careerpositionseq'::regclass) NOT NULL,
    studyplanid integer NOT NULL,
    employer character varying,
    startdate date,
    enddate date,
    careerposition character varying,
    responsibility character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.careerposition OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 126297)
-- Name: civilstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE civilstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.civilstatusseq OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 126299)
-- Name: civilstatus; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE civilstatus (
    id integer DEFAULT nextval('civilstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.civilstatus OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 126309)
-- Name: civiltitleseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE civiltitleseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.civiltitleseq OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 126311)
-- Name: civiltitle; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE civiltitle (
    id integer DEFAULT nextval('civiltitleseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.civiltitle OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 126321)
-- Name: classgroupseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE classgroupseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.classgroupseq OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 126323)
-- Name: classgroup; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE classgroup (
    id integer DEFAULT nextval('classgroupseq'::regclass) NOT NULL,
    description character varying,
    studygradetypeid integer NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.classgroup OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 126332)
-- Name: contractseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE contractseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.contractseq OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 126334)
-- Name: contract; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE contract (
    id integer DEFAULT nextval('contractseq'::regclass) NOT NULL,
    contractcode character varying NOT NULL,
    staffmemberid integer NOT NULL,
    contracttypecode character varying NOT NULL,
    contractdurationcode character varying NOT NULL,
    contractstartdate date NOT NULL,
    contractenddate date,
    contacthours numeric(10,2) DEFAULT 0 NOT NULL,
    fteappointmentoverall numeric(10,2) NOT NULL,
    fteeducation numeric(10,2) NOT NULL,
    fteresearch numeric(10,2) NOT NULL,
    fteadministrativetasks numeric(10,2) NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.contract OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 126344)
-- Name: contractdurationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE contractdurationseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.contractdurationseq OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 126346)
-- Name: contractduration; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE contractduration (
    id integer DEFAULT nextval('contractdurationseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.contractduration OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 126356)
-- Name: contracttypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE contracttypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.contracttypeseq OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 126358)
-- Name: contracttype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE contracttype (
    id integer DEFAULT nextval('contracttypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.contracttype OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 126368)
-- Name: countryseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE countryseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.countryseq OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 126370)
-- Name: country; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE country (
    id integer DEFAULT nextval('countryseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    short2 character(2),
    short3 character(3),
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.country OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 126380)
-- Name: daypartseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE daypartseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.daypartseq OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 126382)
-- Name: daypart; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE daypart (
    id integer DEFAULT nextval('daypartseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.daypart OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 126392)
-- Name: disciplineseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE disciplineseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.disciplineseq OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 126394)
-- Name: discipline; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE discipline (
    id integer DEFAULT nextval('disciplineseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.discipline OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 126404)
-- Name: disciplinegroupseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE disciplinegroupseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.disciplinegroupseq OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 126406)
-- Name: disciplinegroup; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE disciplinegroup (
    id integer DEFAULT nextval('disciplinegroupseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.disciplinegroup OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 126416)
-- Name: districtseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE districtseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.districtseq OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 126418)
-- Name: district; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE district (
    id integer DEFAULT nextval('districtseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    provincecode character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.district OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 126428)
-- Name: educationareaseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE educationareaseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.educationareaseq OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 126430)
-- Name: educationarea; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE educationarea (
    id integer DEFAULT nextval('educationareaseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.educationarea OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 126440)
-- Name: educationlevelseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE educationlevelseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.educationlevelseq OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 126442)
-- Name: educationlevel; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE educationlevel (
    id integer DEFAULT nextval('educationlevelseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.educationlevel OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 126452)
-- Name: educationtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE educationtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.educationtypeseq OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 126454)
-- Name: educationtype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE educationtype (
    id integer DEFAULT nextval('educationtypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.educationtype OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 126464)
-- Name: endgradeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE endgradeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.endgradeseq OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 126466)
-- Name: endgrade; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE endgrade (
    id integer DEFAULT nextval('endgradeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
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
    passed character(1) DEFAULT 'N'::bpchar NOT NULL,
    academicyearid integer NOT NULL
);


ALTER TABLE opuscollege.endgrade OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 126478)
-- Name: endgradegeneralseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE endgradegeneralseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.endgradegeneralseq OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 126480)
-- Name: endgradegeneral; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE endgradegeneral (
    id integer DEFAULT nextval('endgradegeneralseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    comment character varying,
    description character varying,
    temporarygrade character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.endgradegeneral OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 126491)
-- Name: endgradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE endgradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.endgradetypeseq OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 126493)
-- Name: endgradetype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE endgradetype (
    id integer DEFAULT nextval('endgradetypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL
);


ALTER TABLE opuscollege.endgradetype OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 126503)
-- Name: entityseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE entityseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.entityseq OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 126505)
-- Name: examinationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examinationseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.examinationseq OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 126507)
-- Name: examination; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE examination (
    id integer DEFAULT nextval('examinationseq'::regclass) NOT NULL,
    examinationcode character varying NOT NULL,
    examinationdescription character varying,
    subjectid integer NOT NULL,
    examinationtypecode character varying NOT NULL,
    numberofattempts integer NOT NULL,
    weighingfactor integer NOT NULL,
    brspassingexamination character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.examination OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 126517)
-- Name: examinationresultseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examinationresultseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.examinationresultseq OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 126519)
-- Name: examinationresult; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE examinationresult (
    id integer DEFAULT nextval('examinationresultseq'::regclass) NOT NULL,
    examinationid integer NOT NULL,
    subjectid integer NOT NULL,
    studyplandetailid integer NOT NULL,
    examinationresultdate date,
    attemptnr integer NOT NULL,
    mark character varying,
    staffmemberid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    passed character(1) DEFAULT 'N'::bpchar NOT NULL,
    subjectresultid integer DEFAULT 0 NOT NULL
);


ALTER TABLE opuscollege.examinationresult OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 126531)
-- Name: examinationteacherseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examinationteacherseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.examinationteacherseq OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 126533)
-- Name: examinationteacher; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE examinationteacher (
    id integer DEFAULT nextval('examinationteacherseq'::regclass) NOT NULL,
    staffmemberid integer NOT NULL,
    examinationid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    classgroupid integer
);


ALTER TABLE opuscollege.examinationteacher OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 126543)
-- Name: examinationtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examinationtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.examinationtypeseq OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 126545)
-- Name: examinationtype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE examinationtype (
    id integer DEFAULT nextval('examinationtypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.examinationtype OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 126555)
-- Name: examseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.examseq OWNER TO postgres;

--
-- TOC entry 300 (class 1259 OID 126557)
-- Name: examtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.examtypeseq OWNER TO postgres;

--
-- TOC entry 301 (class 1259 OID 126559)
-- Name: examtype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE examtype (
    id integer DEFAULT nextval('examtypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.examtype OWNER TO postgres;

--
-- TOC entry 302 (class 1259 OID 126569)
-- Name: exclusion; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE exclusion (
    subject1 character varying(10) NOT NULL,
    subject2 character varying(10) NOT NULL
);


ALTER TABLE opuscollege.exclusion OWNER TO postgres;

--
-- TOC entry 303 (class 1259 OID 126572)
-- Name: expellationtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE expellationtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.expellationtypeseq OWNER TO postgres;

--
-- TOC entry 304 (class 1259 OID 126574)
-- Name: expellationtype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE expellationtype (
    id integer DEFAULT nextval('expellationtypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.expellationtype OWNER TO postgres;

--
-- TOC entry 305 (class 1259 OID 126584)
-- Name: failgradeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE failgradeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.failgradeseq OWNER TO postgres;

--
-- TOC entry 306 (class 1259 OID 126586)
-- Name: failgrade; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE failgrade (
    id integer DEFAULT nextval('failgradeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    comment character varying,
    description character varying,
    temporarygrade character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.failgrade OWNER TO postgres;

--
-- TOC entry 307 (class 1259 OID 126597)
-- Name: fee_feeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE fee_feeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.fee_feeseq OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 126599)
-- Name: fee_fee; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE fee_fee (
    id integer DEFAULT nextval('fee_feeseq'::regclass) NOT NULL,
    feedue numeric(10,2) DEFAULT 0.00 NOT NULL,
    deadline date DEFAULT now() NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege-fees'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    categorycode character varying(4),
    subjectblockstudygradetypeid integer DEFAULT 0 NOT NULL,
    subjectstudygradetypeid integer DEFAULT 0 NOT NULL,
    studygradetypeid integer DEFAULT 0 NOT NULL,
    academicyearid integer DEFAULT 0 NOT NULL,
    numberofinstallments integer NOT NULL,
    tuitionwaiverdiscountpercentage integer DEFAULT 0 NOT NULL,
    fulltimestudentdiscountpercentage integer DEFAULT 0 NOT NULL,
    localstudentdiscountpercentage integer NOT NULL,
    continuedregistrationdiscountpercentage integer DEFAULT 0 NOT NULL,
    postgraduatediscountpercentage integer DEFAULT 0 NOT NULL,
    accommodationfeeid integer DEFAULT 0 NOT NULL,
    branchid integer DEFAULT 0 NOT NULL
);


ALTER TABLE opuscollege.fee_fee OWNER TO postgres;

--
-- TOC entry 309 (class 1259 OID 126621)
-- Name: fee_feecategoryseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE fee_feecategoryseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.fee_feecategoryseq OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 126623)
-- Name: fee_feecategory; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE fee_feecategory (
    id integer DEFAULT nextval('fee_feecategoryseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.fee_feecategory OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 126633)
-- Name: fee_paymentseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE fee_paymentseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.fee_paymentseq OWNER TO postgres;

--
-- TOC entry 312 (class 1259 OID 126635)
-- Name: fee_payment; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE fee_payment (
    id integer DEFAULT nextval('fee_paymentseq'::regclass) NOT NULL,
    paydate date DEFAULT now() NOT NULL,
    studentid integer NOT NULL,
    studyplandetailid integer DEFAULT 0 NOT NULL,
    subjectblockid integer DEFAULT 0 NOT NULL,
    subjectid integer DEFAULT 0 NOT NULL,
    sumpaid numeric(10,2) DEFAULT 0.00 NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege-fees'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    feeid integer NOT NULL,
    studentbalanceid integer NOT NULL,
    installmentnumber integer DEFAULT 0 NOT NULL
);


ALTER TABLE opuscollege.fee_payment OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 126651)
-- Name: fieldofeducationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE fieldofeducationseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.fieldofeducationseq OWNER TO postgres;

--
-- TOC entry 314 (class 1259 OID 126653)
-- Name: fieldofeducation; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE fieldofeducation (
    id integer DEFAULT nextval('fieldofeducationseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.fieldofeducation OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 126663)
-- Name: financialrequestseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE financialrequestseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.financialrequestseq OWNER TO postgres;

--
-- TOC entry 316 (class 1259 OID 126665)
-- Name: financialrequest; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE financialrequest (
    id integer DEFAULT nextval('financialrequestseq'::regclass) NOT NULL,
    requestid character varying,
    financialrequestid character varying,
    statuscode integer NOT NULL,
    timestampreceived timestamp without time zone,
    requestversion character varying,
    requeststring character varying,
    timestampmodified timestamp without time zone,
    errorcode integer NOT NULL,
    processedtofinancetransaction character(1) DEFAULT 'N'::bpchar NOT NULL,
    errorreportedtofinancialsystem character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewho character varying DEFAULT 'unza'::character varying NOT NULL,
    requesttypeid integer,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    studentid integer NOT NULL
);


ALTER TABLE opuscollege.financialrequest OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 126676)
-- Name: financialtransactionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE financialtransactionseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.financialtransactionseq OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 126678)
-- Name: financialtransaction; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE financialtransaction (
    id integer DEFAULT nextval('financialtransactionseq'::regclass) NOT NULL,
    transactiontypeid integer NOT NULL,
    financialrequestid character varying NOT NULL,
    requestid character varying NOT NULL,
    statuscode integer NOT NULL,
    errorcode integer NOT NULL,
    nationalregistrationnumber character varying NOT NULL,
    academicyearid integer,
    timestampprocessed timestamp without time zone,
    amount numeric(10,2) NOT NULL,
    name character varying NOT NULL,
    cell character varying,
    requeststring character varying NOT NULL,
    processedtostudentbalance character(1) DEFAULT 'N'::bpchar NOT NULL,
    errorreportedtofinancialbankrequest character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    studentcode character varying
);


ALTER TABLE opuscollege.financialtransaction OWNER TO postgres;

--
-- TOC entry 319 (class 1259 OID 126689)
-- Name: frequencyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE frequencyseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.frequencyseq OWNER TO postgres;

--
-- TOC entry 320 (class 1259 OID 126691)
-- Name: frequency; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE frequency (
    id integer DEFAULT nextval('frequencyseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.frequency OWNER TO postgres;

--
-- TOC entry 321 (class 1259 OID 126701)
-- Name: functionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE functionseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.functionseq OWNER TO postgres;

--
-- TOC entry 322 (class 1259 OID 126703)
-- Name: function; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE function (
    id integer DEFAULT nextval('functionseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.function OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 126713)
-- Name: functionlevelseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE functionlevelseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.functionlevelseq OWNER TO postgres;

--
-- TOC entry 324 (class 1259 OID 126715)
-- Name: functionlevel; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE functionlevel (
    id integer DEFAULT nextval('functionlevelseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.functionlevel OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 126725)
-- Name: genderseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE genderseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.genderseq OWNER TO postgres;

--
-- TOC entry 326 (class 1259 OID 126727)
-- Name: gender; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE gender (
    id integer DEFAULT nextval('genderseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.gender OWNER TO postgres;

--
-- TOC entry 327 (class 1259 OID 126737)
-- Name: gradedsecondaryschoolsubjectseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE gradedsecondaryschoolsubjectseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.gradedsecondaryschoolsubjectseq OWNER TO postgres;

--
-- TOC entry 328 (class 1259 OID 126739)
-- Name: gradedsecondaryschoolsubject; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE gradedsecondaryschoolsubject (
    id integer DEFAULT nextval('gradedsecondaryschoolsubjectseq'::regclass) NOT NULL,
    secondaryschoolsubjectid integer NOT NULL,
    studyplanid integer NOT NULL,
    grade character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    secondaryschoolsubjectgroupid integer DEFAULT 0 NOT NULL,
    level character(1)
);


ALTER TABLE opuscollege.gradedsecondaryschoolsubject OWNER TO postgres;

--
-- TOC entry 329 (class 1259 OID 126750)
-- Name: gradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE gradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.gradetypeseq OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 126752)
-- Name: gradetype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE gradetype (
    id integer DEFAULT nextval('gradetypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    title character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    educationlevelcode character(1),
    educationareacode character(1)
);


ALTER TABLE opuscollege.gradetype OWNER TO postgres;

--
-- TOC entry 331 (class 1259 OID 126762)
-- Name: groupeddisciplineseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE groupeddisciplineseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.groupeddisciplineseq OWNER TO postgres;

--
-- TOC entry 332 (class 1259 OID 126764)
-- Name: groupeddiscipline; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE groupeddiscipline (
    id integer DEFAULT nextval('groupeddisciplineseq'::regclass) NOT NULL,
    disciplinecode character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    disciplinegroupid integer
);


ALTER TABLE opuscollege.groupeddiscipline OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 126774)
-- Name: groupedsecondaryschoolsubjectseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE groupedsecondaryschoolsubjectseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.groupedsecondaryschoolsubjectseq OWNER TO postgres;

--
-- TOC entry 334 (class 1259 OID 126776)
-- Name: groupedsecondaryschoolsubject; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

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


ALTER TABLE opuscollege.groupedsecondaryschoolsubject OWNER TO postgres;

--
-- TOC entry 335 (class 1259 OID 126789)
-- Name: identificationtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE identificationtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.identificationtypeseq OWNER TO postgres;

--
-- TOC entry 336 (class 1259 OID 126791)
-- Name: identificationtype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE identificationtype (
    id integer DEFAULT nextval('identificationtypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.identificationtype OWNER TO postgres;

--
-- TOC entry 337 (class 1259 OID 126801)
-- Name: subjectimportanceseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectimportanceseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectimportanceseq OWNER TO postgres;

--
-- TOC entry 338 (class 1259 OID 126803)
-- Name: importancetype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE importancetype (
    id integer DEFAULT nextval('subjectimportanceseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.importancetype OWNER TO postgres;

--
-- TOC entry 339 (class 1259 OID 126813)
-- Name: institutionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE institutionseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.institutionseq OWNER TO postgres;

--
-- TOC entry 340 (class 1259 OID 126815)
-- Name: institution; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE institution (
    id integer DEFAULT nextval('institutionseq'::regclass) NOT NULL,
    institutioncode character varying NOT NULL,
    educationtypecode character varying NOT NULL,
    institutiondescription character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    provincecode character varying NOT NULL,
    rector character varying,
    registrationdate date DEFAULT now() NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.institution OWNER TO postgres;

--
-- TOC entry 341 (class 1259 OID 126826)
-- Name: languageseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE languageseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.languageseq OWNER TO postgres;

--
-- TOC entry 342 (class 1259 OID 126828)
-- Name: language; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE language (
    id integer DEFAULT nextval('languageseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    descriptionshort character(3),
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.language OWNER TO postgres;

--
-- TOC entry 343 (class 1259 OID 126838)
-- Name: levelofeducationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE levelofeducationseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.levelofeducationseq OWNER TO postgres;

--
-- TOC entry 344 (class 1259 OID 126840)
-- Name: levelofeducation; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE levelofeducation (
    id integer DEFAULT nextval('levelofeducationseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.levelofeducation OWNER TO postgres;

--
-- TOC entry 345 (class 1259 OID 126850)
-- Name: logmailerrorseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE logmailerrorseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.logmailerrorseq OWNER TO postgres;

--
-- TOC entry 346 (class 1259 OID 126852)
-- Name: logmailerror; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE logmailerror (
    id integer DEFAULT nextval('logmailerrorseq'::regclass) NOT NULL,
    recipients character varying DEFAULT ''::character varying NOT NULL,
    msgsubject character varying DEFAULT ''::character varying NOT NULL,
    msgsender character varying DEFAULT ''::character varying NOT NULL,
    errormsg character varying DEFAULT ''::character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.logmailerror OWNER TO postgres;

--
-- TOC entry 347 (class 1259 OID 126865)
-- Name: logrequesterrorseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE logrequesterrorseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.logrequesterrorseq OWNER TO postgres;

--
-- TOC entry 348 (class 1259 OID 126867)
-- Name: logrequesterror; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE logrequesterror (
    id integer DEFAULT nextval('logrequesterrorseq'::regclass) NOT NULL,
    ipaddress character varying DEFAULT ''::character varying NOT NULL,
    requeststring character varying DEFAULT ''::character varying NOT NULL,
    errormsg character varying DEFAULT ''::character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.logrequesterror OWNER TO postgres;

--
-- TOC entry 349 (class 1259 OID 126879)
-- Name: lookuptableseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE lookuptableseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.lookuptableseq OWNER TO postgres;

--
-- TOC entry 350 (class 1259 OID 126881)
-- Name: lookuptable; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE lookuptable (
    id integer DEFAULT nextval('lookuptableseq'::regclass) NOT NULL,
    tablename character varying NOT NULL,
    lookuptype character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.lookuptable OWNER TO postgres;

--
-- TOC entry 351 (class 1259 OID 126891)
-- Name: mailconfigseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE mailconfigseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.mailconfigseq OWNER TO postgres;

--
-- TOC entry 352 (class 1259 OID 126893)
-- Name: mailconfig; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE mailconfig (
    id integer DEFAULT nextval('mailconfigseq'::regclass) NOT NULL,
    msgtype character varying DEFAULT ''::character varying NOT NULL,
    msgsubject character varying DEFAULT ''::character varying NOT NULL,
    msgbody character varying DEFAULT ''::character varying NOT NULL,
    msgsender character varying DEFAULT ''::character varying NOT NULL,
    lang character(6) NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.mailconfig OWNER TO postgres;

--
-- TOC entry 353 (class 1259 OID 126906)
-- Name: masteringlevelseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE masteringlevelseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.masteringlevelseq OWNER TO postgres;

--
-- TOC entry 354 (class 1259 OID 126908)
-- Name: masteringlevel; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE masteringlevel (
    id integer DEFAULT nextval('masteringlevelseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.masteringlevel OWNER TO postgres;

--
-- TOC entry 355 (class 1259 OID 126918)
-- Name: nationalityseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE nationalityseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.nationalityseq OWNER TO postgres;

--
-- TOC entry 356 (class 1259 OID 126920)
-- Name: nationality; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE nationality (
    id integer DEFAULT nextval('nationalityseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    descriptionshort character(10),
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.nationality OWNER TO postgres;

--
-- TOC entry 357 (class 1259 OID 126930)
-- Name: nationalitygroupseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE nationalitygroupseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.nationalitygroupseq OWNER TO postgres;

--
-- TOC entry 358 (class 1259 OID 126932)
-- Name: nationalitygroup; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE nationalitygroup (
    id integer DEFAULT nextval('nationalitygroupseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.nationalitygroup OWNER TO postgres;

--
-- TOC entry 359 (class 1259 OID 126942)
-- Name: obtainedqualificationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE obtainedqualificationseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.obtainedqualificationseq OWNER TO postgres;

--
-- TOC entry 360 (class 1259 OID 126944)
-- Name: obtainedqualification; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE obtainedqualification (
    id integer DEFAULT nextval('obtainedqualificationseq'::regclass) NOT NULL,
    studyplanid integer NOT NULL,
    university character varying,
    startdate date,
    enddate date,
    qualification character varying,
    endgradedate date,
    gradetypecode character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.obtainedqualification OWNER TO postgres;

--
-- TOC entry 361 (class 1259 OID 126954)
-- Name: opusprivilegeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE opusprivilegeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.opusprivilegeseq OWNER TO postgres;

--
-- TOC entry 362 (class 1259 OID 126956)
-- Name: opusprivilege; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

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


ALTER TABLE opuscollege.opusprivilege OWNER TO postgres;

--
-- TOC entry 363 (class 1259 OID 126966)
-- Name: opusrole_privilegeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE opusrole_privilegeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.opusrole_privilegeseq OWNER TO postgres;

--
-- TOC entry 364 (class 1259 OID 126968)
-- Name: opusrole_privilege; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE opusrole_privilege (
    id integer DEFAULT nextval('opusrole_privilegeseq'::regclass) NOT NULL,
    privilegecode character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    role character varying,
    validfrom date,
    validthrough date,
    active character varying(1) DEFAULT 'Y'::character varying NOT NULL
);


ALTER TABLE opuscollege.opusrole_privilege OWNER TO postgres;

--
-- TOC entry 365 (class 1259 OID 126978)
-- Name: opususerseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE opususerseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.opususerseq OWNER TO postgres;

--
-- TOC entry 366 (class 1259 OID 126980)
-- Name: opususer; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE opususer (
    id integer DEFAULT nextval('opususerseq'::regclass) NOT NULL,
    personid integer DEFAULT 0 NOT NULL,
    username character varying NOT NULL,
    pw character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    lang character varying(5) DEFAULT 'en'::bpchar NOT NULL,
    preferredorganizationalunitid integer DEFAULT 0 NOT NULL,
    failedloginattempts smallint DEFAULT 0 NOT NULL
);


ALTER TABLE opuscollege.opususer OWNER TO postgres;

--
-- TOC entry 367 (class 1259 OID 126993)
-- Name: opususerroleseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE opususerroleseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.opususerroleseq OWNER TO postgres;

--
-- TOC entry 368 (class 1259 OID 126995)
-- Name: opususerrole; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE opususerrole (
    id integer DEFAULT nextval('opususerroleseq'::regclass) NOT NULL,
    role character varying NOT NULL,
    username character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    validfrom date DEFAULT now() NOT NULL,
    validthrough date,
    organizationalunitid integer DEFAULT 0 NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL
);


ALTER TABLE opuscollege.opususerrole OWNER TO postgres;

--
-- TOC entry 369 (class 1259 OID 127007)
-- Name: penaltyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE penaltyseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.penaltyseq OWNER TO postgres;

--
-- TOC entry 370 (class 1259 OID 127009)
-- Name: penalty; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE penalty (
    id integer DEFAULT nextval('penaltyseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    penaltytypecode character varying NOT NULL,
    amount numeric(10,2) DEFAULT 0.00 NOT NULL,
    startdate date,
    enddate date,
    remark character varying,
    paid character(1) DEFAULT 'N'::bpchar NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.penalty OWNER TO postgres;

--
-- TOC entry 371 (class 1259 OID 127021)
-- Name: penaltytypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE penaltytypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.penaltytypeseq OWNER TO postgres;

--
-- TOC entry 372 (class 1259 OID 127023)
-- Name: penaltytype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE penaltytype (
    id integer DEFAULT nextval('penaltytypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.penaltytype OWNER TO postgres;

--
-- TOC entry 373 (class 1259 OID 127033)
-- Name: personseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE personseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.personseq OWNER TO postgres;

--
-- TOC entry 374 (class 1259 OID 127035)
-- Name: person; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE person (
    id integer DEFAULT nextval('personseq'::regclass) NOT NULL,
    personcode character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    surnamefull character varying NOT NULL,
    surnamealias character varying,
    firstnamesfull character varying NOT NULL,
    firstnamesalias character varying,
    nationalregistrationnumber character varying,
    civiltitlecode character varying,
    gradetypecode character varying,
    gendercode character varying DEFAULT '3'::character varying,
    birthdate date DEFAULT now() NOT NULL,
    nationalitycode character varying,
    placeofbirth character varying,
    districtofbirthcode character varying,
    provinceofbirthcode character varying,
    countryofbirthcode character varying,
    cityoforigin character varying,
    administrativepostoforigincode character varying,
    districtoforigincode character varying,
    provinceoforigincode character varying,
    countryoforigincode character varying,
    civilstatuscode character varying,
    housingoncampus character(1),
    identificationtypecode character varying,
    identificationnumber character varying,
    identificationplaceofissue character varying,
    identificationdateofissue date,
    identificationdateofexpiration date,
    professioncode character varying,
    professiondescription character varying,
    languagefirstcode character varying,
    languagefirstmasteringlevelcode character varying,
    languagesecondcode character varying,
    languagesecondmasteringlevelcode character varying,
    languagethirdcode character varying,
    languagethirdmasteringlevelcode character varying,
    contactpersonemergenciesname character varying,
    contactpersonemergenciestelephonenumber character varying,
    bloodtypecode character varying,
    healthissues character varying,
    photograph bytea,
    remarks character varying,
    registrationdate date DEFAULT now() NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    photographname character varying,
    photographmimetype character varying,
    publichomepage character(1) DEFAULT 'N'::bpchar NOT NULL,
    socialnetworks character varying,
    hobbies character varying,
    motivation character varying
);


ALTER TABLE opuscollege.person OWNER TO postgres;

--
-- TOC entry 375 (class 1259 OID 127049)
-- Name: professionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE professionseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.professionseq OWNER TO postgres;

--
-- TOC entry 376 (class 1259 OID 127051)
-- Name: profession; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE profession (
    id integer DEFAULT nextval('professionseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.profession OWNER TO postgres;

--
-- TOC entry 377 (class 1259 OID 127061)
-- Name: progressstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE progressstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.progressstatusseq OWNER TO postgres;

--
-- TOC entry 378 (class 1259 OID 127063)
-- Name: progressstatus; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

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


ALTER TABLE opuscollege.progressstatus OWNER TO postgres;

--
-- TOC entry 379 (class 1259 OID 127077)
-- Name: provinceseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE provinceseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.provinceseq OWNER TO postgres;

--
-- TOC entry 380 (class 1259 OID 127079)
-- Name: province; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE province (
    id integer DEFAULT nextval('provinceseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    countrycode character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.province OWNER TO postgres;

--
-- TOC entry 381 (class 1259 OID 127089)
-- Name: refereeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE refereeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.refereeseq OWNER TO postgres;

--
-- TOC entry 382 (class 1259 OID 127091)
-- Name: referee; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE referee (
    id integer DEFAULT nextval('refereeseq'::regclass) NOT NULL,
    studyplanid integer NOT NULL,
    name character varying,
    address character varying,
    telephone character varying,
    email character varying,
    orderby integer,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.referee OWNER TO postgres;

--
-- TOC entry 383 (class 1259 OID 127101)
-- Name: relationtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE relationtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.relationtypeseq OWNER TO postgres;

--
-- TOC entry 384 (class 1259 OID 127103)
-- Name: relationtype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE relationtype (
    id integer DEFAULT nextval('relationtypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.relationtype OWNER TO postgres;

--
-- TOC entry 385 (class 1259 OID 127113)
-- Name: reportpropertyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE reportpropertyseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.reportpropertyseq OWNER TO postgres;

--
-- TOC entry 386 (class 1259 OID 127115)
-- Name: reportproperty; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE reportproperty (
    id integer DEFAULT nextval('reportpropertyseq'::regclass) NOT NULL,
    reportname character varying NOT NULL,
    propertyname character varying NOT NULL,
    propertytype character varying NOT NULL,
    propertyfile bytea,
    propertytext character varying,
    visible boolean DEFAULT true NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.reportproperty OWNER TO postgres;

--
-- TOC entry 387 (class 1259 OID 127126)
-- Name: requestadmissionperiod; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE requestadmissionperiod (
    startdate date NOT NULL,
    enddate date NOT NULL,
    academicyearid integer NOT NULL,
    numberofsubjectstograde integer,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.requestadmissionperiod OWNER TO postgres;

--
-- TOC entry 388 (class 1259 OID 127134)
-- Name: requestforchangeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE requestforchangeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.requestforchangeseq OWNER TO postgres;

--
-- TOC entry 389 (class 1259 OID 127136)
-- Name: requestforchange; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

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


ALTER TABLE opuscollege.requestforchange OWNER TO postgres;

--
-- TOC entry 390 (class 1259 OID 127149)
-- Name: rfcstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE rfcstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.rfcstatusseq OWNER TO postgres;

--
-- TOC entry 391 (class 1259 OID 127151)
-- Name: rfcstatus; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE rfcstatus (
    id integer DEFAULT nextval('rfcstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL
);


ALTER TABLE opuscollege.rfcstatus OWNER TO postgres;

--
-- TOC entry 392 (class 1259 OID 127161)
-- Name: rigiditytypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE rigiditytypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.rigiditytypeseq OWNER TO postgres;

--
-- TOC entry 393 (class 1259 OID 127163)
-- Name: rigiditytype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE rigiditytype (
    id integer DEFAULT nextval('rigiditytypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.rigiditytype OWNER TO postgres;

--
-- TOC entry 394 (class 1259 OID 127173)
-- Name: roleseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE roleseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.roleseq OWNER TO postgres;

--
-- TOC entry 395 (class 1259 OID 127175)
-- Name: role; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE role (
    id integer DEFAULT nextval('roleseq'::regclass) NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    role character varying NOT NULL,
    roledescription character varying NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    level integer NOT NULL
);


ALTER TABLE opuscollege.role OWNER TO postgres;

--
-- TOC entry 396 (class 1259 OID 127185)
-- Name: sch_bankseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_bankseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_bankseq OWNER TO postgres;

--
-- TOC entry 397 (class 1259 OID 127187)
-- Name: sch_bank; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_bank (
    id integer DEFAULT nextval('sch_bankseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.sch_bank OWNER TO postgres;

--
-- TOC entry 398 (class 1259 OID 127197)
-- Name: sch_complaintseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_complaintseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_complaintseq OWNER TO postgres;

--
-- TOC entry 399 (class 1259 OID 127199)
-- Name: sch_complaint; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_complaint (
    id integer DEFAULT nextval('sch_complaintseq'::regclass) NOT NULL,
    complaintdate date,
    reason character varying NOT NULL,
    complaintstatuscode character varying NOT NULL,
    scholarshipapplicationid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    result character varying
);


ALTER TABLE opuscollege.sch_complaint OWNER TO postgres;

--
-- TOC entry 400 (class 1259 OID 127209)
-- Name: sch_complaintstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_complaintstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_complaintstatusseq OWNER TO postgres;

--
-- TOC entry 401 (class 1259 OID 127211)
-- Name: sch_complaintstatus; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_complaintstatus (
    id integer DEFAULT nextval('sch_complaintstatusseq'::regclass) NOT NULL,
    description character varying,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.sch_complaintstatus OWNER TO postgres;

--
-- TOC entry 402 (class 1259 OID 127221)
-- Name: sch_decisioncriteriaseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_decisioncriteriaseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_decisioncriteriaseq OWNER TO postgres;

--
-- TOC entry 403 (class 1259 OID 127223)
-- Name: sch_decisioncriteria; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_decisioncriteria (
    id integer DEFAULT nextval('sch_decisioncriteriaseq'::regclass) NOT NULL,
    description character varying,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.sch_decisioncriteria OWNER TO postgres;

--
-- TOC entry 404 (class 1259 OID 127233)
-- Name: sch_scholarshipseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_scholarshipseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_scholarshipseq OWNER TO postgres;

--
-- TOC entry 405 (class 1259 OID 127235)
-- Name: sch_scholarship; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_scholarship (
    id integer DEFAULT nextval('sch_scholarshipseq'::regclass) NOT NULL,
    scholarshiptypecode character varying NOT NULL,
    sponsorid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    amount numeric(10,2),
    housingcosts numeric(10,2),
    academicyearid integer
);


ALTER TABLE opuscollege.sch_scholarship OWNER TO postgres;

--
-- TOC entry 406 (class 1259 OID 127245)
-- Name: sch_scholarshipapplicationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_scholarshipapplicationseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_scholarshipapplicationseq OWNER TO postgres;

--
-- TOC entry 407 (class 1259 OID 127247)
-- Name: sch_scholarshipapplication; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_scholarshipapplication (
    id integer DEFAULT nextval('sch_scholarshipapplicationseq'::regclass) NOT NULL,
    scholarshipstudentid integer NOT NULL,
    scholarshipappliedforid integer NOT NULL,
    scholarshipgrantedid integer,
    decisioncriteriacode character varying,
    scholarshipamount numeric(10,2),
    observation character varying,
    validfrom date,
    validuntil date,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    studyplanid integer DEFAULT 0 NOT NULL,
    feeid integer DEFAULT 0 NOT NULL
);


ALTER TABLE opuscollege.sch_scholarshipapplication OWNER TO postgres;

--
-- TOC entry 408 (class 1259 OID 127259)
-- Name: sch_scholarshiptypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_scholarshiptypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_scholarshiptypeseq OWNER TO postgres;

--
-- TOC entry 409 (class 1259 OID 127261)
-- Name: sch_scholarshiptype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_scholarshiptype (
    id integer DEFAULT nextval('sch_scholarshiptypeseq'::regclass) NOT NULL,
    description character varying NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.sch_scholarshiptype OWNER TO postgres;

--
-- TOC entry 410 (class 1259 OID 127271)
-- Name: sch_sponsorseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_sponsorseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_sponsorseq OWNER TO postgres;

--
-- TOC entry 411 (class 1259 OID 127273)
-- Name: sch_sponsor; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_sponsor (
    id integer DEFAULT nextval('sch_sponsorseq'::regclass) NOT NULL,
    code character varying,
    name character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    sponsortypecode character varying NOT NULL
);


ALTER TABLE opuscollege.sch_sponsor OWNER TO postgres;

--
-- TOC entry 412 (class 1259 OID 127283)
-- Name: sch_sponsorfeepercentage_seq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_sponsorfeepercentage_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_sponsorfeepercentage_seq OWNER TO postgres;

--
-- TOC entry 413 (class 1259 OID 127285)
-- Name: sch_sponsorfeepercentage; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_sponsorfeepercentage (
    id integer DEFAULT nextval('sch_sponsorfeepercentage_seq'::regclass) NOT NULL,
    sponsorcode character varying NOT NULL,
    feecategorycode character varying NOT NULL,
    percentage character varying NOT NULL
);


ALTER TABLE opuscollege.sch_sponsorfeepercentage OWNER TO postgres;

--
-- TOC entry 414 (class 1259 OID 127292)
-- Name: sch_sponsorpayment_seq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_sponsorpayment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_sponsorpayment_seq OWNER TO postgres;

--
-- TOC entry 415 (class 1259 OID 127294)
-- Name: sch_sponsorpayment; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_sponsorpayment (
    id integer DEFAULT nextval('sch_sponsorpayment_seq'::regclass) NOT NULL,
    scholarshipapplicationid integer NOT NULL,
    academicyearid integer NOT NULL,
    paymentduedate date,
    paymentreceiveddate date
);


ALTER TABLE opuscollege.sch_sponsorpayment OWNER TO postgres;

--
-- TOC entry 416 (class 1259 OID 127298)
-- Name: sch_sponsortype_seq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_sponsortype_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_sponsortype_seq OWNER TO postgres;

--
-- TOC entry 417 (class 1259 OID 127300)
-- Name: sch_sponsortype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_sponsortype (
    id integer DEFAULT nextval('sch_sponsortype_seq'::regclass) NOT NULL,
    code character varying NOT NULL,
    title character varying NOT NULL,
    lang character varying NOT NULL,
    description character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar,
    writewho character varying DEFAULT 'opuscollege-scholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.sch_sponsortype OWNER TO postgres;

--
-- TOC entry 418 (class 1259 OID 127310)
-- Name: sch_studentseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_studentseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_studentseq OWNER TO postgres;

--
-- TOC entry 419 (class 1259 OID 127312)
-- Name: sch_student; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_student (
    scholarshipstudentid integer DEFAULT nextval('sch_studentseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    account character varying,
    accountactivated boolean DEFAULT false,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    bankid integer DEFAULT 0 NOT NULL
);


ALTER TABLE opuscollege.sch_student OWNER TO postgres;

--
-- TOC entry 420 (class 1259 OID 127324)
-- Name: sch_subsidyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_subsidyseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_subsidyseq OWNER TO postgres;

--
-- TOC entry 421 (class 1259 OID 127326)
-- Name: sch_subsidy; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_subsidy (
    id integer DEFAULT nextval('sch_subsidyseq'::regclass) NOT NULL,
    scholarshipstudentid integer NOT NULL,
    subsidytypecode character varying NOT NULL,
    sponsorid integer NOT NULL,
    amount numeric(10,2),
    subsidydate date,
    observation character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.sch_subsidy OWNER TO postgres;

--
-- TOC entry 422 (class 1259 OID 127336)
-- Name: sch_subsidytypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_subsidytypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_subsidytypeseq OWNER TO postgres;

--
-- TOC entry 423 (class 1259 OID 127338)
-- Name: sch_subsidytype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_subsidytype (
    id integer DEFAULT nextval('sch_subsidytypeseq'::regclass) NOT NULL,
    description character varying,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.sch_subsidytype OWNER TO postgres;

--
-- TOC entry 424 (class 1259 OID 127348)
-- Name: secondaryschoolsubjectseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE secondaryschoolsubjectseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.secondaryschoolsubjectseq OWNER TO postgres;

--
-- TOC entry 425 (class 1259 OID 127350)
-- Name: secondaryschoolsubject; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE secondaryschoolsubject (
    id integer DEFAULT nextval('secondaryschoolsubjectseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.secondaryschoolsubject OWNER TO postgres;

--
-- TOC entry 426 (class 1259 OID 127360)
-- Name: secondaryschoolsubjectgroupseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE secondaryschoolsubjectgroupseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.secondaryschoolsubjectgroupseq OWNER TO postgres;

--
-- TOC entry 427 (class 1259 OID 127362)
-- Name: secondaryschoolsubjectgroup; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

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


ALTER TABLE opuscollege.secondaryschoolsubjectgroup OWNER TO postgres;

--
-- TOC entry 428 (class 1259 OID 127372)
-- Name: staffmemberseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE staffmemberseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.staffmemberseq OWNER TO postgres;

--
-- TOC entry 429 (class 1259 OID 127374)
-- Name: staffmember; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE staffmember (
    staffmemberid integer DEFAULT nextval('staffmemberseq'::regclass) NOT NULL,
    staffmembercode character varying NOT NULL,
    personid integer NOT NULL,
    dateofappointment date DEFAULT now(),
    appointmenttypecode character varying,
    stafftypecode character varying,
    primaryunitofappointmentid integer DEFAULT 0 NOT NULL,
    educationtypecode character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    startworkday time(5) without time zone,
    endworkday time(5) without time zone,
    teachingdaypartcode character varying,
    supervisingdaypartcode character varying
);


ALTER TABLE opuscollege.staffmember OWNER TO postgres;

--
-- TOC entry 430 (class 1259 OID 127385)
-- Name: staffmemberfunction; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE staffmemberfunction (
    staffmemberid integer NOT NULL,
    functioncode character varying NOT NULL,
    functionlevelcode character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.staffmemberfunction OWNER TO postgres;

--
-- TOC entry 431 (class 1259 OID 127394)
-- Name: stafftypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE stafftypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.stafftypeseq OWNER TO postgres;

--
-- TOC entry 432 (class 1259 OID 127396)
-- Name: stafftype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE stafftype (
    id integer DEFAULT nextval('stafftypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.stafftype OWNER TO postgres;

--
-- TOC entry 433 (class 1259 OID 127406)
-- Name: statusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE statusseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.statusseq OWNER TO postgres;

--
-- TOC entry 434 (class 1259 OID 127408)
-- Name: status; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE status (
    id integer DEFAULT nextval('statusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.status OWNER TO postgres;

--
-- TOC entry 435 (class 1259 OID 127418)
-- Name: studentseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentseq OWNER TO postgres;

--
-- TOC entry 436 (class 1259 OID 127420)
-- Name: student; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE student (
    studentid integer DEFAULT nextval('studentseq'::regclass) NOT NULL,
    studentcode character varying,
    personid integer NOT NULL,
    dateofenrolment date DEFAULT now(),
    primarystudyid integer DEFAULT 0 NOT NULL,
    statuscode character varying,
    expellationdate date,
    reasonforexpellation character varying,
    previousinstitutionid integer NOT NULL,
    previousinstitutionname character varying,
    previousinstitutiondistrictcode character varying,
    previousinstitutionprovincecode character varying,
    previousinstitutioncountrycode character varying,
    previousinstitutioneducationtypecode character varying,
    previousinstitutionfinalgradetypecode character varying,
    previousinstitutionfinalmark character varying,
    previousinstitutiondiplomaphotograph bytea,
    scholarship character(1) DEFAULT 'N'::bpchar NOT NULL,
    fatherfullname character varying,
    fathereducationcode character varying DEFAULT '0'::character varying,
    fatherprofessioncode character varying DEFAULT '0'::character varying,
    fatherprofessiondescription character varying,
    motherfullname character varying,
    mothereducationcode character varying DEFAULT '0'::character varying,
    motherprofessioncode character varying DEFAULT '0'::character varying,
    motherprofessiondescription character varying,
    financialguardianfullname character varying,
    financialguardianrelation character varying,
    financialguardianprofession character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    expellationenddate date,
    expellationtypecode character varying,
    previousinstitutiondiplomaphotographremarks character varying,
    previousinstitutiondiplomaphotographname character varying,
    previousinstitutiondiplomaphotographmimetype character varying,
    subscriptionrequirementsfulfilled character(1) DEFAULT 'Y'::bpchar NOT NULL,
    secondarystudyid integer DEFAULT 0 NOT NULL,
    foreignstudent character(1) DEFAULT 'N'::bpchar NOT NULL,
    nationalitygroupcode character varying,
    fathertelephone character varying,
    mothertelephone character varying,
    relativeofstaffmember character(1) DEFAULT 'N'::bpchar NOT NULL,
    ruralareaorigin character(1) DEFAULT 'N'::bpchar NOT NULL,
    employeenumberofrelative character varying
);


ALTER TABLE opuscollege.student OWNER TO postgres;

--
-- TOC entry 437 (class 1259 OID 127441)
-- Name: studentabsenceseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentabsenceseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentabsenceseq OWNER TO postgres;

--
-- TOC entry 438 (class 1259 OID 127443)
-- Name: studentabsence; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentabsence (
    id integer DEFAULT nextval('studentabsenceseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    startdatetemporaryinactivity date,
    enddatetemporaryinactivity date,
    reasonforabsence character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.studentabsence OWNER TO postgres;

--
-- TOC entry 439 (class 1259 OID 127452)
-- Name: studentactivityseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentactivityseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentactivityseq OWNER TO postgres;

--
-- TOC entry 440 (class 1259 OID 127454)
-- Name: studentactivity; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentactivity (
    id integer DEFAULT nextval('studentactivityseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    description character varying
);


ALTER TABLE opuscollege.studentactivity OWNER TO postgres;

--
-- TOC entry 441 (class 1259 OID 127461)
-- Name: studentbalance_seq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentbalance_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentbalance_seq OWNER TO postgres;

--
-- TOC entry 442 (class 1259 OID 127463)
-- Name: studentbalance; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentbalance (
    id integer DEFAULT nextval('studentbalance_seq'::regclass) NOT NULL,
    studentid integer DEFAULT 0 NOT NULL,
    feeid integer DEFAULT 0 NOT NULL,
    studyplancardinaltimeunitid integer DEFAULT 0 NOT NULL,
    studyplandetailid integer DEFAULT 0 NOT NULL,
    academicyearid integer DEFAULT 0 NOT NULL,
    exemption character(1) DEFAULT 'N'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.studentbalance OWNER TO postgres;

--
-- TOC entry 443 (class 1259 OID 127478)
-- Name: studentcareerseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentcareerseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentcareerseq OWNER TO postgres;

--
-- TOC entry 444 (class 1259 OID 127480)
-- Name: studentcareer; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentcareer (
    id integer DEFAULT nextval('studentcareerseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    description character varying
);


ALTER TABLE opuscollege.studentcareer OWNER TO postgres;

--
-- TOC entry 445 (class 1259 OID 127487)
-- Name: studentclassgroupseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentclassgroupseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentclassgroupseq OWNER TO postgres;

--
-- TOC entry 446 (class 1259 OID 127489)
-- Name: studentclassgroup; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentclassgroup (
    id integer DEFAULT nextval('studentclassgroupseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    classgroupid integer NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.studentclassgroup OWNER TO postgres;

--
-- TOC entry 447 (class 1259 OID 127498)
-- Name: studentcounselingseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentcounselingseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentcounselingseq OWNER TO postgres;

--
-- TOC entry 448 (class 1259 OID 127500)
-- Name: studentcounseling; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentcounseling (
    id integer DEFAULT nextval('studentcounselingseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    description character varying
);


ALTER TABLE opuscollege.studentcounseling OWNER TO postgres;

--
-- TOC entry 449 (class 1259 OID 127507)
-- Name: studentexpulsionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentexpulsionseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentexpulsionseq OWNER TO postgres;

--
-- TOC entry 450 (class 1259 OID 127509)
-- Name: studentexpulsion; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

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


ALTER TABLE opuscollege.studentexpulsion OWNER TO postgres;

--
-- TOC entry 451 (class 1259 OID 127518)
-- Name: studentplacementseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentplacementseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentplacementseq OWNER TO postgres;

--
-- TOC entry 452 (class 1259 OID 127520)
-- Name: studentplacement; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentplacement (
    id integer DEFAULT nextval('studentplacementseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    description character varying
);


ALTER TABLE opuscollege.studentplacement OWNER TO postgres;

--
-- TOC entry 453 (class 1259 OID 127527)
-- Name: studentstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentstatusseq OWNER TO postgres;

--
-- TOC entry 454 (class 1259 OID 127529)
-- Name: studentstatus; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentstatus (
    id integer DEFAULT nextval('studentstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.studentstatus OWNER TO postgres;

--
-- TOC entry 455 (class 1259 OID 127539)
-- Name: studentstudentstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentstudentstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentstudentstatusseq OWNER TO postgres;

--
-- TOC entry 456 (class 1259 OID 127541)
-- Name: studentstudentstatus; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentstudentstatus (
    id integer DEFAULT nextval('studentstudentstatusseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    startdate date,
    studentstatuscode character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.studentstudentstatus OWNER TO postgres;

--
-- TOC entry 457 (class 1259 OID 127550)
-- Name: studyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyseq OWNER TO postgres;

--
-- TOC entry 458 (class 1259 OID 127552)
-- Name: study; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE study (
    id integer DEFAULT nextval('studyseq'::regclass) NOT NULL,
    studydescription character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    organizationalunitid integer NOT NULL,
    academicfieldcode character varying NOT NULL,
    dateofestablishment date,
    startdate date,
    registrationdate date DEFAULT now() NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    minimummarksubject character varying,
    maximummarksubject character varying,
    brspassingsubject character varying
);


ALTER TABLE opuscollege.study OWNER TO postgres;

--
-- TOC entry 459 (class 1259 OID 127563)
-- Name: studyformseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyformseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyformseq OWNER TO postgres;

--
-- TOC entry 460 (class 1259 OID 127565)
-- Name: studyform; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studyform (
    id integer DEFAULT nextval('studyformseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.studyform OWNER TO postgres;

--
-- TOC entry 461 (class 1259 OID 127575)
-- Name: studygradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studygradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studygradetypeseq OWNER TO postgres;

--
-- TOC entry 462 (class 1259 OID 127577)
-- Name: studygradetype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studygradetype (
    id integer DEFAULT nextval('studygradetypeseq'::regclass) NOT NULL,
    studyid integer NOT NULL,
    gradetypecode character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
    registrationdate date DEFAULT now() NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    currentacademicyearid integer DEFAULT 0 NOT NULL,
    cardinaltimeunitcode character varying DEFAULT ''::character varying NOT NULL,
    numberofcardinaltimeunits integer DEFAULT 0 NOT NULL,
    maxnumberofcardinaltimeunits integer DEFAULT 0 NOT NULL,
    numberofsubjectspercardinaltimeunit integer DEFAULT 0 NOT NULL,
    maxnumberofsubjectspercardinaltimeunit integer DEFAULT 0 NOT NULL,
    studytimecode character varying,
    brspassingsubject character varying,
    studyformcode character varying,
    maxnumberoffailedsubjectspercardinaltimeunit integer DEFAULT 0 NOT NULL,
    studyintensitycode character varying DEFAULT ''::character varying NOT NULL,
    maxnumberofstudents integer DEFAULT 0,
    disciplinegroupcode character varying
);


ALTER TABLE opuscollege.studygradetype OWNER TO postgres;

--
-- TOC entry 463 (class 1259 OID 127598)
-- Name: studygradetypeprerequisite; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studygradetypeprerequisite (
    studygradetypeid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    requiredstudyid integer,
    requiredgradetypecode character varying
);


ALTER TABLE opuscollege.studygradetypeprerequisite OWNER TO postgres;

--
-- TOC entry 464 (class 1259 OID 127607)
-- Name: studyintensityseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyintensityseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyintensityseq OWNER TO postgres;

--
-- TOC entry 465 (class 1259 OID 127609)
-- Name: studyintensity; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studyintensity (
    id integer DEFAULT nextval('studyintensityseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.studyintensity OWNER TO postgres;

--
-- TOC entry 466 (class 1259 OID 127619)
-- Name: studyplanseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyplanseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyplanseq OWNER TO postgres;

--
-- TOC entry 467 (class 1259 OID 127621)
-- Name: studyplan; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studyplan (
    id integer DEFAULT nextval('studyplanseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    studyplandescription character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    brspassingexam character varying,
    studyplanstatuscode character varying,
    studyid integer DEFAULT 0 NOT NULL,
    gradetypecode character varying,
    minor1id integer DEFAULT 0 NOT NULL,
    major2id integer DEFAULT 0 NOT NULL,
    minor2id integer DEFAULT 0 NOT NULL,
    applicationnumber integer DEFAULT 0 NOT NULL,
    applicantcategorycode character varying,
    firstchoiceonwardstudyid integer DEFAULT 0,
    firstchoiceonwardgradetypecode character varying,
    secondchoiceonwardstudyid integer DEFAULT 0,
    secondchoiceonwardgradetypecode character varying,
    thirdchoiceonwardstudyid integer DEFAULT 0,
    thirdchoiceonwardgradetypecode character varying,
    previousdisciplinecode character varying,
    previousdisciplinegrade character varying
);


ALTER TABLE opuscollege.studyplan OWNER TO postgres;

--
-- TOC entry 468 (class 1259 OID 127639)
-- Name: studyplancardinaltimeunitseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyplancardinaltimeunitseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyplancardinaltimeunitseq OWNER TO postgres;

--
-- TOC entry 469 (class 1259 OID 127641)
-- Name: studyplancardinaltimeunit; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studyplancardinaltimeunit (
    id integer DEFAULT nextval('studyplancardinaltimeunitseq'::regclass) NOT NULL,
    studyplanid integer NOT NULL,
    cardinaltimeunitnumber integer DEFAULT 0 NOT NULL,
    progressstatuscode character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    studygradetypeid integer DEFAULT 0 NOT NULL,
    cardinaltimeunitstatuscode character varying,
    tuitionwaiver character(1) DEFAULT 'N'::bpchar NOT NULL,
    studyintensitycode character varying
);


ALTER TABLE opuscollege.studyplancardinaltimeunit OWNER TO postgres;

--
-- TOC entry 470 (class 1259 OID 127654)
-- Name: studyplandetailseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyplandetailseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyplandetailseq OWNER TO postgres;

--
-- TOC entry 471 (class 1259 OID 127656)
-- Name: studyplandetail; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studyplandetail (
    id integer DEFAULT nextval('studyplandetailseq'::regclass) NOT NULL,
    studyplanid integer NOT NULL,
    subjectid integer DEFAULT 0 NOT NULL,
    subjectblockid integer DEFAULT 0 NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    studyplancardinaltimeunitid integer DEFAULT 0 NOT NULL,
    studygradetypeid integer DEFAULT 0 NOT NULL
);


ALTER TABLE opuscollege.studyplandetail OWNER TO postgres;

--
-- TOC entry 472 (class 1259 OID 127670)
-- Name: studyplanresult; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

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


ALTER TABLE opuscollege.studyplanresult OWNER TO postgres;

--
-- TOC entry 473 (class 1259 OID 127682)
-- Name: studyplanstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyplanstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyplanstatusseq OWNER TO postgres;

--
-- TOC entry 474 (class 1259 OID 127684)
-- Name: studyplanstatus; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studyplanstatus (
    id integer DEFAULT nextval('studyplanstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.studyplanstatus OWNER TO postgres;

--
-- TOC entry 475 (class 1259 OID 127694)
-- Name: studytimeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studytimeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studytimeseq OWNER TO postgres;

--
-- TOC entry 476 (class 1259 OID 127696)
-- Name: studytime; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studytime (
    id integer DEFAULT nextval('studytimeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.studytime OWNER TO postgres;

--
-- TOC entry 477 (class 1259 OID 127706)
-- Name: studytypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studytypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.studytypeseq OWNER TO postgres;

--
-- TOC entry 478 (class 1259 OID 127708)
-- Name: studytype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studytype (
    id integer DEFAULT nextval('studytypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.studytype OWNER TO postgres;

--
-- TOC entry 479 (class 1259 OID 127718)
-- Name: subjectseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectseq OWNER TO postgres;

--
-- TOC entry 480 (class 1259 OID 127720)
-- Name: subject; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subject (
    id integer DEFAULT nextval('subjectseq'::regclass) NOT NULL,
    subjectcode character varying NOT NULL,
    subjectdescription character varying,
    subjectcontentdescription character varying,
    primarystudyid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    targetgroupcode character varying,
    freechoiceoption character(1) DEFAULT 'N'::bpchar,
    creditamount numeric(4,1),
    hourstoinvest integer DEFAULT 0 NOT NULL,
    frequencycode character varying,
    studytimecode character varying,
    examtypecode character varying,
    maximumparticipants integer NOT NULL,
    brspassingsubject character varying,
    registrationdate date DEFAULT now() NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    currentacademicyearid integer DEFAULT 0 NOT NULL,
    resulttype character varying
);


ALTER TABLE opuscollege.subject OWNER TO postgres;

--
-- TOC entry 481 (class 1259 OID 127734)
-- Name: subjectblockseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectblockseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectblockseq OWNER TO postgres;

--
-- TOC entry 482 (class 1259 OID 127736)
-- Name: subjectblock; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectblock (
    id integer DEFAULT nextval('subjectblockseq'::regclass) NOT NULL,
    subjectblockcode character varying NOT NULL,
    subjectblockdescription character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    targetgroupcode character varying,
    brsapplyingtosubjectblock character varying,
    registrationdate date DEFAULT now() NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    brspassingsubjectblock character varying,
    currentacademicyearid integer DEFAULT 0 NOT NULL,
    brsmaxcontacthours character varying,
    studytimecode character varying,
    blocktypecode character varying,
    primarystudyid integer DEFAULT 0 NOT NULL,
    freechoiceoption character(1) DEFAULT 'N'::bpchar
);


ALTER TABLE opuscollege.subjectblock OWNER TO postgres;

--
-- TOC entry 483 (class 1259 OID 127750)
-- Name: subjectblockprerequisite; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectblockprerequisite (
    subjectblockstudygradetypeid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    requiredsubjectblockcode character varying
);


ALTER TABLE opuscollege.subjectblockprerequisite OWNER TO postgres;

--
-- TOC entry 484 (class 1259 OID 127759)
-- Name: subjectblockstudygradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectblockstudygradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectblockstudygradetypeseq OWNER TO postgres;

--
-- TOC entry 485 (class 1259 OID 127761)
-- Name: subjectblockstudygradetype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectblockstudygradetype (
    id integer DEFAULT nextval('subjectblockstudygradetypeseq'::regclass) NOT NULL,
    subjectblockid integer NOT NULL,
    studygradetypeid integer,
    cardinaltimeunitnumber integer DEFAULT 0 NOT NULL,
    rigiditytypecode character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    importancetypecode character varying
);


ALTER TABLE opuscollege.subjectblockstudygradetype OWNER TO postgres;

--
-- TOC entry 486 (class 1259 OID 127772)
-- Name: subjectclassgroupseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectclassgroupseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectclassgroupseq OWNER TO postgres;

--
-- TOC entry 487 (class 1259 OID 127774)
-- Name: subjectclassgroup; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectclassgroup (
    id integer DEFAULT nextval('subjectclassgroupseq'::regclass) NOT NULL,
    subjectid integer NOT NULL,
    classgroupid integer NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.subjectclassgroup OWNER TO postgres;

--
-- TOC entry 488 (class 1259 OID 127783)
-- Name: subjectprerequisite; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectprerequisite (
    subjectstudygradetypeid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    requiredsubjectcode character varying
);


ALTER TABLE opuscollege.subjectprerequisite OWNER TO postgres;

--
-- TOC entry 489 (class 1259 OID 127792)
-- Name: subjectresultseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectresultseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectresultseq OWNER TO postgres;

--
-- TOC entry 490 (class 1259 OID 127794)
-- Name: subjectresult; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectresult (
    id integer DEFAULT nextval('subjectresultseq'::regclass) NOT NULL,
    subjectid integer NOT NULL,
    studyplandetailid integer NOT NULL,
    subjectresultdate date,
    mark character varying,
    staffmemberid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    passed character(1) DEFAULT 'N'::bpchar NOT NULL,
    endgradecomment character varying
);


ALTER TABLE opuscollege.subjectresult OWNER TO postgres;

--
-- TOC entry 491 (class 1259 OID 127805)
-- Name: subjectstudygradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectstudygradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectstudygradetypeseq OWNER TO postgres;

--
-- TOC entry 492 (class 1259 OID 127807)
-- Name: subjectstudygradetype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectstudygradetype (
    id integer DEFAULT nextval('subjectstudygradetypeseq'::regclass) NOT NULL,
    subjectid integer NOT NULL,
    studygradetypeid integer,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    cardinaltimeunitnumber integer DEFAULT 0 NOT NULL,
    rigiditytypecode character varying,
    importancetypecode character varying
);


ALTER TABLE opuscollege.subjectstudygradetype OWNER TO postgres;

--
-- TOC entry 493 (class 1259 OID 127818)
-- Name: subjectstudytypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectstudytypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectstudytypeseq OWNER TO postgres;

--
-- TOC entry 494 (class 1259 OID 127820)
-- Name: subjectstudytype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectstudytype (
    id integer DEFAULT nextval('subjectstudytypeseq'::regclass) NOT NULL,
    subjectid integer NOT NULL,
    studytypecode character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.subjectstudytype OWNER TO postgres;

--
-- TOC entry 495 (class 1259 OID 127830)
-- Name: subjectsubjectblockseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectsubjectblockseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectsubjectblockseq OWNER TO postgres;

--
-- TOC entry 496 (class 1259 OID 127832)
-- Name: subjectsubjectblock; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectsubjectblock (
    id integer DEFAULT nextval('subjectsubjectblockseq'::regclass) NOT NULL,
    subjectid integer NOT NULL,
    subjectblockid integer,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.subjectsubjectblock OWNER TO postgres;

--
-- TOC entry 497 (class 1259 OID 127842)
-- Name: subjectteacherseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectteacherseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectteacherseq OWNER TO postgres;

--
-- TOC entry 498 (class 1259 OID 127844)
-- Name: subjectteacher; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectteacher (
    id integer DEFAULT nextval('subjectteacherseq'::regclass) NOT NULL,
    staffmemberid integer NOT NULL,
    subjectid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    classgroupid integer
);


ALTER TABLE opuscollege.subjectteacher OWNER TO postgres;

--
-- TOC entry 499 (class 1259 OID 127854)
-- Name: tabledependencyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE tabledependencyseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.tabledependencyseq OWNER TO postgres;

--
-- TOC entry 500 (class 1259 OID 127856)
-- Name: tabledependency; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE tabledependency (
    id integer DEFAULT nextval('tabledependencyseq'::regclass) NOT NULL,
    lookuptableid integer NOT NULL,
    dependenttable character varying NOT NULL,
    dependenttablecolumn character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.tabledependency OWNER TO postgres;

--
-- TOC entry 501 (class 1259 OID 127866)
-- Name: targetgroupseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE targetgroupseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.targetgroupseq OWNER TO postgres;

--
-- TOC entry 502 (class 1259 OID 127868)
-- Name: targetgroup; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE targetgroup (
    id integer DEFAULT nextval('targetgroupseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.targetgroup OWNER TO postgres;

--
-- TOC entry 503 (class 1259 OID 127878)
-- Name: testseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE testseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.testseq OWNER TO postgres;

--
-- TOC entry 504 (class 1259 OID 127880)
-- Name: test; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE test (
    id integer DEFAULT nextval('testseq'::regclass) NOT NULL,
    testcode character varying NOT NULL,
    testdescription character varying,
    examinationid integer NOT NULL,
    examinationtypecode character varying NOT NULL,
    numberofattempts integer NOT NULL,
    weighingfactor integer NOT NULL,
    minimummark character varying,
    maximummark character varying,
    brspassingtest character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.test OWNER TO postgres;

--
-- TOC entry 505 (class 1259 OID 127890)
-- Name: testresultseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE testresultseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.testresultseq OWNER TO postgres;

--
-- TOC entry 506 (class 1259 OID 127892)
-- Name: testresult; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE testresult (
    id integer DEFAULT nextval('testresultseq'::regclass) NOT NULL,
    testid integer NOT NULL,
    examinationid integer NOT NULL,
    studyplandetailid integer NOT NULL,
    testresultdate date,
    attemptnr integer NOT NULL,
    mark character varying,
    passed character(1) DEFAULT 'N'::bpchar NOT NULL,
    staffmemberid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    examinationresultid integer DEFAULT 0 NOT NULL
);


ALTER TABLE opuscollege.testresult OWNER TO postgres;

--
-- TOC entry 507 (class 1259 OID 127904)
-- Name: testteacherseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE testteacherseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.testteacherseq OWNER TO postgres;

--
-- TOC entry 508 (class 1259 OID 127906)
-- Name: testteacher; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE testteacher (
    id integer DEFAULT nextval('testteacherseq'::regclass) NOT NULL,
    staffmemberid integer NOT NULL,
    testid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    classgroupid integer
);


ALTER TABLE opuscollege.testteacher OWNER TO postgres;

--
-- TOC entry 509 (class 1259 OID 127916)
-- Name: thesisseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE thesisseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.thesisseq OWNER TO postgres;

--
-- TOC entry 510 (class 1259 OID 127918)
-- Name: thesis; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE thesis (
    id integer DEFAULT nextval('thesisseq'::regclass) NOT NULL,
    thesiscode character varying NOT NULL,
    thesisdescription character varying,
    thesiscontentdescription character varying,
    studyplanid integer NOT NULL,
    creditamount integer NOT NULL,
    hourstoinvest integer DEFAULT 0 NOT NULL,
    brsapplyingtothesis character varying,
    brspassingthesis character varying,
    keywords character varying,
    researchers character varying,
    supervisors character varying,
    publications character varying,
    readingcommittee character varying,
    defensecommittee character varying,
    statusofclearness character varying,
    thesisstatusdate date DEFAULT now() NOT NULL,
    startacademicyearid integer,
    affiliationfee numeric(10,2) DEFAULT 0.00 NOT NULL,
    research character varying,
    nonrelatedpublications character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.thesis OWNER TO postgres;

--
-- TOC entry 511 (class 1259 OID 127931)
-- Name: thesisresultseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE thesisresultseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.thesisresultseq OWNER TO postgres;

--
-- TOC entry 512 (class 1259 OID 127933)
-- Name: thesisresult; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

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


ALTER TABLE opuscollege.thesisresult OWNER TO postgres;

--
-- TOC entry 513 (class 1259 OID 127946)
-- Name: thesisstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE thesisstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.thesisstatusseq OWNER TO postgres;

--
-- TOC entry 514 (class 1259 OID 127948)
-- Name: thesisstatus; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE thesisstatus (
    id integer DEFAULT nextval('thesisstatusseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.thesisstatus OWNER TO postgres;

--
-- TOC entry 515 (class 1259 OID 127958)
-- Name: thesissupervisorseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE thesissupervisorseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.thesissupervisorseq OWNER TO postgres;

--
-- TOC entry 516 (class 1259 OID 127960)
-- Name: thesissupervisor; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE thesissupervisor (
    id integer DEFAULT nextval('thesissupervisorseq'::regclass) NOT NULL,
    thesisid integer NOT NULL,
    name character varying,
    address character varying,
    telephone character varying,
    email character varying,
    principal character(1) DEFAULT 'N'::bpchar NOT NULL,
    orderby integer,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.thesissupervisor OWNER TO postgres;

--
-- TOC entry 517 (class 1259 OID 127971)
-- Name: thesisthesisstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE thesisthesisstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.thesisthesisstatusseq OWNER TO postgres;

--
-- TOC entry 518 (class 1259 OID 127973)
-- Name: thesisthesisstatus; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE thesisthesisstatus (
    id integer DEFAULT nextval('thesisthesisstatusseq'::regclass) NOT NULL,
    thesisid integer NOT NULL,
    startdate date,
    thesisstatuscode character varying,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.thesisthesisstatus OWNER TO postgres;

--
-- TOC entry 519 (class 1259 OID 127983)
-- Name: timeunitseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE timeunitseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.timeunitseq OWNER TO postgres;

--
-- TOC entry 520 (class 1259 OID 127985)
-- Name: unitareaseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE unitareaseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.unitareaseq OWNER TO postgres;

--
-- TOC entry 521 (class 1259 OID 127987)
-- Name: unitarea; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE unitarea (
    id integer DEFAULT nextval('unitareaseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.unitarea OWNER TO postgres;

--
-- TOC entry 522 (class 1259 OID 127997)
-- Name: unittypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE unittypeseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE opuscollege.unittypeseq OWNER TO postgres;

--
-- TOC entry 523 (class 1259 OID 127999)
-- Name: unittype; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE unittype (
    id integer DEFAULT nextval('unittypeseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.unittype OWNER TO postgres;

--
-- TOC entry 3200 (class 2604 OID 128009)
-- Name: id; Type: DEFAULT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY node_relationships_n_level ALTER COLUMN id SET DEFAULT nextval('organizationalunitseq'::regclass);


--
-- TOC entry 3201 (class 2604 OID 128010)
-- Name: active; Type: DEFAULT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY node_relationships_n_level ALTER COLUMN active SET DEFAULT 'Y'::bpchar;


--
-- TOC entry 3202 (class 2604 OID 128011)
-- Name: unitlevel; Type: DEFAULT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY node_relationships_n_level ALTER COLUMN unitlevel SET DEFAULT 0;


--
-- TOC entry 3203 (class 2604 OID 128012)
-- Name: parentorganizationalunitid; Type: DEFAULT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY node_relationships_n_level ALTER COLUMN parentorganizationalunitid SET DEFAULT 0;


--
-- TOC entry 3204 (class 2604 OID 128013)
-- Name: registrationdate; Type: DEFAULT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY node_relationships_n_level ALTER COLUMN registrationdate SET DEFAULT now();


--
-- TOC entry 3205 (class 2604 OID 128014)
-- Name: writewho; Type: DEFAULT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY node_relationships_n_level ALTER COLUMN writewho SET DEFAULT 'opuscollege'::character varying;


--
-- TOC entry 3206 (class 2604 OID 128015)
-- Name: writewhen; Type: DEFAULT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY node_relationships_n_level ALTER COLUMN writewhen SET DEFAULT now();


SET search_path = audit, pg_catalog;

--
-- TOC entry 4696 (class 0 OID 125674)
-- Dependencies: 173
-- Data for Name: acc_accommodationfee_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY acc_accommodationfee_hist (operation, accommodationfeeid, hosteltypecode, roomtypecode, feeid, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4697 (class 0 OID 125682)
-- Dependencies: 174
-- Data for Name: acc_block_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY acc_block_hist (operation, id, code, description, hostelid, numberoffloors, writewho, writewhen, active) FROM stdin;
\.


--
-- TOC entry 4698 (class 0 OID 125690)
-- Dependencies: 175
-- Data for Name: acc_hostel_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY acc_hostel_hist (operation, id, code, description, numberoffloors, hosteltypecode, writewho, writewhen, active) FROM stdin;
\.


--
-- TOC entry 4699 (class 0 OID 125698)
-- Dependencies: 176
-- Data for Name: acc_room_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY acc_room_hist (operation, id, code, description, numberofbedspaces, hostelid, blockid, floornumber, writewho, writewhen, active, availablebedspace, roomtypecode) FROM stdin;
\.


--
-- TOC entry 4700 (class 0 OID 125706)
-- Dependencies: 177
-- Data for Name: acc_studentaccommodation_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY acc_studentaccommodation_hist (operation, id, studentid, bednumber, academicyearid, dateapplied, dateapproved, approved, approvedbyid, accepted, dateaccepted, reasonforapplyingforaccommodation, comment, roomid, writewho, writewhen, allocated, datedeallocated) FROM stdin;
\.


--
-- TOC entry 4701 (class 0 OID 125714)
-- Dependencies: 178
-- Data for Name: cardinaltimeunitresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY cardinaltimeunitresult_hist (operation, writewho, writewhen, id, studyplanid, studyplancardinaltimeunitid, cardinaltimeunitresultdate, active, passed, mark, endgradecomment) FROM stdin;
\.


--
-- TOC entry 4702 (class 0 OID 125726)
-- Dependencies: 179
-- Data for Name: endgrade_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY endgrade_hist (operation, id, code, lang, active, endgradetypecode, gradepoint, percentagemin, percentagemax, comment, description, temporarygrade, writewho, writewhen, passed, academicyearid) FROM stdin;
\.


--
-- TOC entry 4703 (class 0 OID 125734)
-- Dependencies: 180
-- Data for Name: examinationresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY examinationresult_hist (operation, writewho, writewhen, id, examinationid, subjectid, studyplandetailid, examinationresultdate, attemptnr, mark, staffmemberid, active, passed, subjectresultid) FROM stdin;
\.


--
-- TOC entry 4704 (class 0 OID 125743)
-- Dependencies: 181
-- Data for Name: fee_fee_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY fee_fee_hist (operation, writewho, writewhen, id, feedue, deadline, categorycode, subjectblockstudygradetypeid, subjectstudygradetypeid, studygradetypeid, academicyearid, numberofinstallments, tuitionwaiverdiscountpercentage, fulltimestudentdiscountpercentage, localstudentdiscountpercentage, continuedregistrationdiscountpercentage, postgraduatediscountpercentage, active, accommodationfeeid, branchid) FROM stdin;
\.


--
-- TOC entry 4705 (class 0 OID 125766)
-- Dependencies: 182
-- Data for Name: fee_payment_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY fee_payment_hist (operation, writewho, writewhen, id, paydate, studentid, feeid, studentbalanceid, installmentnumber, sumpaid, active) FROM stdin;
\.


--
-- TOC entry 4706 (class 0 OID 125780)
-- Dependencies: 183
-- Data for Name: financialrequest_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY financialrequest_hist (operation, writewho, id, requestid, requesttypeid, financialrequestid, statuscode, timestampreceived, requestversion, requeststring, timestampmodified, errorcode, processedtofinancetransaction, errorreportedtofinancialsystem, writewhen) FROM stdin;
\.


--
-- TOC entry 4707 (class 0 OID 125791)
-- Dependencies: 184
-- Data for Name: financialtransaction_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY financialtransaction_hist (operation, writewho, id, transactiontypeid, financialrequestid, requestid, statuscode, errorcode, nationalregistrationnumber, academicyearid, timestampprocessed, amount, name, cell, requeststring, processedtostudentbalance, errorreportedtofinancialbankrequest, writewhen, studentcode) FROM stdin;
\.


--
-- TOC entry 4708 (class 0 OID 125801)
-- Dependencies: 185
-- Data for Name: gradedsecondaryschoolsubject_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY gradedsecondaryschoolsubject_hist (operation, id, secondaryschoolsubjectid, studyplanid, grade, active, writewho, writewhen, secondaryschoolsubjectgroupid, level) FROM stdin;
\.


--
-- TOC entry 4709 (class 0 OID 125810)
-- Dependencies: 186
-- Data for Name: opususerprivilege_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY opususerprivilege_hist (operation, id, userid, privilegecode, organizationalunitid, validfrom, validthrough, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4710 (class 0 OID 125818)
-- Dependencies: 187
-- Data for Name: staffmember_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY staffmember_hist (operation, staffmemberid, staffmembercode, personid, dateofappointment, appointmenttypecode, stafftypecode, primaryunitofappointmentid, educationtypecode, writewho, writewhen, startworkday, endworkday, teachingdaypartcode, supervisingdaypartcode, id, personcode, active, surnamefull, surnamealias, firstnamesfull, firstnamesalias, nationalregistrationnumber, civiltitlecode, gradetypecode, gendercode, birthdate, nationalitycode, placeofbirth, districtofbirthcode, provinceofbirthcode, countryofbirthcode, cityoforigin, administrativepostoforigincode, districtoforigincode, provinceoforigincode, countryoforigincode, civilstatuscode, housingoncampus, identificationtypecode, identificationnumber, identificationplaceofissue, identificationdateofissue, identificationdateofexpiration, professioncode, professiondescription, languagefirstcode, languagefirstmasteringlevelcode, languagesecondcode, languagesecondmasteringlevelcode, languagethirdcode, languagethirdmasteringlevelcode, contactpersonemergenciesname, contactpersonemergenciestelephonenumber, bloodtypecode, healthissues, photograph, remarks, registrationdate, photographname, photographmimetype, publichomepage, socialnetworks, hobbies, motivation) FROM stdin;
U	72	STA022022011112253	183	\N	1	1	94	3	admin:226	2014-03-05 16:29:54.048	\N	\N	\N	\N	183	P0987	Y	Registrar	\N	V.C.		234243234	1	PHD	1	1960-09-23	130	Ndola	0	ZM-02	894	Lusaka	\N	0	ZM-05	894	1	N	3	12430802834	Lusaka	2010-10-20	2020-10-20	\N	Professor	eng	1	cha	1	dut	2	Mother	034554235235	3		\N	The photo didn't upload	2014-03-05	\N	\N	Y	Facebook and twitter	Reading\r\nMovies	\N
U	72	STA022022011112253	183	\N	1	1	94	3	registry:174	2014-03-07 11:09:43.048	\N	\N	\N	\N	183	P0987	Y	Registrar<script>alert("Hmm");</script>	\N	V.C.		234243234	1	PHD	1	1960-09-23	130	Ndola	0	ZM-02	894	Lusaka	\N	0	ZM-05	894	1	N	3	12430802834	Lusaka	2010-10-20	2020-10-20	\N	Professor	eng	1	cha	1	dut	2	Mother	034554235235	3		\N	The photo didn't upload	2014-03-07	\N	\N	Y	Facebook and twitter	Reading\r\nMovies	\N
U	72	STA022022011112253	183	\N	1	1	94	3	registry:174	2014-03-07 11:24:10.256	\N	\N	\N	\N	183	P0987	Y	Registrar<script>alert("Hmm");</script>	\N	V.C.  <script>alert("WELKOM")</script>		234243234	1	PHD	1	1960-09-23	130	Ndola	0	ZM-02	894	Lusaka	\N	0	ZM-05	894	1	N	3	12430802834	Lusaka	2010-10-20	2020-10-20	\N	Professor	eng	1	cha	1	dut	2	Mother	034554235235	3		\N	The photo didn't upload	2014-03-07	\N	\N	Y	Facebook and twitter	Reading\r\nMovies	\N
U	72	STA022022011112253	183	\N	1	1	94	3	registry:174	2014-03-07 11:27:46.254	\N	\N	\N	\N	183	P0987	Y	Registrar<script>alert("Hmm");</script>	\N	V.C           . <script>alert("WELKOM")</script>		234243234	1	PHD	1	1960-09-23	130	Ndola	0	ZM-02	894	Lusaka	\N	0	ZM-05	894	1	N	3	12430802834	Lusaka	2010-10-20	2020-10-20	\N	Professor	eng	1	cha	1	dut	2	Mother	034554235235	3		\N	The photo didn't upload	2014-03-07	\N	\N	Y	Facebook and twitter	Reading\r\nMovies	\N
U	72	STA022022011112253	183	\N	1	1	94	3	registry:174	2014-03-07 11:27:54.546	\N	\N	\N	\N	183	P0987	Y	Registrar<script>alert("Hmm");</script>	\N	V.C . <script>alert("WELKOM")</scr		234243234	1	PHD	1	1960-09-23	130	Ndola	0	ZM-02	894	Lusaka	\N	0	ZM-05	894	1	N	3	12430802834	Lusaka	2010-10-20	2020-10-20	\N	Professor	eng	1	cha	1	dut	2	Mother	034554235235	3		\N	The photo didn't upload	2014-03-07	\N	\N	Y	Facebook and twitter	Reading\r\nMovies	\N
U	72	STA022022011112253	183	\N	1	1	94	3	registry:174	2014-03-07 11:29:15.075	\N	\N	\N	\N	183	P0987	Y	Registrar<script>alert("Hmm");</script>	\N	V.C.		234243234	1	PHD	1	1960-09-23	130	Ndola	0	ZM-02	894	Lusaka	\N	0	ZM-05	894	1	N	3	12430802834	Lusaka	2010-10-20	2020-10-20	\N	Professor	eng	1	cha	1	dut	2	Mother	034554235235	3		\N	The photo didn't upload	2014-03-07	\N	\N	Y	Facebook and twitter	Reading\r\nMovies	\N
U	72	STA022022011112253<script>alert("Hmm");</script>	183	\N	1	1	94	3	registry:174	2014-03-07 12:05:47.736	\N	\N	\N	\N	183	P0987	Y	Registrar	\N	V.C.		234243234	1	PHD	1	1960-09-23	130	Ndola	0	ZM-02	894	Lusaka	\N	0	ZM-05	894	1	N	3	12430802834	Lusaka	2010-10-20	2020-10-20	\N	Professor	eng	1	cha	1	dut	2	Mother	034554235235	3		\N	The photo didn't upload	2014-03-07	\N	\N	Y	Facebook and twitter	Reading\r\nMovies	\N
\.


--
-- TOC entry 4711 (class 0 OID 125832)
-- Dependencies: 188
-- Data for Name: student_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY student_hist (operation, studentid, studentcode, personid, dateofenrolment, primarystudyid, expellationdate, reasonforexpellation, previousinstitutionid, previousinstitutionname, previousinstitutiondistrictcode, previousinstitutionprovincecode, previousinstitutioncountrycode, previousinstitutioneducationtypecode, previousinstitutionfinalgradetypecode, previousinstitutionfinalmark, previousinstitutiondiplomaphotograph, scholarship, fatherfullname, fathereducationcode, fatherprofessioncode, fatherprofessiondescription, motherfullname, mothereducationcode, motherprofessioncode, motherprofessiondescription, financialguardianfullname, financialguardianrelation, financialguardianprofession, writewho, writewhen, expellationenddate, expellationtypecode, previousinstitutiondiplomaphotographremarks, previousinstitutiondiplomaphotographname, previousinstitutiondiplomaphotographmimetype, subscriptionrequirementsfulfilled, secondarystudyid, foreignstudent, nationalitygroupcode, fathertelephone, mothertelephone, relativeofstaffmember, ruralareaorigin, id, personcode, active, surnamefull, surnamealias, firstnamesfull, firstnamesalias, nationalregistrationnumber, civiltitlecode, gradetypecode, gendercode, birthdate, nationalitycode, placeofbirth, districtofbirthcode, provinceofbirthcode, countryofbirthcode, cityoforigin, administrativepostoforigincode, districtoforigincode, provinceoforigincode, countryoforigincode, civilstatuscode, housingoncampus, identificationtypecode, identificationnumber, identificationplaceofissue, identificationdateofissue, identificationdateofexpiration, professioncode, professiondescription, languagefirstcode, languagefirstmasteringlevelcode, languagesecondcode, languagesecondmasteringlevelcode, languagethirdcode, languagethirdmasteringlevelcode, contactpersonemergenciesname, contactpersonemergenciestelephonenumber, bloodtypecode, healthissues, photograph, remarks, registrationdate, photographname, photographmimetype, publichomepage, socialnetworks, hobbies, motivation, employeenumberofrelative) FROM stdin;
\.


--
-- TOC entry 4712 (class 0 OID 125856)
-- Dependencies: 189
-- Data for Name: studentabsence_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY studentabsence_hist (operation, id, studentid, startdatetemporaryinactivity, enddatetemporaryinactivity, reasonforabsence, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4713 (class 0 OID 125863)
-- Dependencies: 190
-- Data for Name: studentbalance_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY studentbalance_hist (operation, writewho, writewhen, id, studentid, feeid, studyplancardinaltimeunitid, studyplandetailid, academicyearid, exemption, studentaccommodationid) FROM stdin;
\.


--
-- TOC entry 4714 (class 0 OID 125878)
-- Dependencies: 191
-- Data for Name: studentexpulsion_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY studentexpulsion_hist (operation, id, studentid, startdate, enddate, expulsiontypecode, reasonforexpulsion, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4715 (class 0 OID 125885)
-- Dependencies: 192
-- Data for Name: studyplanresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY studyplanresult_hist (operation, writewho, writewhen, id, studyplanid, examdate, finalmark, mark, active, passed) FROM stdin;
\.


--
-- TOC entry 4716 (class 0 OID 125893)
-- Dependencies: 193
-- Data for Name: subjectresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY subjectresult_hist (operation, writewho, writewhen, id, subjectid, studyplandetailid, subjectresultdate, mark, staffmemberid, active, passed, endgradecomment) FROM stdin;
\.


--
-- TOC entry 4717 (class 0 OID 125901)
-- Dependencies: 194
-- Data for Name: testresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY testresult_hist (operation, writewho, writewhen, id, testid, examinationid, studyplandetailid, testresultdate, attemptnr, mark, passed, staffmemberid, active, examinationresultid) FROM stdin;
\.


--
-- TOC entry 4718 (class 0 OID 125910)
-- Dependencies: 195
-- Data for Name: thesisresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY thesisresult_hist (operation, writewho, writewhen, id, studyplanid, thesisid, thesisresultdate, mark, active, passed) FROM stdin;
\.


SET search_path = opuscollege, pg_catalog;

--
-- TOC entry 4720 (class 0 OID 125920)
-- Dependencies: 197
-- Data for Name: academicfield; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY academicfield (id, code, lang, active, description, writewho, writewhen) FROM stdin;
342	4	en    	Y	Arts and Letters	opuscollege	2010-11-02 16:22:58.674788
344	6	en    	Y	Biochemistry	opuscollege	2010-11-02 16:22:58.674788
345	7	en    	Y	Bioethics	opuscollege	2010-11-02 16:22:58.674788
346	8	en    	Y	Biology	opuscollege	2010-11-02 16:22:58.674788
347	9	en    	Y	Biotechnology (incl. genetic modification)	opuscollege	2010-11-02 16:22:58.674788
348	10	en    	Y	Business Administration / Management Sciences	opuscollege	2010-11-02 16:22:58.674788
349	11	en    	Y	Chemistry	opuscollege	2010-11-02 16:22:58.674788
350	12	en    	Y	Climatology / Climate Sciences	opuscollege	2010-11-02 16:22:58.674788
351	13	en    	Y	Communication Sciences	opuscollege	2010-11-02 16:22:58.674788
352	14	en    	Y	Computer Science	opuscollege	2010-11-02 16:22:58.674788
353	15	en    	Y	Criminology	opuscollege	2010-11-02 16:22:58.674788
354	16	en    	Y	Demography (incl. Migration)	opuscollege	2010-11-02 16:22:58.674788
355	17	en    	Y	Dentistry	opuscollege	2010-11-02 16:22:58.674788
356	18	en    	Y	Development Studies	opuscollege	2010-11-02 16:22:58.674788
357	19	en    	Y	Earth Sciences - Soil	opuscollege	2010-11-02 16:22:58.674788
358	20	en    	Y	Earth Sciences - Water	opuscollege	2010-11-02 16:22:58.674788
359	21	en    	Y	Economy	opuscollege	2010-11-02 16:22:58.674788
360	22	en    	Y	Educational Sciences / Pedagogy	opuscollege	2010-11-02 16:22:58.674788
361	23	en    	Y	Engineering - Construction	opuscollege	2010-11-02 16:22:58.674788
362	24	en    	Y	Engineering - Electronic	opuscollege	2010-11-02 16:22:58.674788
363	25	en    	Y	Engineering - Industrial	opuscollege	2010-11-02 16:22:58.674788
364	26	en    	Y	Engineering - Mechanical	opuscollege	2010-11-02 16:22:58.674788
365	28	en    	Y	Environmental Studies	opuscollege	2010-11-02 16:22:58.674788
366	29	en    	Y	Ethics	opuscollege	2010-11-02 16:22:58.674788
367	30	en    	Y	Ethnography	opuscollege	2010-11-02 16:22:58.674788
368	31	en    	Y	Food Sciences / Food technology	opuscollege	2010-11-02 16:22:58.674788
369	32	en    	Y	Gender Studies	opuscollege	2010-11-02 16:22:58.674788
370	33	en    	Y	Geography	opuscollege	2010-11-02 16:22:58.674788
371	34	en    	Y	Geology	opuscollege	2010-11-02 16:22:58.674788
372	35	en    	Y	History	opuscollege	2010-11-02 16:22:58.674788
373	36	en    	Y	ICT - Information Systems	opuscollege	2010-11-02 16:22:58.674788
374	37	en    	Y	ICT - Software development	opuscollege	2010-11-02 16:22:58.674788
375	38	en    	Y	ICT - Computer Technology	opuscollege	2010-11-02 16:22:58.674788
376	39	en    	Y	ICT - Telecommunications Technology	opuscollege	2010-11-02 16:22:58.674788
377	40	en    	Y	Informatics	opuscollege	2010-11-02 16:22:58.674788
378	41	en    	Y	International studies	opuscollege	2010-11-02 16:22:58.674788
379	42	en    	Y	Journalism	opuscollege	2010-11-02 16:22:58.674788
380	43	en    	Y	Languages - Arabic	opuscollege	2010-11-02 16:22:58.674788
381	44	en    	Y	Languages - Chinese	opuscollege	2010-11-02 16:22:58.674788
382	45	en    	Y	Languages - English	opuscollege	2010-11-02 16:22:58.674788
383	46	en    	Y	Languages - French	opuscollege	2010-11-02 16:22:58.674788
384	47	en    	Y	Languages - German	opuscollege	2010-11-02 16:22:58.674788
385	48	en    	Y	Languages - Portuguese	opuscollege	2010-11-02 16:22:58.674788
386	49	en    	Y	Languages - Russian	opuscollege	2010-11-02 16:22:58.674788
387	50	en    	Y	Languages - Spanish	opuscollege	2010-11-02 16:22:58.674788
388	51	en    	Y	Law	opuscollege	2010-11-02 16:22:58.674788
389	52	en    	Y	Linguistics	opuscollege	2010-11-02 16:22:58.674788
390	53	en    	Y	Literature	opuscollege	2010-11-02 16:22:58.674788
391	54	en    	Y	Mathematics	opuscollege	2010-11-02 16:22:58.674788
392	55	en    	Y	Mechanics	opuscollege	2010-11-02 16:22:58.674788
393	56	en    	Y	Medicine - Anatomy	opuscollege	2010-11-02 16:22:58.674788
394	57	en    	Y	Medicine - Cardiology	opuscollege	2010-11-02 16:22:58.674788
395	58	en    	Y	Medicine - Ear, Nose, Throat	opuscollege	2010-11-02 16:22:58.674788
396	59	en    	Y	Medicine - Endocrinology	opuscollege	2010-11-02 16:22:58.674788
397	60	en    	Y	Medicine - General Practice (GP)	opuscollege	2010-11-02 16:22:58.674788
398	61	en    	Y	Medicine - Geriatrics	opuscollege	2010-11-02 16:22:58.674788
399	62	en    	Y	Medicine - Gynaecology	opuscollege	2010-11-02 16:22:58.674788
400	63	en    	Y	Medicine - Immunology	opuscollege	2010-11-02 16:22:58.674788
401	64	en    	Y	Medicine - Internal specialisms	opuscollege	2010-11-02 16:22:58.674788
402	65	en    	Y	Medicine - Locomotor Apparatus (motion diseases)	opuscollege	2010-11-02 16:22:58.674788
403	66	en    	Y	Medicine - Oncology	opuscollege	2010-11-02 16:22:58.674788
404	67	en    	Y	Medicine - Ophthalmology	opuscollege	2010-11-02 16:22:58.674788
405	68	en    	Y	Medicine - Paediatrics	opuscollege	2010-11-02 16:22:58.674788
407	70	en    	Y	Medicine - Tropical Medicine	opuscollege	2010-11-02 16:22:58.674788
408	71	en    	Y	Medicine - Urology	opuscollege	2010-11-02 16:22:58.674788
409	72	en    	Y	Microbiology	opuscollege	2010-11-02 16:22:58.674788
410	73	en    	Y	Nanotechnology	opuscollege	2010-11-02 16:22:58.674788
411	74	en    	Y	Nuclear Technology	opuscollege	2010-11-02 16:22:58.674788
412	75	en    	Y	Pharmacy	opuscollege	2010-11-02 16:22:58.674788
413	76	en    	Y	Philosophy	opuscollege	2010-11-02 16:22:58.674788
414	77	en    	Y	Physics	opuscollege	2010-11-02 16:22:58.674788
415	78	en    	Y	Political Sciences	opuscollege	2010-11-02 16:22:58.674788
416	79	en    	Y	Psychology	opuscollege	2010-11-02 16:22:58.674788
417	80	en    	Y	Religious Studies	opuscollege	2010-11-02 16:22:58.674788
418	81	en    	Y	Sciences (natural)	opuscollege	2010-11-02 16:22:58.674788
419	82	en    	Y	Social Sciences	opuscollege	2010-11-02 16:22:58.674788
420	83	en    	Y	Sociology	opuscollege	2010-11-02 16:22:58.674788
421	84	en    	Y	Theology	opuscollege	2010-11-02 16:22:58.674788
422	85	en    	Y	Medicine	opuscollege	2010-11-02 16:22:58.674788
423	86	en    	Y	Technology	opuscollege	2010-11-02 16:22:58.674788
343	5	en    	Y	Astronomy	opuscollege	2010-11-02 16:22:58.674788
339	1	en    	Y	Agronomy / Agricultural Sciences	opuscollege	2010-11-02 16:22:58.674788
341	3	en    	Y	Archeology	opuscollege	2010-11-02 16:22:58.674788
434	1311585114938	en    	Y	Medical Sciences - Psychiatry	opuscollege	2011-07-25 11:12:58.633501
435	1311585114938	en_ZM 	Y	Medical Sciences - Psychiatry ZM	opuscollege	2011-07-25 11:12:58.954911
340	2	en    	Y	Anthropology3	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 196
-- Name: academicfieldseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('academicfieldseq', 435, true);


--
-- TOC entry 4722 (class 0 OID 125932)
-- Dependencies: 199
-- Data for Name: academicyear; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY academicyear (id, description, active, writewho, writewhen, startdate, enddate, nextacademicyearid) FROM stdin;
19	2016	Y	opuscollege	2011-08-09 14:45:36.927083	2016-01-01	2016-12-31	0
15	2005	Y	opuscollege	2011-02-21 12:43:17.305094	2005-01-01	2005-12-31	8
8	2006	Y	opuscollege	2008-12-17 16:07:45.25569	2006-01-01	2006-12-31	9
9	2007	Y	opuscollege	2008-12-17 16:07:45.25569	2007-01-01	2007-12-31	10
10	2008	Y	opuscollege	2008-12-17 16:07:45.25569	2008-01-01	2008-12-31	11
11	2009	Y	opuscollege	2008-12-17 16:07:45.25569	2009-01-01	2009-12-31	12
12	2010	Y	opuscollege	2008-12-17 16:07:45.25569	2010-01-01	2010-12-31	13
13	2011	Y	opuscollege	2008-12-17 16:07:45.25569	2011-01-01	2011-12-31	14
16	2013	Y	opuscollege	2011-07-30 23:02:25.956305	2013-01-01	2013-12-31	17
17	2014	Y	opuscollege	2011-08-05 12:31:49.82907	2014-01-01	2014-12-31	18
18	2015	Y	opuscollege	2011-08-09 14:44:35.894879	2015-01-01	2015-12-31	19
14	2012	Y	opuscollege	2010-10-15 18:01:21.557191	2012-01-01	2012-12-31	16
20	2004	Y	opuscollege	2011-08-11 12:54:02.870318	2004-01-01	2004-12-31	15
\.


--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 198
-- Name: academicyearseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('academicyearseq', 20, true);


--
-- TOC entry 4724 (class 0 OID 125945)
-- Dependencies: 201
-- Data for Name: acc_accommodationfee; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_accommodationfee (accommodationfeeid, hosteltypecode, roomtypecode, feeid) FROM stdin;
\.


--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 202
-- Name: acc_accommodationfeepaymentseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_accommodationfeepaymentseq', 1, false);


--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 200
-- Name: acc_accommodationfeeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_accommodationfeeseq', 3, true);


--
-- TOC entry 4727 (class 0 OID 125956)
-- Dependencies: 204
-- Data for Name: acc_accommodationresource; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_accommodationresource (id, name, description, active, writewho, writewhen) FROM stdin;
1	Matress	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
2	Curtain Net	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
3	Curtain (Normal)	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
4	Key	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
5	Study Lamp	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
6	Wall Switch	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
7	Wall Socket	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
8	Mortice-Lock	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
9	Pad-Lock	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
10	Bed (Single - Bed)	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
11	Bed (3 - Quarters)	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
12	Bed (Double Bed)	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
13	Dinning Chair	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
14	Chair (Standard)	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
15	Key-Blocker	\N	Y	opuscollege-accommodation	2014-03-05 14:59:12.908
\.


--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 203
-- Name: acc_accommodationresourceseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_accommodationresourceseq', 15, true);


--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 205
-- Name: acc_accommodationselectioncriteriaseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_accommodationselectioncriteriaseq', 1, false);


--
-- TOC entry 4730 (class 0 OID 125970)
-- Dependencies: 207
-- Data for Name: acc_block; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_block (id, code, description, hostelid, numberoffloors, writewho, writewhen, active) FROM stdin;
\.


--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 206
-- Name: acc_blockseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_blockseq', 4, true);


--
-- TOC entry 4732 (class 0 OID 125982)
-- Dependencies: 209
-- Data for Name: acc_hostel; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_hostel (id, code, description, numberoffloors, hosteltypecode, writewho, writewhen, active) FROM stdin;
\.


--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 208
-- Name: acc_hostelseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_hostelseq', 3, true);


--
-- TOC entry 4734 (class 0 OID 125997)
-- Dependencies: 211
-- Data for Name: acc_hosteltype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_hosteltype (id, code, description, lang, writewho, writewhen, active) FROM stdin;
\.


--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 210
-- Name: acc_hosteltypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_hosteltypeseq', 3, true);


--
-- TOC entry 4736 (class 0 OID 126010)
-- Dependencies: 213
-- Data for Name: acc_room; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_room (id, code, description, numberofbedspaces, hostelid, blockid, floornumber, writewho, writewhen, active, availablebedspace, roomtypecode) FROM stdin;
\.


--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 212
-- Name: acc_roomseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_roomseq', 1, true);


--
-- TOC entry 4738 (class 0 OID 126026)
-- Dependencies: 215
-- Data for Name: acc_roomtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_roomtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 214
-- Name: acc_roomtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_roomtypeseq', 1, true);


--
-- TOC entry 4740 (class 0 OID 126038)
-- Dependencies: 217
-- Data for Name: acc_studentaccommodation; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_studentaccommodation (id, studentid, bednumber, academicyearid, dateapplied, dateapproved, approved, approvedbyid, accepted, dateaccepted, reasonforapplyingforaccommodation, comment, roomid, writewho, writewhen, allocated, datedeallocated) FROM stdin;
\.


--
-- TOC entry 4742 (class 0 OID 126056)
-- Dependencies: 219
-- Data for Name: acc_studentaccommodationresource; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_studentaccommodationresource (id, studentaccommodationid, accommodationresourceid, datecollected, datereturned, commentwhencollecting, commentwhenreturning, returned, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 218
-- Name: acc_studentaccommodationresourceseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_studentaccommodationresourceseq', 1, false);


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 220
-- Name: acc_studentaccommodationselectioncriteriaseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_studentaccommodationselectioncriteriaseq', 1, false);


--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 216
-- Name: acc_studentaccommodationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_studentaccommodationseq', 1, false);


--
-- TOC entry 4745 (class 0 OID 126072)
-- Dependencies: 222
-- Data for Name: address; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY address (id, addresstypecode, personid, studyid, organizationalunitid, active, street, number, numberextension, zipcode, pobox, city, administrativepostcode, districtcode, provincecode, countrycode, telephone, faxnumber, mobilephone, emailaddress, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 221
-- Name: addressseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('addressseq', 142, true);


--
-- TOC entry 4747 (class 0 OID 126088)
-- Dependencies: 224
-- Data for Name: addresstype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY addresstype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
15	1	en    	Y	home	opuscollege	2010-11-02 16:22:58.674788
16	2	en    	Y	formal communication address student	opuscollege	2010-11-02 16:22:58.674788
17	3	en    	Y	financial guardian	opuscollege	2010-11-02 16:22:58.674788
18	4	en    	Y	formal communication address study	opuscollege	2010-11-02 16:22:58.674788
19	5	en    	Y	formal communication address organizational unit	opuscollege	2010-11-02 16:22:58.674788
20	6	en    	Y	formal communication address work	opuscollege	2010-11-02 16:22:58.674788
21	7	en    	Y	parents	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 223
-- Name: addresstypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('addresstypeseq', 21, true);


--
-- TOC entry 4749 (class 0 OID 126100)
-- Dependencies: 226
-- Data for Name: administrativepost; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY administrativepost (id, code, lang, active, description, districtcode, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 225
-- Name: administrativepostseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('administrativepostseq', 777, true);


--
-- TOC entry 4751 (class 0 OID 126112)
-- Dependencies: 228
-- Data for Name: admissionregistrationconfig; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY admissionregistrationconfig (id, organizationalunitid, academicyearid, startofregistration, endofregistration, active, writewho, writewhen, startofadmission, endofadmission, startofrefundperiod, endofrefundperiod) FROM stdin;
\.


--
-- TOC entry 4753 (class 0 OID 126124)
-- Dependencies: 230
-- Data for Name: appconfig; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY appconfig (id, appconfigattributename, appconfigattributevalue, writewho, writewhen, startdate, enddate) FROM stdin;
60	academicYearOfAdmission	14	opuscollege	2012-10-02 18:31:34.489	2011-01-01	2011-12-31
61	academicYearOfAdmission	16	opuscollege	2012-10-02 18:31:34.489	2012-01-01	2012-12-31
62	academicYearOfAdmission	17	opuscollege	2012-10-02 18:31:34.489	2013-01-01	2013-12-31
5	numberOfSubjectsToGrade	5	opuscollege	2011-12-13 14:50:39.092887	1970-01-01	\N
27	admissionBachelorCutOffPointCreditFemale	1	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
28	admissionBachelorCutOffPointCreditMale	3	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
33	admissionBachelorCutOffPointRelativesCreditFemale	0	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
34	admissionBachelorCutOffPointRelativesCreditMale	2	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
36	maxUploadSizeImage	300000	opuscollege	2012-04-03 13:12:04.889282	1970-01-01	\N
37	maxUploadSizeDoc	300000	opuscollege	2012-04-03 13:12:04.889282	1970-01-01	\N
39	admissionInitialStudyPlanStatus	1	opuscollege	2012-04-16 14:01:11.752894	1970-01-01	\N
40	cntdRegistrationInitialCardinalTimeUnitStatus	5	opuscollege	2012-04-16 14:01:11.752894	1970-01-01	\N
55	admissionBachelorCutOffPointCreditRuralAreas	-0.5	opuscollege	2012-05-14 16:56:00.942047	1970-01-01	\N
57	useOfScholarshipDecisionCriteria	N	opuscollege	2012-05-25 14:39:12.273	1970-01-01	\N
41	useOfSubjectBlocks	N	opuscollege	2012-04-16 14:01:33.045436	1970-01-01	\N
58	useOfSubsidies	N	opuscollege	2012-05-25 14:40:36.636	1970-01-01	\N
42	administratorMailAddress	admin@cbu.ac.zm	opuscollege	2012-04-17 15:03:26.508134	1970-01-01	\N
9	smtpBulkServerAddress	smtp.cbu.ac.zm	opuscollege	2011-12-22 14:05:47.862809	1970-01-01	\N
8	smtpServerAddress	smtp.cbu.ac.zm	opuscollege	2011-12-22 13:36:18.039582	1970-01-01	\N
35	USE_HOSTELBLOCKS	Y	opuscollege	2012-04-03 13:07:51.179803	1970-01-01	\N
53	BANK_RESPONSE_URL	n/a	opuscollege	2012-04-23 17:41:18.553256	1970-01-01	\N
52	BANK_WHITELIST_ADDRESSES	n/a	opuscollege	2012-04-23 17:41:18.553256	1970-01-01	\N
63	mailEnabled	N	opuscollege	2012-10-02 18:31:34.489	2011-01-01	\N
64	defaultResultsPublishDate	2099-01-01	opuscollege	2014-03-05 14:59:12.908	1970-01-01	\N
65	cntdRegistrationAutoApproveDefaultSubjects	N	opuscollege	2014-03-05 14:59:12.908	1970-01-01	\N
\.


--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 229
-- Name: appconfigseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('appconfigseq', 65, true);


--
-- TOC entry 4755 (class 0 OID 126137)
-- Dependencies: 232
-- Data for Name: applicantcategory; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY applicantcategory (id, code, lang, active, description, writewho, writewhen) FROM stdin;
13	1	nl	Y	Schoolverlater	opuscollege	2011-11-17 15:50:41.337963
14	2	nl	Y	Niet-schoolverlater	opuscollege	2011-11-17 15:50:41.337963
15	3	nl	Y	Speciaal geval	opuscollege	2011-11-17 15:50:41.337963
16	1	pt	Y	School leaver	opuscollege	2011-11-17 15:50:41.337963
17	2	pt	Y	Non-school leaver	opuscollege	2011-11-17 15:50:41.337963
18	3	pt	Y	Special case	opuscollege	2011-11-17 15:50:41.337963
19	1	en	Y	School leaver	opuscollege	2011-11-17 15:50:41.337963
20	2	en	Y	Non-school leaver	opuscollege	2011-11-17 15:50:41.337963
21	3	en	Y	Special case	opuscollege	2011-11-17 15:50:41.337963
\.


--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 231
-- Name: applicantcategoryseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('applicantcategoryseq', 21, true);


--
-- TOC entry 4757 (class 0 OID 126149)
-- Dependencies: 234
-- Data for Name: appointmenttype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY appointmenttype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
11	1	en    	Y	tenured	opuscollege	2010-11-02 16:22:58.674788
12	2	en    	Y	associate	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 233
-- Name: appointmenttypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('appointmenttypeseq', 12, true);


--
-- TOC entry 4759 (class 0 OID 126161)
-- Dependencies: 236
-- Data for Name: appversions; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY appversions (id, writewho, writewhen, module, state, db, dbversion) FROM stdin;
49	opuscollege	2010-04-07 15:26:39.196747	alumni	A	Y	3.00
71	opuscollege	2011-05-17 14:01:34.875173	dbconversion	A	Y	3.12
103	opuscollege	2011-10-18 15:17:25.608551	mozambique	A	Y	3.21
104	opuscollege	2011-10-18 15:17:37.064825	netherlands	A	Y	3.21
124	opuscollege	2011-12-22 13:42:22.798643	ucm	A	Y	3.03
144	opuscollege	2012-04-03 13:57:47.988848	scholarship	A	Y	3.26
146	opuscollege	2012-04-03 17:24:16.964515	unza	A	Y	3.20
150	opuscollege	2012-05-03 11:49:00.324838	fee	A	Y	3.15
185	opuscollege	2012-10-15 16:02:30.679	admission	A	Y	4.00
186	opuscollege	2012-10-15 16:02:30.679	cbu	A	Y	4.00
188	opuscollege	2012-10-15 16:02:30.679	report	A	Y	4.00
189	opuscollege	2012-10-15 16:02:30.679	zambia	A	Y	4.02
184	opuscollege	2012-10-15 16:02:30.679	accommodation	A	Y	4.02
202	opuscollege	2014-03-05 14:59:12.908	college	A	Y	4.33
\.


--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 235
-- Name: appversionsseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('appversionsseq', 202, true);


--
-- TOC entry 4760 (class 0 OID 126174)
-- Dependencies: 237
-- Data for Name: authorisation; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY authorisation (code, description, active, writewho, writewhen) FROM stdin;
E	editable	Y	opuscollege	2010-09-30 14:20:03.500628
V	visible	Y	opuscollege	2010-09-30 14:20:03.500628
H	hidden	Y	opuscollege	2010-09-30 14:20:03.500628
\.


--
-- TOC entry 4762 (class 0 OID 126185)
-- Dependencies: 239
-- Data for Name: blocktype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY blocktype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
5	1	en    	Y	thematic	opuscollege	2010-11-02 16:22:58.674788
6	2	en    	Y	study year	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 238
-- Name: blocktypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('blocktypeseq', 6, true);


--
-- TOC entry 4764 (class 0 OID 126197)
-- Dependencies: 241
-- Data for Name: bloodtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY bloodtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
37	1	en    	Y	A	opuscollege	2010-11-02 16:22:58.674788
38	2	en    	Y	B	opuscollege	2010-11-02 16:22:58.674788
39	3	en    	Y	AB	opuscollege	2010-11-02 16:22:58.674788
40	4	en    	Y	0	opuscollege	2010-11-02 16:22:58.674788
41	5	en    	Y	unknown	opuscollege	2010-11-02 16:22:58.674788
42	6	en    	Y	A-Pos	opuscollege	2010-11-02 16:22:58.674788
43	7	en    	Y	A-Neg	opuscollege	2010-11-02 16:22:58.674788
44	8	en    	Y	B-Pos	opuscollege	2010-11-02 16:22:58.674788
45	9	en    	Y	B-Neg	opuscollege	2010-11-02 16:22:58.674788
46	10	en    	Y	AB-Pos	opuscollege	2010-11-02 16:22:58.674788
47	11	en    	Y	AB-Neg	opuscollege	2010-11-02 16:22:58.674788
48	12	en    	Y	0-Pos	opuscollege	2010-11-02 16:22:58.674788
49	13	en    	Y	0-Neg	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 240
-- Name: bloodtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('bloodtypeseq', 49, true);


--
-- TOC entry 4766 (class 0 OID 126209)
-- Dependencies: 243
-- Data for Name: branch; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY branch (id, branchcode, branchdescription, institutionid, active, registrationdate, writewho, writewhen) FROM stdin;
117	01	Primary Branch Universidade Unizambeze	116	Y	2009-11-18	opuscollege	2009-11-18 15:58:13.257641
111	01	MEC Branch	111	Y	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
106	01	Universidade Eduardo Mondlane	106	Y	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
107	01	Universidade Católica de Moçambique	107	Y	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
108	01	Universidade Pedagógica	108	Y	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
109	01	Universidade Mussa Bin Bique	109	Y	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
110	01	Instituto Superior de Transportes e Comunicações	110	Y	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
113	02	Universidade Católica de Moçambique - Pemba	107	Y	2008-02-07	opuscollege	2008-02-07 13:52:20.637141
126	B017052011150407	Mulungushi Main Branch	130	Y	2011-05-17	opuscollege	2011-05-17 15:03:01.235215
120	01	Central Registry	130	Y	2010-10-16	opuscollege	2010-10-16 17:23:16.594706
145	B025052012155754	School of Business	130	Y	2012-05-25	opuscollege	2012-05-25 15:58:02.41
152	B025052012165019	Directorate of Distance Education and Open Learning	130	Y	2012-05-25	opuscollege	2012-05-25 16:50:30.229
151	B025052012165012	Graduate Studies	130	Y	2012-05-25	opuscollege	2012-05-25 16:50:17.275
146	B025052012163050	School of Built Environment	130	Y	2012-05-25	opuscollege	2012-05-25 16:31:00.707
147	B025052012163428	School of Engineering	130	Y	2012-05-25	opuscollege	2012-05-25 16:34:34.167
148	B025052012163934	School of Maths and Natural Sciences	130	Y	2012-05-25	opuscollege	2012-05-25 16:39:42.896
150	B025052012164743	School of Medicine	130	Y	2012-05-25	opuscollege	2012-05-25 16:47:48.161
144	B025052012155736	School of Mines and Mineral Sciences	130	Y	2012-05-25	opuscollege	2012-05-25 15:57:46.737
149	B025052012164328	School of Natural Resources	130	Y	2012-05-25	opuscollege	2012-05-25 16:43:36.263
\.


--
-- TOC entry 4768 (class 0 OID 126222)
-- Dependencies: 245
-- Data for Name: branchacademicyeartimeunit; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY branchacademicyeartimeunit (id, branchid, academicyearid, cardinaltimeunitcode, cardinaltimeunitnumber, resultspublishdate, active) FROM stdin;
\.


--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 244
-- Name: branchacademicyeartimeunitseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('branchacademicyeartimeunitseq', 1, false);


--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 242
-- Name: branchseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('branchseq', 152, true);


--
-- TOC entry 4770 (class 0 OID 126232)
-- Dependencies: 247
-- Data for Name: cardinaltimeunit; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY cardinaltimeunit (id, code, lang, active, description, writewho, writewhen, nrofunitsperyear) FROM stdin;
13	1	en    	Y	year	opuscollege	2011-07-22 18:08:38.426949	1
14	2	en    	Y	semester	opuscollege	2011-07-22 18:08:38.426949	2
15	3	en    	Y	trimester	opuscollege	2011-07-22 18:08:38.426949	3
\.


--
-- TOC entry 4772 (class 0 OID 126245)
-- Dependencies: 249
-- Data for Name: cardinaltimeunitresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY cardinaltimeunitresult (id, studyplanid, studyplancardinaltimeunitid, cardinaltimeunitresultdate, active, passed, writewho, writewhen, mark, endgradecomment) FROM stdin;
\.


--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 248
-- Name: cardinaltimeunitresultseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('cardinaltimeunitresultseq', 64, true);


--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 246
-- Name: cardinaltimeunitseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('cardinaltimeunitseq', 18, true);


--
-- TOC entry 4774 (class 0 OID 126260)
-- Dependencies: 251
-- Data for Name: cardinaltimeunitstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY cardinaltimeunitstatus (id, code, lang, description, active, writewho, writewhen) FROM stdin;
17	5	en    	Waiting for payment	Y	opuscollege	2011-10-27 15:16:18.2245
19	7	en    	Customize programme	Y	opuscollege	2011-10-27 15:16:18.2245
20	8	en    	Waiting for approval of registration	Y	opuscollege	2011-10-27 15:16:18.2245
21	9	en    	Rejected registration	Y	opuscollege	2011-10-27 15:16:18.2245
22	10	en    	Actively registered	Y	opuscollege	2011-10-27 15:16:18.2245
23	20	en    	Request for change	Y	opuscollege	2011-10-27 15:16:18.2245
\.


--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 250
-- Name: cardinaltimeunitstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('cardinaltimeunitstatusseq', 23, true);


--
-- TOC entry 4776 (class 0 OID 126272)
-- Dependencies: 253
-- Data for Name: cardinaltimeunitstudygradetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY cardinaltimeunitstudygradetype (id, studygradetypeid, cardinaltimeunitnumber, numberofelectivesubjectblocks, numberofelectivesubjects, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 252
-- Name: cardinaltimeunitstudygradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('cardinaltimeunitstudygradetypeseq', 752, true);


--
-- TOC entry 4778 (class 0 OID 126287)
-- Dependencies: 255
-- Data for Name: careerposition; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY careerposition (id, studyplanid, employer, startdate, enddate, careerposition, responsibility, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 254
-- Name: careerpositionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('careerpositionseq', 8, true);


--
-- TOC entry 4780 (class 0 OID 126299)
-- Dependencies: 257
-- Data for Name: civilstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY civilstatus (id, code, lang, active, description, writewho, writewhen) FROM stdin;
17	1	en    	Y	married	opuscollege	2010-11-02 16:22:58.674788
18	2	en    	Y	single	opuscollege	2010-11-02 16:22:58.674788
19	3	en    	Y	widow	opuscollege	2010-11-02 16:22:58.674788
20	4	en    	Y	divorced	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 256
-- Name: civilstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('civilstatusseq', 20, true);


--
-- TOC entry 4782 (class 0 OID 126311)
-- Dependencies: 259
-- Data for Name: civiltitle; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY civiltitle (id, code, lang, active, description, writewho, writewhen) FROM stdin;
10	1	en    	Y	mr.	opuscollege	2010-11-02 16:22:58.674788
11	2	en    	Y	mrs.	opuscollege	2010-11-02 16:22:58.674788
12	3	en    	Y	ms.	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 258
-- Name: civiltitleseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('civiltitleseq', 12, true);


--
-- TOC entry 4784 (class 0 OID 126323)
-- Dependencies: 261
-- Data for Name: classgroup; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY classgroup (id, description, studygradetypeid, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 260
-- Name: classgroupseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('classgroupseq', 1, false);


--
-- TOC entry 4786 (class 0 OID 126334)
-- Dependencies: 263
-- Data for Name: contract; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY contract (id, contractcode, staffmemberid, contracttypecode, contractdurationcode, contractstartdate, contractenddate, contacthours, fteappointmentoverall, fteeducation, fteresearch, fteadministrativetasks, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4788 (class 0 OID 126346)
-- Dependencies: 265
-- Data for Name: contractduration; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY contractduration (id, code, lang, active, description, writewho, writewhen) FROM stdin;
5	1	en    	Y	permanent	opuscollege	2010-11-02 16:22:58.674788
6	2	en    	Y	temporary	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 264
-- Name: contractdurationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('contractdurationseq', 6, true);


--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 262
-- Name: contractseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('contractseq', 39, true);


--
-- TOC entry 4790 (class 0 OID 126358)
-- Dependencies: 267
-- Data for Name: contracttype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY contracttype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
9	1	en    	Y	full	opuscollege	2010-11-02 16:22:58.674788
10	2	en    	Y	partial	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 266
-- Name: contracttypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('contracttypeseq', 10, true);


--
-- TOC entry 4792 (class 0 OID 126370)
-- Dependencies: 269
-- Data for Name: country; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY country (id, code, lang, active, short2, short3, description, writewho, writewhen) FROM stdin;
880	024	en    	Y	AO	AGO	ANGOLA	opuscollege	2011-05-10 10:09:00.042264
881	032	en    	Y	AR	ARG	ARGENTINA	opuscollege	2011-05-10 10:09:00.042264
882	036	en    	Y	AU	AUS	AUSTRALIA	opuscollege	2011-05-10 10:09:00.042264
883	040	en    	Y	AT	AUT	AUSTRIA	opuscollege	2011-05-10 10:09:00.042264
884	050	en    	Y	BD	BGD	BANGLADESH	opuscollege	2011-05-10 10:09:00.042264
885	112 	en    	Y	BY	BLR	BELARUS	opuscollege	2011-05-10 10:09:00.042264
886	056	en    	Y	BE	BEL	BELGIUM	opuscollege	2011-05-10 10:09:00.042264
887	204	en    	Y	BJ	BEN	BENIN	opuscollege	2011-05-10 10:09:00.042264
888	068	en    	Y	BO	BOL	BOLIVIA	opuscollege	2011-05-10 10:09:00.042264
889	070	en    	Y	BA	BIH	BOSNIA HERZEGOVINA	opuscollege	2011-05-10 10:09:00.042264
890	072	en    	Y	BW	BWA	BOTSWANA	opuscollege	2011-05-10 10:09:00.042264
891	076	en    	Y	BR	BRA	BRAZIL	opuscollege	2011-05-10 10:09:00.042264
892	100	en    	Y	BG	BGR	BULGARIA	opuscollege	2011-05-10 10:09:00.042264
893	854	en    	Y	BF	BFA	BURKINA FASO	opuscollege	2011-05-10 10:09:00.042264
894	108	en    	Y	BI	BDI	BURUNDI	opuscollege	2011-05-10 10:09:00.042264
895	120	en    	Y	CM	CMR	CAMEROON	opuscollege	2011-05-10 10:09:00.042264
896	124	en    	Y	CA	CAN	CANADA	opuscollege	2011-05-10 10:09:00.042264
897	132	en    	Y	CV	CPV	CAPE VERDE	opuscollege	2011-05-10 10:09:00.042264
898	140	en    	Y	CF	CAF	CENTRAL AFRICAN REPUBLIC	opuscollege	2011-05-10 10:09:00.042264
899	148	en    	Y	TD	TCD	TCHAD	opuscollege	2011-05-10 10:09:00.042264
900	152	en    	Y	CL	CHL	CHILE	opuscollege	2011-05-10 10:09:00.042264
901	156	en    	Y	CN	CHN	CHINA	opuscollege	2011-05-10 10:09:00.042264
902	170	en    	Y	CO	COL	COLOMBIA	opuscollege	2011-05-10 10:09:00.042264
903	174	en    	Y	KM	COM	COMORE ISLAND	opuscollege	2011-05-10 10:09:00.042264
904	178	en    	Y	CG	COG	CONGO	opuscollege	2011-05-10 10:09:00.042264
905	188	en    	Y	CR	CRI	COSTA RICA	opuscollege	2011-05-10 10:09:00.042264
906	384	en    	Y	CI	CIV	COSTA DO MARFIM	opuscollege	2011-05-10 10:09:00.042264
907	192	en    	Y	CU	CUB	CUBA	opuscollege	2011-05-10 10:09:00.042264
908	203	en    	Y	CZ	CZE	CHECH REPUBLIC	opuscollege	2011-05-10 10:09:00.042264
909	208	en    	Y	DK	DNK	DENMARK	opuscollege	2011-05-10 10:09:00.042264
910	262	en    	Y	DJ	DJI	DJIBOUTI	opuscollege	2011-05-10 10:09:00.042264
911	626	en    	Y	TP	TMP	EAST TIMOR	opuscollege	2011-05-10 10:09:00.042264
912	218	en    	Y	EC	ECU	ECUADOR	opuscollege	2011-05-10 10:09:00.042264
913	818	en    	Y	EG	EGY	EGYPT	opuscollege	2011-05-10 10:09:00.042264
914	222	en    	Y	SV	SLV	EL SALVADOR	opuscollege	2011-05-10 10:09:00.042264
915	226	en    	Y	GQ	GNQ	EQUITORIAL GUINEE	opuscollege	2011-05-10 10:09:00.042264
916	232	en    	Y	ER	ERI	ERITREA	opuscollege	2011-05-10 10:09:00.042264
917	210	en    	Y	ET	ETH	ETHIOPIA	opuscollege	2011-05-10 10:09:00.042264
918	246	en    	Y	FI	FIN	FINLAND	opuscollege	2011-05-10 10:09:00.042264
919	250	en    	Y	FR	FRA	FRANCE	opuscollege	2011-05-10 10:09:00.042264
920	266	en    	Y	GA	GAB	GABON	opuscollege	2011-05-10 10:09:00.042264
921	270	en    	Y	GM	GMB	GAMBIA	opuscollege	2011-05-10 10:09:00.042264
922	276	en    	Y	DE	DEU	GERMANY	opuscollege	2011-05-10 10:09:00.042264
923	288	en    	Y	GH	GHA	GHANA	opuscollege	2011-05-10 10:09:00.042264
924	300	en    	Y	GR	GRC	GREECE	opuscollege	2011-05-10 10:09:00.042264
925	320	en    	Y	GT	GTM	GUATEMALA	opuscollege	2011-05-10 10:09:00.042264
926	324	en    	Y	GN	GIN	GUINEE	opuscollege	2011-05-10 10:09:00.042264
927	624	en    	Y	GW	GNB	GUINEE-BISSAU	opuscollege	2011-05-10 10:09:00.042264
928	344	en    	Y	HK	HKG	HONG KONG	opuscollege	2011-05-10 10:09:00.042264
929	348	en    	Y	HU	HUN	HUNGARIA	opuscollege	2011-05-10 10:09:00.042264
930	356	en    	Y	IN	IND	INDIA	opuscollege	2011-05-10 10:09:00.042264
931	360	en    	Y	Id	IdN	INDONESIA	opuscollege	2011-05-10 10:09:00.042264
932	364	en    	Y	IR	IRN	IRAN	opuscollege	2011-05-10 10:09:00.042264
933	368	en    	Y	IQ	IRQ	IRAQ	opuscollege	2011-05-10 10:09:00.042264
934	372	en    	Y	IE	IRL	IRELAND	opuscollege	2011-05-10 10:09:00.042264
935	376	en    	Y	IL	ISR	ISRAEL	opuscollege	2011-05-10 10:09:00.042264
936	380	en    	Y	IT	ITA	ITALY	opuscollege	2011-05-10 10:09:00.042264
937	388	en    	Y	JM	JAM	JAMAICA	opuscollege	2011-05-10 10:09:00.042264
938	392	en    	Y	JP	JPN	JAPAN	opuscollege	2011-05-10 10:09:00.042264
939	404	en    	Y	KE	KEN	KENYA	opuscollege	2011-05-10 10:09:00.042264
940	408	en    	Y	KP	PRK	NORTH COREA	opuscollege	2011-05-10 10:09:00.042264
941	410	en    	Y	KR	KOR	SOUTH COREA	opuscollege	2011-05-10 10:09:00.042264
942	414	en    	Y	KW	KWT	KUWAIT	opuscollege	2011-05-10 10:09:00.042264
943	422	en    	Y	LB	LBN	LEBANON	opuscollege	2011-05-10 10:09:00.042264
944	426	en    	Y	LS	LSO	LESOTHO	opuscollege	2011-05-10 10:09:00.042264
945	430	en    	Y	LR	LBR	LIBERIA	opuscollege	2011-05-10 10:09:00.042264
946	434	en    	Y	LY	LBY	LYBIA	opuscollege	2011-05-10 10:09:00.042264
947	442	en    	Y	LU	LUX	LUXEMBURG	opuscollege	2011-05-10 10:09:00.042264
948	446	en    	Y	MO	MAC	MACAU	opuscollege	2011-05-10 10:09:00.042264
949	450	en    	Y	MG	MDG	MADAGASCAR	opuscollege	2011-05-10 10:09:00.042264
950	454	en    	Y	MW	MWI	MALAWI	opuscollege	2011-05-10 10:09:00.042264
951	458	en    	Y	MY	MYS	MALAYSIA	opuscollege	2011-05-10 10:09:00.042264
952	466	en    	Y	ML	MLI	MALI	opuscollege	2011-05-10 10:09:00.042264
953	478	en    	Y	MR	MRT	MAURETANIA	opuscollege	2011-05-10 10:09:00.042264
954	480	en    	Y	MU	MUS	MAURITIUS	opuscollege	2011-05-10 10:09:00.042264
955	484	en    	Y	MX	MEX	MEXICO	opuscollege	2011-05-10 10:09:00.042264
956	504	en    	Y	MA	MAR	MORROCOS	opuscollege	2011-05-10 10:09:00.042264
957	508	en    	Y	MZ	MOZ	MOZAMBIQUE	opuscollege	2011-05-10 10:09:00.042264
958	516	en    	Y	NA	NAM	NAMIBIA	opuscollege	2011-05-10 10:09:00.042264
959	528	en    	Y	NL	NLD	NETHERLANDS	opuscollege	2011-05-10 10:09:00.042264
960	554	en    	Y	NZ	NZL	NEW ZEALAND	opuscollege	2011-05-10 10:09:00.042264
961	562	en    	Y	NE	NER	NIGER	opuscollege	2011-05-10 10:09:00.042264
962	566	en    	Y	NG	NGA	NIGERIA	opuscollege	2011-05-10 10:09:00.042264
963	578	en    	Y	NO	NOR	NORWAY	opuscollege	2011-05-10 10:09:00.042264
964	586	en    	Y	PK	PAK	PAKISTAN	opuscollege	2011-05-10 10:09:00.042264
965	591	en    	Y	PA	PAN	PANAMA	opuscollege	2011-05-10 10:09:00.042264
966	600	en    	Y	PY	PRY	PARAGUAY	opuscollege	2011-05-10 10:09:00.042264
967	604	en    	Y	PE	PER	PERU	opuscollege	2011-05-10 10:09:00.042264
968	608	en    	Y	PH	PHL	PHILIPPINES	opuscollege	2011-05-10 10:09:00.042264
969	616	en    	Y	PL	POL	POLAND	opuscollege	2011-05-10 10:09:00.042264
970	620	en    	Y	PT	PRT	PORTUGAL	opuscollege	2011-05-10 10:09:00.042264
971	630	en    	Y	PR	PRI	PUERRTO RICO	opuscollege	2011-05-10 10:09:00.042264
972	634	en    	Y	QA	QAT	QATAR	opuscollege	2011-05-10 10:09:00.042264
973	638	en    	Y	RE	REU	REUNION	opuscollege	2011-05-10 10:09:00.042264
974	642	en    	Y	RO	ROM	RUMENIA	opuscollege	2011-05-10 10:09:00.042264
975	643	en    	Y	RU	RUS	RUSSIA	opuscollege	2011-05-10 10:09:00.042264
976	646	en    	Y	RW	RWA	RWANDA	opuscollege	2011-05-10 10:09:00.042264
977	678	en    	Y	ST	STP	SANTO TOMAS AND PRINCIPE	opuscollege	2011-05-10 10:09:00.042264
978	682	en    	Y	SA	SAU	SAUDI ARABIA	opuscollege	2011-05-10 10:09:00.042264
979	686	en    	Y	SN	SEN	SENEGAL	opuscollege	2011-05-10 10:09:00.042264
980	690	en    	Y	SC	SYC	SEYCHELLES	opuscollege	2011-05-10 10:09:00.042264
981	694	en    	Y	SL	SLE	SIERRA LEONE	opuscollege	2011-05-10 10:09:00.042264
982	702	en    	Y	SG	SGP	SINGAPOUR	opuscollege	2011-05-10 10:09:00.042264
983	703	en    	Y	SK	SVK	SLOVAKIA	opuscollege	2011-05-10 10:09:00.042264
984	706	en    	Y	SO	SOM	SOMALIA	opuscollege	2011-05-10 10:09:00.042264
985	710	en    	Y	ZA	ZAF	SOUTH AFRICA	opuscollege	2011-05-10 10:09:00.042264
986	724	en    	Y	ES	ESP	SPAIN	opuscollege	2011-05-10 10:09:00.042264
987	144	en    	Y	LK	LKA	SRI LANKA	opuscollege	2011-05-10 10:09:00.042264
988	736	en    	Y	SD	SDN	SUDAN	opuscollege	2011-05-10 10:09:00.042264
989	748	en    	Y	SZ	SWZ	SWAZILAND	opuscollege	2011-05-10 10:09:00.042264
990	752	en    	Y	SE	SWE	SWEDEN	opuscollege	2011-05-10 10:09:00.042264
991	756	en    	Y	CH	CHE	SWITZERLAND	opuscollege	2011-05-10 10:09:00.042264
992	760	en    	Y	SY	SYR	SYRIA	opuscollege	2011-05-10 10:09:00.042264
993	158	en    	Y	TW	TWN	TAIWAN	opuscollege	2011-05-10 10:09:00.042264
994	834	en    	Y	TZ	TZA	TANZANIA	opuscollege	2011-05-10 10:09:00.042264
995	764	en    	Y	TH	THA	TAILANDIA	opuscollege	2011-05-10 10:09:00.042264
996	768	en    	Y	TG	TGO	TOGO	opuscollege	2011-05-10 10:09:00.042264
997	788	en    	Y	TN	TUN	TUNISIA	opuscollege	2011-05-10 10:09:00.042264
998	792	en    	Y	TR	TUR	TURKEY	opuscollege	2011-05-10 10:09:00.042264
999	800	en    	Y	UG	UGA	UGANDA	opuscollege	2011-05-10 10:09:00.042264
1000	804	en    	Y	UA	UKR	UKRAINE	opuscollege	2011-05-10 10:09:00.042264
1001	784	en    	Y	AE	ARE	UNITED ARAB EMIRATES	opuscollege	2011-05-10 10:09:00.042264
1002	826	en    	Y	GB	GBR	GREAT BRITAIN	opuscollege	2011-05-10 10:09:00.042264
1003	840	en    	Y	US	USA	UNITED STATES	opuscollege	2011-05-10 10:09:00.042264
1004	858	en    	Y	UY	URY	URUGUAY	opuscollege	2011-05-10 10:09:00.042264
1005	862	en    	Y	VE	VEN	VENEZUELA	opuscollege	2011-05-10 10:09:00.042264
1006	704	en    	Y	VN	VNM	VIETNAM	opuscollege	2011-05-10 10:09:00.042264
1007	732	en    	Y	EH	ESH	WESTERN SAHARA	opuscollege	2011-05-10 10:09:00.042264
1008	887	en    	Y	YE	YEM	YEMEN	opuscollege	2011-05-10 10:09:00.042264
1009	891	en    	Y	YU	YUG	YUGOSLAVIA	opuscollege	2011-05-10 10:09:00.042264
1010	180	en    	Y	RC	RDC	DR OF CONGO	opuscollege	2011-05-10 10:09:00.042264
1011	894	en    	Y	ZM	ZMB	ZAMBIA	opuscollege	2011-05-10 10:09:00.042264
1012	716	en    	Y	ZW	ZWE	ZIMBABWE	opuscollege	2011-05-10 10:09:00.042264
879	012	en    	Y	DZ	DZA	ALGERIA	opuscollege	2011-05-10 10:09:00.042264
\.


--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 268
-- Name: countryseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('countryseq', 1012, true);


--
-- TOC entry 4794 (class 0 OID 126382)
-- Dependencies: 271
-- Data for Name: daypart; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY daypart (id, code, lang, active, description, writewho, writewhen) FROM stdin;
4	1	en    	Y	morning	opuscollege	2010-08-23 22:46:06.977017
6	3	en    	Y	evening	opuscollege	2010-08-23 22:46:06.977017
5	2	en    	Y	afternoon	opuscollege	2010-08-23 22:46:06.977017
\.


--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 270
-- Name: daypartseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('daypartseq', 9, true);


--
-- TOC entry 4796 (class 0 OID 126394)
-- Dependencies: 273
-- Data for Name: discipline; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY discipline (id, code, lang, active, description, writewho, writewhen) FROM stdin;
1	1	en	Y	Human Resource Mgt	opuscollege	2012-01-31 11:02:32.919327
2	2	en	Y	Education	opuscollege	2012-01-31 11:02:32.919327
3	3	en	Y	Sociology	opuscollege	2012-01-31 11:02:32.919327
4	4	en	Y	Anthropology	opuscollege	2012-01-31 11:02:32.919327
5	5	en	Y	Law	opuscollege	2012-01-31 11:02:32.919327
6	6	en	Y	Public Administration	opuscollege	2012-01-31 11:02:32.919327
7	7	en	Y	Personnel Mgt	opuscollege	2012-01-31 11:02:32.919327
8	8	en	Y	Political science	opuscollege	2012-01-31 11:02:32.919327
9	9	en	Y	Economics	opuscollege	2012-01-31 11:02:32.919327
10	10	en	Y	Business Administration	opuscollege	2012-01-31 11:02:32.919327
11	11	en	Y	Commerce	opuscollege	2012-01-31 11:02:32.919327
12	12	en	Y	Accountancy	opuscollege	2012-01-31 11:02:32.919327
13	13	en	Y	Other bachelor with 3 years of practical experience	opuscollege	2012-01-31 11:02:32.919327
14	14	en	Y	Practicing HRM with postgraduate Diploma from recognized institution	opuscollege	2012-01-31 11:02:32.919327
15	15	en	Y	Holder of professional accounting qualifications (ACCA, CIMA)	opuscollege	2012-01-31 11:02:32.919327
16	16	en	Y	2 years of practical experience and First degree in any bachelor	opuscollege	2012-01-31 11:02:32.919327
17	17	en	Y	3 years of practical experience and Post-graduate diploma in various disciplines	opuscollege	2012-01-31 11:02:32.919327
18	18	en	Y	Holder of professional qualification (CIOB, RICS, RIBA)	opuscollege	2012-01-31 11:02:32.919327
19	1	nl	Y	Human Resource Mgt	opuscollege	2012-01-31 11:02:32.919327
20	2	nl	Y	Education	opuscollege	2012-01-31 11:02:32.919327
21	3	nl	Y	Sociology	opuscollege	2012-01-31 11:02:32.919327
22	4	nl	Y	Anthropology	opuscollege	2012-01-31 11:02:32.919327
23	5	nl	Y	Law	opuscollege	2012-01-31 11:02:32.919327
24	6	nl	Y	Public Administration	opuscollege	2012-01-31 11:02:32.919327
25	7	nl	Y	Personnel Mgt	opuscollege	2012-01-31 11:02:32.919327
26	8	nl	Y	Political science	opuscollege	2012-01-31 11:02:32.919327
27	9	nl	Y	Economics	opuscollege	2012-01-31 11:02:32.919327
28	10	nl	Y	Business Administration	opuscollege	2012-01-31 11:02:32.919327
29	11	nl	Y	Commerce	opuscollege	2012-01-31 11:02:32.919327
30	12	nl	Y	Accountancy	opuscollege	2012-01-31 11:02:32.919327
31	13	nl	Y	Other bachelor with 3 years of practical experience	opuscollege	2012-01-31 11:02:32.919327
32	14	nl	Y	Practicing HRM with postgraduate Diploma from recognized institution	opuscollege	2012-01-31 11:02:32.919327
33	15	nl	Y	Holder of professional accounting qualifications (ACCA, CIMA)	opuscollege	2012-01-31 11:02:32.919327
34	16	nl	Y	2 years of practical experience and First degree in any bachelor	opuscollege	2012-01-31 11:02:32.919327
35	17	nl	Y	3 years of practical experience and Post-graduate diploma in various disciplines	opuscollege	2012-01-31 11:02:32.919327
36	18	nl	Y	Holder of professional qualification (CIOB, RICS, RIBA)	opuscollege	2012-01-31 11:02:32.919327
37	1	pt	Y	Human Resource Mgt	opuscollege	2012-01-31 11:02:32.919327
38	2	pt	Y	Education	opuscollege	2012-01-31 11:02:32.919327
39	3	pt	Y	Sociology	opuscollege	2012-01-31 11:02:32.919327
40	4	pt	Y	Anthropology	opuscollege	2012-01-31 11:02:32.919327
41	5	pt	Y	Law	opuscollege	2012-01-31 11:02:32.919327
42	6	pt	Y	Public Administration	opuscollege	2012-01-31 11:02:32.919327
43	7	pt	Y	Personnel Mgt	opuscollege	2012-01-31 11:02:32.919327
44	8	pt	Y	Political science	opuscollege	2012-01-31 11:02:32.919327
45	9	pt	Y	Economics	opuscollege	2012-01-31 11:02:32.919327
46	10	pt	Y	Business Administration	opuscollege	2012-01-31 11:02:32.919327
47	11	pt	Y	Commerce	opuscollege	2012-01-31 11:02:32.919327
48	12	pt	Y	Accountancy	opuscollege	2012-01-31 11:02:32.919327
49	13	pt	Y	Other bachelor with 3 years of practical experience	opuscollege	2012-01-31 11:02:32.919327
50	14	pt	Y	Practicing HRM with postgraduate Diploma from recognized institution	opuscollege	2012-01-31 11:02:32.919327
51	15	pt	Y	Holder of professional accounting qualifications (ACCA, CIMA)	opuscollege	2012-01-31 11:02:32.919327
52	16	pt	Y	2 years of practical experience and First degree in any bachelor	opuscollege	2012-01-31 11:02:32.919327
53	17	pt	Y	3 years of practical experience and Post-graduate diploma in various disciplines	opuscollege	2012-01-31 11:02:32.919327
54	18	pt	Y	Holder of professional qualification (CIOB, RICS, RIBA)	opuscollege	2012-01-31 11:02:32.919327
\.


--
-- TOC entry 4798 (class 0 OID 126406)
-- Dependencies: 275
-- Data for Name: disciplinegroup; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY disciplinegroup (id, code, active, description, writewho, writewhen) FROM stdin;
1	1	Y	Master of Arts - Human Resource Mgt	opuscollege	2012-01-31 14:43:14.080379
2	2	Y	Master of Business Administration General	opuscollege	2012-01-31 14:43:14.080379
3	3	Y	Master of Business Administration Financial	opuscollege	2012-01-31 14:43:14.080379
4	4	Y	Master of Science in Project Mgt	opuscollege	2012-01-31 14:43:14.080379
5	1	Y	Master of Arts - Human Resource Mgt	opuscollege	2012-01-31 14:43:14.080379
6	2	Y	Master of Business Administration General	opuscollege	2012-01-31 14:43:14.080379
7	3	Y	Master of Business Administration Financial	opuscollege	2012-01-31 14:43:14.080379
8	4	Y	Master of Science in Project Mgt	opuscollege	2012-01-31 14:43:14.080379
9	1	Y	Master of Arts - Human Resource Mgt	opuscollege	2012-01-31 14:43:14.080379
10	2	Y	Master of Business Administration General	opuscollege	2012-01-31 14:43:14.080379
11	3	Y	Master of Business Administration Financial	opuscollege	2012-01-31 14:43:14.080379
12	4	Y	Master of Science in Project Mgt	opuscollege	2012-01-31 14:43:14.080379
\.


--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 274
-- Name: disciplinegroupseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('disciplinegroupseq', 12, true);


--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 272
-- Name: disciplineseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('disciplineseq', 54, true);


--
-- TOC entry 4800 (class 0 OID 126418)
-- Dependencies: 277
-- Data for Name: district; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY district (id, code, lang, active, description, provincecode, writewho, writewhen) FROM stdin;
579	ZM-01-01	en    	Y	Chibombo	ZM-01	opuscollege	2011-06-30 09:47:48.872219
580	ZM-01-02	en    	Y	Kabwe	ZM-01	opuscollege	2011-06-30 09:47:48.872219
581	ZM-01-03	en    	Y	Kapiri Mposhi	ZM-01	opuscollege	2011-06-30 09:47:48.872219
582	ZM-01-04	en    	Y	Mkushi	ZM-01	opuscollege	2011-06-30 09:47:48.872219
583	ZM-01-05	en    	Y	Mumbwa	ZM-01	opuscollege	2011-06-30 09:47:48.872219
584	ZM-01-06	en    	Y	Serenje	ZM-01	opuscollege	2011-06-30 09:47:48.872219
585	ZM-02-01	en    	Y	Chililabombwe	ZM-02	opuscollege	2011-06-30 09:47:48.872219
586	ZM-02-02	en    	Y	Chingola	ZM-02	opuscollege	2011-06-30 09:47:48.872219
587	ZM-02-03	en    	Y	Kalulushi	ZM-02	opuscollege	2011-06-30 09:47:48.872219
588	ZM-02-04	en    	Y	Kitwe	ZM-02	opuscollege	2011-06-30 09:47:48.872219
589	ZM-02-05	en    	Y	Luanshya	ZM-02	opuscollege	2011-06-30 09:47:48.872219
590	ZM-02-06	en    	Y	Lufwanyama	ZM-02	opuscollege	2011-06-30 09:47:48.872219
591	ZM-02-07	en    	Y	Masaiti	ZM-02	opuscollege	2011-06-30 09:47:48.872219
592	ZM-02-08	en    	Y	Mpongwe	ZM-02	opuscollege	2011-06-30 09:47:48.872219
593	ZM-02-09	en    	Y	Mufulira	ZM-02	opuscollege	2011-06-30 09:47:48.872219
594	ZM-02-10	en    	Y	Ndola 	ZM-02	opuscollege	2011-06-30 09:47:48.872219
595	ZM-03-01	en    	Y	Chadiza	ZM-03	opuscollege	2011-06-30 09:47:48.872219
596	ZM-03-02	en    	Y	Chama	ZM-03	opuscollege	2011-06-30 09:47:48.872219
597	ZM-03-03	en    	Y	Chipata	ZM-03	opuscollege	2011-06-30 09:47:48.872219
598	ZM-03-04	en    	Y	Katete	ZM-03	opuscollege	2011-06-30 09:47:48.872219
599	ZM-03-05	en    	Y	Lundazi	ZM-03	opuscollege	2011-06-30 09:47:48.872219
600	ZM-03-06	en    	Y	Mambwe	ZM-03	opuscollege	2011-06-30 09:47:48.872219
601	ZM-03-07	en    	Y	Nyimba	ZM-03	opuscollege	2011-06-30 09:47:48.872219
602	ZM-03-08	en    	Y	Petauke	ZM-03	opuscollege	2011-06-30 09:47:48.872219
603	ZM-04-01	en    	Y	Chiengi	ZM-04	opuscollege	2011-06-30 09:47:48.872219
604	ZM-04-02	en    	Y	Kawambwa	ZM-04	opuscollege	2011-06-30 09:47:48.872219
605	ZM-04-03	en    	Y	Mansa	ZM-04	opuscollege	2011-06-30 09:47:48.872219
606	ZM-04-04	en    	Y	Milenge	ZM-04	opuscollege	2011-06-30 09:47:48.872219
607	ZM-04-05	en    	Y	Mwense	ZM-04	opuscollege	2011-06-30 09:47:48.872219
608	ZM-04-06	en    	Y	Nchelenge	ZM-04	opuscollege	2011-06-30 09:47:48.872219
609	ZM-04-07	en    	Y	Samfya	ZM-04	opuscollege	2011-06-30 09:47:48.872219
610	ZM-05-01	en    	Y	Chongwe	ZM-05	opuscollege	2011-06-30 09:47:48.872219
611	ZM-05-02	en    	Y	Kafue	ZM-05	opuscollege	2011-06-30 09:47:48.872219
612	ZM-05-03	en    	Y	Luangwa	ZM-05	opuscollege	2011-06-30 09:47:48.872219
613	ZM-05-04	en    	Y	Lusaka	ZM-05	opuscollege	2011-06-30 09:47:48.872219
614	ZM-06-01	en    	Y	Chilubi	ZM-06	opuscollege	2011-06-30 09:47:48.872219
615	ZM-06-02	en    	Y	Chinsali	ZM-06	opuscollege	2011-06-30 09:47:48.872219
616	ZM-06-03	en    	Y	Isoka	ZM-06	opuscollege	2011-06-30 09:47:48.872219
617	ZM-06-04	en    	Y	Kaputa	ZM-06	opuscollege	2011-06-30 09:47:48.872219
618	ZM-06-05	en    	Y	Kasama District	ZM-06	opuscollege	2011-06-30 09:47:48.872219
619	ZM-06-06	en    	Y	Luwingu	ZM-06	opuscollege	2011-06-30 09:47:48.872219
620	ZM-06-07	en    	Y	Mbala	ZM-06	opuscollege	2011-06-30 09:47:48.872219
621	ZM-06-08	en    	Y	Mpika	ZM-06	opuscollege	2011-06-30 09:47:48.872219
622	ZM-06-09	en    	Y	Mporokoso	ZM-06	opuscollege	2011-06-30 09:47:48.872219
623	ZM-06-10	en    	Y	Mpulungu	ZM-06	opuscollege	2011-06-30 09:47:48.872219
624	ZM-06-11	en    	Y	Mungwi	ZM-06	opuscollege	2011-06-30 09:47:48.872219
626	ZM-07-02	en    	Y	Kabompo	ZM-07	opuscollege	2011-06-30 09:47:48.872219
627	ZM-07-03	en    	Y	Kasempa	ZM-07	opuscollege	2011-06-30 09:47:48.872219
628	ZM-07-04	en    	Y	Mufumbwe	ZM-07	opuscollege	2011-06-30 09:47:48.872219
629	ZM-07-05	en    	Y	Mwinilunga	ZM-07	opuscollege	2011-06-30 09:47:48.872219
630	ZM-07-06	en    	Y	Solwezi	ZM-07	opuscollege	2011-06-30 09:47:48.872219
631	ZM-07-07	en    	Y	Zambezi	ZM-07	opuscollege	2011-06-30 09:47:48.872219
632	ZM-08-01	en    	Y	Choma	ZM-08	opuscollege	2011-06-30 09:47:48.872219
633	ZM-08-02	en    	Y	Gwembe	ZM-08	opuscollege	2011-06-30 09:47:48.872219
634	ZM-08-03	en    	Y	Itezhi-Tezhi	ZM-08	opuscollege	2011-06-30 09:47:48.872219
635	ZM-08-04	en    	Y	Kalomo	ZM-08	opuscollege	2011-06-30 09:47:48.872219
636	ZM-08-05	en    	Y	Kazungula	ZM-08	opuscollege	2011-06-30 09:47:48.872219
637	ZM-08-06	en    	Y	Livingstone	ZM-08	opuscollege	2011-06-30 09:47:48.872219
638	ZM-08-07	en    	Y	Mazabuka	ZM-08	opuscollege	2011-06-30 09:47:48.872219
639	ZM-08-08	en    	Y	Monze	ZM-08	opuscollege	2011-06-30 09:47:48.872219
640	ZM-08-09	en    	Y	Namwala	ZM-08	opuscollege	2011-06-30 09:47:48.872219
641	ZM-08-10	en    	Y	Siavonga	ZM-08	opuscollege	2011-06-30 09:47:48.872219
642	ZM-08-11	en    	Y	Sinazongwe	ZM-08	opuscollege	2011-06-30 09:47:48.872219
643	ZM-09-01	en    	Y	Kalabo	ZM-09	opuscollege	2011-06-30 09:47:48.872219
644	ZM-09-02	en    	Y	Kaoma	ZM-09	opuscollege	2011-06-30 09:47:48.872219
645	ZM-09-03	en    	Y	Lukulu	ZM-09	opuscollege	2011-06-30 09:47:48.872219
646	ZM-09-04	en    	Y	Mongu	ZM-09	opuscollege	2011-06-30 09:47:48.872219
647	ZM-09-05	en    	Y	Senanga	ZM-09	opuscollege	2011-06-30 09:47:48.872219
648	ZM-09-06	en    	Y	Sesheke	ZM-09	opuscollege	2011-06-30 09:47:48.872219
649	ZM-09-07	en    	Y	Shangombo	ZM-09	opuscollege	2011-06-30 09:47:48.872219
625	ZM-07-01	en    	Y	Chavuma	ZM-07	opuscollege	2011-06-30 09:47:48.872219
\.


--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 276
-- Name: districtseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('districtseq', 649, true);


--
-- TOC entry 4802 (class 0 OID 126430)
-- Dependencies: 279
-- Data for Name: educationarea; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY educationarea (id, code, lang, active, description, writewho, writewhen) FROM stdin;
1	S	en    	Y	Science based	opuscollege	2014-03-05 14:59:12.908
2	A	en    	Y	Art based	opuscollege	2014-03-05 14:59:12.908
3	M	en    	Y	Medicine based	opuscollege	2014-03-05 14:59:12.908
4	S	pt    	Y	Science based	opuscollege	2014-03-05 14:59:12.908
5	A	pt    	Y	Art based	opuscollege	2014-03-05 14:59:12.908
6	M	pt    	Y	Medicine based	opuscollege	2014-03-05 14:59:12.908
7	S	nl    	Y	Science based	opuscollege	2014-03-05 14:59:12.908
8	A	nl    	Y	Art based	opuscollege	2014-03-05 14:59:12.908
9	M	nl    	Y	Medicine based	opuscollege	2014-03-05 14:59:12.908
\.


--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 278
-- Name: educationareaseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('educationareaseq', 9, true);


--
-- TOC entry 4804 (class 0 OID 126442)
-- Dependencies: 281
-- Data for Name: educationlevel; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY educationlevel (id, code, lang, active, description, writewho, writewhen) FROM stdin;
1	B	en    	Y	Bachelor	opuscollege	2014-03-05 14:59:12.908
2	M	en    	Y	Master	opuscollege	2014-03-05 14:59:12.908
3	B	pt    	Y	Bachelor	opuscollege	2014-03-05 14:59:12.908
4	M	pt    	Y	Master	opuscollege	2014-03-05 14:59:12.908
5	B	nl    	Y	Bachelor	opuscollege	2014-03-05 14:59:12.908
6	M	nl    	Y	Master	opuscollege	2014-03-05 14:59:12.908
\.


--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 280
-- Name: educationlevelseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('educationlevelseq', 6, true);


--
-- TOC entry 4806 (class 0 OID 126454)
-- Dependencies: 283
-- Data for Name: educationtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY educationtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
25	-1	en    	Y	Elementary	opuscollege	2010-11-02 16:22:58.674788
26	0	en    	Y	Basic	opuscollege	2010-11-02 16:22:58.674788
27	1	en    	Y	Secondary school	opuscollege	2010-11-02 16:22:58.674788
28	3	en    	Y	Higher education	opuscollege	2010-11-02 16:22:58.674788
29	4	en    	Y	Bachelor	opuscollege	2010-11-02 16:22:58.674788
30	5	en    	Y	Licenciate	opuscollege	2010-11-02 16:22:58.674788
31	6	en    	Y	Diploma	opuscollege	2010-11-02 16:22:58.674788
32	7	en    	Y	Master	opuscollege	2010-11-02 16:22:58.674788
33	8	en    	Y	Doctor	opuscollege	2010-11-02 16:22:58.674788
34	9	en    	Y	Post graduate	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 282
-- Name: educationtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('educationtypeseq', 34, true);


--
-- TOC entry 4808 (class 0 OID 126466)
-- Dependencies: 285
-- Data for Name: endgrade; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY endgrade (id, code, lang, active, endgradetypecode, gradepoint, percentagemin, percentagemax, comment, description, temporarygrade, writewho, writewhen, passed, academicyearid) FROM stdin;
856	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
926	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
996	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1066	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1136	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1206	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1276	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1346	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1416	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1486	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1556	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1626	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1696	S	en    	Y	AR	2.50	55.80	100.00	Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
904	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
912	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
920	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
921	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
922	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
923	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
924	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
925	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
858	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
866	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
874	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
881	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
888	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
896	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
928	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
936	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
944	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
951	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
958	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
966	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1482	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
974	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
982	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
990	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
991	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
992	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
993	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
994	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
995	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
998	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1006	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1014	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1021	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1028	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1036	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1044	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1483	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1052	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1060	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1061	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1062	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1063	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1064	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1065	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1068	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1076	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1084	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1091	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1098	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1106	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1114	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1484	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1122	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1130	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1131	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1132	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1133	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1134	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1135	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1138	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1146	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1154	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1161	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1168	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1176	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1184	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1192	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1200	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1201	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1202	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1203	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1204	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1205	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1208	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1216	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1224	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1231	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1238	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1246	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1254	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1262	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1270	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1271	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1272	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1273	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1274	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1275	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1278	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1286	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1294	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1301	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1308	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1316	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1324	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1332	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1485	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1340	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1341	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1342	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1343	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1344	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1345	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1348	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1356	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1364	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1371	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1378	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1386	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1394	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1402	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1410	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1411	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1412	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1413	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1414	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1415	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1418	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1426	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1434	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1441	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1448	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1456	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1464	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1472	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1480	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1481	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1488	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1496	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1504	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1511	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1518	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1526	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1534	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1542	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1550	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1551	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1552	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1553	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1554	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1555	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1558	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1566	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1574	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1581	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1588	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1596	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1604	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1612	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1620	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1621	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1622	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1623	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1624	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1625	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1628	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1636	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1644	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1651	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1658	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1666	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1674	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1682	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1690	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1691	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1692	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1693	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1694	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1695	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1698	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1706	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1714	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1721	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1728	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1736	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1744	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1752	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1760	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1761	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1762	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1763	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1764	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1765	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1766	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1773	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1780	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1787	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1794	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1801	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1808	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1815	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1822	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1829	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1836	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1843	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1850	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1870	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1877	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1884	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1891	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1898	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1905	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1912	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1919	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1926	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1933	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1940	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1947	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1954	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1974	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1981	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1988	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1995	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2002	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2009	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2016	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2023	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2030	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2037	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2044	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2051	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2058	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2078	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2084	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2090	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2096	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2102	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2108	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2114	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2120	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2126	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2132	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2138	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2144	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2150	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
857	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-07-26 18:00:59.70967	N	8
927	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	19
997	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1067	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1137	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1207	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1277	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1347	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1417	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1487	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1557	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1627	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1697	U	en    	Y	AR	0.00	0.00	55.79	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	20
900	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
901	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
902	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
903	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
906	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
907	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
908	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
909	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
910	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
911	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
914	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
915	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
916	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
917	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
918	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
919	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
860	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
861	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
862	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
863	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
864	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
865	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
868	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
869	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
870	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
871	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
872	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
873	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
876	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
877	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
878	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
879	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
880	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-07-26 18:00:59.70967	N	8
883	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
884	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
885	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
886	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
887	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-07-26 18:00:59.70967	N	8
890	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
891	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
892	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
893	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
894	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
895	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
898	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
899	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
930	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
931	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
932	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
933	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
934	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
935	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
938	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
939	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
940	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
941	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
942	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
943	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
946	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
947	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
948	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
949	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
950	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	19
953	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
954	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
955	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
956	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
957	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	19
960	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
961	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
962	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
963	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
964	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
965	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
968	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
969	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
970	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
971	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
972	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
973	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
976	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
977	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
978	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
979	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
980	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
981	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
984	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
985	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
986	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
987	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
988	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
989	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1000	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1001	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1002	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1003	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1004	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1005	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1008	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1009	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1010	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1011	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1012	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1013	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1016	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1017	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1018	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1019	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1020	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1023	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1024	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1025	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1026	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1027	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1030	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1031	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1032	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1033	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1034	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1035	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1038	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1039	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1040	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1041	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1042	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1043	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1046	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1047	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1048	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1049	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1050	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1051	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1054	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1055	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1056	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1057	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1058	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1059	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1070	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1071	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1072	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1073	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1074	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1075	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1078	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1079	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1080	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1081	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1082	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1083	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1086	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1087	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1088	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1089	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1090	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1093	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1094	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1095	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1096	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1097	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1100	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1101	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1102	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1103	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1104	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1105	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1108	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1109	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1110	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1111	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1112	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1113	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1116	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1117	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1118	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1119	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1120	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1121	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1124	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1125	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1126	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1127	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1128	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1129	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1140	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1141	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1142	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1143	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1144	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1145	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1148	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1149	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1150	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1151	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1152	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1153	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1156	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1157	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1158	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1159	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1160	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1163	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1164	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1165	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1166	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1167	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1170	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1171	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1172	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1173	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1174	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1175	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1178	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1179	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1180	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1181	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1182	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1183	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1186	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1187	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1188	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1189	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1190	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1191	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1194	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1195	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1196	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1197	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1198	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1199	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1210	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1211	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1212	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1213	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1214	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1215	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1218	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1219	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1220	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1221	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1222	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1223	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1226	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1227	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1228	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1229	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1230	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1233	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1234	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1235	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1236	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1237	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1240	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1241	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1242	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1243	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1244	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1245	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1248	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1249	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1250	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1251	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1252	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1253	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1256	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1257	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1258	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1259	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1260	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1261	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1264	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1265	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1266	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1267	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1268	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1269	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1280	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1281	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1282	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1283	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1284	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1285	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1288	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1289	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1290	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1291	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1292	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1293	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1296	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1297	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1298	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1299	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1300	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1303	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1304	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1305	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1306	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1307	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1310	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1311	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1312	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1313	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1314	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1315	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1318	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1319	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1320	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1321	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1322	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1323	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1326	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1327	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1328	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1329	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1330	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1331	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1334	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1335	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1336	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1337	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1338	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1339	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1350	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1351	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1352	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1353	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1354	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1355	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1358	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1359	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1360	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1361	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1362	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1363	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1366	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1367	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1368	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1369	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1370	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1373	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1374	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1375	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1376	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1377	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1380	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1381	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1382	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1383	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1384	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1385	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1388	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1389	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1390	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1391	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1392	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1393	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1396	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1397	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1398	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1399	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1400	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1401	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1404	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1405	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1406	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1407	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1408	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1409	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1420	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1421	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1422	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1423	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1424	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1425	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1428	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1429	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1430	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1431	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1432	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1433	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1436	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1437	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1438	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1439	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1440	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1443	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1444	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1445	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1446	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1447	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1450	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1451	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1452	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1453	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1454	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1455	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1458	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1459	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1460	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1461	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1462	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1463	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1466	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1467	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1468	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1469	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1470	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1471	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1474	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1475	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1476	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1477	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1478	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1479	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1490	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1491	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1492	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1493	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1494	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1495	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1498	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1499	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1500	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1501	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1502	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1503	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1506	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1507	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1508	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1509	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1510	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1513	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1514	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1515	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1516	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1517	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1520	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1521	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1522	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1523	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1524	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1525	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1528	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1529	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1530	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1531	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1532	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1533	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1536	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1537	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1538	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1539	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1540	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1541	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1544	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1545	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1546	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1547	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1548	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1549	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1489	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1560	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1561	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1562	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1563	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1564	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1565	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1568	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1569	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1570	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1571	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1572	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1573	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1576	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1577	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1578	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1579	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1580	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1583	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1584	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1585	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1586	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1587	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1590	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1591	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1592	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1593	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1594	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1595	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1598	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1599	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1600	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1601	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1602	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1603	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1606	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1607	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1608	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1609	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1610	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1611	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1614	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1615	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1616	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1617	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1618	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1619	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1630	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1631	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1632	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1633	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1634	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1635	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1638	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1639	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1640	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1641	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1642	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1643	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1646	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1647	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1648	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1649	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1650	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1653	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1654	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1655	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1656	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1657	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1660	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1661	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1662	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1663	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1664	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1665	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1668	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1669	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1670	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1671	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1672	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1673	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1676	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1677	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1678	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1679	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1680	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1681	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1684	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1685	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1686	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1687	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1688	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1689	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1700	B+	en    	Y	BSC	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1701	B	en    	Y	BSC	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1702	C+	en    	Y	BSC	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1703	C	en    	Y	BSC	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1704	D+	en    	Y	BSC	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1705	D	en    	Y	BSC	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1708	B+	en    	Y	BA	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1709	B	en    	Y	BA	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1710	C+	en    	Y	BA	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1711	C	en    	Y	BA	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1712	D+	en    	Y	BA	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1713	D	en    	Y	BA	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1716	B+	en    	Y	MSC	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1717	B	en    	Y	MSC	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1718	C+	en    	Y	MSC	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1719	C	en    	Y	MSC	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1720	F	en    	Y	MSC	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1723	B+	en    	Y	MA	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1724	B	en    	Y	MA	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1725	C+	en    	Y	MA	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1726	C	en    	Y	MA	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1727	F	en    	Y	MA	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1730	B+	en    	Y	DA	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1731	B	en    	Y	DA	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1732	C+	en    	Y	DA	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1733	C	en    	Y	DA	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1734	D+	en    	Y	DA	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1735	D	en    	Y	DA	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1738	B+	en    	Y	DSC	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1739	B	en    	Y	DSC	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1740	C+	en    	Y	DSC	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1741	C	en    	Y	DSC	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1742	D+	en    	Y	DSC	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1743	D	en    	Y	DSC	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1746	B+	en    	Y	DIST-DEGR	3.00	68.00	75.99	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1747	B	en    	Y	DIST-DEGR	2.00	62.00	67.99	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1748	C+	en    	Y	DIST-DEGR	1.00	56.00	61.99	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1749	C	en    	Y	DIST-DEGR	0.00	50.00	55.99	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1750	D+	en    	Y	DIST-DEGR	0.00	40.00	49.99	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1751	D	en    	Y	DIST-DEGR	0.00	0.00	39.99	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1754	B+	en    	Y	DIST	3.00	79.60	84.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1755	B	en    	Y	DIST	2.00	69.60	79.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1756	C+	en    	Y	DIST	1.00	59.60	69.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1757	C	en    	Y	DIST	0.00	49.60	59.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1758	D+	en    	Y	DIST	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1759	D	en    	Y	DIST	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
905	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
913	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
859	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
867	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
875	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
882	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
889	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
897	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
929	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
937	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
945	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
952	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
959	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
967	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
975	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
983	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
999	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1007	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1015	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1022	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1029	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1037	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1045	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1053	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1069	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1077	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1085	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1092	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1099	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1107	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1115	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1123	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1139	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1147	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1155	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1162	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1169	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1177	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1185	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1193	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1209	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1217	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1225	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1232	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1239	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1247	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1255	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1263	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1279	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1287	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1295	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1302	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1309	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1317	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1325	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1333	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1349	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1357	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1365	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1372	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1379	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1387	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1395	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1403	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1419	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1427	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1435	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1442	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1449	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1457	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1465	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1473	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1497	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1505	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1512	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1519	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1527	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1535	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1543	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1559	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1567	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1575	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1582	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1589	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1597	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1605	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1613	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1629	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1637	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1645	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1652	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1659	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1667	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1675	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1683	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1699	A	en    	Y	BSC	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1707	A	en    	Y	BA	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1715	A	en    	Y	MSC	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1722	A	en    	Y	MA	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1729	A	en    	Y	DA	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1737	A	en    	Y	DSC	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1745	A	en    	Y	DIST-DEGR	4.00	76.00	85.99	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1753	A	en    	Y	DIST	4.00	84.60	89.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1767	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1768	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1769	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1770	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1771	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1772	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1774	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1775	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1776	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1777	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1778	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1779	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1781	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1782	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1783	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1784	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1785	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1786	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1788	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1789	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1790	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1791	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1792	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1793	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1795	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1796	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1797	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1798	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1799	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1800	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1802	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1803	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1804	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1805	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1806	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1807	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1809	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1810	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1811	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1812	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1813	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1814	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1816	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1817	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1818	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1819	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1820	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1821	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1823	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1824	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1825	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1826	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1827	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1828	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1830	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1831	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1832	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1833	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1834	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1835	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1837	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1838	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1839	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1840	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1841	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1842	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1844	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1845	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1846	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1847	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1848	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1849	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1851	B+	en    	Y	B	1.50	65.80	74.79	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1852	B	en    	Y	B	1.00	55.80	65.79	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1853	C+	en    	Y	B	0.50	45.80	55.79	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1854	C	en    	Y	B	0.00	39.80	45.79	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1855	D+	en    	Y	B	0.00	34.80	39.79	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1856	D	en    	Y	B	0.00	0.00	34.79	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1857	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1858	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1859	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1860	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1861	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1862	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1863	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1864	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1865	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1866	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1867	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1868	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1869	A	en    	Y	B	2.00	74.80	85.79	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1871	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1872	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1873	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1874	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1875	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1876	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1878	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1879	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1880	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1881	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1882	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1883	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1885	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1886	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1887	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1888	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1889	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1890	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1892	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1893	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1894	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1895	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1896	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1897	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1899	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1900	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1901	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1902	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1903	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1904	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1906	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1907	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1908	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1909	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1910	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1911	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1913	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1914	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1915	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1916	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1917	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1918	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1920	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1921	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1922	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1923	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1924	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1925	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1927	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1928	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1929	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1930	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1931	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1932	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1934	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1935	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1936	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1937	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1938	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1939	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1941	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1942	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1943	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1944	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1945	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1946	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1948	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1949	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1950	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1951	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1952	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1953	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1955	B+	en    	Y	ADVCERT	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1956	B	en    	Y	ADVCERT	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1957	C+	en    	Y	ADVCERT	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1958	C	en    	Y	ADVCERT	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1959	D+	en    	Y	ADVCERT	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1960	D	en    	Y	ADVCERT	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1961	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1962	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1963	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1964	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1965	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1966	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1967	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1968	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1969	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1970	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1971	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1972	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1973	A	en    	Y	ADVCERT	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1975	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1976	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1977	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1978	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1979	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1980	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1982	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1983	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1984	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1985	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1986	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1987	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1989	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1990	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1991	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1992	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1993	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1994	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1996	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1997	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1998	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1999	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2000	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
2001	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
2003	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2004	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2005	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2006	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2007	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
2008	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
2010	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2011	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2012	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2013	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2014	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
2015	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
2017	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2018	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2019	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2020	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2021	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
2022	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
2024	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2025	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2026	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2027	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2028	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
2029	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
2031	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2032	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2033	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2034	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2035	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
2036	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
2038	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2039	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2040	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2041	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2042	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
2043	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
2045	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2046	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2047	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2048	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2049	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
2050	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
2052	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2053	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2054	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2055	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2056	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
2057	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
2059	B+	en    	Y	ADVTECH	3.00	67.60	75.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2060	B	en    	Y	ADVTECH	2.00	61.60	67.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2061	C+	en    	Y	ADVTECH	1.00	55.60	61.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2062	C	en    	Y	ADVTECH	0.00	49.60	55.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2063	D+	en    	Y	ADVTECH	0.00	39.60	49.59	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
2064	D	en    	Y	ADVTECH	0.00	0.00	39.59	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
2065	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2066	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2067	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2068	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2069	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2070	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2071	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2072	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2073	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2074	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2075	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2076	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2077	A	en    	Y	ADVTECH	4.00	75.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2079	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2080	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2081	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2082	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2083	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-07-26 18:00:59.70967	N	8
2085	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2086	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2087	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2088	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2089	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	19
2091	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2092	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2093	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2094	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2095	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	15
2097	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2098	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2099	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2100	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2101	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	9
2103	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2104	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2105	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2106	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2107	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	10
2109	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2110	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2111	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2112	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2113	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	11
2115	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2116	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2117	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2118	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2119	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	12
2121	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2122	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2123	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2124	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2125	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	13
2127	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2128	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2129	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2130	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2131	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	16
2133	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2134	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2135	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2136	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2137	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	17
2139	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2140	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2141	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2142	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2143	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	18
2145	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2146	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2147	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2148	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2149	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	14
2151	B+	en    	Y	M	4.00	69.60	74.59	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2152	B	en    	Y	M	3.00	64.60	69.59	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2153	C+	en    	Y	M	2.00	54.60	64.59	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2154	C	en    	Y	M	1.00	49.60	54.59	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2155	F	en    	Y	M	0.00	0.00	49.59	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	20
2156	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2157	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2158	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2159	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2160	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2161	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2162	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2163	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2164	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2165	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2166	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2167	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2168	A	en    	Y	M	5.00	74.60	85.59	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
\.


--
-- TOC entry 4810 (class 0 OID 126480)
-- Dependencies: 287
-- Data for Name: endgradegeneral; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY endgradegeneral (id, code, lang, active, comment, description, temporarygrade, writewho, writewhen) FROM stdin;
1	WP	en    	Y	Withdrawn from course with permission		N	opuscollege	2010-11-02 16:39:22.709387
2	DC	en    	Y	Deceased during course		N	opuscollege	2010-11-02 16:39:22.709387
\.


--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 286
-- Name: endgradegeneralseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('endgradegeneralseq', 2, true);


--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 284
-- Name: endgradeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('endgradeseq', 2168, true);


--
-- TOC entry 4812 (class 0 OID 126493)
-- Dependencies: 289
-- Data for Name: endgradetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY endgradetype (id, code, lang, description, writewho, writewhen, active) FROM stdin;
29	CA	en    	continuous assessment	opuscollege	2011-03-15 17:17:12.177	Y
30	SE	en    	sessional examination	opuscollege	2011-03-15 17:17:12.177	Y
31	SR	en    	course result	opuscollege	2011-03-15 17:17:12.177	Y
32	PC	en    	project course result	opuscollege	2011-03-15 17:17:12.177	Y
33	TR	en    	thesis result	opuscollege	2011-03-15 17:17:12.177	Y
34	AR	en    	attachment result	opuscollege	2011-03-15 17:17:12.177	Y
35	CTU	en    	cardinal time unit endgrade	opuscollege	2011-03-15 17:17:12.177	Y
36	BSC	en    	bachelor of science	opuscollege	2011-03-15 17:17:12.177	Y
37	BA	en    	bachelor of art	opuscollege	2011-03-15 17:17:12.177	Y
38	MSC	en    	master of science	opuscollege	2011-03-15 17:17:12.177	Y
39	MA	en    	master of art	opuscollege	2011-03-15 17:17:12.177	Y
40	DA	en    	diploma other than maths and science	opuscollege	2011-03-15 17:17:12.177	Y
41	DSC	en    	diploma maths and science	opuscollege	2011-03-15 17:17:12.177	Y
42	DIST-DEGR	en    	degree programme (distant education)	opuscollege	2011-03-15 17:17:12.177	Y
43	DIST	en    	distant education	opuscollege	2011-03-15 17:17:12.177	Y
44	PHD	en    	doctor	opuscollege	2011-03-15 17:17:12.177	Y
45	LIC	en    	licentiate	opuscollege	2011-03-15 17:17:12.177	Y
\.


--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 288
-- Name: endgradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('endgradetypeseq', 45, true);


--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 290
-- Name: entityseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('entityseq', 1, false);


--
-- TOC entry 4815 (class 0 OID 126507)
-- Dependencies: 292
-- Data for Name: examination; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY examination (id, examinationcode, examinationdescription, subjectid, examinationtypecode, numberofattempts, weighingfactor, brspassingexamination, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4817 (class 0 OID 126519)
-- Dependencies: 294
-- Data for Name: examinationresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY examinationresult (id, examinationid, subjectid, studyplandetailid, examinationresultdate, attemptnr, mark, staffmemberid, active, writewho, writewhen, passed, subjectresultid) FROM stdin;
\.


--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 293
-- Name: examinationresultseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examinationresultseq', 159, true);


--
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 291
-- Name: examinationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examinationseq', 218, true);


--
-- TOC entry 4819 (class 0 OID 126533)
-- Dependencies: 296
-- Data for Name: examinationteacher; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY examinationteacher (id, staffmemberid, examinationid, active, writewho, writewhen, classgroupid) FROM stdin;
\.


--
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 295
-- Name: examinationteacherseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examinationteacherseq', 242, true);


--
-- TOC entry 4821 (class 0 OID 126545)
-- Dependencies: 298
-- Data for Name: examinationtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY examinationtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
153	1	en    	Y	oral	opuscollege	2010-11-02 16:22:58.674788
154	2	en    	Y	written	opuscollege	2010-11-02 16:22:58.674788
155	3	en    	Y	paper	opuscollege	2010-11-02 16:22:58.674788
156	4	en    	Y	lab/practical	opuscollege	2010-11-02 16:22:58.674788
157	5	en    	Y	thesis	opuscollege	2010-11-02 16:22:58.674788
158	6	en    	Y	case study	opuscollege	2010-11-02 16:22:58.674788
159	7	en    	Y	presentation	opuscollege	2010-11-02 16:22:58.674788
160	100	en    	Y	combined tests	opuscollege	2010-11-02 16:22:58.674788
161	101	en    	Y	sessional examination	opuscollege	2010-11-02 16:22:58.674788
162	102	en    	Y	continuous assessment	opuscollege	2010-11-02 16:22:58.674788
163	8	en    	Y	homework	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 297
-- Name: examinationtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examinationtypeseq', 163, true);


--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 299
-- Name: examseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examseq', 38, true);


--
-- TOC entry 4824 (class 0 OID 126559)
-- Dependencies: 301
-- Data for Name: examtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY examtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
9	1	en    	Y	multiple event	opuscollege	2010-11-02 16:22:58.674788
10	2	en    	Y	single event	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 300
-- Name: examtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examtypeseq', 10, true);


--
-- TOC entry 4825 (class 0 OID 126569)
-- Dependencies: 302
-- Data for Name: exclusion; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY exclusion (subject1, subject2) FROM stdin;
\.


--
-- TOC entry 4827 (class 0 OID 126574)
-- Dependencies: 304
-- Data for Name: expellationtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY expellationtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
1	1	en    	Y	Falsification of certificates	opuscollege	2008-02-01 08:20:15.179914
2	2	en    	Y	Academic fraude	opuscollege	2008-02-01 08:20:15.179914
3	3	en    	Y	Disobedience	opuscollege	2008-02-01 08:20:15.179914
4	4	en    	Y	Other motives	opuscollege	2008-02-01 08:20:15.179914
\.


--
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 303
-- Name: expellationtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('expellationtypeseq', 8, true);


--
-- TOC entry 4829 (class 0 OID 126586)
-- Dependencies: 306
-- Data for Name: failgrade; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY failgrade (id, code, lang, active, comment, description, temporarygrade, writewho, writewhen) FROM stdin;
1	U	en    	Y	Unsatisfactory, Fail in a Practical Course		N	opuscollege	2010-11-02 16:39:22.709387
2	NE	en    	Y	No Examination Taken		N	opuscollege	2010-11-02 16:39:22.709387
3	WD	en    	Y	Withdrawn from the course with penalty for unsatisfactory academic progress		N	opuscollege	2010-11-02 16:39:22.709387
4	LT	en    	Y	Left the course during the semester without permission		N	opuscollege	2010-11-02 16:39:22.709387
5	DQ	en    	Y	Disqualified in a course by Senate Examination		N	opuscollege	2010-11-02 16:39:22.709387
6	DR	en    	Y	Deregistered for failure to pay fees		N	opuscollege	2010-11-02 16:39:22.709387
7	RS	en    	Y	Re-sit course examination only		N	opuscollege	2010-11-02 16:39:22.709387
8	IN	en    	Y	Incomplete		Y	opuscollege	2010-11-02 16:39:22.709387
9	DF	en    	Y	Deferred Examination		Y	opuscollege	2010-11-02 16:39:22.709387
10	SP	en    	Y	Supplementary Examination		Y	opuscollege	2010-11-02 16:39:22.709387
\.


--
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 305
-- Name: failgradeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('failgradeseq', 10, true);


--
-- TOC entry 4831 (class 0 OID 126599)
-- Dependencies: 308
-- Data for Name: fee_fee; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY fee_fee (id, feedue, deadline, active, writewho, writewhen, categorycode, subjectblockstudygradetypeid, subjectstudygradetypeid, studygradetypeid, academicyearid, numberofinstallments, tuitionwaiverdiscountpercentage, fulltimestudentdiscountpercentage, localstudentdiscountpercentage, continuedregistrationdiscountpercentage, postgraduatediscountpercentage, accommodationfeeid, branchid) FROM stdin;
\.


--
-- TOC entry 4833 (class 0 OID 126623)
-- Dependencies: 310
-- Data for Name: fee_feecategory; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY fee_feecategory (id, code, lang, active, description, writewho, writewhen) FROM stdin;
25	1	en    	Y	Tuition	opuscollege	2010-08-10 15:07:24.742992
26	2	en    	Y	Housing / Accomodation	opuscollege	2010-08-10 15:07:24.742992
27	3	en    	Y	Examinations	opuscollege	2010-08-10 15:07:24.742992
28	4	en    	Y	Medical	opuscollege	2010-08-10 15:07:24.742992
29	5	en    	Y	Recreations	opuscollege	2010-08-10 15:07:24.742992
30	6	en    	Y	Admission - Initial Application	opuscollege	2010-08-10 15:07:24.742992
31	7	en    	Y	Registration	opuscollege	2010-08-10 15:07:24.742992
32	8	en    	Y	Insurance / Caution	opuscollege	2010-08-10 15:07:24.742992
\.


--
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 309
-- Name: fee_feecategoryseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('fee_feecategoryseq', 48, true);


--
-- TOC entry 5299 (class 0 OID 0)
-- Dependencies: 307
-- Name: fee_feeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('fee_feeseq', 99, true);


--
-- TOC entry 4835 (class 0 OID 126635)
-- Dependencies: 312
-- Data for Name: fee_payment; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY fee_payment (id, paydate, studentid, studyplandetailid, subjectblockid, subjectid, sumpaid, active, writewho, writewhen, feeid, studentbalanceid, installmentnumber) FROM stdin;
\.


--
-- TOC entry 5300 (class 0 OID 0)
-- Dependencies: 311
-- Name: fee_paymentseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('fee_paymentseq', 429, true);


--
-- TOC entry 4837 (class 0 OID 126653)
-- Dependencies: 314
-- Data for Name: fieldofeducation; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY fieldofeducation (id, code, lang, active, description, writewho, writewhen) FROM stdin;
9	1	en    	Y	general	opuscollege	2010-11-02 16:22:58.674788
10	2	en    	Y	agricultural	opuscollege	2010-11-02 16:22:58.674788
12	4	en    	Y	pedagogical	opuscollege	2010-11-02 16:22:58.674788
11	3	en    	Y	technical	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5301 (class 0 OID 0)
-- Dependencies: 313
-- Name: fieldofeducationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('fieldofeducationseq', 12, true);


--
-- TOC entry 4839 (class 0 OID 126665)
-- Dependencies: 316
-- Data for Name: financialrequest; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY financialrequest (id, requestid, financialrequestid, statuscode, timestampreceived, requestversion, requeststring, timestampmodified, errorcode, processedtofinancetransaction, errorreportedtofinancialsystem, writewho, requesttypeid, writewhen, studentid) FROM stdin;
\.


--
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 315
-- Name: financialrequestseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('financialrequestseq', 1092, true);


--
-- TOC entry 4841 (class 0 OID 126678)
-- Dependencies: 318
-- Data for Name: financialtransaction; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY financialtransaction (id, transactiontypeid, financialrequestid, requestid, statuscode, errorcode, nationalregistrationnumber, academicyearid, timestampprocessed, amount, name, cell, requeststring, processedtostudentbalance, errorreportedtofinancialbankrequest, writewho, writewhen, studentcode) FROM stdin;
\.


--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 317
-- Name: financialtransactionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('financialtransactionseq', 851, true);


--
-- TOC entry 4843 (class 0 OID 126691)
-- Dependencies: 320
-- Data for Name: frequency; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY frequency (id, code, lang, active, description, writewho, writewhen) FROM stdin;
51	1	en    	Y	1	opuscollege	2010-11-02 16:22:58.674788
52	2	en    	Y	1,5	opuscollege	2010-11-02 16:22:58.674788
53	3	en    	Y	2	opuscollege	2010-11-02 16:22:58.674788
54	4	en    	Y	2,5	opuscollege	2010-11-02 16:22:58.674788
55	5	en    	Y	3	opuscollege	2010-11-02 16:22:58.674788
56	6	en    	Y	3,5	opuscollege	2010-11-02 16:22:58.674788
57	7	en    	Y	4	opuscollege	2010-11-02 16:22:58.674788
58	8	en    	Y	4,5	opuscollege	2010-11-02 16:22:58.674788
59	9	en    	Y	5	opuscollege	2010-11-02 16:22:58.674788
60	10	en    	Y	5,5	opuscollege	2010-11-02 16:22:58.674788
61	11	en    	Y	6	opuscollege	2010-11-02 16:22:58.674788
62	12	en    	Y	6,5	opuscollege	2010-11-02 16:22:58.674788
63	13	en    	Y	7	opuscollege	2010-11-02 16:22:58.674788
64	14	en    	Y	7,5	opuscollege	2010-11-02 16:22:58.674788
65	15	en    	Y	8	opuscollege	2010-11-02 16:22:58.674788
66	16	en    	Y	8,5	opuscollege	2010-11-02 16:22:58.674788
67	17	en    	Y	9	opuscollege	2010-11-02 16:22:58.674788
68	18	en    	Y	9,5	opuscollege	2010-11-02 16:22:58.674788
69	19	en    	Y	10	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 319
-- Name: frequencyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('frequencyseq', 69, true);


--
-- TOC entry 4845 (class 0 OID 126703)
-- Dependencies: 322
-- Data for Name: function; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY function (id, code, lang, active, description, writewho, writewhen) FROM stdin;
79	1	en    	Y	Chief Professor	opuscollege	2011-03-15 17:17:12.177
80	2	en    	Y	Associate Professor	opuscollege	2011-03-15 17:17:12.177
81	3	en    	Y	Assistant Professor	opuscollege	2011-03-15 17:17:12.177
82	4	en    	Y	Researcher	opuscollege	2011-03-15 17:17:12.177
83	5	en    	Y	Assistant	opuscollege	2011-03-15 17:17:12.177
84	6	en    	Y	Assistant-stagiaire	opuscollege	2011-03-15 17:17:12.177
86	8	en    	Y	Director	opuscollege	2011-03-15 17:17:12.177
87	9	en    	Y	Sub Director of Education	opuscollege	2011-03-15 17:17:12.177
88	10	en    	Y	Sub Director of Research	opuscollege	2011-03-15 17:17:12.177
89	11	en    	Y	Dean of School	opuscollege	2011-03-15 17:17:12.177
90	12	en    	Y	Head of Department	opuscollege	2011-03-15 17:17:12.177
91	13	en    	Y	Head of Group	opuscollege	2011-03-15 17:17:12.177
92	14	en    	Y	Head of Course	opuscollege	2011-03-15 17:17:12.177
93	15	en    	Y	Head of Section	opuscollege	2011-03-15 17:17:12.177
85	7	en    	Y	Monitor	opuscollege	2011-03-15 17:17:12.177
\.


--
-- TOC entry 4847 (class 0 OID 126715)
-- Dependencies: 324
-- Data for Name: functionlevel; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY functionlevel (id, code, lang, active, description, writewho, writewhen) FROM stdin;
5	1	en    	Y	management	opuscollege	2008-02-01 08:20:15.179914
6	2	en    	Y	non-management	opuscollege	2008-02-01 08:20:15.179914
\.


--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 323
-- Name: functionlevelseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('functionlevelseq', 10, true);


--
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 321
-- Name: functionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('functionseq', 93, true);


--
-- TOC entry 4849 (class 0 OID 126727)
-- Dependencies: 326
-- Data for Name: gender; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY gender (id, code, lang, active, description, writewho, writewhen) FROM stdin;
14	1	en    	Y	male	opuscollege	2010-11-02 16:22:58.674788
15	2	en    	Y	female	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 325
-- Name: genderseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('genderseq', 15, true);


--
-- TOC entry 4851 (class 0 OID 126739)
-- Dependencies: 328
-- Data for Name: gradedsecondaryschoolsubject; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY gradedsecondaryschoolsubject (id, secondaryschoolsubjectid, studyplanid, grade, active, writewho, writewhen, secondaryschoolsubjectgroupid, level) FROM stdin;
\.


--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 327
-- Name: gradedsecondaryschoolsubjectseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('gradedsecondaryschoolsubjectseq', 351, true);


--
-- TOC entry 4853 (class 0 OID 126752)
-- Dependencies: 330
-- Data for Name: gradetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY gradetype (id, code, lang, active, description, title, writewho, writewhen, educationlevelcode, educationareacode) FROM stdin;
122	SEC	pt    	Y	Ensino secund&aacute;rio	Ensino sec.	opuscollege	2012-05-21 15:39:19.182758	\N	\N
124	LIC	pt    	Y	Licentiatura	Lic..	opuscollege	2012-05-21 15:39:19.182758	\N	\N
126	PHD	pt    	Y	Ph.D.	Ph.D.	opuscollege	2012-05-21 15:39:19.182758	\N	\N
123	BSC	pt    	Y	Bacharelato	B.Sc.	opuscollege	2012-05-21 15:39:19.182758	B	\N
127	BA	pt    	Y	Bachelor of art	B.A.	opuscollege	2012-05-21 15:39:19.182758	B	\N
125	MSC	pt    	Y	Mestre	M.Sc.	opuscollege	2012-05-21 15:39:19.182758	M	\N
128	MA	pt    	Y	Master of art	M.A.	opuscollege	2012-05-21 15:39:19.182758	M	\N
129	SEC	en    	Y	Secondary school	sec.	opuscollege	2012-10-02 18:31:34.489	\N	\N
130	BSC	en    	Y	Bachelor of science	B.Sc.	opuscollege	2012-10-02 18:31:34.489	\N	\N
131	LIC	en    	Y	Licentiate	Lic..	opuscollege	2012-10-02 18:31:34.489	\N	\N
132	MSC	en    	Y	Master of science	M.Sc.	opuscollege	2012-10-02 18:31:34.489	\N	\N
133	PHD	en    	Y	Doctor	Ph.D.	opuscollege	2012-10-02 18:31:34.489	\N	\N
134	BA	en    	Y	Bachelor of art	B.A.	opuscollege	2012-10-02 18:31:34.489	\N	\N
135	MA	en    	Y	Master of art	M.A.	opuscollege	2012-10-02 18:31:34.489	\N	\N
136	DA	en    	Y	Diploma other than maths and science	Dpl.A.	opuscollege	2012-10-02 18:31:34.489	\N	\N
137	DSC	en    	Y	Diploma maths and science	Dpl.M.Sc.	opuscollege	2012-10-02 18:31:34.489	\N	\N
138	BEng	en    	Y	Bachelor of Engineering	B.Eng.	opuscollege	2012-10-02 18:31:34.489	\N	\N
139	MEngSc	en    	Y	Master of Engineering Science	M.Eng.Sc.	opuscollege	2012-10-02 18:31:34.489	\N	\N
140	MScEng	en    	Y	Master of Science Engineering 	M.Sc.Eng.	opuscollege	2012-10-02 18:31:34.489	\N	\N
141	MBA	en    	Y	Master of Business Administration	M.BA.	opuscollege	2012-10-02 18:31:34.489	\N	\N
142	M	en    	Y	Master	M.	opuscollege	2012-10-02 18:31:34.489	\N	\N
143	B	en    	Y	Bachelor	B	opuscollege	2012-10-02 18:31:34.489	\N	\N
144	ADVTECH	en    	Y	Advanced Technology	Adv.Tech.	opuscollege	2012-10-02 18:31:34.489	\N	\N
145	ADVCERT	en    	Y	Advanced Certificate	Adv.Cert.	opuscollege	2012-10-02 18:31:34.489	\N	\N
\.


--
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 329
-- Name: gradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('gradetypeseq', 145, true);


--
-- TOC entry 4855 (class 0 OID 126764)
-- Dependencies: 332
-- Data for Name: groupeddiscipline; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY groupeddiscipline (id, disciplinecode, active, writewho, writewhen, disciplinegroupid) FROM stdin;
1	1	Y	opuscollege	2012-01-31 15:45:32.004405	\N
2	2	Y	opuscollege	2012-01-31 15:45:32.004405	\N
3	3	Y	opuscollege	2012-01-31 15:45:32.004405	\N
4	4	Y	opuscollege	2012-01-31 15:45:32.004405	\N
5	5	Y	opuscollege	2012-01-31 15:45:32.004405	\N
6	6	Y	opuscollege	2012-01-31 15:45:32.004405	\N
7	7	Y	opuscollege	2012-01-31 15:45:32.004405	\N
8	8	Y	opuscollege	2012-01-31 15:45:32.004405	\N
9	9	Y	opuscollege	2012-01-31 15:45:32.004405	\N
10	13	Y	opuscollege	2012-01-31 15:45:32.004405	\N
11	14	Y	opuscollege	2012-01-31 15:45:32.004405	\N
12	9	Y	opuscollege	2012-01-31 15:45:32.004405	\N
13	10	Y	opuscollege	2012-01-31 15:45:32.004405	\N
14	11	Y	opuscollege	2012-01-31 15:45:32.004405	\N
15	12	Y	opuscollege	2012-01-31 15:45:32.004405	\N
16	13	Y	opuscollege	2012-01-31 15:45:32.004405	\N
17	9	Y	opuscollege	2012-01-31 15:45:32.004405	\N
18	10	Y	opuscollege	2012-01-31 15:45:32.004405	\N
19	11	Y	opuscollege	2012-01-31 15:45:32.004405	\N
20	12	Y	opuscollege	2012-01-31 15:45:32.004405	\N
21	13	Y	opuscollege	2012-01-31 15:45:32.004405	\N
22	15	Y	opuscollege	2012-01-31 15:45:32.004405	\N
23	16	Y	opuscollege	2012-01-31 15:45:32.004405	\N
24	17	Y	opuscollege	2012-01-31 15:45:32.004405	\N
25	18	Y	opuscollege	2012-01-31 15:45:32.004405	\N
\.


--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 331
-- Name: groupeddisciplineseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('groupeddisciplineseq', 25, true);


--
-- TOC entry 4857 (class 0 OID 126776)
-- Dependencies: 334
-- Data for Name: groupedsecondaryschoolsubject; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY groupedsecondaryschoolsubject (id, secondaryschoolsubjectid, secondaryschoolsubjectgroupid, active, writewho, writewhen, weight, minimumgradepoint, maximumgradepoint) FROM stdin;
\.


--
-- TOC entry 5311 (class 0 OID 0)
-- Dependencies: 333
-- Name: groupedsecondaryschoolsubjectseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('groupedsecondaryschoolsubjectseq', 468, true);


--
-- TOC entry 4859 (class 0 OID 126791)
-- Dependencies: 336
-- Data for Name: identificationtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY identificationtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
24	1	en    	Y	National Registration Card	opuscollege	2011-03-15 17:17:12.177
25	3	en    	Y	passport	opuscollege	2011-03-15 17:17:12.177
26	4	en    	Y	drivers license	opuscollege	2011-03-15 17:17:12.177
\.


--
-- TOC entry 5312 (class 0 OID 0)
-- Dependencies: 335
-- Name: identificationtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('identificationtypeseq', 26, true);


--
-- TOC entry 4861 (class 0 OID 126803)
-- Dependencies: 338
-- Data for Name: importancetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY importancetype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
5	1	en    	Y	major	opuscollege	2010-11-02 16:22:58.674788
6	2	en    	Y	minor	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4863 (class 0 OID 126815)
-- Dependencies: 340
-- Data for Name: institution; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY institution (id, institutioncode, educationtypecode, institutiondescription, active, provincecode, rector, registrationdate, writewho, writewhen) FROM stdin;
116	UNIV101	3	Universidade Unizambeze	Y	07	\N	2009-11-18	opuscollege	2009-11-18 15:58:13.257641
125	ELEM01	-1	Elementary Test School	Y	02	T.H.E. Nurse	2010-01-01	opuscollege	2011-01-11 10:14:24.658192
124	PRIM01	0	Primary Test School	Y	02	T.H.E. School Leader	2010-01-01	opuscollege	2011-01-11 10:13:08.583358
106	UNIV01	3	Universidade Eduardo Mondlane	Y	05	\N	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
107	UNIV02	3	Universidade Católica de Moçambique	Y	07	\N	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
108	UNIV03	3	Universidade Pedagógica	Y	05	\N	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
109	UNIV04	3	Universidade Mussa Bin Bique 	Y	05	\N	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
110	UNIV05	3	Instituto Superior de Transportes e Comunicações	Y	05	\N	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
111	UNIV00	3	MEC	Y	05	\N	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
120	UNZA01	3	UNZA Lusaka	Y	05	DVC	2010-10-16	opuscollege	2010-10-16 19:37:42.413129
130	I017052011150132	3	Mulungushi	Y	ZM-01		2011-05-17	opuscollege	2011-05-17 15:01:49.570283
121	CBU01	3	CBU Kitwe	Y	ZM-01	DVC	2010-01-01	opuscollege	2011-01-06 15:14:12.959732
142	I022052012150423	3	Universiteit Utrecht	Y	0		2012-05-22	opuscollege	2012-05-22 15:04:51.966442
132	I02909201193450	1	Kitwe secondary school	Y	ZM-02		2011-09-29	opuscollege	2011-09-29 09:35:56.106278
\.


--
-- TOC entry 5313 (class 0 OID 0)
-- Dependencies: 339
-- Name: institutionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('institutionseq', 142, true);


--
-- TOC entry 4865 (class 0 OID 126828)
-- Dependencies: 342
-- Data for Name: language; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY language (id, code, lang, active, description, descriptionshort, writewho, writewhen) FROM stdin;
1517	chi	en    	Y	Chinese	zh 	opuscollege	2010-11-02 16:22:58.674788
1518	dut	en    	Y	Dutch	nl 	opuscollege	2010-11-02 16:22:58.674788
1519	eng	en    	Y	English	en 	opuscollege	2010-11-02 16:22:58.674788
1520	fre	en    	Y	French	fr 	opuscollege	2010-11-02 16:22:58.674788
1521	ger	en    	Y	German	de 	opuscollege	2010-11-02 16:22:58.674788
1522	ita	en    	Y	Italian	it 	opuscollege	2010-11-02 16:22:58.674788
1523	jpn	en    	Y	Japonese	ja 	opuscollege	2010-11-02 16:22:58.674788
1524	por	en    	Y	Portuguese	pt 	opuscollege	2010-11-02 16:22:58.674788
1525	rus	en    	Y	Russian	ru 	opuscollege	2010-11-02 16:22:58.674788
1526	spa	en    	Y	Spanish	es 	opuscollege	2010-11-02 16:22:58.674788
1527	zul	en    	Y	Zulu	zu 	opuscollege	2010-11-02 16:22:58.674788
1528	cha	en    	Y	Changana	ca 	opuscollege	2010-11-02 16:22:58.674788
1529	cho	en    	Y	Chope	co 	opuscollege	2010-11-02 16:22:58.674788
1530	bit	en    	Y	Bitonga	bt 	opuscollege	2010-11-02 16:22:58.674788
1531	cit	en    	Y	Chitsua	ci 	opuscollege	2010-11-02 16:22:58.674788
1532	ron	en    	Y	Ronga	ro 	opuscollege	2010-11-02 16:22:58.674788
1533	sen	en    	Y	Sena	se 	opuscollege	2010-11-02 16:22:58.674788
1534	nda	en    	Y	Ndau	nd 	opuscollege	2010-11-02 16:22:58.674788
1535	nhu	en    	Y	Nhungue	nh 	opuscollege	2010-11-02 16:22:58.674788
1536	tev	en    	Y	Teve	tv 	opuscollege	2010-11-02 16:22:58.674788
1537	coa	en    	Y	Chona	cn 	opuscollege	2010-11-02 16:22:58.674788
1538	nde	en    	Y	Ndevele	nv 	opuscollege	2010-11-02 16:22:58.674788
1539	nja	en    	Y	Nhandja	nj 	opuscollege	2010-11-02 16:22:58.674788
1541	lom	en    	Y	LomuÃ©	lm 	opuscollege	2010-11-02 16:22:58.674788
1542	mac	en    	Y	Macua	mc 	opuscollege	2010-11-02 16:22:58.674788
1543	cot	en    	Y	Coti	ci 	opuscollege	2010-11-02 16:22:58.674788
1544	jaw	en    	Y	Jawa	jw 	opuscollege	2010-11-02 16:22:58.674788
1545	mac	en    	Y	Macondi	mc 	opuscollege	2010-11-02 16:22:58.674788
1546	met	en    	Y	MetÃ³	mt 	opuscollege	2010-11-02 16:22:58.674788
1547	mua	en    	Y	MuanÃ­	mu 	opuscollege	2010-11-02 16:22:58.674788
1548	swa	en    	Y	Swahili	sw 	opuscollege	2010-11-02 16:22:58.674788
1540	chu	en    	Y	Chuabo	cb 	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5314 (class 0 OID 0)
-- Dependencies: 341
-- Name: languageseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('languageseq', 1550, true);


--
-- TOC entry 4867 (class 0 OID 126840)
-- Dependencies: 344
-- Data for Name: levelofeducation; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY levelofeducation (id, code, lang, active, description, writewho, writewhen) FROM stdin;
11	1	en    	Y	No education	opuscollege	2010-11-02 16:22:58.674788
12	2	en    	Y	1.-7. class	opuscollege	2010-11-02 16:22:58.674788
13	3	en    	Y	8.-10. class	opuscollege	2010-11-02 16:22:58.674788
14	4	en    	Y	11.-12. class	opuscollege	2010-11-02 16:22:58.674788
15	5	en    	Y	Everything above	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 343
-- Name: levelofeducationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('levelofeducationseq', 15, true);


--
-- TOC entry 4869 (class 0 OID 126852)
-- Dependencies: 346
-- Data for Name: logmailerror; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY logmailerror (id, recipients, msgsubject, msgsender, errormsg, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 345
-- Name: logmailerrorseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('logmailerrorseq', 12, true);


--
-- TOC entry 4871 (class 0 OID 126867)
-- Dependencies: 348
-- Data for Name: logrequesterror; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY logrequesterror (id, ipaddress, requeststring, errormsg, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 347
-- Name: logrequesterrorseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('logrequesterrorseq', 3, true);


--
-- TOC entry 4873 (class 0 OID 126881)
-- Dependencies: 350
-- Data for Name: lookuptable; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY lookuptable (id, tablename, lookuptype, active, writewho, writewhen) FROM stdin;
12	country	Lookup3	Y	opuscollege	2009-02-05 16:49:32.224762
13	district	Lookup2	Y	opuscollege	2009-02-05 16:49:32.224762
19	frequency	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
20	function	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
25	language	Lookup1	Y	opuscollege	2009-02-05 16:49:32.224762
29	nationality	Lookup1	Y	opuscollege	2009-02-05 16:49:32.224762
30	profession	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
31	province	Lookup5	Y	opuscollege	2009-02-05 16:49:32.224762
35	status	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
52	cardinaltimeunit	Lookup8	Y	opuscollege	2010-07-15 17:31:23.460469
1	academicfield	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
3	addresstype	Lookup	N	opuscollege	2009-02-05 16:49:32.224762
4	administrativepost	Lookup4	Y	opuscollege	2009-02-05 16:49:32.224762
5	appointmenttype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
6	blocktype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
7	bloodtype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
8	civilstatus	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
9	civiltitle	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
10	contractduration	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
11	contracttype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
14	educationtype	Lookup	N	opuscollege	2009-02-05 16:49:32.224762
15	examinationtype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
16	examtype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
17	expellationtype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
18	fieldofeducation	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
24	identificationtype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
26	levelofeducation	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
28	masteringlevel	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
32	relationtype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
33	rigiditytype	Lookup	N	opuscollege	2009-02-05 16:49:32.224762
34	stafftype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
38	studytype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
40	targetgroup	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
41	timeunit	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
42	unitarea	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
43	unittype	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
44	sch_complaintstatus	Lookup	Y	opuscollege	2009-02-06 13:56:29.988612
45	sch_decisioncriteria	Lookup	Y	opuscollege	2009-02-06 13:56:29.988612
46	sch_scholarshiptype	Lookup	Y	opuscollege	2009-02-06 13:56:29.988612
47	sch_subsidytype	Lookup	Y	opuscollege	2009-02-06 13:56:29.988612
54	daypart	Lookup	Y	opuscollege	2010-08-23 21:24:25.337485
55	thesisstatus	Lookup	Y	opuscollege	2010-08-24 17:14:40.57965
57	studyplanstatus	Lookup	Y	opuscollege	2010-09-21 14:22:40.525563
58	studentstatus	Lookup	Y	opuscollege	2010-12-14 10:11:35.803464
60	rfcstatus	Lookup	Y	opuscollege	2011-02-22 16:28:26.807376
61	cardinaltimeunitstatus	Lookup	Y	opuscollege	2011-05-25 15:04:54.68875
62	endgradetype	Lookup	N	opuscollege	2011-07-04 15:15:11.416496
65	applicantcategory	Lookup	Y	opuscollege	2011-11-17 15:20:10.898813
66	nationalitygroup	Lookup	Y	opuscollege	2011-11-17 15:20:10.898813
59	progressstatus	Lookup7	N	opuscollege	2010-12-22 16:33:12.327227
69	studyintensity	Lookup	N	opuscollege	2011-12-07 18:09:47.476359
72	sch_sponsortype	Lookup6	Y	opuscollege	2011-12-12 13:42:43.252596
22	gender	Lookup	N	opuscollege	2009-02-05 16:49:32.224762
39	importancetype	Lookup	N	opuscollege	2009-02-05 16:49:32.224762
74	discipline	Lookup	Y	opuscollege	2012-01-31 10:50:25.014384
75	disciplinegroup	Lookup	Y	opuscollege	2012-01-31 15:47:27.508174
21	functionlevel	Lookup	Y	opuscollege	2009-02-05 16:49:32.224762
70	fee_feecategory	Lookup	N	opuscollege	2011-12-12 13:35:06.086237
37	studytime	Lookup	N	opuscollege	2009-02-05 16:49:32.224762
36	studyform	Lookup	N	opuscollege	2009-02-05 16:49:32.224762
77	acc_roomtype	Lookup	Y	opuscollege	2012-10-02 18:31:34.489
78	acc_hosteltype	Lookup	Y	opuscollege	2012-10-02 18:31:34.489
76	penaltytype	Lookup	Y	opuscollege	2012-04-16 14:01:11.752894
79	educationlevel	Lookup	Y	opuscollege	2014-03-05 14:59:12.908
80	educationarea	Lookup	Y	opuscollege	2014-03-05 14:59:12.908
81	gradetype	Lookup9	Y	opuscollege	2014-03-05 14:59:12.908
\.


--
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 349
-- Name: lookuptableseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('lookuptableseq', 81, true);


--
-- TOC entry 4875 (class 0 OID 126893)
-- Dependencies: 352
-- Data for Name: mailconfig; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY mailconfig (id, msgtype, msgsubject, msgbody, msgsender, lang, writewho, writewhen) FROM stdin;
1	rejected_admission	Your request for admission has been denied	Unfortunately your request for admission has been denied.<br />Please contact the dean of the school or the academic office for more information.	academicoffice@unza.zm	en    	opuscollege	2012-01-03 16:09:04.664241
2	rejected_admission	Your request for admission has been denied	Unfortunately your request for admission has been denied.<br />Please contact the dean of the school or the academic office for more information.	academicoffice@unza.zm	en_ZM 	opuscollege	2012-01-03 16:09:04.664241
3	approved_admission	Your request for admission has been granted	Your request for admission has been granted.<br />Please contact the dean of the school or the academic office for more information on how to proceed.	academicoffice@unza.zm	en    	opuscollege	2012-01-03 16:09:04.664241
4	approved_admission	Your request for admission has been granted	Your request for admission has been granted.<br />Please contact the dean of the school or the academic office for more information on how to proceed.	academicoffice@unza.zm	en_ZM 	opuscollege	2012-01-03 16:09:04.664241
5	rejected_registration	Your request for registration has been denied	Unfortunately your request for registration has been denied.<br />Please contact the dean of the school for more information.	registry@unza.zm	en    	opuscollege	2012-01-03 16:09:04.664241
6	rejected_registration	Your request for registration has been denied	Unfortunately your request for registration has been denied.<br />Please contact the dean of the school for more information.	registry@unza.zm	en_ZM 	opuscollege	2012-01-03 16:09:04.664241
7	actively_registered	Your request for registration has been granted	Your request for registration has been granted.<br />Please contact the dean of the school for more information on how to proceed.	registry@unza.zm	en    	opuscollege	2012-01-03 16:09:04.664241
8	actively_registered	Your request for registration has been granted	Your request for registration has been granted.<br />Please contact the dean of the school for more information on how to proceed.	registry@unza.zm	en_ZM 	opuscollege	2012-01-03 16:09:04.664241
9	customize_programme	Your request for registration is in customize programme phase	Your request for registration is in customize programme phase.<br />Please login to the unza website and review the courses you are subscribed to.	registry@unza.zm	en    	opuscollege	2012-01-03 16:09:04.664241
10	customize_programme	Your request for registration is in customize programme phase	Your request for registration is in customize programme phase.<br />Please login to the unza website and review the courses you are subscribed to.	registry@unza.zm	en_ZM 	opuscollege	2012-01-03 16:09:04.664241
11	waitingforpayment_admission	Your request for admission has been set to status waiting-for-payment.	Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the application form and pay the application fee.	academicoffice@unza.zm	en    	opuscollege	2012-04-03 14:00:36.224466
12	waitingforpayment_admission	Your request for admission has been set to status waiting-for-payment.	Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the application form and pay the application fee.	academicoffice@unza.zm	en_ZM 	opuscollege	2012-04-03 14:00:36.224466
13	waitingforselection_admission	Your request for admission has been set to status waiting-for-selection.	Your request for admission has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.	academicoffice@unza.zm	en    	opuscollege	2012-04-03 14:00:36.224466
14	waitingforselection_admission	Your request for admission has been set to status waiting-for-selection.	Your request for admission has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.	academicoffice@unza.zm	en_ZM 	opuscollege	2012-04-03 14:00:36.224466
15	waitingforpayment_registration	Your request for continued registration has been set to status waiting-for-payment.	Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the continued registration form and pay the registration fees.	registry@unza.zm	en    	opuscollege	2012-04-03 14:00:36.224466
16	waitingforpayment_registration	Your request for continued registration has been set to status waiting-for-payment.	Your request for admission has been set to status waiting-for-payment.<br />Please go to the bank with the continued registration form and pay the registration fees.	registry@unza.zm	en_ZM 	opuscollege	2012-04-03 14:00:36.224466
17	waitingforselection_registration	Your request for continued registration has been set to status waiting-for-selection.	Your request for continued registration has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.	registry@unza.zm	en    	opuscollege	2012-04-03 14:00:36.224466
18	waitingforselection_registration	Your request for continued registration has been set to status waiting-for-selection.	Your request for continued registration has been set to status waiting-for-selection.<br />Your payment has been received and you are now awaiting the selection by the university.	registry@unza.zm	en_ZM 	opuscollege	2012-04-03 14:00:36.224466
19	waitingforapproval_registration	Your request for continued registration has been set to status waiting-for-approval.	Your request for continued registration has been set to status waiting-for-approval.<br />You have been positively selected and you are now awaiting the formal approval of the university.	registry@unza.zm	en    	opuscollege	2012-04-03 14:00:36.224466
20	waitingforapproval_registration	Your request for continued registration has been set to status waiting-for-approval.	Your request for continued registration has been set to status waiting-for-approval.<br />You have been positively selected and you are now awaiting the formal approval of the university.	registry@unza.zm	en_ZM 	opuscollege	2012-04-03 14:00:36.224466
21	requestforchange_registration	Your request for continued registration has been set to status request-for-change.	Your request for continued registration has been set to status request-for-change.<br />Your request for change has been received by the corresponding officer at the university.	registry@unza.zm	en    	opuscollege	2012-04-03 14:00:36.224466
22	requestforchange_registration	Your request for continued registration has been set to status request-for-change.	Your request for continued registration has been set to status request-for-change.\r\nYour request for change has been received by the corresponding officer at the university.	registry@unza.zm	en_ZM 	opuscollege	2012-04-03 14:00:36.224466
\.


--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 351
-- Name: mailconfigseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('mailconfigseq', 22, true);


--
-- TOC entry 4877 (class 0 OID 126908)
-- Dependencies: 354
-- Data for Name: masteringlevel; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY masteringlevel (id, code, lang, active, description, writewho, writewhen) FROM stdin;
7	1	en    	Y	fluent	opuscollege	2010-11-02 16:22:58.674788
8	2	en    	Y	basic	opuscollege	2010-11-02 16:22:58.674788
9	3	en    	Y	poor	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5320 (class 0 OID 0)
-- Dependencies: 353
-- Name: masteringlevelseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('masteringlevelseq', 9, true);


--
-- TOC entry 4879 (class 0 OID 126920)
-- Dependencies: 356
-- Data for Name: nationality; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY nationality (id, code, lang, active, descriptionshort, description, writewho, writewhen) FROM stdin;
265	1	en    	Y	AFG       	Afghan	opuscollege	2010-11-02 16:22:58.674788
266	2	en    	Y	ALB       	Albanian	opuscollege	2010-11-02 16:22:58.674788
267	3	en    	Y	ALG       	Algerian	opuscollege	2010-11-02 16:22:58.674788
268	4	en    	Y	AME       	American (US)	opuscollege	2010-11-02 16:22:58.674788
269	5	en    	Y	ANG       	Angolan	opuscollege	2010-11-02 16:22:58.674788
270	6	en    	Y	ARG       	Argentine	opuscollege	2010-11-02 16:22:58.674788
271	7	en    	Y	AUS       	Australian	opuscollege	2010-11-02 16:22:58.674788
272	8	en    	Y	AUT       	Austrian	opuscollege	2010-11-02 16:22:58.674788
273	9	en    	Y	BAN       	Bangladeshian	opuscollege	2010-11-02 16:22:58.674788
274	10	en    	Y	BLR       	Belarusian	opuscollege	2010-11-02 16:22:58.674788
275	11	en    	Y	BEL       	Belgian	opuscollege	2010-11-02 16:22:58.674788
276	12	en    	Y	BEN       	Beninese	opuscollege	2010-11-02 16:22:58.674788
277	13	en    	Y	BOL       	Bolivian	opuscollege	2010-11-02 16:22:58.674788
278	14	en    	Y	BOS       	Bosnian	opuscollege	2010-11-02 16:22:58.674788
279	15	en    	Y	BOT       	Botswanian	opuscollege	2010-11-02 16:22:58.674788
280	16	en    	Y	BRA       	Brazilian	opuscollege	2010-11-02 16:22:58.674788
281	17	en    	Y	BRI       	British	opuscollege	2010-11-02 16:22:58.674788
282	18	en    	Y	BUL       	Bulgarian	opuscollege	2010-11-02 16:22:58.674788
283	19	en    	Y	BRK       	Burkinese (B. Fasso)	opuscollege	2010-11-02 16:22:58.674788
284	20	en    	Y	BRM       	Burmese	opuscollege	2010-11-02 16:22:58.674788
285	21	en    	Y	BRN       	Burundese	opuscollege	2010-11-02 16:22:58.674788
286	22	en    	Y	CMB       	Cambodian	opuscollege	2010-11-02 16:22:58.674788
287	23	en    	Y	CAM       	Cameroonian	opuscollege	2010-11-02 16:22:58.674788
288	24	en    	Y	CAN       	Canadian	opuscollege	2010-11-02 16:22:58.674788
289	25	en    	Y	CAF       	Central African	opuscollege	2010-11-02 16:22:58.674788
290	26	en    	Y	CHA       	Chadian	opuscollege	2010-11-02 16:22:58.674788
291	27	en    	Y	CHI       	Chilean	opuscollege	2010-11-02 16:22:58.674788
292	28	en    	Y	CHI       	Chinese	opuscollege	2010-11-02 16:22:58.674788
293	29	en    	Y	COL       	Colombian	opuscollege	2010-11-02 16:22:58.674788
294	30	en    	Y	CNB       	Congolese (Brazaville)	opuscollege	2010-11-02 16:22:58.674788
295	31	en    	Y	CNC       	Congolese (DR Congo)	opuscollege	2010-11-02 16:22:58.674788
296	32	en    	Y	CRO       	Croatian	opuscollege	2010-11-02 16:22:58.674788
297	33	en    	Y	CUB       	Cuban	opuscollege	2010-11-02 16:22:58.674788
298	34	en    	Y	DAN       	Danish	opuscollege	2010-11-02 16:22:58.674788
299	35	en    	Y	DOM       	Dominican Republican	opuscollege	2010-11-02 16:22:58.674788
300	36	en    	Y	DUT       	Dutch	opuscollege	2010-11-02 16:22:58.674788
301	37	en    	Y	ECU       	Ecuadorian	opuscollege	2010-11-02 16:22:58.674788
302	38	en    	Y	EGY       	Egyptian	opuscollege	2010-11-02 16:22:58.674788
303	39	en    	Y	EQU       	Equatorial Guinean	opuscollege	2010-11-02 16:22:58.674788
304	40	en    	Y	ERI       	Eritrean	opuscollege	2010-11-02 16:22:58.674788
305	41	en    	Y	EST       	Estonian	opuscollege	2010-11-02 16:22:58.674788
306	42	en    	Y	ETH       	Ethiopian	opuscollege	2010-11-02 16:22:58.674788
307	43	en    	Y	FIL       	Fillipino	opuscollege	2010-11-02 16:22:58.674788
308	44	en    	Y	FIN       	Finnish	opuscollege	2010-11-02 16:22:58.674788
309	45	en    	Y	FRE       	French	opuscollege	2010-11-02 16:22:58.674788
310	46	en    	Y	GAB       	Gabonese	opuscollege	2010-11-02 16:22:58.674788
311	47	en    	Y	GAM       	Gambian	opuscollege	2010-11-02 16:22:58.674788
312	48	en    	Y	GER       	German	opuscollege	2010-11-02 16:22:58.674788
313	49	en    	Y	GHA       	Ghanese	opuscollege	2010-11-02 16:22:58.674788
314	50	en    	Y	GRE       	Greek	opuscollege	2010-11-02 16:22:58.674788
315	51	en    	Y	GUI       	Guinean	opuscollege	2010-11-02 16:22:58.674788
316	52	en    	Y	GUY       	Guyanese	opuscollege	2010-11-02 16:22:58.674788
317	53	en    	Y	HAI       	Haitian	opuscollege	2010-11-02 16:22:58.674788
318	54	en    	Y	HUN       	Hungarian	opuscollege	2010-11-02 16:22:58.674788
319	55	en    	Y	ICE       	Icelandian	opuscollege	2010-11-02 16:22:58.674788
320	56	en    	Y	IND       	Indian	opuscollege	2010-11-02 16:22:58.674788
321	57	en    	Y	IDN       	Indonesian	opuscollege	2010-11-02 16:22:58.674788
322	58	en    	Y	IRN       	Iranian	opuscollege	2010-11-02 16:22:58.674788
323	59	en    	Y	IRA       	Iraqi	opuscollege	2010-11-02 16:22:58.674788
324	60	en    	Y	IRE       	Irish	opuscollege	2010-11-02 16:22:58.674788
325	61	en    	Y	ITA       	Italian	opuscollege	2010-11-02 16:22:58.674788
326	62	en    	Y	IVO       	Ivory Coastan	opuscollege	2010-11-02 16:22:58.674788
327	63	en    	Y	JAM       	Jamaican	opuscollege	2010-11-02 16:22:58.674788
328	64	en    	Y	JAP       	Japanese	opuscollege	2010-11-02 16:22:58.674788
329	65	en    	Y	JEW       	Jewish (Israel)	opuscollege	2010-11-02 16:22:58.674788
330	66	en    	Y	JOR       	Jordanian	opuscollege	2010-11-02 16:22:58.674788
331	67	en    	Y	KAZ       	Kazakhstanian	opuscollege	2010-11-02 16:22:58.674788
332	68	en    	Y	KYRG      	Kyrgyzistanian	opuscollege	2010-11-02 16:22:58.674788
333	69	en    	Y	KEN       	Kenian	opuscollege	2010-11-02 16:22:58.674788
334	70	en    	Y	LA        	Laotian	opuscollege	2010-11-02 16:22:58.674788
335	71	en    	Y	LAT       	Latvian (Lettish)	opuscollege	2010-11-02 16:22:58.674788
336	72	en    	Y	LEB       	Lebanese	opuscollege	2010-11-02 16:22:58.674788
337	73	en    	Y	LES       	Lesothan	opuscollege	2010-11-02 16:22:58.674788
338	74	en    	Y	LIB       	Liberian	opuscollege	2010-11-02 16:22:58.674788
339	75	en    	Y	LIT       	Lituanian	opuscollege	2010-11-02 16:22:58.674788
340	76	en    	Y	MLW       	Malawian	opuscollege	2010-11-02 16:22:58.674788
341	77	en    	Y	MLS       	Malasian	opuscollege	2010-11-02 16:22:58.674788
342	78	en    	Y	MAL       	Malian	opuscollege	2010-11-02 16:22:58.674788
343	79	en    	Y	MAU       	Mauritanian	opuscollege	2010-11-02 16:22:58.674788
344	80	en    	Y	MEX       	Mexican	opuscollege	2010-11-02 16:22:58.674788
345	81	en    	Y	MOL       	Moldavian	opuscollege	2010-11-02 16:22:58.674788
346	82	en    	Y	MON       	Mongolian	opuscollege	2010-11-02 16:22:58.674788
347	83	en    	Y	MOR       	Morrocan	opuscollege	2010-11-02 16:22:58.674788
348	84	en    	Y	NAM       	Namibian	opuscollege	2010-11-02 16:22:58.674788
349	85	en    	Y	NEP       	Nepalese	opuscollege	2010-11-02 16:22:58.674788
350	86	en    	Y	NWG       	New Guinean	opuscollege	2010-11-02 16:22:58.674788
351	87	en    	Y	NWZ       	New Zealandian	opuscollege	2010-11-02 16:22:58.674788
352	88	en    	Y	NGA       	Nigerian (Nigeria)	opuscollege	2010-11-02 16:22:58.674788
353	89	en    	Y	NGE       	Nigerees (Niger)	opuscollege	2010-11-02 16:22:58.674788
354	90	en    	Y	NOR       	Norvegian	opuscollege	2010-11-02 16:22:58.674788
355	91	en    	Y	OMA       	Omani	opuscollege	2010-11-02 16:22:58.674788
356	92	en    	Y	PAK       	Pakistani	opuscollege	2010-11-02 16:22:58.674788
357	93	en    	Y	PAR       	Paraguayan	opuscollege	2010-11-02 16:22:58.674788
358	94	en    	Y	PER       	Peruvian	opuscollege	2010-11-02 16:22:58.674788
359	95	en    	Y	POL       	Polish	opuscollege	2010-11-02 16:22:58.674788
360	96	en    	Y	PRT       	Portuguese	opuscollege	2010-11-02 16:22:58.674788
361	97	en    	Y	PUE       	PuertoRican	opuscollege	2010-11-02 16:22:58.674788
362	98	en    	Y	ROM       	Romanian	opuscollege	2010-11-02 16:22:58.674788
363	99	en    	Y	RUS       	Russian	opuscollege	2010-11-02 16:22:58.674788
364	100	en    	Y	RSQ       	Rwandese	opuscollege	2010-11-02 16:22:58.674788
365	101	en    	Y	SAU       	Saudi Arabian	opuscollege	2010-11-02 16:22:58.674788
366	102	en    	Y	SEN       	Senegalese	opuscollege	2010-11-02 16:22:58.674788
367	103	en    	Y	SER       	Serbian	opuscollege	2010-11-02 16:22:58.674788
368	104	en    	Y	SIE       	Sierra Leonian	opuscollege	2010-11-02 16:22:58.674788
369	105	en    	Y	SIN       	Singaporean	opuscollege	2010-11-02 16:22:58.674788
370	106	en    	Y	SLO       	Slovenian	opuscollege	2010-11-02 16:22:58.674788
371	107	en    	Y	SOM       	Somalian	opuscollege	2010-11-02 16:22:58.674788
372	108	en    	Y	SAF       	South African	opuscollege	2010-11-02 16:22:58.674788
373	109	en    	Y	ESP       	Spanish	opuscollege	2010-11-02 16:22:58.674788
374	110	en    	Y	SUD       	Sudanese	opuscollege	2010-11-02 16:22:58.674788
375	111	en    	Y	SUR       	Surinamese	opuscollege	2010-11-02 16:22:58.674788
376	112	en    	Y	SYR       	Syrian	opuscollege	2010-11-02 16:22:58.674788
377	113	en    	Y	SWA       	Swazilandean	opuscollege	2010-11-02 16:22:58.674788
378	114	en    	Y	SWE       	Swedish	opuscollege	2010-11-02 16:22:58.674788
379	115	en    	Y	SWI       	Swiss	opuscollege	2010-11-02 16:22:58.674788
380	116	en    	Y	TAJ       	Tajikistanian	opuscollege	2010-11-02 16:22:58.674788
381	117	en    	Y	TAN       	Tanzanian	opuscollege	2010-11-02 16:22:58.674788
382	118	en    	Y	THA       	Thai	opuscollege	2010-11-02 16:22:58.674788
383	119	en    	Y	TOG       	Togolese	opuscollege	2010-11-02 16:22:58.674788
384	120	en    	Y	TUN       	Tunisian	opuscollege	2010-11-02 16:22:58.674788
385	121	en    	Y	TUR       	Turkish	opuscollege	2010-11-02 16:22:58.674788
386	122	en    	Y	TKM       	Turkmenistanian	opuscollege	2010-11-02 16:22:58.674788
387	123	en    	Y	UGA       	Ugandan	opuscollege	2010-11-02 16:22:58.674788
388	124	en    	Y	UKR       	Ukranian	opuscollege	2010-11-02 16:22:58.674788
389	125	en    	Y	URU       	Uruguayan	opuscollege	2010-11-02 16:22:58.674788
390	126	en    	Y	UZB       	Uzbek	opuscollege	2010-11-02 16:22:58.674788
391	127	en    	Y	VEN       	Venezuelan	opuscollege	2010-11-02 16:22:58.674788
392	128	en    	Y	VIE       	Vietnamese	opuscollege	2010-11-02 16:22:58.674788
393	129	en    	Y	YEM       	Yemenite	opuscollege	2010-11-02 16:22:58.674788
394	130	en    	Y	ZAM       	Zambian	opuscollege	2010-11-02 16:22:58.674788
395	131	en    	Y	ZIM       	Zimbabwean	opuscollege	2010-11-02 16:22:58.674788
396	132	en    	Y	MOZ       	Mozambican	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4881 (class 0 OID 126932)
-- Dependencies: 358
-- Data for Name: nationalitygroup; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY nationalitygroup (id, code, lang, active, description, writewho, writewhen) FROM stdin;
3	SADC	en	Y	SADC	opuscollege	2011-12-12 13:46:13.271927
4	OTNA	en	Y	Other National	opuscollege	2011-12-12 13:46:13.271927
\.


--
-- TOC entry 5321 (class 0 OID 0)
-- Dependencies: 357
-- Name: nationalitygroupseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('nationalitygroupseq', 4, true);


--
-- TOC entry 5322 (class 0 OID 0)
-- Dependencies: 355
-- Name: nationalityseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('nationalityseq', 398, true);


--
-- TOC entry 4695 (class 0 OID 125656)
-- Dependencies: 172
-- Data for Name: node_relationships_n_level; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY node_relationships_n_level (id, organizationalunitcode, organizationalunitdescription, active, branchid, unitlevel, parentorganizationalunitid, unitareacode, unittypecode, academicfieldcode, directorid, registrationdate, writewho, writewhen, level) FROM stdin;
\.


--
-- TOC entry 4883 (class 0 OID 126944)
-- Dependencies: 360
-- Data for Name: obtainedqualification; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY obtainedqualification (id, studyplanid, university, startdate, enddate, qualification, endgradedate, gradetypecode, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5323 (class 0 OID 0)
-- Dependencies: 359
-- Name: obtainedqualificationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('obtainedqualificationseq', 24, true);


--
-- TOC entry 4885 (class 0 OID 126956)
-- Dependencies: 362
-- Data for Name: opusprivilege; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY opusprivilege (id, code, lang, active, description, writewho, writewhen, validfrom, validthrough) FROM stdin;
306	ADMINISTER_SYSTEM	nl    	Y	Perform changes on system configuration 	opuscollege	2011-05-03 11:30:21.74826	\N	\N
307	GENERATE_STUDENT_REPORTS	nl    	Y	Generate student reports	opuscollege	2011-05-03 11:30:21.74826	\N	\N
308	GENERATE_STATISTICS	nl    	Y	Generate statistics	opuscollege	2011-05-03 11:30:21.74826	\N	\N
309	DELETE_ACADEMIC_YEARS	nl    	Y	Delete academic years	opuscollege	2011-05-03 11:30:21.74826	\N	\N
310	DELETE_BRANCHES	nl    	Y	Delete branches	opuscollege	2011-05-03 11:30:21.74826	\N	\N
311	DELETE_EXAMS	nl    	Y	Delete exams	opuscollege	2011-05-03 11:30:21.74826	\N	\N
312	DELETE_FEES	nl    	Y	Delete fees	opuscollege	2011-05-03 11:30:21.74826	\N	\N
313	DELETE_INSTITUTIONS	nl    	Y	Delete institutions	opuscollege	2011-05-03 11:30:21.74826	\N	\N
314	DELETE_LOOKUPS	nl    	Y	Delete lookups	opuscollege	2011-05-03 11:30:21.74826	\N	\N
315	DELETE_ORGANIZATIONS	nl    	Y	Delete organizations	opuscollege	2011-05-03 11:30:21.74826	\N	\N
316	DELETE_ORG_UNITS	nl    	Y	Delete organizational units	opuscollege	2011-05-03 11:30:21.74826	\N	\N
317	DELETE_ROLES	nl    	Y	Delete roles 	opuscollege	2011-05-03 11:30:21.74826	\N	\N
318	DELETE_STAFF_MEMBERS	nl    	Y	Delete staff members	opuscollege	2011-05-03 11:30:21.74826	\N	\N
319	DELETE_STUDENTS	nl    	Y	Delete students	opuscollege	2011-05-03 11:30:21.74826	\N	\N
320	DELETE_STUDIES	nl    	Y	Delete studies	opuscollege	2011-05-03 11:30:21.74826	\N	\N
321	DELETE_STUDY_PLANS	nl    	Y	Delete study plans	opuscollege	2011-05-03 11:30:21.74826	\N	\N
322	DELETE_SUBJECTS	nl    	Y	Delete subjects	opuscollege	2011-05-03 11:30:21.74826	\N	\N
323	DELETE_USER_ROLES	nl    	Y	Remove roles form users	opuscollege	2011-05-03 11:30:21.74826	\N	\N
327	READ_ACADEMIC_YEARS	nl    	Y	View academic years	opuscollege	2011-05-03 11:30:21.74826	\N	\N
328	READ_ADMIN_MENU	nl    	Y	View the admin menu	opuscollege	2011-05-03 11:30:21.74826	\N	\N
329	READ_ALUMNI_MENU	nl    	Y	View the alumni menu	opuscollege	2011-05-03 11:30:21.74826	\N	\N
330	READ_BRANCHES	nl    	Y	View branches	opuscollege	2011-05-03 11:30:21.74826	\N	\N
331	READ_EXAMS	nl    	Y	View exams	opuscollege	2011-05-03 11:30:21.74826	\N	\N
332	READ_FEE_MENU	nl    	Y	View the fees menu	opuscollege	2011-05-03 11:30:21.74826	\N	\N
333	READ_FEES	nl    	Y	View fees	opuscollege	2011-05-03 11:30:21.74826	\N	\N
334	READ_INSTITUTIONS	nl    	Y	View institutions	opuscollege	2011-05-03 11:30:21.74826	\N	\N
335	READ_INSTITUTIONS_MENU	nl    	Y	View the institutions menu	opuscollege	2011-05-03 11:30:21.74826	\N	\N
336	READ_LOOKUPS	nl    	Y	View lookups	opuscollege	2011-05-03 11:30:21.74826	\N	\N
337	READ_ORGANIZATIONS	nl    	Y	View organizations	opuscollege	2011-05-03 11:30:21.74826	\N	\N
338	READ_ORGANIZATIONS_MENU	nl    	Y	View the organizations menu	opuscollege	2011-05-03 11:30:21.74826	\N	\N
339	READ_ORG_UNITS	nl    	Y	View organizational units	opuscollege	2011-05-03 11:30:21.74826	\N	\N
340	READ_REPORT_MENU	nl    	Y	View the report menu	opuscollege	2011-05-03 11:30:21.74826	\N	\N
341	READ_RESULTS_MENU	nl    	Y	View the institutions menu	opuscollege	2011-05-03 11:30:21.74826	\N	\N
342	READ_ROLES	nl    	Y	View roles	opuscollege	2011-05-03 11:30:21.74826	\N	\N
343	READ_SCHOLARSHIP_MENU	nl    	Y	View the scholarships menu	opuscollege	2011-05-03 11:30:21.74826	\N	\N
344	READ_STAFF_MEMBERS	nl    	Y	View Staff members	opuscollege	2011-05-03 11:30:21.74826	\N	\N
345	READ_STAFF_MEMBERS_MENU	nl    	Y	View the staff members menu	opuscollege	2011-05-03 11:30:21.74826	\N	\N
346	READ_STUDENTS	nl    	Y	View students	opuscollege	2011-05-03 11:30:21.74826	\N	\N
347	READ_STUDENTS_MENU	nl    	Y	View the students menu	opuscollege	2011-05-03 11:30:21.74826	\N	\N
348	READ_STUDIES	nl    	Y	View studies	opuscollege	2011-05-03 11:30:21.74826	\N	\N
349	READ_STUDIES_MENU	nl    	Y	View the studies menu	opuscollege	2011-05-03 11:30:21.74826	\N	\N
350	READ_STUDY_PLANS	nl    	Y	View study plans	opuscollege	2011-05-03 11:30:21.74826	\N	\N
351	READ_SUBJECTS	nl    	Y	View subjects	opuscollege	2011-05-03 11:30:21.74826	\N	\N
352	READ_USER_ROLES	nl    	Y	View what roles users are assigned to	opuscollege	2011-05-03 11:30:21.74826	\N	\N
353	WRITE_ACADEMIC_YEARS	nl    	Y	Add and modify academic years	opuscollege	2011-05-03 11:30:21.74826	\N	\N
354	WRITE_BRANCHES	nl    	Y	Add and modify branches	opuscollege	2011-05-03 11:30:21.74826	\N	\N
355	WRITE_EXAMS	nl    	Y	Add and modify Exams	opuscollege	2011-05-03 11:30:21.74826	\N	\N
356	WRITE_FEES	nl    	Y	Edit fees	opuscollege	2011-05-03 11:30:21.74826	\N	\N
357	WRITE_INSTITUTIONS	nl    	Y	Add and modify institutions	opuscollege	2011-05-03 11:30:21.74826	\N	\N
358	WRITE_LOOKUPS	nl    	Y	Add and modify lookups	opuscollege	2011-05-03 11:30:21.74826	\N	\N
359	WRITE_ORGANIZATIONS	nl    	Y	Write organizations	opuscollege	2011-05-03 11:30:21.74826	\N	\N
360	WRITE_ORG_UNITS	nl    	Y	And and modify organizational units	opuscollege	2011-05-03 11:30:21.74826	\N	\N
361	WRITE_ROLES	nl    	Y	Add and update roles 	opuscollege	2011-05-03 11:30:21.74826	\N	\N
362	WRITE_STAFF_MEMBERS	nl    	Y	Add and modify staff members	opuscollege	2011-05-03 11:30:21.74826	\N	\N
363	WRITE_STUDENTS	nl    	Y	Add and modify students	opuscollege	2011-05-03 11:30:21.74826	\N	\N
364	WRITE_STUDIES	nl    	Y	Add and modify studies	opuscollege	2011-05-03 11:30:21.74826	\N	\N
365	WRITE_STUDY_PLANS	nl    	Y	Add and modify study plans	opuscollege	2011-05-03 11:30:21.74826	\N	\N
366	WRITE_SUBJECTS	nl    	Y	Add and modify subjects	opuscollege	2011-05-03 11:30:21.74826	\N	\N
367	WRITE_USER_ROLES	nl    	Y	Assign roles to users 	opuscollege	2011-05-03 11:30:21.74826	\N	\N
368	TRANSFER_CURRICULUM	nl    	Y	Transfer curriculum	opuscollege	2011-05-03 11:30:21.74826	\N	\N
369	TRANSFER_STUDENTS	nl    	Y	Transfer students	opuscollege	2011-05-03 11:30:21.74826	\N	\N
370	ADMINISTER_SYSTEM	pt    	Y	Perform changes on system configuration 	opuscollege	2011-05-03 11:30:35.67174	\N	\N
371	GENERATE_STUDENT_REPORTS	pt    	Y	Generate student reports	opuscollege	2011-05-03 11:30:35.67174	\N	\N
372	GENERATE_STATISTICS	pt    	Y	Generate statistics	opuscollege	2011-05-03 11:30:35.67174	\N	\N
373	DELETE_ACADEMIC_YEARS	pt    	Y	Delete academic years	opuscollege	2011-05-03 11:30:35.67174	\N	\N
374	DELETE_BRANCHES	pt    	Y	Delete branches	opuscollege	2011-05-03 11:30:35.67174	\N	\N
375	DELETE_EXAMS	pt    	Y	Delete exams	opuscollege	2011-05-03 11:30:35.67174	\N	\N
376	DELETE_FEES	pt    	Y	Delete fees	opuscollege	2011-05-03 11:30:35.67174	\N	\N
377	DELETE_INSTITUTIONS	pt    	Y	Delete institutions	opuscollege	2011-05-03 11:30:35.67174	\N	\N
378	DELETE_LOOKUPS	pt    	Y	Delete lookups	opuscollege	2011-05-03 11:30:35.67174	\N	\N
379	DELETE_ORGANIZATIONS	pt    	Y	Delete organizations	opuscollege	2011-05-03 11:30:35.67174	\N	\N
380	DELETE_ORG_UNITS	pt    	Y	Delete organizational units	opuscollege	2011-05-03 11:30:35.67174	\N	\N
381	DELETE_ROLES	pt    	Y	Delete roles 	opuscollege	2011-05-03 11:30:35.67174	\N	\N
382	DELETE_STAFF_MEMBERS	pt    	Y	Delete staff members	opuscollege	2011-05-03 11:30:35.67174	\N	\N
383	DELETE_STUDENTS	pt    	Y	Delete students	opuscollege	2011-05-03 11:30:35.67174	\N	\N
384	DELETE_STUDIES	pt    	Y	Delete studies	opuscollege	2011-05-03 11:30:35.67174	\N	\N
385	DELETE_STUDY_PLANS	pt    	Y	Delete study plans	opuscollege	2011-05-03 11:30:35.67174	\N	\N
386	DELETE_SUBJECTS	pt    	Y	Delete subjects	opuscollege	2011-05-03 11:30:35.67174	\N	\N
387	DELETE_USER_ROLES	pt    	Y	Remove roles form users	opuscollege	2011-05-03 11:30:35.67174	\N	\N
391	READ_ACADEMIC_YEARS	pt    	Y	View academic years	opuscollege	2011-05-03 11:30:35.67174	\N	\N
392	READ_ADMIN_MENU	pt    	Y	View the admin menu	opuscollege	2011-05-03 11:30:35.67174	\N	\N
393	READ_ALUMNI_MENU	pt    	Y	View the alumni menu	opuscollege	2011-05-03 11:30:35.67174	\N	\N
394	READ_BRANCHES	pt    	Y	View branches	opuscollege	2011-05-03 11:30:35.67174	\N	\N
395	READ_EXAMS	pt    	Y	View exams	opuscollege	2011-05-03 11:30:35.67174	\N	\N
396	READ_FEE_MENU	pt    	Y	View the fees menu	opuscollege	2011-05-03 11:30:35.67174	\N	\N
397	READ_FEES	pt    	Y	View fees	opuscollege	2011-05-03 11:30:35.67174	\N	\N
398	READ_INSTITUTIONS	pt    	Y	View institutions	opuscollege	2011-05-03 11:30:35.67174	\N	\N
399	READ_INSTITUTIONS_MENU	pt    	Y	View the institutions menu	opuscollege	2011-05-03 11:30:35.67174	\N	\N
400	READ_LOOKUPS	pt    	Y	View lookups	opuscollege	2011-05-03 11:30:35.67174	\N	\N
401	READ_ORGANIZATIONS	pt    	Y	View organizations	opuscollege	2011-05-03 11:30:35.67174	\N	\N
402	READ_ORGANIZATIONS_MENU	pt    	Y	View the organizations menu	opuscollege	2011-05-03 11:30:35.67174	\N	\N
403	READ_ORG_UNITS	pt    	Y	View organizational units	opuscollege	2011-05-03 11:30:35.67174	\N	\N
404	READ_REPORT_MENU	pt    	Y	View the report menu	opuscollege	2011-05-03 11:30:35.67174	\N	\N
405	READ_RESULTS_MENU	pt    	Y	View the institutions menu	opuscollege	2011-05-03 11:30:35.67174	\N	\N
406	READ_ROLES	pt    	Y	View roles	opuscollege	2011-05-03 11:30:35.67174	\N	\N
407	READ_SCHOLARSHIP_MENU	pt    	Y	View the scholarships menu	opuscollege	2011-05-03 11:30:35.67174	\N	\N
408	READ_STAFF_MEMBERS	pt    	Y	View Staff members	opuscollege	2011-05-03 11:30:35.67174	\N	\N
409	READ_STAFF_MEMBERS_MENU	pt    	Y	View the staff members menu	opuscollege	2011-05-03 11:30:35.67174	\N	\N
410	READ_STUDENTS	pt    	Y	View students	opuscollege	2011-05-03 11:30:35.67174	\N	\N
411	READ_STUDENTS_MENU	pt    	Y	View the students menu	opuscollege	2011-05-03 11:30:35.67174	\N	\N
412	READ_STUDIES	pt    	Y	View studies	opuscollege	2011-05-03 11:30:35.67174	\N	\N
413	READ_STUDIES_MENU	pt    	Y	View the studies menu	opuscollege	2011-05-03 11:30:35.67174	\N	\N
414	READ_STUDY_PLANS	pt    	Y	View study plans	opuscollege	2011-05-03 11:30:35.67174	\N	\N
415	READ_SUBJECTS	pt    	Y	View subjects	opuscollege	2011-05-03 11:30:35.67174	\N	\N
416	READ_USER_ROLES	pt    	Y	View what roles users are assigned to	opuscollege	2011-05-03 11:30:35.67174	\N	\N
417	WRITE_ACADEMIC_YEARS	pt    	Y	Add and modify academic years	opuscollege	2011-05-03 11:30:35.67174	\N	\N
418	WRITE_BRANCHES	pt    	Y	Add and modify branches	opuscollege	2011-05-03 11:30:35.67174	\N	\N
419	WRITE_EXAMS	pt    	Y	Add and modify Exams	opuscollege	2011-05-03 11:30:35.67174	\N	\N
420	WRITE_FEES	pt    	Y	Edit fees	opuscollege	2011-05-03 11:30:35.67174	\N	\N
421	WRITE_INSTITUTIONS	pt    	Y	Add and modify institutions	opuscollege	2011-05-03 11:30:35.67174	\N	\N
422	WRITE_LOOKUPS	pt    	Y	Add and modify lookups	opuscollege	2011-05-03 11:30:35.67174	\N	\N
423	WRITE_ORGANIZATIONS	pt    	Y	Write organizations	opuscollege	2011-05-03 11:30:35.67174	\N	\N
424	WRITE_ORG_UNITS	pt    	Y	And and modify organizational units	opuscollege	2011-05-03 11:30:35.67174	\N	\N
425	WRITE_ROLES	pt    	Y	Add and update roles 	opuscollege	2011-05-03 11:30:35.67174	\N	\N
426	WRITE_STAFF_MEMBERS	pt    	Y	Add and modify staff members	opuscollege	2011-05-03 11:30:35.67174	\N	\N
427	WRITE_STUDENTS	pt    	Y	Add and modify students	opuscollege	2011-05-03 11:30:35.67174	\N	\N
428	WRITE_STUDIES	pt    	Y	Add and modify studies	opuscollege	2011-05-03 11:30:35.67174	\N	\N
429	WRITE_STUDY_PLANS	pt    	Y	Add and modify study plans	opuscollege	2011-05-03 11:30:35.67174	\N	\N
430	WRITE_SUBJECTS	pt    	Y	Add and modify subjects	opuscollege	2011-05-03 11:30:35.67174	\N	\N
431	WRITE_USER_ROLES	pt    	Y	Assign roles to users 	opuscollege	2011-05-03 11:30:35.67174	\N	\N
432	TRANSFER_CURRICULUM	pt    	Y	Transfer curriculum	opuscollege	2011-05-03 11:30:35.67174	\N	\N
433	TRANSFER_STUDENTS	pt    	Y	Transfer students	opuscollege	2011-05-03 11:30:35.67174	\N	\N
701	UPDATE_STUDYPLANRESULTS	pt    	Y	Update studyplan results	opuscollege	2011-05-18 10:52:15.398942	\N	\N
702	UPDATE_STUDYPLANRESULTS	nl    	Y	Wijzigen studieplan resultaten	opuscollege	2011-05-18 10:52:15.398942	\N	\N
2769	ADMINISTER_SYSTEM	en    	Y	Perform changes on system configuration	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2770	APPROVE_SUBJECT_SUBSCRIPTIONS	en    	Y	Approve subject subscriptions	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2771	GENERATE_STUDENT_REPORTS	en    	Y	Generate student reports	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2772	GENERATE_STATISTICS	en    	Y	Generate statistics	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2773	CREATE_ACADEMIC_YEARS	en    	Y	Create academic years	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2774	CREATE_BRANCHES	en    	Y	Create branches	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2775	CREATE_CHILD_ORG_UNITS	en    	Y	Show child organizational units	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2777	CREATE_EXAMINATION_SUPERVISORS	en    	Y	Assign examination supervisors	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2778	CREATE_FEES	en    	Y	Create fees	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2779	CREATE_FOREIGN_STUDYPLAN_DETAILS	en    	Y	Create studyplan details from other universities in a studyplan	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2780	CREATE_FOREIGN_STUDYPLAN_RESULTS	en    	Y	Create studyplan results for studyplan details from other universities	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2781	CREATE_INSTITUTIONS	en    	Y	Create institutions	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2782	CREATE_LOOKUPS	en    	Y	Create lookups	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2783	CREATE_ORG_UNITS	en    	Y	Create organizational units	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2784	CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL	en    	Y	Allow each student to subscribe to subjects and subject blocks pending approval	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2785	CREATE_ROLES	en    	Y	Create roles	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2786	CREATE_SECONDARY_SCHOOLS	en    	Y	Create organizations	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2787	CREATE_STAFFMEMBERS	en    	Y	Create Staff members	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2788	CREATE_STAFFMEMBER_ADDRESSES	en    	Y	Create staff member addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2789	CREATE_STAFFMEMBER_CONTRACTS	en    	Y	Create staff member contracts	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2790	CREATE_STUDENTS	en    	Y	Create all students	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2791	CREATE_STUDY_PLANS	en    	Y	Create study plans	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2792	CREATE_STUDENT_ABSENCES	en    	Y	Create student absences	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2793	CREATE_STUDENT_ADDRESSES	en    	Y	Create student addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2794	CREATE_STUDIES	en    	Y	Create studies	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2795	CREATE_STUDY_ADDRESSES	en    	Y	Create study addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2796	CREATE_STUDYGRADETYPE_RFC	en    	Y	Create RFCs for a study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2797	CREATE_STUDYGRADETYPES	en    	Y	Create study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2798	CREATE_SUBJECTS	en    	Y	Create subjects	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2799	CREATE_SUBJECT_PREREQUISITES	en    	Y	Define subjects prerequisites	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2800	CREATE_SUBJECT_STUDYGRADETYPES	en    	Y	Assign subjects to study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2801	CREATE_SUBJECT_SUBJECTBLOCKS	en    	Y	Assign subjects to subject blocks	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2802	CREATE_SUBJECT_TEACHERS	en    	Y	Assign subject teachers	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2803	CREATE_SUBJECTBLOCKS	en    	Y	Create subject blocks	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2804	CREATE_SUBJECTBLOCK_PREREQUISITES	en    	Y	Define subject block prerequisites	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2805	CREATE_SUBJECTBLOCK_STUDYGRADETYPES	en    	Y	Assign subject blocks to study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2806	CREATE_STUDYPLAN_RESULTS	en    	Y	Create studyplan results	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2807	CREATE_STUDYPLANDETAILS	en    	Y	Subscribe students to subjects and subject blocks pending approval	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2808	CREATE_STUDYPLANDETAILS_PENDING_APPROVAL	en    	Y	Subscribe students to subjects and subject blocks pending approval	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2809	CREATE_TEST_SUPERVISORS	en    	Y	Assign test supervisors	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2810	CREATE_USER_ROLES	en    	Y	Create what roles users are assigned to	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2811	DELETE_ACADEMIC_YEARS	en    	Y	Delete academic years	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2812	DELETE_BRANCHES	en    	Y	Delete branches	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2813	DELETE_CHILD_ORG_UNITS	en    	Y	Delete child organizational units	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2814	DELETE_EXAMINATIONS	en    	Y	Delete examinations	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2815	DELETE_EXAMINATION_SUPERVISORS	en    	Y	Delete examination supervisors	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2816	DELETE_FEES	en    	Y	Delete fees	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2817	DELETE_INSTITUTIONS	en    	Y	Delete institutions	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2818	DELETE_LOOKUPS	en    	Y	Delete lookups	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2819	DELETE_SECONDARY_SCHOOLS	en    	Y	Delete organizations	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2820	DELETE_ORG_UNITS	en    	Y	Delete organizational units	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2821	DELETE_ROLES	en    	Y	Delete roles	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2822	DELETE_STAFFMEMBERS	en    	Y	Delete staff members	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2823	DELETE_STAFFMEMBER_CONTRACTS	en    	Y	Delete staff member contracts	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2824	DELETE_STAFFMEMBER_ADDRESSES	en    	Y	Delete staff member addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2825	DELETE_STUDENTS	en    	Y	Delete students	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2827	DELETE_STUDENT_ABSENCES	en    	Y	Delete student absences	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2828	DELETE_STUDENT_ADDRESSES	en    	Y	Delete student addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2829	DELETE_STUDIES	en    	Y	Delete studies	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2830	DELETE_STUDY_ADDRESSES	en    	Y	Delete study addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2831	DELETE_STUDYGRADETYPES	en    	Y	Delete study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2832	DELETE_STUDY_PLANS	en    	Y	Delete study plans	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2833	DELETE_SUBJECTS	en    	Y	Delete subjects	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2834	DELETE_SUBJECT_PREREQUISITES	en    	Y	Remove subject prerequisites	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2835	DELETE_SUBJECT_STUDYGRADETYPES	en    	Y	Remove subjects from study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2836	DELETE_SUBJECT_SUBJECTBLOCKS	en    	Y	Remove subjects from subject blocks	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2837	DELETE_SUBJECT_TEACHERS	en    	Y	Delete subject teachers	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2839	DELETE_SUBJECTBLOCK_PREREQUISITES	en    	Y	Remove subject block prerequisites	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2840	DELETE_SUBJECTBLOCK_STUDYGRADETYPES	en    	Y	Remove subject blocks from study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2841	DELETE_TESTS	en    	Y	Delete tests	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2842	DELETE_TEST_SUPERVISORS	en    	Y	Delete test supervisors	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2843	DELETE_USER_ROLES	en    	Y	Remove roles form users	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2844	FINALIZE_ADMISSION_FLOW	en    	Y	Make final progression step in the admission flow	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2845	FINALIZE_CONTINUED_REGISTRATION_FLOW	en    	Y	Make final progression step in the continued registration flow	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2846	PROGRESS_ADMISSION_FLOW	en    	Y	Make progression steps in the admission flow	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2847	PROGRESS_CONTINUED_REGISTRATION_FLOW	en    	Y	Make progression steps in the continued registration flow	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2848	READ_ACADEMIC_YEARS	en    	Y	View academic years	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2849	READ_BRANCHES	en    	Y	View branches	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2850	READ_EXAMINATIONS	en    	Y	View examinations	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2851	READ_EXAMINATION_SUPERVISORS	en    	Y	View examination supervisors	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2852	READ_FEES	en    	Y	View fees	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2853	READ_INSTITUTIONS	en    	Y	View institutions	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2854	READ_LOOKUPS	en    	Y	View lookups	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2855	READ_OPUSUSER	en    	Y	View Opususer data	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2856	READ_ORG_UNITS	en    	Y	View organizational units	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2857	READ_OWN_STUDYPLAN_RESULTS	en    	Y	View own study plan results for subjects teacher teaches or student	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2858	READ_PRIMARY_AND_CHILD_ORG_UNITS	en    	Y	View primary organizational unit and its children	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2859	READ_ROLES	en    	Y	View roles	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2860	READ_SECONDARY_SCHOOLS	en    	Y	View organizations	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2861	READ_STAFFMEMBERS	en    	Y	View Staff members	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2862	READ_STAFFMEMBER_CONTRACTS	en    	Y	Read staff member contracts	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2863	READ_STAFFMEMBER_ADDRESSES	en    	Y	Read staff member addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2864	READ_STUDENTS	en    	Y	View all students	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2865	READ_STUDENTS_SAME_STUDYGRADETYPE	en    	Y	View only students in the study grade type	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2866	READ_STUDENT_SUBSCRIPTION_DATA	en    	Y	View student subscription data	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2867	READ_STUDENT_ABSENCES	en    	Y	View student absences	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2868	READ_STUDENT_ADDRESSES	en    	Y	View student addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2869	READ_STUDENT_MEDICAL_DATA	en    	Y	View student medical data	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2870	READ_STUDIES	en    	Y	View studies	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2871	READ_STUDY_ADDRESSES	en    	Y	Read study addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2872	READ_STUDYGRADETYPES	en    	Y	View study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2873	READ_STUDY_PLANS	en    	Y	View study plans	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2874	READ_STUDYPLAN_RESULTS	en    	Y	View study plan results	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2875	READ_SUBJECTBLOCKS	en    	Y	View subject blocks	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2876	READ_SUBJECTS	en    	Y	View subjects	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2877	READ_SUBJECT_TEACHERS	en    	Y	View subject teachers	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2878	READ_SUBJECT_STUDYGRADETYPES	en    	Y	View associations subject / study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2879	READ_SUBJECT_SUBJECTBLOCKS	en    	Y	View associations subject / subject blocks	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2880	READ_SUBJECTBLOCK_STUDYGRADETYPES	en    	Y	View associations subject block / study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2881	READ_TESTS	en    	Y	View tests	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2882	READ_TEST_SUPERVISORS	en    	Y	View test supervisors	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2883	READ_USER_ROLES	en    	Y	View what roles users are assigned to	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2884	RESET_PASSWORD	en    	Y	Reset passwords	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2887	UPDATE_ACADEMIC_YEARS	en    	Y	Update academic years	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2888	UPDATE_BRANCHES	en    	Y	Update branches	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2889	UPDATE_EXAMINATIONS	en    	Y	Update Examinations	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2890	UPDATE_FEES	en    	Y	Update fees	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2891	UPDATE_FOREIGN_STUDYPLAN_DETAILS	en    	Y	Update studyplan with studyplan details from other universities	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2892	UPDATE_FOREIGN_STUDYPLAN_RESULTS	en    	Y	Update studyplan results for studyplan details from other universities	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2893	UPDATE_INSTITUTIONS	en    	Y	Update institutions	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2894	UPDATE_LOOKUPS	en    	Y	Update lookups	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2895	UPDATE_SECONDARY_SCHOOLS	en    	Y	Update organizations	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2896	UPDATE_OPUSUSER	en    	Y	Update Opususer data	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2897	UPDATE_ORG_UNITS	en    	Y	Update organizational units	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2898	UPDATE_OWN_STUDYPLAN_RESULTS_PENDING_APPROVAL	en    	Y	Allow each teachert to update subjects and subject block results pending approval	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2899	UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL	en    	Y	Allow each student to update subjects and subject block subscriptions pending approval	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2900	UPDATE_PRIMARY_AND_CHILD_ORG_UNITS	en    	Y	Update primary organizational unit and its children	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2901	UPDATE_PROGRESS_STATUS	en    	Y	Update student progress status	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2902	UPDATE_ROLES	en    	Y	Update roles	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2903	UPDATE_STAFFMEMBERS	en    	Y	Update staff members	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2904	UPDATE_STAFFMEMBER_CONTRACTS	en    	Y	Update staff member contracts	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2905	UPDATE_STAFFMEMBER_ADDRESSES	en    	Y	Update staff member addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2906	UPDATE_STUDENTS	en    	Y	Update students	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2910	UPDATE_STUDENT_MEDICAL_DATA	en    	Y	Update student medical data	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2911	UPDATE_STUDIES	en    	Y	Update studies	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2913	UPDATE_STUDY_PLANS	en    	Y	Update study plans	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2914	UPDATE_STUDYPLAN_RESULTS	en    	Y	Update studyplan results	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2915	UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL	en    	Y	Update studyplan results upon appeal	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2916	UPDATE_STUDYGRADETYPE_RFC	en    	Y	Update RFCs for a study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2917	UPDATE_STUDYGRADETYPES	en    	Y	Update study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2918	UPDATE_SUBJECTS	en    	Y	Update subjects	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2919	UPDATE_SUBJECT_STUDYGRADETYPES	en    	Y	Update associations subject / study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2920	UPDATE_SUBJECT_SUBJECTBLOCKS	en    	Y	Update associations subject / subject blocks	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2921	UPDATE_SUBJECTBLOCK_STUDYGRADETYPES	en    	Y	Update associations subject block / study grade types	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2922	UPDATE_SUBJECTBLOCKS	en    	Y	Update subject blocks	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2923	UPDATE_USER_ROLES	en    	Y	Update user roles	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2924	TRANSFER_CURRICULUM	en    	Y	Transfer curriculum	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2925	TRANSFER_STUDENTS	en    	Y	Transfer students	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2939	CREATE_IDENTIFICATION_DATA	en    	Y	Create National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 13:36:17.301786	\N	\N
2941	DELETE_IDENTIFICATION_DATA	en    	Y	Delete National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 13:36:17.301786	\N	\N
2940	UPDATE_IDENTIFICATION_DATA	en    	Y	Update National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 13:36:17.301786	\N	\N
2942	READ_IDENTIFICATION_DATA	en    	Y	View National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 13:36:17.301786	\N	\N
2943	CREATE_IDENTIFICATION_DATA	pt    	Y	Create National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 14:37:44.97772	\N	\N
2944	UPDATE_IDENTIFICATION_DATA	pt    	Y	Update National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 14:37:44.97772	\N	\N
2945	DELETE_IDENTIFICATION_DATA	pt    	Y	Delete National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 14:37:44.97772	\N	\N
2946	READ_IDENTIFICATION_DATA	pt    	Y	View National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 14:37:44.97772	\N	\N
2947	CREATE_IDENTIFICATION_DATA	nl    	Y	Create National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 14:38:18.345092	\N	\N
2948	UPDATE_IDENTIFICATION_DATA	nl    	Y	Update National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 14:38:18.345092	\N	\N
2949	DELETE_IDENTIFICATION_DATA	nl    	Y	Delete National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 14:38:18.345092	\N	\N
2950	READ_IDENTIFICATION_DATA	nl    	Y	View National Registration Number, Identfication Number and Type of a student	opuscollege	2011-11-14 14:38:18.345092	\N	\N
2952	REVERSE_PROGRESS_STATUS	en    	Y	Reverse progress statuses in cntd registration	opuscollege	2011-12-12 13:46:13.271927	\N	\N
2953	READ_STUDENT_NOTES	en    	Y	Read notes on career interests, activities and placements of students	opuscollege	2011-12-21 16:01:18.656314	\N	\N
2954	CREATE_STUDENT_NOTES	en    	Y	Create notes on career interests, activities and placements of students	opuscollege	2011-12-21 16:01:18.656314	\N	\N
2955	UPDATE_STUDENT_NOTES	en    	Y	Alter notes on career interests, activities and placements of students	opuscollege	2011-12-21 16:01:18.656314	\N	\N
2956	DELETE_STUDENT_NOTES	en    	Y	Delete notes on career interests, activities and placements of students	opuscollege	2011-12-21 16:01:18.656314	\N	\N
2957	READ_STUDENT_COUNSELING	en    	Y	Read notes on counseling of students	opuscollege	2011-12-21 20:04:36.930572	\N	\N
2958	CREATE_STUDENT_COUNSELING	en    	Y	Create notes on counseling of students	opuscollege	2011-12-21 20:04:36.930572	\N	\N
2959	UPDATE_STUDENT_COUNSELING	en    	Y	Alter notes on counseling of students	opuscollege	2011-12-21 20:04:36.930572	\N	\N
2960	DELETE_STUDENT_COUNSELING	en    	Y	Delete notes on counseling of students	opuscollege	2011-12-21 20:04:36.930572	\N	\N
2961	READ_FINANCE	en    	Y	Read information in the financial module	opuscollege	2012-01-05 15:01:08.520582	\N	\N
2962	CREATE_FINANCE	en    	Y	Create information in the financial module	opuscollege	2012-01-05 15:01:08.520582	\N	\N
2963	UPDATE_FINANCE	en    	Y	Update information in the financial module	opuscollege	2012-01-05 15:01:08.520582	\N	\N
2964	DELETE_FINANCE	en    	Y	Delete information in the financial module	opuscollege	2012-01-05 15:01:08.520582	\N	\N
2927	TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR	en    	Y	Set the cut-off point for applying bachelor students	opuscollege	2011-10-18 15:12:19.972188	\N	\N
2931	TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR	pt    	Y	Set the cut-off point for applying bachelor students	opuscollege	2011-10-18 15:17:25.608551	\N	\N
2935	TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR	nl    	Y	Set the cut-off point for applying bachelor students	opuscollege	2011-10-18 15:17:37.064825	\N	\N
2965	GENERATE_HISTORY_REPORTS	en    	Y	Generate history reports	opuscollege	2012-02-09 14:28:17.39831	\N	\N
2966	CREATE_SCHOLARSHIPS	en    	Y	Create information on scholarships	opuscollege	2012-04-03 13:57:47.988848	\N	\N
2967	READ_SCHOLARSHIPS	en    	Y	Read information on scholarships	opuscollege	2012-04-03 13:57:47.988848	\N	\N
2968	UPDATE_SCHOLARSHIPS	en    	Y	Update information on scholarships	opuscollege	2012-04-03 13:57:47.988848	\N	\N
2969	DELETE_SCHOLARSHIPS	en    	Y	Delete information on scholarships	opuscollege	2012-04-03 13:57:47.988848	\N	\N
2970	CREATE_ACCOMMODATION_DATA	en    	Y	Create accommodation data	opuscollege	2012-04-16 14:00:45.202224	\N	\N
2971	UPDATE_ACCOMMODATION_DATA	en    	Y	Update accommodation data	opuscollege	2012-04-16 14:00:45.202224	\N	\N
2972	DELETE_ACCOMMODATION_DATA	en    	Y	Delete accommodation data	opuscollege	2012-04-16 14:00:45.202224	\N	\N
2973	READ_ACCOMMODATION_DATA	en    	Y	Read accommodation data	opuscollege	2012-04-16 14:00:45.202224	\N	\N
2974	ACCESS_CONTEXT_HELP	en    	Y	Show the context help	opuscollege	2012-04-16 14:07:21.776523	\N	\N
3250	ADMINISTER_SYSTEM	en_ZM 	Y	Perform changes on system configuration	opuscollege	2012-05-21 10:59:52.546945	\N	\N
3251	APPROVE_SUBJECT_SUBSCRIPTIONS	en_ZM 	Y	Approve course subscriptions	opuscollege	2012-05-21 10:59:52.566357	\N	\N
3252	GENERATE_STUDENT_REPORTS	en_ZM 	Y	Generate student reports	opuscollege	2012-05-21 10:59:52.599005	\N	\N
3253	GENERATE_STATISTICS	en_ZM 	Y	Generate statistics	opuscollege	2012-05-21 10:59:52.629253	\N	\N
3254	CREATE_ACADEMIC_YEARS	en_ZM 	Y	Create academic years	opuscollege	2012-05-21 10:59:52.66072	\N	\N
3255	CREATE_BRANCHES	en_ZM 	Y	Create second level units	opuscollege	2012-05-21 10:59:52.691898	\N	\N
3256	CREATE_CHILD_ORG_UNITS	en_ZM 	Y	Show child second level units	opuscollege	2012-05-21 10:59:52.723052	\N	\N
3257	CREATE_EXAMINATION_SUPERVISORS	en_ZM 	Y	Assign examination supervisors	opuscollege	2012-05-21 10:59:52.754395	\N	\N
3258	CREATE_FEES	en_ZM 	Y	Create fees	opuscollege	2012-05-21 10:59:52.785696	\N	\N
3259	CREATE_FOREIGN_STUDYPLAN_DETAILS	en_ZM 	Y	Create studyplan details from other universities in a studyplan	opuscollege	2012-05-21 10:59:52.816845	\N	\N
3260	CREATE_FOREIGN_STUDYPLAN_RESULTS	en_ZM 	Y	Create studyplan results for studyplan details from other universities	opuscollege	2012-05-21 10:59:52.848425	\N	\N
3261	CREATE_INSTITUTIONS	en_ZM 	Y	Create institutions	opuscollege	2012-05-21 10:59:52.879702	\N	\N
3262	CREATE_LOOKUPS	en_ZM 	Y	Create lookups	opuscollege	2012-05-21 10:59:52.910905	\N	\N
3263	CREATE_ORG_UNITS	en_ZM 	Y	Create second level units	opuscollege	2012-05-21 10:59:52.942133	\N	\N
3264	CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL	en_ZM 	Y	Allow each student to subscribe to courses and course blocks pending approval	opuscollege	2012-05-21 10:59:52.973403	\N	\N
3265	CREATE_ROLES	en_ZM 	Y	Create roles	opuscollege	2012-05-21 10:59:53.004645	\N	\N
3266	CREATE_SECONDARY_SCHOOLS	en_ZM 	Y	Create organizations	opuscollege	2012-05-21 10:59:53.036087	\N	\N
3267	CREATE_STAFFMEMBERS	en_ZM 	Y	Create Staff members	opuscollege	2012-05-21 10:59:53.067538	\N	\N
3268	CREATE_STAFFMEMBER_ADDRESSES	en_ZM 	Y	Create staff member addresses	opuscollege	2012-05-21 10:59:53.098799	\N	\N
3269	CREATE_STAFFMEMBER_CONTRACTS	en_ZM 	Y	Create staff member contracts	opuscollege	2012-05-21 10:59:53.130332	\N	\N
3270	CREATE_STUDENTS	en_ZM 	Y	Create all students	opuscollege	2012-05-21 10:59:53.161469	\N	\N
3271	CREATE_STUDY_PLANS	en_ZM 	Y	Create study plans	opuscollege	2012-05-21 10:59:53.192741	\N	\N
3272	CREATE_STUDENT_ABSENCES	en_ZM 	Y	Create student absences	opuscollege	2012-05-21 10:59:53.224115	\N	\N
3273	CREATE_STUDENT_ADDRESSES	en_ZM 	Y	Create student addresses	opuscollege	2012-05-21 10:59:53.255281	\N	\N
3274	CREATE_STUDIES	en_ZM 	Y	Create studies	opuscollege	2012-05-21 10:59:53.286482	\N	\N
3275	CREATE_STUDY_ADDRESSES	en_ZM 	Y	Create study addresses	opuscollege	2012-05-21 10:59:53.317801	\N	\N
3276	CREATE_STUDYGRADETYPE_RFC	en_ZM 	Y	Create RFCs for a programmes of study	opuscollege	2012-05-21 10:59:53.348933	\N	\N
3277	CREATE_STUDYGRADETYPES	en_ZM 	Y	Create programmes of study	opuscollege	2012-05-21 10:59:53.380184	\N	\N
3278	CREATE_SUBJECTS	en_ZM 	Y	Create courses	opuscollege	2012-05-21 10:59:53.411382	\N	\N
3279	CREATE_SUBJECT_PREREQUISITES	en_ZM 	Y	Define courses prerequisites	opuscollege	2012-05-21 10:59:53.442472	\N	\N
3280	CREATE_SUBJECT_STUDYGRADETYPES	en_ZM 	Y	Assign courses to programmes of study	opuscollege	2012-05-21 10:59:53.474823	\N	\N
3281	CREATE_SUBJECT_SUBJECTBLOCKS	en_ZM 	Y	Assign courses to course blocks	opuscollege	2012-05-21 10:59:53.505178	\N	\N
3282	CREATE_SUBJECT_TEACHERS	en_ZM 	Y	Assign course lecturers	opuscollege	2012-05-21 10:59:53.536437	\N	\N
3283	CREATE_SUBJECTBLOCKS	en_ZM 	Y	Create course blocks	opuscollege	2012-05-21 10:59:53.567535	\N	\N
3284	CREATE_SUBJECTBLOCK_PREREQUISITES	en_ZM 	Y	Define course block prerequisites	opuscollege	2012-05-21 10:59:53.600177	\N	\N
3285	CREATE_SUBJECTBLOCK_STUDYGRADETYPES	en_ZM 	Y	Assign course blocks to programmes of study	opuscollege	2012-05-21 10:59:53.629979	\N	\N
3286	CREATE_STUDYPLAN_RESULTS	en_ZM 	Y	Create studyplan results	opuscollege	2012-05-21 10:59:53.661325	\N	\N
3287	CREATE_STUDYPLANDETAILS	en_ZM 	Y	Subscribe students to courses and course blocks pending approval	opuscollege	2012-05-21 10:59:53.692875	\N	\N
3288	CREATE_STUDYPLANDETAILS_PENDING_APPROVAL	en_ZM 	Y	Subscribe students to courses and course blocks pending approval	opuscollege	2012-05-21 10:59:53.72418	\N	\N
3289	CREATE_TEST_SUPERVISORS	en_ZM 	Y	Assign test supervisors	opuscollege	2012-05-21 10:59:53.755316	\N	\N
3290	CREATE_USER_ROLES	en_ZM 	Y	Create what roles users are assigned to	opuscollege	2012-05-21 10:59:53.786322	\N	\N
3291	DELETE_ACADEMIC_YEARS	en_ZM 	Y	Delete academic years	opuscollege	2012-05-21 10:59:53.817621	\N	\N
3292	DELETE_BRANCHES	en_ZM 	Y	Delete second level units	opuscollege	2012-05-21 10:59:53.848924	\N	\N
3293	DELETE_CHILD_ORG_UNITS	en_ZM 	Y	Delete child second level units	opuscollege	2012-05-21 10:59:53.880164	\N	\N
3294	DELETE_EXAMINATIONS	en_ZM 	Y	Delete examinations	opuscollege	2012-05-21 10:59:53.9114	\N	\N
3295	DELETE_EXAMINATION_SUPERVISORS	en_ZM 	Y	Delete examination supervisors	opuscollege	2012-05-21 10:59:53.942973	\N	\N
3296	DELETE_FEES	en_ZM 	Y	Delete fees	opuscollege	2012-05-21 10:59:53.974012	\N	\N
3297	DELETE_INSTITUTIONS	en_ZM 	Y	Delete institutions	opuscollege	2012-05-21 10:59:54.005019	\N	\N
3298	DELETE_LOOKUPS	en_ZM 	Y	Delete lookups	opuscollege	2012-05-21 10:59:54.036257	\N	\N
3299	DELETE_SECONDARY_SCHOOLS	en_ZM 	Y	Delete organizations	opuscollege	2012-05-21 10:59:54.067815	\N	\N
3300	DELETE_ORG_UNITS	en_ZM 	Y	Delete second level units	opuscollege	2012-05-21 10:59:54.098761	\N	\N
3301	DELETE_ROLES	en_ZM 	Y	Delete roles	opuscollege	2012-05-21 10:59:54.131163	\N	\N
3302	DELETE_STAFFMEMBERS	en_ZM 	Y	Delete staff members	opuscollege	2012-05-21 10:59:54.161663	\N	\N
3303	DELETE_STAFFMEMBER_CONTRACTS	en_ZM 	Y	Delete staff member contracts	opuscollege	2012-05-21 10:59:54.192768	\N	\N
3304	DELETE_STAFFMEMBER_ADDRESSES	en_ZM 	Y	Delete staff member addresses	opuscollege	2012-05-21 10:59:54.223917	\N	\N
3305	DELETE_STUDENTS	en_ZM 	Y	Delete students	opuscollege	2012-05-21 10:59:54.255168	\N	\N
3306	DELETE_STUDENT_ABSENCES	en_ZM 	Y	Delete student absences	opuscollege	2012-05-21 10:59:54.286318	\N	\N
3307	DELETE_STUDENT_ADDRESSES	en_ZM 	Y	Delete student addresses	opuscollege	2012-05-21 10:59:54.317567	\N	\N
3308	DELETE_STUDIES	en_ZM 	Y	Delete studies	opuscollege	2012-05-21 10:59:54.349052	\N	\N
3309	DELETE_STUDY_ADDRESSES	en_ZM 	Y	Delete study addresses	opuscollege	2012-05-21 10:59:54.380408	\N	\N
3310	DELETE_STUDYGRADETYPES	en_ZM 	Y	Delete programmes of study	opuscollege	2012-05-21 10:59:54.411535	\N	\N
3311	DELETE_STUDY_PLANS	en_ZM 	Y	Delete study plans	opuscollege	2012-05-21 10:59:54.442486	\N	\N
3312	DELETE_SUBJECTS	en_ZM 	Y	Delete courses	opuscollege	2012-05-21 10:59:54.473813	\N	\N
3313	DELETE_SUBJECT_PREREQUISITES	en_ZM 	Y	Remove course prerequisites	opuscollege	2012-05-21 10:59:54.50511	\N	\N
3314	DELETE_SUBJECT_STUDYGRADETYPES	en_ZM 	Y	Remove courses from programmes of study	opuscollege	2012-05-21 10:59:54.536637	\N	\N
3315	DELETE_SUBJECT_SUBJECTBLOCKS	en_ZM 	Y	Remove courses from course blocks	opuscollege	2012-05-21 10:59:54.56771	\N	\N
3316	DELETE_SUBJECT_TEACHERS	en_ZM 	Y	Delete course lecturers	opuscollege	2012-05-21 10:59:54.599223	\N	\N
3317	DELETE_SUBJECTBLOCKS	en_ZM 	Y	Delete courses	opuscollege	2012-05-21 10:59:54.630563	\N	\N
3318	DELETE_SUBJECTBLOCK_PREREQUISITES	en_ZM 	Y	Remove course block prerequisites	opuscollege	2012-05-21 10:59:54.661552	\N	\N
3319	DELETE_SUBJECTBLOCK_STUDYGRADETYPES	en_ZM 	Y	Remove course blocks from programmes of study	opuscollege	2012-05-21 10:59:54.692647	\N	\N
3320	DELETE_TESTS	en_ZM 	Y	Delete tests	opuscollege	2012-05-21 10:59:54.723994	\N	\N
3321	DELETE_TEST_SUPERVISORS	en_ZM 	Y	Delete test supervisors	opuscollege	2012-05-21 10:59:54.755155	\N	\N
3322	DELETE_USER_ROLES	en_ZM 	Y	Remove roles form users	opuscollege	2012-05-21 10:59:54.786248	\N	\N
3323	FINALIZE_ADMISSION_FLOW	en_ZM 	Y	Make final progression step in the admission flow	opuscollege	2012-05-21 10:59:54.817704	\N	\N
3324	FINALIZE_CONTINUED_REGISTRATION_FLOW	en_ZM 	Y	Make final progression step in the continued registration flow	opuscollege	2012-05-21 10:59:54.848941	\N	\N
3325	PROGRESS_ADMISSION_FLOW	en_ZM 	Y	Make progression steps in the admission flow	opuscollege	2012-05-21 10:59:54.880395	\N	\N
3326	PROGRESS_CONTINUED_REGISTRATION_FLOW	en_ZM 	Y	Make progression steps in the continued registration flow	opuscollege	2012-05-21 10:59:54.911513	\N	\N
3327	READ_ACADEMIC_YEARS	en_ZM 	Y	View academic years	opuscollege	2012-05-21 10:59:54.9427	\N	\N
3328	READ_BRANCHES	en_ZM 	Y	View second level units	opuscollege	2012-05-21 10:59:54.974104	\N	\N
3329	READ_EXAMINATIONS	en_ZM 	Y	View examinations	opuscollege	2012-05-21 10:59:55.005096	\N	\N
3330	READ_EXAMINATION_SUPERVISORS	en_ZM 	Y	View examination supervisors	opuscollege	2012-05-21 10:59:55.036545	\N	\N
3331	READ_FEES	en_ZM 	Y	View fees	opuscollege	2012-05-21 10:59:55.067612	\N	\N
3332	READ_INSTITUTIONS	en_ZM 	Y	View institutions	opuscollege	2012-05-21 10:59:55.098908	\N	\N
3333	READ_LOOKUPS	en_ZM 	Y	View lookups	opuscollege	2012-05-21 10:59:55.130097	\N	\N
3334	READ_OPUSUSER	en_ZM 	Y	View Opususer data	opuscollege	2012-05-21 10:59:55.1617	\N	\N
3335	READ_ORG_UNITS	en_ZM 	Y	View second level units	opuscollege	2012-05-21 10:59:55.192856	\N	\N
3336	READ_OWN_STUDYPLAN_RESULTS	en_ZM 	Y	View own study plan results for courses lecturer teaches or student	opuscollege	2012-05-21 10:59:55.22449	\N	\N
3337	READ_PRIMARY_AND_CHILD_ORG_UNITS	en_ZM 	Y	View primary second level unit and its children	opuscollege	2012-05-21 10:59:55.255551	\N	\N
3338	READ_ROLES	en_ZM 	Y	View roles	opuscollege	2012-05-21 10:59:55.286402	\N	\N
3339	READ_SECONDARY_SCHOOLS	en_ZM 	Y	View organizations	opuscollege	2012-05-21 10:59:55.317701	\N	\N
3340	READ_STAFFMEMBERS	en_ZM 	Y	View Staff members	opuscollege	2012-05-21 10:59:55.349192	\N	\N
3341	READ_STAFFMEMBER_CONTRACTS	en_ZM 	Y	Read staff member contracts	opuscollege	2012-05-21 10:59:55.380436	\N	\N
3342	READ_STAFFMEMBER_ADDRESSES	en_ZM 	Y	Read staff member addresses	opuscollege	2012-05-21 10:59:55.413142	\N	\N
3343	READ_STUDENTS	en_ZM 	Y	View all students	opuscollege	2012-05-21 10:59:55.442748	\N	\N
3344	READ_STUDENTS_SAME_STUDYGRADETYPE	en_ZM 	Y	View only students in the programme of study	opuscollege	2012-05-21 10:59:55.477924	\N	\N
3345	READ_STUDENT_SUBSCRIPTION_DATA	en_ZM 	Y	View student subscription data	opuscollege	2012-05-21 10:59:55.50523	\N	\N
3346	READ_STUDENT_ABSENCES	en_ZM 	Y	View student absences	opuscollege	2012-05-21 10:59:55.536286	\N	\N
3347	READ_STUDENT_ADDRESSES	en_ZM 	Y	View student addresses	opuscollege	2012-05-21 10:59:55.567588	\N	\N
3348	READ_STUDENT_MEDICAL_DATA	en_ZM 	Y	View student medical data	opuscollege	2012-05-21 10:59:55.599953	\N	\N
3349	READ_STUDIES	en_ZM 	Y	View studies	opuscollege	2012-05-21 10:59:55.630029	\N	\N
3350	READ_STUDY_ADDRESSES	en_ZM 	Y	Read study addresses	opuscollege	2012-05-21 10:59:55.661412	\N	\N
3351	READ_STUDYGRADETYPES	en_ZM 	Y	View programmes of study	opuscollege	2012-05-21 10:59:55.693079	\N	\N
3352	READ_STUDY_PLANS	en_ZM 	Y	View study plans	opuscollege	2012-05-21 10:59:55.724026	\N	\N
3353	READ_STUDYPLAN_RESULTS	en_ZM 	Y	View study plan results	opuscollege	2012-05-21 10:59:55.75505	\N	\N
3354	READ_SUBJECTBLOCKS	en_ZM 	Y	View course blocks	opuscollege	2012-05-21 10:59:55.786575	\N	\N
3355	READ_SUBJECTS	en_ZM 	Y	View courses	opuscollege	2012-05-21 10:59:55.817903	\N	\N
3356	READ_SUBJECT_TEACHERS	en_ZM 	Y	View course lecturers	opuscollege	2012-05-21 10:59:55.849124	\N	\N
3357	READ_SUBJECT_STUDYGRADETYPES	en_ZM 	Y	View associations course / programmes of study	opuscollege	2012-05-21 10:59:55.880329	\N	\N
3358	READ_SUBJECT_SUBJECTBLOCKS	en_ZM 	Y	View associations course / course blocks	opuscollege	2012-05-21 10:59:55.911812	\N	\N
3359	READ_SUBJECTBLOCK_STUDYGRADETYPES	en_ZM 	Y	View associations course block / programmes of study	opuscollege	2012-05-21 10:59:55.942783	\N	\N
3360	READ_TESTS	en_ZM 	Y	View tests	opuscollege	2012-05-21 10:59:55.973974	\N	\N
3361	READ_TEST_SUPERVISORS	en_ZM 	Y	View test supervisors	opuscollege	2012-05-21 10:59:56.00513	\N	\N
3362	READ_USER_ROLES	en_ZM 	Y	View what roles users are assigned to	opuscollege	2012-05-21 10:59:56.036371	\N	\N
3363	RESET_PASSWORD	en_ZM 	Y	Reset passwords	opuscollege	2012-05-21 10:59:56.067522	\N	\N
3364	UPDATE_ACADEMIC_YEARS	en_ZM 	Y	Update academic years	opuscollege	2012-05-21 10:59:56.099029	\N	\N
3365	UPDATE_BRANCHES	en_ZM 	Y	Update second level units	opuscollege	2012-05-21 10:59:56.130326	\N	\N
3366	UPDATE_EXAMINATIONS	en_ZM 	Y	Update Examinations	opuscollege	2012-05-21 10:59:56.161583	\N	\N
3367	UPDATE_FEES	en_ZM 	Y	Update fees	opuscollege	2012-05-21 10:59:56.192709	\N	\N
3368	UPDATE_FOREIGN_STUDYPLAN_DETAILS	en_ZM 	Y	Update studyplan with studyplan details from other universities	opuscollege	2012-05-21 10:59:56.224071	\N	\N
3369	UPDATE_FOREIGN_STUDYPLAN_RESULTS	en_ZM 	Y	Update studyplan results for studyplan details from other universities	opuscollege	2012-05-21 10:59:56.255173	\N	\N
3370	UPDATE_INSTITUTIONS	en_ZM 	Y	Update institutions	opuscollege	2012-05-21 10:59:56.286417	\N	\N
3371	UPDATE_LOOKUPS	en_ZM 	Y	Update lookups	opuscollege	2012-05-21 10:59:56.317623	\N	\N
3372	UPDATE_SECONDARY_SCHOOLS	en_ZM 	Y	Update organizations	opuscollege	2012-05-21 10:59:56.349053	\N	\N
3373	UPDATE_OPUSUSER	en_ZM 	Y	Update Opususer data	opuscollege	2012-05-21 10:59:56.380532	\N	\N
3374	UPDATE_ORG_UNITS	en_ZM 	Y	Update second level units	opuscollege	2012-05-21 10:59:56.411792	\N	\N
3375	UPDATE_OWN_STUDYPLAN_RESULTS_PENDING_APPROVAL	en_ZM 	Y	Allow each lecturer to update courses and course block results pending approval	opuscollege	2012-05-21 10:59:56.442922	\N	\N
3376	UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL	en_ZM 	Y	Allow each student to update courses and course block subscriptions pending approval	opuscollege	2012-05-21 10:59:56.487132	\N	\N
3377	UPDATE_PRIMARY_AND_CHILD_ORG_UNITS	en_ZM 	Y	Update primary second level unit and its children	opuscollege	2012-05-21 10:59:56.566662	\N	\N
3378	UPDATE_PROGRESS_STATUS	en_ZM 	Y	Update student progress status	opuscollege	2012-05-21 10:59:56.599115	\N	\N
3379	UPDATE_ROLES	en_ZM 	Y	Update roles	opuscollege	2012-05-21 10:59:56.630106	\N	\N
3380	UPDATE_STAFFMEMBERS	en_ZM 	Y	Update staff members	opuscollege	2012-05-21 10:59:56.661604	\N	\N
3381	UPDATE_STAFFMEMBER_CONTRACTS	en_ZM 	Y	Update staff member contracts	opuscollege	2012-05-21 10:59:56.693106	\N	\N
3382	UPDATE_STAFFMEMBER_ADDRESSES	en_ZM 	Y	Update staff member addresses	opuscollege	2012-05-21 10:59:56.724312	\N	\N
3383	UPDATE_STUDENTS	en_ZM 	Y	Update students	opuscollege	2012-05-21 10:59:56.755472	\N	\N
3384	UPDATE_STUDENT_SUBSCRIPTION_DATA	en_ZM 	Y	View student subscription data	opuscollege	2012-05-21 10:59:56.786945	\N	\N
3385	UPDATE_STUDENT_ABSENCES	en_ZM 	Y	Delete student absences	opuscollege	2012-05-21 10:59:56.820948	\N	\N
3386	UPDATE_STUDENT_ADDRESSES	en_ZM 	Y	Delete student addresses	opuscollege	2012-05-21 10:59:56.849077	\N	\N
3387	UPDATE_STUDENT_MEDICAL_DATA	en_ZM 	Y	Update student medical data	opuscollege	2012-05-21 10:59:56.880167	\N	\N
3388	UPDATE_STUDIES	en_ZM 	Y	Update studies	opuscollege	2012-05-21 10:59:56.91166	\N	\N
3389	UPDATE_STUDY_ADDRESSES	en_ZM 	Y	Create study addresses	opuscollege	2012-05-21 10:59:56.94276	\N	\N
3390	UPDATE_STUDY_PLANS	en_ZM 	Y	Update study plans	opuscollege	2012-05-21 10:59:56.974099	\N	\N
3391	UPDATE_STUDYPLAN_RESULTS	en_ZM 	Y	Update studyplan results	opuscollege	2012-05-21 10:59:57.005381	\N	\N
3392	UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL	en_ZM 	Y	Update studyplan results upon appeal	opuscollege	2012-05-21 10:59:57.036508	\N	\N
3393	UPDATE_STUDYGRADETYPE_RFC	en_ZM 	Y	Update RFCs for a programmes of study	opuscollege	2012-05-21 10:59:57.067597	\N	\N
3394	UPDATE_STUDYGRADETYPES	en_ZM 	Y	Update programmes of study	opuscollege	2012-05-21 10:59:57.098941	\N	\N
3395	UPDATE_SUBJECTS	en_ZM 	Y	Update courses	opuscollege	2012-05-21 10:59:57.130325	\N	\N
3396	UPDATE_SUBJECT_STUDYGRADETYPES	en_ZM 	Y	Update associations course / programmes of study	opuscollege	2012-05-21 10:59:57.16175	\N	\N
3397	UPDATE_SUBJECT_SUBJECTBLOCKS	en_ZM 	Y	Update associations course / course blocks	opuscollege	2012-05-21 10:59:57.192718	\N	\N
3398	UPDATE_SUBJECTBLOCK_STUDYGRADETYPES	en_ZM 	Y	Update associations course block / programmes of study	opuscollege	2012-05-21 10:59:57.22399	\N	\N
3399	UPDATE_SUBJECTBLOCKS	en_ZM 	Y	Update course blocks	opuscollege	2012-05-21 10:59:57.255294	\N	\N
3400	UPDATE_USER_ROLES	en_ZM 	Y	Update user roles	opuscollege	2012-05-21 10:59:57.286681	\N	\N
3401	TRANSFER_CURRICULUM	en_ZM 	Y	Transfer curriculum	opuscollege	2012-05-21 10:59:57.3178	\N	\N
3402	TRANSFER_STUDENTS	en_ZM 	Y	Transfer students	opuscollege	2012-05-21 10:59:57.349038	\N	\N
3403	CREATE_IDENTIFICATION_DATA	en_ZM 	Y	Create National Registration Number, Identfication Number and Type of a student	opuscollege	2012-05-21 10:59:57.380143	\N	\N
3404	DELETE_IDENTIFICATION_DATA	en_ZM 	Y	Delete National Registration Number, Identfication Number and Type of a student	opuscollege	2012-05-21 10:59:57.411423	\N	\N
3405	UPDATE_IDENTIFICATION_DATA	en_ZM 	Y	Update National Registration Number, Identfication Number and Type of a student	opuscollege	2012-05-21 10:59:57.442981	\N	\N
3406	READ_IDENTIFICATION_DATA	en_ZM 	Y	View National Registration Number, Identfication Number and Type of a student	opuscollege	2012-05-21 10:59:57.516822	\N	\N
3407	REVERSE_PROGRESS_STATUS	en_ZM 	Y	Reverse progress statuses in cntd registration	opuscollege	2012-05-21 10:59:57.536253	\N	\N
3408	READ_STUDENT_NOTES	en_ZM 	Y	Read notes on career interests, activities and placements of students	opuscollege	2012-05-21 10:59:57.566636	\N	\N
3409	CREATE_STUDENT_NOTES	en_ZM 	Y	Create notes on career interests, activities and placements of students	opuscollege	2012-05-21 10:59:57.598034	\N	\N
3410	UPDATE_STUDENT_NOTES	en_ZM 	Y	Alter notes on career interests, activities and placements of students	opuscollege	2012-05-21 10:59:57.629283	\N	\N
3411	DELETE_STUDENT_NOTES	en_ZM 	Y	Delete notes on career interests, activities and placements of students	opuscollege	2012-05-21 10:59:57.660815	\N	\N
3412	READ_STUDENT_COUNSELING	en_ZM 	Y	Read notes on counseling of students	opuscollege	2012-05-21 10:59:57.707708	\N	\N
3413	CREATE_STUDENT_COUNSELING	en_ZM 	Y	Create notes on counseling of students	opuscollege	2012-05-21 10:59:57.738071	\N	\N
3414	UPDATE_STUDENT_COUNSELING	en_ZM 	Y	Alter notes on counseling of students	opuscollege	2012-05-21 10:59:57.76967	\N	\N
3415	DELETE_STUDENT_COUNSELING	en_ZM 	Y	Delete notes on counseling of students	opuscollege	2012-05-21 10:59:57.800513	\N	\N
3416	READ_FINANCE	en_ZM 	Y	Read information in the financial module	opuscollege	2012-05-21 10:59:57.832768	\N	\N
3417	CREATE_FINANCE	en_ZM 	Y	Create information in the financial module	opuscollege	2012-05-21 10:59:57.863059	\N	\N
3418	UPDATE_FINANCE	en_ZM 	Y	Update information in the financial module	opuscollege	2012-05-21 10:59:57.89445	\N	\N
3419	DELETE_FINANCE	en_ZM 	Y	Delete information in the financial module	opuscollege	2012-05-21 10:59:57.925606	\N	\N
3422	TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR	en_ZM 	Y	Set the cut-off point for applying bachelor students	opuscollege	2012-05-21 10:59:58.01931	\N	\N
3423	GENERATE_HISTORY_REPORTS	en_ZM 	Y	Generate history reports	opuscollege	2012-05-21 10:59:58.050486	\N	\N
3424	CREATE_SCHOLARSHIPS	en_ZM 	Y	Create information on scholarships	opuscollege	2012-05-21 10:59:58.081808	\N	\N
3425	READ_SCHOLARSHIPS	en_ZM 	Y	Read information on scholarships	opuscollege	2012-05-21 10:59:58.112943	\N	\N
3426	UPDATE_SCHOLARSHIPS	en_ZM 	Y	Update information on scholarships	opuscollege	2012-05-21 10:59:58.144242	\N	\N
3427	DELETE_SCHOLARSHIPS	en_ZM 	Y	Delete information on scholarships	opuscollege	2012-05-21 10:59:58.175641	\N	\N
3428	CREATE_ACCOMMODATION_DATA	en_ZM 	Y	Create accommodation data	opuscollege	2012-05-21 10:59:58.207397	\N	\N
3429	UPDATE_ACCOMMODATION_DATA	en_ZM 	Y	Update accommodation data	opuscollege	2012-05-21 10:59:58.238099	\N	\N
3430	DELETE_ACCOMMODATION_DATA	en_ZM 	Y	Delete accommodation data	opuscollege	2012-05-21 10:59:58.269334	\N	\N
3431	READ_ACCOMMODATION_DATA	en_ZM 	Y	Read accommodation data	opuscollege	2012-05-21 10:59:58.300664	\N	\N
3432	ACCESS_CONTEXT_HELP	en_ZM 	Y	Show the context help	opuscollege	2012-05-21 10:59:58.33213	\N	\N
3434	ALLOCATE_ROOM	en    	Y	Allocate Room	opuscollege	2012-10-02 18:31:34.489	\N	\N
3435	ALLOCATE_ROOM	en_ZM 	Y	Allocate Room	opuscollege	2012-10-02 18:31:34.489	\N	\N
3436	APPLY_FOR_ACCOMMODATION	en    	Y	Apply for accommodation	opuscollege	2012-10-02 18:31:34.489	\N	\N
3438	UPDATE_SCHOLARSHIP_FLAG	en    	Y	Update the student scholarship flag	opuscollege	2014-03-05 14:59:12.908	\N	\N
2912	UPDATE_STUDY_ADDRESSES	en    	Y	Update study addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2908	UPDATE_STUDENT_ABSENCES	en    	Y	Update students absences	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2909	UPDATE_STUDENT_ADDRESSES	en    	Y	Update student addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2838	DELETE_SUBJECTBLOCKS	en    	Y	Delete subject blocks	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2907	UPDATE_STUDENT_SUBSCRIPTION_DATA	en    	Y	Update student subscription data	opuscollege	2011-08-29 13:33:51.297472	\N	\N
3439	UPDATE_RESULT_VISIBILITY	en    	Y	Update result visibility for students	opuscollege	2014-03-05 14:59:12.908	\N	\N
3440	CREATE_RESULT_VISIBILITY	en    	Y	Add result visibility for students	opuscollege	2014-03-05 14:59:12.908	\N	\N
3441	DELETE_RESULT_VISIBILITY	en    	Y	Delete result visibility for students	opuscollege	2014-03-05 14:59:12.908	\N	\N
3442	UPDATE_PROGRESS_STATUS	pt    	Y	Actualizar estado do progresso do estudante	opuscollege	2014-03-05 14:59:12.908	\N	\N
3443	UPDATE_SCHOLARSHIP_FLAG	pt    	Y	Actualizar indicador de bolsa	opuscollege	2014-03-05 14:59:12.908	\N	\N
3444	UPDATE_RESULT_VISIBILITY	pt    	Y	Actualizar visibilidade de resultado para estudantes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3445	CREATE_RESULT_VISIBILITY	pt    	Y	Adicionar visibilidade de resultado para estudantes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3446	DELETE_RESULT_VISIBILITY	pt    	Y	Adicionar visibilidade de resultado para estudantes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3447	CREATE_RESULTS_ASSIGNED_SUBJECTS	en    	Y	Create subject results by assigned subject teachers	opuscollege	2014-03-05 14:59:12.908	\N	\N
3448	READ_RESULTS_ASSIGNED_SUBJECTS	en    	Y	Read subject results by assigned subject teachers	opuscollege	2014-03-05 14:59:12.908	\N	\N
3449	UPDATE_RESULTS_ASSIGNED_SUBJECTS	en    	Y	Update subject results by assigned subject teachers	opuscollege	2014-03-05 14:59:12.908	\N	\N
3450	DELETE_RESULTS_ASSIGNED_SUBJECTS	en    	Y	Delete subject results by assigned subject teachers	opuscollege	2014-03-05 14:59:12.908	\N	\N
3459	CREATE_SUBJECTS_RESULTS	en    	Y	Create subject results (and set any subject teacher)	opuscollege	2014-03-05 14:59:12.908	\N	\N
3460	READ_SUBJECTS_RESULTS	en    	Y	Read subject results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3461	UPDATE_SUBJECTS_RESULTS	en    	Y	Update all subject results (and set any subject teacher)	opuscollege	2014-03-05 14:59:12.908	\N	\N
3462	DELETE_SUBJECTS_RESULTS	en    	Y	Delete subject results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3463	CREATE_SUBJECTS_RESULTS	pt    	Y	Create subject results (and set any subject teacher)	opuscollege	2014-03-05 14:59:12.908	\N	\N
3464	READ_SUBJECTS_RESULTS	pt    	Y	Read subject results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3465	UPDATE_SUBJECTS_RESULTS	pt    	Y	Update all subject results (and set any subject teacher)	opuscollege	2014-03-05 14:59:12.908	\N	\N
3466	DELETE_SUBJECTS_RESULTS	pt    	Y	Delete subject results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3467	CREATE_SUBJECTS_RESULTS	nl    	Y	Create subject results (and set any subject teacher)	opuscollege	2014-03-05 14:59:12.908	\N	\N
3468	READ_SUBJECTS_RESULTS	nl    	Y	Read subject results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3469	UPDATE_SUBJECTS_RESULTS	nl    	Y	Update all subject results (and set any subject teacher)	opuscollege	2014-03-05 14:59:12.908	\N	\N
3470	DELETE_SUBJECTS_RESULTS	nl    	Y	Delete subject results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3471	CREATE_CARDINALTIMEUNIT_RESULTS	en    	Y	Create cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3472	READ_CARDINALTIMEUNIT_RESULTS	en    	Y	Read cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3473	UPDATE_CARDINALTIMEUNIT_RESULTS	en    	Y	Update all cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3474	DELETE_CARDINALTIMEUNIT_RESULTS	en    	Y	Delete cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3475	CREATE_CARDINALTIMEUNIT_RESULTS	pt    	Y	Create cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3476	READ_CARDINALTIMEUNIT_RESULTS	pt    	Y	Read cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3477	UPDATE_CARDINALTIMEUNIT_RESULTS	pt    	Y	Update all cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3478	DELETE_CARDINALTIMEUNIT_RESULTS	pt    	Y	Delete cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3479	CREATE_CARDINALTIMEUNIT_RESULTS	nl    	Y	Create cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3480	READ_CARDINALTIMEUNIT_RESULTS	nl    	Y	Read cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3481	UPDATE_CARDINALTIMEUNIT_RESULTS	nl    	Y	Update all cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3482	DELETE_CARDINALTIMEUNIT_RESULTS	nl    	Y	Delete cardinal time unit results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3483	CREATE_CLASSGROUPS	en    	Y	Create classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3484	READ_CLASSGROUPS	en    	Y	Read classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3485	UPDATE_CLASSGROUPS	en    	Y	Update classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3486	DELETE_CLASSGROUPS	en    	Y	Delete classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3487	CREATE_CLASSGROUPS	pt    	Y	Create classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3488	READ_CLASSGROUPS	pt    	Y	Read classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3489	UPDATE_CLASSGROUPS	pt    	Y	Update classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3490	DELETE_CLASSGROUPS	pt    	Y	Delete classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3491	CREATE_CLASSGROUPS	nl    	Y	Create classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3492	READ_CLASSGROUPS	nl    	Y	Read classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3493	UPDATE_CLASSGROUPS	nl    	Y	Update classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3494	DELETE_CLASSGROUPS	nl    	Y	Delete classes	opuscollege	2014-03-05 14:59:12.908	\N	\N
3495	CREATE_SUBJECT_CLASSGROUPS	en    	Y	Assign class to subject	opuscollege	2014-03-05 14:59:12.908	\N	\N
3496	DELETE_SUBJECT_CLASSGROUPS	en    	Y	Remove class from subject	opuscollege	2014-03-05 14:59:12.908	\N	\N
3497	CREATE_STUDENT_CLASSGROUPS	en    	Y	Assign student to class	opuscollege	2014-03-05 14:59:12.908	\N	\N
3498	DELETE_STUDENT_CLASSGROUPS	en    	Y	Remove student from class	opuscollege	2014-03-05 14:59:12.908	\N	\N
3499	CREATE_SUBJECT_CLASSGROUPS	pt    	Y	Assign class to subject	opuscollege	2014-03-05 14:59:12.908	\N	\N
3500	DELETE_SUBJECT_CLASSGROUPS	pt    	Y	Remove class from subject	opuscollege	2014-03-05 14:59:12.908	\N	\N
3501	CREATE_STUDENT_CLASSGROUPS	pt    	Y	Assign student to class	opuscollege	2014-03-05 14:59:12.908	\N	\N
3502	DELETE_STUDENT_CLASSGROUPS	pt    	Y	Remove student from class	opuscollege	2014-03-05 14:59:12.908	\N	\N
3503	CREATE_SUBJECT_CLASSGROUPS	nl    	Y	Assign class to subject	opuscollege	2014-03-05 14:59:12.908	\N	\N
3504	DELETE_SUBJECT_CLASSGROUPS	nl    	Y	Remove class from subject	opuscollege	2014-03-05 14:59:12.908	\N	\N
3505	CREATE_STUDENT_CLASSGROUPS	nl    	Y	Assign student to class	opuscollege	2014-03-05 14:59:12.908	\N	\N
3506	DELETE_STUDENT_CLASSGROUPS	nl    	Y	Remove student from class	opuscollege	2014-03-05 14:59:12.908	\N	\N
3507	DELETE_STUDYPLAN_RESULTS	en    	Y	Delete studyplan results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3508	DELETE_STUDYPLAN_RESULTS	nl    	Y	Delete studyplan results	opuscollege	2014-03-05 14:59:12.908	\N	\N
3509	DELETE_STUDYPLAN_RESULTS	pt    	Y	Remover resultados do plano do estudo	opuscollege	2014-03-05 14:59:12.908	\N	\N
3510	CREATE_ACCOMMODATION_DATA	pt    	Y	Criar informa&ccedil;&atilde;o de acomoda&ccedil;&atilde;o	opuscollege	2014-03-05 14:59:12.908	\N	\N
3511	UPDATE_ACCOMMODATION_DATA	pt    	Y	Actualizar informa&ccedil;&atilde;o de acomoda&ccedil;&atilde;o	opuscollege	2014-03-05 14:59:12.908	\N	\N
3512	DELETE_ACCOMMODATION_DATA	pt    	Y	Remover informa&ccedil;&atilde;o de acomoda&ccedil;&atilde;o	opuscollege	2014-03-05 14:59:12.908	\N	\N
3513	READ_ACCOMMODATION_DATA	pt    	Y	Visualizar informa&ccedil;&atilde;o de acomoda&ccedil;&atilde;o	opuscollege	2014-03-05 14:59:12.908	\N	\N
3514	ALLOCATE_ROOM	pt    	Y	Alocar quartos	opuscollege	2014-03-05 14:59:12.908	\N	\N
3515	APPLY_FOR_ACCOMMODATION	pt    	Y	Candidatar-se a acomoda&ccedil;&atilde;o	opuscollege	2014-03-05 14:59:12.908	\N	\N
\.


--
-- TOC entry 5324 (class 0 OID 0)
-- Dependencies: 361
-- Name: opusprivilegeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('opusprivilegeseq', 3515, true);


--
-- TOC entry 4887 (class 0 OID 126968)
-- Dependencies: 364
-- Data for Name: opusrole_privilege; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY opusrole_privilege (id, privilegecode, writewho, writewhen, role, validfrom, validthrough, active) FROM stdin;
28152	CREATE_IDENTIFICATION_DATA	opuscollege	2011-11-14 14:35:12.429078	admin	\N	\N	Y
28153	UPDATE_IDENTIFICATION_DATA	opuscollege	2011-11-14 14:35:12.429078	admin	\N	\N	Y
28154	DELETE_IDENTIFICATION_DATA	opuscollege	2011-11-14 14:35:12.429078	admin	\N	\N	Y
28155	READ_IDENTIFICATION_DATA	opuscollege	2011-11-14 14:35:12.429078	admin	\N	\N	Y
28159	READ_IDENTIFICATION_DATA	opuscollege	2011-11-14 14:35:12.429078	admin-B	\N	\N	Y
28160	CREATE_IDENTIFICATION_DATA	opuscollege	2011-11-14 14:35:12.429078	admin-C	\N	\N	Y
28161	UPDATE_IDENTIFICATION_DATA	opuscollege	2011-11-14 14:35:12.429078	admin-C	\N	\N	Y
28162	DELETE_IDENTIFICATION_DATA	opuscollege	2011-11-14 14:35:12.429078	admin-C	\N	\N	Y
28163	READ_IDENTIFICATION_DATA	opuscollege	2011-11-14 14:35:12.429078	admin-C	\N	\N	Y
28164	READ_IDENTIFICATION_DATA	opuscollege	2011-11-14 14:35:12.429078	admin-D	\N	\N	Y
28165	PROGRESS_ADMISSION_FLOW	opuscollege	2011-11-16 17:15:35.820205	registry	\N	\N	Y
28166	FINALIZE_ADMISSION_FLOW	opuscollege	2011-11-16 17:15:35.820205	registry	\N	\N	Y
28170	PROGRESS_CONTINUED_REGISTRATION_FLOW	opuscollege	2011-11-16 17:15:35.820205	registry	\N	\N	Y
28171	FINALIZE_CONTINUED_REGISTRATION_FLOW	opuscollege	2011-11-16 17:15:35.820205	registry	\N	\N	Y
28167	TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR	opuscollege	2011-11-16 17:15:35.820205	registry	\N	\N	Y
28172	PROGRESS_ADMISSION_FLOW	opuscollege	2011-11-18 16:53:22.010188	finance	\N	\N	Y
28175	FINALIZE_ADMISSION_FLOW	opuscollege	2011-11-18 16:55:35.912889	admin-S	\N	\N	Y
28176	FINALIZE_ADMISSION_FLOW	opuscollege	2011-11-18 16:55:35.912889	admin-D	\N	\N	Y
28173	TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR	opuscollege	2011-11-18 16:55:27.505842	admin-S	\N	\N	Y
28174	TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR	opuscollege	2011-11-18 16:55:27.505842	admin-D	\N	\N	Y
26943	ADMINISTER_SYSTEM	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26945	CREATE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26946	CREATE_BRANCHES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26947	CREATE_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26949	CREATE_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26950	CREATE_FEES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26951	CREATE_FOREIGN_STUDYPLAN_DETAILS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26952	CREATE_FOREIGN_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26953	CREATE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26954	CREATE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26955	CREATE_ROLES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26956	CREATE_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26957	CREATE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26958	CREATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26959	CREATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26960	CREATE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26961	CREATE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26962	CREATE_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26963	CREATE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26964	CREATE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26965	CREATE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26966	CREATE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26967	CREATE_STUDYPLANDETAILS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26968	CREATE_STUDYGRADETYPE_RFC	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26969	CREATE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26970	CREATE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26971	CREATE_SUBJECT_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26972	CREATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26973	CREATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26974	CREATE_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26975	CREATE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26976	CREATE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26977	CREATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26979	CREATE_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26980	CREATE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26981	DELETE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26982	DELETE_BRANCHES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26983	DELETE_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26984	DELETE_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26985	DELETE_FEES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26986	DELETE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26987	DELETE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26988	DELETE_ROLES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26989	DELETE_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26990	DELETE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26991	DELETE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26992	DELETE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26993	DELETE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26994	DELETE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26996	DELETE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26997	DELETE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26998	DELETE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
26999	DELETE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27000	DELETE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27001	DELETE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27002	DELETE_SUBJECT_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27003	DELETE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27004	DELETE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27005	DELETE_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27006	DELETE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27007	DELETE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27008	DELETE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27009	DELETE_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27010	DELETE_TESTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27011	DELETE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27012	GENERATE_STUDENT_REPORTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27013	GENERATE_STATISTICS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27014	READ_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27015	READ_BRANCHES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27016	READ_PRIMARY_AND_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27017	READ_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27018	READ_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27019	READ_FEES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27020	READ_INSTITUTIONS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27021	READ_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27022	READ_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27023	READ_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27024	READ_ROLES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27025	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27026	READ_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27027	READ_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27028	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27029	READ_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27030	READ_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27031	READ_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27032	READ_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27033	READ_STUDENT_MEDICAL_DATA	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27034	READ_STUDENT_SUBSCRIPTION_DATA	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27035	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27036	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27037	READ_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27038	READ_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27039	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27040	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27041	READ_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27042	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27043	READ_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27044	READ_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27045	READ_TESTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27046	READ_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27047	RESET_PASSWORD	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27048	UPDATE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27049	UPDATE_BRANCHES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27050	UPDATE_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27052	UPDATE_INSTITUTIONS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27053	UPDATE_FOREIGN_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27054	UPDATE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27055	UPDATE_OPUSUSER	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27056	UPDATE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27057	UPDATE_PROGRESS_STATUS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27058	UPDATE_ROLES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27059	UPDATE_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27060	UPDATE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27061	UPDATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27062	UPDATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27063	UPDATE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27064	UPDATE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27065	UPDATE_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27066	UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27067	UPDATE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27068	UPDATE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27069	UPDATE_STUDENT_MEDICAL_DATA	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27070	UPDATE_STUDENT_SUBSCRIPTION_DATA	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27071	UPDATE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27072	UPDATE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27073	UPDATE_STUDYGRADETYPE_RFC	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27074	UPDATE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27075	UPDATE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27076	UPDATE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27077	UPDATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27078	UPDATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27079	UPDATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27080	UPDATE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27081	TRANSFER_CURRICULUM	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27082	TRANSFER_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27085	CREATE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27086	CREATE_BRANCHES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27087	CREATE_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27089	CREATE_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27090	CREATE_FEES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27091	CREATE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27092	CREATE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27093	CREATE_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27094	CREATE_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27095	CREATE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27096	CREATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27097	CREATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27098	CREATE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27099	CREATE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27100	CREATE_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27101	CREATE_STUDYPLANDETAILS_PENDING_APPROVAL	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27102	CREATE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27103	CREATE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27104	CREATE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27105	CREATE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27106	CREATE_STUDYPLANDETAILS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27107	CREATE_STUDYGRADETYPE_RFC	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27108	CREATE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27109	CREATE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27110	CREATE_SUBJECT_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27111	CREATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27112	CREATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27113	CREATE_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27114	CREATE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27115	CREATE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27116	CREATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27118	CREATE_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27119	CREATE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27120	DELETE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27121	DELETE_BRANCHES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27122	DELETE_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27123	DELETE_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27124	DELETE_FEES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27125	DELETE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27126	DELETE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27127	DELETE_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27128	DELETE_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27051	UPDATE_FEES	opuscollege	2011-08-29 13:34:01.160205	registry	\N	\N	Y
27129	DELETE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27130	DELETE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27131	DELETE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27132	DELETE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27133	DELETE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27135	DELETE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27136	DELETE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27137	DELETE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27138	DELETE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27139	DELETE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27140	DELETE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27141	DELETE_SUBJECT_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27142	DELETE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27143	DELETE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27144	DELETE_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27145	DELETE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27146	DELETE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27147	DELETE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27148	DELETE_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27149	DELETE_TESTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27150	DELETE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27151	FINALIZE_ADMISSION_FLOW	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27152	PROGRESS_ADMISSION_FLOW	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27153	GENERATE_STUDENT_REPORTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27154	GENERATE_STATISTICS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27155	READ_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27156	READ_BRANCHES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27157	READ_PRIMARY_AND_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27158	READ_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27159	READ_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27160	READ_FEES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27161	READ_INSTITUTIONS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27162	READ_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27163	READ_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27164	READ_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27165	READ_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27166	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27167	READ_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27168	READ_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27169	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27170	READ_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27171	READ_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27172	READ_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27173	READ_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27174	READ_STUDENT_MEDICAL_DATA	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27175	READ_STUDENT_SUBSCRIPTION_DATA	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27176	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27177	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27178	READ_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27179	READ_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27180	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27181	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27182	READ_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27183	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27184	READ_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27185	READ_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27186	READ_TESTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27187	READ_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27188	RESET_PASSWORD	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27189	UPDATE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27190	UPDATE_BRANCHES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27191	UPDATE_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27192	UPDATE_FEES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27193	UPDATE_FOREIGN_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27194	UPDATE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27195	UPDATE_OPUSUSER	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27196	UPDATE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27197	UPDATE_PROGRESS_STATUS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27198	UPDATE_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27199	UPDATE_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27200	UPDATE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27201	UPDATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27202	UPDATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27203	UPDATE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27204	UPDATE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27207	UPDATE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27208	UPDATE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27209	UPDATE_STUDENT_MEDICAL_DATA	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27210	UPDATE_STUDENT_SUBSCRIPTION_DATA	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27211	UPDATE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27212	UPDATE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27213	UPDATE_STUDYGRADETYPE_RFC	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27214	UPDATE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27215	UPDATE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27216	UPDATE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27217	UPDATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27218	UPDATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27219	UPDATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27220	UPDATE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27222	TRANSFER_CURRICULUM	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27223	TRANSFER_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-C	\N	\N	Y
27225	GENERATE_STUDENT_REPORTS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27226	GENERATE_STATISTICS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27227	READ_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27228	READ_BRANCHES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27229	READ_PRIMARY_AND_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27230	READ_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27231	READ_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27232	READ_FEES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27233	READ_INSTITUTIONS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27234	READ_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27235	READ_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27236	READ_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27237	READ_ROLES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27238	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27239	READ_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27240	READ_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27241	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27242	READ_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27243	READ_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27244	READ_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27245	READ_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27246	READ_STUDENT_MEDICAL_DATA	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27247	READ_STUDENT_SUBSCRIPTION_DATA	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27248	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27249	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27250	READ_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27251	READ_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27252	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27253	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27254	READ_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27255	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27256	READ_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27257	READ_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27258	READ_TESTS	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27259	READ_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27260	UPDATE_BRANCHES	opuscollege	2011-08-29 13:34:01.160205	dvc	\N	\N	Y
27261	GENERATE_STUDENT_REPORTS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27262	GENERATE_STATISTICS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27263	READ_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27264	READ_BRANCHES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27265	READ_PRIMARY_AND_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27266	READ_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27267	READ_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27268	READ_FEES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27269	READ_INSTITUTIONS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27270	READ_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27271	READ_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27272	READ_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27273	READ_ROLES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27274	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27275	READ_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27276	READ_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27277	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27278	READ_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27279	READ_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27280	READ_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27281	READ_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27282	READ_STUDENT_MEDICAL_DATA	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27284	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27285	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27286	READ_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27287	READ_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27288	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27289	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27290	READ_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27291	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27292	READ_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27293	READ_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27294	READ_TESTS	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27295	READ_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	audit	\N	\N	Y
27298	CREATE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27299	CREATE_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27301	CREATE_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27302	CREATE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27303	CREATE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27304	CREATE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27305	CREATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27306	CREATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27307	CREATE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27308	CREATE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27309	CREATE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27310	CREATE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27311	CREATE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27312	CREATE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27313	CREATE_STUDYGRADETYPE_RFC	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27314	CREATE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27315	CREATE_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27316	CREATE_STUDYPLANDETAILS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27317	CREATE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27318	CREATE_SUBJECT_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27319	CREATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27320	CREATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27321	CREATE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27322	CREATE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27323	CREATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27324	CREATE_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27325	CREATE_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27326	CREATE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27327	DELETE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27328	DELETE_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27329	DELETE_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27330	DELETE_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27331	DELETE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27332	DELETE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27333	DELETE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27334	DELETE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27335	DELETE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27336	DELETE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27337	DELETE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27338	DELETE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27339	DELETE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27340	DELETE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27341	DELETE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27342	DELETE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27343	DELETE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27344	DELETE_SUBJECT_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27345	DELETE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27346	DELETE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27347	DELETE_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27348	DELETE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27349	DELETE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27350	DELETE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27351	DELETE_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27352	DELETE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27353	GENERATE_STUDENT_REPORTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27354	GENERATE_STATISTICS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27355	FINALIZE_CONTINUED_REGISTRATION_FLOW	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27356	PROGRESS_CONTINUED_REGISTRATION_FLOW	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27357	READ_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27358	READ_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27359	READ_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27360	READ_FEES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27361	READ_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27362	READ_OPUSUSER	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27363	READ_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27364	READ_PRIMARY_AND_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27365	READ_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27366	READ_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27367	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27368	READ_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27369	READ_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27370	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27371	READ_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27372	READ_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27373	READ_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27374	READ_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27375	READ_STUDENT_SUBSCRIPTION_DATA	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27376	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27377	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27378	READ_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27379	READ_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27380	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27381	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27382	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27383	READ_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27384	READ_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27385	READ_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27386	READ_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27387	TRANSFER_CURRICULUM	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27388	TRANSFER_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27390	UPDATE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27391	UPDATE_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27392	UPDATE_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27393	UPDATE_FOREIGN_STUDYPLAN_DETAILS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27394	UPDATE_FOREIGN_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27395	UPDATE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27396	UPDATE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27397	UPDATE_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27398	UPDATE_PROGRESS_STATUS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27399	UPDATE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27400	UPDATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27401	UPDATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27402	UPDATE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27403	UPDATE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27404	UPDATE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27405	UPDATE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27406	UPDATE_STUDENT_SUBSCRIPTION_DATA	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27407	UPDATE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27408	UPDATE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27410	UPDATE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27411	UPDATE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27412	UPDATE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27413	UPDATE_STUDYGRADETYPE_RFC	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27414	UPDATE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27415	UPDATE_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27416	UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27417	UPDATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27418	UPDATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27419	UPDATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-S	\N	\N	Y
27421	CREATE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27422	CREATE_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27424	CREATE_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27425	CREATE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27426	CREATE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27427	CREATE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27428	CREATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27429	CREATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27430	CREATE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27431	CREATE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27432	CREATE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27433	CREATE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27434	CREATE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27435	CREATE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27436	CREATE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27437	CREATE_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27438	CREATE_STUDYPLANDETAILS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27439	CREATE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27440	CREATE_SUBJECT_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27441	CREATE_STUDYGRADETYPE_RFC	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27442	CREATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27443	CREATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27444	CREATE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27445	CREATE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27446	CREATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27447	CREATE_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27448	CREATE_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27449	CREATE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27450	DELETE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27451	DELETE_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27452	DELETE_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27453	DELETE_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27454	DELETE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27455	DELETE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27456	DELETE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27457	DELETE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27458	DELETE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27459	DELETE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27460	DELETE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27461	DELETE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27462	DELETE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27463	DELETE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27464	DELETE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27465	DELETE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27466	DELETE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27467	DELETE_SUBJECT_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27468	DELETE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27469	DELETE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27470	DELETE_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27471	DELETE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27472	DELETE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27473	DELETE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27474	DELETE_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27475	DELETE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27476	GENERATE_STUDENT_REPORTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27477	GENERATE_STATISTICS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27478	FINALIZE_CONTINUED_REGISTRATION_FLOW	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27479	PROGRESS_CONTINUED_REGISTRATION_FLOW	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27480	READ_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27481	READ_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27482	READ_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27483	READ_FEES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27484	READ_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27485	READ_OPUSUSER	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27486	READ_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27487	READ_PRIMARY_AND_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27488	READ_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27489	READ_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27490	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27491	READ_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27492	READ_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27493	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27494	READ_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27495	READ_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27496	READ_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27497	READ_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27498	READ_STUDENT_SUBSCRIPTION_DATA	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27499	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27500	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27501	READ_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27502	READ_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27503	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27504	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27505	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27506	READ_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27507	READ_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27508	READ_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27509	READ_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27510	UPDATE_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27511	UPDATE_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27512	UPDATE_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27513	UPDATE_FOREIGN_STUDYPLAN_DETAILS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27514	UPDATE_FOREIGN_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27515	UPDATE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27516	UPDATE_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27517	UPDATE_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
28177	CREATE_STUDYPLANDETAILS_PENDING_APPROVAL	opuscollege	2011-12-12 13:15:51.713108	admin-S	\N	\N	Y
27519	UPDATE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27520	UPDATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27521	UPDATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27522	UPDATE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27523	UPDATE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27524	UPDATE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27525	UPDATE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27526	UPDATE_STUDENT_SUBSCRIPTION_DATA	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27527	UPDATE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27528	UPDATE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27530	UPDATE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27531	UPDATE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27532	UPDATE_STUDYGRADETYPE_RFC	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27533	UPDATE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27534	UPDATE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27535	UPDATE_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27536	UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27537	UPDATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27538	UPDATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27539	UPDATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-B	\N	\N	Y
27541	CREATE_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27543	CREATE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27544	CREATE_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27545	CREATE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27546	CREATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27547	CREATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27548	CREATE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27549	CREATE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27550	CREATE_STUDYPLANDETAILS_PENDING_APPROVAL	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27551	CREATE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27552	CREATE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27553	CREATE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27554	CREATE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27555	CREATE_STUDYGRADETYPE_RFC	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27556	CREATE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27557	CREATE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27558	CREATE_SUBJECT_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27559	CREATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27560	CREATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27561	CREATE_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27562	CREATE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27563	CREATE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27564	CREATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27565	CREATE_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27566	CREATE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27567	DELETE_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27568	DELETE_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27569	DELETE_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27570	DELETE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27571	DELETE_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27572	DELETE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27573	DELETE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27574	DELETE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27575	DELETE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27576	DELETE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27577	DELETE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27578	DELETE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27579	DELETE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27580	DELETE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27581	DELETE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27582	DELETE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27583	DELETE_SUBJECT_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27584	DELETE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27585	DELETE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27586	DELETE_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27587	DELETE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27588	DELETE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27589	DELETE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27590	DELETE_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27591	DELETE_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27592	GENERATE_STUDENT_REPORTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27593	GENERATE_STATISTICS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27594	READ_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27595	READ_EXAMINATION_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27596	READ_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27597	READ_FEES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27598	READ_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27599	READ_OPUSUSER	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27600	READ_PRIMARY_AND_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27601	READ_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27602	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27603	READ_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27604	READ_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27605	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27606	READ_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27607	READ_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27608	READ_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27609	READ_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27610	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27611	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27612	READ_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27613	READ_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27614	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27615	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27616	READ_SUBJECT_TEACHERS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27617	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27618	READ_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27619	READ_TEST_SUPERVISORS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27620	READ_USER_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27621	PROGRESS_CONTINUED_REGISTRATION_FLOW	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27622	UPDATE_EXAMINATIONS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27623	UPDATE_LOOKUPS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27624	UPDATE_PRIMARY_AND_CHILD_ORG_UNITS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27625	UPDATE_PROGRESS_STATUS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27626	UPDATE_ROLES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27627	UPDATE_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27628	UPDATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27629	UPDATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27630	UPDATE_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27631	UPDATE_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27632	UPDATE_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27633	UPDATE_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27634	UPDATE_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27635	UPDATE_STUDIES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27636	UPDATE_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27637	UPDATE_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27638	UPDATE_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27639	UPDATE_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27640	UPDATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27641	UPDATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
28186	READ_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	registry	\N	\N	Y
27642	UPDATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	admin-D	\N	\N	Y
27643	READ_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27644	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27645	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27646	READ_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27647	READ_OWN_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27648	READ_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27649	READ_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27650	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27651	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27652	READ_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27653	READ_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27654	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27655	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27656	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27657	READ_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	teacher	\N	\N	Y
27660	READ_OWN_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	student	\N	\N	Y
27661	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	student	\N	\N	Y
27662	READ_STUDENTS_SAME_STUDYGRADETYPE	opuscollege	2011-08-29 13:34:01.160205	student	\N	\N	Y
27663	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	student	\N	\N	Y
27664	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	student	\N	\N	Y
27666	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	guest	\N	\N	Y
27667	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	guest	\N	\N	Y
27668	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	guest	\N	\N	Y
27669	CREATE_FEES	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27670	DELETE_FEES	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27671	GENERATE_STUDENT_REPORTS	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27672	GENERATE_STATISTICS	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27675	READ_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27676	READ_FEES	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27677	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27678	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27679	READ_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27680	READ_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27681	READ_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27682	READ_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27683	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27684	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27685	READ_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27686	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27687	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27688	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27689	READ_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
28178	REVERSE_PROGRESS_STATUS	opuscollege	2011-12-12 13:18:20.764334	admin	\N	\N	Y
27691	UPDATE_FEES	opuscollege	2011-08-29 13:34:01.160205	finance	\N	\N	Y
27692	GENERATE_STUDENT_REPORTS	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27693	GENERATE_STATISTICS	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27695	READ_FEES	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27696	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27697	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27698	READ_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27699	READ_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27700	READ_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27702	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27704	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27705	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27706	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	library	\N	\N	Y
27708	GENERATE_STUDENT_REPORTS	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27709	GENERATE_STATISTICS	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27711	READ_SECONDARY_SCHOOLS	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27712	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27713	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27714	READ_STUDY_PLANS	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27715	READ_STUDYPLAN_RESULTS	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27716	READ_STUDENT_ABSENCES	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27717	READ_STUDENT_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27718	READ_STUDENT_MEDICAL_DATA	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27720	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27722	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27723	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27724	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	dos	\N	\N	Y
27726	GENERATE_STATISTICS	opuscollege	2011-08-29 13:34:01.160205	pr	\N	\N	Y
27727	READ_ACADEMIC_YEARS	opuscollege	2011-08-29 13:34:01.160205	pr	\N	\N	Y
27728	READ_STAFFMEMBERS	opuscollege	2011-08-29 13:34:01.160205	pr	\N	\N	Y
27729	READ_STUDENTS	opuscollege	2011-08-29 13:34:01.160205	pr	\N	\N	Y
27730	READ_STUDIES	opuscollege	2011-08-29 13:34:01.160205	pr	\N	\N	Y
27731	READ_STUDY_ADDRESSES	opuscollege	2011-08-29 13:34:01.160205	pr	\N	\N	Y
27732	READ_SUBJECTS	opuscollege	2011-08-29 13:34:01.160205	pr	\N	\N	Y
27733	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	pr	\N	\N	Y
27734	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	pr	\N	\N	Y
27735	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-08-29 13:34:01.160205	pr	\N	\N	Y
27736	READ_SUBJECTBLOCKS	opuscollege	2011-08-29 13:34:01.160205	pr	\N	\N	Y
27737	UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL	opuscollege	2011-08-29 13:34:15.141559	admin-D	\N	\N	Y
28179	REVERSE_PROGRESS_STATUS	opuscollege	2011-12-12 13:18:20.764334	registry	\N	\N	Y
28180	REVERSE_PROGRESS_STATUS	opuscollege	2011-12-12 13:18:20.764334	admin-S	\N	\N	Y
28181	CREATE_STUDYPLANDETAILS_PENDING_APPROVAL	opuscollege	2011-12-12 13:18:20.764334	registry	\N	\N	Y
28182	READ_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	admin	\N	\N	Y
28183	CREATE_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	admin	\N	\N	Y
28184	UPDATE_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	admin	\N	\N	Y
28185	DELETE_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	admin	\N	\N	Y
28187	CREATE_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	registry	\N	\N	Y
28188	UPDATE_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	registry	\N	\N	Y
28189	DELETE_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	registry	\N	\N	Y
28190	READ_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	dos	\N	\N	Y
28191	CREATE_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	dos	\N	\N	Y
28192	UPDATE_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	dos	\N	\N	Y
28193	DELETE_STUDENT_NOTES	opuscollege	2011-12-21 16:01:18.656314	dos	\N	\N	Y
28214	TRANSFER_CURRICULUM	opuscollege	2012-01-10 16:54:28.65697	admin-B	\N	\N	Y
28215	TRANSFER_STUDENTS	opuscollege	2012-01-10 16:54:28.65697	admin-B	\N	\N	Y
28216	READ_STUDENT_NOTES	opuscollege	2012-01-18 11:19:33.407234	admin-B	\N	\N	Y
28194	READ_STUDENT_COUNSELING	opuscollege	2011-12-21 20:04:36.930572	dos	\N	\N	Y
28195	CREATE_STUDENT_COUNSELING	opuscollege	2011-12-21 20:04:36.930572	dos	\N	\N	Y
28196	UPDATE_STUDENT_COUNSELING	opuscollege	2011-12-21 20:04:36.930572	dos	\N	\N	Y
28197	DELETE_STUDENT_COUNSELING	opuscollege	2011-12-21 20:04:36.930572	dos	\N	\N	Y
28218	READ_IDENTIFICATION_DATA	opuscollege	2012-01-19 13:42:47.961299	dos	\N	\N	Y
27932	TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR	opuscollege	2011-10-18 15:12:19.972188	admin-C	\N	\N	Y
27942	CREATE_FEES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27943	UPDATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27944	UPDATE_STAFFMEMBERS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27945	UPDATE_BRANCHES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27947	UPDATE_STUDENT_SUBSCRIPTION_DATA	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27948	DELETE_LOOKUPS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27949	GENERATE_STUDENT_REPORTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27950	CREATE_FOREIGN_STUDYPLAN_RESULTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27951	DELETE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27952	READ_STAFF_MEMBERS_MENU	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27953	CREATE_ORG_UNITS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27954	UPDATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27955	WRITE_BRANCHES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27956	READ_EXAMS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27957	DELETE_TEST_SUPERVISORS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27958	READ_ORGANIZATIONS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27959	WRITE_ORG_UNITS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27960	READ_EXAMINATION_SUPERVISORS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27961	DELETE_ORG_UNITS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27962	UPDATE_FOREIGN_STUDYPLAN_DETAILS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27963	READ_BRANCHES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27964	WRITE_STUDIES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27965	READ_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27966	DELETE_INSTITUTIONS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27967	READ_STAFF_MEMBERS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27968	WRITE_STUDY_PLANS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27969	READ_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27970	READ_SUBJECT_TEACHERS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27971	TRANSFER_CURRICULUM	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27972	GENERATE_STATISTICS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27973	READ_STAFFMEMBER_CONTRACTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27974	DELETE_SUBJECT_TEACHERS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27975	UPDATE_EXAMINATIONS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27976	UPDATE_INSTITUTIONS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27977	CREATE_STAFFMEMBERS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27978	READ_STUDIES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27979	DELETE_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27980	READ_FEES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27981	UPDATE_PROGRESS_STATUS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27982	DELETE_STUDIES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27983	DELETE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27985	CREATE_STUDYGRADETYPE_RFC	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27986	CREATE_STUDENT_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27987	UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27988	DELETE_SUBJECT_PREREQUISITES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27989	DELETE_BRANCHES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27990	UPDATE_PRIMARY_AND_CHILD_ORG_UNITS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27991	UPDATE_OPUSUSER	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27992	CREATE_SECONDARY_SCHOOLS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27993	READ_SUBJECTBLOCKS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27994	RESET_PASSWORD	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27995	ADMINISTER_SYSTEM	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27996	CREATE_BRANCHES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27997	WRITE_ACADEMIC_YEARS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
27998	FINALIZE_CONTINUED_REGISTRATION_FLOW	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28000	CREATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28001	CREATE_SUBJECT_TEACHERS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28002	DELETE_STUDY_PLANS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28003	CREATE_STUDYPLANDETAILS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28004	UPDATE_FEES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28005	UPDATE_LOOKUPS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28006	CREATE_INSTITUTIONS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28007	READ_INSTITUTIONS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28008	READ_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28009	READ_ACADEMIC_YEARS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28010	CREATE_SUBJECTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28011	READ_INSTITUTIONS_MENU	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28012	WRITE_STAFF_MEMBERS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28013	CREATE_ROLES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28014	CREATE_CHILD_ORG_UNITS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28015	CREATE_LOOKUPS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28016	DELETE_STAFF_MEMBERS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28017	CREATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28018	DELETE_SECONDARY_SCHOOLS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28019	WRITE_STUDENTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28020	UPDATE_ACADEMIC_YEARS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28021	READ_TEST_SUPERVISORS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28022	CREATE_USER_ROLES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28023	UPDATE_STUDENT_ABSENCES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28024	READ_LOOKUPS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28025	READ_EXAMINATIONS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28026	CREATE_ACADEMIC_YEARS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28027	CREATE_STUDENTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28028	UPDATE_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28029	DELETE_ACADEMIC_YEARS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28030	UPDATE_STUDENTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28031	TRANSFER_STUDENTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28032	UPDATE_STUDYPLANRESULTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28033	CREATE_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28034	UPDATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28035	DELETE_ORGANIZATIONS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28036	PROGRESS_CONTINUED_REGISTRATION_FLOW	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28037	READ_STUDENTS_MENU	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28038	CREATE_STAFFMEMBER_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28040	WRITE_SUBJECTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28041	CREATE_STUDY_PLANS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28042	UPDATE_STUDYPLAN_RESULTS_UPON_APPEAL	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28043	WRITE_USER_ROLES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28044	DELETE_STUDENTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28045	DELETE_STUDENT_ABSENCES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28046	READ_SUBJECT_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28048	UPDATE_STUDIES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28049	READ_SCHOLARSHIP_MENU	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28050	UPDATE_ROLES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28051	CREATE_TEST_SUPERVISORS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28052	CREATE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28053	CREATE_STAFFMEMBER_CONTRACTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28054	DELETE_SUBJECTBLOCKS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28055	READ_STUDYPLAN_RESULTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28056	CREATE_SUBJECTBLOCKS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28057	UPDATE_STUDYGRADETYPE_RFC	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28058	DELETE_STUDY_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28059	WRITE_EXAMS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28060	UPDATE_STUDYPLAN_RESULTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28061	DELETE_ROLES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28062	READ_PRIMARY_AND_CHILD_ORG_UNITS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28063	READ_RESULTS_MENU	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28064	DELETE_SUBJECTBLOCK_PREREQUISITES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28065	DELETE_CHILD_ORG_UNITS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28066	DELETE_FEES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28067	CREATE_STUDY_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28069	FINALIZE_ADMISSION_FLOW	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28070	DELETE_EXAMS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28073	READ_STUDY_PLANS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28074	CREATE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28075	READ_TESTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28076	WRITE_ORGANIZATIONS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28077	DELETE_STAFFMEMBER_CONTRACTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28078	READ_FEE_MENU	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28080	CREATE_STUDENT_ABSENCES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28081	UPDATE_FOREIGN_STUDYPLAN_RESULTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28082	READ_REPORT_MENU	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28083	WRITE_FEES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28084	CREATE_STUDYPLANDETAILS_PENDING_APPROVAL	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28085	CREATE_STUDYPLAN_RESULTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28086	READ_STUDIES_MENU	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28087	DELETE_USER_ROLES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28088	READ_USER_ROLES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28089	DELETE_STAFFMEMBER_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28090	READ_STUDENT_SUBSCRIPTION_DATA	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28092	DELETE_TESTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28093	READ_OWN_STUDYPLAN_RESULTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28096	DELETE_SUBJECTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28097	DELETE_STAFFMEMBERS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28099	READ_STUDY_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28100	READ_ALUMNI_MENU	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28101	READ_ROLES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28102	READ_SUBJECTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28103	READ_STUDENT_ABSENCES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28104	UPDATE_STUDENT_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28105	WRITE_INSTITUTIONS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28106	DELETE_EXAMINATIONS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28107	WRITE_ROLES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28108	PROGRESS_ADMISSION_FLOW	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28109	READ_STUDENT_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28110	READ_ORGANIZATIONS_MENU	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28111	READ_STUDENTS_SAME_STUDYGRADETYPE	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28112	DELETE_STUDENT_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28113	READ_ADMIN_MENU	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28114	UPDATE_SUBJECTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28115	UPDATE_STUDY_PLANS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28116	UPDATE_ORG_UNITS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28117	UPDATE_STUDY_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28118	READ_STUDENT_MEDICAL_DATA	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28119	UPDATE_SECONDARY_SCHOOLS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28120	DELETE_EXAMINATION_SUPERVISORS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28121	CREATE_SUBJECT_PREREQUISITES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28122	UPDATE_STUDENT_MEDICAL_DATA	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28123	CREATE_STUDIES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28124	READ_OPUSUSER	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28125	READ_STAFFMEMBERS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28127	WRITE_LOOKUPS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28128	UPDATE_SUBJECTBLOCKS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28129	READ_STUDENTS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28130	READ_SECONDARY_SCHOOLS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28131	UPDATE_SUBJECT_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28132	UPDATE_USER_ROLES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28133	READ_ORG_UNITS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28134	CREATE_FOREIGN_STUDYPLAN_DETAILS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28135	READ_STAFFMEMBER_ADDRESSES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28136	CREATE_EXAMINATION_SUPERVISORS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28137	DELETE_SUBJECTBLOCK_STUDYGRADETYPES	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28138	UPDATE_SUBJECT_SUBJECTBLOCKS	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28198	READ_FINANCE	opuscollege	2012-01-05 15:01:08.520582	admin	\N	\N	Y
28199	CREATE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	admin	\N	\N	Y
28200	UPDATE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	admin	\N	\N	Y
28201	DELETE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	admin	\N	\N	Y
28202	READ_FINANCE	opuscollege	2012-01-05 15:01:08.520582	registry	\N	\N	Y
28203	CREATE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	registry	\N	\N	Y
28204	UPDATE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	registry	\N	\N	Y
28205	DELETE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	registry	\N	\N	Y
28206	READ_FINANCE	opuscollege	2012-01-05 15:01:08.520582	admin-C	\N	\N	Y
28207	CREATE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	admin-C	\N	\N	Y
28208	UPDATE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	admin-C	\N	\N	Y
28209	DELETE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	admin-C	\N	\N	Y
28210	READ_FINANCE	opuscollege	2012-01-05 15:01:08.520582	finance	\N	\N	Y
28211	CREATE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	finance	\N	\N	Y
28212	UPDATE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	finance	\N	\N	Y
28213	DELETE_FINANCE	opuscollege	2012-01-05 15:01:08.520582	finance	\N	\N	Y
28072	TOGGLE_CUTOFFPOINT_ADMISSION_BACHELOR	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
28219	CREATE_IDENTIFICATION_DATA	opuscollege	2012-02-07 15:24:58.073892	registry	\N	\N	Y
28220	UPDATE_IDENTIFICATION_DATA	opuscollege	2012-02-07 15:24:58.073892	registry	\N	\N	Y
28221	DELETE_IDENTIFICATION_DATA	opuscollege	2012-02-07 15:24:58.073892	registry	\N	\N	Y
28222	READ_IDENTIFICATION_DATA	opuscollege	2012-02-07 15:24:58.073892	registry	\N	\N	Y
28223	GENERATE_HISTORY_REPORTS	opuscollege	2012-02-09 14:28:17.39831	admin	\N	\N	Y
28224	GENERATE_HISTORY_REPORTS	opuscollege	2012-02-09 14:28:17.39831	registry	\N	\N	Y
28225	GENERATE_HISTORY_REPORTS	opuscollege	2012-02-09 14:28:17.39831	admin-C	\N	\N	Y
28226	GENERATE_HISTORY_REPORTS	opuscollege	2012-02-09 14:28:17.39831	audit	\N	\N	Y
28227	CREATE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	admin	\N	\N	Y
28228	UPDATE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	admin	\N	\N	Y
28229	DELETE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	admin	\N	\N	Y
28230	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	admin	\N	\N	Y
28231	CREATE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	registry	\N	\N	Y
28232	UPDATE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	registry	\N	\N	Y
28233	DELETE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	registry	\N	\N	Y
28234	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	registry	\N	\N	Y
28235	CREATE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	admin-C	\N	\N	Y
28236	UPDATE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	admin-C	\N	\N	Y
28237	DELETE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	admin-C	\N	\N	Y
28238	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	admin-C	\N	\N	Y
28239	CREATE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	dos	\N	\N	Y
28240	UPDATE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	dos	\N	\N	Y
28241	DELETE_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	dos	\N	\N	Y
28242	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	dos	\N	\N	Y
28243	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	admin-B	\N	\N	Y
28244	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	admin-D	\N	\N	Y
28245	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	admin-S	\N	\N	Y
28246	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	teacher	\N	\N	Y
28247	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	student	\N	\N	Y
28248	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	finance	\N	\N	Y
28249	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	library	\N	\N	Y
28250	READ_ACCOMMODATION_DATA	opuscollege	2012-04-16 14:00:45.202224	audit	\N	\N	Y
28253	READ_IDENTIFICATION_DATA	opuscollege	2012-04-16 14:07:11.610447	finance	\N	\N	Y
28254	READ_STUDENT_SUBSCRIPTION_DATA	opuscollege	2012-04-16 14:07:11.610447	finance	\N	\N	Y
28255	READ_OPUSUSER	opuscollege	2012-04-16 14:07:11.610447	finance	\N	\N	Y
28256	READ_IDENTIFICATION_DATA	opuscollege	2012-04-16 14:07:11.610447	audit	\N	\N	Y
28257	READ_STUDENT_SUBSCRIPTION_DATA	opuscollege	2012-04-16 14:07:11.610447	audit	\N	\N	Y
28258	READ_OPUSUSER	opuscollege	2012-04-16 14:07:11.610447	audit	\N	\N	Y
28259	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	admin	\N	\N	Y
28260	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	registry	\N	\N	Y
28261	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	admin-C	\N	\N	Y
28262	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	admin-B	\N	\N	Y
28263	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	admin-S	\N	\N	Y
28264	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	admin-D	\N	\N	Y
28265	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	teacher	\N	\N	Y
28266	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	finance	\N	\N	Y
28267	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	library	\N	\N	Y
28268	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	audit	\N	\N	Y
28269	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	dos	\N	\N	Y
28270	ACCESS_CONTEXT_HELP	opuscollege	2012-04-16 14:07:21.776523	pr	\N	\N	Y
28271	CREATE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	admin	\N	\N	Y
28272	UPDATE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	admin	\N	\N	Y
28273	DELETE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	admin	\N	\N	Y
28274	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	admin	\N	\N	Y
28275	CREATE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	registry	\N	\N	Y
28276	UPDATE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	registry	\N	\N	Y
28277	DELETE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	registry	\N	\N	Y
28278	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	registry	\N	\N	Y
28279	CREATE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	admin-C	\N	\N	Y
28280	UPDATE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	admin-C	\N	\N	Y
28281	DELETE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	admin-C	\N	\N	Y
28282	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	admin-C	\N	\N	Y
28283	CREATE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	finance	\N	\N	Y
28284	UPDATE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	finance	\N	\N	Y
28285	DELETE_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	finance	\N	\N	Y
28286	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	finance	\N	\N	Y
28287	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	admin-B	\N	\N	Y
28288	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	admin-D	\N	\N	Y
28289	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	admin-S	\N	\N	Y
28290	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	teacher	\N	\N	Y
28291	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	student	\N	\N	Y
28292	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	dos	\N	\N	Y
28293	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	library	\N	\N	Y
28294	READ_SCHOLARSHIPS	opuscollege	2012-04-16 14:30:12.48538	audit	\N	\N	Y
28303	UPDATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL	opuscollege	2012-05-22 13:34:32.434954	student	\N	\N	Y
28746	ALLOCATE_ROOM	opuscollege	2012-10-02 18:31:34.489	admin	\N	\N	Y
28747	ALLOCATE_ROOM	opuscollege	2012-10-02 18:31:34.489	dos	\N	\N	Y
28748	CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL	opuscollege	2012-10-02 18:31:34.489	student	\N	\N	Y
28749	APPROVE_SUBJECT_SUBSCRIPTIONS	opuscollege	2012-10-02 18:31:34.489	registry	\N	\N	Y
28750	APPROVE_SUBJECT_SUBSCRIPTIONS	opuscollege	2012-10-02 18:31:34.489	admin-C	\N	\N	Y
28751	APPROVE_SUBJECT_SUBSCRIPTIONS	opuscollege	2012-10-02 18:31:34.489	admin-S	\N	\N	Y
28752	APPROVE_SUBJECT_SUBSCRIPTIONS	opuscollege	2012-10-02 18:31:34.489	admin-B	\N	\N	Y
28753	APPROVE_SUBJECT_SUBSCRIPTIONS	opuscollege	2012-10-02 18:31:34.489	admin-D	\N	\N	Y
28754	APPLY_FOR_ACCOMMODATION	opuscollege	2012-10-02 18:31:34.489	student	\N	\N	Y
28755	APPLY_FOR_ACCOMMODATION	opuscollege	2012-10-02 18:31:34.489	admin	\N	\N	Y
28756	GENERATE_STUDENT_REPORTS	opuscollege	2012-10-02 18:31:34.489	teacher	\N	\N	Y
28757	READ_STUDENT_SUBSCRIPTION_DATA	opuscollege	2012-10-02 18:31:34.489	admin-D	\N	\N	Y
28758	READ_ORG_UNITS	opuscollege	2012-10-02 18:31:34.489	dos	\N	\N	Y
28759	READ_BRANCHES	opuscollege	2012-10-02 18:31:34.489	dos	\N	\N	Y
28760	UPDATE_SCHOLARSHIP_FLAG	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28761	UPDATE_SCHOLARSHIP_FLAG	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28762	UPDATE_SCHOLARSHIP_FLAG	opuscollege	2014-03-05 14:59:12.908	student	\N	\N	Y
28763	UPDATE_RESULT_VISIBILITY	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28764	UPDATE_RESULT_VISIBILITY	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28765	CREATE_RESULT_VISIBILITY	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28766	CREATE_RESULT_VISIBILITY	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28767	DELETE_RESULT_VISIBILITY	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28768	DELETE_RESULT_VISIBILITY	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28769	CREATE_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	teacher	\N	\N	Y
28770	READ_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	teacher	\N	\N	Y
28771	UPDATE_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	teacher	\N	\N	Y
28772	DELETE_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	teacher	\N	\N	Y
28781	CREATE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28782	READ_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28783	UPDATE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28784	DELETE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28785	CREATE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28786	READ_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28787	UPDATE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28788	DELETE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28789	CREATE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28790	READ_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28791	UPDATE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28792	DELETE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28793	CREATE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28794	READ_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28795	UPDATE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28796	DELETE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28797	CREATE_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28798	READ_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28799	UPDATE_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28800	DELETE_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28809	CREATE_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28810	READ_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28811	UPDATE_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28812	DELETE_RESULTS_ASSIGNED_SUBJECTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28821	CREATE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-C	\N	\N	Y
28822	CREATE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28823	CREATE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28824	READ_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-C	\N	\N	Y
28825	READ_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	dvc	\N	\N	Y
28826	READ_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	audit	\N	\N	Y
28827	READ_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28828	READ_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28829	READ_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28830	READ_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	teacher	\N	\N	Y
28831	READ_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	finance	\N	\N	Y
28832	READ_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	dos	\N	\N	Y
28833	UPDATE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28834	UPDATE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28835	UPDATE_CARDINALTIMEUNIT_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28836	CREATE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-C	\N	\N	Y
28837	CREATE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28838	CREATE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28839	READ_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-C	\N	\N	Y
28840	READ_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	dvc	\N	\N	Y
28841	READ_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	audit	\N	\N	Y
28842	READ_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28843	READ_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28844	READ_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28845	READ_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	teacher	\N	\N	Y
28846	READ_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	finance	\N	\N	Y
28847	READ_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	dos	\N	\N	Y
28848	UPDATE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28849	UPDATE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28850	UPDATE_SUBJECTS_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28851	CREATE_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28852	CREATE_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-C	\N	\N	Y
28853	CREATE_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28854	CREATE_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28855	CREATE_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28856	READ_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28857	READ_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-C	\N	\N	Y
28858	READ_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	dvc	\N	\N	Y
28859	READ_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	audit	\N	\N	Y
28860	READ_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28861	READ_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28862	READ_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28863	READ_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	teacher	\N	\N	Y
28864	READ_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	finance	\N	\N	Y
28865	READ_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	dos	\N	\N	Y
28866	READ_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28867	UPDATE_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28868	UPDATE_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28869	UPDATE_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28870	UPDATE_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28871	UPDATE_EXAMINATION_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28872	CREATE_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28873	CREATE_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-C	\N	\N	Y
28874	CREATE_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28875	CREATE_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28876	CREATE_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28877	READ_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28878	READ_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-C	\N	\N	Y
28879	READ_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	dvc	\N	\N	Y
28880	READ_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	audit	\N	\N	Y
28881	READ_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28882	READ_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28883	READ_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28884	READ_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	teacher	\N	\N	Y
28885	READ_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	finance	\N	\N	Y
28886	READ_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	dos	\N	\N	Y
28887	READ_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28888	UPDATE_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28889	UPDATE_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-S	\N	\N	Y
28890	UPDATE_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-B	\N	\N	Y
28891	UPDATE_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-D	\N	\N	Y
28892	UPDATE_TEST_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28893	CREATE_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28894	READ_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28895	UPDATE_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28896	DELETE_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28897	CREATE_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28898	READ_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28899	UPDATE_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28900	DELETE_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28901	CREATE_SUBJECT_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28902	DELETE_SUBJECT_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28903	CREATE_STUDENT_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28904	DELETE_STUDENT_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28905	CREATE_SUBJECT_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28906	DELETE_SUBJECT_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28907	CREATE_STUDENT_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28908	DELETE_STUDENT_CLASSGROUPS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
28909	DELETE_STUDYPLAN_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin-C	\N	\N	Y
28910	DELETE_STUDYPLAN_RESULTS	opuscollege	2014-03-05 14:59:12.908	registry	\N	\N	Y
28911	DELETE_STUDYPLAN_RESULTS	opuscollege	2014-03-05 14:59:12.908	admin	\N	\N	Y
\.


--
-- TOC entry 5325 (class 0 OID 0)
-- Dependencies: 363
-- Name: opusrole_privilegeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('opusrole_privilegeseq', 28911, true);


--
-- TOC entry 4889 (class 0 OID 126980)
-- Dependencies: 366
-- Data for Name: opususer; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY opususer (id, personid, username, pw, writewho, writewhen, lang, preferredorganizationalunitid, failedloginattempts) FROM stdin;
226	242	admin	21232f297a57a5a743894a0e4a801fc3	opuscollege	2011-05-17 14:20:49.072314	en_ZM	94	0
174	183	registry	a9205dcfd4a6f7c2cbe8be01566ff84a	opuscollege	2011-02-22 11:24:02.206331	en_ZM	94	0
\.


--
-- TOC entry 4891 (class 0 OID 126995)
-- Dependencies: 368
-- Data for Name: opususerrole; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY opususerrole (id, role, username, writewho, writewhen, validfrom, validthrough, organizationalunitid, active) FROM stdin;
312	registry	registry	opuscollege	2011-08-04 20:11:08.279632	2011-08-04	\N	94	Y
243	admin	admin	opuscollege	2011-05-17 14:20:49.188692	2011-05-17	\N	94	Y
\.


--
-- TOC entry 5326 (class 0 OID 0)
-- Dependencies: 367
-- Name: opususerroleseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('opususerroleseq', 524, true);


--
-- TOC entry 5327 (class 0 OID 0)
-- Dependencies: 365
-- Name: opususerseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('opususerseq', 496, true);


--
-- TOC entry 4694 (class 0 OID 125643)
-- Dependencies: 171
-- Data for Name: organizationalunit; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY organizationalunit (id, organizationalunitcode, organizationalunitdescription, active, branchid, unitlevel, parentorganizationalunitid, unitareacode, unittypecode, academicfieldcode, directorid, registrationdate, writewho, writewhen) FROM stdin;
2	UNIV1BRANCH1UN1	UEM-unit1	Y	106	1	0	1	1	1	4	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
3	UNIV2BRANCH1UN1	ISPU-unit1	Y	110	1	0	1	1	1	5	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
4	UNIV3BRANCH1UN1	UCM-unit1	Y	107	1	0	1	1	1	6	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
5	UNIV4BRANCH1UN1	UMBB-unit1	Y	109	1	0	1	1	1	7	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
6	UNIV5BRANCH1UN1	UP-unit1	Y	108	1	0	1	1	1	8	2008-02-01	opuscollege	2008-02-01 08:19:48.945068
8	UP-FCNMUN1	Universidade Pedagógica - FCNM	Y	108	1	0	1	1	1	11	2008-02-05	opuscollege	2008-02-05 10:40:35.743689
9	UP-FCSUN1	Universidade Pedagógica - FCS	Y	108	1	0	1	1	1	12	2008-02-05	opuscollege	2008-02-05 10:40:35.743689
10	UP-FCEFDUN1	Universidade Pedagógica - FCEFD	Y	108	1	0	1	1	1	13	2008-02-05	opuscollege	2008-02-05 10:40:35.743689
11	UP-FLUN1	Universidade Pedagógica - FL	Y	108	1	0	1	1	1	14	2008-02-05	opuscollege	2008-02-05 10:40:35.743689
12	UP-FCPUN1	Universidade Pedagógica - FCP	Y	108	1	0	1	1	1	15	2008-02-05	opuscollege	2008-02-05 10:40:35.743689
13	UCM-PEMBAUN1	UCM-Pemba-unit1	Y	113	1	0	1	1	1	16	2008-02-07	opuscollege	2008-02-07 13:52:32.702844
54	UNIZAMBEZEBRANCH1UNIT1	UNIZAMBEZE-unit1	Y	117	1	0	1	1	1	100	2009-11-18	opuscollege	2009-11-18 15:58:13.257641
59	UNZABRANCH1UNIT1	UNZA-unit1	Y	119	1	0	1	1	1	160	2010-01-01	opuscollege	2011-01-06 15:32:36.928222
83	O13017052011150433	Mulungushi-unit1	Y	126	1	0	0	0	0	0	2011-05-17	opuscollege	2011-05-17 15:03:32.309921
93	O11104082011211237	MEC Unit 1	Y	111	1	0	2	0	0	0	2011-08-04	opuscollege	2011-08-04 21:12:35.598622
94	O12105082011101053	Registrars Office	Y	120	1	0	0	0	0	0	2011-08-05	opuscollege	2011-08-05 10:11:56.473823
95	O12105082011101110	Bursars Office	Y	120	1	0	0	0	0	0	2011-08-05	opuscollege	2011-08-05 10:12:17.83549
96	O12105082011101122	Internal Audit	Y	120	1	0	0	0	0	0	2011-08-05	opuscollege	2011-08-05 10:12:32.475409
78	O12111052011111122	Academic Office	Y	120	1	0	2	3	0	0	2011-05-11	opuscollege	2011-11-23 14:08:49.233986
129	O14222052012150717	Faculteit Biologie	Y	142	1	0	0	0	0	0	2012-05-22	opuscollege	2012-05-22 15:07:36.752191
130	O14222052012151229	vakgroep Ethologie	Y	142	2	129	0	0	0	0	2012-05-22	opuscollege	2012-05-22 15:13:05.534068
131	O12025052012155813	Dean's office	Y	145	1	0	2	3	10	0	2012-05-25	opuscollege	2012-05-25 15:58:48.005
132	O12025052012155948	Teaching Department	Y	145	1	0	1	2	10	0	2012-05-25	opuscollege	2012-05-25 16:00:05.054
135	O12125052012163111	Dean's office	Y	146	1	0	2	3	28	0	2012-05-25	opuscollege	2012-05-25 16:31:35.068
136	O12125052012163223	Teaching Department	Y	146	1	0	1	2	28	0	2012-05-25	opuscollege	2012-05-25 16:32:38.054
133	O12025052012160109	Dean's office	Y	144	1	0	2	3	81	0	2012-05-25	opuscollege	2012-05-25 16:34:04.166
134	O12025052012160202	Teaching Department	Y	144	1	0	1	2	81	0	2012-05-25	opuscollege	2012-05-25 16:34:16.573
137	O12125052012163441	Dean's office	Y	147	1	0	1	3	25	0	2012-05-25	opuscollege	2012-05-25 16:35:18.544
138	O12125052012163544	Teaching Department	Y	147	1	0	1	2	25	0	2012-05-25	opuscollege	2012-05-25 16:36:00.357
139	O12125052012163950	Dean's office	Y	148	1	0	2	3	54	0	2012-05-25	opuscollege	2012-05-25 16:40:10.1
140	O12125052012164037	Teaching Department	Y	148	1	0	1	2	54	0	2012-05-25	opuscollege	2012-05-25 16:40:57.929
141	O12125052012164343	Dean's office	Y	149	1	0	2	3	34	0	2012-05-25	opuscollege	2012-05-25 16:44:19.702
142	O12125052012164446	Teaching Department	Y	149	1	0	1	2	34	0	2012-05-25	opuscollege	2012-05-25 16:44:56.89
143	O12125052012164754	Dean's office	Y	150	1	0	2	3	85	0	2012-05-25	opuscollege	2012-05-25 16:48:12.256
144	O12125052012164836	Teaching Department	Y	150	1	0	1	2	85	0	2012-05-25	opuscollege	2012-05-25 16:48:48.085
145	O12125052012165034	Dean's office	Y	151	1	0	2	3	2	0	2012-05-25	opuscollege	2012-05-25 16:50:51.605
146	O12125052012165116	Teaching Department	Y	151	1	0	1	2	2	0	2012-05-25	opuscollege	2012-05-25 16:51:32.387
147	O12125052012165200	Dean's office	Y	152	1	0	2	3	3	0	2012-05-25	opuscollege	2012-05-25 16:52:11.357
148	O12125052012165238	Teaching Department	Y	152	1	0	1	2	3	0	2012-05-25	opuscollege	2012-05-25 16:52:48.608
\.


--
-- TOC entry 5328 (class 0 OID 0)
-- Dependencies: 227
-- Name: organizationalunitacademicyearseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('organizationalunitacademicyearseq', 37, true);


--
-- TOC entry 5329 (class 0 OID 0)
-- Dependencies: 170
-- Name: organizationalunitseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('organizationalunitseq', 148, true);


--
-- TOC entry 4893 (class 0 OID 127009)
-- Dependencies: 370
-- Data for Name: penalty; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY penalty (id, studentid, penaltytypecode, amount, startdate, enddate, remark, paid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5330 (class 0 OID 0)
-- Dependencies: 369
-- Name: penaltyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('penaltyseq', 1, false);


--
-- TOC entry 4895 (class 0 OID 127023)
-- Dependencies: 372
-- Data for Name: penaltytype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY penaltytype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
1	1	en	Y	Late cardinal time-unit registration (bursar)	opuscollege	2012-04-16 14:01:11.752894
2	2	en	Y	Late examination registration (bursar)	opuscollege	2012-04-16 14:01:11.752894
3	3	en	Y	Losing / destroying books (library)	opuscollege	2012-04-16 14:01:11.752894
4	4	en	Y	Losing keys (accommodation, dean of students)	opuscollege	2012-04-16 14:01:11.752894
5	5	en	Y	Breaking windows (accommodation, dean of students)	opuscollege	2012-04-16 14:01:11.752894
\.


--
-- TOC entry 5331 (class 0 OID 0)
-- Dependencies: 371
-- Name: penaltytypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('penaltytypeseq', 5, true);


--
-- TOC entry 4897 (class 0 OID 127035)
-- Dependencies: 374
-- Data for Name: person; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY person (id, personcode, active, surnamefull, surnamealias, firstnamesfull, firstnamesalias, nationalregistrationnumber, civiltitlecode, gradetypecode, gendercode, birthdate, nationalitycode, placeofbirth, districtofbirthcode, provinceofbirthcode, countryofbirthcode, cityoforigin, administrativepostoforigincode, districtoforigincode, provinceoforigincode, countryoforigincode, civilstatuscode, housingoncampus, identificationtypecode, identificationnumber, identificationplaceofissue, identificationdateofissue, identificationdateofexpiration, professioncode, professiondescription, languagefirstcode, languagefirstmasteringlevelcode, languagesecondcode, languagesecondmasteringlevelcode, languagethirdcode, languagethirdmasteringlevelcode, contactpersonemergenciesname, contactpersonemergenciestelephonenumber, bloodtypecode, healthissues, photograph, remarks, registrationdate, writewho, writewhen, photographname, photographmimetype, publichomepage, socialnetworks, hobbies, motivation) FROM stdin;
242	P897897	Y	Admin	\N	M.M.J.	M.M.		0	0	1	1950-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-17	opuscollege	2011-05-17 14:20:49.003771	\N	\N	N	\N	\N	\N
183	P0987	Y	Registrar	\N	V.C.		234243234	1	PHD	1	1960-09-23	130	Ndola	0	ZM-02	894	Lusaka	\N	0	ZM-05	894	1	N	3	12430802834	Lusaka	2010-10-20	2020-10-20	\N	Professor	eng	1	cha	1	dut	2	Mother	034554235235	3		\\xffd8ffe000104a46494600010101004800480000ffdb00430001010101010101010101010101010101010101010101010101010101010101010101010102020101020101010202020202020202020102020202020202020202ffdb00430101010101010101010101020101010202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202ffc0001108004b006403012200021101031101ffc4001f0000010501010101010100000000000000000102030405060708090a0bffc400b5100002010303020403050504040000017d01020300041105122131410613516107227114328191a1082342b1c11552d1f02433627282090a161718191a25262728292a3435363738393a434445464748494a535455565758595a636465666768696a737475767778797a838485868788898a92939495969798999aa2a3a4a5a6a7a8a9aab2b3b4b5b6b7b8b9bac2c3c4c5c6c7c8c9cad2d3d4d5d6d7d8d9dae1e2e3e4e5e6e7e8e9eaf1f2f3f4f5f6f7f8f9faffc4001f0100030101010101010101010000000000000102030405060708090a0bffc400b51100020102040403040705040400010277000102031104052131061241510761711322328108144291a1b1c109233352f0156272d10a162434e125f11718191a262728292a35363738393a434445464748494a535455565758595a636465666768696a737475767778797a82838485868788898a92939495969798999aa2a3a4a5a6a7a8a9aab2b3b4b5b6b7b8b9bac2c3c4c5c6c7c8c9cad2d3d4d5d6d7d8d9dae2e3e4e5e6e7e8e9eaf2f3f4f5f6f7f8f9faffda000c03010002110311003f00fe343c61e00f16f822d74dbed56dbc3da8db6bb6b1df69ade1df16786bc58c6cf6c68e2fc785b56bc3a5ce09ff005574b0cbdf66071dcfc39f1afc2cd2be12fc4df0ef893e0d6bdae7c4fd7dad25f87bf16b4ff1e6ade1d83c0c9656f2adf69579e1b8b4c96cfc4905cc850912c90c836ed475ce4f89f957b6b7177796975f659a364f3608c8f3665745da70a0862075ef8fc6bd0bc05f1a35ff008717063d36dac2f12fe6579d6fa18a60ef7036b078a5521d48ee3a66bf3ae24c350cd3eb34f2ccbaad0a519d19c28cf1d521594a92a7270a95e952c3a9c1c937c9ecd425093a538cb593fbdcbb1398e57470f88c5d4a58cc7c7da4675295054a84e33a93509429cab62a54e71872c26e5526e528ba89463254e3e51a469735edcb3acea3558d669e3b69de181a46030190cd2290fdf039e2b76c6ca286e2f60bbd5161789e486686e66f2649e556468f6152163293292183ed2139c57ddbe1ff00d9cf44f8b365e25f8b3e31f19691e0f6f0f35bcc91d869b6b6da3de99acee6f6d22bad40c8469d7724b6e6257103c41976cd246ceb5f0b69da34bac7884c529b2b982e2f755884ad703ecd6e2312ca2e2694ed0e9e565d4a33160bf2ee3c57b997e073dc4e1ea6256555a50c561a9e26d1c3caa545454d36f0ef97df849a69ca34f9adccba4ade463aa468430d27560d3af28724ab41c233704d2aca324a32519292551a6d34dc7e13eabf86d0fc55d5340f8adf0665f1fdea7826fb4cf09ddeb5e14d0fc4165a9f87359d6db56b7b7f09eb73699a55dc9278aae74bb9d4b7c12592dc489f3ac84461c8f60f84ff00f04c0f8b7e38d5eda7f12eb9a7f84224bb32453da472ea9ac8485894be3609b56c449b772c72bab8de32a0f15f737ec2ff00b31d8f847c3b61a9dec16177e2ed4c4b24fae24305d4ba6e99398e5169a6df2961e53798a432b9ea7a118afdfef857f08749d334b822b5b48be68e27f35e20cf31db992492565e589246493ce2bf35f15fc76c6d79e57c3fc1f9243035f22c32c357cc713899e36ae220f1188af4610a4e9d1a347d851af0c3b708b5354aee11ba51fdefc1ef00b26c4e5f89cff8cb14f11fdb95d62a9e0f0d463848d397d5f0d42a4eb5684ea56af2ab3c3baa9ca71942128d352928294bf183c03ff04f53f0a3c3f69e2ff85fe2cd562f8f1a26a3a969f71e39d634eb5ff8476e3c1fa9d904bad29bc29369f28fed337ea2479e4796da7825786587072696b1aaf82fe0fdc5aea23f67fbef01fc40bfb68ac7c47e27f8113ffc231a678cb59b78a59ae3c593e891f9d696f7afabac0d2c16f15bc2bbcc82142013fd24f877c0ab648f3c76f049130c379b1237201000c2f4ce073ed5e1ff001afe00f823e29f8335cf08789b42b2586e44da869b7505b2437fa56ac22648f51b09d103432b0cac8036d7462ae0822bf983c50f18f8c788259663788f0b4f1183ca70b430752582a4b0952be1b0f294a32c5aa52e4c74e973cb91574da4df2bbab3fe80c97c0be14cab0b984384aad4cbf31c456ab89a3f58c455c553a55eab8ca4a8c6bb9bc2a9f2a8b74b48deea2ec7f101fb594ba5f8abe20def8e748f13f8b7c577fe309a6d67c5f73e34874a4d6f49d69d922bdd3f51d534c758af265b88d90e618255f294c91e5813c2fc1a9fc47e1a99ae3c3d6da6de9d4a54926b0bdbc297897b1b496c64b18202ed719ddca01bf9cedc1c9f4afdb57e11f8cbe05fc64f107807c45696e96d6fb6ebc3779670bac3abe89772b1b0bee49325ce55a393a953185ee2bd8ff650f03c5a57826ebc41a8592c3a9fdba5beb79268313a79371a7c31ca77a654e647c743c62bf75cf78932fcbfc26c9b18aac739c16634b0f1a29f272d585457a70bd25049528a8c7dd8a94792d25cdcc7e53e13f0866b8bf1633086229cf2ec5e4d2aaabcb5528558d94e49be64fda3bcb5bc651a8dc6cac37f68bb7d653e10ff00c4c52de5d6ae748b6927fb13395105eb422ce1549103c6e913bf0c39df91cd7e66dbf82fc45046d770413c7f6089d2f6592192358c02aea50b20f3088a45e3ef06214e0919fdd0fda0ac61d4acf4a916de255bdb189a4202ed2d0eab7208202e3ee212076db8af893c53a45aafc2eba8a3b916973ab78aad34eb79963121324ba979b28656236a2dbc1231239f9057078399a4a3c0ab1fece387fae62eab71b5e2959292d17c306a4924b4d3b59fd77d20a8c319e22d0c0d4a7f58fa9e0a118da4e328deacdc795df76bd9df9af749abae66c97e0a7ec47acfc56f00e9de33935e974c8efee2e60b6b75b1798bdbdaf971aceec07cacce64f97b051457ec4fc23d7fe1bfc3af871e11f0a2f8abc3300b0d1ed58adf6b3676f76ef32079659e176ca3b4de6120f3cd15fca19f78f5e2b4b3bcd9e4f1ad4f2afacd65878fd520ed45546a9ddba2db7cb6bddef73f40cbbc27e0f8603050c5e55edf151a50f693f6957de9f2c799fbb34b577b5b43f02eefe02f892ebc007e22693adfc33bdd36de157bed2ad3e287828f8d109748159bc152eae9a94cfbe44cf956ee42e5ce1559878c6ac9a68d2d6de2b3be875db7bcb45b86964b792d36223f9bb605b459229832ae4994af07e5ee3b7d234bd5ed6de7b782d5f5042d3dc6e8617927815812e4a4721f91411ce318aa5e0f9bc21a2789edae7e21f85b5cf1be8855dae7c3fa36bcbe17d42f228813b62d4d6cee0db60756f2989f4ef5fe9ae273eca29e1a72c9785a52ab4b0f28ca12af4f1756bd44d4bda61bdbd3c3c70f3d128a957496a9d5516cff003ba8e5d9c42a548e6b9d53f675b12e74e51c3d6c2428d1692a74711eceae2a5899293939548d3a6a69c7f70a50e697b07c3af1bea7e0ef851e3cfed4d1b5abed0b5cbfd3b408b5a8af524d0345d66fad5ae521689ade48ee6e6e6c45dab5bcae8a172ea43a64757e06fd9f75df8d9ac7c2f6f0bcff000d34c96cb4e306b963a283e1fbc3a5f87b51827bbd5fc45a6eab34a350f10dce93a84855a129e70d39a3110650efcb4fa4fecd3e2b8fc23a3fc2ed17e3acbf14bc45af18af7c31e2fb9f0749f0eadacae6665b45d3aff4abbfed2b996d612a0cd3a2f9a22672a85b60fd0fff00826c7ecf7a1fc4ff00dadbe29fc34f1ad98b4f12f80fc28d79e015b6f3f4ab79af57574d2aeb5844b799bed11c36f35a4e031954a48ccea4035eae57e2eff67f0fe633ad92e738d9e1f010a18259a660d52caead1af1f695305818c62de16779ca9d38578429f339ba95da518982e05c7677c4795e0e38fcbe852c563dfb5a984c3dbeb54e58795a8e2f1328d472ac9a527374e33972d3a6a34a2e4ea7ec1feccbe17812de2b78ed638534ff002ec1a303f751c5690ac51c91a6d1b62d91ae0e00c30efcd7ec0fc2dd3aca1b0d39becd1decd2a84b6858abb4f23165dde5ecc32ee03049c64e6bf2f7e03e89aadd3eb9671c72596a92eb0fa71f397ca78a4f9ecb518f6823608c09d891d9148048c57d5d732f8c61ba834ed23c0df12efbfb3e3b1d2e5f1cf86fc6da7f83b48f0edb211e66a70e9b245717dabdac43e49152d5a491df291b26645fe3f79753cc33acca5531094e75aac949f2de769377f79a4acbbbb5cfeedcb331965392e5d0faac9aa542945c23cd78ed14ad08ca4ecfa455fae88fd189ac2f23636971a1ad9c822321b6974f625d238c3ef8da3c6e18db919e073ce2bc67c71a4cad05ccde52c43ca9372112213b4672a0fcc18118c7a8a87c13f123c4f63e0dd42f756d6f5fd475bb2f0f4f35a5bf8a0c526b5099a6812e5ae2e2dd42cecc90e378553b0e3009c57c67f123e32fc414d6f52fed51f1320b1994dd586a5a67812c350f0d4b7125dc76c6cdae2df526d4c84255e42b66db6066b86ca29c7cce6fc334336a38ec1d0c6a938c6553f7908ab436f7b956fcd16be1edb1f6784e24596c70989c461254bda4a34d28393e6a9a5edcd656b5b5727adf57a33f1e7fe0ab91e95e09d5be12fc6187c29e1cf147887c25e209b4f583c49a7bdee9922a27f6959d8deaaaf97708de5cceb0cfc3885fcbf9b20fc2be1bf88561e34f0acfe20d33c33a2f846e7c4baf5ad95cf86fc385d746d3753d6357fb75d41a7412cd23db5bf9088c232d84de4280a001fa25fb77f8ab55bdd07c0fa06a367a46abaaf8f75dd71eebc15aa5d58dc787b5a7f0e6897aeb1ea16174ead36a715a5c3cfa5cb108a58aed09866562d1c9f961f0fe731f8bfc096c2d9a1d2a5d5edf5b96c24bd8aeae619346b49adef92f145ac4609d6e1e1daae1880c06f6c1af8fcb32ff0067e1ee4b80c765b52963b2378bab4311525387b6c2431389ab1a34e9caa72d5a0aa42ac69d5f65753a75631a965289e5e0339cc70be35e3565f5e35727cfa8e1e96229469c65ecabd4c3d28c6bceac55e9d56952bd3736e74e74e5c8f9a333d23e38eb06d74df0dc65d80906b2abc6e3986eaedd010587dd32af1db3c57c87e31d4edecfc27e1213ed915753d6b55652a4ab3288e0816407ab6fb93b49e7935ec9f1df5b7d46d3c20f00777b8bdf1735bc680b3c8e6f57ca895507ccc4380000738c015e55e3df867f1074ff0008f86aebc4be13d4344d36eb469e5b59f55f26cdaea5bf9125816de1697cc12ec8559432ab1eb8c026bf5fe02c461b2de01c97038bc4430f2c5e2b16b91ce3094ad56aa92826ef27b5edb5d5ec793e27602a663e27e698ac2d27567470b8474fdd728ddd3a334a5a6def36d75b3b6c782c7e35f11cad3c86f19cc9713392f374cb7dc50c784030001c0c515ea1a17c21d2ae34f496feea5d3ae5dd8bda5cabbc91e55083bd386539c83ef457af573ee15a75674dd24dc1db4a0dad2cb46b46bcd68fa74386870b71fce8d39bc728f324eceb24f5b6ea4ae9ef74f54f73f63fc29fb737fc13befed86a1f137fe0947e1ed2aeb50b39a0bbbcf831f1fbc5be169e5b5b8825b5b8586cfc41a45e0891ed659571e76e01f2181c11f9fbfb56f8b7fe09e3e23f0df88efbf653f81bfb48fc14f1cebc2454d2fc77f10fc0df11bc0f0d9477a9a8a69d6e24d093548184b0c4892433472145c3b3a92adb9a9781635d3ed765ba045d3d5fcadbb308e3e5da093870ac73cf6c915f34f8cbc1313eafe1dd225b7b7316aad7d69fe937525941179d6b70b05ccb751e197c96db2f5f98c413072457070166d83cd389324c3657571385ab53134953a143113853a928cfdda352936e15213b46128d4528494acfcbf3fe35e03a19564f9ae65512ace852949d4ad2a93e56d457b54e537cae2db9a946ce2d687cfde3bf875e28f82fe28f04dd7c45d22c9df53d0fc33e35fec8f0f78a34bbf6d53c27e24822bfb2316b1e19d42e9749bd96c19c4b6f215bab5914c571047202b5fa05fb23fed35f187c21fb48fc32fda223b2d0fc2df0ff004376f0af88f4ebbb9d23c31f6ef8697361268136b92de5fa411eadab58e99343224d20f32f25d3f272efb87c03e08f86bac7c41f1359fc37b6d7fc34d79a86b171a4e9faaf897c5363e1cd22cee5a658adee1f5cd6ae56d74eb46918798f3b246a33b9801b8751a7784759b1d4753d375ef16685aa5df8292ee2b74bdf10477de1f16ba38668f40b38544b6dad6a573203f62b73fe8d74e0c627cb293fd8199e1b19c4794e75c23c19c2b3c42ab5aacf0f87f62b198f728c143131588a50a75aad2a51854e583953841275542735373fe59ca7155b87f35ca789f89337a6abe0a9d2756b529d4c3619ca3273a52f613a9888539ce5cb7b7b49cefecdd4845ae5fec6fe0878afc37aa78e2f7c4be1cd6acfc43e0ff136a126b3a6ebba7dcc379a76a90eab76d27f6869f3dac8c9241279f064a310afbd0ed2081fadae9e148fc316baf4ba88b6d8b143068d65197bdd5ae59731c76de6811c6cc3019dc85455663d2bf97cff00823ff88754f12fc3dd4bc1de28b7b1d3754d2bc67a9de5869d1c106966cb46d62e9750b64b7b2b7256ca11782422151fbb520051c0afdc2f1ec5e3af0f787348d4b4db74f11dc692f771b68f05d8b5fb3c9a7b3831cb2c83699e602df63104648565dacc47f2663324861333c5e0f16e34a34e5ef4a5cc9c65a3be966e57d2df0f35d3d343fb5f87b89962b2cc1e3a9e0e55ab62e31e5a4b916bcdcae32752ea318eee4f55049a77b33bbd2fc45a5eb3aa6bb7bad6a3a1783f4e3a4ea51fd8353bcb817d2bc6d227912cd3c43cdb9da8a70a3665b86c633a9a32f81fc41e1a93534669af34eb08d99e477f2e69115c2dc2e028961754231203b19707822be6897e34eaf77e1b935ed47e1a1825d36764f264bab6134129311682e6db52804b2cfe69525d11d5f7b0c10456be81e2ef1078efc39a9eb3ac6810f802e6e6c82d95ac7750092f34d984a921bc48ca88d920866ba57f2d0a25b32b64b57859d6439742a42ad3c5b8621d09fbaf4538fc4a49a76bc649d935aa936d9fa3d4c76759761684b32c8e10c0d7ad1509c671a9284da8bb4a376e51e56af34fdd692574ec7e19ff00c148fe077c48f8edfb497c1fd5fe19e93ff099ba5e6a3e10b5f07785b4fd6ae7c57a5cda42db78af50f11c66ca3fb3456af6768d128f345d136f232c4d1ee75fcfbb2d660d2fc7be30d6b572ba7db783b49b9b6be92e4188da5eccd34f7ad700ae44aade507c8ce460f35f62f8dbf6ae821fda0fc42ba25e78bbc169a5789a4d3fc4d2784f5c7b19fc4fa768fa7ead69a5eb1696f7ecf15bf88b37fe44a5248629ed1ff7789d46ff0084b5ff001068dae6b3f122de4d3af748d1bc493bac42f24baf106a72d9de88639ae6f12daddae75078c92eea2269c00ca558819f3a197567c3190f0de2f2ccc6a62f2ec3d57ed7f732a31c1e638e8e2670a34a9d2551d6e6ab89927cf579e8ce9fb550aaa7cdf2592f1552a5c679ce3a955c1d0c1e69898ce6dca719fd672cc1d4c3d275aa3ab2a72a0d53c3a518469ca9d584aca71a89c3a3d1b5df08dfebbf0db57d4bc4be1c3a7f866d35dd6ae164d6b4d68e4d42fc58cfa3a902e0ee63999f18e0c58600f15eb1f16bf68ef87de38f01a787f59f127852d4fd8e2b75bdb8ba1732e9d75673bc91dc58dbda991e79dc310480157771c57e6af843e0cf87e3baf1adff008becef353f0de8da9cde1e6d62c2df58d1df4b1a8976d07c716567a85b40f75a22ca8b1dc432c61d1261263e46159de07f841a6ebf26a9af2bdaebba3784b5c3a6f88bc29a3eacd06bda8e93a74066d4f5ab4bc9a32b65e6da969acf992395ed2685ca10bbbf518703f0e51c0d0c2cf1b53170cbe552ad0af2a2e84e2ead49e2344ea7b927cdac6aa4aca119adcfcb73ae3fceb37cfa39d3cb2384c455a74284e953c4aad4e52c3d3a743da2bd052e5972f372c25269f338c9e97fad7fe133f843aa456d732fc4ef0cdacab6b6f6f24427beb5c49044a923324f600bb170c770f94f62714571107ecf3f0ebc7718f107c1ef86ff0017bc67e0a949b7b6d7a4f16f873484b8be83fe3f6086d352b312f9713ba465c8c3491b81c0a2be5df0cf0ec1b83cc31f41c5db926f0509476d2519d48ce2d755249aedb1f510f1278a1462a31c0ca292b34eac935a5ad250927d35e67b6e7da5a86bba4cf726531ca6dd609594a3876e3f75115d930fdde5707e52306be28fda175c5bf58a3b077f3e273656a6276130b97465c45b0655b7371807f3adcf116bdacf84fc31e0ef186ad3e9bfd8bf1034e12f8756c359d3f54d4716f8499b52d2ac2e5ee349248042dc468491d335e1f26b567ab78a34bbbd6a7ba3a7d8eaf16ad7b15a5afef5ed60955a48d24ba648e390aa900b9da49e6bc2e05e0ec4e539be1b35c2ce58afa8ca4a93a2dcdbaf464e32845c1cad521562e9cacef192b3b58d78df8c32cc7e4b8acaaa558d178d505514daa6e34aaa8b53fde72e92a72e783b3524d357b9e14be15920f345f5ebee45125cdb90eb333b7ccd12c72aabb1da70df2f39c73c9a9b49d1ae25d56cae74937709fb6db2878e57501629919d256e0088853956047180335f73699fb377c63fda63c48b7ff043e07fc42f18dbc71ac16fab41a35e5b69d29384496eb53b878ed970b8008940c2679e2bebaf873ff0443fdb87c75a46ada86a5a5f823e171d1607bab1d1fc4fe2269b57d5eea305e382d6d3c3b6f7621666500493b20dcc0107ad7f5264b3c5d0a786cc336cd29e4b8b718d49519ce2b114e6d5ece34e6a49a76778b724b4924ef6fe41cfb2eca563ebd2c92956c7e0a954946138a9384e09c795f34934a4d5f9b570bfc0dc75757f625f89b7be17f8bba4c9a5f886d747d49c5c7f6635e4de469dad99ae12f20b4bb930551fcd574dc4160b28207040fe94fc0df1d6cfc41e2a4b3d72d5ac26b9b54fed0d1f53762f1eac6dcc5361c031b5b4ced135bbef11cbbb2acdc1afe4cfe2b7eccff19ff65bbef0e683f166db4cd3f5dd5acee358d26f3c39ab0d4e3586d6f5ada485ee5214fb36a115c265e3c6556453fc55f597c0dfdbf75cf055869de0ff008dde0b3f16fc156423b6b2d6acf5793c35f127c37698c11a2f892289d6fadd1b6b0b5bc478c900064ce6be4737c9d62b16f131e4cc14232a72b4a379ee9ca1393509b7bda6d3beaa5af29fa470f7124b0b85787a952781552a2ab1938c9c632e652719c62a538766e9a95d5af1d3997f4d5ac783fc1173710deddf8975789af95cc9a6c4b602d219d1835b46ecd19682167dc09c8c32ae58eeaf96bf69df17df1d02f7c1ff000f6f203acea9e1fb9d253528b0ede1f8ae209a2b89ae2448cadccf2445a08906306e998b0da54f8d7c1df8b7fb19fc639ed2ff00c31fb507887c297b70a607f87ff14adec340d6e1b89369105beb4f28b5b850eb8f3232e5caeef949af71f13781fc0b3f82b5ef15f867c77a66b1e17d0edf55d5af75ed12f20d4e2b8bbd02de667b5975349e456659480d924297da91a96dd5f8cf1a57a796e16ac28e0b11f5976a718d5a2e31b395f96f67195fba959e8b53f7ae17c5e2b3ba94bda6330f1c34173b9d2ab194b9a315695d59c6d64f58e9d7b2fe4f3e26c7269be339aeaf66d97f0e970ff69dca9601efed2e2ead659180e77b18d4e0f2718e6befeff82687ed9ff01be09fc57bcd2bf680f849e1ad6742f12e9f7474bf8b52f87edf5cf1878535ad3ed1ae2d2c66b036ee6ef46bc585a2631e26b795a390b98ccaa3f34fe226a773a978cbc4d753c91df4b2df5edb48cf13c71ba4b3cb704246f86ca863b4f1923760022b27c2a96da6ddc33dd40d34e609218ddd8e2d7cd0aacc8b8e642836e7b03c63273fb2e6395d3cd725c62c451a8abd5a1cb4dd0a8e94a0e51bdb471f762d26e0f9a124927096c7f3a433886579be170d1c6d38e0fdbf3547560eaa9c613b271569b5292ba5512534db6a4baff4ebf1bbfe0aaffb0a7c4bd0757f06eb7fb2df88fe23f86ef6de7d1750bdb8d2fc1fe199e7d3ee11ed8dc594e1deeada4f2d98c792ac080490735fcf0fc5df80df0cbc2d792f8f3f660f10f8df56f869e20f1343a6f8ebc3de218a28bc73f0f3c2fac3ac96fa4789f4fb19644d4fc36b7188e1d66cdde270bb6e56da53b64e5e5b99048c1446914b98df3924671b5ceeebf301e9df357b42f1ff0089bc07aa5978ab42b830eb5e1f32db5eaa22c90dfe8772a639edef6da48cc77b62f1c8e9246e195a398ee1f2835f9de4bc258fe1aab2c56458bab55d6b7b4c2d7aca54312b78c6a4143969cf9bdd8d6a69384a70738d582941fda63b8c323cd69c7078fa4a8725fd9e269d2973e1ddb59c252939b5cb69383d24a1349c25692f1bf1bfc75f1e7c27f15eb7e10f849e249bc31e16b7ba5bb9f46b5b3b5bab0b6d6e78218b547d3a4704ad9c8f6f1385e00777e324d15ddfc5bf815aec9e27b5f1378526d2ec3c3de3fd074bf1e69963adc9756d75671f8884f2dcdac022b39166b04bd86e960704663014a82a7257d8e0f37e16af85a15711430cb1128af68ab461ed6351693854e6a727cf0927095e52d63f13b5cf3311947113ad51e12957ad8593bd29d192f65529bb3854a76ad15cb38b53568c775a2d951f859f0874ff008dbaef85fc17f0ae1b9f0bea1e1cf0a6a3ae7c60f881e30d665bcf0ae856365712dc5febcb63fd97136876b6d64d0c296f1cd746f6e244313465caafec37fc1293fe09d5e18fda23e23ebbf183c71637fe2bfd9ffe1b6a32e97e118bc49a70d37fe16cf8b6d1d436af7b611b951e18b564f316d7cc95649248e395db6c80fc3de106fec0fd8b3f685d534558f4cd4afbc63f0ebc2f797f6914715e5cf87e7d32e7539b499ae42ef92d1ef98c8ca4e490013b5401fda8feccfe1ed13e1f7eccbe1ad3bc17a5d9f876c7c3ff00046df51d1ed34f89520b3be87c1eba8a5d88e4dc269cdf132bb49bcc8ec4c9bb273db97e26580caf199a5373957ab56787a6e7375274dce11c4d7aaaa4fdfbb8d68d2a314d468c79d45594397c2e26c3a8e3b0b9545461171556a7227084a34a7f57a74d4399ab3953954ab269b9be4dbdf4ff003bff00683ff82adfc00fd92fc59aefc13f057c26d4fc75e22f05c7fd95a869be1fbcd27c23e0cf0feb51db82ba54b79f639a59da2dd189becf6c421050316ce3f3f35fff0082f1fed0b24331f0b7c17f839e1cbd2b709677d77278af5fb886de60cb09681f52b68eeee236656f99423141b90292b5f875e27f106b5e28f1af8b7c45e21d4aeb57d6f5bd7756d5b56d4ef64f36eafb51bd9ae2e6eaea79303748f3b331c000670001c56579d29895cb92c921dadc64059300671d31dba1ef5eae1721c34153ab517b6a95146527294be292e676b5b4ded7d763c0c4e70e119d2e4e48d3bad2317750718ddf35d27aa76565bf91ec7f1fbf697f8ebfb42eaa7c47f14bc6b73e26bb8ef2f6eed6dfec3a7595ae8c751d8972ba3db5a5a01670058a30223bd14a062188c9f0285efe78b6a6a772adcfc972d15d9df83f33199094dbdf0475e95a974499b924ee94823b10431208e98ca8fcab1ef0797769b3e5cc880e3b822327f5afb4c26554553a6a518a868b9631492beab56befd99f058ce23c44aad68e194a128b693949daeacdde31d2dd95f72e585c4b07982f849f683212b75146ae8c8bf329050a88cee0df87727afd0ff0ff00e3c7c50f06f827c5de10f0ef8a75c7f0a6a50c297fe18b9bcb97f0f18b5399a2d4f507b08e719b8291c31ee0500599b76ec8af09b050fa85bc0c0342d2c0ac87a15768d5867af218fe75f56df681a3695a2ea3069da75b5a4571a65cc73ac49ccc9e546fb6476259fe639e4e735f2fc613ca72d8d1c3e2302f193c64af08cb91d38ba6e2eed493775bc6db3d6eb73ed7c3a7c439fd5ad5f0d9a43014b2e505527155156a8ab370514e128c6ced695f471d3965b1f3b3782eefc5bada6a3a626e3716d6faef9224912d52e2e5a5b299c3cc4b9852459b647963ce7240e7d0747f841b5d25d6b5062a32ef6f6598dc838cfefe4196edc01d01aecfe1db16d212727337f6569f179bc07f29351d542c791fc002af1d3e5156be22ea77da67876f6f6c2e1adaea38d824c8b1964ccbb7e50e84038ef8cd7e718fce33daf9cae1ecb7150c1c6b54853551c6f3bd450b5e6d49a494925ca93b2bddb3f66cb384786aa658b89337c1cf1f3c353a92f65ccd5251a529b7cb4e2e0a52934e4f9e4e2dbb594524acdbf873c1da35b9965b3b18c40aca27d42457de72a7733cf260a671d00e959d71e2ff0085d1c3223ea1e1e3325bbc1796a62cc77b6c54a490492451f03692a707255b23902be15d635ed6b5669e4d4b54bdbc647da9e7dc48eaaa5ba04dd80393dbbd734f248119b7b640c024e786041ebd7803f2afad8f8212af1788ceb8af155f13f15a83718c76babd573724effcb0b6eacd23e65f8d983c24a383c8b83307430bf0b75e31bbe97e4a31824f477bce574dad9b3f583e31feda5a778bf59f0aafc3cf853f0fa0f097853e1f784fc15a5db5dea30cd35b0f0fdacd15c43be7f2dc45f699e5640ca5b6c837331c9a2bf11f50bebc5bc9c2dccaa37740c40e828ae2c47819c2f5b115eb62210c5e22b4e539d5a8b13ed2a4e52e694e7ecf174a9f349b6e5c94e11bb768ab9c786f1b334c2e1e861b09859e0f0d8784614e952a987f674e11494610f6b83ab539229251e7a9395b7933ffd9	The photo didn't upload	2011-02-22	opuscollege	2011-02-22 11:24:02.201299	sergey.jpg	image/jpeg	Y	Facebook and twitter	Reading\r\nMovies	\N
\.


--
-- TOC entry 5332 (class 0 OID 0)
-- Dependencies: 373
-- Name: personseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('personseq', 525, true);


--
-- TOC entry 4899 (class 0 OID 127051)
-- Dependencies: 376
-- Data for Name: profession; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY profession (id, code, lang, active, description, writewho, writewhen) FROM stdin;
119	1	en    	Y	accountant	opuscollege	2010-11-02 16:22:58.674788
120	2	en    	Y	academic staff (professor)	opuscollege	2010-11-02 16:22:58.674788
121	3	en    	Y	academic staff (assistant)	opuscollege	2010-11-02 16:22:58.674788
122	4	en    	Y	artist	opuscollege	2010-11-02 16:22:58.674788
124	6	en    	Y	bank director	opuscollege	2010-11-02 16:22:58.674788
125	7	en    	Y	bank employee	opuscollege	2010-11-02 16:22:58.674788
126	8	en    	Y	buss driver	opuscollege	2010-11-02 16:22:58.674788
127	9	en    	Y	butcher	opuscollege	2010-11-02 16:22:58.674788
128	10	en    	Y	civil servant	opuscollege	2010-11-02 16:22:58.674788
129	11	en    	Y	cook	opuscollege	2010-11-02 16:22:58.674788
130	12	en    	Y	company clerk	opuscollege	2010-11-02 16:22:58.674788
131	13	en    	Y	company manager	opuscollege	2010-11-02 16:22:58.674788
132	14	en    	Y	craftsman	opuscollege	2010-11-02 16:22:58.674788
133	15	en    	Y	dentist	opuscollege	2010-11-02 16:22:58.674788
134	16	en    	Y	electrician	opuscollege	2010-11-02 16:22:58.674788
135	17	en    	Y	engineer	opuscollege	2010-11-02 16:22:58.674788
136	18	en    	Y	farmer	opuscollege	2010-11-02 16:22:58.674788
137	19	en    	Y	fisherman	opuscollege	2010-11-02 16:22:58.674788
138	20	en    	Y	furniture maker	opuscollege	2010-11-02 16:22:58.674788
139	21	en    	Y	garage manager	opuscollege	2010-11-02 16:22:58.674788
140	22	en    	Y	gardener	opuscollege	2010-11-02 16:22:58.674788
141	23	en    	Y	hairdresser	opuscollege	2010-11-02 16:22:58.674788
142	24	en    	Y	herdsman (cow, sheep, etc..)	opuscollege	2010-11-02 16:22:58.674788
143	25	en    	Y	hotel manager	opuscollege	2010-11-02 16:22:58.674788
144	26	en    	Y	hotel employee	opuscollege	2010-11-02 16:22:58.674788
145	27	en    	Y	housewife	opuscollege	2010-11-02 16:22:58.674788
146	28	en    	Y	ICT specialist	opuscollege	2010-11-02 16:22:58.674788
147	29	en    	Y	interpreter	opuscollege	2010-11-02 16:22:58.674788
148	30	en    	Y	journalist	opuscollege	2010-11-02 16:22:58.674788
149	31	en    	Y	lawyer	opuscollege	2010-11-02 16:22:58.674788
150	32	en    	Y	manual labourer	opuscollege	2010-11-02 16:22:58.674788
151	33	en    	Y	market vendor	opuscollege	2010-11-02 16:22:58.674788
152	34	en    	Y	mechanic	opuscollege	2010-11-02 16:22:58.674788
153	35	en    	Y	medical doctor (general practicioner)	opuscollege	2010-11-02 16:22:58.674788
154	36	en    	Y	medical doctor (specialist)	opuscollege	2010-11-02 16:22:58.674788
155	37	en    	Y	musician	opuscollege	2010-11-02 16:22:58.674788
156	38	en    	Y	nurse (medical, incl. midwife)	opuscollege	2010-11-02 16:22:58.674788
157	39	en    	Y	(house-)painter	opuscollege	2010-11-02 16:22:58.674788
158	40	en    	Y	postman	opuscollege	2010-11-02 16:22:58.674788
159	41	en    	Y	psychologist	opuscollege	2010-11-02 16:22:58.674788
160	42	en    	Y	restaurant manager	opuscollege	2010-11-02 16:22:58.674788
161	43	en    	Y	restaurant employee	opuscollege	2010-11-02 16:22:58.674788
162	44	en    	Y	school director	opuscollege	2010-11-02 16:22:58.674788
163	45	en    	Y	salesman	opuscollege	2010-11-02 16:22:58.674788
164	46	en    	Y	shop owner	opuscollege	2010-11-02 16:22:58.674788
165	47	en    	Y	shop employee	opuscollege	2010-11-02 16:22:58.674788
166	48	en    	Y	seamstress	opuscollege	2010-11-02 16:22:58.674788
167	49	en    	Y	secretary	opuscollege	2010-11-02 16:22:58.674788
168	50	en    	Y	shoemaker	opuscollege	2010-11-02 16:22:58.674788
169	51	en    	Y	(black)smith	opuscollege	2010-11-02 16:22:58.674788
170	52	en    	Y	teacher primary school	opuscollege	2010-11-02 16:22:58.674788
171	53	en    	Y	teacher secondary school	opuscollege	2010-11-02 16:22:58.674788
172	54	en    	Y	train conductor	opuscollege	2010-11-02 16:22:58.674788
173	55	en    	Y	train engine driver	opuscollege	2010-11-02 16:22:58.674788
174	56	en    	Y	tailor	opuscollege	2010-11-02 16:22:58.674788
175	57	en    	Y	taxi driver	opuscollege	2010-11-02 16:22:58.674788
176	58	en    	Y	waiter/waitress	opuscollege	2010-11-02 16:22:58.674788
177	59	en    	Y	weaver	opuscollege	2010-11-02 16:22:58.674788
123	5	en    	Y	baker	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5333 (class 0 OID 0)
-- Dependencies: 375
-- Name: professionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('professionseq', 177, true);


--
-- TOC entry 4901 (class 0 OID 127063)
-- Dependencies: 378
-- Data for Name: progressstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY progressstatus (id, code, lang, active, description, writewho, writewhen, continuing, increment, graduating, carrying) FROM stdin;
107	01	en    	Y	CP - Clear pass	opuscollege	2012-05-01 15:50:10.67413	Y	Y	N	N
108	03	en    	Y	R - Repeat	opuscollege	2012-05-01 15:50:10.67413	Y	N	N	A
109	04	en    	Y	P - Proceed	opuscollege	2012-05-01 15:50:10.67413	Y	Y	N	S
110	14	en    	Y	S - Suspended	opuscollege	2012-05-01 15:50:10.67413	N	N	N	N
111	15	en    	Y	E - Expelled	opuscollege	2012-05-01 15:50:10.67413	N	N	N	N
112	19	en    	Y	PT - At Part-time	opuscollege	2012-05-01 15:50:10.67413	Y	N	N	S
113	22	en    	Y	EU - Exclude university	opuscollege	2012-05-01 15:50:10.67413	N	N	N	N
114	23	en    	Y	WP - Withdrawn with permission	opuscollege	2012-05-01 15:50:10.67413	Y	N	N	A
115	25	en    	Y	G - Graduate	opuscollege	2012-05-01 15:50:10.67413	N	N	Y	N
116	27	en    	Y	PR - Proceed & Repeat	opuscollege	2012-05-01 15:50:10.67413	Y	Y	N	S
117	29	en    	Y	TPT - To Part-time	opuscollege	2012-05-01 15:50:10.67413	Y	N	N	S
118	31	en    	Y	FT - To Full-time	opuscollege	2012-05-01 15:50:10.67413	Y	Y	N	N
119	34	en    	Y	ES - Exclude school	opuscollege	2012-05-01 15:50:10.67413	N	N	N	N
120	35	en    	Y	EP - Exclude program	opuscollege	2012-05-01 15:50:10.67413	N	N	N	N
121	37	en    	Y	WTP - Penalty withdrawal/Withdrawal without permission	opuscollege	2012-05-01 15:50:10.67413	N	N	N	N
122	53	en    	Y	DE - Deferred/Supp. Examinations	opuscollege	2012-05-01 15:50:10.67413	N	N	N	N
\.


--
-- TOC entry 5334 (class 0 OID 0)
-- Dependencies: 377
-- Name: progressstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('progressstatusseq', 122, true);


--
-- TOC entry 4903 (class 0 OID 127079)
-- Dependencies: 380
-- Data for Name: province; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY province (id, code, lang, active, description, countrycode, writewho, writewhen) FROM stdin;
59	ZM-01	en    	Y	Central	894	opuscollege	2011-03-15 17:17:12.177
60	ZM-02	en    	Y	Copperbelt	894	opuscollege	2011-03-15 17:17:12.177
61	ZM-03	en    	Y	Eastern	894	opuscollege	2011-03-15 17:17:12.177
62	ZM-04	en    	Y	Luapula	894	opuscollege	2011-03-15 17:17:12.177
63	ZM-05	en    	Y	Lusaka	894	opuscollege	2011-03-15 17:17:12.177
65	ZM-07	en    	Y	North-Western	894	opuscollege	2011-03-15 17:17:12.177
66	ZM-08	en    	Y	Southern	894	opuscollege	2011-03-15 17:17:12.177
67	ZM-09	en    	Y	Western	894	opuscollege	2011-03-15 17:17:12.177
64	ZM-06	en    	Y	Northern	894	opuscollege	2011-03-15 17:17:12.177
77	ZM-10	en    	Y	Muchinga	894	opuscollege	2014-03-05 14:59:12.908
\.


--
-- TOC entry 5335 (class 0 OID 0)
-- Dependencies: 379
-- Name: provinceseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('provinceseq', 77, true);


--
-- TOC entry 4905 (class 0 OID 127091)
-- Dependencies: 382
-- Data for Name: referee; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY referee (id, studyplanid, name, address, telephone, email, orderby, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5336 (class 0 OID 0)
-- Dependencies: 381
-- Name: refereeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('refereeseq', 44, true);


--
-- TOC entry 4907 (class 0 OID 127103)
-- Dependencies: 384
-- Data for Name: relationtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY relationtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
9	1	en    	Y	brother	opuscollege	2010-11-02 16:22:58.674788
10	2	en    	Y	sister	opuscollege	2010-11-02 16:22:58.674788
11	3	en    	Y	uncle	opuscollege	2010-11-02 16:22:58.674788
12	4	en    	Y	aunt	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5337 (class 0 OID 0)
-- Dependencies: 383
-- Name: relationtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('relationtypeseq', 12, true);


--
-- TOC entry 4909 (class 0 OID 127115)
-- Dependencies: 386
-- Data for Name: reportproperty; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY reportproperty (id, reportname, propertyname, propertytype, propertyfile, propertytext, visible, active, writewho, writewhen) FROM stdin;
4	StudentsPerStudyGradeAcadyear	reportLogo	image/pjpeg	\\xffd8ffe000104a46494600010101004800480000ffdb00430001010101010101010101010101010101010101010101010101010101010101010101010102020101020101010202020202020202020102020202020202020202ffdb00430101010101010101010101020101010202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202ffc0001108003f011f03012200021101031101ffc4001f0000010501010101010100000000000000000102030405060708090a0bffc400b5100002010303020403050504040000017d01020300041105122131410613516107227114328191a1082342b1c11552d1f02433627282090a161718191a25262728292a3435363738393a434445464748494a535455565758595a636465666768696a737475767778797a838485868788898a92939495969798999aa2a3a4a5a6a7a8a9aab2b3b4b5b6b7b8b9bac2c3c4c5c6c7c8c9cad2d3d4d5d6d7d8d9dae1e2e3e4e5e6e7e8e9eaf1f2f3f4f5f6f7f8f9faffc4001f0100030101010101010101010000000000000102030405060708090a0bffc400b51100020102040403040705040400010277000102031104052131061241510761711322328108144291a1b1c109233352f0156272d10a162434e125f11718191a262728292a35363738393a434445464748494a535455565758595a636465666768696a737475767778797a82838485868788898a92939495969798999aa2a3a4a5a6a7a8a9aab2b3b4b5b6b7b8b9bac2c3c4c5c6c7c8c9cad2d3d4d5d6d7d8d9dae2e3e4e5e6e7e8e9eaf2f3f4f5f6f7f8f9faffda000c03010002110311003f00f97ffe0a99f147e26691fb7b7ed0ba7693f117c75a669f6dabf82c5b58e9fe2ef105959db893e19782a690416b6da82a441a592463b54659cb1e4935f9fdff000b8fe2effd154f88ff00f85c789bff009695f63ffc1577fe5207fb45ff00d863c11ffaabbc0f5f9e35fd6f428d1f6347f751f863f65765e47f2ce22ad5fac57fdecbe397da7fccfccf47ff0085c7f177fe8aa7c47ffc2e3c4dff00cb4a3fe171fc5dff00a2a9f11fff000b8f137ff2d2bce28ad7d8d1ff009f51ff00c057f918fb6abff3f65ff813ff0033d1ff00e171fc5dff00a2a9f11fff000b8f137ff2d28ff85c7f177fe8aa7c47ff00c2e3c4dffcb4af38ad8b5f0feb97b178827b5d26fe78bc2960baaf895d2d652342d39f5cd27c34b79aa82b9b283fe120d7746b3dcf8ff49d4e18befb8142a149ed462edfdd5ebdbcbf0f217b6a8b475a49bfef3ff3f3475fff000b8fe2effd154f88ff00f85c789bff0096947fc2e3f8bbff004553e23ffe171e26ff00e5a570171677769e47daed6e2d7ed56f15e5b7da20961fb45a4dbbc9ba83cc51e6dbbed6daeb956da704e2abd0e8528bb3a314d7f757f902af51abaad269f693ff0033d1ff00e171fc5dff00a2a9f11fff000b8f137ff2d28ff85c7f177fe8aa7c47ff00c2e3c4dffcb4af38a28f6347fe7d47ff00015fe43f6d57fe7ecbff00027fe67a3ffc2e3f8bbff4553e23ff00e171e26ffe5a51ff000b8fe2effd154f88ff00f85c789bff009695e71451ec68ff00cfa8ff00e02bfc83db55ff009fb2ff00c09ff99e8fff000b8fe2effd154f88ff00f85c789bff0096947fc2e3f8bbff004553e23ffe171e26ff00e5a579c5147b1a3ff3ea3ff80aff0020f6d57fe7ecbff027fe67a3ff00c2e3f8bbff004553e23ffe171e26ff00e5a51ff0b8fe2eff00d154f88fff0085c789bff9695e71451ec68ffcfa8ffe02bfc83db55ff9fb2ffc09ff0099e8ff00f0b8fe2eff00d154f88fff0085c789bff96947fc2e3f8bbff4553e23ff00e171e26ffe5a579c5147b1a3ff003ea3ff0080aff20f6d57fe7ecbff00027fe67a3ffc2e3f8bbff4553e23ff00e171e26ffe5a51ff000b8fe2effd154f88ff00f85c789bff009695e71451ec68ff00cfa8ff00e02bfc83db55ff009fb2ff00c09ff99e8fff000b8fe2effd154f88ff00f85c789bff0096947fc2e3f8bbff004553e23ffe171e26ff00e5a579c5147b1a3ff3ea3ff80aff0020f6d57fe7ecbff027fe67a3ff00c2e3f8bbff004553e23ffe171e26ff00e5a51ff0b8fe2eff00d154f88fff0085c789bff9695e71451ec68ffcfa8ffe02bfc83db55ff9fb2ffc09ff0099e8ff00f0b8fe2eff00d154f88fff0085c789bff96947fc2e3f8bbff4553e23ff00e171e26ffe5a579c5147b1a3ff003ea3ff0080aff20f6d57fe7ecbff00027fe67a3ffc2e3f8bbff4553e23ff00e171e26ffe5a51ff000b8fe2effd154f88ff00f85c789bff009695e71451ec68ff00cfa8ff00e02bfc83db55ff009fb2ff00c09ff99e8fff000b8fe2effd154f88ff00f85c789bff0096947fc2e3f8bbff004553e23ffe171e26ff00e5a579c5147b1a3ff3ea3ff80aff0020f6d57fe7ecbff027fe67a3ff00c2e3f8bbff004553e23ffe171e26ff00e5a51ff0b8fe2eff00d154f88fff0085c789bff9695e71451ec68ffcfa8ffe02bfc83db55ff9fb2ffc09ff0099e8ff00f0b8fe2eff00d154f88fff0085c789bff96947fc2e3f8bbff4553e23ff00e171e26ffe5a579c5147b1a3ff003ea3ff0080aff20f6d57fe7ecbff00027fe67a3ffc2e3f8bbff4553e23ff00e171e26ffe5a57d0ff00b297c59f8a979f1f7c056d77f133e205d5bc9ff094f9905cf8cfc473c326cf05f88e44df14ba9156c3aab0c8e0a823915f18d7d1dfb24ffc9c1fc3ff00fb9aff00f509f125736328d1fa9e2bf751fe1cfecafe57e474612ad5fad61bf7b2fe243ed3fe65e67d01ff00055dff009481fed17ff618f047feaaef03d7e78d7e877fc1577fe5207fb45ffd863c11ff00aabbc0f5f9e35d143f8147fc11fc918e23fde2bff8e5ff00a530a28a2b5313d73e118f843a86a5ac7863e2ff00f6c683a778a6c21d37c39f13f4796f6f47c2cf1125cacd67e24f10f83ecad6593c6de0b971f65d5ed6d026ab696772da9e92b7f79649a36a9f722781b555f116910fc44bbd25bc651784f4ff0082df1535fb4d4ece7f03fc4af809f14f4db6f877f00ff6a7d07c4c91a5af887c3ba1789751f04da6a579b622d3f857c2d717a926b975e21921fcbfaee1be24f8e5fc0f63f0ddfc477b2782f4ad6356d7349d1654b6946917fe20b4b5b2f112691a84901bbd2b4cd4a1d3f4c6d4ac6de78ecb509b48b2b8bcb79ee2cad6587a6857f6525ccdf247a4525777bae66acddaef56dbb5e2ac9e9cf5a8fb48be54b9dbde4db495acec9dd2f4492bfbceed1f414a2cf52f07f85357d5748b5d635af0e7ecf175f0ebc3da13e9cfa96ef891e2cf8dbf127c19a268d3e986299e0f16c3e04b9f156b9608e892a5e78760b983cb945bd7ce5e30f0e5b786757bbd1aceff00fb664d0cc1a5f88754b35597468fc4c4dd35fe9da55ec4592f6ca092de7b78ee0314bd7d367bab62d6af135739657d7ba65d437da75e5d69f7b6ec5edef2cae26b4ba81cab21686e20757898a330ca9070c47435d1ea5aee9faa595a477705e07b3b396d34cd2b4c6834ad0f4220b626885c7db66d6a4b89764d72f235aced2215334c0c6d16f2ab42bd19732e4ad1b6aecefdddd24ef2d2e9c66d72ae5b465370c634eb51ab0e57cf45df48e96ecacdb5a6b6b38a777cd79460a5de7ece5f04f5dfda43e3bfc27f811e1bd46cf46d63e2a78e341f075b6b57f1497165a243aade2477fad5d5b42eaf770d9e9e2eae5a14657985af948cace08fde7f0d7eca9ff04a4f8b1fb5478d7fe09a1e04f87df1d3c2df1afc3c3e217c3ff0afed5fad7c477d6e0d7be31fc35d075ad53c5369e21f86d0490e916de1fb6bbf0aeb91c4d6d6f6b2dfbc12da05b0925b4b95fc56fd883e37689fb37fed73fb3dfc6ff13c5752f857e1efc4ef0e6afe2c3631bcf7d07852e6e0e95e27bdb1b58d4b5f5edbe83a86a13c36e36fda24b75837c7e66f5fe847c1dfb3dfc09fd9fbfe0a1bf107fe0a8fe31fdb0ff66ef12fecb5ff000957c61fda27c13a6f843e23daeb5f183c5de25f8b3a57892eadbc0963f0fad2d51a5d52c7c41e37d41638a2bb9a79574ab24ba8207b8be8ec7e5734a98883a9ecbda29c70f56547d9aa8ef8956f669a82e49be91a555ba73bc9ca1251e687d36594e84d43daaa6e12af4a35bda3a6ad8777f68d39be682fe6a94d2a90b454669cb965f1e697fb36fec3bfb33fec0df09fe3afed5bfb3a78f7e2cfc4ff0016fed11f17be00f8dae7c09f193c49e05b9f0edd780bc4ff001034a9359d2b4b955ec353b9b487c20218ade5b7b55b891849712ae1d1fdab40ff0082557eca5a77ed5de3ff000a412f8f7c79f02bc6bff04cdf157edb3f0634bf186af7de1af1d7823c4571e2cf0a691a0697e25bcf0c9b35d623b4b3bdbf758664036ea6b6d791dc4f67f6cb893c41ff000508f08fc3dff82687c1bf1ce9ff000cff00645f8f1f12fc77fb60fc7ff1b6b9f07bf686f09e93f16a7f87563e36f1d7c56f1958f8b34ff03daf8aecafbc33a979d736d6d6fa949fbb7b7bf78e32c6656af0eff827dfedff00aafc67ff008280fc51f887fb62fc57f0ff00862ebf691fd98fe23feccfa478cf59583c3bf0f7e1aaf882f7c33ae784745b1b779d6d7c31e168eefc397b147e7cc91c97badbdc5e5cb5cddcf72fccff00b57971d56309d2f6552b34f9e5375211af17054a94a32b4634a135170e5955bc52856752f0e8ff0084d72c152738547569d156e48c3d9ce545a93ab562e3794aa4e2e4a6a51a6d36e54942d3f933f62efd997e107c65fd8cff00e0a51f18bc7da0dfea7e3dfd9c3c03f06f5ef84fa9daebbabe996da1ea7e30d47e265bebd35f69961771dbeb692c5e1ad202a5dc72ac5e4318c2991f3f74fc47fd933f624fd8abf674fd9b3e237c51fd8f7f683fdb22cbe397c1cf077c53f1c7c7df0c7c52f11f803e15fc3abff16dae89ab278634293c11a7496c974b677320b78f5d64fb55b5e09a0bc9a769134be7743f87da47fc1377f60bfdbf7e1efc65f8cdf017c73f12ff006bcb1f83ff000ffe0df817e0a7c4db0f88fabea5a7f82b59f1ccfaef8fb57fecbb253a0f838e97e2b967b59ef12069a5d20d948b05ddd5b46ff59ffc13b3c15fb5afeca777f0cb55d47fe0a23fb186b5fb0a5edbe95aefc43f03f8bfe3c691e28d234bf056bd60754f11786bc3be1ff1268c0f817c5cb3ea976af6da7ea96ba7bea52b4b7eb7c8d2c12eb5aae23d9e3eb397b5a347177853752ad2f6b4960f0cf929d6a1fbd8dabfb569454a12aaa509a49c8ce8d3a1ed3034547d956ad85b4aa2852abecaabc5d75cd52957fdd49ba2e9a95dc671a6e3285da56fe5a7c6371e17bbf1778aaebc0f61aa695e0bb9f11eb971e10d2f5bb98af35ad37c2f36a7752787ec357bc858a5d6a90e92d691dc4884abcb1bb29208ae72be98fdb33c51f08bc6bfb567ed01e2af809a658e91f0735cf8a5e2bbdf87b67a5695fd87a43f879b51963b7d4347d17621d2346bb9639aeed2d8c503416d7b144d6d6cca6de3f99ebde52e64a5cae1cdad9ab357e8d6b66b66afa33c36b95b8f329f2e974ee9dbaa7d53dd3ea14514500145145001451450014514500145145001451450014514500145145001451450015f477ec93ff2707f0fff00ee6bff00d427c495f38d7d1dfb24ff00c9c1fc3fff00b9afff00509f12573637fdcf17ff005eaa7fe92ce8c27fbde17febe43ff4a47d01ff00055dff009481fed17ff618f047feaaef03d7e78d7e877fc1577fe5207fb45ffd863c11ff00aabbc0f5f9e35a50fe051ff047f244e23fde2bff008e5ffa533d57e1af803c1de305d4efbc6ff193c0ff0009348d2a5b38d4788b48f1ff0089bc47e2237097325cc3e14f0ff80fc23a92cb710470445df57bcd16c5daf238e2be7904ab17e917ecebfb1cfc1cf899a55f78d7c25f0b3e3a7c5ff85da33347e21fda2bf684f1c7c3efd863f65bf06bc5742deeee75ed6c1f1cde78cada0ba4f224b4d1fc4565ab9595646b086491618bf383e0a7c5383e0d78fec3c7d3fc34f85ff165b4cd3f58b6b3f087c61f0c3f8cbc0ada8ea1a75c5a69bad6a3e1937d041ad5c585f4905d436f79e7d94cf6c22bbb69e17743fa41e12fdb0f4cf8969e11f893f1f353f157ed99fb52dff8cd3c2dfb3dfecb9e26b51e0dfd923e09dcac9a4e8be11f13f89bc17a57f66695e239eeb51bbb78b4cf0c683169fa39b7d3a697c49a897961b637375138fb28a92b5ddd7349cb993518c5fb38b5eedeeeac74938bf689f2914d537cded64e2ef64d7bb151b3bca52fde3bfbcd595296b14d3a6fdf3f6ab42ff826dfecfbfb4a7ec2bf193c07f017c05f0574af8c3e22d2f4ff00187c09f89de0ef85de34f873a5f8ecf80b52d3eef59d0fc05e38fda03e24f883c6df11be1cdd6a33e9fa55f78b254d0fc337d73e24d2afec6d648a1fddff00229f117e1afc40f847e30d67c01f143c19e24f00f8d7c3f7325a6b1e19f15e9179a2eaf652c723c61ded2f624696d9cc6cd14f1ee8664c490c8f1b2b1feb37e0cfed61e25f82fe2df8e9e38d5be20bfc6df197ecfbe0cb6f147ed9bf1d125ff8a7fe24fed11adbdff80bf67ffd81bf6796b1b3b6b1f04fc16d27e226ab25d5f5de996b0c7ab5e786f5099a287485c4dfd01e89fb45fc3df107899bc2daa582ea7e2bf0ff00c7ad5bf674d2af74db1b4bbb2d53e2c787bf6727fda0fc58be1d6d42e566d2eca1f0de9fe2ad37323198dee84f1b936f209c7c5e3b39cdb23af89ab3c1cb38c0e213a919fb5709d0953a7454e1294e9b528724a8d551e5a7351adeda518ca73a34bec305946559d51c34218b8e538da2d5394153538d68ce755c27150a8ad3e75569b9734e0dd2f65194a30856a9fce07fc101bfe09b1e34d3b5ff00187ed5ff00b467c328b4df066b5e08b8f047c24f047c48f0bc32def89db5bd5b47d5b57f88b2f86fc43645ac34686cb45b7b4d2a79a21fda0bae5ddcc005bc36f3dcfea97fc150354f85bfb36fecfbe2af12f86be15685e00b81e16f115cdafc45d07f643f07fc68f04aeb434ebb8343f0678baeacae6cdfe1c4baaeae74fb1b6d6afd23d3a19f5b83fd25a6531afd0de3cff8281fc3dd37c257de23f02e83e23f1a4367f063c25fb4ab58e8f2e9769e2bf11fecddaf36a5a678e3e227c2bd32fa3b983c55e36f056ab6a87c41e19bf1657368af6e933799a8584571fc63ff00c14e7f6d8b6f8fde3cd4bc19e08f13f84fc73a5d8dd0b5f187ed0df0dacfc77f0bff00e1a77c330da785b54f00b7c62f8453cd67a24de3df0f5de9d3417ba9c3a718af2eec6d5f4d8f4cb0b1b4b35e3c9e867f9be7ff00db598a965d82c2e94f0d7f6b0bc6cf92a46ea0a569b93954a7294aabe58d1e5a756587eacd6b64595645fd9180e5cc3198a4dcf116f6726a5a39c2567371bc5251a738c634d272adcd3a51aff92f451457e847c1051451401aba0e85acf8a35cd1bc35e1dd32f75af10788b55d3b42d0b46d36de4bbd4756d6757bc874fd334cb0b5894bdcdedc5edc411451a82cf24aaaa0922bf43fc57ff0483ff8291f827c31e22f197893f653f1bd97877c29a1eabe24d7af6df5cf016ad3d9e8da258cfa96a7751697a3f8b6e2ef5078ecada6710db4134f26cdb146ee429f98bf643654fdac7f6607765545fda23e0a333310aaaabf12bc3459998f014004927d2bfaa6fdae3f665ff8294ea9ff00050bff008283fc66fd9efc6c7e057c0fd77f67ef0f8d53e20f8ffc3fa5f89bc15f11fc15a0fc0ef85563e39f01f826d75af0b6b51699e209355d0b5cf32ea18b4d951f479c0bd50ec4f8f8dcc2a50cc30982855a3868e228d5abcf5be194a9d6c3538d252f694d41cd579352fde3e68c62a9be66d7af82c053af80c563674ab621d0ab4a97251f8a319d2c454755c7926e6a2e8c538feed72ca5273d127fcedfc33ff82537fc1423e317807c29f143e1c7eccbe30f127813c71a45bebfe14f1026b9e05d2e2d6b45bb2df63d4edacb5bf155b5cc769322ef85e48104b13a4b1ee89d1dbf427f66ef81b7df0d7fe094ff00f056ff000cfc5cf86fa7685f183e1478efe17f872ea3f10e8fa3def8abc17a99d73c2b06a961a76b28933d8acb0ca43b5a5c7953c536433c6e09fd42f0e7c1bf8edf12fc07ff0006ec78d7e14f843c61e25f87bf09f44b0d6fe34eb3e1b95c687e15d0aea2fd9fe7d32f3c58a9768af6863f0ff88da30c926dfecf9fe50720f9bfed00caff00b38ffc1c40559580fda2fe1ba92a41019354f0223ae47f1075604762083cd7261336ad8c9d14aac22de618483842ea74e34b3ec3e1b96a3f692e755a9c79afc9497c70e5945731db88caa8e13da3f6739afa8e2a5cf3b4a13954c92b6279a9ae48f23a539d92e7a8f484f9a2dd8f8abfe0acbfb2ef8d3e32fc72fd813e117eccdf07e0f1078f3c65fb0e7827c4d37863c0da3e85a0bead75632788350d77c45addd9367691cc2cacd7cdbcbd9d0c8e2183cd79a48637fcabf8e3ff0004d7fdb93f66ef024bf133e357ecede30f04f816df57d2741b9f114ba878535db5b5d535eb8367a3db5d41e18f10decf6a9717de5dbc72c912c26e2e6183cc134f0a3ff5c7e12655ff0082adff00c136433282ff00f04bdb85404805985aeaee5541fbcdb158e076527a035f027ed23a57c6ff00853ff04eaf8c1e11b8fd8df57fd99fe08ea3fb65fc3ef1878b3c49f1cbf6a5d53e267c4bbbd40f8cbe17436faef843c1f73f06f4ab6b4f015e368ba0a46f26ba16cbfb3b56616b29db2d694331c44b30cb3012ab0e5c44302e72ab2829c9626ae2a94e5194ebc24dd35878b8c614ab73b9b8ca54bdce7cab65d87fa8e618d54e6a54258b5154e32708bc3d1c2d58a946146714aa4b1125294aad2e550e68c6a7bfcbf8b567ff00047eff008296df5c6996d07ec85f13924d5f478f5cb56bc7f0be9d04565288d960d4eeb50f10c51689ac012aeed3ef5edefd0860f6ca51c2f05f043fe099ff00b74fed1ff0e747f8b7f057f675f1778e3e1c7882e756b4d0bc576faa784347d3f589742d4eeb45d5df4d4f11f88ece6bdb68358b1beb579a389a1fb4584f0890c90caa9fdab7867e14fed071ff00c16b3c69f1b5740f1b37eccbe20fd9274bf0e69de318752925f873a9f8be0baf0bcd6d611db43a83432ea8a62d5248c983215e4911b6c9b9bf35bf668f057893c6dff0470ff826f2f847f666f897fb506b3e1bf8f9f13b5d87c39f0d3e355d7c133e0db8b3f8ebf1d1ed7c5be32d76cbc15aeb6abe128e796da1bab236b18c5f24fe61f2c46fe353e29af565828c5d0b632181939ab354658ba18cad3a7353c45284a549e1a34fdeab46ee4e4e29da07ab5386685258c94bdb5f092c6c545dd3ab1c2d6c25184e2e142a4946aac44aa7bb4aae91514dabccfe4efe33fc13f8abfb3cfc45d77e137c69f04eaff0fbe22786869efacf8635a16ad776b16aba75aeada6dcc773617335bdf5a4fa7de5b4b1cd6f34b132c980fb9580f2dafd5bff0082d5eb7f143c41ff00050cf8b7a8fc62f04784be1d78f1fc3bf0be2d47c23e09f1f5e7c4cd0b4bb28fe1df877fb20a78c2fbc1da04ba8ddcda61b59a653a55a889ee0c6a245512bfe5257d8e16acabe0f03889a51a98ac3d0ab251929454aad18549284936a705293509a6d4e2949369dcf92c5528d0c5e370f07274f0d5eb538b9271938d3ab3845ce2d2719b8c53945a4e32ba693560a28a2b7300a28a2800a28a2800a28a2800a28a2800a28a2800afa3bf649ff9383f87ff00f735ff00ea13e24af9c6be8efd927fe4e0fe1fff00dcd7ff00a84f892b9b1bfee78bff00af553ff49674613fdef0bff5f21ffa523e80ff0082aeff00ca40ff0068bffb0c7823ff00557781ebf3c6bf733fe0a4ff00b05fed61f117f6dbf8ede33f06fc29fed8f0d6b7aaf8465d2f52ff0084e7e1b69ff6a4b4f875e10d3ee1bec7aaf8c60b8876de5a5c26248909f2f72e54ab1f86ff00e1dadfb6b7fd117ffcc8df09bff9bbae4a19ae58a8d1be6343e18ffcbea7d97f78ebc4659993af59acbebb4e72ff0097553f99ff0074f85e8afba3fe1dadfb6b7fd117ff00cc8df09bff009bba3fe1dadfb6b7fd117ffcc8df09bff9bbad7fb572bffa1961ff00f0753ffe48cbfb3332ff00a1757ffc1353ff00913e58f097c56f88de05b2b5d2bc2de30d6b4bd0ad3c73e13f896be1afb48bef0a5cf8efc0c6fbfe112f136a7e15d4526d3b58d4ac63d4f518e23776b32186fa6864478a4643f5ef86bfe0a5ff00b54f85b50b2d72cbc47e1cbbf125a7ed67e2dfdb466f11dff87c36a1a8fc66f1bf830780bc422fad6d2f61b1ff0084365f0db5c411e970da431dbaddc91412476e5605c9ff00876b7edadff445ff00f3237c26ff00e6ee8ff876b7edadff00445fff003237c26ffe6eea67996515797dae3b0b5b936e7a946695d72bd24dab38e8d6cd593d9154f2fcda9737b2c1626973efcb4eac6fadeef952d53d53dd3bdb7678178fbf688f8c1f133c33e15f04f8b3c637777e0bf01dd78ee7f02f856d2d2c34ed27c1d6bf12fc42fe29f19e8ba09b3b54b8b7f0f5e6b6e92b58c93cb6c82da148e3548630be295f747fc3b5bf6d6ffa22ff00f991be137ff37747fc3b5bf6d6ff00a22fff00991be137ff003775a4b37cb64db966741ddca5fc6a7bca4e5276e6b27293727ddb6f7335956631b5b2daeaca2bf8352f68a518abf2ded18a49764925a1f0bd15f747fc3b5bf6d6ff00a22fff00991be137ff0037747fc3b5bf6d6ffa22ff00f991be137ff37753fdab95ff00d0cb0fff0083a9ff00f2457f66665ff42eafff00826a7ff227c2f457dd1ff0ed6fdb5bfe88bffe646f84dffcddd1ff000ed6fdb5bfe88bff00e646f84dff00cddd1fdab95ffd0cb0ff00f83a9fff00241fd99997fd0babff00e09a9ffc89f0bd7a5ea3f1a3e316af6179a56adf163e25ea9a5ea36d3d96a1a6ea3e3bf145ed85fd9dcc6d0dcda5e59dceaad1dd5b4913b2bc6eac8eac5581048afa77fe1dadfb6b7fd117ff00cc8df09bff009bba3fe1dadfb6b7fd117ffcc8df09bff9bbaa8e6f96c6fcb9a508dfb57a6bff006e25e53984adcd96d695b6bd19bffdb4f97348f8c1f16fc3fa6da68da0fc52f88ba2691611986c74ad23c6fe26d374db288bb4862b4b1b2d4d22b68cc8eedb51546e7271926b0d7c73e365b1d7f4c5f18f8a574df15ddcba878a74f5f10eac2c7c497f34be7cd7bafda0bbf2f58bb79807696e1647661b8b13cd7d7fff000ed6fdb5bfe88bff00e646f84dff00cddd1ff0ed6fdb5bfe88bffe646f84dffcddd57f6d603fe86d47ff0007c3ff009317f63e3bfe85757ff044ff00f913e4b97e24fc449f56d1f5e9bc7de349b5df0edab58f87f5a97c53ae49ab68564f14b03d9e8fa8bdf19b4cb5304d3218e0744292b2918620bbc49f12fe23f8cec62d2fc61f103c6de2bd320bb8efe0d3bc49e2bd775db186fa2867b78af62b4d52fe58e3bb5b7baba4590287097322860aec0fd65ff0ed6fdb5bfe88bffe646f84dffcddd1ff000ed6fdb5bfe88bff00e646f84dff00cddd279ce5f2bf366b45f36f7af0d76dfdfd765f72059463d5ad95d65cbb5a84f4f4f7743f58be107fc16c7f64cf807e2ab6f89bf087f60bf1df823c7565f0d5fc0365e19d3bf6a8f165d7c22b28a48ed2e0c567e06d57c357167690aea163691a5dc768b771da42238f6e4a9fe7bfc3df147e2678474ffec8f0a7c45f1df8634913cb7234cf0f78bbc41a2e9e2e670a26b8fb169ba8451f9ee11373eddcdb0649c0afabbfe1dadfb6b7fd117ffcc8df09bff9bba3fe1dadfb6b7fd117ff00cc8df09bff009bbae5a18bc8f0d5aae270f8fa50c462234e152a4b1b56bce71a5cdecd4a788c4569251e7934a2e2b5db456eaad85ce71346961ebe02a4b0f42539d3a70c1d3a3084aa72f3b51a142945b97246ee49bd347abbfc51ab6b1ab6bfa95deb1aeea9a8eb5abdfcbe7dfeabab5edcea5a95ecdb553cebbbebc95e5b9976228dcecc70a0670056757dd1ff000ed6fdb5bfe88bff00e646f84dff00cddd1ff0ed6fdb5bfe88bffe646f84dffcddd743cdb2c6db799d06deadbad4eedffe0473acab3149259757496892a352c97fe027c2f457dd1ff0ed6fdb5bfe88bffe646f84dffcddd1ff000ed6fdb5bfe88bff00e646f84dff00cddd2fed5caffe86587ffc1d4fff00921ff66665ff0042eaff00f826a7ff00227c2f457dd1ff000ed6fdb5bfe88bff00e646f84dff00cddd1ff0ed6fdb5bfe88bffe646f84dffcddd1fdab95ff00d0cb0fff0083a9ff00f241fd99997fd0babffe09a9ff00c89f0bd15f747fc3b5bf6d6ffa22ff00f991be137ff37747fc3b5bf6d6ff00a22fff00991be137ff0037747f6ae57ff432c3ff00e0ea7ffc907f66665ff42eafff00826a7ff227c2f457dd1ff0ed6fdb5bfe88bffe646f84dffcddd1ff000ed6fdb5bfe88bff00e646f84dff00cddd1fdab95ffd0cb0ff00f83a9fff00241fd99997fd0babff00e09a9ffc89f0bd15f747fc3b5bf6d6ff00a22fff00991be137ff0037747fc3b5bf6d6ffa22ff00f991be137ff37747f6ae57ff00432c3ffe0ea7ff00c907f66665ff0042eaff00f826a7ff00227c2f457dd1ff000ed6fdb5bfe88bff00e646f84dff00cddd1ff0ed6fdb5bfe88bffe646f84dffcddd1fdab95ff00d0cb0fff0083a9ff00f241fd99997fd0babffe09a9ff00c89f0bd7d1dfb24ffc9c1fc3ff00fb9aff00f509f1257ad7fc3b5bf6d6ff00a22fff00991be137ff003775ef1fb32ffc13cbf6c2f0dfc6ff0004eb5ad7c20fb169965ff0927da6e7fe13ff0085f73e57da7c23afda43fb9b4f1b4923eeb89e25f950e37e4e141239f199a658f098a4b31a0dba73492ad4eedf2bfef1be172ccc962b0cde5f5d2552177ecaa7f32fee9fffd9	\N	t	Y	opuscollege	2009-06-15 11:26:28.146359
5	StudentsBySubject	reportTitle	text	\N	List of Students by Subject	t	Y	opuscollege	2010-07-21 10:02:28.343449
9	CurriculumPerYear	reportTitle	text	\N	Curriculum per Academic	t	Y	opuscollege	2011-02-23 16:37:24.315383
8	StudentsBySubject	reportLogo	image/gif	\\x4749463839618a008900f700008c31318c3939944242944a42944a4a944a529c4a4a9c524a9c52529c5a529c5a5aa55a5aa5635aa56363a56b6bad6b6bad736bad7373ad7b73ad7b7bb57b73b57b7bb5847bb58484b58c84b58c8cbd8484bd8c84bd8c8cbd948cbd9494c69494c69c94c69c9cc6a59cc6a5a5c6adadcea5a5ceada5ceadadceb5adceb5b5cebdbdd6adadd6b5add6b5b5d6bdb5d6bdbdd6c6bdd6c6c6debdbddec6c6decec6dececeded6d6e7cecee7d6cee7d6d6e7dedeefd6d6efdedeefe7e7efefeff7e7e7f7efe7f7efeff7f7f7fff7f7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff2c000000008a0089000008fe004f58a870a1c2c082070d1254887061c2870e23369cc8b022448a172d4ad4887163c68f1b4f5c0040b2a4c9932853aa5cc9b2a5cb973063ca1c28b3a6cd9b3873ea2c39c1c2ce9f2d030c004a1428cda23a07346880c18307121e44787080b4aacd9e566b4e4801c3c3d2062461901ce021ab599747cf8ead81c1a483112920a83c0156c008b5785162cd2b22c085143148d8a83074a55700014ee45d4c32ed59b22755b44c20190006048c17ef7d4c2240e4962a3c0318213ab35ac755038818410065e5952226347e611aefe6aa0948b44ef97aa5629231628870b01b6500127d6bdb444d94c05de3134674709960e461000a388c1869520009010342fe5c28addce56da2037a971c1023414cdd2150c638a9a3b8031a219c161e5bbc3c00e63f91965208fdb9d4800e02a084c10850b5d6034a128cd000092e7890010929ac66a107eed5761e5034a49482043691c05202357880034a099485d8572411b0546eca01a893036d99945b82353920db4d2dba64a2873e1515400a883545e178375d6753902b99680158a6d97893033624e8410505dae4644d50aae443054b1149d4041ef0a81e4e6182e9a24a249cb041879959195303c399341f5019b0f9664a11c667a64e0782901f081e8cf0674e53f9d9120974d659414eaa2dfa5f0d54e9d4a69b2e9d409e6645de14036600a8900286a70280a64e96cab4694afe093c27294e13503980ac3a7686138739bd3a60976a7d08130a2541f0a3494e8d5043a4311dd76bab28dd5ae5a43661104149227459d99154d60401b4d4811bd9a7c1861a9302dc2955036f267570ac4c18f47912b3b08a6b1203f62265674a03204912090dd00bc0a213e458539c240ce5000a35a4006c49beaae42fa8321d279a6a86a1e440be266da5006223cc0041031e043082082b459cd2848ced7b9208744290694aad32109a7931746b1204a42a10835c2ceaa0c2d044173d340c47cf80eb59c2aaa440c31d64f0144bd01eb71f8b24509bd2c8c8eaf0a9ca2a39c0dd695abb84c1d842ae144007d79e84e704e49a14006d3a7220028f0080ad12fecab6991b54ce3089c5d2c6cf51f62e4b379f6472670de46793a064cb34b14b6ba624c28425c7f4a54903bc50c3050fb3b474564dc31953e528354043e82a6dfe324e0ecc6c96cb2609fe12ea274d70f84b235c8d12c77bcb6b56e996c7643b4bbad634fa49c0abd483ce55d15ed2ba30e16e12df32ad4a354ec73de0e9f07eb384a60829e0bd52e22b6100bdd9c9677c53ad00903c7bd92da50800012aac7fd2b727364f52e32ff15fbb443324ab100f593a33510232c014159cc0291e0001545412001584206e2be99c4b0680020196a4801810d84f68272d6461802e1878c04b644482f6c5a47766d31f4c64951e5221e58024399b0212e080c2d80083fe2cf2c005009612d6212606be4309010af8a4f15c4e0101b080f08842bb00c4c00327a0010f12b427f3602f5b72eba0898ac3411538050518a881f98c432c9c28c0062e50540766a00004b4f14ce19bcb0924148204598f241320c1bbacb81f090d0c3f3648d4cd96e29917d02d6c06ab89c9145081b6056059762c0aed0e9482117cc00623e8604b9c223b920400059e614aea0456a1dd950403f48b490ae895980a4ce08e3bc1214954b01b243927040d88010d3e350211deef052298814c207001c819e7046d930964e6f282620e6e8a2b91dead68f0b9f58ce74b13409b71cae7bf1140808929a19e4cc0a89201d82004cb8b9f0ace164995e8b22493fe93db088ef59a58252b947bf44c17cdd62713b4048935c19e4a18108217946600133095045a23bf96480f9006ade02c4de202a9b92007a22953deac45aa00b80026d50940037ee3b43dd6245f17e8c0153d70aa0a90a701aecc5d1e0717031310606eaf148f67127082598ab40117f880685e604453c680002f705d491a7017ffe1c82526932149608696581a2847ba23c905e8a582a8922401eefa580a5f1280d5016003553b678292c3d614003177287880c0fe08c89db2e4020c00805d4ad0a7468d932402605b60f3b992b1be329a8811410d320034c176d2862a21000a308b5509488d040e38408c38765188c926069ef14004184b92619244015e99fe145f49f2a78a02c00135c0a0c95a420018c4f3252724090a9aaa2abf222f022e1ac06a5372ca922800040d900b3aa3153067a2c0011978a00558174ab460132689110d6b5352da921c892d6775e654ffc49ab23cd003c0c2409c1c6ade9f11179039d5d35df7462a9cc2e49ef6fc5e38a3c5c484cd6006ea6b800b3e6612dbee2cbf86b19702b41ab66309e825e56591bf5a55991655538526f98e795117569b285425ae7de154eb293ee3c20401a421166c5160aa1188259ca25d59a878a592e3fdeb8772931a0a14458308a8f4619add6fde18d42dff6598b922d0c1096cea16733eca032a8863091e993bd99933022f88c194322082ab39e70467e365feeed09c82135416008569400a503081fe0ce0bb2d2e4a126322239214004fb0094006dcf3270918762510303272541083198886001378817be41b9c0ec42d6133f1aa7f90f53008d8e0019fc3654c7cb03a2a39007a4e995408188c122b67cfc5feb980052ea0dab17c8c00829af54d6ce01a0cb66a6d1456c993f362031064a0071ee8810f7ac0e81e3c08000e1315084e82010ea864a02489800e201b13009ba68d7b0a000858ba559c58eb24a7369d5bd0579361074b69b53eeba23c881872c319952ae11a625230ed9c789b31ac6d00894ca2deff1648cd2ac9406b8e634c98b8fb2c5c5eaf8e20ecbef5b0d824e53329abfd0d6be54c17641857328bfea8a21434cd80750c984007ee6b514d6fba54d786d8c75d228218201b984b3901eb52606da0fc5b33033f09be2d6613052089c7a6ccdfdee82d6c97bf7c5bf085e8a800b0d99ba8000109a8402ce305216ee7b2e3ca29180048a0801184406b118f493247f0c09438200606ab60f49cfe720788a0e048af09650170823db75634f0bb21d8cbd3b81d2215d2746789041a30e813dd6cb6ed4efccb4960821700532a3a81ed07b0ea82a957e5e7b5613b510ec4d976423ef22f7f89a1bff21591a704db2b2100d35b02fadaa480f524fbd300ee0b7b0ab29b8a924fbd7a0860838107400750f1bb8e0a9eef60bf6ff09b0e214a1c2a5f10a8b4f7ad868948f5fe15fcd4db1b31209800ab4ffcbb215bda40cebf0af4373df393842865f26ac00b82ae92ed6bb2fb2fe758da4da280377b00c28b6740ebe71f1ca36ff5923be45712174057f7977a3081014d9500f1d1006b743fd874205a65219f3780e54100df97120bf27627a02bad31616e2302dfb31e84135cdce78033145830813209600335f0021020813a830175560330a0033425210990201fc822ae577bcaf17b4ec33226a128178002ace6002790009b173ff2e1120a204a18867f9b065b1b944820e0756fb17d77e12c12e312770179469819186385fda6120840023936007c9339ecc21222d027ed77120fc718baf1120e964113d2737f884f2c310043e263fe2b91868c918029f15c2e110229b05d8e44152e541288a85f24a17359e8828fa27de2120012803e08301d57751204305e19e079037001e9a78879e12330e18814344b0280669e410028d3872f5320e151033aa30392b6899cd83af7d534a7541c09c0547c170053083121703886d6259598881c681a5211033892015193018b7753d1a63874362f65810127b71e24607db9032d79c7127b981744e40123c37a43144933d842a2d12f97f63f231637a2166245588d99612f10400324d068d17600a6f202198041ea152b99c5880270714d378c2a819001f43b5a4586639187f10481dd069099a14e2cd1861cb5127b4712089025db9312798812ed98173034fe4ab0c27c47f42f74b812c385120a407fe601929991932bf93b09287d03f312bd378deca885fe8154321936d0a341ff421d2cb65baf4691c87357e0722b6fb22384c812aa412e1e906331f1928ba1832a11018ca63624104a2a8082cc735712507a6b589556b912fb671914e6421167802991011b4712acb11c4ab96903a6205a659626f17e3cd17017e03b0ec081ae9819bea23e2a4119ae711297a8278a335e5d55972cc15a94a917f0f53be6e5012ec624258170eae7992b7189a189189e614571c3371800382d118079a33d3741968cd17ba159461d108cf34202390000b1015e24900119e002e2a4153e591bae09160d806f3b9412bd4347bfc52ff6fe8713bcb9180cf84aa0b401fb854a0dd38ca61199994100dff59a2d416ba3f8972d33982f779cc7c29ec65120779917e8691ac2c1012533013e604c0990024ab755e99715ddc91810802424f3660a72170e402d0ec093e7f99ce5612cb7536fb7387b46219f0ec899268101219062df1976167aa1cec77810a34c2f97a0a6816729939d8cb19fcac188cc857db5e1a2992101cd79a3aed737acf912e8d212ca75610ea8a38c7136288121111903354891345a1b74580086680323e3011cc072b312a42d71005dd103a104455c5a5c636a20ca5797485aa6fe11a56adaa21edaa656c9a6705a1e693aa79921a7765a2537700228c0a77c4a027d8a0280faa72a813aa8825aa8884aa88a7aa88b6aa88e9aa88cfaa77efaa88d0aa994caa8987aa99a0aa9275003010100003b	\N	t	Y	opuscollege	2011-02-23 16:36:39.568268
7	StudentCard	studentCardBackgroundImage	image/gif	\\x4749463839618a008900f700008c31318c3939944242944a42944a4a944a529c4a4a9c524a9c52529c5a529c5a5aa55a5aa5635aa56363a56b6bad6b6bad736bad7373ad7b73ad7b7bb57b73b57b7bb5847bb58484b58c84b58c8cbd8484bd8c84bd8c8cbd948cbd9494c69494c69c94c69c9cc6a59cc6a5a5c6adadcea5a5ceada5ceadadceb5adceb5b5cebdbdd6adadd6b5add6b5b5d6bdb5d6bdbdd6c6bdd6c6c6debdbddec6c6decec6dececeded6d6e7cecee7d6cee7d6d6e7dedeefd6d6efdedeefe7e7efefeff7e7e7f7efe7f7efeff7f7f7fff7f7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff21f90401000000002c000000008a0089000008fe004f58a870a1c2c082070d1254887061c2870e23369cc8b022448a172d4ad4887163c68f1b4f5c0040b2a4c9932853aa5cc9b2a5cb973063ca1c28b3a6cd9b3873ea2c39c1c2ce9f2d030c004a1428cda23a07346880c18307121e44787080b4aacd9e566b4e4801c3c3d2062461901ce021ab599747cf8ead81c1a483112920a83c0156c008b5785162cd2b22c085143148d8a83074a55700014ee45d4c32ed59b22755b44c20190006048c17ef7d4c2240e4962a3c0318213ab35ac755038818410065e5952226347e611aefe6aa0948b44ef97aa5629231628870b01b6500127d6bdb444d94c05de3134674709960e461000a388c1869520009010342fe5c28addce56da2037a971c1023414cdd2150c638a9a3b8031a219c161e5bbc3c00e63f91965208fdb9d4800e02a084c10850b5d6034a128cd000092e7890010929ac66a107eed5761e5034a49482043691c05202357880034a099485d8572411b0546eca01a893036d99945b82353920db4d2dba64a2873e1515400a883545e178375d6753902b99680158a6d97893033624e8410505dae4644d50aae443054b1149d4041ef0a81e4e6182e9a24a249cb041879959195303c399341f5019b0f9664a11c667a64e0782901f081e8cf0674e53f9d9120974d659414eaa2dfa5f0d54e9d4a69b2e9d409e6645de14036600a8900286a70280a64e96cab4694afe093c27294e13503980ac3a7686138739bd3a60976a7d08130a2541f0a3494e8d5043a4311dd76bab28dd5ae5a43661104149227459d99154d60401b4d4811bd9a7c1861a9302dc2955036f267570ac4c18f47912b3b08a6b1203f62265674a03204912090dd00bc0a213e458539c240ce5000a35a4006c49beaae42fa8321d279a6a86a1e440be266da5006223cc0041031e043082082b459cd2848ced7b9208744290694aad32109a7931746b1204a42a10835c2ceaa0c2d044173d340c47cf80eb59c2aaa440c31d64f0144bd01eb71f8b24509bd2c8c8eaf0a9ca2a39c0dd695abb84c1d842ae144007d79e84e704e49a14006d3a7220028f0080ad12fecab6991b54ce3089c5d2c6cf51f62e4b379f6472670de46793a064cb34b14b6ba624c28425c7f4a54903bc50c3050fb3b474564dc31953e528354043e82a6dfe324e0ecc6c96cb2609fe12ea274d70f84b235c8d12c77bcb6b56e996c7643b4bbad634fa49c0abd483ce55d15ed2ba30e16e12df32ad4a354ec73de0e9f07eb384a60829e0bd52e22b6100bdd9c9677c53ad00903c7bd92da50800012aac7fd2b727364f52e32ff15fbb443324ab100f593a33510232c014159cc0291e0001545412001584206e2be99c4b0680020196a4801810d84f68272d6461802e1878c04b644482f6c5a47766d31f4c64951e5221e58024399b0212e080c2d80083fe2cf2c005009612d6212606be4309010af8a4f15c4e0101b080f08842bb00c4c00327a0010f12b427f3602f5b72eba0898ac3411538050518a881f98c432c9c28c0062e50540766a00004b4f14ce19bcb0924148204598f241320c1bbacb81f090d0c3f3648d4cd96e29917d02d6c06ab89c9145081b6056059762c0aed0e9482117cc00623e8604b9c223b920400059e614aea0456a1dd950403f48b490ae895980a4ce08e3bc1214954b01b243927040d88010d3e350211deef052298814c207001c819e7046d930964e6f282620e6e8a2b91dead68f0b9f58ce74b13409b71cae7bf1140808929a19e4cc0a89201d82004cb8b9f0ace164995e8b22493fe93db088ef59a58252b947bf44c17cdd62713b4048935c19e4a18108217946600133095045a23bf96480f9006ade02c4de202a9b92007a22953deac45aa00b80026d50940037ee3b43dd6245f17e8c0153d70aa0a90a701aecc5d1e0717031310606eaf148f67127082598ab40117f880685e604453c680002f705d491a7017ffe1c82526932149608696581a2847ba23c905e8a582a8922401eefa580a5f1280d5016003553b678292c3d614003177287880c0fe08c89db2e4020c00805d4ad0a7468d932402605b60f3b992b1be329a8811410d320034c176d2862a21000a308b5509488d040e38408c38765188c926069ef14004184b92619244015e99fe145f49f2a78a02c00135c0a0c95a420018c4f3252724090a9aaa2abf222f022e1ac06a5372ca922800040d900b3aa3153067a2c0011978a00558174ab460132689110d6b5352da921c892d6775e654ffc49ab23cd003c0c2409c1c6ade9f11179039d5d35df7462a9cc2e49ef6fc5e38a3c5c484cd6006ea6b800b3e6612dbee2cbf86b19702b41ab66309e825e56591bf5a55991655538526f98e795117569b285425ae7de154eb293ee3c20401a421166c5160aa1188259ca25d59a878a592e3fdeb8772931a0a14458308a8f4619add6fde18d42dff6598b922d0c1096cea16733eca032a8863091e993bd99933022f88c194322082ab39e70467e365feeed09c82135416008569400a503081fe0ce0bb2d2e4a126322239214004fb0094006dcf3270918762510303272541083198886001378817be41b9c0ec42d6133f1aa7f90f53008d8e0019fc3654c7cb03a2a39007a4e995408188c122b67cfc5feb980052ea0dab17c8c00829af54d6ce01a0cb66a6d1456c993f362031064a0071ee8810f7ac0e81e3c08000e1315084e82010ea864a02489800e201b13009ba68d7b0a000858ba559c58eb24a7369d5bd0579361074b69b53eeba23c881872c319952ae11a625230ed9c789b31ac6d00894ca2deff1648cd2ac9406b8e634c98b8fb2c5c5eaf8e20ecbef5b0d824e53329abfd0d6be54c17641857328bfea8a21434cd80750c984007ee6b514d6fba54d786d8c75d228218201b984b3901eb52606da0fc5b33033f09be2d6613052089c7a6ccdfdee82d6c97bf7c5bf085e8a800b0d99ba8000109a8402ce305216ee7b2e3ca29180048a0801184406b118f493247f0c09438200606ab60f49cfe720788a0e048af09650170823db75634f0bb21d8cbd3b81d2215d2746789041a30e813dd6cb6ed4efccb4960821700532a3a81ed07b0ea82a957e5e7b5613b510ec4d976423ef22f7f89a1bff21591a704db2b2100d35b02fadaa480f524fbd300ee0b7b0ab29b8a924fbd7a0860838107400750f1bb8e0a9eef60bf6ff09b0e214a1c2a5f10a8b4f7ad868948f5fe15fcd4db1b31209800ab4ffcbb215bda40cebf0af4373df393842865f26ac00b82ae92ed6bb2fb2fe758da4da280377b00c28b6740ebe71f1ca36ff5923be45712174057f7977a3081014d9500f1d1006b743fd874205a65219f3780e54100df97120bf27627a02bad31616e2302dfb31e84135cdce78033145830813209600335f0021020813a830175560330a0033425210990201fc822ae577bcaf17b4ec33226a128178002ace6002790009b173ff2e1120a204a18867f9b065b1b944820e0756fb17d77e12c12e312770179469819186385fda6120840023936007c9339ecc21222d027ed77120fc718baf1120e964113d2737f884f2c310043e263fe2b91868c918029f15c2e110229b05d8e44152e541288a85f24a17359e8828fa27de2120012803e08301d57751204305e19e079037001e9a78879e12330e18814344b0280669e410028d3872f5320e151033aa30392b6899cd83af7d534a7541c09c0547c170053083121703886d6259598881c681a5211033892015193018b7753d1a63874362f65810127b71e24607db9032d79c7127b981744e40123c37a43144933d842a2d12f97f63f231637a2166245588d99612f10400324d068d17600a6f202198041ea152b99c5880270714d378c2a819001f43b5a4586639187f10481dd069099a14e2cd1861cb5127b4712089025db9312798812ed98173034fe4ab0c27c47f42f74b812c385120a407fe601929991932bf93b09287d03f312bd378deca885fe8154321936d0a341ff421d2cb65baf4691c87357e0722b6fb22384c812aa412e1e906331f1928ba1832a11018ca63624104a2a8082cc735712507a6b589556b912fb671914e6421167802991011b4712acb11c4ab96903a6205a659626f17e3cd17017e03b0ec081ae9819bea23e2a4119ae711297a8278a335e5d55972cc15a94a917f0f53be6e5012ec624258170eae7992b7189a189189e614571c3371800382d118079a33d3741968cd17ba159461d108cf34202390000b1015e24900119e002e2a4153e591bae09160d806f3b9412bd4347bfc52ff6fe8713bcb9180cf84aa0b401fb854a0dd38ca61199994100dff59a2d416ba3f8972d33982f779cc7c29ec65120779917e8691ac2c1012533013e604c0990024ab755e99715ddc91810802424f3660a72170e402d0ec093e7f99ce5612cb7536fb7387b46219f0ec899268101219062df1976167aa1cec77810a34c2f97a0a6816729939d8cb19fcac188cc857db5e1a2992101cd79a3aed737acf912e8d212ca75610ea8a38c7136288121111903354891345a1b74580086680323e3011cc072b312a42d71005dd103a104455c5a5c636a20ca5797485aa6fe11a56adaa21edaa656c9a6705a1e693aa79921a7765a2537700228c0a77c4a027d8a0280faa72a813aa8825aa8884aa88a7aa88b6aa88e9aa88cfaa77efaa88d0aa994caa8987aa99a0aa9275003010100003b	\N	t	Y	opuscollege	2011-02-23 16:35:46.993779
10	StudentCard	reportLogo	image/gif	\\x474946383961b5003100f70000000008081829214a6b316ba54284c64a8cce636363636b6b639cce6b737373737b737b84738ca573a5d67b8ca584adde94b5de9cbdde9cbde7a5a5a5a5c6e7adbdc6b5cee7bdd6efc6def7cedeefd6e7ffdeefefdeeff7e7efffeff7fff7f7fff7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff2c00000000b50031000008fe00273060e0606041820613225c78b0a142870c1f4a8c4811a2c589172b62dca8b163c68f1c0f563820a0a4c9932853aa5cc9b2a5cb973063ca9c49b3e64a07246deadcc9b3a7cf9f3e71021d4ab4a8d1a33773225dcab4a95395429f0a1820b5aa559e5191523549c1e480ad57c38a4de9400153020f4c36d83aa0c1d8b76fcb36a5c0d6ed54bb02d2c2ddeb546ed102054e5ae05ab26d6104351158e8600102d80716225b6810d864e4ca252f7b8560e18366be3dfd121da0017301bb0fb6da4500166c4b0c1f3cc8fec061ab050fb17367d8fae1035e01b151f7968d7b3068ac668f66c06c81ea00c402509b24e07a2584d8a91b6cf89021b3870b0308fe40c0dd1db887dfc1a7c6be40fdf9efe335451bc500a1705701f5a397d43b0033cb01e99554406c81dd665c74b851156049e90de84175f0ed249f5110e4874060f9b9f55549efad84408227612780815ec5a6e07921a248406cf945185a724b555852571b52055d01adb1d4406c2865e0d9881e1ce8e089e8a128c0761e6ce0988b12c2b85401184c05e154041436a549e379801289244ed58107e52d689e5d0370105b715732d9d2844815d0e27f69eec7a360410289db9d1bf06624837b0a504006c4d5a6e64c6c8eb5a14b0de086d29711d8796604608929666180fa36a84c85eef5d5940e5659586c887599928f7af1d9a17a7d5ebaa6937c1dca526cfee509108189401e889204dc95f8a094277de80174aaba94e9a5897ac081053e1a292a4a0e66d0c0035f1ab76306916180db06c1c234eca50fe4265ba9cba2f4c09db21d98e899b0c6996d49db5eea1e8e276dda527f0dac8512bd0db0b6aeb60b1ca5ee49a7d52bb0c0fea94940bd541d6c6f840e2430d47314581a5367bd555cb1ad6a36104208556accb18b0df7d41f041d70071bc62d957c676f19504059b01a7fd071083283ccaa4c6869c0dd03550e40f1bf02ac381c08b161b0b0aa1e77fcc1c70c3b2c535b271ffde7701fdce7126cb8e5a6b5a7c4d23c73cd4dc744810693553735070f20905bc1295d37348bcfa2cc64d2d16dccf571ed5aa912fe023a73e0560166560c6cdb6f67bdc1a94d0d7081058b2f7e1f018c477e015d75d7bc23d31448cef856905f4059048c0bd878e4a5ea14b24d0d98b95c49d771a076d616dceda7ce5ac746f4b5400f75c1c61b2f1d825b16f0eefbef757f1cf3ccc26f3cd800bc371f4249cefb2e3b4da7cfd440c9185436c0c9038c4735cb8b598c1b0859efe6a6dc4c05cf31016a13af3e01ec2fedd6f1c52b1d0202f02f3d1801345370f00634831e77e00701af21e7696e6bce74ccf437eedce676e27b5b6ec8b781e93d457d255991fb369641f955ce7e5ff394f282b631bb60500023ac1f569c0693012dc924ddda8d7af29401a2d94e6b1e80e00740d09c4ab1cd29febbfb804a4ea8c1f9d9ed83958b40bdf417340f8e888328fcc0e11a103cb0998e853071cdf63e909f32d566003cbc0dd574082b16f9097d4d39e196a0c83fe25d0e79c81b9ea5f827b113f6ee8e793aa04d06d0010e700d3654e98ce2aa96b542d6f00308f81017dfa246f805928d1ea4df1ba3b3b4e915313350a4191a6d523d9a50f124110b0c8006d31b30fae60393e3e287f244800d084a2c41cc20cd80c7c659aa5092061c9105d2424713663204c62940647277132cee644795b9ce577808a00781204f3c8ad8f2886914f5d56b561bfc5d030ae8c64a22d16310a8d708dbe82ced2c4d80537c9f1e7b22a3a9f0b0896bd921703ed03d4bf9c88256eca1c01d7b87187dcaf17edf3c62fbf6791f1fedf37902e8c03e97464db218d32703a2ca8eaa942b4182b13bae82cbc0ea059db66c143a0a4b58beb682808dfea6a4f5da0e423d3a307c624a290f9b91108133981db9a5420dddd74bea5519351a252bfeca4c5a06c0339d2285668c590c148f0254a33ab547d18bd54f61fad4aa66107e58654a53adcad5a76cb5ab6045ca57c34ad6a138c00000486b00d6cad6b6baf5ad708dab5ce74ad7badaf5ae78cdab5ef7cad6b41ea08f1c082c07003b58c112f6b0864d6c6011bb58c516b6b1907dac64193b59c752f6b296cd6c64312bd8ce6e56b3958dac610302003b	\N	t	Y	opuscollege	2011-07-25 10:59:14.521142
11	StudentProfile	reportLogo	image/gif	\\x47494638396107025e00f70000214a6b214a7321527329527321527b29527b295a7b315a7b395a7b39637b215284295284295a84315a84316384395a84396384426384426b844a6b84295a8c29638c31638c39638c396b8c42638c426b8c4a6b8c4a738c52738c295a94296394316394316b94396b94426b944273944a6b944a7394527394527b945a7b9429639c296b9c31639c316b9c396b9c39739c42739c4a739c52739c527b9c5a7b9c5a849c6b849c316ba53173a5396ba53973a54273a5427ba54a73a54a7ba5527ba5316bad3173ad3173b53973ad3973b5397bb5397bbd397bc64273ad427bad427bb5427bbd4284b54284bd4284c64284ce428cce4a7bad4a7bb54a84ad4a84b54a84bd4a84c64a8cbd4a8cc64a8cce527bad5284ad5284b55284bd528cb5528cbd5a84a55e84a95a84b55a8cb56388a9678ca96b8cad638cb56394b56b8cb56b94b55a8cbd5a94bd638cbd6394bd6b94bd528cc65a8cc65a94c66394c66b94c66b9cc6528cce5294ce5a94ce6394ce639cce6b9cce5294d65a94d65a9cd6639cd6738ca57b94a57394ad7394b57b9cb57394bd739cbd7b9cbd739cc6739cce73a5c673a5ce7fa0bd84a5bd7b9cc67ba5ca84a5c684a5ce84adce8c9cb58ca5b58ca5bd8ca5c68cadc68cadce94a5bd94adbd94adc69cadc69cb5c6a5b5c6adbdc66b9cd66ba5d66ba5de73a5d673a5de7ba5d67ba5de7badd67badde84a9d684adde84b5de8cadd68cb1da8cb5de8cb5e794b1ce8cbdde99b5d39cbdd28cbde794b5de94b9e298bde2a8bfd4a9c6de9fc0e7a5c6e7a2c8eca5ceefadc6e7adc6efadcee7adceefb5c6d6b5c6deb5c6e7b5cedeb5cee7b5d6e7bdc6d6bdcedec6cedebdcee7bdd6dec1d2e7c6d6e7cbd8e4cedee7b5ceefb5d6efbdceefbdd6efc6d6efc6deefced6efcedeefcee7efb5d6f7bdd6f7c6d6f7c6def7cedef7cedeffcee7f7cee7ffd6dee7d6deefd6def7d6e7efd6e7f7d6e7ffd6efefd6eff7dedeefdee7efdee7f7dee7ffdeefefdeeff7deefffdef7f7e7e7efe7e7f7e7efefe7eff7e7efffe7f7f7e7f7ffefefffeff7f7eff7ffeffffff7f7fff7ffffffffff2c0000000007025e000008fe003f011a48b0a0c18308132a5cc8b021c2499e3c7d921831e2c48a142f5aa4b85163468c1e3f560c39d163499018456e446992e3ca912e63aa547912664b96383be67ca913e6ce992463066da9b1664f9e405d1a4dfad3e8d2a729a136158a7192c3ab58b30e1408a0abd7af60c38a1d4bb6acd9b362072440c096eddab66bdfc26d3b97aedcba6e11dcd56b976f5fba7ef3eebd1b17f0dec07c07f7556cb8b163c18ff1e68d5cf82f64cb922b6746cc99f361c29e0187a63c1a7367d08c2f4b9e3c7900dad7b063771d28bbb6eddbb873ebdecdbbb7efdfc0830b1f4ebcb871ddb48f2b5fcebcb9f3e7d0a34b9f4ebd76f2ead8b36bdfcebdbbf7efd4affe831f4fbebcf9f3e8d30717afbebdfbf7f0e3cb57ce7ebefdfbf8f3eb575f7fbfffff000628e06ffd0d68e0810826f85f810a6e57c00a2c3428e184133248217505dca0c2851c76b820201e3a270008148ca5412a8884c5c0071f9018e28b308267618cbe65b8a15827ecd24a5814dce063843406296474330e991b034528f1c30f6191e0ca231494e8558f487c1185915866495c915acac6801358a8a28a6b5f69308a1e3e7ed52315a3ccd1e59b70e2c6659c6719908312aeb8c24001017865811c7148a1849a37b0e92658078c70009d8c363a67a3651db0cb2e43dc408057190e31ca28024c7983146d8615862a62406a6a978f325a80000590f9d501feb2b41245120560aa820ea59c42a8a1600520862a6130374001071cc097b1061c10409f611d40acb1c52250acb3060c4b56b40754cb6c580340eb6ca7610520c0b407241081b4d012e0eaa91da61ae70059c49b050363e5628c06602130a9ab6b86ead5073754a1870fccada1c72dc658630f3bc618534b2d48580ad60062fad2f0c50d03b369bcf48a656fc3a76481c458825cbc4bbc2ade80c4c30dd7d30f3617eb8232bb1eba0b27bcf2761c96bd1b20baafa7a01eda15c05fe8c143c1071b838d3de61843ccc395d6fa15c5aa588c71c3be6c6a4716158c85cbc5210f4172cc337f9561120f5bec32cc0dcb9c05cd35830877b83e72d34d2856801016fe1676e8b107095e1d20e60d2d5cdad508fe76c5851e4adca037581fb0b0806f025043cd3cf9dc63cf3e9cdba34f3ef994538e1b37e83c8031c0d4834f3efb64ce7a3ff5d8534f3ed034e3480b1e7cb54e3efde49335176365f2f93ee68c12cab63f94b2cb3cb37f8e0fe7f9acaecf3cc0f832378736bf29808fdd9c434a162184654516a08c0243e083df203500228ce2c6575ee821c50d527ec542e9be0d604d37bc73ee3fe7fde8c73bdef106fa79e574c6d85c00fdb7c07d04d01cd878c40d3ef0157904b01fc61845a9c492897e708e1d9b721518aa76410ffe0f80f968d8f52e94bd3711a0001c38012c7cb18724b4e02b0c6080247271860fd06b00fe4a90021cbed000af98496800a0432978b0aaaf0ca152f8dbcd010ce188d8718e1aba88441bea608b5bd0c31d9c5b062ec870c0866d0e82b268c31c16310a5ff862739f73462e08514113666d8361e9a0078bc72900ac0813e46047ebac810de3b5e1906d40c42a5a710a55ac90422da45327b0e18a2c880d2c9730061d6ed0b500f8480f7a286257da87443aa8c20461718213827083c9ed0602b5b0450377a18a38dc2009a328853bdc11c07260838e5d41e0e6b0410d0906c10956789802fbc10e6c70427726d4181ec1d2c10f6eaa2bf79bc502ed61395542f1064a00e5351f29a148c629058078842b4a11061a7c250c74a803229814801ce6ea0146fe4c5c125511033551004c1f5800b87043000acca01ad7f060347ca186198880011680410c62e10a97d5e31d98c881050020cc7d5863196f60000540008219cc4017be10643ede810b0a74cc829c9366f016c847d7dc6009b930a13910810892ba34871610010c244ace72caada861214437a2518b487c056088d88521bed28a5a40c02b882be529bdb2bd1bc4cb00bc59c00ddad0c0558c025f5f0940bcd861c2931581a366f4a831cc10963a8cc21a0eec473234d41598ee43a61c342108fba8842cec6281d84813525f644e3ad1e01298a80526465082aeaca80dae7883053a56d5ab1ece7d5d21c002c6908711604a095478e2ba70530125d4c184fb48fe841c1c109627aec38e7da0025c1328d7a37ae50b71a806008d710320f915b079a46908013004c32e701c5ce8c26219ebdbe97a65030f7b98ab76a0073c64a1095de92c56fde5231fe9ec00e3eccd08f4b00a00f6430bad1c8b384c480d55bc61b79bb38631ca109616dc6019262c4671bb72db986a70a6d61c455786e084c37af01d0fb36edc240c160d4422120f83c0a200008335c8e10e70e84a24527101705d600f6b58b00e58c0824b05a0000ed8831ec422806dc566bdedcd6b145a2c5fd6ed831aadb86f47f55b5d00dc200800e6dc3008d7573b1e38b07b5c2e3875a10fcecd4317ba88c05abe45610535165207c86e2d22e01513ec82155d292ffefec47a23508a120016c88213148b43c7d90606a3a84503c94c966160c3654db3047ee5ca5fb038210bd53021718154e0bf3e39b9091e2825dc418f06ee3217b5588301bb7ca02f372accd9f52c0072b42300f8d7bc0020c08001004ab076050472a6b3571830c13be779cf6511c69ffb11e8ddd643ae74054b13101de0551ff7d1d454ee285c356997f96f97bbc8f4a6393d204f37ca3558302c35f8bb001df8a80536a6715728d00206bff55f849b766d66508b5dfc8fcf6399853104d9eb211be3a801f02f36dab1b9663ed32bc79ee657aab98fc17ea5023940c43b5cd68fe7e9c31ef9a8c73872210b2653fb431707cbf878d10dba66a8bcb0e91111fe9c706e6c96b77eebae852ffe9780b2c85b90e03086a011f86bfd063bcd3720c7e60a8e8d4e40d3c002f78a1e89b7dc71dfc010036ca07b19760b59671c3fd686540ed7008a3d1c020c045097e1d0128017ee6968002b1d01065a9b18a84217b826cbcb8927f3415f141aca40463292e10c676cae1eee988518ce07f068227be082ddd440c5d5800ea08014a318473976be8f7bccc31cc53006083e40f6a7cb27eaa62a6c9ed3d01b35ebec366647bb09e12d96b5c7fc12befe5f031bf80e7748a2d67d07fa4ca3bc6cb114205e84fcf50907e8a3ca5b1e3e9887940540000319a01537018892791910eeb297e2160c247d588a418e77ec031bb960c4a019fe08db7d38831ab078c40fbeee95462337d9091ecb88405006401c2212c65887f5f731bb35c0c1d5bfbf7c91f3bf9baef69e3778660bee257d60f10c3b570db77008dbe75eff930bb7c005515447b2076544577b66013098800de6e05e9bf266fcf71ec1c77f01500114f00114b02d02b00004b0270a807f6731027f90631e140315b05a00a00005800d3e460dac206471f50eec900c29e10983a0062e5001ebe315e3303bfb904163307b05277867215267200bc60040fbb029b4f581c0b77f5c081cb4a66637e07b63016ba3d04078e004288773e6a707c0636f5e4816cbb06bd3a00a6700857c448662d1238ed0401df88520188780887c0250630ca002fe2ca0022080887a181616b0047be08778b05160910449c0569c930b727025f67673af610ccee032d4500bf7d52b023074e620635d212e35d67c5d610143f0087e380a1e3888e7118280080227a71b1dd040e3800dee3435b7700bceb60f154741f65668b0510bb7c056cdb409610130b2b040d9a058bae8235d23163d7030ff034a1b668be8818b5f783f3eb286b5d18b26f48bc17840b7300bfd638cb50687b2c18cce880dd0083937308d1e9458373034e5958d61e1037a2080fee38de0981ee27890b90101a3700afff30ee5600dc3008ad8d03b9ca30ba34030c11457faa58caf313e89c639f5e00ccd100a89700aa9c00df3d06fc6800b5fb106a360fe0cf9300f75e70bc5e00bc36039e6b03afda00fbb64830a391e091994b6e100b9f43f17a55f7358912684911a396844261b871692f4474c9b2226de600fcfc330b3f0156d300ac7003bd8a05f17430ddd000feeb54b44198e82b896cd21000d0001b7a00bbae739f5103bbab70bbaf0030de02ac9281b06c0008ea00b78053af5600ee0600ee6b039e3400d9b2001a2060030490dad137117b570102792e5b00c63003c6e591e43f999b22126c59857ff630baa707c1bc95b51591b6ea00ad3c0802704338d10165f7985a6c97d22890dbee074a2d91da1f99baf110331e00890500bba900b93e20ab6f00891300331e0821cf5066fe09c75f006a6551b1afe1003670009a9600bb6302993820991a00635d03360710130d09d92009ee23929ba107e87400635b0009f279cdc119cf88916f753347b300aa0900550e023aee84962688eb0416b44900576b0299bd238f7091622970577e0a067a2074ca06efbe91dfac9210510a1bec100202002233002246aa2257aa22a9aa223307c4079165102033e30055b10053aa00351a2871440823b4a0149281b04500120a00348b0055ba0055b200214b075b657012c70a3468aa43ee0032ee052bd610114a0a217c0008683a55a8a831b7a161d7a213ec2a4bf51587f60a16abaa6167a0759f038e4a44ae5b3299a46410020a70efa05b017a66431a603222e05902c100001fe1330014ff4a3bed10578500aab9027aed00a8dfaa8aed0a8ad90278b94277f80072280545610268e3a0741002458e0a97932072bc6a765e1a702023054a007ca030c01540aa31099bf010bf35642b89aab25d40cc6b08e8fb429f5f00fc20a0c4e20360100acc2fa0fbe50aca8daa76d0927002330af1a40a7300a17301c9b70abbabaad17440dc690024885acc3caac0020aeca4aaecd1a16aa6a1fb4d65c76500badc00e10d70feb3096dde00d01d430e8191cc330af26b47a17540fd8500d93b2296e0aa7bf3a0ac11a40cb7a49c81a40bb80aee9fa15eb3a1f0a4aa10fc36f0ed44cd8d00ddd1040cb600cfb0a1cc930afba99570124b004bb0b069bfe0594484e0fdb0fcb4a045d11b3117b49134bb1cfda214540046f4007b3e00bcb000dce400cc02026a0a00733b00133c00588600c89063bf5d043aed41b435004d780b2b0e50fb9f90e4b750aa78004439043ae0837e2ea0fcb7a6e9b320ffdf00f682bb1390b00159b1e02a04aa6a00adb700ef62096d5202656e004f4d22363600c007641a403a2b8a14a4c59429ce30ffed040f0b0549bf27f8b65aec4eab0a3f00e0174ae381bb772bbb30722523bf0036ac00895c0099dc00aaa700aa590088830088100083600062610036052088dc009b8400cec204879250b8b804abec19c6ce5410b045b17d43aef600ed5400db8800b517003d2793d31dbb035feabb06ddb0f37ebb95e31b7de713f72300abad00de6d03b0d23ab8d638e87b60bd8c0b64a1740d4b00b60f01b76b3b7dc07b0c9abb57aa086e1aab0ffc0b02477bd0babbd709bb3de8b1d0730033440066570066e90080dc90ab0d0099c40088460a44a5a2b232202366003ab500bd4e04bd5d0bccd8085de500d860002880b1b03700231a098a669bcefdb4ccd4b0d23dcbb5b20bdfd1bacff6bbde5eabf3d5cc0137bc0d5a101bbe00be7700e216b565db0a77b98057840480e7451c1a00aa5a00767f8affd700b96a41ba0a6ab8dfbb88a560baa904b62d230b49ab03cfc0f972bc0c9eac3dc4bc4d3210023d00aad300c14070b88e00651a002e6d82dfe10a00133100aa6800dd8d0bbcd500cb2400ab9e20a00eb0ba1b0060680a86831001050029392bcf9cbb50d540dba500ba3b008748008b0000b08802085f80011100110b0caaddccaacccca1a663605f0caaebccab10ccb1a4600cc72b669ebc6c2babd5e31a8b19ccbb80ccb07c0cbb4ec00c7dc00d9b20009f000b01c01df080081aacbb78ccd10e0cca802bafb1186be49165ba007ba700ef010400354add7ea0259800a49a7abd5a0076c601b25d06e8ceb408e8bbc17f44519f43e12e223b7e0adc6700c96d330056d0cbeb00b83f015aa8430042dd0076d39c0b00b8960673f3cc03ebc296c25ac700c00acb00bc060d0103dd28b60d15d61044e50fe0b031dbfc6132fcc3891048d7a5e313eba20d00f2dd20d730b76d8cd1302ce408216e35ccee7bc52ef20abebdcceef9cabf13ccfb56102f69cbffd90cf5a9cb2ee500ca0f5cf37300b026d0c112dd013bdd05ed1d0844b0dd280d35c4d0d135dd24052bde4aad16dfb0fc2dc15b200d2635dd6672dd21264a75db1044ee00a06cdb2a3e0d2416bd032dd15344d0dc760d607add377a825724c1e03b029d9607dcc840d27035e5e5108b51092ef800da0f48e289b42c6f0b72b0c00459005427dcfb9ea3f52cd40fbb04b048a205cbd0fc95adbfffbd6c26a0dfe1279f960dbb7eddbd570d596dbd6fe0bb1cc7aac40ecdb9b9bac4d53090060a0f4e0dbd2fe9dacc8f015d13dddbf9daccd10c058f2d8e311d9a3600eefa00f957d3256f0159a9d68faf00ed9004ac55842f5d030a45d1685750be6acdaabbd0fad8d85b03d86b24d0dbd2dddcb9ddb574d0cc6a00fb67d41c02ddcc9fdcb177ddbdb0bde6b9ce0b8fd0febd076467603138eddd46ddd1c3ee0ff400ddc6d24decd1d23e0068fd00ccad0bbded00dab000a5bc0ca1fba88b3900bed3bb0b3c0056bc00aada040282b92f5400ee3000dcf800ccf0b0bb3a00ccbf00ccf300ee6d00e3fee40f87cbffb500ee380085c3007a0a00abb900bcbb00c8598201683e0c21acfa0940760bbd1ff10dc871279641ee27ea307689e0a9a5be60c8ed1c4bdc6d68bdcfe2e53e6609b0767dee7ffd06b02b0044630c04da30b7e9327bbf4d6fd200c1e9eb2e5400ca024e7c939c0cb30e24352e2db1103a3600bf6b0b7fdd0e2dfe3025e61a0d2d00d7b3b0ec6c00a373004caa4b5537d41346c0ccd10eadcea5e8e7bbf2f830d10b80459f007cca8420a622f6f9ee9aae404a0440e51fd0fbaedcf2d93acc690eccaae07e5dbb6c1edcf6cadb60dceac02b0b6cd6e0cdd45ed6ace30ce5db74e30c096bd0ac824d9ee80e00104e95e11dd01d44cba40ed5535c0d33e28ddedcd01b2a361700699e009c260c3d6500d8ef008f4390220005619b203b3300bec000fc6b00b8c40033fb0047060c8e650af87dcb8b9194011f7782ae5fe5e9bacb5dcf7b8ef300fb9300bfb4b052e9c02be7a20c69eacc24082580a07585091767e280df3e6b880a5398f05cc2eacce70e7b79dd1d81bcccc2ae1d9eb0b58d004424f01ebf0bfffc03032ad4a3cdc0fd5b00a7460011650a2c5600d64fee81efebfecd00c9830f5a5900aec20acfdb0dd25b7e9fe0e203ec20ab5c0ec01340fc6900bbef92576f0ceb7300afd5401c11e40861cb21ba8df626cf2f97dcf8c0ff901b4ebafed0ea730671752f3c2fa090ced044ce9ecbb2d93c9ea099dcfecfeb0e6480fc098abe67b6eb3122b0fc97ae18286ee6b4c0da3f0845ef1356b5cddf39eace5600cb5e915ff690ec92ae2732f249c1e1d01d0b3425b0dd8fe2046b03008821025db0201311006cc590ee6f0bc67a0050fd5035da40ff5200b98e00bcdb081628cbfc69b9b28afdfb24e7fcd840bb9c00e0b570fc0106420f0b20a32e656cff95e01102d6e4ce2e4c913a11f31000000664cdf3f889e162e74e2645c3f7fffaa8d72b370d4a87a10fbf97252c423c87efdfeed72320480808f21531ad3d306c6081223e465fcc7ce58a59715e7f15c366acc4400b9888584280c293d91ec9ccdc23902062b57ef442e2b89d4eb57b061c58e255bd6ec59b18000a165dbd6ed5bb202b26461d7cf58ad36373e84fda16a57bf7cd8b021b9410000851b86faed73e76ec70d5cd8eaf9f39732e5be7dfc2a5fde6779f13ecafe9b317ba6fcce98ac1b3704dbebdc0f5816257065cfa6fdd518b57d22259e35668ce9bfdd149d90c3f8cf19c793bf81b54cfe2f254b9703623aef87ed56ad8f3153f6347649785d88c68c22c5e51be23f644fa9df73772cfba88632ed3a895ddbfe7dfc5ed5e6e7df7fac12269671061647b8008102a4042000820806b9851876d8c10517173e60200018b890a49f7a8a2966881b7231c79d7a4aace7b3ce2aeb6c34cb46136db47df2d1a7b377aac9458a242674a61b76eac9450997fc13323f60967928a54fd0f2c5a1f38203a0a28b20daa823003ed20a2292829c2ea52c010860cb7ecaf125975a6c71c596139d2b6717468272621e95faa166143190fecac5bca6d44b491f7aac29f3cc66aa39521f63962062484413fd6a3f451bb58f85c2c282f4161efb31a7964890fae0064cdef1d49ad45273c69f6c7abb8d45ce5aa38c33cf5adca71c6ce05c8c9d5a6a5968892c5a316610477b6debce87204a9237262342aa2273ce3b8eca8fea5269392d413aaf4b98a41569bbf3ae8d663c012a924fbca3262aefb7f42682ea5a95cec3561f7766b981055fe3c58f5179eb2d0bd202c24a8d5276f6190753a440e0d45373400d75d46c8869a81918534d6955145bfd4cb0ba30a3d5560094c862956178b5f7633b8bfd6758b37afbcdc98aca396fca93c0fb872493aab4f665e6be9c79cf87b7d3271ff1eaecd6896ffec79b48a9df9c32575dcb36db39257ada7d1764a8d1a2376aaac10a20b571ecf1d4162774f80a966ee0e96798a79332064e4c6e68831a6b9edba5dfd65875b51e6cb28138153df2be85c55a21a83aea3bf3398fe48986a8c80923ca6e2858e08e1daeb8659be39239995d860e00e9468133a3cbe3aac86570c9c3133d3dfb19c79846fe56ddada957ff3b3572b47e2716ca9102bbae62cabef3c4b4d7609bcb5dcc895b6ecedec1661c8855c95b8fbd5bebdb757b811dfc2bc32b4a1c8485166fd2f18b32625966f9baac3cdd2e6dde7ca5dac5fad9e539eb1c7a74a317822aa5d35387fefeb4d6c29fea01f236a6193244e0000510005220818971ec6317fea0e0828258a08275d0ad196610800dec918f94702109d6d80c365c718b9458a31ad2308639fa418e5bdce214a7c8c73eb2010d450c810a791845d3b2010e2d7c205ffb6bd46de443382214c118ec2807397ca187352cc464db9b08b2a81339f04dab2b517c0e73aa259fce2dc412b2e0a2241011062f798b3aa113d7e8ca25bff394c3186d9a88129a10092ecac2102cd80b0fa3d63a3bca2b734be240586ef1b67ee8220b2eb9da0d4e540d6390010036f00c884695928db42225d4a0862f76411c6cd4a21579c34c631c7103c3e9011deef014176ec0803c26ea3647ea07e1a0449d8dcc6121c51019ca9ca0b24922278a58a21c982e97392ca66f16a6fed2852adae0a6a0856b21443b4ffc0070ae7fa8d17e0bb142166e612a49942d95f6c2e3367b350211a0800607f0ca00b6b0856b984317ae1883055039803a20c21efdc0441b765081412c463039b881333e630c2acc0123e5c88623d6400c0e61631822b80025eba18f5c44e20c151081211061883a5c600105f4a67f9614ac7e34e39ce72c452970f90f6b8c4296002086c89231d22d7c641e22f95eb3d2052dc9f5e37236634a4847b107988ea347f4a8862edaf4b39e8aa91530754636d244baa3a5a41ed0c0054c5be10a6cbc631e3e3242903a1aaf6e7ef563c0ec072ab2d082891ca05618cc4b6a10e10f421943073768c6657271032e50a63163b8fec12c2ef38c85e8621727c286310801000284ea060110ab7fa407116cbc2785e7fbde122192d2ecd4ea37351d85cb6096d35f4e07b29a7c8fe020a2464b20f33c74134f76cae10e7d6ce78ccf5c4f7bde139ff350638a8d755458791baf01a4e214d5b8c61972804a012c4004cda04639d80106c40c61111c4a213ffd89195c5020069529115f31518d7e8d8304303083199e510f7260031620a80005dc4b018efef63eb9f0c56fd8e10b5f00c317d57806069d638d3d506917c000293bf46b0c60042ab652da4312c7e71cf189762435db43289e3a0fe6e617bfb9392d3020b19016b4601c27f2473ee8810dfde2b71ef7c09633e5d1997fe8431f62d270fe39c6b1e07f2ca3085e952fa27cdbe3460dc016b5aa85062652801b248132cb3086915be0845470e823a27a589222e09933dc600eb530463fd8f1918544e6449f05327f04fb1bea64eb5ad4d0c31716b28bc152275dd9c2169bbd9053328b96662e1140de5ca6666c41c41c6c424a322433e76ba919aa0bc91a4fe44ce7ede40e5e651ed28f293da40138e210883884df16c20019626416b59000005c902b2feb01142a00415d67249108d4631e9dc9cb1a22f1977aa8a2155acc85805831841c5c1a3f90808435d6c18e639b43a8c746f63b6c9c0b2ef86021ac608535906d0e731c9bd9eb50b639ca016d6903400f7f3036116bb184202c44d5e52e472dfe9a00848578810bcd188739907d6f229263dbc588841990b2095cd03bdbf756763f1ec21367f6dab9cc2ee2b6bd4d8e71c8e2037514367f2c5d714759200b7d4809610ce38351e8c2cb15612c32bc8c0d4d002001bde94c9653e3087fec43300bd9546a2a80f1fcb4e13d3bcfce1ef410ee85a4460f3ce7b9cf81fe242780223b6bd04b189db0879feaa10a4d9f081bf4100aa2effce84899821ea0bef3d7c65625b315c81cb2fe1e3c38010738efcfc5d98ea80640210ff5c8c7630cf38390f7631d4e68026395a1776c000501c02006ad43e5087ee8a31ad85888c05283a0b7d7660c8b00c522a0be07ca5b3eea7ae00152de3587502422f4a3177de9f3fe06836335410fa5ff02d5f93e743dcc810a545fc81ae480f9ca5f3ef397dffa44b8e0f551903e14d080ad6c91a2821bc8a1f4c25f3e1c9c10ecc8dfc7edd11752219152865d50a31fe2408ac94fd7a6037ca433d841bd09885c8bd41886faebc74f1db2a3872cc42ccc6664ffc7a65f7ffc587f22d8d73ef727920cd359230030808fc020ec200100303f224b8d1dc23f07740bf7fb083cc882240899a27940b0d21f0c54140160ac89180004d0002ee8817fa3065d688533c09c2118025bb0053cc002ec19800398c103e8c00dbc41b3808612610773f0066a908559004272f8b3d9c2c14ad34023ec1505d02600b80463b8055548c142520555b00327b0b68024cc42b39007eac8077b30075331067b98a766d2c22334c35e6100f55b880d40011318014f5b0003188111b0000a684034ccc385708675c0883d2991ad8a1b7d600727d143fbb83f434c44456c1443631c45a30e76c0864d58c44354864ff8044fc0444dcc444edc444fec4450fc44510c45521c45532c45543c45554c45565c45576c45587c45598c455a9c455bac455cbc455dcc45507c866758876dc3376d63077178064be4c55d4c46645c46651cc567080800003b	\N	t	Y	opuscollege	2011-07-25 11:07:20.005985
13	AdmissionLetter	reportDeanName	text	\N		t	Y	opuscollege	2012-05-22 13:55:39.171142
14	AdmissionLetter	reportConclusionDate	text	\N		t	Y	opuscollege	2012-05-22 13:55:54.270965
15	AdmissionSummary	reportLogo	image/gif	\\x47494638376141002f00e7ff00fefe7bfa8667f3f4f3fbfaad4eb645a91d1bb7b6b9acdba72a9043a7a5a7f4b0ab9b5e5d74c56c526a5605cc3dfefe76eaf6e9f64b4bfcf9e6d3cf93ecebece2e3e3f8fffefe0000f2fefdb9e2b445b43afbfd87dae6e720ac45f6928e969696f43636c8c8a982312dfefef9f47b7bebf9f70bcb45d8ecd5fe5502f8f9f8b3af9dfefeeddddcdd9c7a76868585d3d3d30d0c0ccae6c7cbcaccfffaffc2b8aeb8ba72fefdfefbfac36bbd6466686afefefce5e68a292a2afcfcfc7877789ad594e4eff1f9f0e2f9fef8585958b18c88fbfffed8f1d8e8e2dac91211fbd9d6fac6c3643938f3fbf1fa0100fbfc9dc1c1c1fdfed79ea8a6cd2c2a80ca799ae7b0cc564f46474588cc82e3e3a0fbfefbf2b34bfcf6fb01d23be205058b979741774ed8c9c3dfd9e39e423ed4959201cc363a5b448dd285eedad937d163f7f6f5cc7272f5f6fa5eb7565f6563c8d1d2e1b0b07d4f4a21cf5493d58cfffcfcebebc7acb9b7e5eceb58da7efce3e1bea19d4d595964c25ea3d89ff91717fafafbdedcc4fbfbfebfba9a2f6b3df50101d1ecceacabadb4b3b2e6e7e7635c60e0e0e0eae7e6fcfaf708ca3efdfe70f0f0f1eae6edd5ddde7b6e73fd0103babdbe91ce8ceac9c877635eebd2d049af646f71719acf95c0e4bfdcd4dacd851ececfcedbdb89706c6edad9d6879e8d6da277f02729d0cdd7e6635bf7d2ce989d9de0f3e0c7f2d3c3c5c8e71718eef0dfd2d0d1fc15028a8d8dd3d2dcb1afb1f4f582f9fc7e61726e534e513f514600cb2d7ce399f5bcb80dc33efa090cc8c3bffb0c018f9191938e95fd0401fa0104e70b0db6c5c0f10d0eeaeb825b573afb0e0fa2a0a17f7e804f4441aeb3adccc7c9fa0301f95f60f5e98b04c93976d892948985fb0209d7d6d7c6c8c7444e4e5abc52faf87d00c734f703040bc733ef0609fe0705de0f10ee0a0909ca34fefefefefffffffefffffffdfefffefffefefefefff8a4a3f0f579c24040f5f779fcf0775b876ce2eadff2f589eeef9e92c4a214ba41f6e3c2cbe1ddb1ecc3cfdad75a5e5e2b11113a3b3afdcdccc4c663eae182000000ffffff2c0000000041002f000008fe00ff091c48b0a0c182e38414b1a1c31c3a1b230e4a9c48b1a2c073e4c68d23f76f5c113cba483c8b0022c233120af0082c324e20478b30616661594401882617705ed8c993274e521e7a8c9b11b3a8c173e330d6e4b553523049927a4addd944124e6a1e5aea7869d4e2381b45b23cabdaf39b8825d7f4b46953ab568e36f8e088f826b5090801236c74ad784e5c9108179c45955460999e4cd30af572c5a2c2214587128592610095b23605a23a1366d74239733af61af4e8a1c95349df0cfb48e0e9501abd03c519f4e388c5a45f96e8066e42c28205d1178b902bd7e742d46f56f07d904121b4c086e8c4919b3efd9c8e72d3d1e94893c8800fbadb24fef16a75eedcde72e82c28316e7c899e0f2fd2fc933d90a5f61550f243919037a3f37f7e28324924c238b3cd05630062d446e51441027b48d802ca0b02c8868e391d91b3c200003cd00800203e20a288006c70c31cff9863433916285288149238d344041894535411163c33d8123cf8e3e307ffac0891138d3c102200ea18b3c3273b18434b87467e78830d590894c20b2df0040206309163ce5f927853808f649229cb081b90c8ce042a24538821933cb18a354f4c224b2181f4d321008d0c00c838e88cf34832394942ca1a18d267d01616d8408233639629a98ffc00f04932094ce24922140890420a7e849a82001424e28a01816413e50d3d14f18f00fe7534212b086b54944e1a2048328815304c3a292ad53c9282a20789234e0f291ce2060db374b801a2ffa430c92bbe38a3c61ae89877100840bc218515ca1c628daf92c2b0570f8ec41202888d04a18338d2b24783821255a2c6233cb8c0825ebd92eb0f0fb015259b0e3d50600d3c20d2d1d01a7918d7443dc219c4e20590f893886c7ef8ebcf13c0c5e647183b7448871fe408508533ce48e188ab059533822948f823800de65040ee1041120b1c3a766021221d3de80004389ce5b1c84173b4d2853fef44f4cfa43c4cd2b144e43882059f47e8a00318391503c94136d810411752d4480e3e92b611ca7c0791a36d57e738124f878f5890020882119182fe44405c104c31100042c1103ec2604b32f21de41bcda2d9f048238dc4b3c6391c54050e24551a24c4182837618a101ca0e2830f8550805e4b2f8d934404baa480a168231c01e21f420092eb05a81c7d9000a40443551fcfa4a34b12c4efa38b07cf8070c1207d10f304053a0b0c483cb4d042c10897e0244505c596c3c130853621634e5245758118992453811fd10bec48919ea4604178174c62ac41e650514737e64fd55301d7c8c4132a34358164616eb378c43fc672011708402226e08628a4e03ff301300751a8400fdab7177108a04832e8c11102b38e4418c4336460443846b1806e48c52c014c000bfc50c08288c3061b00c0040460819c7c6315fe2db301151ce0004638601798a8c5108e618bc3fc621287d05d0d0d720300cc2211164086332e1085cc0d640e7120a2188948867914e205aeb10107a7280123c9600480b9002c12371072e0628c448c8603cc48ac35161010459a441a3cb0131f50a020f6c0e3183b90003f4e5120e64853081ca18b9d58827b0489831189c88545cac2918fcc420e27608753ec040e2c708940b421462e94810c624480215ef7c889e8c00996aa40124e590d818c630ef6d8a4030491894e12110152ab254574c0a14f242209c108061c5ee0cb73a08188e19807229a71cd63724c991341c70da031011604a1139db0c4da7cc94a077061190948c12660e9802f58039c13fe21871f5cf1844300e209bf48862206a20a58bad205d0db023dbf20037c4ec406294803fbfc908614e865236860041910908317e8650eddfc8227d8d695cfd0721cafb351477c99228158883eb2910d2b19610b43ec2d45f3744003a8d915359a23154c0858418440ac19bc2d45b4b4812adc798b5f386220235028191ab04ea388c30e04c00101a6f08f72e0800102c1012574900102684003d880401130440002fcc38be8400317101089aa0ac406726d432a8b259b0a408f20e4980225c801813df4600e57308340aec00773c400078b654039b220843d30201599db883676618b27d08b20f3cc810925c2027d0c016704b1c101a6309320e9e0077c10fec80f0e5004425ce11f3ad8c415c8915b4ac01636e430021786808a34e8ac1c0a0505260d92881cfc031fd1f283457540254d98e100413a071fb0fb0f3e64a0084690430c32200742ac880f9b48851cb88286512863b9050169b824e28f0f18c210322013f458428e139875265fb5110eae808e4d6820061a3840d8b2a00108fc43034618481c6021030e9ac31e09b0c3415cc0837f54c05c0351a30d98c00457698010e8f86ad8f64009716cc2ad3f706b16cada560280d51c46e0842027328234b8e2a906e1815efde1d2d8d88000d8f8472a1a9c053e68200b3d38706eddfa604ad8001b0ca06c59ff1116163c758d3648430f0e620b7fe883a40449081a1bceba5bd9ac59039015470cdcda83b20ae1c4062480116c1010003b48238dc4b3c6391c54050e24551a24c4182837618a101ca0e2830f8550805e4b2f8d934404baa480a168231c01e21f420092eb05a81c7d9000a40443551fcfa4a34b12c4efa38b07cf8070c1207d10f304053a0b0c483cb4d042c10897e0244505c596c3c130853621634e5245758118992453811fd10bec48919ea4604178174c62ac41e650514737e64fd55301d7c8c4132a34358164616eb378c43fc672011708402226e08628a4e03ff301300751a8400fdab7177108a04832e8c11102b38e4418c4336460443846b1806e48c52c014c000bfc50c08288c3061b00c0040460819c7c6315fe2db301151ce0004638601798a8c5108e618bc3fc621287d05d0d0d720300cc2211164086332e1085cc0d640e7120a2188948867914e205aeb10107a7280123c9600480b9002c12371072e0628c448c8603cc48ac35161010459a441a3cb0131f50a020f6c0e3183b90003f4e5120e64853081ca18b9d58827b0489831189c88545cac2918fcc420e27608753ec040e2c708940b421462e94810c624480215ef7c889e8c00996aa40124e590d818c630ef6d8a4030491894e12110152ab254574c0a14f242209c108061c5ee0cb73a08188e19807229a71cd63724c991341c70da031011604a1139db0c4da	\N	t	Y	opuscollege	2012-05-24 16:12:15.672962
\.


--
-- TOC entry 5338 (class 0 OID 0)
-- Dependencies: 385
-- Name: reportpropertyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('reportpropertyseq', 15, true);


--
-- TOC entry 4910 (class 0 OID 127126)
-- Dependencies: 387
-- Data for Name: requestadmissionperiod; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY requestadmissionperiod (startdate, enddate, academicyearid, numberofsubjectstograde, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4912 (class 0 OID 127136)
-- Dependencies: 389
-- Data for Name: requestforchange; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY requestforchange (id, requestinguserid, respondinguserid, rfc, comments, entityid, entitytypecode, rfcstatuscode, expirationdate, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5339 (class 0 OID 0)
-- Dependencies: 388
-- Name: requestforchangeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('requestforchangeseq', 30, true);


--
-- TOC entry 4914 (class 0 OID 127151)
-- Dependencies: 391
-- Data for Name: rfcstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY rfcstatus (id, code, lang, description, writewho, writewhen, active) FROM stdin;
1	1	en    	New	opuscollege	2011-02-22 16:26:34.386311	Y
2	2	en    	Resolved	opuscollege	2011-02-22 16:26:34.386311	Y
3	3	en    	Refused	opuscollege	2011-02-22 16:26:34.386311	Y
\.


--
-- TOC entry 5340 (class 0 OID 0)
-- Dependencies: 390
-- Name: rfcstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('rfcstatusseq', 3, true);


--
-- TOC entry 4916 (class 0 OID 127163)
-- Dependencies: 393
-- Data for Name: rigiditytype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY rigiditytype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
13	1	en    	Y	compulsory	opuscollege	2011-02-15 17:15:14.600271
14	3	en    	Y	elective	opuscollege	2011-02-15 17:15:14.600271
\.


--
-- TOC entry 5341 (class 0 OID 0)
-- Dependencies: 392
-- Name: rigiditytypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('rigiditytypeseq', 14, true);


--
-- TOC entry 4918 (class 0 OID 127175)
-- Dependencies: 395
-- Data for Name: role; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY role (id, lang, active, role, roledescription, writewho, writewhen, level) FROM stdin;
128	en    	Y	admin	functional administrator and registry	opuscollege	2011-08-06 15:36:51.935426	1
131	en    	Y	admin-C	academic affairs office	opuscollege	2011-08-06 15:36:51.935426	3
132	en    	Y	admin-B	branch	opuscollege	2011-08-06 15:36:51.935426	3
130	en    	Y	registry	registry office	opuscollege	2011-08-06 15:36:51.935426	2
129	en    	Y	dvc	deputy vice chancellor	opuscollege	2011-08-06 15:36:51.935426	2
140	en    	Y	audit	internal audit	opuscollege	2011-08-06 15:36:51.935426	2
133	en    	Y	admin-S	head of 1st level unit - dean etc.	opuscollege	2011-08-06 15:36:51.935426	4
139	en    	Y	library	librarian	opuscollege	2011-08-06 15:36:51.935426	4
138	en    	Y	finance	financial officer	opuscollege	2011-08-06 15:36:51.935426	4
141	en    	Y	dos	dean of Students	opuscollege	2011-08-06 15:36:51.935426	4
142	en    	Y	pr	pr / communication	opuscollege	2011-08-06 15:36:51.935426	4
134	en    	Y	admin-D	head of 2nd level unit	opuscollege	2011-08-06 15:36:51.935426	5
135	en    	Y	teacher	lecturer	opuscollege	2011-08-06 15:36:51.935426	6
136	en    	Y	student	student	opuscollege	2011-08-06 15:36:51.935426	7
137	en    	Y	guest	system guest	opuscollege	2011-08-06 15:36:51.935426	8
\.


--
-- TOC entry 5342 (class 0 OID 0)
-- Dependencies: 394
-- Name: roleseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('roleseq', 162, true);


--
-- TOC entry 4920 (class 0 OID 127187)
-- Dependencies: 397
-- Data for Name: sch_bank; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_bank (id, code, name, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5343 (class 0 OID 0)
-- Dependencies: 396
-- Name: sch_bankseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_bankseq', 4, true);


--
-- TOC entry 4922 (class 0 OID 127199)
-- Dependencies: 399
-- Data for Name: sch_complaint; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_complaint (id, complaintdate, reason, complaintstatuscode, scholarshipapplicationid, active, writewho, writewhen, result) FROM stdin;
\.


--
-- TOC entry 5344 (class 0 OID 0)
-- Dependencies: 398
-- Name: sch_complaintseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_complaintseq', 22, true);


--
-- TOC entry 4924 (class 0 OID 127211)
-- Dependencies: 401
-- Data for Name: sch_complaintstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_complaintstatus (id, description, code, lang, active, writewho, writewhen) FROM stdin;
1	resolved	RS	en    	Y	opusscholarship	2008-08-15 17:38:10.590138
2	not resolved	NR	en    	Y	opusscholarship	2008-08-15 17:38:10.590138
3	open	OP	en    	Y	opusscholarship	2008-08-15 17:38:10.590138
\.


--
-- TOC entry 5345 (class 0 OID 0)
-- Dependencies: 400
-- Name: sch_complaintstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_complaintstatusseq', 6, true);


--
-- TOC entry 4926 (class 0 OID 127223)
-- Dependencies: 403
-- Data for Name: sch_decisioncriteria; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_decisioncriteria (id, description, code, lang, active, writewho, writewhen) FROM stdin;
3	A	A	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
4	Art.13	Art.13	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
5	Art.14,3	Art.14,3	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
6	B	B	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
7	C	C	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
8	December	Dez	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
9	E	E	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
10	Exceptional	Excep	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
11	Out of time	Extemp	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
12	F	F	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
13	G	G	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
14	H	H	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
15	I	I	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
16	J	J	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
17	July	Jul	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
18	K	K	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
19	L	L	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
20	L) Exceptional	L) Excep	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
21	M	M	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
22	N	N	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
23	November	Nov	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
24	O	O	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
25	O) Art.14,3	O) Art.14,3	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
26	October	Out	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
27	P	P	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
28	Q	Q	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
29	R	R	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
30	S	S	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
31	September	Set	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
32	T	T	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
33	U	U	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
34	U) Art.13	U) Art.13	en    	Y	opusscholarship	2008-08-20 16:17:29.396375
35	A	A	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
36	Art.13	Art.13	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
37	Art.14,3	Art.14,3	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
38	B	B	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
39	C	C	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
40	Dezembro	Dez	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
42	Excepcional	Excep	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
43	Extempor&atilde;neo	Extemp	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
44	F	F	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
45	G	G	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
46	H	H	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
47	I	I	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
48	J	J	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
49	Julho	Jul	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
50	K	K	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
51	L	L	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
52	L) Excepcional	L) Excep	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
53	M	M	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
54	N	N	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
55	Novembro	Nov	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
56	O	O	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
57	O) Art.14,3	O) Art.14,3	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
58	Outubro	Out	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
59	P	P	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
60	Q	Q	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
61	R	R	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
62	S	S	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
63	Setembro	Set	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
64	T	T	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
65	U	U	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
66	U) Art.13	U) Art.13	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
41	E	E	pt    	Y	opusscholarship	2008-08-20 16:17:29.396375
\.


--
-- TOC entry 5346 (class 0 OID 0)
-- Dependencies: 402
-- Name: sch_decisioncriteriaseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_decisioncriteriaseq', 66, true);


--
-- TOC entry 4928 (class 0 OID 127235)
-- Dependencies: 405
-- Data for Name: sch_scholarship; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_scholarship (id, scholarshiptypecode, sponsorid, active, writewho, writewhen, amount, housingcosts, academicyearid) FROM stdin;
\.


--
-- TOC entry 4930 (class 0 OID 127247)
-- Dependencies: 407
-- Data for Name: sch_scholarshipapplication; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_scholarshipapplication (id, scholarshipstudentid, scholarshipappliedforid, scholarshipgrantedid, decisioncriteriacode, scholarshipamount, observation, validfrom, validuntil, active, writewho, writewhen, studyplanid, feeid) FROM stdin;
\.


--
-- TOC entry 5347 (class 0 OID 0)
-- Dependencies: 406
-- Name: sch_scholarshipapplicationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_scholarshipapplicationseq', 1030, true);


--
-- TOC entry 5348 (class 0 OID 0)
-- Dependencies: 404
-- Name: sch_scholarshipseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_scholarshipseq', 17, true);


--
-- TOC entry 4932 (class 0 OID 127261)
-- Dependencies: 409
-- Data for Name: sch_scholarshiptype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_scholarshiptype (id, description, code, lang, active, writewho, writewhen) FROM stdin;
37	complete scholarship	cs	en    	Y	opusscholarship	2008-08-21 10:54:30.352241
38	housing scholarship	hs	en    	Y	opusscholarship	2008-08-21 10:54:30.352241
39	reduced scholarship	rs	en    	Y	opusscholarship	2008-08-21 10:54:30.352241
40	50% discount	ds	en    	Y	opusscholarship	2008-08-21 10:54:30.352241
41	free of fees	fs	en    	Y	opusscholarship	2008-08-21 10:54:30.352241
42	merit scholarship	ms	en    	Y	opusscholarship	2008-08-21 10:54:30.352241
\.


--
-- TOC entry 5349 (class 0 OID 0)
-- Dependencies: 408
-- Name: sch_scholarshiptypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_scholarshiptypeseq', 48, true);


--
-- TOC entry 4934 (class 0 OID 127273)
-- Dependencies: 411
-- Data for Name: sch_sponsor; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_sponsor (id, code, name, active, writewho, writewhen, sponsortypecode) FROM stdin;
9	GOV	Government	Y	opusscholarship	2011-01-06 11:01:57.171649	
10	PRIV	Private	Y	opusscholarship	2011-01-06 11:01:57.171649	
11	OTH	Other	Y	opusscholarship	2011-01-06 11:01:57.171649	
12	1	GOVERNMENT OF ZAMBIA	Y	opusscholarship	2011-09-29 11:09:15.569071	
13	2	ZAMBIA ARMY	Y	opusscholarship	2011-09-29 11:09:15.569071	
14	3	AA INSTITUTE	Y	opusscholarship	2011-09-29 11:09:15.569071	
15	4	UGANDAN GOVERNMENT	Y	opusscholarship	2011-09-29 11:09:15.569071	
16	5	BARCLAYS BANK	Y	opusscholarship	2011-09-29 11:09:15.569071	
17	6	SIAME ASSOCIATES	Y	opusscholarship	2011-09-29 11:09:15.569071	
18	7	BOTSWANA GOVERNMENT	Y	opusscholarship	2011-09-29 11:09:15.569071	
19	8	MOBILE OIL (z) LTD	Y	opusscholarship	2011-09-29 11:09:15.569071	
20	11	RETIRED STAFF	Y	opusscholarship	2011-09-29 11:09:15.569071	
21	12	UNIVERSITY OF ZAMBIA	Y	opusscholarship	2011-09-29 11:09:15.569071	
22	13	STUDENT	Y	opusscholarship	2011-09-29 11:09:15.569071	
23	14	GUARDIAN	Y	opusscholarship	2011-09-29 11:09:15.569071	
\.


--
-- TOC entry 4936 (class 0 OID 127285)
-- Dependencies: 413
-- Data for Name: sch_sponsorfeepercentage; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_sponsorfeepercentage (id, sponsorcode, feecategorycode, percentage) FROM stdin;
\.


--
-- TOC entry 5350 (class 0 OID 0)
-- Dependencies: 412
-- Name: sch_sponsorfeepercentage_seq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_sponsorfeepercentage_seq', 1, false);


--
-- TOC entry 4938 (class 0 OID 127294)
-- Dependencies: 415
-- Data for Name: sch_sponsorpayment; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_sponsorpayment (id, scholarshipapplicationid, academicyearid, paymentduedate, paymentreceiveddate) FROM stdin;
\.


--
-- TOC entry 5351 (class 0 OID 0)
-- Dependencies: 414
-- Name: sch_sponsorpayment_seq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_sponsorpayment_seq', 9, true);


--
-- TOC entry 5352 (class 0 OID 0)
-- Dependencies: 410
-- Name: sch_sponsorseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_sponsorseq', 23, true);


--
-- TOC entry 4940 (class 0 OID 127300)
-- Dependencies: 417
-- Data for Name: sch_sponsortype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_sponsortype (id, code, title, lang, description, active, writewho, writewhen) FROM stdin;
1	GRZ-S	GRZ sponsorship	en	Government Sponsored Tuition Waiver through Bursaries committee. This covers Tuition only.	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353
2	EX-S	External sponsorsip	en	Sponsorship provided by institutions other than UNZA	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353
3	SDF-S	Staff Development Fellow (SDF)	en	Applicable to members of staff	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353
4	TW-S	Tution Waiver	en	Applicable to members of staff and their dependants	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353
5	STB-S	Staff Terminal Benefits Sponsorship	en	The fees due are deducted from a member of staffs unpaid terminal benefits. Beneficiaries include dependants	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353
6	SLF-S	Self sponsorship	en	The student pays all fees themselves	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353
\.


--
-- TOC entry 5353 (class 0 OID 0)
-- Dependencies: 416
-- Name: sch_sponsortype_seq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_sponsortype_seq', 6, true);


--
-- TOC entry 4942 (class 0 OID 127312)
-- Dependencies: 419
-- Data for Name: sch_student; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_student (scholarshipstudentid, studentid, account, accountactivated, active, writewho, writewhen, bankid) FROM stdin;
\.


--
-- TOC entry 5354 (class 0 OID 0)
-- Dependencies: 418
-- Name: sch_studentseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_studentseq', 20, true);


--
-- TOC entry 4944 (class 0 OID 127326)
-- Dependencies: 421
-- Data for Name: sch_subsidy; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_subsidy (id, scholarshipstudentid, subsidytypecode, sponsorid, amount, subsidydate, observation, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5355 (class 0 OID 0)
-- Dependencies: 420
-- Name: sch_subsidyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_subsidyseq', 9, true);


--
-- TOC entry 4946 (class 0 OID 127338)
-- Dependencies: 423
-- Data for Name: sch_subsidytype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_subsidytype (id, description, code, lang, active, writewho, writewhen) FROM stdin;
1	Material	mat	en    	Y	opusscholarship	2008-08-21 10:54:37.762649
2	Thesis (Bank)	tesB	en    	Y	opusscholarship	2008-08-21 10:54:37.762649
3	Thesis (Signature)	tesA	en    	Y	opusscholarship	2008-08-21 10:54:37.762649
4	Thesis (Final)	tesF	en    	Y	opusscholarship	2008-08-21 10:54:37.762649
\.


--
-- TOC entry 5356 (class 0 OID 0)
-- Dependencies: 422
-- Name: sch_subsidytypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_subsidytypeseq', 8, true);


--
-- TOC entry 4948 (class 0 OID 127350)
-- Dependencies: 425
-- Data for Name: secondaryschoolsubject; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY secondaryschoolsubject (id, code, active, description, writewho, writewhen) FROM stdin;
1	001	Y	English Language	opuscollege	2011-07-11 15:33:35.309638
2	002	Y	Literature in English	opuscollege	2011-07-11 15:33:35.309638
3	101	Y	Mathematics	opuscollege	2011-07-11 15:33:35.309638
4	102	Y	Additional Mathematics	opuscollege	2011-07-11 15:33:35.309638
5	201	Y	Chemistry	opuscollege	2011-07-11 15:33:35.309638
6	202	Y	Physics	opuscollege	2011-07-11 15:33:35.309638
7	203	Y	Physical Science	opuscollege	2011-07-11 15:33:35.309638
8	204	Y	Engineering science	opuscollege	2011-07-11 15:33:35.309638
9	205	Y	Agricultural science	opuscollege	2011-07-11 15:33:35.309638
10	207	Y	Biology	opuscollege	2011-07-11 15:33:35.309638
11	211	Y	Science	opuscollege	2011-07-11 15:33:35.309638
12	301	Y	General Science	opuscollege	2011-07-11 15:33:35.309638
13	304	Y	Commerce	opuscollege	2011-07-11 15:33:35.309638
14	307	Y	Food and nutrition	opuscollege	2011-07-11 15:33:35.309638
15	308	Y	History	opuscollege	2011-07-11 15:33:35.309638
16	311	Y	Geography	opuscollege	2011-07-11 15:33:35.309638
17	312	Y	Metal work	opuscollege	2011-07-11 15:33:35.309638
18	314	Y	Geometrical and mechanical drawing	opuscollege	2011-07-11 15:33:35.309638
19	315	Y	Geometrical and building drawing	opuscollege	2011-07-11 15:33:35.309638
20	320	Y	Bible Knowledge / Religious Education	opuscollege	2011-07-11 15:33:35.309638
21	321	Y	Principles of Accounts	opuscollege	2011-07-11 15:33:35.309638
22	410	Y	Language other than English	opuscollege	2011-07-11 15:33:35.309638
23	415	Y	Other subjects	opuscollege	2011-07-11 15:33:35.309638
24	418	Y	Computer science	opuscollege	2011-07-11 15:33:35.309638
25	419	Y	Combined science	opuscollege	2011-07-11 15:33:35.309638
26	420	Y	Human and social biology	opuscollege	2011-07-11 15:33:35.309638
27	421	Y	Wood Work	opuscollege	2011-07-11 15:33:35.309638
28	422	Y	Art	opuscollege	2011-07-11 15:33:35.309638
29	423	Y	Zambian language	opuscollege	2011-07-11 15:33:35.309638
30	424	Y	Economics	opuscollege	2011-07-11 15:33:35.309638
31	425	Y	Botany	opuscollege	2011-07-11 15:33:35.309638
\.


--
-- TOC entry 4950 (class 0 OID 127362)
-- Dependencies: 427
-- Data for Name: secondaryschoolsubjectgroup; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY secondaryschoolsubjectgroup (id, groupnumber, minimumnumbertograde, maximumnumbertograde, studygradetypeid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5357 (class 0 OID 0)
-- Dependencies: 426
-- Name: secondaryschoolsubjectgroupseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('secondaryschoolsubjectgroupseq', 92, true);


--
-- TOC entry 5358 (class 0 OID 0)
-- Dependencies: 424
-- Name: secondaryschoolsubjectseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('secondaryschoolsubjectseq', 31, true);


--
-- TOC entry 4952 (class 0 OID 127374)
-- Dependencies: 429
-- Data for Name: staffmember; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY staffmember (staffmemberid, staffmembercode, personid, dateofappointment, appointmenttypecode, stafftypecode, primaryunitofappointmentid, educationtypecode, writewho, writewhen, startworkday, endworkday, teachingdaypartcode, supervisingdaypartcode) FROM stdin;
101	STA6417052011141947	242	2008-01-01	1	1	94	3	opuscollege	2011-05-17 14:20:49.113706	00:00:00	00:00:00	0	0
72	STA022022011112253<script>alert("Hmm");</script>	183	\N	1	1	94	3	registry:174	2011-02-22 11:24:02.20943	00:00:00	00:00:00	0	0
\.


--
-- TOC entry 4953 (class 0 OID 127385)
-- Dependencies: 430
-- Data for Name: staffmemberfunction; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY staffmemberfunction (staffmemberid, functioncode, functionlevelcode, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5359 (class 0 OID 0)
-- Dependencies: 428
-- Name: staffmemberseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('staffmemberseq', 170, true);


--
-- TOC entry 4955 (class 0 OID 127396)
-- Dependencies: 432
-- Data for Name: stafftype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY stafftype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
9	1	en    	Y	Academic	opuscollege	2010-11-02 16:22:58.674788
13	1337677170524	en    	Y	stafftype zm	opuscollege	2012-05-22 10:59:49.222194
14	1337677170524	en_ZM 	Y	stafftype zm	opuscollege	2012-05-22 10:59:49.225253
15	1337677214493	en    	Y	stafftype in en	opuscollege	2012-05-22 11:00:33.193185
16	1337677214493	en_ZM 	Y	stafftype in en	opuscollege	2012-05-22 11:00:33.195787
11	1337676858993	en    	Y	Academic zm in en	opuscollege	2012-05-22 10:54:37.691599
12	1337676858993	en_ZM 	Y	Academic zm4	opuscollege	2012-05-22 10:54:37.788918
10	2,2	en    	Y	Non-academic zm	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5360 (class 0 OID 0)
-- Dependencies: 431
-- Name: stafftypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('stafftypeseq', 16, true);


--
-- TOC entry 4957 (class 0 OID 127408)
-- Dependencies: 434
-- Data for Name: status; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY status (id, code, lang, active, description, writewho, writewhen) FROM stdin;
75	1	en    	Y	active	opuscollege	2011-02-16 15:20:33.4205
76	2	en    	Y	temporary inactive	opuscollege	2011-02-16 15:20:33.4205
77	3	en    	Y	excluded	opuscollege	2011-02-16 15:20:33.4205
78	4	en    	Y	suspended	opuscollege	2011-02-16 15:20:33.4205
79	5	en    	Y	expelled	opuscollege	2011-02-16 15:20:33.4205
80	6	en    	Y	deceased	opuscollege	2011-02-16 15:20:33.4205
\.


--
-- TOC entry 5361 (class 0 OID 0)
-- Dependencies: 433
-- Name: statusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('statusseq', 80, true);


--
-- TOC entry 4959 (class 0 OID 127420)
-- Dependencies: 436
-- Data for Name: student; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY student (studentid, studentcode, personid, dateofenrolment, primarystudyid, statuscode, expellationdate, reasonforexpellation, previousinstitutionid, previousinstitutionname, previousinstitutiondistrictcode, previousinstitutionprovincecode, previousinstitutioncountrycode, previousinstitutioneducationtypecode, previousinstitutionfinalgradetypecode, previousinstitutionfinalmark, previousinstitutiondiplomaphotograph, scholarship, fatherfullname, fathereducationcode, fatherprofessioncode, fatherprofessiondescription, motherfullname, mothereducationcode, motherprofessioncode, motherprofessiondescription, financialguardianfullname, financialguardianrelation, financialguardianprofession, writewho, writewhen, expellationenddate, expellationtypecode, previousinstitutiondiplomaphotographremarks, previousinstitutiondiplomaphotographname, previousinstitutiondiplomaphotographmimetype, subscriptionrequirementsfulfilled, secondarystudyid, foreignstudent, nationalitygroupcode, fathertelephone, mothertelephone, relativeofstaffmember, ruralareaorigin, employeenumberofrelative) FROM stdin;
\.


--
-- TOC entry 4961 (class 0 OID 127443)
-- Dependencies: 438
-- Data for Name: studentabsence; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentabsence (id, studentid, startdatetemporaryinactivity, enddatetemporaryinactivity, reasonforabsence, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5362 (class 0 OID 0)
-- Dependencies: 437
-- Name: studentabsenceseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentabsenceseq', 14, true);


--
-- TOC entry 4963 (class 0 OID 127454)
-- Dependencies: 440
-- Data for Name: studentactivity; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentactivity (id, studentid, description) FROM stdin;
\.


--
-- TOC entry 5363 (class 0 OID 0)
-- Dependencies: 439
-- Name: studentactivityseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentactivityseq', 14, true);


--
-- TOC entry 4965 (class 0 OID 127463)
-- Dependencies: 442
-- Data for Name: studentbalance; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentbalance (id, studentid, feeid, studyplancardinaltimeunitid, studyplandetailid, academicyearid, exemption, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5364 (class 0 OID 0)
-- Dependencies: 441
-- Name: studentbalance_seq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentbalance_seq', 116, true);


--
-- TOC entry 4967 (class 0 OID 127480)
-- Dependencies: 444
-- Data for Name: studentcareer; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentcareer (id, studentid, description) FROM stdin;
\.


--
-- TOC entry 5365 (class 0 OID 0)
-- Dependencies: 443
-- Name: studentcareerseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentcareerseq', 9, true);


--
-- TOC entry 4969 (class 0 OID 127489)
-- Dependencies: 446
-- Data for Name: studentclassgroup; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentclassgroup (id, studentid, classgroupid, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5366 (class 0 OID 0)
-- Dependencies: 445
-- Name: studentclassgroupseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentclassgroupseq', 1, false);


--
-- TOC entry 4971 (class 0 OID 127500)
-- Dependencies: 448
-- Data for Name: studentcounseling; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentcounseling (id, studentid, description) FROM stdin;
\.


--
-- TOC entry 5367 (class 0 OID 0)
-- Dependencies: 447
-- Name: studentcounselingseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentcounselingseq', 4, true);


--
-- TOC entry 4973 (class 0 OID 127509)
-- Dependencies: 450
-- Data for Name: studentexpulsion; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentexpulsion (id, studentid, startdate, enddate, expulsiontypecode, reasonforexpulsion, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5368 (class 0 OID 0)
-- Dependencies: 449
-- Name: studentexpulsionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentexpulsionseq', 11, true);


--
-- TOC entry 4975 (class 0 OID 127520)
-- Dependencies: 452
-- Data for Name: studentplacement; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentplacement (id, studentid, description) FROM stdin;
\.


--
-- TOC entry 5369 (class 0 OID 0)
-- Dependencies: 451
-- Name: studentplacementseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentplacementseq', 7, true);


--
-- TOC entry 5370 (class 0 OID 0)
-- Dependencies: 435
-- Name: studentseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentseq', 314, true);


--
-- TOC entry 4977 (class 0 OID 127529)
-- Dependencies: 454
-- Data for Name: studentstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentstatus (id, code, lang, active, description, writewho, writewhen) FROM stdin;
7	1	en    	Y	active	opuscollege	2011-06-14 16:54:51.91068
8	5	en    	Y	deceased	opuscollege	2011-06-14 16:54:51.91068
9	101	en    	Y	expelled	opuscollege	2011-06-14 16:54:51.91068
10	102	en    	Y	suspended	opuscollege	2011-06-14 16:54:51.91068
\.


--
-- TOC entry 5371 (class 0 OID 0)
-- Dependencies: 453
-- Name: studentstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentstatusseq', 10, true);


--
-- TOC entry 4979 (class 0 OID 127541)
-- Dependencies: 456
-- Data for Name: studentstudentstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentstudentstatus (id, studentid, startdate, studentstatuscode, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5372 (class 0 OID 0)
-- Dependencies: 455
-- Name: studentstudentstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentstudentstatusseq', 243, true);


--
-- TOC entry 4981 (class 0 OID 127552)
-- Dependencies: 458
-- Data for Name: study; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY study (id, studydescription, active, organizationalunitid, academicfieldcode, dateofestablishment, startdate, registrationdate, writewho, writewhen, minimummarksubject, maximummarksubject, brspassingsubject) FROM stdin;
\.


--
-- TOC entry 4983 (class 0 OID 127565)
-- Dependencies: 460
-- Data for Name: studyform; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyform (id, code, lang, active, description, writewho, writewhen) FROM stdin;
15	1317302927520	en_ZM 	Y	regular programme alternative	opuscollege	2011-09-29 15:28:50.118965
19	1	en    	Y	Regular learning	opuscollege	2012-10-02 18:31:34.489
20	2	en    	Y	Parallel programme	opuscollege	2012-10-02 18:31:34.489
21	3	en    	Y	Distant learning	opuscollege	2012-10-02 18:31:34.489
\.


--
-- TOC entry 5373 (class 0 OID 0)
-- Dependencies: 459
-- Name: studyformseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyformseq', 21, true);


--
-- TOC entry 4985 (class 0 OID 127577)
-- Dependencies: 462
-- Data for Name: studygradetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studygradetype (id, studyid, gradetypecode, active, contactid, registrationdate, writewho, writewhen, currentacademicyearid, cardinaltimeunitcode, numberofcardinaltimeunits, maxnumberofcardinaltimeunits, numberofsubjectspercardinaltimeunit, maxnumberofsubjectspercardinaltimeunit, studytimecode, brspassingsubject, studyformcode, maxnumberoffailedsubjectspercardinaltimeunit, studyintensitycode, maxnumberofstudents, disciplinegroupcode) FROM stdin;
\.


--
-- TOC entry 4986 (class 0 OID 127598)
-- Dependencies: 463
-- Data for Name: studygradetypeprerequisite; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studygradetypeprerequisite (studygradetypeid, active, writewho, writewhen, requiredstudyid, requiredgradetypecode) FROM stdin;
\.


--
-- TOC entry 5374 (class 0 OID 0)
-- Dependencies: 461
-- Name: studygradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studygradetypeseq', 249, true);


--
-- TOC entry 4988 (class 0 OID 127609)
-- Dependencies: 465
-- Data for Name: studyintensity; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyintensity (id, code, lang, active, description, writewho, writewhen) FROM stdin;
4	F	en	Y	fulltime	opuscollege	2012-10-02 18:31:34.489
5	P	en	Y	parttime	opuscollege	2012-10-02 18:31:34.489
\.


--
-- TOC entry 5375 (class 0 OID 0)
-- Dependencies: 464
-- Name: studyintensityseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyintensityseq', 5, true);


--
-- TOC entry 4990 (class 0 OID 127621)
-- Dependencies: 467
-- Data for Name: studyplan; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyplan (id, studentid, studyplandescription, active, writewho, writewhen, brspassingexam, studyplanstatuscode, studyid, gradetypecode, minor1id, major2id, minor2id, applicationnumber, applicantcategorycode, firstchoiceonwardstudyid, firstchoiceonwardgradetypecode, secondchoiceonwardstudyid, secondchoiceonwardgradetypecode, thirdchoiceonwardstudyid, thirdchoiceonwardgradetypecode, previousdisciplinecode, previousdisciplinegrade) FROM stdin;
\.


--
-- TOC entry 4992 (class 0 OID 127641)
-- Dependencies: 469
-- Data for Name: studyplancardinaltimeunit; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyplancardinaltimeunit (id, studyplanid, cardinaltimeunitnumber, progressstatuscode, active, writewho, writewhen, studygradetypeid, cardinaltimeunitstatuscode, tuitionwaiver, studyintensitycode) FROM stdin;
\.


--
-- TOC entry 5376 (class 0 OID 0)
-- Dependencies: 468
-- Name: studyplancardinaltimeunitseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyplancardinaltimeunitseq', 410, true);


--
-- TOC entry 4994 (class 0 OID 127656)
-- Dependencies: 471
-- Data for Name: studyplandetail; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyplandetail (id, studyplanid, subjectid, subjectblockid, active, writewho, writewhen, studyplancardinaltimeunitid, studygradetypeid) FROM stdin;
\.


--
-- TOC entry 5377 (class 0 OID 0)
-- Dependencies: 470
-- Name: studyplandetailseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyplandetailseq', 1007, true);


--
-- TOC entry 4995 (class 0 OID 127670)
-- Dependencies: 472
-- Data for Name: studyplanresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyplanresult (id, studyplanid, examdate, finalmark, mark, active, writewho, writewhen, passed) FROM stdin;
\.


--
-- TOC entry 5378 (class 0 OID 0)
-- Dependencies: 466
-- Name: studyplanseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyplanseq', 252, true);


--
-- TOC entry 4997 (class 0 OID 127684)
-- Dependencies: 474
-- Data for Name: studyplanstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyplanstatus (id, code, lang, active, description, writewho, writewhen) FROM stdin;
132	1	en    	Y	Waiting for payment	opuscollege	2011-12-22 13:05:52.569496
133	2	en    	Y	Waiting for selection	opuscollege	2011-12-22 13:05:52.569496
134	3	en    	Y	Approved admission	opuscollege	2011-12-22 13:05:52.569496
135	4	en    	Y	Rejected admission	opuscollege	2011-12-22 13:05:52.569496
136	10	en    	Y	Temporarily inactive	opuscollege	2011-12-22 13:05:52.569496
137	11	en    	Y	Graduated	opuscollege	2011-12-22 13:05:52.569496
138	12	en    	Y	Withdrawn	opuscollege	2011-12-22 13:05:52.569496
\.


--
-- TOC entry 5379 (class 0 OID 0)
-- Dependencies: 473
-- Name: studyplanstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyplanstatusseq', 138, true);


--
-- TOC entry 5380 (class 0 OID 0)
-- Dependencies: 457
-- Name: studyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyseq', 1209, true);


--
-- TOC entry 4999 (class 0 OID 127696)
-- Dependencies: 476
-- Data for Name: studytime; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studytime (id, code, lang, active, description, writewho, writewhen) FROM stdin;
21	1	en    	Y	Daytime	opuscollege	2012-04-24 15:12:49.734024
22	2	en    	Y	Evening	opuscollege	2012-04-24 15:12:49.734024
\.


--
-- TOC entry 5381 (class 0 OID 0)
-- Dependencies: 475
-- Name: studytimeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studytimeseq', 22, true);


--
-- TOC entry 5001 (class 0 OID 127708)
-- Dependencies: 478
-- Data for Name: studytype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studytype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
64	1	en    	Y	lecture	opuscollege	2011-03-15 17:17:12.177
65	2	en    	Y	workshop	opuscollege	2011-03-15 17:17:12.177
66	3	en    	Y	experiment	opuscollege	2011-03-15 17:17:12.177
67	4	en    	Y	self study	opuscollege	2011-03-15 17:17:12.177
68	5	en    	Y	paper	opuscollege	2011-03-15 17:17:12.177
69	6	en    	Y	e-learning	opuscollege	2011-03-15 17:17:12.177
70	7	en    	Y	group work	opuscollege	2011-03-15 17:17:12.177
71	8	en    	Y	individual assistance by lecturer	opuscollege	2011-03-15 17:17:12.177
72	9	en    	Y	literature	opuscollege	2011-03-15 17:17:12.177
73	10	en    	Y	lab/practical	opuscollege	2011-03-15 17:17:12.177
74	11	en    	Y	project	opuscollege	2011-03-15 17:17:12.177
75	12	en    	Y	seminar	opuscollege	2011-03-15 17:17:12.177
\.


--
-- TOC entry 5382 (class 0 OID 0)
-- Dependencies: 477
-- Name: studytypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studytypeseq', 75, true);


--
-- TOC entry 5003 (class 0 OID 127720)
-- Dependencies: 480
-- Data for Name: subject; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subject (id, subjectcode, subjectdescription, subjectcontentdescription, primarystudyid, active, targetgroupcode, freechoiceoption, creditamount, hourstoinvest, frequencycode, studytimecode, examtypecode, maximumparticipants, brspassingsubject, registrationdate, writewho, writewhen, currentacademicyearid, resulttype) FROM stdin;
\.


--
-- TOC entry 5005 (class 0 OID 127736)
-- Dependencies: 482
-- Data for Name: subjectblock; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectblock (id, subjectblockcode, subjectblockdescription, active, targetgroupcode, brsapplyingtosubjectblock, registrationdate, writewho, writewhen, brspassingsubjectblock, currentacademicyearid, brsmaxcontacthours, studytimecode, blocktypecode, primarystudyid, freechoiceoption) FROM stdin;
\.


--
-- TOC entry 5006 (class 0 OID 127750)
-- Dependencies: 483
-- Data for Name: subjectblockprerequisite; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectblockprerequisite (subjectblockstudygradetypeid, active, writewho, writewhen, requiredsubjectblockcode) FROM stdin;
\.


--
-- TOC entry 5383 (class 0 OID 0)
-- Dependencies: 481
-- Name: subjectblockseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectblockseq', 131, true);


--
-- TOC entry 5008 (class 0 OID 127761)
-- Dependencies: 485
-- Data for Name: subjectblockstudygradetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectblockstudygradetype (id, subjectblockid, studygradetypeid, cardinaltimeunitnumber, rigiditytypecode, active, writewho, writewhen, importancetypecode) FROM stdin;
\.


--
-- TOC entry 5384 (class 0 OID 0)
-- Dependencies: 484
-- Name: subjectblockstudygradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectblockstudygradetypeseq', 136, true);


--
-- TOC entry 5010 (class 0 OID 127774)
-- Dependencies: 487
-- Data for Name: subjectclassgroup; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectclassgroup (id, subjectid, classgroupid, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5385 (class 0 OID 0)
-- Dependencies: 486
-- Name: subjectclassgroupseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectclassgroupseq', 1, false);


--
-- TOC entry 5386 (class 0 OID 0)
-- Dependencies: 337
-- Name: subjectimportanceseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectimportanceseq', 6, true);


--
-- TOC entry 5011 (class 0 OID 127783)
-- Dependencies: 488
-- Data for Name: subjectprerequisite; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectprerequisite (subjectstudygradetypeid, active, writewho, writewhen, requiredsubjectcode) FROM stdin;
\.


--
-- TOC entry 5013 (class 0 OID 127794)
-- Dependencies: 490
-- Data for Name: subjectresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectresult (id, subjectid, studyplandetailid, subjectresultdate, mark, staffmemberid, active, writewho, writewhen, passed, endgradecomment) FROM stdin;
\.


--
-- TOC entry 5387 (class 0 OID 0)
-- Dependencies: 489
-- Name: subjectresultseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectresultseq', 236, true);


--
-- TOC entry 5388 (class 0 OID 0)
-- Dependencies: 479
-- Name: subjectseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectseq', 1665, true);


--
-- TOC entry 5015 (class 0 OID 127807)
-- Dependencies: 492
-- Data for Name: subjectstudygradetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectstudygradetype (id, subjectid, studygradetypeid, active, writewho, writewhen, cardinaltimeunitnumber, rigiditytypecode, importancetypecode) FROM stdin;
\.


--
-- TOC entry 5389 (class 0 OID 0)
-- Dependencies: 491
-- Name: subjectstudygradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectstudygradetypeseq', 2075, true);


--
-- TOC entry 5017 (class 0 OID 127820)
-- Dependencies: 494
-- Data for Name: subjectstudytype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectstudytype (id, subjectid, studytypecode, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5390 (class 0 OID 0)
-- Dependencies: 493
-- Name: subjectstudytypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectstudytypeseq', 122, true);


--
-- TOC entry 5019 (class 0 OID 127832)
-- Dependencies: 496
-- Data for Name: subjectsubjectblock; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectsubjectblock (id, subjectid, subjectblockid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5391 (class 0 OID 0)
-- Dependencies: 495
-- Name: subjectsubjectblockseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectsubjectblockseq', 193, true);


--
-- TOC entry 5021 (class 0 OID 127844)
-- Dependencies: 498
-- Data for Name: subjectteacher; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectteacher (id, staffmemberid, subjectid, active, writewho, writewhen, classgroupid) FROM stdin;
\.


--
-- TOC entry 5392 (class 0 OID 0)
-- Dependencies: 497
-- Name: subjectteacherseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectteacherseq', 394, true);


--
-- TOC entry 5023 (class 0 OID 127856)
-- Dependencies: 500
-- Data for Name: tabledependency; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY tabledependency (id, lookuptableid, dependenttable, dependenttablecolumn, active, writewho, writewhen) FROM stdin;
1	1	organizationalUnit	academicFieldCode	Y	opuscollege	2009-02-05 16:49:32.224762
2	1	study	academicFieldCode	Y	opuscollege	2009-02-05 16:49:32.224762
5	3	address	addressTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
8	5	staffMember	appointmentTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
9	7	person	bloodTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
10	8	person	civilStatusCode	Y	opuscollege	2009-02-05 16:49:32.224762
11	9	person	civilTitleCode	Y	opuscollege	2009-02-05 16:49:32.224762
12	10	contract	contractDurationCode	Y	opuscollege	2009-02-05 16:49:32.224762
13	11	contract	contractTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
14	12	province	countryCode	Y	opuscollege	2009-02-05 16:49:32.224762
15	12	person	countryOfOriginCode	Y	opuscollege	2009-02-05 16:49:32.224762
16	12	person	countryOfBirthCode	Y	opuscollege	2009-02-05 16:49:32.224762
17	12	address	countryCode	Y	opuscollege	2009-02-05 16:49:32.224762
18	12	student	previousInstitutionCountryCode	Y	opuscollege	2009-02-05 16:49:32.224762
19	13	administrativePost	districtCode	Y	opuscollege	2009-02-05 16:49:32.224762
20	13	person	districtOfBirthCode	Y	opuscollege	2009-02-05 16:49:32.224762
21	13	person	districtOfOriginCode	Y	opuscollege	2009-02-05 16:49:32.224762
22	14	institution	educationTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
23	14	staffMember	educationTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
24	14	student	previousInstitutionEducationTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
25	15	examination	examinationTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
26	15	test	examinationTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
27	16	subject	examTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
28	17	student	expellationTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
29	19	subject	frequencyCode	Y	opuscollege	2009-02-05 16:49:32.224762
30	20	staffMemberFunction	functionCode	Y	opuscollege	2009-02-05 16:49:32.224762
31	21	staffMemberFunction	functionLevelCode	Y	opuscollege	2009-02-05 16:49:32.224762
32	22	person	genderCode	Y	opuscollege	2009-02-05 16:49:32.224762
33	23	person	gradeTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
34	23	student	previousInstitutionFinalGradeTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
35	23	studyGradeType	gradeTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
36	24	person	identificationTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
37	25	person	languageFirstCode	Y	opuscollege	2009-02-05 16:49:32.224762
38	25	person	languageSecondCode	Y	opuscollege	2009-02-05 16:49:32.224762
39	25	person	languageThirdCode	Y	opuscollege	2009-02-05 16:49:32.224762
40	28	person	languageFirstMasteringLevelCode	Y	opuscollege	2009-02-05 16:49:32.224762
41	28	person	languageSecondMasteringLevelCode	Y	opuscollege	2009-02-05 16:49:32.224762
42	28	person	languageThirdMasteringLevelCode	Y	opuscollege	2009-02-05 16:49:32.224762
43	29	person	nationalityCode	Y	opuscollege	2009-02-05 16:49:32.224762
44	30	person	professionCode	Y	opuscollege	2009-02-05 16:49:32.224762
45	30	student	fatherProfessionCode	Y	opuscollege	2009-02-05 16:49:32.224762
46	30	student	motherProfessionCode	Y	opuscollege	2009-02-05 16:49:32.224762
47	31	district	provinceCode	Y	opuscollege	2009-02-05 16:49:32.224762
48	31	person	provinceOfBirthCode	Y	opuscollege	2009-02-05 16:49:32.224762
49	31	person	provinceOfOriginCode	Y	opuscollege	2009-02-05 16:49:32.224762
50	31	institution	provinceCode	Y	opuscollege	2009-02-05 16:49:32.224762
51	31	student	previousInstitutionProvinceCode	Y	opuscollege	2009-02-05 16:49:32.224762
52	31	address	provinceCode	Y	opuscollege	2009-02-05 16:49:32.224762
53	33	subject	rigidityTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
54	34	staffMember	staffTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
55	35	student	statusCode	Y	opuscollege	2009-02-05 16:49:32.224762
57	36	subject	studyFormCode	Y	opuscollege	2009-02-05 16:49:32.224762
59	37	subject	studyTimeCode	Y	opuscollege	2009-02-05 16:49:32.224762
60	38	subjectStudyType	studyTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
61	39	subject	subjectImportanceCode	Y	opuscollege	2009-02-05 16:49:32.224762
63	40	subject	targetGroupCode	Y	opuscollege	2009-02-05 16:49:32.224762
64	40	subjectBlock	targetGroupCode	Y	opuscollege	2009-02-05 16:49:32.224762
68	42	organizationalUnit	unitAreaCode	Y	opuscollege	2009-02-05 16:49:32.224762
69	43	organizationalUnit	unitTypeCode	Y	opuscollege	2009-02-05 16:49:32.224762
70	44	sch_complaint	complaintstatuscode	Y	opuscollege	2009-02-06 13:56:29.988612
72	46	sch_scholarshipTypeYear	scholarshiptypecode	Y	opuscollege	2009-02-06 13:56:29.988612
73	47	sch_subsidyType	subsidytypecode	Y	opuscollege	2009-02-06 13:56:29.988612
71	45	sch_decisionCriteria	decisioncriteriacode	Y	opuscollege	2009-02-06 13:56:29.988612
78	53	fee_feeCategory	categoryCode	Y	opuscollege	2010-08-10 11:53:46.612314
79	77	acc_room	roomTypeCode	Y	opuscollege	2012-10-02 18:31:34.489
80	78	acc_hostel	hostelTypeCode	Y	opuscollege	2012-10-02 18:31:34.489
\.


--
-- TOC entry 5393 (class 0 OID 0)
-- Dependencies: 499
-- Name: tabledependencyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('tabledependencyseq', 80, true);


--
-- TOC entry 5025 (class 0 OID 127868)
-- Dependencies: 502
-- Data for Name: targetgroup; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY targetgroup (id, code, lang, active, description, writewho, writewhen) FROM stdin;
13	1	en    	Y	all students	opuscollege	2010-11-02 16:22:58.674788
14	2	en    	Y	students from study	opuscollege	2010-11-02 16:22:58.674788
15	3	en    	Y	all international students	opuscollege	2010-11-02 16:22:58.674788
16	4	en    	Y	all national students	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5394 (class 0 OID 0)
-- Dependencies: 501
-- Name: targetgroupseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('targetgroupseq', 16, true);


--
-- TOC entry 5027 (class 0 OID 127880)
-- Dependencies: 504
-- Data for Name: test; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY test (id, testcode, testdescription, examinationid, examinationtypecode, numberofattempts, weighingfactor, minimummark, maximummark, brspassingtest, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5029 (class 0 OID 127892)
-- Dependencies: 506
-- Data for Name: testresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY testresult (id, testid, examinationid, studyplandetailid, testresultdate, attemptnr, mark, passed, staffmemberid, active, writewho, writewhen, examinationresultid) FROM stdin;
\.


--
-- TOC entry 5395 (class 0 OID 0)
-- Dependencies: 505
-- Name: testresultseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('testresultseq', 74, true);


--
-- TOC entry 5396 (class 0 OID 0)
-- Dependencies: 503
-- Name: testseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('testseq', 94, true);


--
-- TOC entry 5031 (class 0 OID 127906)
-- Dependencies: 508
-- Data for Name: testteacher; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY testteacher (id, staffmemberid, testid, active, writewho, writewhen, classgroupid) FROM stdin;
\.


--
-- TOC entry 5397 (class 0 OID 0)
-- Dependencies: 507
-- Name: testteacherseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('testteacherseq', 103, true);


--
-- TOC entry 5033 (class 0 OID 127918)
-- Dependencies: 510
-- Data for Name: thesis; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY thesis (id, thesiscode, thesisdescription, thesiscontentdescription, studyplanid, creditamount, hourstoinvest, brsapplyingtothesis, brspassingthesis, keywords, researchers, supervisors, publications, readingcommittee, defensecommittee, statusofclearness, thesisstatusdate, startacademicyearid, affiliationfee, research, nonrelatedpublications, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5035 (class 0 OID 127933)
-- Dependencies: 512
-- Data for Name: thesisresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY thesisresult (id, studyplanid, thesisresultdate, mark, active, passed, writewho, writewhen, thesisid) FROM stdin;
\.


--
-- TOC entry 5398 (class 0 OID 0)
-- Dependencies: 511
-- Name: thesisresultseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('thesisresultseq', 3, true);


--
-- TOC entry 5399 (class 0 OID 0)
-- Dependencies: 509
-- Name: thesisseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('thesisseq', 52, true);


--
-- TOC entry 5037 (class 0 OID 127948)
-- Dependencies: 514
-- Data for Name: thesisstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY thesisstatus (id, code, lang, active, description, writewho, writewhen) FROM stdin;
1	1	en    	Y	admission requested	opuscollege	2010-08-24 15:14:52.551731
2	2	en    	Y	proposal cleared	opuscollege	2010-08-24 15:14:52.551731
3	3	en    	Y	thesis accepted	opuscollege	2010-08-24 15:14:52.551731
\.


--
-- TOC entry 5400 (class 0 OID 0)
-- Dependencies: 513
-- Name: thesisstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('thesisstatusseq', 12, true);


--
-- TOC entry 5039 (class 0 OID 127960)
-- Dependencies: 516
-- Data for Name: thesissupervisor; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY thesissupervisor (id, thesisid, name, address, telephone, email, principal, orderby, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5401 (class 0 OID 0)
-- Dependencies: 515
-- Name: thesissupervisorseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('thesissupervisorseq', 23, true);


--
-- TOC entry 5041 (class 0 OID 127973)
-- Dependencies: 518
-- Data for Name: thesisthesisstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY thesisthesisstatus (id, thesisid, startdate, thesisstatuscode, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 5402 (class 0 OID 0)
-- Dependencies: 517
-- Name: thesisthesisstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('thesisthesisstatusseq', 3, true);


--
-- TOC entry 5403 (class 0 OID 0)
-- Dependencies: 519
-- Name: timeunitseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('timeunitseq', 83, true);


--
-- TOC entry 5044 (class 0 OID 127987)
-- Dependencies: 521
-- Data for Name: unitarea; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY unitarea (id, code, lang, active, description, writewho, writewhen) FROM stdin;
5	1	en    	Y	Academic	opuscollege	2010-11-02 16:22:58.674788
6	2	en    	Y	Administrative	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 5404 (class 0 OID 0)
-- Dependencies: 520
-- Name: unitareaseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('unitareaseq', 6, true);


--
-- TOC entry 5046 (class 0 OID 127999)
-- Dependencies: 523
-- Data for Name: unittype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY unittype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
68	2	en    	Y	Department	opuscollege	2011-08-06 10:59:40.133887
69	3	en    	Y	Administration	opuscollege	2011-08-06 10:59:40.133887
70	4	en    	Y	Section	opuscollege	2011-08-06 10:59:40.133887
71	5	en    	Y	Direction	opuscollege	2011-08-06 10:59:40.133887
72	6	en    	Y	Secretariat	opuscollege	2011-08-06 10:59:40.133887
73	7	en    	Y	Institute	opuscollege	2011-08-06 10:59:40.133887
\.


--
-- TOC entry 5405 (class 0 OID 0)
-- Dependencies: 522
-- Name: unittypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('unittypeseq', 73, true);


--
-- TOC entry 4099 (class 2606 OID 128024)
-- Name: academicfield_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY academicfield
    ADD CONSTRAINT academicfield_id_key UNIQUE (id);


--
-- TOC entry 4101 (class 2606 OID 128026)
-- Name: academicfield_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY academicfield
    ADD CONSTRAINT academicfield_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4103 (class 2606 OID 128028)
-- Name: academicyear_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY academicyear
    ADD CONSTRAINT academicyear_pkey PRIMARY KEY (id);


--
-- TOC entry 4105 (class 2606 OID 128030)
-- Name: acc_accommodationfee_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_accommodationfee
    ADD CONSTRAINT acc_accommodationfee_pkey PRIMARY KEY (accommodationfeeid);


--
-- TOC entry 4107 (class 2606 OID 128032)
-- Name: acc_accommodationresource_name_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_accommodationresource
    ADD CONSTRAINT acc_accommodationresource_name_key UNIQUE (name);


--
-- TOC entry 4109 (class 2606 OID 128034)
-- Name: acc_accommodationresource_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_accommodationresource
    ADD CONSTRAINT acc_accommodationresource_pkey PRIMARY KEY (id);


--
-- TOC entry 4111 (class 2606 OID 128036)
-- Name: acc_block_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_block
    ADD CONSTRAINT acc_block_pkey PRIMARY KEY (id);


--
-- TOC entry 4113 (class 2606 OID 128038)
-- Name: acc_hostel_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_hostel
    ADD CONSTRAINT acc_hostel_pkey PRIMARY KEY (id);


--
-- TOC entry 4116 (class 2606 OID 128040)
-- Name: acc_hosteltype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_hosteltype
    ADD CONSTRAINT acc_hosteltype_pkey PRIMARY KEY (id);


--
-- TOC entry 4118 (class 2606 OID 128042)
-- Name: acc_room_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_room
    ADD CONSTRAINT acc_room_pkey PRIMARY KEY (id);


--
-- TOC entry 4121 (class 2606 OID 128044)
-- Name: acc_roomtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_roomtype
    ADD CONSTRAINT acc_roomtype_id_key UNIQUE (id);


--
-- TOC entry 4123 (class 2606 OID 128046)
-- Name: acc_roomtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_roomtype
    ADD CONSTRAINT acc_roomtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4127 (class 2606 OID 128048)
-- Name: acc_studentaccommodation_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_studentaccommodation
    ADD CONSTRAINT acc_studentaccommodation_pkey PRIMARY KEY (id);


--
-- TOC entry 4129 (class 2606 OID 128050)
-- Name: acc_studentaccommodationresource_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_studentaccommodationresource
    ADD CONSTRAINT acc_studentaccommodationresource_pkey PRIMARY KEY (studentaccommodationid, accommodationresourceid);


--
-- TOC entry 4131 (class 2606 OID 128052)
-- Name: address_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- TOC entry 4133 (class 2606 OID 128054)
-- Name: addresstype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY addresstype
    ADD CONSTRAINT addresstype_id_key UNIQUE (id);


--
-- TOC entry 4135 (class 2606 OID 128056)
-- Name: addresstype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY addresstype
    ADD CONSTRAINT addresstype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4137 (class 2606 OID 128058)
-- Name: administrativepost_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY administrativepost
    ADD CONSTRAINT administrativepost_id_key UNIQUE (id);


--
-- TOC entry 4139 (class 2606 OID 128060)
-- Name: administrativepost_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY administrativepost
    ADD CONSTRAINT administrativepost_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4143 (class 2606 OID 128062)
-- Name: appconfig_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY appconfig
    ADD CONSTRAINT appconfig_pkey PRIMARY KEY (startdate, appconfigattributename);


--
-- TOC entry 4145 (class 2606 OID 128064)
-- Name: applicantcategory_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY applicantcategory
    ADD CONSTRAINT applicantcategory_id_key UNIQUE (id);


--
-- TOC entry 4147 (class 2606 OID 128066)
-- Name: applicantcategory_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY applicantcategory
    ADD CONSTRAINT applicantcategory_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4149 (class 2606 OID 128068)
-- Name: appointmenttype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY appointmenttype
    ADD CONSTRAINT appointmenttype_id_key UNIQUE (id);


--
-- TOC entry 4151 (class 2606 OID 128070)
-- Name: appointmenttype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY appointmenttype
    ADD CONSTRAINT appointmenttype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4153 (class 2606 OID 128072)
-- Name: appversions_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY appversions
    ADD CONSTRAINT appversions_pkey PRIMARY KEY (id);


--
-- TOC entry 4157 (class 2606 OID 128074)
-- Name: authorisation_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY authorisation
    ADD CONSTRAINT authorisation_pkey PRIMARY KEY (code);


--
-- TOC entry 4159 (class 2606 OID 128076)
-- Name: blocktype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY blocktype
    ADD CONSTRAINT blocktype_id_key UNIQUE (id);


--
-- TOC entry 4161 (class 2606 OID 128078)
-- Name: blocktype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY blocktype
    ADD CONSTRAINT blocktype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4163 (class 2606 OID 128080)
-- Name: bloodtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bloodtype
    ADD CONSTRAINT bloodtype_id_key UNIQUE (id);


--
-- TOC entry 4165 (class 2606 OID 128082)
-- Name: bloodtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bloodtype
    ADD CONSTRAINT bloodtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4167 (class 2606 OID 128084)
-- Name: branch_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch
    ADD CONSTRAINT branch_pkey PRIMARY KEY (id);


--
-- TOC entry 4169 (class 2606 OID 128086)
-- Name: branchacademicyeartimeunit_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branchacademicyeartimeunit
    ADD CONSTRAINT branchacademicyeartimeunit_pkey PRIMARY KEY (id);


--
-- TOC entry 4171 (class 2606 OID 128088)
-- Name: cardinaltimeunit_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunit
    ADD CONSTRAINT cardinaltimeunit_id_key UNIQUE (id);


--
-- TOC entry 4173 (class 2606 OID 128090)
-- Name: cardinaltimeunit_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunit
    ADD CONSTRAINT cardinaltimeunit_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4175 (class 2606 OID 128092)
-- Name: cardinaltimeunitresult_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunitresult
    ADD CONSTRAINT cardinaltimeunitresult_pkey PRIMARY KEY (id);


--
-- TOC entry 4177 (class 2606 OID 128094)
-- Name: cardinaltimeunitresult_studyplanid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunitresult
    ADD CONSTRAINT cardinaltimeunitresult_studyplanid_key UNIQUE (studyplanid, studyplancardinaltimeunitid);


--
-- TOC entry 4179 (class 2606 OID 128096)
-- Name: cardinaltimeunitstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunitstatus
    ADD CONSTRAINT cardinaltimeunitstatus_id_key UNIQUE (id);


--
-- TOC entry 4181 (class 2606 OID 128098)
-- Name: cardinaltimeunitstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunitstatus
    ADD CONSTRAINT cardinaltimeunitstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4183 (class 2606 OID 128100)
-- Name: cardinaltimeunitstudygradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunitstudygradetype
    ADD CONSTRAINT cardinaltimeunitstudygradetype_pkey PRIMARY KEY (id);


--
-- TOC entry 4185 (class 2606 OID 128102)
-- Name: careerposition_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY careerposition
    ADD CONSTRAINT careerposition_pkey PRIMARY KEY (id);


--
-- TOC entry 4187 (class 2606 OID 128104)
-- Name: civilstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY civilstatus
    ADD CONSTRAINT civilstatus_id_key UNIQUE (id);


--
-- TOC entry 4189 (class 2606 OID 128106)
-- Name: civilstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY civilstatus
    ADD CONSTRAINT civilstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4191 (class 2606 OID 128108)
-- Name: civiltitle_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY civiltitle
    ADD CONSTRAINT civiltitle_id_key UNIQUE (id);


--
-- TOC entry 4193 (class 2606 OID 128110)
-- Name: civiltitle_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY civiltitle
    ADD CONSTRAINT civiltitle_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4195 (class 2606 OID 128112)
-- Name: classgroup_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY classgroup
    ADD CONSTRAINT classgroup_pkey PRIMARY KEY (id);


--
-- TOC entry 4591 (class 2606 OID 128114)
-- Name: code_desc; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY test
    ADD CONSTRAINT code_desc UNIQUE (testcode, testdescription, examinationid);


--
-- TOC entry 4249 (class 2606 OID 128116)
-- Name: code_description; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examination
    ADD CONSTRAINT code_description UNIQUE (examinationcode, examinationdescription, subjectid);


--
-- TOC entry 4465 (class 2606 OID 128118)
-- Name: code_unique_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY secondaryschoolsubject
    ADD CONSTRAINT code_unique_key UNIQUE (code);


--
-- TOC entry 4197 (class 2606 OID 128120)
-- Name: contract_contractcode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT contract_contractcode_key UNIQUE (contractcode);


--
-- TOC entry 4199 (class 2606 OID 128122)
-- Name: contract_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (id);


--
-- TOC entry 4201 (class 2606 OID 128124)
-- Name: contractduration_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contractduration
    ADD CONSTRAINT contractduration_id_key UNIQUE (id);


--
-- TOC entry 4203 (class 2606 OID 128126)
-- Name: contractduration_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contractduration
    ADD CONSTRAINT contractduration_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4205 (class 2606 OID 128128)
-- Name: contracttype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contracttype
    ADD CONSTRAINT contracttype_id_key UNIQUE (id);


--
-- TOC entry 4207 (class 2606 OID 128130)
-- Name: contracttype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contracttype
    ADD CONSTRAINT contracttype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4209 (class 2606 OID 128132)
-- Name: country_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_id_key UNIQUE (id);


--
-- TOC entry 4211 (class 2606 OID 128134)
-- Name: country_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4213 (class 2606 OID 128136)
-- Name: daypart_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY daypart
    ADD CONSTRAINT daypart_id_key UNIQUE (id);


--
-- TOC entry 4215 (class 2606 OID 128138)
-- Name: daypart_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY daypart
    ADD CONSTRAINT daypart_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4217 (class 2606 OID 128140)
-- Name: discipline_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discipline
    ADD CONSTRAINT discipline_id_key UNIQUE (id);


--
-- TOC entry 4219 (class 2606 OID 128142)
-- Name: discipline_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discipline
    ADD CONSTRAINT discipline_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4221 (class 2606 OID 128144)
-- Name: disciplinegroup_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY disciplinegroup
    ADD CONSTRAINT disciplinegroup_id_key UNIQUE (id);


--
-- TOC entry 4223 (class 2606 OID 128146)
-- Name: district_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY district
    ADD CONSTRAINT district_id_key UNIQUE (id);


--
-- TOC entry 4225 (class 2606 OID 128148)
-- Name: district_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY district
    ADD CONSTRAINT district_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4227 (class 2606 OID 128150)
-- Name: educationarea_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY educationarea
    ADD CONSTRAINT educationarea_id_key UNIQUE (id);


--
-- TOC entry 4229 (class 2606 OID 128152)
-- Name: educationarea_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY educationarea
    ADD CONSTRAINT educationarea_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4231 (class 2606 OID 128154)
-- Name: educationlevel_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY educationlevel
    ADD CONSTRAINT educationlevel_id_key UNIQUE (id);


--
-- TOC entry 4233 (class 2606 OID 128156)
-- Name: educationlevel_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY educationlevel
    ADD CONSTRAINT educationlevel_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4235 (class 2606 OID 128158)
-- Name: educationtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY educationtype
    ADD CONSTRAINT educationtype_id_key UNIQUE (id);


--
-- TOC entry 4237 (class 2606 OID 128160)
-- Name: educationtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY educationtype
    ADD CONSTRAINT educationtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4239 (class 2606 OID 128162)
-- Name: endgrade_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY endgrade
    ADD CONSTRAINT endgrade_pkey PRIMARY KEY (id);


--
-- TOC entry 4243 (class 2606 OID 128164)
-- Name: endgradegeneral_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY endgradegeneral
    ADD CONSTRAINT endgradegeneral_pkey PRIMARY KEY (id);


--
-- TOC entry 4245 (class 2606 OID 128166)
-- Name: endgradetype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY endgradetype
    ADD CONSTRAINT endgradetype_id_key UNIQUE (id);


--
-- TOC entry 4247 (class 2606 OID 128168)
-- Name: endgradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY endgradetype
    ADD CONSTRAINT endgradetype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4539 (class 2606 OID 128170)
-- Name: exam_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplanresult
    ADD CONSTRAINT exam_pkey PRIMARY KEY (id);


--
-- TOC entry 4541 (class 2606 OID 128172)
-- Name: exam_studyplanid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplanresult
    ADD CONSTRAINT exam_studyplanid_key UNIQUE (studyplanid);


--
-- TOC entry 4251 (class 2606 OID 128174)
-- Name: examination_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examination
    ADD CONSTRAINT examination_pkey PRIMARY KEY (id);


--
-- TOC entry 4253 (class 2606 OID 128176)
-- Name: examinationresult_examinationattemptnr_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_examinationattemptnr_key UNIQUE (examinationid, subjectid, subjectresultid, studyplandetailid, attemptnr);


--
-- TOC entry 4255 (class 2606 OID 128178)
-- Name: examinationresult_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_pkey PRIMARY KEY (id);


--
-- TOC entry 4257 (class 2606 OID 128180)
-- Name: examinationteacher_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationteacher
    ADD CONSTRAINT examinationteacher_pkey PRIMARY KEY (id);


--
-- TOC entry 4259 (class 2606 OID 128182)
-- Name: examinationteacher_staffmemberid_classgroupid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationteacher
    ADD CONSTRAINT examinationteacher_staffmemberid_classgroupid_key UNIQUE (staffmemberid, examinationid, classgroupid);


--
-- TOC entry 4261 (class 2606 OID 128184)
-- Name: examinationtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationtype
    ADD CONSTRAINT examinationtype_id_key UNIQUE (id);


--
-- TOC entry 4263 (class 2606 OID 128186)
-- Name: examinationtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationtype
    ADD CONSTRAINT examinationtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4265 (class 2606 OID 128188)
-- Name: examtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examtype
    ADD CONSTRAINT examtype_id_key UNIQUE (id);


--
-- TOC entry 4267 (class 2606 OID 128190)
-- Name: examtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examtype
    ADD CONSTRAINT examtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4271 (class 2606 OID 128192)
-- Name: expellationtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY expellationtype
    ADD CONSTRAINT expellationtype_id_key UNIQUE (id);


--
-- TOC entry 4273 (class 2606 OID 128194)
-- Name: expellationtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY expellationtype
    ADD CONSTRAINT expellationtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4275 (class 2606 OID 128196)
-- Name: failgrade_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY failgrade
    ADD CONSTRAINT failgrade_pkey PRIMARY KEY (id);


--
-- TOC entry 4277 (class 2606 OID 128198)
-- Name: fee_fee_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_fee
    ADD CONSTRAINT fee_fee_pkey PRIMARY KEY (id);


--
-- TOC entry 4279 (class 2606 OID 128200)
-- Name: fee_feecategory_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_feecategory
    ADD CONSTRAINT fee_feecategory_id_key UNIQUE (id);


--
-- TOC entry 4281 (class 2606 OID 128202)
-- Name: fee_feecategory_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_feecategory
    ADD CONSTRAINT fee_feecategory_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4283 (class 2606 OID 128204)
-- Name: fee_payment_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_payment
    ADD CONSTRAINT fee_payment_pkey PRIMARY KEY (id);


--
-- TOC entry 4285 (class 2606 OID 128206)
-- Name: fieldofeducation_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fieldofeducation
    ADD CONSTRAINT fieldofeducation_id_key UNIQUE (id);


--
-- TOC entry 4287 (class 2606 OID 128208)
-- Name: fieldofeducation_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fieldofeducation
    ADD CONSTRAINT fieldofeducation_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4289 (class 2606 OID 128210)
-- Name: financialrequest_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY financialrequest
    ADD CONSTRAINT financialrequest_pkey PRIMARY KEY (id);


--
-- TOC entry 4291 (class 2606 OID 128212)
-- Name: financialtransaction_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY financialtransaction
    ADD CONSTRAINT financialtransaction_pkey PRIMARY KEY (id);


--
-- TOC entry 4447 (class 2606 OID 128214)
-- Name: fk_sponsorcode; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsor
    ADD CONSTRAINT fk_sponsorcode UNIQUE (code);


--
-- TOC entry 4293 (class 2606 OID 128216)
-- Name: frequency_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY frequency
    ADD CONSTRAINT frequency_id_key UNIQUE (id);


--
-- TOC entry 4295 (class 2606 OID 128218)
-- Name: frequency_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY frequency
    ADD CONSTRAINT frequency_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4297 (class 2606 OID 128220)
-- Name: function_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY function
    ADD CONSTRAINT function_id_key UNIQUE (id);


--
-- TOC entry 4299 (class 2606 OID 128222)
-- Name: function_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY function
    ADD CONSTRAINT function_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4301 (class 2606 OID 128224)
-- Name: functionlevel_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY functionlevel
    ADD CONSTRAINT functionlevel_id_key UNIQUE (id);


--
-- TOC entry 4303 (class 2606 OID 128226)
-- Name: functionlevel_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY functionlevel
    ADD CONSTRAINT functionlevel_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4305 (class 2606 OID 128228)
-- Name: gender_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gender
    ADD CONSTRAINT gender_id_key UNIQUE (id);


--
-- TOC entry 4307 (class 2606 OID 128230)
-- Name: gender_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gender
    ADD CONSTRAINT gender_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4309 (class 2606 OID 128232)
-- Name: gradedsecondaryschoolsubject_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gradedsecondaryschoolsubject
    ADD CONSTRAINT gradedsecondaryschoolsubject_pkey PRIMARY KEY (id);


--
-- TOC entry 4311 (class 2606 OID 128234)
-- Name: gradedsecondaryschoolsubject_secondaryschoolsubjectid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gradedsecondaryschoolsubject
    ADD CONSTRAINT gradedsecondaryschoolsubject_secondaryschoolsubjectid_key UNIQUE (secondaryschoolsubjectid, studyplanid);


--
-- TOC entry 4313 (class 2606 OID 128236)
-- Name: gradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gradetype
    ADD CONSTRAINT gradetype_pkey PRIMARY KEY (id);


--
-- TOC entry 4315 (class 2606 OID 128238)
-- Name: groupeddiscipline_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groupeddiscipline
    ADD CONSTRAINT groupeddiscipline_pkey PRIMARY KEY (id);


--
-- TOC entry 4319 (class 2606 OID 128240)
-- Name: groupedsecondaryschoolsubject_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groupedsecondaryschoolsubject
    ADD CONSTRAINT groupedsecondaryschoolsubject_pkey PRIMARY KEY (id);


--
-- TOC entry 4321 (class 2606 OID 128242)
-- Name: groupedsecondaryschoolsubject_secondaryschoolsubjectid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groupedsecondaryschoolsubject
    ADD CONSTRAINT groupedsecondaryschoolsubject_secondaryschoolsubjectid_key UNIQUE (secondaryschoolsubjectid, secondaryschoolsubjectgroupid);


--
-- TOC entry 4323 (class 2606 OID 128244)
-- Name: identificationtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY identificationtype
    ADD CONSTRAINT identificationtype_id_key UNIQUE (id);


--
-- TOC entry 4325 (class 2606 OID 128246)
-- Name: identificationtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY identificationtype
    ADD CONSTRAINT identificationtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4331 (class 2606 OID 128248)
-- Name: institution_institutioncode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY institution
    ADD CONSTRAINT institution_institutioncode_key UNIQUE (institutioncode);


--
-- TOC entry 4333 (class 2606 OID 128250)
-- Name: institution_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY institution
    ADD CONSTRAINT institution_pkey PRIMARY KEY (id);


--
-- TOC entry 4335 (class 2606 OID 128252)
-- Name: language_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY language
    ADD CONSTRAINT language_id_key UNIQUE (id);


--
-- TOC entry 4337 (class 2606 OID 128254)
-- Name: language_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY language
    ADD CONSTRAINT language_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4339 (class 2606 OID 128256)
-- Name: levelofeducation_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY levelofeducation
    ADD CONSTRAINT levelofeducation_id_key UNIQUE (id);


--
-- TOC entry 4341 (class 2606 OID 128258)
-- Name: levelofeducation_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY levelofeducation
    ADD CONSTRAINT levelofeducation_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4343 (class 2606 OID 128260)
-- Name: logmailerror_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY logmailerror
    ADD CONSTRAINT logmailerror_pkey PRIMARY KEY (id);


--
-- TOC entry 4345 (class 2606 OID 128262)
-- Name: logrequesterror_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY logrequesterror
    ADD CONSTRAINT logrequesterror_pkey PRIMARY KEY (id);


--
-- TOC entry 4347 (class 2606 OID 128264)
-- Name: lookuptable_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lookuptable
    ADD CONSTRAINT lookuptable_pkey PRIMARY KEY (id);


--
-- TOC entry 4350 (class 2606 OID 128266)
-- Name: mailconfig_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mailconfig
    ADD CONSTRAINT mailconfig_pkey PRIMARY KEY (id);


--
-- TOC entry 4352 (class 2606 OID 128268)
-- Name: masteringlevel_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY masteringlevel
    ADD CONSTRAINT masteringlevel_id_key UNIQUE (id);


--
-- TOC entry 4354 (class 2606 OID 128270)
-- Name: masteringlevel_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY masteringlevel
    ADD CONSTRAINT masteringlevel_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4155 (class 2606 OID 128272)
-- Name: module_uq; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY appversions
    ADD CONSTRAINT module_uq UNIQUE (module);


--
-- TOC entry 4356 (class 2606 OID 128274)
-- Name: nationality_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nationality
    ADD CONSTRAINT nationality_id_key UNIQUE (id);


--
-- TOC entry 4358 (class 2606 OID 128276)
-- Name: nationality_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nationality
    ADD CONSTRAINT nationality_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4360 (class 2606 OID 128278)
-- Name: nationalitygroup_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nationalitygroup
    ADD CONSTRAINT nationalitygroup_id_key UNIQUE (id);


--
-- TOC entry 4362 (class 2606 OID 128280)
-- Name: nationalitygroup_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nationalitygroup
    ADD CONSTRAINT nationalitygroup_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4364 (class 2606 OID 128282)
-- Name: obtainedqualification_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY obtainedqualification
    ADD CONSTRAINT obtainedqualification_pkey PRIMARY KEY (id);


--
-- TOC entry 4366 (class 2606 OID 128284)
-- Name: opusprivilege_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opusprivilege
    ADD CONSTRAINT opusprivilege_id_key UNIQUE (id);


--
-- TOC entry 4368 (class 2606 OID 128286)
-- Name: opusprivilege_lang_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opusprivilege
    ADD CONSTRAINT opusprivilege_lang_key UNIQUE (lang, code);


--
-- TOC entry 4370 (class 2606 OID 128288)
-- Name: opusprivilege_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opusprivilege
    ADD CONSTRAINT opusprivilege_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4372 (class 2606 OID 128290)
-- Name: opusrole_privilege_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opusrole_privilege
    ADD CONSTRAINT opusrole_privilege_pkey PRIMARY KEY (id);


--
-- TOC entry 4377 (class 2606 OID 128292)
-- Name: opususer_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opususer
    ADD CONSTRAINT opususer_pkey PRIMARY KEY (id);


--
-- TOC entry 4379 (class 2606 OID 128294)
-- Name: opususer_username_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opususer
    ADD CONSTRAINT opususer_username_key UNIQUE (username);


--
-- TOC entry 4381 (class 2606 OID 128296)
-- Name: opususerrole_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opususerrole
    ADD CONSTRAINT opususerrole_pkey PRIMARY KEY (id);


--
-- TOC entry 4095 (class 2606 OID 128298)
-- Name: organizationalunit_organizationalunitcode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY organizationalunit
    ADD CONSTRAINT organizationalunit_organizationalunitcode_key UNIQUE (organizationalunitcode);


--
-- TOC entry 4097 (class 2606 OID 128300)
-- Name: organizationalunit_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY organizationalunit
    ADD CONSTRAINT organizationalunit_pkey PRIMARY KEY (id);


--
-- TOC entry 4141 (class 2606 OID 128302)
-- Name: organizationalunitacademicyear_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY admissionregistrationconfig
    ADD CONSTRAINT organizationalunitacademicyear_pkey PRIMARY KEY (organizationalunitid, academicyearid);


--
-- TOC entry 4385 (class 2606 OID 128304)
-- Name: penalty_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY penalty
    ADD CONSTRAINT penalty_pkey PRIMARY KEY (id);


--
-- TOC entry 4387 (class 2606 OID 128306)
-- Name: penaltytype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY penaltytype
    ADD CONSTRAINT penaltytype_id_key UNIQUE (id);


--
-- TOC entry 4389 (class 2606 OID 128308)
-- Name: penaltytype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY penaltytype
    ADD CONSTRAINT penaltytype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4391 (class 2606 OID 128310)
-- Name: person_personcode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_personcode_key UNIQUE (personcode);


--
-- TOC entry 4393 (class 2606 OID 128312)
-- Name: person_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- TOC entry 4269 (class 2606 OID 128314)
-- Name: pk_exclusion; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY exclusion
    ADD CONSTRAINT pk_exclusion PRIMARY KEY (subject1, subject2);


--
-- TOC entry 4467 (class 2606 OID 128316)
-- Name: primary_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY secondaryschoolsubject
    ADD CONSTRAINT primary_key PRIMARY KEY (id);


--
-- TOC entry 4395 (class 2606 OID 128318)
-- Name: profession_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY profession
    ADD CONSTRAINT profession_id_key UNIQUE (id);


--
-- TOC entry 4397 (class 2606 OID 128320)
-- Name: profession_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY profession
    ADD CONSTRAINT profession_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4399 (class 2606 OID 128322)
-- Name: progressstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY progressstatus
    ADD CONSTRAINT progressstatus_id_key UNIQUE (id);


--
-- TOC entry 4401 (class 2606 OID 128324)
-- Name: progressstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY progressstatus
    ADD CONSTRAINT progressstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4403 (class 2606 OID 128326)
-- Name: province_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY province
    ADD CONSTRAINT province_id_key UNIQUE (id);


--
-- TOC entry 4405 (class 2606 OID 128328)
-- Name: province_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY province
    ADD CONSTRAINT province_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4407 (class 2606 OID 128330)
-- Name: referee_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY referee
    ADD CONSTRAINT referee_pkey PRIMARY KEY (id);


--
-- TOC entry 4409 (class 2606 OID 128332)
-- Name: relationtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY relationtype
    ADD CONSTRAINT relationtype_id_key UNIQUE (id);


--
-- TOC entry 4411 (class 2606 OID 128334)
-- Name: relationtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY relationtype
    ADD CONSTRAINT relationtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4413 (class 2606 OID 128336)
-- Name: reportproperty_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY reportproperty
    ADD CONSTRAINT reportproperty_pkey PRIMARY KEY (id);


--
-- TOC entry 4415 (class 2606 OID 128338)
-- Name: reportproperty_reportname_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY reportproperty
    ADD CONSTRAINT reportproperty_reportname_key UNIQUE (reportname, propertyname);


--
-- TOC entry 4417 (class 2606 OID 128340)
-- Name: requestadmissionperiod_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY requestadmissionperiod
    ADD CONSTRAINT requestadmissionperiod_pkey PRIMARY KEY (startdate, enddate, academicyearid);


--
-- TOC entry 4419 (class 2606 OID 128342)
-- Name: requestforchange_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY requestforchange
    ADD CONSTRAINT requestforchange_pkey PRIMARY KEY (id);


--
-- TOC entry 4421 (class 2606 OID 128344)
-- Name: rfcstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rfcstatus
    ADD CONSTRAINT rfcstatus_id_key UNIQUE (id);


--
-- TOC entry 4423 (class 2606 OID 128346)
-- Name: rfcstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rfcstatus
    ADD CONSTRAINT rfcstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4425 (class 2606 OID 128348)
-- Name: rigiditytype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rigiditytype
    ADD CONSTRAINT rigiditytype_id_key UNIQUE (id);


--
-- TOC entry 4427 (class 2606 OID 128350)
-- Name: rigiditytype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rigiditytype
    ADD CONSTRAINT rigiditytype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4429 (class 2606 OID 128352)
-- Name: role_lang_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_lang_key UNIQUE (lang, role);


--
-- TOC entry 4431 (class 2606 OID 128354)
-- Name: role_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- TOC entry 4433 (class 2606 OID 128356)
-- Name: sch_bank_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_bank
    ADD CONSTRAINT sch_bank_pkey PRIMARY KEY (code);


--
-- TOC entry 4435 (class 2606 OID 128358)
-- Name: sch_complaint_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_complaint
    ADD CONSTRAINT sch_complaint_pkey PRIMARY KEY (id);


--
-- TOC entry 4437 (class 2606 OID 128360)
-- Name: sch_complaintstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_complaintstatus
    ADD CONSTRAINT sch_complaintstatus_pkey PRIMARY KEY (id);


--
-- TOC entry 4439 (class 2606 OID 128362)
-- Name: sch_decisioncriteria_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_decisioncriteria
    ADD CONSTRAINT sch_decisioncriteria_pkey PRIMARY KEY (id);


--
-- TOC entry 4443 (class 2606 OID 128364)
-- Name: sch_scholarship_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_scholarshipapplication
    ADD CONSTRAINT sch_scholarship_pkey PRIMARY KEY (id);


--
-- TOC entry 4445 (class 2606 OID 128366)
-- Name: sch_scholarshiptype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_scholarshiptype
    ADD CONSTRAINT sch_scholarshiptype_pkey PRIMARY KEY (id);


--
-- TOC entry 4441 (class 2606 OID 128368)
-- Name: sch_scholarshiptypeyear_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_scholarship
    ADD CONSTRAINT sch_scholarshiptypeyear_pkey PRIMARY KEY (id);


--
-- TOC entry 4449 (class 2606 OID 128370)
-- Name: sch_sponsor_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsor
    ADD CONSTRAINT sch_sponsor_pkey PRIMARY KEY (id);


--
-- TOC entry 4451 (class 2606 OID 128372)
-- Name: sch_sponsorfeepercentage_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsorfeepercentage
    ADD CONSTRAINT sch_sponsorfeepercentage_pkey PRIMARY KEY (id);


--
-- TOC entry 4453 (class 2606 OID 128374)
-- Name: sch_sponsorpayment_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsorpayment
    ADD CONSTRAINT sch_sponsorpayment_pkey PRIMARY KEY (id);


--
-- TOC entry 4455 (class 2606 OID 128376)
-- Name: sch_sponsortype_code_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsortype
    ADD CONSTRAINT sch_sponsortype_code_key UNIQUE (code);


--
-- TOC entry 4457 (class 2606 OID 128378)
-- Name: sch_sponsortype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsortype
    ADD CONSTRAINT sch_sponsortype_pkey PRIMARY KEY (id);


--
-- TOC entry 4459 (class 2606 OID 128380)
-- Name: sch_student_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_student
    ADD CONSTRAINT sch_student_pkey PRIMARY KEY (scholarshipstudentid);


--
-- TOC entry 4461 (class 2606 OID 128382)
-- Name: sch_subsidy_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_subsidy
    ADD CONSTRAINT sch_subsidy_pkey PRIMARY KEY (id);


--
-- TOC entry 4463 (class 2606 OID 128384)
-- Name: sch_subsidytype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_subsidytype
    ADD CONSTRAINT sch_subsidytype_pkey PRIMARY KEY (id);


--
-- TOC entry 4469 (class 2606 OID 128386)
-- Name: secondaryschoolsubject_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY secondaryschoolsubject
    ADD CONSTRAINT secondaryschoolsubject_id_key UNIQUE (id);


--
-- TOC entry 4471 (class 2606 OID 128388)
-- Name: secondaryschoolsubjectgroup_groupnumber_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY secondaryschoolsubjectgroup
    ADD CONSTRAINT secondaryschoolsubjectgroup_groupnumber_key UNIQUE (groupnumber, studygradetypeid);


--
-- TOC entry 4473 (class 2606 OID 128390)
-- Name: secondaryschoolsubjectgroup_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY secondaryschoolsubjectgroup
    ADD CONSTRAINT secondaryschoolsubjectgroup_pkey PRIMARY KEY (id);


--
-- TOC entry 4475 (class 2606 OID 128392)
-- Name: staffmember_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY staffmember
    ADD CONSTRAINT staffmember_pkey PRIMARY KEY (staffmemberid);


--
-- TOC entry 4477 (class 2606 OID 128394)
-- Name: staffmember_staffmembercode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY staffmember
    ADD CONSTRAINT staffmember_staffmembercode_key UNIQUE (staffmembercode);


--
-- TOC entry 4479 (class 2606 OID 128396)
-- Name: staffmemberfunction_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY staffmemberfunction
    ADD CONSTRAINT staffmemberfunction_pkey PRIMARY KEY (staffmemberid, functioncode);


--
-- TOC entry 4481 (class 2606 OID 128398)
-- Name: stafftype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stafftype
    ADD CONSTRAINT stafftype_id_key UNIQUE (id);


--
-- TOC entry 4483 (class 2606 OID 128400)
-- Name: stafftype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stafftype
    ADD CONSTRAINT stafftype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4485 (class 2606 OID 128402)
-- Name: status_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY status
    ADD CONSTRAINT status_id_key UNIQUE (id);


--
-- TOC entry 4487 (class 2606 OID 128404)
-- Name: status_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4489 (class 2606 OID 128406)
-- Name: student_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY student
    ADD CONSTRAINT student_pkey PRIMARY KEY (studentid);


--
-- TOC entry 4491 (class 2606 OID 128408)
-- Name: student_studentcode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY student
    ADD CONSTRAINT student_studentcode_key UNIQUE (studentcode);


--
-- TOC entry 4493 (class 2606 OID 128410)
-- Name: studentabsence_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentabsence
    ADD CONSTRAINT studentabsence_pkey PRIMARY KEY (id);


--
-- TOC entry 4495 (class 2606 OID 128412)
-- Name: studentabsence_startdatetemporaryinactivity_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentabsence
    ADD CONSTRAINT studentabsence_startdatetemporaryinactivity_key UNIQUE (startdatetemporaryinactivity, enddatetemporaryinactivity);


--
-- TOC entry 4497 (class 2606 OID 128414)
-- Name: studentactivity_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentactivity
    ADD CONSTRAINT studentactivity_pkey PRIMARY KEY (id);


--
-- TOC entry 4499 (class 2606 OID 128416)
-- Name: studentbalance_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentbalance
    ADD CONSTRAINT studentbalance_pkey PRIMARY KEY (id);


--
-- TOC entry 4501 (class 2606 OID 128418)
-- Name: studentcareer_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentcareer
    ADD CONSTRAINT studentcareer_pkey PRIMARY KEY (id);


--
-- TOC entry 4503 (class 2606 OID 128420)
-- Name: studentclassgroup_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentclassgroup
    ADD CONSTRAINT studentclassgroup_pkey PRIMARY KEY (id);


--
-- TOC entry 4505 (class 2606 OID 128422)
-- Name: studentcounseling_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentcounseling
    ADD CONSTRAINT studentcounseling_pkey PRIMARY KEY (id);


--
-- TOC entry 4507 (class 2606 OID 128424)
-- Name: studentexpulsion_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentexpulsion
    ADD CONSTRAINT studentexpulsion_pkey PRIMARY KEY (id);


--
-- TOC entry 4509 (class 2606 OID 128426)
-- Name: studentexpulsion_startdate_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentexpulsion
    ADD CONSTRAINT studentexpulsion_startdate_key UNIQUE (startdate, enddate);


--
-- TOC entry 4511 (class 2606 OID 128428)
-- Name: studentplacement_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentplacement
    ADD CONSTRAINT studentplacement_pkey PRIMARY KEY (id);


--
-- TOC entry 4513 (class 2606 OID 128430)
-- Name: studentstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentstatus
    ADD CONSTRAINT studentstatus_id_key UNIQUE (id);


--
-- TOC entry 4515 (class 2606 OID 128432)
-- Name: studentstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentstatus
    ADD CONSTRAINT studentstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4517 (class 2606 OID 128434)
-- Name: studentstudentstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentstudentstatus
    ADD CONSTRAINT studentstudentstatus_pkey PRIMARY KEY (id);


--
-- TOC entry 4525 (class 2606 OID 128436)
-- Name: study_gradetype_studyform_studytime_studyintensity_academicyear; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studygradetype
    ADD CONSTRAINT study_gradetype_studyform_studytime_studyintensity_academicyear UNIQUE (studyid, gradetypecode, studyformcode, studytimecode, studyintensitycode, currentacademicyearid);


--
-- TOC entry 4519 (class 2606 OID 128438)
-- Name: study_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY study
    ADD CONSTRAINT study_pkey PRIMARY KEY (id);


--
-- TOC entry 4521 (class 2606 OID 128440)
-- Name: studyform_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyform
    ADD CONSTRAINT studyform_id_key UNIQUE (id);


--
-- TOC entry 4523 (class 2606 OID 128442)
-- Name: studyform_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyform
    ADD CONSTRAINT studyform_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4527 (class 2606 OID 128444)
-- Name: studygradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studygradetype
    ADD CONSTRAINT studygradetype_pkey PRIMARY KEY (id);


--
-- TOC entry 4529 (class 2606 OID 128446)
-- Name: studyintensity_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyintensity
    ADD CONSTRAINT studyintensity_id_key UNIQUE (id);


--
-- TOC entry 4531 (class 2606 OID 128448)
-- Name: studyintensity_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyintensity
    ADD CONSTRAINT studyintensity_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4533 (class 2606 OID 128450)
-- Name: studyplan_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplan
    ADD CONSTRAINT studyplan_pkey PRIMARY KEY (id);


--
-- TOC entry 4535 (class 2606 OID 128452)
-- Name: studyplancardinaltimeunit_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplancardinaltimeunit
    ADD CONSTRAINT studyplancardinaltimeunit_pkey PRIMARY KEY (id);


--
-- TOC entry 4537 (class 2606 OID 128454)
-- Name: studyplandetail_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplandetail
    ADD CONSTRAINT studyplandetail_pkey PRIMARY KEY (id);


--
-- TOC entry 4543 (class 2606 OID 128456)
-- Name: studyplanstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplanstatus
    ADD CONSTRAINT studyplanstatus_id_key UNIQUE (id);


--
-- TOC entry 4545 (class 2606 OID 128458)
-- Name: studyplanstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplanstatus
    ADD CONSTRAINT studyplanstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4547 (class 2606 OID 128460)
-- Name: studytime_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studytime
    ADD CONSTRAINT studytime_id_key UNIQUE (id);


--
-- TOC entry 4549 (class 2606 OID 128462)
-- Name: studytime_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studytime
    ADD CONSTRAINT studytime_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4551 (class 2606 OID 128464)
-- Name: studytype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studytype
    ADD CONSTRAINT studytype_id_key UNIQUE (id);


--
-- TOC entry 4553 (class 2606 OID 128466)
-- Name: studytype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studytype
    ADD CONSTRAINT studytype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4555 (class 2606 OID 128468)
-- Name: subject_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (id);


--
-- TOC entry 4557 (class 2606 OID 128470)
-- Name: subject_subjectcode_subjectdescription_currentacademicyearid_ke; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subject_subjectcode_subjectdescription_currentacademicyearid_ke UNIQUE (subjectcode, subjectdescription, currentacademicyearid);


--
-- TOC entry 4559 (class 2606 OID 128472)
-- Name: subjectblock_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectblock
    ADD CONSTRAINT subjectblock_pkey PRIMARY KEY (id);


--
-- TOC entry 4561 (class 2606 OID 128474)
-- Name: subjectblock_subjectblockcode_currentacademicyearid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectblock
    ADD CONSTRAINT subjectblock_subjectblockcode_currentacademicyearid_key UNIQUE (subjectblockcode, currentacademicyearid);


--
-- TOC entry 4563 (class 2606 OID 128476)
-- Name: subjectblockstudygradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectblockstudygradetype
    ADD CONSTRAINT subjectblockstudygradetype_pkey PRIMARY KEY (id);


--
-- TOC entry 4565 (class 2606 OID 128478)
-- Name: subjectblockstudygradetype_subjectblockid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectblockstudygradetype
    ADD CONSTRAINT subjectblockstudygradetype_subjectblockid_key UNIQUE (subjectblockid, studygradetypeid, cardinaltimeunitnumber, rigiditytypecode);


--
-- TOC entry 4567 (class 2606 OID 128480)
-- Name: subjectclassgroup_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectclassgroup
    ADD CONSTRAINT subjectclassgroup_pkey PRIMARY KEY (id);


--
-- TOC entry 4327 (class 2606 OID 128482)
-- Name: subjectimportance_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY importancetype
    ADD CONSTRAINT subjectimportance_id_key UNIQUE (id);


--
-- TOC entry 4329 (class 2606 OID 128484)
-- Name: subjectimportance_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY importancetype
    ADD CONSTRAINT subjectimportance_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4569 (class 2606 OID 128486)
-- Name: subjectresult_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectresult
    ADD CONSTRAINT subjectresult_pkey PRIMARY KEY (id);


--
-- TOC entry 4571 (class 2606 OID 128488)
-- Name: subjectstudygradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectstudygradetype
    ADD CONSTRAINT subjectstudygradetype_pkey PRIMARY KEY (id);


--
-- TOC entry 4573 (class 2606 OID 128490)
-- Name: subjectstudytype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectstudytype
    ADD CONSTRAINT subjectstudytype_pkey PRIMARY KEY (id);


--
-- TOC entry 4575 (class 2606 OID 128492)
-- Name: subjectstudytype_subjectid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectstudytype
    ADD CONSTRAINT subjectstudytype_subjectid_key UNIQUE (subjectid, studytypecode);


--
-- TOC entry 4577 (class 2606 OID 128494)
-- Name: subjectsubjectblock_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectsubjectblock
    ADD CONSTRAINT subjectsubjectblock_pkey PRIMARY KEY (id);


--
-- TOC entry 4579 (class 2606 OID 128496)
-- Name: subjectsubjectblock_subjectid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectsubjectblock
    ADD CONSTRAINT subjectsubjectblock_subjectid_key UNIQUE (subjectid, subjectblockid);


--
-- TOC entry 4581 (class 2606 OID 128498)
-- Name: subjectteacher_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectteacher
    ADD CONSTRAINT subjectteacher_pkey PRIMARY KEY (id);


--
-- TOC entry 4583 (class 2606 OID 128500)
-- Name: subjectteacher_staffmemberid_classgroupid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectteacher
    ADD CONSTRAINT subjectteacher_staffmemberid_classgroupid_key UNIQUE (staffmemberid, subjectid, classgroupid);


--
-- TOC entry 4585 (class 2606 OID 128502)
-- Name: tabledependency_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tabledependency
    ADD CONSTRAINT tabledependency_pkey PRIMARY KEY (id);


--
-- TOC entry 4587 (class 2606 OID 128504)
-- Name: targetgroup_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY targetgroup
    ADD CONSTRAINT targetgroup_id_key UNIQUE (id);


--
-- TOC entry 4589 (class 2606 OID 128506)
-- Name: targetgroup_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY targetgroup
    ADD CONSTRAINT targetgroup_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4593 (class 2606 OID 128508)
-- Name: test_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY test
    ADD CONSTRAINT test_pkey PRIMARY KEY (id);


--
-- TOC entry 4595 (class 2606 OID 128510)
-- Name: testresult_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_pkey PRIMARY KEY (id);


--
-- TOC entry 4597 (class 2606 OID 128512)
-- Name: testresult_testattemptnr_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_testattemptnr_key UNIQUE (testid, examinationid, examinationresultid, studyplandetailid, attemptnr);


--
-- TOC entry 4599 (class 2606 OID 128514)
-- Name: testteacher_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY testteacher
    ADD CONSTRAINT testteacher_pkey PRIMARY KEY (id);


--
-- TOC entry 4601 (class 2606 OID 128516)
-- Name: testteacher_staffmemberid_classgroupid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY testteacher
    ADD CONSTRAINT testteacher_staffmemberid_classgroupid_key UNIQUE (staffmemberid, testid, classgroupid);


--
-- TOC entry 4603 (class 2606 OID 128518)
-- Name: thesis_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesis
    ADD CONSTRAINT thesis_pkey PRIMARY KEY (id);


--
-- TOC entry 4605 (class 2606 OID 128520)
-- Name: thesis_thesiscode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesis
    ADD CONSTRAINT thesis_thesiscode_key UNIQUE (thesiscode);


--
-- TOC entry 4607 (class 2606 OID 128522)
-- Name: thesisresult_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesisresult
    ADD CONSTRAINT thesisresult_pkey PRIMARY KEY (id);


--
-- TOC entry 4609 (class 2606 OID 128524)
-- Name: thesisresult_studyplanid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesisresult
    ADD CONSTRAINT thesisresult_studyplanid_key UNIQUE (studyplanid);


--
-- TOC entry 4611 (class 2606 OID 128526)
-- Name: thesisstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesisstatus
    ADD CONSTRAINT thesisstatus_id_key UNIQUE (id);


--
-- TOC entry 4613 (class 2606 OID 128528)
-- Name: thesisstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesisstatus
    ADD CONSTRAINT thesisstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4615 (class 2606 OID 128530)
-- Name: thesissupervisor_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesissupervisor
    ADD CONSTRAINT thesissupervisor_pkey PRIMARY KEY (id);


--
-- TOC entry 4617 (class 2606 OID 128532)
-- Name: thesisthesisstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesisthesisstatus
    ADD CONSTRAINT thesisthesisstatus_pkey PRIMARY KEY (id);


--
-- TOC entry 4125 (class 2606 OID 128534)
-- Name: unique_acc_roomtype_code_lang; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_roomtype
    ADD CONSTRAINT unique_acc_roomtype_code_lang UNIQUE (code, lang);


--
-- TOC entry 4374 (class 2606 OID 128536)
-- Name: unique_role_privilege; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opusrole_privilege
    ADD CONSTRAINT unique_role_privilege UNIQUE (role, privilegecode);


--
-- TOC entry 4619 (class 2606 OID 128538)
-- Name: unitarea_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unitarea
    ADD CONSTRAINT unitarea_id_key UNIQUE (id);


--
-- TOC entry 4621 (class 2606 OID 128540)
-- Name: unitarea_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unitarea
    ADD CONSTRAINT unitarea_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4623 (class 2606 OID 128542)
-- Name: unittype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unittype
    ADD CONSTRAINT unittype_id_key UNIQUE (id);


--
-- TOC entry 4625 (class 2606 OID 128544)
-- Name: unittype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unittype
    ADD CONSTRAINT unittype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4317 (class 2606 OID 128546)
-- Name: uq_groupeddiscipline_disciplinecode_groupid; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groupeddiscipline
    ADD CONSTRAINT uq_groupeddiscipline_disciplinecode_groupid UNIQUE (disciplinecode, disciplinegroupid);


--
-- TOC entry 4241 (class 2606 OID 128548)
-- Name: uq_lang_code_academicyear_endgradetype; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY endgrade
    ADD CONSTRAINT uq_lang_code_academicyear_endgradetype UNIQUE (code, lang, academicyearid, endgradetypecode);


--
-- TOC entry 4383 (class 2606 OID 128550)
-- Name: user_organizationalunit_unique_constraint; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opususerrole
    ADD CONSTRAINT user_organizationalunit_unique_constraint UNIQUE (username, organizationalunitid);


--
-- TOC entry 4375 (class 1259 OID 128551)
-- Name: lower_username_idx; Type: INDEX; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE INDEX lower_username_idx ON opususer USING btree (lower((username)::text));


--
-- TOC entry 4119 (class 1259 OID 128552)
-- Name: unique_acc_roomcode; Type: INDEX; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX unique_acc_roomcode ON acc_room USING btree (lower((code)::text));


--
-- TOC entry 4114 (class 1259 OID 128553)
-- Name: unique_hostelcode; Type: INDEX; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX unique_hostelcode ON acc_hostel USING btree (lower((code)::text));


--
-- TOC entry 4348 (class 1259 OID 128554)
-- Name: unique_tablename; Type: INDEX; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX unique_tablename ON lookuptable USING btree (lower((tablename)::text));


SET search_path = audit, pg_catalog;

--
-- TOC entry 4626 (class 2606 OID 128555)
-- Name: fee_payment_hist_studentid_fkey; Type: FK CONSTRAINT; Schema: audit; Owner: postgres
--

ALTER TABLE ONLY fee_payment_hist
    ADD CONSTRAINT fee_payment_hist_studentid_fkey FOREIGN KEY (studentid) REFERENCES opuscollege.student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = opuscollege, pg_catalog;

--
-- TOC entry 4637 (class 2606 OID 128560)
-- Name: academicyear_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY branchacademicyeartimeunit
    ADD CONSTRAINT academicyear_fkey FOREIGN KEY (academicyearid) REFERENCES academicyear(id);


--
-- TOC entry 4629 (class 2606 OID 128565)
-- Name: acc_room_hostelid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_room
    ADD CONSTRAINT acc_room_hostelid_fkey FOREIGN KEY (hostelid) REFERENCES acc_hostel(id);


--
-- TOC entry 4630 (class 2606 OID 128570)
-- Name: acc_studentaccommodation_academicyearid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_studentaccommodation
    ADD CONSTRAINT acc_studentaccommodation_academicyearid_fkey FOREIGN KEY (academicyearid) REFERENCES academicyear(id);


--
-- TOC entry 4631 (class 2606 OID 128575)
-- Name: acc_studentaccommodation_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_studentaccommodation
    ADD CONSTRAINT acc_studentaccommodation_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid);


--
-- TOC entry 4632 (class 2606 OID 128580)
-- Name: acc_studentaccommodationresource_accommodationresourceid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_studentaccommodationresource
    ADD CONSTRAINT acc_studentaccommodationresource_accommodationresourceid_fkey FOREIGN KEY (accommodationresourceid) REFERENCES acc_accommodationresource(id);


--
-- TOC entry 4633 (class 2606 OID 128585)
-- Name: acc_studentaccommodationresource_studentaccommodationid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_studentaccommodationresource
    ADD CONSTRAINT acc_studentaccommodationresource_studentaccommodationid_fkey FOREIGN KEY (studentaccommodationid) REFERENCES acc_studentaccommodation(id);


--
-- TOC entry 4638 (class 2606 OID 128590)
-- Name: branch_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY branchacademicyeartimeunit
    ADD CONSTRAINT branch_fkey FOREIGN KEY (branchid) REFERENCES branch(id);


--
-- TOC entry 4636 (class 2606 OID 128595)
-- Name: branch_institutionid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY branch
    ADD CONSTRAINT branch_institutionid_fkey FOREIGN KEY (institutionid) REFERENCES institution(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4639 (class 2606 OID 128600)
-- Name: cardinaltimeunitstudygradetype_studygradetypeid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY cardinaltimeunitstudygradetype
    ADD CONSTRAINT cardinaltimeunitstudygradetype_studygradetypeid_fkey FOREIGN KEY (studygradetypeid) REFERENCES studygradetype(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4640 (class 2606 OID 128605)
-- Name: classgroup_studygradetypeid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY classgroup
    ADD CONSTRAINT classgroup_studygradetypeid_fkey FOREIGN KEY (studygradetypeid) REFERENCES studygradetype(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4641 (class 2606 OID 128610)
-- Name: contract_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT contract_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4642 (class 2606 OID 128615)
-- Name: endgrade_academicyearid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY endgrade
    ADD CONSTRAINT endgrade_academicyearid_fkey FOREIGN KEY (academicyearid) REFERENCES academicyear(id) ON UPDATE CASCADE;


--
-- TOC entry 4671 (class 2606 OID 128620)
-- Name: exam_studyplanid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studyplanresult
    ADD CONSTRAINT exam_studyplanid_fkey FOREIGN KEY (studyplanid) REFERENCES studyplan(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4643 (class 2606 OID 128625)
-- Name: examinationresult_examinationid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_examinationid_fkey FOREIGN KEY (examinationid) REFERENCES examination(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4644 (class 2606 OID 128630)
-- Name: examinationresult_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4645 (class 2606 OID 128635)
-- Name: examinationresult_studyplandetailid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_studyplandetailid_fkey FOREIGN KEY (studyplandetailid) REFERENCES studyplandetail(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4646 (class 2606 OID 128640)
-- Name: examinationresult_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4647 (class 2606 OID 128645)
-- Name: examinationteacher_classgroupid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationteacher
    ADD CONSTRAINT examinationteacher_classgroupid_fkey FOREIGN KEY (classgroupid) REFERENCES classgroup(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4648 (class 2606 OID 128650)
-- Name: examinationteacher_examinationid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationteacher
    ADD CONSTRAINT examinationteacher_examinationid_fkey FOREIGN KEY (examinationid) REFERENCES examination(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4649 (class 2606 OID 128655)
-- Name: examinationteacher_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationteacher
    ADD CONSTRAINT examinationteacher_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4650 (class 2606 OID 128660)
-- Name: fee_payment_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY fee_payment
    ADD CONSTRAINT fee_payment_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4627 (class 2606 OID 128665)
-- Name: fk_accommodationfee_feeid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_accommodationfee
    ADD CONSTRAINT fk_accommodationfee_feeid FOREIGN KEY (feeid) REFERENCES fee_fee(id) ON UPDATE CASCADE;


--
-- TOC entry 4628 (class 2606 OID 128670)
-- Name: fk_block_hostelid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_block
    ADD CONSTRAINT fk_block_hostelid FOREIGN KEY (hostelid) REFERENCES acc_hostel(id) ON UPDATE CASCADE;


--
-- TOC entry 4653 (class 2606 OID 128675)
-- Name: fk_complaintscholarshipid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_complaint
    ADD CONSTRAINT fk_complaintscholarshipid FOREIGN KEY (scholarshipapplicationid) REFERENCES sch_scholarshipapplication(id);


--
-- TOC entry 4655 (class 2606 OID 128680)
-- Name: fk_scholarshiptypeyearappliedforid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_scholarshipapplication
    ADD CONSTRAINT fk_scholarshiptypeyearappliedforid FOREIGN KEY (scholarshipappliedforid) REFERENCES sch_scholarship(id);


--
-- TOC entry 4656 (class 2606 OID 128685)
-- Name: fk_scholarshiptypeyeargrantedid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_scholarshipapplication
    ADD CONSTRAINT fk_scholarshiptypeyeargrantedid FOREIGN KEY (scholarshipgrantedid) REFERENCES sch_scholarship(id);


--
-- TOC entry 4654 (class 2606 OID 128690)
-- Name: fk_sponsor; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_scholarship
    ADD CONSTRAINT fk_sponsor FOREIGN KEY (sponsorid) REFERENCES sch_sponsor(id);


--
-- TOC entry 4658 (class 2606 OID 128695)
-- Name: fk_student; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_student
    ADD CONSTRAINT fk_student FOREIGN KEY (studentid) REFERENCES student(studentid);


--
-- TOC entry 4657 (class 2606 OID 128700)
-- Name: fk_studentscholarship; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_scholarshipapplication
    ADD CONSTRAINT fk_studentscholarship FOREIGN KEY (scholarshipstudentid) REFERENCES sch_student(scholarshipstudentid);


--
-- TOC entry 4659 (class 2606 OID 128705)
-- Name: fk_subsidysponsorid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_subsidy
    ADD CONSTRAINT fk_subsidysponsorid FOREIGN KEY (sponsorid) REFERENCES sch_sponsor(id);


--
-- TOC entry 4651 (class 2606 OID 128710)
-- Name: groupeddiscipline_disciplinegroupid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY groupeddiscipline
    ADD CONSTRAINT groupeddiscipline_disciplinegroupid_fkey FOREIGN KEY (disciplinegroupid) REFERENCES disciplinegroup(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4652 (class 2606 OID 128715)
-- Name: opususerrole_username_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY opususerrole
    ADD CONSTRAINT opususerrole_username_fkey FOREIGN KEY (username) REFERENCES opususer(username) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4634 (class 2606 OID 128720)
-- Name: organizationalunitacademicyear_academicyearid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY admissionregistrationconfig
    ADD CONSTRAINT organizationalunitacademicyear_academicyearid_fkey FOREIGN KEY (academicyearid) REFERENCES academicyear(id);


--
-- TOC entry 4635 (class 2606 OID 128725)
-- Name: organizationalunitacademicyear_organizationalunitid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY admissionregistrationconfig
    ADD CONSTRAINT organizationalunitacademicyear_organizationalunitid_fkey FOREIGN KEY (organizationalunitid) REFERENCES organizationalunit(id);


--
-- TOC entry 4660 (class 2606 OID 128730)
-- Name: staffmember_personid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY staffmember
    ADD CONSTRAINT staffmember_personid_fkey FOREIGN KEY (personid) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4661 (class 2606 OID 128735)
-- Name: staffmemberfunction_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY staffmemberfunction
    ADD CONSTRAINT staffmemberfunction_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4662 (class 2606 OID 128740)
-- Name: student_personid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY student
    ADD CONSTRAINT student_personid_fkey FOREIGN KEY (personid) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4663 (class 2606 OID 128745)
-- Name: studentabsence_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studentabsence
    ADD CONSTRAINT studentabsence_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4664 (class 2606 OID 128750)
-- Name: studentclassgroup_classgroupid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studentclassgroup
    ADD CONSTRAINT studentclassgroup_classgroupid_fkey FOREIGN KEY (classgroupid) REFERENCES classgroup(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4665 (class 2606 OID 128755)
-- Name: studentclassgroup_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studentclassgroup
    ADD CONSTRAINT studentclassgroup_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4666 (class 2606 OID 128760)
-- Name: studentexpulsion_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studentexpulsion
    ADD CONSTRAINT studentexpulsion_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4667 (class 2606 OID 128765)
-- Name: studentstudentstatus_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studentstudentstatus
    ADD CONSTRAINT studentstudentstatus_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4668 (class 2606 OID 128770)
-- Name: studyplan_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studyplan
    ADD CONSTRAINT studyplan_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE;


--
-- TOC entry 4669 (class 2606 OID 128775)
-- Name: studyplancardinaltimeunit_studyplanid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studyplancardinaltimeunit
    ADD CONSTRAINT studyplancardinaltimeunit_studyplanid_fkey FOREIGN KEY (studyplanid) REFERENCES studyplan(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4670 (class 2606 OID 128780)
-- Name: studyplandetail_studyplanid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studyplandetail
    ADD CONSTRAINT studyplandetail_studyplanid_fkey FOREIGN KEY (studyplanid) REFERENCES studyplan(id) ON UPDATE CASCADE;


--
-- TOC entry 4672 (class 2606 OID 128785)
-- Name: subjectblockstudygradetype_studygradetypeid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectblockstudygradetype
    ADD CONSTRAINT subjectblockstudygradetype_studygradetypeid_fkey FOREIGN KEY (studygradetypeid) REFERENCES studygradetype(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4673 (class 2606 OID 128790)
-- Name: subjectblockstudygradetype_subjectblockid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectblockstudygradetype
    ADD CONSTRAINT subjectblockstudygradetype_subjectblockid_fkey FOREIGN KEY (subjectblockid) REFERENCES subjectblock(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4674 (class 2606 OID 128795)
-- Name: subjectclassgroup_classgroupid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectclassgroup
    ADD CONSTRAINT subjectclassgroup_classgroupid_fkey FOREIGN KEY (classgroupid) REFERENCES classgroup(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4675 (class 2606 OID 128800)
-- Name: subjectclassgroup_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectclassgroup
    ADD CONSTRAINT subjectclassgroup_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4676 (class 2606 OID 128805)
-- Name: subjectresult_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectresult
    ADD CONSTRAINT subjectresult_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4677 (class 2606 OID 128810)
-- Name: subjectresult_studyplandetailid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectresult
    ADD CONSTRAINT subjectresult_studyplandetailid_fkey FOREIGN KEY (studyplandetailid) REFERENCES studyplandetail(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4678 (class 2606 OID 128815)
-- Name: subjectresult_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectresult
    ADD CONSTRAINT subjectresult_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4679 (class 2606 OID 128820)
-- Name: subjectstudygradetype_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectstudygradetype
    ADD CONSTRAINT subjectstudygradetype_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4680 (class 2606 OID 128825)
-- Name: subjectstudytype_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectstudytype
    ADD CONSTRAINT subjectstudytype_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4681 (class 2606 OID 128830)
-- Name: subjectsubjectblock_subjectblockid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectsubjectblock
    ADD CONSTRAINT subjectsubjectblock_subjectblockid_fkey FOREIGN KEY (subjectblockid) REFERENCES subjectblock(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4682 (class 2606 OID 128835)
-- Name: subjectsubjectblock_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectsubjectblock
    ADD CONSTRAINT subjectsubjectblock_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4683 (class 2606 OID 128840)
-- Name: subjectteacher_classgroupid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectteacher
    ADD CONSTRAINT subjectteacher_classgroupid_fkey FOREIGN KEY (classgroupid) REFERENCES classgroup(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4684 (class 2606 OID 128845)
-- Name: subjectteacher_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectteacher
    ADD CONSTRAINT subjectteacher_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4685 (class 2606 OID 128850)
-- Name: subjectteacher_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectteacher
    ADD CONSTRAINT subjectteacher_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4686 (class 2606 OID 128855)
-- Name: testresult_examinationid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_examinationid_fkey FOREIGN KEY (examinationid) REFERENCES examination(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4687 (class 2606 OID 128860)
-- Name: testresult_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4688 (class 2606 OID 128865)
-- Name: testresult_studyplandetailid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_studyplandetailid_fkey FOREIGN KEY (studyplandetailid) REFERENCES studyplandetail(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4689 (class 2606 OID 128870)
-- Name: testresult_testid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_testid_fkey FOREIGN KEY (testid) REFERENCES test(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4690 (class 2606 OID 128875)
-- Name: testteacher_classgroupid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testteacher
    ADD CONSTRAINT testteacher_classgroupid_fkey FOREIGN KEY (classgroupid) REFERENCES classgroup(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4691 (class 2606 OID 128880)
-- Name: testteacher_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testteacher
    ADD CONSTRAINT testteacher_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4692 (class 2606 OID 128885)
-- Name: testteacher_testid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testteacher
    ADD CONSTRAINT testteacher_testid_fkey FOREIGN KEY (testid) REFERENCES test(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 6
-- Name: audit; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA audit FROM PUBLIC;
REVOKE ALL ON SCHEMA audit FROM postgres;
GRANT ALL ON SCHEMA audit TO postgres;


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 7
-- Name: opuscollege; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA opuscollege FROM PUBLIC;
REVOKE ALL ON SCHEMA opuscollege FROM postgres;
GRANT ALL ON SCHEMA opuscollege TO postgres;


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 8
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 171
-- Name: organizationalunit; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE organizationalunit FROM PUBLIC;
REVOKE ALL ON TABLE organizationalunit FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE organizationalunit TO postgres;


SET search_path = audit, pg_catalog;

--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 173
-- Name: acc_accommodationfee_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE acc_accommodationfee_hist FROM PUBLIC;
REVOKE ALL ON TABLE acc_accommodationfee_hist FROM postgres;
GRANT ALL ON TABLE acc_accommodationfee_hist TO postgres;


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 174
-- Name: acc_block_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE acc_block_hist FROM PUBLIC;
REVOKE ALL ON TABLE acc_block_hist FROM postgres;
GRANT ALL ON TABLE acc_block_hist TO postgres;


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 175
-- Name: acc_hostel_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE acc_hostel_hist FROM PUBLIC;
REVOKE ALL ON TABLE acc_hostel_hist FROM postgres;
GRANT ALL ON TABLE acc_hostel_hist TO postgres;


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 176
-- Name: acc_room_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE acc_room_hist FROM PUBLIC;
REVOKE ALL ON TABLE acc_room_hist FROM postgres;
GRANT ALL ON TABLE acc_room_hist TO postgres;


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 177
-- Name: acc_studentaccommodation_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE acc_studentaccommodation_hist FROM PUBLIC;
REVOKE ALL ON TABLE acc_studentaccommodation_hist FROM postgres;
GRANT ALL ON TABLE acc_studentaccommodation_hist TO postgres;


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 178
-- Name: cardinaltimeunitresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE cardinaltimeunitresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE cardinaltimeunitresult_hist FROM postgres;
GRANT ALL ON TABLE cardinaltimeunitresult_hist TO postgres;


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 179
-- Name: endgrade_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE endgrade_hist FROM PUBLIC;
REVOKE ALL ON TABLE endgrade_hist FROM postgres;
GRANT ALL ON TABLE endgrade_hist TO postgres;


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 180
-- Name: examinationresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE examinationresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE examinationresult_hist FROM postgres;
GRANT ALL ON TABLE examinationresult_hist TO postgres;


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 181
-- Name: fee_fee_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE fee_fee_hist FROM PUBLIC;
REVOKE ALL ON TABLE fee_fee_hist FROM postgres;
GRANT ALL ON TABLE fee_fee_hist TO postgres;


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 182
-- Name: fee_payment_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE fee_payment_hist FROM PUBLIC;
REVOKE ALL ON TABLE fee_payment_hist FROM postgres;
GRANT ALL ON TABLE fee_payment_hist TO postgres;


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 183
-- Name: financialrequest_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE financialrequest_hist FROM PUBLIC;
REVOKE ALL ON TABLE financialrequest_hist FROM postgres;
GRANT ALL ON TABLE financialrequest_hist TO postgres;


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 184
-- Name: financialtransaction_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE financialtransaction_hist FROM PUBLIC;
REVOKE ALL ON TABLE financialtransaction_hist FROM postgres;
GRANT ALL ON TABLE financialtransaction_hist TO postgres;


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 185
-- Name: gradedsecondaryschoolsubject_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE gradedsecondaryschoolsubject_hist FROM PUBLIC;
REVOKE ALL ON TABLE gradedsecondaryschoolsubject_hist FROM postgres;
GRANT ALL ON TABLE gradedsecondaryschoolsubject_hist TO postgres;


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 186
-- Name: opususerprivilege_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE opususerprivilege_hist FROM PUBLIC;
REVOKE ALL ON TABLE opususerprivilege_hist FROM postgres;
GRANT ALL ON TABLE opususerprivilege_hist TO postgres;


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 187
-- Name: staffmember_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE staffmember_hist FROM PUBLIC;
REVOKE ALL ON TABLE staffmember_hist FROM postgres;
GRANT ALL ON TABLE staffmember_hist TO postgres;


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 188
-- Name: student_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE student_hist FROM PUBLIC;
REVOKE ALL ON TABLE student_hist FROM postgres;
GRANT ALL ON TABLE student_hist TO postgres;


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 189
-- Name: studentabsence_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE studentabsence_hist FROM PUBLIC;
REVOKE ALL ON TABLE studentabsence_hist FROM postgres;
GRANT ALL ON TABLE studentabsence_hist TO postgres;


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 190
-- Name: studentbalance_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE studentbalance_hist FROM PUBLIC;
REVOKE ALL ON TABLE studentbalance_hist FROM postgres;
GRANT ALL ON TABLE studentbalance_hist TO postgres;


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 191
-- Name: studentexpulsion_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE studentexpulsion_hist FROM PUBLIC;
REVOKE ALL ON TABLE studentexpulsion_hist FROM postgres;
GRANT ALL ON TABLE studentexpulsion_hist TO postgres;


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 192
-- Name: studyplanresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE studyplanresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE studyplanresult_hist FROM postgres;
GRANT ALL ON TABLE studyplanresult_hist TO postgres;


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 193
-- Name: subjectresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE subjectresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE subjectresult_hist FROM postgres;
GRANT ALL ON TABLE subjectresult_hist TO postgres;


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 194
-- Name: testresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE testresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE testresult_hist FROM postgres;
GRANT ALL ON TABLE testresult_hist TO postgres;


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 195
-- Name: thesisresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE thesisresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE thesisresult_hist FROM postgres;
GRANT ALL ON TABLE thesisresult_hist TO postgres;


SET search_path = opuscollege, pg_catalog;

--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 197
-- Name: academicfield; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE academicfield FROM PUBLIC;
REVOKE ALL ON TABLE academicfield FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE academicfield TO postgres;


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 199
-- Name: academicyear; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE academicyear FROM PUBLIC;
REVOKE ALL ON TABLE academicyear FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE academicyear TO postgres;


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 201
-- Name: acc_accommodationfee; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_accommodationfee FROM PUBLIC;
REVOKE ALL ON TABLE acc_accommodationfee FROM postgres;
GRANT ALL ON TABLE acc_accommodationfee TO postgres;


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 204
-- Name: acc_accommodationresource; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_accommodationresource FROM PUBLIC;
REVOKE ALL ON TABLE acc_accommodationresource FROM postgres;
GRANT ALL ON TABLE acc_accommodationresource TO postgres;


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 207
-- Name: acc_block; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_block FROM PUBLIC;
REVOKE ALL ON TABLE acc_block FROM postgres;
GRANT ALL ON TABLE acc_block TO postgres;


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 209
-- Name: acc_hostel; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_hostel FROM PUBLIC;
REVOKE ALL ON TABLE acc_hostel FROM postgres;
GRANT ALL ON TABLE acc_hostel TO postgres;


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 211
-- Name: acc_hosteltype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_hosteltype FROM PUBLIC;
REVOKE ALL ON TABLE acc_hosteltype FROM postgres;
GRANT ALL ON TABLE acc_hosteltype TO postgres;


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 213
-- Name: acc_room; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_room FROM PUBLIC;
REVOKE ALL ON TABLE acc_room FROM postgres;
GRANT ALL ON TABLE acc_room TO postgres;


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 215
-- Name: acc_roomtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_roomtype FROM PUBLIC;
REVOKE ALL ON TABLE acc_roomtype FROM postgres;
GRANT ALL ON TABLE acc_roomtype TO postgres;


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 217
-- Name: acc_studentaccommodation; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_studentaccommodation FROM PUBLIC;
REVOKE ALL ON TABLE acc_studentaccommodation FROM postgres;
GRANT ALL ON TABLE acc_studentaccommodation TO postgres;


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 219
-- Name: acc_studentaccommodationresource; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_studentaccommodationresource FROM PUBLIC;
REVOKE ALL ON TABLE acc_studentaccommodationresource FROM postgres;
GRANT ALL ON TABLE acc_studentaccommodationresource TO postgres;


--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 222
-- Name: address; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE address FROM PUBLIC;
REVOKE ALL ON TABLE address FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE address TO postgres;


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 224
-- Name: addresstype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE addresstype FROM PUBLIC;
REVOKE ALL ON TABLE addresstype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE addresstype TO postgres;


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 226
-- Name: administrativepost; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE administrativepost FROM PUBLIC;
REVOKE ALL ON TABLE administrativepost FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE administrativepost TO postgres;


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 230
-- Name: appconfig; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE appconfig FROM PUBLIC;
REVOKE ALL ON TABLE appconfig FROM postgres;
GRANT ALL ON TABLE appconfig TO postgres;


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 232
-- Name: applicantcategory; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE applicantcategory FROM PUBLIC;
REVOKE ALL ON TABLE applicantcategory FROM postgres;
GRANT ALL ON TABLE applicantcategory TO postgres;


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 234
-- Name: appointmenttype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE appointmenttype FROM PUBLIC;
REVOKE ALL ON TABLE appointmenttype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE appointmenttype TO postgres;


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 236
-- Name: appversions; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE appversions FROM PUBLIC;
REVOKE ALL ON TABLE appversions FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE appversions TO postgres;


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 237
-- Name: authorisation; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE authorisation FROM PUBLIC;
REVOKE ALL ON TABLE authorisation FROM postgres;
GRANT ALL ON TABLE authorisation TO postgres;


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 239
-- Name: blocktype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE blocktype FROM PUBLIC;
REVOKE ALL ON TABLE blocktype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE blocktype TO postgres;


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 241
-- Name: bloodtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE bloodtype FROM PUBLIC;
REVOKE ALL ON TABLE bloodtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE bloodtype TO postgres;


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 243
-- Name: branch; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE branch FROM PUBLIC;
REVOKE ALL ON TABLE branch FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE branch TO postgres;


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 247
-- Name: cardinaltimeunit; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE cardinaltimeunit FROM PUBLIC;
REVOKE ALL ON TABLE cardinaltimeunit FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE cardinaltimeunit TO postgres;


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 249
-- Name: cardinaltimeunitresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE cardinaltimeunitresult FROM PUBLIC;
REVOKE ALL ON TABLE cardinaltimeunitresult FROM postgres;
GRANT ALL ON TABLE cardinaltimeunitresult TO postgres;


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 251
-- Name: cardinaltimeunitstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE cardinaltimeunitstatus FROM PUBLIC;
REVOKE ALL ON TABLE cardinaltimeunitstatus FROM postgres;
GRANT ALL ON TABLE cardinaltimeunitstatus TO postgres;


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 253
-- Name: cardinaltimeunitstudygradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE cardinaltimeunitstudygradetype FROM PUBLIC;
REVOKE ALL ON TABLE cardinaltimeunitstudygradetype FROM postgres;
GRANT ALL ON TABLE cardinaltimeunitstudygradetype TO postgres;


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 255
-- Name: careerposition; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE careerposition FROM PUBLIC;
REVOKE ALL ON TABLE careerposition FROM postgres;
GRANT ALL ON TABLE careerposition TO postgres;


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 257
-- Name: civilstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE civilstatus FROM PUBLIC;
REVOKE ALL ON TABLE civilstatus FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE civilstatus TO postgres;


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 259
-- Name: civiltitle; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE civiltitle FROM PUBLIC;
REVOKE ALL ON TABLE civiltitle FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE civiltitle TO postgres;


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 261
-- Name: classgroup; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE classgroup FROM PUBLIC;
REVOKE ALL ON TABLE classgroup FROM postgres;
GRANT ALL ON TABLE classgroup TO postgres;


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 263
-- Name: contract; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE contract FROM PUBLIC;
REVOKE ALL ON TABLE contract FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE contract TO postgres;


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 265
-- Name: contractduration; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE contractduration FROM PUBLIC;
REVOKE ALL ON TABLE contractduration FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE contractduration TO postgres;


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 267
-- Name: contracttype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE contracttype FROM PUBLIC;
REVOKE ALL ON TABLE contracttype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE contracttype TO postgres;


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 269
-- Name: country; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE country FROM PUBLIC;
REVOKE ALL ON TABLE country FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE country TO postgres;


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 271
-- Name: daypart; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE daypart FROM PUBLIC;
REVOKE ALL ON TABLE daypart FROM postgres;
GRANT ALL ON TABLE daypart TO postgres;


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 273
-- Name: discipline; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE discipline FROM PUBLIC;
REVOKE ALL ON TABLE discipline FROM postgres;
GRANT ALL ON TABLE discipline TO postgres;


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 275
-- Name: disciplinegroup; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE disciplinegroup FROM PUBLIC;
REVOKE ALL ON TABLE disciplinegroup FROM postgres;
GRANT ALL ON TABLE disciplinegroup TO postgres;


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 277
-- Name: district; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE district FROM PUBLIC;
REVOKE ALL ON TABLE district FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE district TO postgres;


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 279
-- Name: educationarea; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE educationarea FROM PUBLIC;
REVOKE ALL ON TABLE educationarea FROM postgres;
GRANT ALL ON TABLE educationarea TO postgres;


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 281
-- Name: educationlevel; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE educationlevel FROM PUBLIC;
REVOKE ALL ON TABLE educationlevel FROM postgres;
GRANT ALL ON TABLE educationlevel TO postgres;


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 283
-- Name: educationtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE educationtype FROM PUBLIC;
REVOKE ALL ON TABLE educationtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE educationtype TO postgres;


--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 285
-- Name: endgrade; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE endgrade FROM PUBLIC;
REVOKE ALL ON TABLE endgrade FROM postgres;
GRANT ALL ON TABLE endgrade TO postgres;


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 287
-- Name: endgradegeneral; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE endgradegeneral FROM PUBLIC;
REVOKE ALL ON TABLE endgradegeneral FROM postgres;
GRANT ALL ON TABLE endgradegeneral TO postgres;


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 289
-- Name: endgradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE endgradetype FROM PUBLIC;
REVOKE ALL ON TABLE endgradetype FROM postgres;
GRANT ALL ON TABLE endgradetype TO postgres;


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 292
-- Name: examination; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE examination FROM PUBLIC;
REVOKE ALL ON TABLE examination FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE examination TO postgres;


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 294
-- Name: examinationresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE examinationresult FROM PUBLIC;
REVOKE ALL ON TABLE examinationresult FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE examinationresult TO postgres;


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 296
-- Name: examinationteacher; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE examinationteacher FROM PUBLIC;
REVOKE ALL ON TABLE examinationteacher FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE examinationteacher TO postgres;


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 298
-- Name: examinationtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE examinationtype FROM PUBLIC;
REVOKE ALL ON TABLE examinationtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE examinationtype TO postgres;


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 301
-- Name: examtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE examtype FROM PUBLIC;
REVOKE ALL ON TABLE examtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE examtype TO postgres;


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 304
-- Name: expellationtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE expellationtype FROM PUBLIC;
REVOKE ALL ON TABLE expellationtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE expellationtype TO postgres;


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 306
-- Name: failgrade; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE failgrade FROM PUBLIC;
REVOKE ALL ON TABLE failgrade FROM postgres;
GRANT ALL ON TABLE failgrade TO postgres;


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 308
-- Name: fee_fee; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE fee_fee FROM PUBLIC;
REVOKE ALL ON TABLE fee_fee FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE fee_fee TO postgres;


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 310
-- Name: fee_feecategory; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE fee_feecategory FROM PUBLIC;
REVOKE ALL ON TABLE fee_feecategory FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE fee_feecategory TO postgres;


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 312
-- Name: fee_payment; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE fee_payment FROM PUBLIC;
REVOKE ALL ON TABLE fee_payment FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE fee_payment TO postgres;


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 314
-- Name: fieldofeducation; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE fieldofeducation FROM PUBLIC;
REVOKE ALL ON TABLE fieldofeducation FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE fieldofeducation TO postgres;


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 316
-- Name: financialrequest; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE financialrequest FROM PUBLIC;
REVOKE ALL ON TABLE financialrequest FROM postgres;
GRANT ALL ON TABLE financialrequest TO postgres;


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 318
-- Name: financialtransaction; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE financialtransaction FROM PUBLIC;
REVOKE ALL ON TABLE financialtransaction FROM postgres;
GRANT ALL ON TABLE financialtransaction TO postgres;


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 320
-- Name: frequency; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE frequency FROM PUBLIC;
REVOKE ALL ON TABLE frequency FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE frequency TO postgres;


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 322
-- Name: function; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE function FROM PUBLIC;
REVOKE ALL ON TABLE function FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE function TO postgres;


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 324
-- Name: functionlevel; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE functionlevel FROM PUBLIC;
REVOKE ALL ON TABLE functionlevel FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE functionlevel TO postgres;


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 326
-- Name: gender; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE gender FROM PUBLIC;
REVOKE ALL ON TABLE gender FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE gender TO postgres;


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 328
-- Name: gradedsecondaryschoolsubject; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE gradedsecondaryschoolsubject FROM PUBLIC;
REVOKE ALL ON TABLE gradedsecondaryschoolsubject FROM postgres;
GRANT ALL ON TABLE gradedsecondaryschoolsubject TO postgres;


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 330
-- Name: gradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE gradetype FROM PUBLIC;
REVOKE ALL ON TABLE gradetype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE gradetype TO postgres;


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 332
-- Name: groupeddiscipline; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE groupeddiscipline FROM PUBLIC;
REVOKE ALL ON TABLE groupeddiscipline FROM postgres;
GRANT ALL ON TABLE groupeddiscipline TO postgres;


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 334
-- Name: groupedsecondaryschoolsubject; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE groupedsecondaryschoolsubject FROM PUBLIC;
REVOKE ALL ON TABLE groupedsecondaryschoolsubject FROM postgres;
GRANT ALL ON TABLE groupedsecondaryschoolsubject TO postgres;


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 336
-- Name: identificationtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE identificationtype FROM PUBLIC;
REVOKE ALL ON TABLE identificationtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE identificationtype TO postgres;


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 338
-- Name: importancetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE importancetype FROM PUBLIC;
REVOKE ALL ON TABLE importancetype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE importancetype TO postgres;


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 340
-- Name: institution; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE institution FROM PUBLIC;
REVOKE ALL ON TABLE institution FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE institution TO postgres;


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 342
-- Name: language; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE language FROM PUBLIC;
REVOKE ALL ON TABLE language FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE language TO postgres;


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 344
-- Name: levelofeducation; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE levelofeducation FROM PUBLIC;
REVOKE ALL ON TABLE levelofeducation FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE levelofeducation TO postgres;


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 346
-- Name: logmailerror; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE logmailerror FROM PUBLIC;
REVOKE ALL ON TABLE logmailerror FROM postgres;
GRANT ALL ON TABLE logmailerror TO postgres;


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 348
-- Name: logrequesterror; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE logrequesterror FROM PUBLIC;
REVOKE ALL ON TABLE logrequesterror FROM postgres;
GRANT ALL ON TABLE logrequesterror TO postgres;


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 350
-- Name: lookuptable; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE lookuptable FROM PUBLIC;
REVOKE ALL ON TABLE lookuptable FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE lookuptable TO postgres;


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 352
-- Name: mailconfig; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE mailconfig FROM PUBLIC;
REVOKE ALL ON TABLE mailconfig FROM postgres;
GRANT ALL ON TABLE mailconfig TO postgres;


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 354
-- Name: masteringlevel; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE masteringlevel FROM PUBLIC;
REVOKE ALL ON TABLE masteringlevel FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE masteringlevel TO postgres;


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 356
-- Name: nationality; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE nationality FROM PUBLIC;
REVOKE ALL ON TABLE nationality FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE nationality TO postgres;


--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 358
-- Name: nationalitygroup; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE nationalitygroup FROM PUBLIC;
REVOKE ALL ON TABLE nationalitygroup FROM postgres;
GRANT ALL ON TABLE nationalitygroup TO postgres;


--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 360
-- Name: obtainedqualification; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE obtainedqualification FROM PUBLIC;
REVOKE ALL ON TABLE obtainedqualification FROM postgres;
GRANT ALL ON TABLE obtainedqualification TO postgres;


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 362
-- Name: opusprivilege; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE opusprivilege FROM PUBLIC;
REVOKE ALL ON TABLE opusprivilege FROM postgres;
GRANT ALL ON TABLE opusprivilege TO postgres;


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 364
-- Name: opusrole_privilege; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE opusrole_privilege FROM PUBLIC;
REVOKE ALL ON TABLE opusrole_privilege FROM postgres;
GRANT ALL ON TABLE opusrole_privilege TO postgres;


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 366
-- Name: opususer; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE opususer FROM PUBLIC;
REVOKE ALL ON TABLE opususer FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE opususer TO postgres;


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 368
-- Name: opususerrole; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE opususerrole FROM PUBLIC;
REVOKE ALL ON TABLE opususerrole FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE opususerrole TO postgres;


--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 370
-- Name: penalty; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE penalty FROM PUBLIC;
REVOKE ALL ON TABLE penalty FROM postgres;
GRANT ALL ON TABLE penalty TO postgres;


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 372
-- Name: penaltytype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE penaltytype FROM PUBLIC;
REVOKE ALL ON TABLE penaltytype FROM postgres;
GRANT ALL ON TABLE penaltytype TO postgres;


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 374
-- Name: person; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE person FROM PUBLIC;
REVOKE ALL ON TABLE person FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE person TO postgres;


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 376
-- Name: profession; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE profession FROM PUBLIC;
REVOKE ALL ON TABLE profession FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE profession TO postgres;


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 378
-- Name: progressstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE progressstatus FROM PUBLIC;
REVOKE ALL ON TABLE progressstatus FROM postgres;
GRANT ALL ON TABLE progressstatus TO postgres;


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 380
-- Name: province; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE province FROM PUBLIC;
REVOKE ALL ON TABLE province FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE province TO postgres;


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 382
-- Name: referee; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE referee FROM PUBLIC;
REVOKE ALL ON TABLE referee FROM postgres;
GRANT ALL ON TABLE referee TO postgres;


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 384
-- Name: relationtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE relationtype FROM PUBLIC;
REVOKE ALL ON TABLE relationtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE relationtype TO postgres;


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 386
-- Name: reportproperty; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE reportproperty FROM PUBLIC;
REVOKE ALL ON TABLE reportproperty FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE reportproperty TO postgres;


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 387
-- Name: requestadmissionperiod; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE requestadmissionperiod FROM PUBLIC;
REVOKE ALL ON TABLE requestadmissionperiod FROM postgres;
GRANT ALL ON TABLE requestadmissionperiod TO postgres;


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 391
-- Name: rfcstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE rfcstatus FROM PUBLIC;
REVOKE ALL ON TABLE rfcstatus FROM postgres;
GRANT ALL ON TABLE rfcstatus TO postgres;


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 393
-- Name: rigiditytype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE rigiditytype FROM PUBLIC;
REVOKE ALL ON TABLE rigiditytype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE rigiditytype TO postgres;


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 395
-- Name: role; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE role FROM PUBLIC;
REVOKE ALL ON TABLE role FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE role TO postgres;


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 397
-- Name: sch_bank; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_bank FROM PUBLIC;
REVOKE ALL ON TABLE sch_bank FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_bank TO postgres;


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 399
-- Name: sch_complaint; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_complaint FROM PUBLIC;
REVOKE ALL ON TABLE sch_complaint FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_complaint TO postgres;


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 401
-- Name: sch_complaintstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_complaintstatus FROM PUBLIC;
REVOKE ALL ON TABLE sch_complaintstatus FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_complaintstatus TO postgres;


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 403
-- Name: sch_decisioncriteria; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_decisioncriteria FROM PUBLIC;
REVOKE ALL ON TABLE sch_decisioncriteria FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_decisioncriteria TO postgres;


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 405
-- Name: sch_scholarship; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_scholarship FROM PUBLIC;
REVOKE ALL ON TABLE sch_scholarship FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_scholarship TO postgres;


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 407
-- Name: sch_scholarshipapplication; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_scholarshipapplication FROM PUBLIC;
REVOKE ALL ON TABLE sch_scholarshipapplication FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_scholarshipapplication TO postgres;


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 409
-- Name: sch_scholarshiptype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_scholarshiptype FROM PUBLIC;
REVOKE ALL ON TABLE sch_scholarshiptype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_scholarshiptype TO postgres;


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 411
-- Name: sch_sponsor; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_sponsor FROM PUBLIC;
REVOKE ALL ON TABLE sch_sponsor FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_sponsor TO postgres;


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 413
-- Name: sch_sponsorfeepercentage; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_sponsorfeepercentage FROM PUBLIC;
REVOKE ALL ON TABLE sch_sponsorfeepercentage FROM postgres;
GRANT ALL ON TABLE sch_sponsorfeepercentage TO postgres;


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 415
-- Name: sch_sponsorpayment; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_sponsorpayment FROM PUBLIC;
REVOKE ALL ON TABLE sch_sponsorpayment FROM postgres;
GRANT ALL ON TABLE sch_sponsorpayment TO postgres;


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 417
-- Name: sch_sponsortype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_sponsortype FROM PUBLIC;
REVOKE ALL ON TABLE sch_sponsortype FROM postgres;
GRANT ALL ON TABLE sch_sponsortype TO postgres;


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 419
-- Name: sch_student; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_student FROM PUBLIC;
REVOKE ALL ON TABLE sch_student FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_student TO postgres;


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 421
-- Name: sch_subsidy; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_subsidy FROM PUBLIC;
REVOKE ALL ON TABLE sch_subsidy FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_subsidy TO postgres;


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 423
-- Name: sch_subsidytype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_subsidytype FROM PUBLIC;
REVOKE ALL ON TABLE sch_subsidytype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_subsidytype TO postgres;


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 425
-- Name: secondaryschoolsubject; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE secondaryschoolsubject FROM PUBLIC;
REVOKE ALL ON TABLE secondaryschoolsubject FROM postgres;
GRANT ALL ON TABLE secondaryschoolsubject TO postgres;


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 427
-- Name: secondaryschoolsubjectgroup; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE secondaryschoolsubjectgroup FROM PUBLIC;
REVOKE ALL ON TABLE secondaryschoolsubjectgroup FROM postgres;
GRANT ALL ON TABLE secondaryschoolsubjectgroup TO postgres;


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 429
-- Name: staffmember; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE staffmember FROM PUBLIC;
REVOKE ALL ON TABLE staffmember FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE staffmember TO postgres;


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 430
-- Name: staffmemberfunction; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE staffmemberfunction FROM PUBLIC;
REVOKE ALL ON TABLE staffmemberfunction FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE staffmemberfunction TO postgres;


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 432
-- Name: stafftype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE stafftype FROM PUBLIC;
REVOKE ALL ON TABLE stafftype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE stafftype TO postgres;


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 434
-- Name: status; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE status FROM PUBLIC;
REVOKE ALL ON TABLE status FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE status TO postgres;


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 436
-- Name: student; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE student FROM PUBLIC;
REVOKE ALL ON TABLE student FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE student TO postgres;


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 438
-- Name: studentabsence; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentabsence FROM PUBLIC;
REVOKE ALL ON TABLE studentabsence FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studentabsence TO postgres;


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 440
-- Name: studentactivity; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentactivity FROM PUBLIC;
REVOKE ALL ON TABLE studentactivity FROM postgres;
GRANT ALL ON TABLE studentactivity TO postgres;


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 442
-- Name: studentbalance; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentbalance FROM PUBLIC;
REVOKE ALL ON TABLE studentbalance FROM postgres;
GRANT ALL ON TABLE studentbalance TO postgres;


--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 444
-- Name: studentcareer; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentcareer FROM PUBLIC;
REVOKE ALL ON TABLE studentcareer FROM postgres;
GRANT ALL ON TABLE studentcareer TO postgres;


--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 446
-- Name: studentclassgroup; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentclassgroup FROM PUBLIC;
REVOKE ALL ON TABLE studentclassgroup FROM postgres;
GRANT ALL ON TABLE studentclassgroup TO postgres;


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 448
-- Name: studentcounseling; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentcounseling FROM PUBLIC;
REVOKE ALL ON TABLE studentcounseling FROM postgres;
GRANT ALL ON TABLE studentcounseling TO postgres;


--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 450
-- Name: studentexpulsion; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentexpulsion FROM PUBLIC;
REVOKE ALL ON TABLE studentexpulsion FROM postgres;
GRANT ALL ON TABLE studentexpulsion TO postgres;


--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 452
-- Name: studentplacement; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentplacement FROM PUBLIC;
REVOKE ALL ON TABLE studentplacement FROM postgres;
GRANT ALL ON TABLE studentplacement TO postgres;


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 454
-- Name: studentstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentstatus FROM PUBLIC;
REVOKE ALL ON TABLE studentstatus FROM postgres;
GRANT ALL ON TABLE studentstatus TO postgres;


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 456
-- Name: studentstudentstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentstudentstatus FROM PUBLIC;
REVOKE ALL ON TABLE studentstudentstatus FROM postgres;
GRANT ALL ON TABLE studentstudentstatus TO postgres;


--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 458
-- Name: study; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE study FROM PUBLIC;
REVOKE ALL ON TABLE study FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE study TO postgres;


--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 460
-- Name: studyform; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyform FROM PUBLIC;
REVOKE ALL ON TABLE studyform FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studyform TO postgres;


--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 462
-- Name: studygradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studygradetype FROM PUBLIC;
REVOKE ALL ON TABLE studygradetype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studygradetype TO postgres;


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 463
-- Name: studygradetypeprerequisite; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studygradetypeprerequisite FROM PUBLIC;
REVOKE ALL ON TABLE studygradetypeprerequisite FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studygradetypeprerequisite TO postgres;


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 465
-- Name: studyintensity; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyintensity FROM PUBLIC;
REVOKE ALL ON TABLE studyintensity FROM postgres;
GRANT ALL ON TABLE studyintensity TO postgres;


--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 467
-- Name: studyplan; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyplan FROM PUBLIC;
REVOKE ALL ON TABLE studyplan FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studyplan TO postgres;


--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 469
-- Name: studyplancardinaltimeunit; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyplancardinaltimeunit FROM PUBLIC;
REVOKE ALL ON TABLE studyplancardinaltimeunit FROM postgres;
GRANT ALL ON TABLE studyplancardinaltimeunit TO postgres;


--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 471
-- Name: studyplandetail; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyplandetail FROM PUBLIC;
REVOKE ALL ON TABLE studyplandetail FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studyplandetail TO postgres;


--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 472
-- Name: studyplanresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyplanresult FROM PUBLIC;
REVOKE ALL ON TABLE studyplanresult FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studyplanresult TO postgres;


--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 474
-- Name: studyplanstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyplanstatus FROM PUBLIC;
REVOKE ALL ON TABLE studyplanstatus FROM postgres;
GRANT ALL ON TABLE studyplanstatus TO postgres;


--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 476
-- Name: studytime; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studytime FROM PUBLIC;
REVOKE ALL ON TABLE studytime FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studytime TO postgres;


--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 478
-- Name: studytype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studytype FROM PUBLIC;
REVOKE ALL ON TABLE studytype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studytype TO postgres;


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 480
-- Name: subject; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subject FROM PUBLIC;
REVOKE ALL ON TABLE subject FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subject TO postgres;


--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 482
-- Name: subjectblock; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectblock FROM PUBLIC;
REVOKE ALL ON TABLE subjectblock FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectblock TO postgres;


--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 483
-- Name: subjectblockprerequisite; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectblockprerequisite FROM PUBLIC;
REVOKE ALL ON TABLE subjectblockprerequisite FROM postgres;
GRANT ALL ON TABLE subjectblockprerequisite TO postgres;


--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 485
-- Name: subjectblockstudygradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectblockstudygradetype FROM PUBLIC;
REVOKE ALL ON TABLE subjectblockstudygradetype FROM postgres;
GRANT ALL ON TABLE subjectblockstudygradetype TO postgres;


--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 487
-- Name: subjectclassgroup; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectclassgroup FROM PUBLIC;
REVOKE ALL ON TABLE subjectclassgroup FROM postgres;
GRANT ALL ON TABLE subjectclassgroup TO postgres;


--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 488
-- Name: subjectprerequisite; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectprerequisite FROM PUBLIC;
REVOKE ALL ON TABLE subjectprerequisite FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectprerequisite TO postgres;


--
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 490
-- Name: subjectresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectresult FROM PUBLIC;
REVOKE ALL ON TABLE subjectresult FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectresult TO postgres;


--
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 492
-- Name: subjectstudygradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectstudygradetype FROM PUBLIC;
REVOKE ALL ON TABLE subjectstudygradetype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectstudygradetype TO postgres;


--
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 494
-- Name: subjectstudytype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectstudytype FROM PUBLIC;
REVOKE ALL ON TABLE subjectstudytype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectstudytype TO postgres;


--
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 496
-- Name: subjectsubjectblock; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectsubjectblock FROM PUBLIC;
REVOKE ALL ON TABLE subjectsubjectblock FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectsubjectblock TO postgres;


--
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 498
-- Name: subjectteacher; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectteacher FROM PUBLIC;
REVOKE ALL ON TABLE subjectteacher FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectteacher TO postgres;


--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 500
-- Name: tabledependency; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE tabledependency FROM PUBLIC;
REVOKE ALL ON TABLE tabledependency FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE tabledependency TO postgres;


--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 502
-- Name: targetgroup; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE targetgroup FROM PUBLIC;
REVOKE ALL ON TABLE targetgroup FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE targetgroup TO postgres;


--
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 504
-- Name: test; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE test FROM PUBLIC;
REVOKE ALL ON TABLE test FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE test TO postgres;


--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 506
-- Name: testresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE testresult FROM PUBLIC;
REVOKE ALL ON TABLE testresult FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE testresult TO postgres;


--
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 508
-- Name: testteacher; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE testteacher FROM PUBLIC;
REVOKE ALL ON TABLE testteacher FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE testteacher TO postgres;


--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 510
-- Name: thesis; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE thesis FROM PUBLIC;
REVOKE ALL ON TABLE thesis FROM postgres;
GRANT ALL ON TABLE thesis TO postgres;


--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 512
-- Name: thesisresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE thesisresult FROM PUBLIC;
REVOKE ALL ON TABLE thesisresult FROM postgres;
GRANT ALL ON TABLE thesisresult TO postgres;


--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 514
-- Name: thesisstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE thesisstatus FROM PUBLIC;
REVOKE ALL ON TABLE thesisstatus FROM postgres;
GRANT ALL ON TABLE thesisstatus TO postgres;


--
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 516
-- Name: thesissupervisor; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE thesissupervisor FROM PUBLIC;
REVOKE ALL ON TABLE thesissupervisor FROM postgres;
GRANT ALL ON TABLE thesissupervisor TO postgres;


--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 518
-- Name: thesisthesisstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE thesisthesisstatus FROM PUBLIC;
REVOKE ALL ON TABLE thesisthesisstatus FROM postgres;
GRANT ALL ON TABLE thesisthesisstatus TO postgres;


--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 521
-- Name: unitarea; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE unitarea FROM PUBLIC;
REVOKE ALL ON TABLE unitarea FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE unitarea TO postgres;


--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 523
-- Name: unittype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE unittype FROM PUBLIC;
REVOKE ALL ON TABLE unittype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE unittype TO postgres;


-- Completed on 2014-03-28 13:44:27

--
-- PostgreSQL database dump complete
--

