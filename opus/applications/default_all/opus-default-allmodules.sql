--
-- PostgreSQL database dump
--

-- Started on 2012-11-11 12:41:20

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 6 (class 2615 OID 39757)
-- Name: audit; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA audit;


ALTER SCHEMA audit OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 39758)
-- Name: opuscollege; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA opuscollege;


ALTER SCHEMA opuscollege OWNER TO postgres;

--
-- TOC entry 1023 (class 2612 OID 39761)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = opuscollege, pg_catalog;

--
-- TOC entry 2210 (class 1259 OID 39762)
-- Dependencies: 7
-- Name: organizationalunitseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE organizationalunitseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.organizationalunitseq OWNER TO postgres;

--
-- TOC entry 4501 (class 0 OID 0)
-- Dependencies: 2210
-- Name: organizationalunitseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('organizationalunitseq', 134, true);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 2211 (class 1259 OID 39764)
-- Dependencies: 2831 2832 2833 2834 2835 2836 2837 7
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
-- TOC entry 2212 (class 1259 OID 39777)
-- Dependencies: 2838 2839 2840 2841 2842 2843 2844 2211 7
-- Name: node_relationships_n_level; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE node_relationships_n_level (
    level integer
)
INHERITS (organizationalunit);


ALTER TABLE opuscollege.node_relationships_n_level OWNER TO postgres;

--
-- TOC entry 21 (class 1255 OID 39790)
-- Dependencies: 7 313 1023
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
-- TOC entry 22 (class 1255 OID 39791)
-- Dependencies: 7
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
-- TOC entry 23 (class 1255 OID 39792)
-- Dependencies: 7 1023
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
-- TOC entry 24 (class 1255 OID 39793)
-- Dependencies: 1023 7
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
-- TOC entry 25 (class 1255 OID 39794)
-- Dependencies: 1023 7
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
-- TOC entry 2213 (class 1259 OID 39795)
-- Dependencies: 2845 2846 6
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
-- TOC entry 2214 (class 1259 OID 39803)
-- Dependencies: 2847 2848 6
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
-- TOC entry 2215 (class 1259 OID 39811)
-- Dependencies: 2849 2850 6
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
-- TOC entry 2216 (class 1259 OID 39819)
-- Dependencies: 2851 2852 6
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
-- TOC entry 2217 (class 1259 OID 39827)
-- Dependencies: 2853 2854 6
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
-- TOC entry 2218 (class 1259 OID 39835)
-- Dependencies: 2855 2856 2857 2858 2859 2860 6
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
-- TOC entry 2219 (class 1259 OID 39847)
-- Dependencies: 2861 2862 6
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
-- TOC entry 2220 (class 1259 OID 39855)
-- Dependencies: 2863 2864 2865 6
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
-- TOC entry 2221 (class 1259 OID 39864)
-- Dependencies: 2866 2867 2868 2869 2870 2871 2872 2873 2874 2875 2876 2877 2878 2879 2880 2881 2882 6
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
    branchid integer DEFAULT 0 NOT NULL,
    studyintensitycode character varying,
    feeunitcode character varying,
    applicationmode character(1),
    cardinaltimeunitnumber integer DEFAULT 0 NOT NULL,
    CONSTRAINT fee_fee_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.fee_fee_hist OWNER TO postgres;

--
-- TOC entry 2222 (class 1259 OID 39887)
-- Dependencies: 2883 2884 6
-- Name: fee_feedeadline_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE fee_feedeadline_hist (
    operation character(1) NOT NULL,
    id integer,
    feeid integer,
    deadline date,
    active character(1),
    writewho character varying,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    cardinaltimeunitcode character varying,
    cardinaltimeunitnumber integer,
    CONSTRAINT fee_feedeadline_hist_operation_check CHECK ((operation = ANY (ARRAY['I'::bpchar, 'D'::bpchar, 'U'::bpchar])))
);


ALTER TABLE audit.fee_feedeadline_hist OWNER TO postgres;

--
-- TOC entry 2223 (class 1259 OID 39895)
-- Dependencies: 2885 2886 2887 2888 2889 2890 2891 2892 6
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
-- TOC entry 2224 (class 1259 OID 39909)
-- Dependencies: 2893 2894 2895 2896 2897 6
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
-- TOC entry 2225 (class 1259 OID 39920)
-- Dependencies: 2898 2899 2900 2901 6
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
-- TOC entry 2226 (class 1259 OID 39930)
-- Dependencies: 2902 2903 2904 6
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
-- TOC entry 2227 (class 1259 OID 39939)
-- Dependencies: 2905 6
-- Name: sch_sponsor_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_sponsor_hist (
    operation character(1) NOT NULL,
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    active character(1) NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    sponsortypecode character varying NOT NULL
);


ALTER TABLE audit.sch_sponsor_hist OWNER TO postgres;

--
-- TOC entry 2228 (class 1259 OID 39946)
-- Dependencies: 2906 6
-- Name: sch_sponsorfeepercentage_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_sponsorfeepercentage_hist (
    operation character(1) NOT NULL,
    id integer NOT NULL,
    feecategorycode character varying NOT NULL,
    percentage character varying NOT NULL,
    writewho character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    sponsorid integer NOT NULL,
    active character(1) NOT NULL
);


ALTER TABLE audit.sch_sponsorfeepercentage_hist OWNER TO postgres;

--
-- TOC entry 2229 (class 1259 OID 39953)
-- Dependencies: 2907 2908 2909 2910 2911 2912 2913 2914 6
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
-- TOC entry 2230 (class 1259 OID 39967)
-- Dependencies: 2915 2916 2917 2918 2919 2920 2921 2922 2923 2924 2925 2926 2927 2928 2929 2930 2931 2932 2933 6
-- Name: student_hist; Type: TABLE; Schema: audit; Owner: postgres; Tablespace: 
--

CREATE TABLE student_hist (
    operation character(1) NOT NULL,
    studentid integer NOT NULL,
    studentcode character varying NOT NULL,
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
    relativestaffmemberid integer DEFAULT 0 NOT NULL,
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
    motivation character varying
);


ALTER TABLE audit.student_hist OWNER TO postgres;

--
-- TOC entry 2231 (class 1259 OID 39992)
-- Dependencies: 2934 6
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
-- TOC entry 2232 (class 1259 OID 39999)
-- Dependencies: 2935 2936 2937 2938 2939 2940 2941 2942 2943 6
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
-- TOC entry 2233 (class 1259 OID 40014)
-- Dependencies: 2944 6
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
-- TOC entry 2234 (class 1259 OID 40021)
-- Dependencies: 2945 2946 6
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
-- TOC entry 2235 (class 1259 OID 40029)
-- Dependencies: 2947 2948 6
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
-- TOC entry 2236 (class 1259 OID 40037)
-- Dependencies: 2949 2950 2951 6
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
-- TOC entry 2237 (class 1259 OID 40046)
-- Dependencies: 2952 2953 6
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
-- TOC entry 2238 (class 1259 OID 40054)
-- Dependencies: 7
-- Name: academicfieldseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE academicfieldseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.academicfieldseq OWNER TO postgres;

--
-- TOC entry 4528 (class 0 OID 0)
-- Dependencies: 2238
-- Name: academicfieldseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('academicfieldseq', 435, true);


--
-- TOC entry 2239 (class 1259 OID 40056)
-- Dependencies: 2954 2955 2956 2957 7
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
-- TOC entry 2240 (class 1259 OID 40066)
-- Dependencies: 7
-- Name: academicyearseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE academicyearseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.academicyearseq OWNER TO postgres;

--
-- TOC entry 4530 (class 0 OID 0)
-- Dependencies: 2240
-- Name: academicyearseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('academicyearseq', 20, true);


--
-- TOC entry 2241 (class 1259 OID 40068)
-- Dependencies: 2958 2959 2960 2961 2962 7
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
-- TOC entry 2242 (class 1259 OID 40079)
-- Dependencies: 7
-- Name: acc_accommodationfeeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_accommodationfeeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_accommodationfeeseq OWNER TO postgres;

--
-- TOC entry 4532 (class 0 OID 0)
-- Dependencies: 2242
-- Name: acc_accommodationfeeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_accommodationfeeseq', 3, true);


--
-- TOC entry 2243 (class 1259 OID 40081)
-- Dependencies: 2963 7
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
-- TOC entry 2244 (class 1259 OID 40088)
-- Dependencies: 7
-- Name: acc_accommodationfeepaymentseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_accommodationfeepaymentseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_accommodationfeepaymentseq OWNER TO postgres;

--
-- TOC entry 4534 (class 0 OID 0)
-- Dependencies: 2244
-- Name: acc_accommodationfeepaymentseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_accommodationfeepaymentseq', 1, false);


--
-- TOC entry 2245 (class 1259 OID 40090)
-- Dependencies: 7
-- Name: acc_accommodationselectioncriteriaseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_accommodationselectioncriteriaseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_accommodationselectioncriteriaseq OWNER TO postgres;

--
-- TOC entry 4535 (class 0 OID 0)
-- Dependencies: 2245
-- Name: acc_accommodationselectioncriteriaseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_accommodationselectioncriteriaseq', 1, false);


--
-- TOC entry 2246 (class 1259 OID 40092)
-- Dependencies: 7
-- Name: acc_blockseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_blockseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_blockseq OWNER TO postgres;

--
-- TOC entry 4536 (class 0 OID 0)
-- Dependencies: 2246
-- Name: acc_blockseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_blockseq', 4, true);


--
-- TOC entry 2247 (class 1259 OID 40094)
-- Dependencies: 2964 2965 2966 2967 7
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
-- TOC entry 2248 (class 1259 OID 40104)
-- Dependencies: 7
-- Name: acc_hostelseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_hostelseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_hostelseq OWNER TO postgres;

--
-- TOC entry 4538 (class 0 OID 0)
-- Dependencies: 2248
-- Name: acc_hostelseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_hostelseq', 3, true);


--
-- TOC entry 2249 (class 1259 OID 40106)
-- Dependencies: 2968 2969 2970 2971 2972 2973 2974 7
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
-- TOC entry 2250 (class 1259 OID 40119)
-- Dependencies: 7
-- Name: acc_hosteltypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_hosteltypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_hosteltypeseq OWNER TO postgres;

--
-- TOC entry 4540 (class 0 OID 0)
-- Dependencies: 2250
-- Name: acc_hosteltypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_hosteltypeseq', 3, true);


--
-- TOC entry 2251 (class 1259 OID 40121)
-- Dependencies: 2975 2976 2977 2978 2979 7
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
-- TOC entry 2252 (class 1259 OID 40132)
-- Dependencies: 7
-- Name: acc_roomseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_roomseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_roomseq OWNER TO postgres;

--
-- TOC entry 4542 (class 0 OID 0)
-- Dependencies: 2252
-- Name: acc_roomseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_roomseq', 1, true);


--
-- TOC entry 2253 (class 1259 OID 40134)
-- Dependencies: 2980 2981 2982 2983 2984 2985 2986 2987 7
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
-- TOC entry 2254 (class 1259 OID 40148)
-- Dependencies: 7
-- Name: acc_roomtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_roomtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_roomtypeseq OWNER TO postgres;

--
-- TOC entry 4544 (class 0 OID 0)
-- Dependencies: 2254
-- Name: acc_roomtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_roomtypeseq', 3, true);


--
-- TOC entry 2255 (class 1259 OID 40150)
-- Dependencies: 2988 2989 2990 2991 7
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
-- TOC entry 2256 (class 1259 OID 40160)
-- Dependencies: 7
-- Name: acc_studentaccommodationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_studentaccommodationseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_studentaccommodationseq OWNER TO postgres;

--
-- TOC entry 4546 (class 0 OID 0)
-- Dependencies: 2256
-- Name: acc_studentaccommodationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_studentaccommodationseq', 1, false);


--
-- TOC entry 2257 (class 1259 OID 40162)
-- Dependencies: 2992 2993 2994 2995 2996 2997 2998 2999 3000 3001 7
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
-- TOC entry 2258 (class 1259 OID 40178)
-- Dependencies: 7
-- Name: acc_studentaccommodationselectioncriteriaseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE acc_studentaccommodationselectioncriteriaseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.acc_studentaccommodationselectioncriteriaseq OWNER TO postgres;

--
-- TOC entry 4548 (class 0 OID 0)
-- Dependencies: 2258
-- Name: acc_studentaccommodationselectioncriteriaseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('acc_studentaccommodationselectioncriteriaseq', 1, false);


--
-- TOC entry 2259 (class 1259 OID 40180)
-- Dependencies: 7
-- Name: addressseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE addressseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.addressseq OWNER TO postgres;

--
-- TOC entry 4549 (class 0 OID 0)
-- Dependencies: 2259
-- Name: addressseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('addressseq', 142, true);


--
-- TOC entry 2260 (class 1259 OID 40182)
-- Dependencies: 3002 3003 3004 3005 3006 3007 3008 3009 7
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
-- TOC entry 2261 (class 1259 OID 40196)
-- Dependencies: 7
-- Name: addresstypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE addresstypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.addresstypeseq OWNER TO postgres;

--
-- TOC entry 4551 (class 0 OID 0)
-- Dependencies: 2261
-- Name: addresstypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('addresstypeseq', 21, true);


--
-- TOC entry 2262 (class 1259 OID 40198)
-- Dependencies: 3010 3011 3012 3013 7
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
-- TOC entry 2263 (class 1259 OID 40208)
-- Dependencies: 7
-- Name: administrativepostseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE administrativepostseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.administrativepostseq OWNER TO postgres;

--
-- TOC entry 4553 (class 0 OID 0)
-- Dependencies: 2263
-- Name: administrativepostseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('administrativepostseq', 777, true);


--
-- TOC entry 2264 (class 1259 OID 40210)
-- Dependencies: 3014 3015 3016 3017 7
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
-- TOC entry 2265 (class 1259 OID 40220)
-- Dependencies: 7
-- Name: organizationalunitacademicyearseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE organizationalunitacademicyearseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.organizationalunitacademicyearseq OWNER TO postgres;

--
-- TOC entry 4555 (class 0 OID 0)
-- Dependencies: 2265
-- Name: organizationalunitacademicyearseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('organizationalunitacademicyearseq', 23, true);


--
-- TOC entry 2266 (class 1259 OID 40222)
-- Dependencies: 3018 3019 3020 3021 7
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
-- TOC entry 2267 (class 1259 OID 40232)
-- Dependencies: 7
-- Name: appconfigseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE appconfigseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.appconfigseq OWNER TO postgres;

--
-- TOC entry 4556 (class 0 OID 0)
-- Dependencies: 2267
-- Name: appconfigseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('appconfigseq', 65, true);


--
-- TOC entry 2268 (class 1259 OID 40234)
-- Dependencies: 3022 3023 3024 3025 3026 7
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
-- TOC entry 2269 (class 1259 OID 40245)
-- Dependencies: 7
-- Name: applicantcategoryseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE applicantcategoryseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.applicantcategoryseq OWNER TO postgres;

--
-- TOC entry 4558 (class 0 OID 0)
-- Dependencies: 2269
-- Name: applicantcategoryseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('applicantcategoryseq', 21, true);


--
-- TOC entry 2270 (class 1259 OID 40247)
-- Dependencies: 3027 3028 3029 3030 7
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
-- TOC entry 2271 (class 1259 OID 40257)
-- Dependencies: 7
-- Name: appointmenttypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE appointmenttypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.appointmenttypeseq OWNER TO postgres;

--
-- TOC entry 4560 (class 0 OID 0)
-- Dependencies: 2271
-- Name: appointmenttypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('appointmenttypeseq', 12, true);


--
-- TOC entry 2272 (class 1259 OID 40259)
-- Dependencies: 3031 3032 3033 3034 7
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
-- TOC entry 2273 (class 1259 OID 40269)
-- Dependencies: 7
-- Name: appversionsseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE appversionsseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.appversionsseq OWNER TO postgres;

--
-- TOC entry 4562 (class 0 OID 0)
-- Dependencies: 2273
-- Name: appversionsseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('appversionsseq', 207, true);


--
-- TOC entry 2274 (class 1259 OID 40271)
-- Dependencies: 3035 3036 3037 3038 3039 3040 3041 7
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
-- TOC entry 2275 (class 1259 OID 40284)
-- Dependencies: 3042 3043 3044 7
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
-- TOC entry 2276 (class 1259 OID 40293)
-- Dependencies: 7
-- Name: blocktypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE blocktypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.blocktypeseq OWNER TO postgres;

--
-- TOC entry 4565 (class 0 OID 0)
-- Dependencies: 2276
-- Name: blocktypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('blocktypeseq', 6, true);


--
-- TOC entry 2277 (class 1259 OID 40295)
-- Dependencies: 3045 3046 3047 3048 7
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
-- TOC entry 2278 (class 1259 OID 40305)
-- Dependencies: 7
-- Name: bloodtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE bloodtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.bloodtypeseq OWNER TO postgres;

--
-- TOC entry 4567 (class 0 OID 0)
-- Dependencies: 2278
-- Name: bloodtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('bloodtypeseq', 49, true);


--
-- TOC entry 2279 (class 1259 OID 40307)
-- Dependencies: 3049 3050 3051 3052 7
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
-- TOC entry 2280 (class 1259 OID 40317)
-- Dependencies: 7
-- Name: branchseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE branchseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.branchseq OWNER TO postgres;

--
-- TOC entry 4569 (class 0 OID 0)
-- Dependencies: 2280
-- Name: branchseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('branchseq', 145, true);


--
-- TOC entry 2281 (class 1259 OID 40319)
-- Dependencies: 3053 3054 3055 3056 3057 7
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
-- TOC entry 2282 (class 1259 OID 40330)
-- Dependencies: 7
-- Name: cardinaltimeunitseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE cardinaltimeunitseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.cardinaltimeunitseq OWNER TO postgres;

--
-- TOC entry 4571 (class 0 OID 0)
-- Dependencies: 2282
-- Name: cardinaltimeunitseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('cardinaltimeunitseq', 18, true);


--
-- TOC entry 2283 (class 1259 OID 40332)
-- Dependencies: 3058 3059 3060 3061 3062 7
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
-- TOC entry 2284 (class 1259 OID 40343)
-- Dependencies: 7
-- Name: cardinaltimeunitresultseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE cardinaltimeunitresultseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.cardinaltimeunitresultseq OWNER TO postgres;

--
-- TOC entry 4573 (class 0 OID 0)
-- Dependencies: 2284
-- Name: cardinaltimeunitresultseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('cardinaltimeunitresultseq', 64, true);


--
-- TOC entry 2285 (class 1259 OID 40345)
-- Dependencies: 3063 3064 3065 3066 3067 3068 3069 7
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
-- TOC entry 2286 (class 1259 OID 40358)
-- Dependencies: 7
-- Name: cardinaltimeunitstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE cardinaltimeunitstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.cardinaltimeunitstatusseq OWNER TO postgres;

--
-- TOC entry 4575 (class 0 OID 0)
-- Dependencies: 2286
-- Name: cardinaltimeunitstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('cardinaltimeunitstatusseq', 23, true);


--
-- TOC entry 2287 (class 1259 OID 40360)
-- Dependencies: 3070 3071 3072 3073 7
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
-- TOC entry 2288 (class 1259 OID 40370)
-- Dependencies: 7
-- Name: cardinaltimeunitstudygradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE cardinaltimeunitstudygradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.cardinaltimeunitstudygradetypeseq OWNER TO postgres;

--
-- TOC entry 4577 (class 0 OID 0)
-- Dependencies: 2288
-- Name: cardinaltimeunitstudygradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('cardinaltimeunitstudygradetypeseq', 752, true);


--
-- TOC entry 2289 (class 1259 OID 40372)
-- Dependencies: 3074 3075 3076 3077 3078 3079 3080 7
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
-- TOC entry 2290 (class 1259 OID 40385)
-- Dependencies: 7
-- Name: careerpositionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE careerpositionseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.careerpositionseq OWNER TO postgres;

--
-- TOC entry 4579 (class 0 OID 0)
-- Dependencies: 2290
-- Name: careerpositionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('careerpositionseq', 8, true);


--
-- TOC entry 2291 (class 1259 OID 40387)
-- Dependencies: 3081 3082 3083 3084 7
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
-- TOC entry 2292 (class 1259 OID 40397)
-- Dependencies: 7
-- Name: civilstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE civilstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.civilstatusseq OWNER TO postgres;

--
-- TOC entry 4581 (class 0 OID 0)
-- Dependencies: 2292
-- Name: civilstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('civilstatusseq', 20, true);


--
-- TOC entry 2293 (class 1259 OID 40399)
-- Dependencies: 3085 3086 3087 3088 7
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
-- TOC entry 2294 (class 1259 OID 40409)
-- Dependencies: 7
-- Name: civiltitleseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE civiltitleseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.civiltitleseq OWNER TO postgres;

--
-- TOC entry 4583 (class 0 OID 0)
-- Dependencies: 2294
-- Name: civiltitleseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('civiltitleseq', 12, true);


--
-- TOC entry 2295 (class 1259 OID 40411)
-- Dependencies: 3089 3090 3091 3092 7
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
-- TOC entry 2296 (class 1259 OID 40421)
-- Dependencies: 7
-- Name: contractseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE contractseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.contractseq OWNER TO postgres;

--
-- TOC entry 4585 (class 0 OID 0)
-- Dependencies: 2296
-- Name: contractseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('contractseq', 39, true);


--
-- TOC entry 2297 (class 1259 OID 40423)
-- Dependencies: 3093 3094 3095 3096 7
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
-- TOC entry 2298 (class 1259 OID 40433)
-- Dependencies: 7
-- Name: contractdurationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE contractdurationseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.contractdurationseq OWNER TO postgres;

--
-- TOC entry 4587 (class 0 OID 0)
-- Dependencies: 2298
-- Name: contractdurationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('contractdurationseq', 6, true);


--
-- TOC entry 2299 (class 1259 OID 40435)
-- Dependencies: 3097 3098 3099 3100 7
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
-- TOC entry 2300 (class 1259 OID 40445)
-- Dependencies: 7
-- Name: contracttypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE contracttypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.contracttypeseq OWNER TO postgres;

--
-- TOC entry 4589 (class 0 OID 0)
-- Dependencies: 2300
-- Name: contracttypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('contracttypeseq', 10, true);


--
-- TOC entry 2301 (class 1259 OID 40447)
-- Dependencies: 3101 3102 3103 3104 7
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
-- TOC entry 2302 (class 1259 OID 40457)
-- Dependencies: 7
-- Name: countryseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE countryseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.countryseq OWNER TO postgres;

--
-- TOC entry 4591 (class 0 OID 0)
-- Dependencies: 2302
-- Name: countryseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('countryseq', 1012, true);


--
-- TOC entry 2303 (class 1259 OID 40459)
-- Dependencies: 3105 3106 3107 3108 7
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
-- TOC entry 2304 (class 1259 OID 40469)
-- Dependencies: 7
-- Name: daypartseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE daypartseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.daypartseq OWNER TO postgres;

--
-- TOC entry 4593 (class 0 OID 0)
-- Dependencies: 2304
-- Name: daypartseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('daypartseq', 9, true);


--
-- TOC entry 2305 (class 1259 OID 40471)
-- Dependencies: 3109 3110 3111 3112 7
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
-- TOC entry 2306 (class 1259 OID 40481)
-- Dependencies: 7
-- Name: disciplineseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE disciplineseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.disciplineseq OWNER TO postgres;

--
-- TOC entry 4595 (class 0 OID 0)
-- Dependencies: 2306
-- Name: disciplineseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('disciplineseq', 54, true);


--
-- TOC entry 2307 (class 1259 OID 40483)
-- Dependencies: 3113 3114 3115 3116 7
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
-- TOC entry 2308 (class 1259 OID 40493)
-- Dependencies: 7
-- Name: disciplinegroupseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE disciplinegroupseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.disciplinegroupseq OWNER TO postgres;

--
-- TOC entry 4597 (class 0 OID 0)
-- Dependencies: 2308
-- Name: disciplinegroupseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('disciplinegroupseq', 12, true);


--
-- TOC entry 2309 (class 1259 OID 40495)
-- Dependencies: 3117 3118 3119 3120 7
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
-- TOC entry 2310 (class 1259 OID 40505)
-- Dependencies: 7
-- Name: districtseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE districtseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.districtseq OWNER TO postgres;

--
-- TOC entry 4599 (class 0 OID 0)
-- Dependencies: 2310
-- Name: districtseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('districtseq', 649, true);


--
-- TOC entry 2311 (class 1259 OID 40507)
-- Dependencies: 3121 3122 3123 3124 7
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
-- TOC entry 2312 (class 1259 OID 40517)
-- Dependencies: 7
-- Name: educationtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE educationtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.educationtypeseq OWNER TO postgres;

--
-- TOC entry 4601 (class 0 OID 0)
-- Dependencies: 2312
-- Name: educationtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('educationtypeseq', 34, true);


--
-- TOC entry 2313 (class 1259 OID 40519)
-- Dependencies: 3125 3126 3127 3128 7
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
-- TOC entry 2314 (class 1259 OID 40529)
-- Dependencies: 7
-- Name: endgradeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE endgradeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.endgradeseq OWNER TO postgres;

--
-- TOC entry 4603 (class 0 OID 0)
-- Dependencies: 2314
-- Name: endgradeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('endgradeseq', 2168, true);


--
-- TOC entry 2315 (class 1259 OID 40531)
-- Dependencies: 3129 3130 3131 3132 3133 3134 7
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
-- TOC entry 2316 (class 1259 OID 40543)
-- Dependencies: 7
-- Name: endgradegeneralseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE endgradegeneralseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.endgradegeneralseq OWNER TO postgres;

--
-- TOC entry 4605 (class 0 OID 0)
-- Dependencies: 2316
-- Name: endgradegeneralseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('endgradegeneralseq', 2, true);


--
-- TOC entry 2317 (class 1259 OID 40545)
-- Dependencies: 3135 3136 3137 3138 3139 7
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
-- TOC entry 2318 (class 1259 OID 40556)
-- Dependencies: 7
-- Name: endgradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE endgradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.endgradetypeseq OWNER TO postgres;

--
-- TOC entry 4607 (class 0 OID 0)
-- Dependencies: 2318
-- Name: endgradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('endgradetypeseq', 45, true);


--
-- TOC entry 2319 (class 1259 OID 40558)
-- Dependencies: 3140 3141 3142 3143 7
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
-- TOC entry 2320 (class 1259 OID 40568)
-- Dependencies: 7
-- Name: entityseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE entityseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.entityseq OWNER TO postgres;

--
-- TOC entry 4609 (class 0 OID 0)
-- Dependencies: 2320
-- Name: entityseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('entityseq', 1, false);


--
-- TOC entry 2321 (class 1259 OID 40570)
-- Dependencies: 7
-- Name: examinationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examinationseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.examinationseq OWNER TO postgres;

--
-- TOC entry 4610 (class 0 OID 0)
-- Dependencies: 2321
-- Name: examinationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examinationseq', 218, true);


--
-- TOC entry 2322 (class 1259 OID 40572)
-- Dependencies: 3144 3145 3146 3147 7
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
-- TOC entry 2323 (class 1259 OID 40582)
-- Dependencies: 7
-- Name: examinationresultseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examinationresultseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.examinationresultseq OWNER TO postgres;

--
-- TOC entry 4612 (class 0 OID 0)
-- Dependencies: 2323
-- Name: examinationresultseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examinationresultseq', 159, true);


--
-- TOC entry 2324 (class 1259 OID 40584)
-- Dependencies: 3148 3149 3150 3151 3152 3153 7
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
-- TOC entry 2325 (class 1259 OID 40596)
-- Dependencies: 7
-- Name: examinationteacherseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examinationteacherseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.examinationteacherseq OWNER TO postgres;

--
-- TOC entry 4614 (class 0 OID 0)
-- Dependencies: 2325
-- Name: examinationteacherseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examinationteacherseq', 242, true);


--
-- TOC entry 2326 (class 1259 OID 40598)
-- Dependencies: 3154 3155 3156 3157 7
-- Name: examinationteacher; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE examinationteacher (
    id integer DEFAULT nextval('examinationteacherseq'::regclass) NOT NULL,
    staffmemberid integer NOT NULL,
    examinationid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.examinationteacher OWNER TO postgres;

--
-- TOC entry 2327 (class 1259 OID 40608)
-- Dependencies: 7
-- Name: examinationtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examinationtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.examinationtypeseq OWNER TO postgres;

--
-- TOC entry 4616 (class 0 OID 0)
-- Dependencies: 2327
-- Name: examinationtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examinationtypeseq', 163, true);


--
-- TOC entry 2328 (class 1259 OID 40610)
-- Dependencies: 3158 3159 3160 3161 7
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
-- TOC entry 2329 (class 1259 OID 40620)
-- Dependencies: 7
-- Name: examseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.examseq OWNER TO postgres;

--
-- TOC entry 4618 (class 0 OID 0)
-- Dependencies: 2329
-- Name: examseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examseq', 38, true);


--
-- TOC entry 2330 (class 1259 OID 40622)
-- Dependencies: 7
-- Name: examtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE examtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.examtypeseq OWNER TO postgres;

--
-- TOC entry 4619 (class 0 OID 0)
-- Dependencies: 2330
-- Name: examtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('examtypeseq', 10, true);


--
-- TOC entry 2331 (class 1259 OID 40624)
-- Dependencies: 3162 3163 3164 3165 7
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
-- TOC entry 2332 (class 1259 OID 40634)
-- Dependencies: 7
-- Name: expellationtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE expellationtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.expellationtypeseq OWNER TO postgres;

--
-- TOC entry 4621 (class 0 OID 0)
-- Dependencies: 2332
-- Name: expellationtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('expellationtypeseq', 8, true);


--
-- TOC entry 2333 (class 1259 OID 40636)
-- Dependencies: 3166 3167 3168 3169 7
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
-- TOC entry 2334 (class 1259 OID 40646)
-- Dependencies: 7
-- Name: failgradeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE failgradeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.failgradeseq OWNER TO postgres;

--
-- TOC entry 4623 (class 0 OID 0)
-- Dependencies: 2334
-- Name: failgradeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('failgradeseq', 10, true);


--
-- TOC entry 2335 (class 1259 OID 40648)
-- Dependencies: 3170 3171 3172 3173 3174 7
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
-- TOC entry 2336 (class 1259 OID 40659)
-- Dependencies: 7
-- Name: fee_feeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE fee_feeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.fee_feeseq OWNER TO postgres;

--
-- TOC entry 4625 (class 0 OID 0)
-- Dependencies: 2336
-- Name: fee_feeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('fee_feeseq', 99, true);


--
-- TOC entry 2337 (class 1259 OID 40661)
-- Dependencies: 3175 3176 3177 3178 3179 3180 3181 3182 3183 3184 3185 3186 3187 3188 3189 3190 3191 3192 7
-- Name: fee_fee; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE fee_fee (
    id integer DEFAULT nextval('fee_feeseq'::regclass) NOT NULL,
    feedue numeric(10,2) DEFAULT 0.00 NOT NULL,
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
    branchid integer DEFAULT 0 NOT NULL,
    studyintensitycode character varying DEFAULT ''::character varying NOT NULL,
    feeunitcode character varying DEFAULT ''::character varying NOT NULL,
    applicationmode character(1) DEFAULT 'A'::bpchar NOT NULL,
    cardinaltimeunitnumber integer DEFAULT 0 NOT NULL
);


ALTER TABLE opuscollege.fee_fee OWNER TO postgres;

--
-- TOC entry 2338 (class 1259 OID 40685)
-- Dependencies: 7
-- Name: fee_feecategoryseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE fee_feecategoryseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.fee_feecategoryseq OWNER TO postgres;

--
-- TOC entry 4627 (class 0 OID 0)
-- Dependencies: 2338
-- Name: fee_feecategoryseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('fee_feecategoryseq', 48, true);


--
-- TOC entry 2339 (class 1259 OID 40687)
-- Dependencies: 3193 3194 3195 3196 7
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
-- TOC entry 2340 (class 1259 OID 40697)
-- Dependencies: 7
-- Name: fee_feedeadlineseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE fee_feedeadlineseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.fee_feedeadlineseq OWNER TO postgres;

--
-- TOC entry 4629 (class 0 OID 0)
-- Dependencies: 2340
-- Name: fee_feedeadlineseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('fee_feedeadlineseq', 1, false);


--
-- TOC entry 2341 (class 1259 OID 40699)
-- Dependencies: 3197 3198 3199 3200 3201 3202 7
-- Name: fee_feedeadline; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE fee_feedeadline (
    id integer DEFAULT nextval('fee_feedeadlineseq'::regclass) NOT NULL,
    feeid integer NOT NULL,
    deadline date NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege-fees'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    cardinaltimeunitcode character varying NOT NULL,
    cardinaltimeunitnumber integer NOT NULL,
    CONSTRAINT fee_feedeadline_cardinaltimeunitcode_check CHECK (((cardinaltimeunitcode)::text <> ''::text)),
    CONSTRAINT fee_feedeadline_cardinaltimeunitnumber_check CHECK ((cardinaltimeunitnumber > 0))
);


ALTER TABLE opuscollege.fee_feedeadline OWNER TO postgres;

--
-- TOC entry 2342 (class 1259 OID 40711)
-- Dependencies: 7
-- Name: fee_paymentseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE fee_paymentseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.fee_paymentseq OWNER TO postgres;

--
-- TOC entry 4631 (class 0 OID 0)
-- Dependencies: 2342
-- Name: fee_paymentseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('fee_paymentseq', 429, true);


--
-- TOC entry 2343 (class 1259 OID 40713)
-- Dependencies: 3203 3204 3205 3206 3207 3208 3209 3210 3211 3212 7
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
-- TOC entry 2344 (class 1259 OID 40729)
-- Dependencies: 7
-- Name: fee_unitseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE fee_unitseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.fee_unitseq OWNER TO postgres;

--
-- TOC entry 4633 (class 0 OID 0)
-- Dependencies: 2344
-- Name: fee_unitseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('fee_unitseq', 7, true);


--
-- TOC entry 2345 (class 1259 OID 40731)
-- Dependencies: 3213 3214 3215 3216 7
-- Name: fee_unit; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE fee_unit (
    id integer DEFAULT nextval('fee_unitseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(2) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.fee_unit OWNER TO postgres;

--
-- TOC entry 2346 (class 1259 OID 40741)
-- Dependencies: 7
-- Name: fieldofeducationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE fieldofeducationseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.fieldofeducationseq OWNER TO postgres;

--
-- TOC entry 4635 (class 0 OID 0)
-- Dependencies: 2346
-- Name: fieldofeducationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('fieldofeducationseq', 12, true);


--
-- TOC entry 2347 (class 1259 OID 40743)
-- Dependencies: 3217 3218 3219 3220 7
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
-- TOC entry 2348 (class 1259 OID 40753)
-- Dependencies: 7
-- Name: financialrequestseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE financialrequestseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.financialrequestseq OWNER TO postgres;

--
-- TOC entry 4637 (class 0 OID 0)
-- Dependencies: 2348
-- Name: financialrequestseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('financialrequestseq', 1092, true);


--
-- TOC entry 2349 (class 1259 OID 40755)
-- Dependencies: 3221 3222 3223 3224 3225 7
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
    studentcode character varying
);


ALTER TABLE opuscollege.financialrequest OWNER TO postgres;

--
-- TOC entry 2350 (class 1259 OID 40766)
-- Dependencies: 7
-- Name: financialtransactionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE financialtransactionseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.financialtransactionseq OWNER TO postgres;

--
-- TOC entry 4639 (class 0 OID 0)
-- Dependencies: 2350
-- Name: financialtransactionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('financialtransactionseq', 851, true);


--
-- TOC entry 2351 (class 1259 OID 40768)
-- Dependencies: 3226 3227 3228 3229 3230 7
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
-- TOC entry 2352 (class 1259 OID 40779)
-- Dependencies: 7
-- Name: frequencyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE frequencyseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.frequencyseq OWNER TO postgres;

--
-- TOC entry 4641 (class 0 OID 0)
-- Dependencies: 2352
-- Name: frequencyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('frequencyseq', 69, true);


--
-- TOC entry 2353 (class 1259 OID 40781)
-- Dependencies: 3231 3232 3233 3234 7
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
-- TOC entry 2354 (class 1259 OID 40791)
-- Dependencies: 7
-- Name: functionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE functionseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.functionseq OWNER TO postgres;

--
-- TOC entry 4643 (class 0 OID 0)
-- Dependencies: 2354
-- Name: functionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('functionseq', 93, true);


--
-- TOC entry 2355 (class 1259 OID 40793)
-- Dependencies: 3235 3236 3237 3238 7
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
-- TOC entry 2356 (class 1259 OID 40803)
-- Dependencies: 7
-- Name: functionlevelseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE functionlevelseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.functionlevelseq OWNER TO postgres;

--
-- TOC entry 4645 (class 0 OID 0)
-- Dependencies: 2356
-- Name: functionlevelseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('functionlevelseq', 10, true);


--
-- TOC entry 2357 (class 1259 OID 40805)
-- Dependencies: 3239 3240 3241 3242 7
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
-- TOC entry 2358 (class 1259 OID 40815)
-- Dependencies: 7
-- Name: genderseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE genderseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.genderseq OWNER TO postgres;

--
-- TOC entry 4647 (class 0 OID 0)
-- Dependencies: 2358
-- Name: genderseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('genderseq', 15, true);


--
-- TOC entry 2359 (class 1259 OID 40817)
-- Dependencies: 3243 3244 3245 3246 7
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
-- TOC entry 2360 (class 1259 OID 40827)
-- Dependencies: 7
-- Name: gradedsecondaryschoolsubjectseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE gradedsecondaryschoolsubjectseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.gradedsecondaryschoolsubjectseq OWNER TO postgres;

--
-- TOC entry 4649 (class 0 OID 0)
-- Dependencies: 2360
-- Name: gradedsecondaryschoolsubjectseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('gradedsecondaryschoolsubjectseq', 351, true);


--
-- TOC entry 2361 (class 1259 OID 40829)
-- Dependencies: 3247 3248 3249 3250 3251 7
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
-- TOC entry 2362 (class 1259 OID 40840)
-- Dependencies: 7
-- Name: gradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE gradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.gradetypeseq OWNER TO postgres;

--
-- TOC entry 4651 (class 0 OID 0)
-- Dependencies: 2362
-- Name: gradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('gradetypeseq', 132, true);


--
-- TOC entry 2363 (class 1259 OID 40842)
-- Dependencies: 3252 3253 3254 3255 7
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
    titleshort character(1)
);


ALTER TABLE opuscollege.gradetype OWNER TO postgres;

--
-- TOC entry 2364 (class 1259 OID 40852)
-- Dependencies: 7
-- Name: groupeddisciplineseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE groupeddisciplineseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.groupeddisciplineseq OWNER TO postgres;

--
-- TOC entry 4653 (class 0 OID 0)
-- Dependencies: 2364
-- Name: groupeddisciplineseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('groupeddisciplineseq', 25, true);


--
-- TOC entry 2365 (class 1259 OID 40854)
-- Dependencies: 3256 3257 3258 3259 7
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
-- TOC entry 2366 (class 1259 OID 40864)
-- Dependencies: 7
-- Name: groupedsecondaryschoolsubjectseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE groupedsecondaryschoolsubjectseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.groupedsecondaryschoolsubjectseq OWNER TO postgres;

--
-- TOC entry 4655 (class 0 OID 0)
-- Dependencies: 2366
-- Name: groupedsecondaryschoolsubjectseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('groupedsecondaryschoolsubjectseq', 468, true);


--
-- TOC entry 2367 (class 1259 OID 40866)
-- Dependencies: 3260 3261 3262 3263 3264 3265 3266 7
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
-- TOC entry 2368 (class 1259 OID 40879)
-- Dependencies: 7
-- Name: identificationtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE identificationtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.identificationtypeseq OWNER TO postgres;

--
-- TOC entry 4657 (class 0 OID 0)
-- Dependencies: 2368
-- Name: identificationtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('identificationtypeseq', 26, true);


--
-- TOC entry 2369 (class 1259 OID 40881)
-- Dependencies: 3267 3268 3269 3270 7
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
-- TOC entry 2370 (class 1259 OID 40891)
-- Dependencies: 7
-- Name: subjectimportanceseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectimportanceseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectimportanceseq OWNER TO postgres;

--
-- TOC entry 4659 (class 0 OID 0)
-- Dependencies: 2370
-- Name: subjectimportanceseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectimportanceseq', 6, true);


--
-- TOC entry 2371 (class 1259 OID 40893)
-- Dependencies: 3271 3272 3273 3274 7
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
-- TOC entry 2372 (class 1259 OID 40903)
-- Dependencies: 7
-- Name: institutionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE institutionseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.institutionseq OWNER TO postgres;

--
-- TOC entry 4661 (class 0 OID 0)
-- Dependencies: 2372
-- Name: institutionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('institutionseq', 142, true);


--
-- TOC entry 2373 (class 1259 OID 40905)
-- Dependencies: 3275 3276 3277 3278 3279 7
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
-- TOC entry 2374 (class 1259 OID 40916)
-- Dependencies: 7
-- Name: languageseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE languageseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.languageseq OWNER TO postgres;

--
-- TOC entry 4663 (class 0 OID 0)
-- Dependencies: 2374
-- Name: languageseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('languageseq', 1550, true);


--
-- TOC entry 2375 (class 1259 OID 40918)
-- Dependencies: 3280 3281 3282 3283 7
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
-- TOC entry 2376 (class 1259 OID 40928)
-- Dependencies: 7
-- Name: levelofeducationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE levelofeducationseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.levelofeducationseq OWNER TO postgres;

--
-- TOC entry 4665 (class 0 OID 0)
-- Dependencies: 2376
-- Name: levelofeducationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('levelofeducationseq', 15, true);


--
-- TOC entry 2377 (class 1259 OID 40930)
-- Dependencies: 3284 3285 3286 3287 7
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
-- TOC entry 2378 (class 1259 OID 40940)
-- Dependencies: 7
-- Name: logmailerrorseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE logmailerrorseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.logmailerrorseq OWNER TO postgres;

--
-- TOC entry 4667 (class 0 OID 0)
-- Dependencies: 2378
-- Name: logmailerrorseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('logmailerrorseq', 12, true);


--
-- TOC entry 2379 (class 1259 OID 40942)
-- Dependencies: 3288 3289 3290 3291 3292 3293 3294 7
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
-- TOC entry 2380 (class 1259 OID 40955)
-- Dependencies: 7
-- Name: logrequesterrorseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE logrequesterrorseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.logrequesterrorseq OWNER TO postgres;

--
-- TOC entry 4669 (class 0 OID 0)
-- Dependencies: 2380
-- Name: logrequesterrorseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('logrequesterrorseq', 3, true);


--
-- TOC entry 2381 (class 1259 OID 40957)
-- Dependencies: 3295 3296 3297 3298 3299 3300 7
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
-- TOC entry 2382 (class 1259 OID 40969)
-- Dependencies: 7
-- Name: lookuptableseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE lookuptableseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.lookuptableseq OWNER TO postgres;

--
-- TOC entry 4671 (class 0 OID 0)
-- Dependencies: 2382
-- Name: lookuptableseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('lookuptableseq', 79, true);


--
-- TOC entry 2383 (class 1259 OID 40971)
-- Dependencies: 3301 3302 3303 3304 7
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
-- TOC entry 2384 (class 1259 OID 40981)
-- Dependencies: 7
-- Name: mailconfigseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE mailconfigseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.mailconfigseq OWNER TO postgres;

--
-- TOC entry 4673 (class 0 OID 0)
-- Dependencies: 2384
-- Name: mailconfigseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('mailconfigseq', 22, true);


--
-- TOC entry 2385 (class 1259 OID 40983)
-- Dependencies: 3305 3306 3307 3308 3309 3310 3311 7
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
-- TOC entry 2386 (class 1259 OID 40996)
-- Dependencies: 7
-- Name: masteringlevelseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE masteringlevelseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.masteringlevelseq OWNER TO postgres;

--
-- TOC entry 4675 (class 0 OID 0)
-- Dependencies: 2386
-- Name: masteringlevelseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('masteringlevelseq', 9, true);


--
-- TOC entry 2387 (class 1259 OID 40998)
-- Dependencies: 3312 3313 3314 3315 7
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
-- TOC entry 2388 (class 1259 OID 41008)
-- Dependencies: 7
-- Name: nationalityseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE nationalityseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.nationalityseq OWNER TO postgres;

--
-- TOC entry 4677 (class 0 OID 0)
-- Dependencies: 2388
-- Name: nationalityseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('nationalityseq', 398, true);


--
-- TOC entry 2389 (class 1259 OID 41010)
-- Dependencies: 3316 3317 3318 3319 7
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
-- TOC entry 2390 (class 1259 OID 41020)
-- Dependencies: 7
-- Name: nationalitygroupseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE nationalitygroupseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.nationalitygroupseq OWNER TO postgres;

--
-- TOC entry 4679 (class 0 OID 0)
-- Dependencies: 2390
-- Name: nationalitygroupseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('nationalitygroupseq', 4, true);


--
-- TOC entry 2391 (class 1259 OID 41022)
-- Dependencies: 3320 3321 3322 3323 7
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
-- TOC entry 2392 (class 1259 OID 41032)
-- Dependencies: 7
-- Name: obtainedqualificationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE obtainedqualificationseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.obtainedqualificationseq OWNER TO postgres;

--
-- TOC entry 4681 (class 0 OID 0)
-- Dependencies: 2392
-- Name: obtainedqualificationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('obtainedqualificationseq', 24, true);


--
-- TOC entry 2393 (class 1259 OID 41034)
-- Dependencies: 3324 3325 3326 3327 7
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
-- TOC entry 2394 (class 1259 OID 41044)
-- Dependencies: 7
-- Name: opusprivilegeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE opusprivilegeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.opusprivilegeseq OWNER TO postgres;

--
-- TOC entry 4683 (class 0 OID 0)
-- Dependencies: 2394
-- Name: opusprivilegeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('opusprivilegeseq', 3448, true);


--
-- TOC entry 2395 (class 1259 OID 41046)
-- Dependencies: 3328 3329 3330 3331 7
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
-- TOC entry 2396 (class 1259 OID 41056)
-- Dependencies: 7
-- Name: opusrole_privilegeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE opusrole_privilegeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.opusrole_privilegeseq OWNER TO postgres;

--
-- TOC entry 4685 (class 0 OID 0)
-- Dependencies: 2396
-- Name: opusrole_privilegeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('opusrole_privilegeseq', 28787, true);


--
-- TOC entry 2397 (class 1259 OID 41058)
-- Dependencies: 3332 3333 3334 3335 7
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
-- TOC entry 2398 (class 1259 OID 41068)
-- Dependencies: 7
-- Name: opususerseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE opususerseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.opususerseq OWNER TO postgres;

--
-- TOC entry 4687 (class 0 OID 0)
-- Dependencies: 2398
-- Name: opususerseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('opususerseq', 490, true);


--
-- TOC entry 2399 (class 1259 OID 41070)
-- Dependencies: 3336 3337 3338 3339 3340 3341 3342 7
-- Name: opususer; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE opususer (
    id integer DEFAULT nextval('opususerseq'::regclass) NOT NULL,
    personid integer DEFAULT 0 NOT NULL,
    username character varying NOT NULL,
    pw character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    lang character(5) DEFAULT 'en'::bpchar NOT NULL,
    preferredorganizationalunitid integer DEFAULT 0 NOT NULL,
    failedloginattempts smallint DEFAULT 0 NOT NULL
);


ALTER TABLE opuscollege.opususer OWNER TO postgres;

--
-- TOC entry 2400 (class 1259 OID 41083)
-- Dependencies: 7
-- Name: opususerroleseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE opususerroleseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.opususerroleseq OWNER TO postgres;

--
-- TOC entry 4689 (class 0 OID 0)
-- Dependencies: 2400
-- Name: opususerroleseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('opususerroleseq', 518, true);


--
-- TOC entry 2401 (class 1259 OID 41085)
-- Dependencies: 3343 3344 3345 3346 3347 3348 7
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
-- TOC entry 2402 (class 1259 OID 41097)
-- Dependencies: 7
-- Name: penaltyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE penaltyseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.penaltyseq OWNER TO postgres;

--
-- TOC entry 4691 (class 0 OID 0)
-- Dependencies: 2402
-- Name: penaltyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('penaltyseq', 1, false);


--
-- TOC entry 2403 (class 1259 OID 41099)
-- Dependencies: 3349 3350 3351 3352 3353 3354 7
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
-- TOC entry 2404 (class 1259 OID 41111)
-- Dependencies: 7
-- Name: penaltytypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE penaltytypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.penaltytypeseq OWNER TO postgres;

--
-- TOC entry 4693 (class 0 OID 0)
-- Dependencies: 2404
-- Name: penaltytypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('penaltytypeseq', 5, true);


--
-- TOC entry 2405 (class 1259 OID 41113)
-- Dependencies: 3355 3356 3357 3358 7
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
-- TOC entry 2406 (class 1259 OID 41123)
-- Dependencies: 7
-- Name: personseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE personseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.personseq OWNER TO postgres;

--
-- TOC entry 4695 (class 0 OID 0)
-- Dependencies: 2406
-- Name: personseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('personseq', 519, true);


--
-- TOC entry 2407 (class 1259 OID 41125)
-- Dependencies: 3359 3360 3361 3362 3363 3364 3365 3366 7
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
-- TOC entry 2408 (class 1259 OID 41139)
-- Dependencies: 7
-- Name: professionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE professionseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.professionseq OWNER TO postgres;

--
-- TOC entry 4697 (class 0 OID 0)
-- Dependencies: 2408
-- Name: professionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('professionseq', 177, true);


--
-- TOC entry 2409 (class 1259 OID 41141)
-- Dependencies: 3367 3368 3369 3370 7
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
-- TOC entry 2410 (class 1259 OID 41151)
-- Dependencies: 7
-- Name: progressstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE progressstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.progressstatusseq OWNER TO postgres;

--
-- TOC entry 4699 (class 0 OID 0)
-- Dependencies: 2410
-- Name: progressstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('progressstatusseq', 122, true);


--
-- TOC entry 2411 (class 1259 OID 41153)
-- Dependencies: 3371 3372 3373 3374 3375 3376 3377 3378 7
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
-- TOC entry 2412 (class 1259 OID 41167)
-- Dependencies: 7
-- Name: provinceseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE provinceseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.provinceseq OWNER TO postgres;

--
-- TOC entry 4701 (class 0 OID 0)
-- Dependencies: 2412
-- Name: provinceseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('provinceseq', 76, true);


--
-- TOC entry 2413 (class 1259 OID 41169)
-- Dependencies: 3379 3380 3381 3382 7
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
-- TOC entry 2414 (class 1259 OID 41179)
-- Dependencies: 7
-- Name: refereeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE refereeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.refereeseq OWNER TO postgres;

--
-- TOC entry 4703 (class 0 OID 0)
-- Dependencies: 2414
-- Name: refereeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('refereeseq', 44, true);


--
-- TOC entry 2415 (class 1259 OID 41181)
-- Dependencies: 3383 3384 3385 3386 7
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
-- TOC entry 2416 (class 1259 OID 41191)
-- Dependencies: 7
-- Name: relationtypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE relationtypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.relationtypeseq OWNER TO postgres;

--
-- TOC entry 4705 (class 0 OID 0)
-- Dependencies: 2416
-- Name: relationtypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('relationtypeseq', 12, true);


--
-- TOC entry 2417 (class 1259 OID 41193)
-- Dependencies: 3387 3388 3389 3390 7
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
-- TOC entry 2418 (class 1259 OID 41203)
-- Dependencies: 7
-- Name: reportpropertyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE reportpropertyseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.reportpropertyseq OWNER TO postgres;

--
-- TOC entry 4707 (class 0 OID 0)
-- Dependencies: 2418
-- Name: reportpropertyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('reportpropertyseq', 15, true);


--
-- TOC entry 2419 (class 1259 OID 41205)
-- Dependencies: 3391 3392 3393 3394 3395 7
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
-- TOC entry 2420 (class 1259 OID 41216)
-- Dependencies: 3396 3397 7
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
-- TOC entry 2421 (class 1259 OID 41224)
-- Dependencies: 7
-- Name: requestforchangeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE requestforchangeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.requestforchangeseq OWNER TO postgres;

--
-- TOC entry 4710 (class 0 OID 0)
-- Dependencies: 2421
-- Name: requestforchangeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('requestforchangeseq', 30, true);


--
-- TOC entry 2422 (class 1259 OID 41226)
-- Dependencies: 3398 3399 3400 3401 3402 3403 3404 7
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
-- TOC entry 2423 (class 1259 OID 41239)
-- Dependencies: 7
-- Name: rfcstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE rfcstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.rfcstatusseq OWNER TO postgres;

--
-- TOC entry 4711 (class 0 OID 0)
-- Dependencies: 2423
-- Name: rfcstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('rfcstatusseq', 3, true);


--
-- TOC entry 2424 (class 1259 OID 41241)
-- Dependencies: 3405 3406 3407 3408 7
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
-- TOC entry 2425 (class 1259 OID 41251)
-- Dependencies: 7
-- Name: rigiditytypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE rigiditytypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.rigiditytypeseq OWNER TO postgres;

--
-- TOC entry 4713 (class 0 OID 0)
-- Dependencies: 2425
-- Name: rigiditytypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('rigiditytypeseq', 14, true);


--
-- TOC entry 2426 (class 1259 OID 41253)
-- Dependencies: 3409 3410 3411 3412 7
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
-- TOC entry 2427 (class 1259 OID 41263)
-- Dependencies: 7
-- Name: roleseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE roleseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.roleseq OWNER TO postgres;

--
-- TOC entry 4715 (class 0 OID 0)
-- Dependencies: 2427
-- Name: roleseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('roleseq', 162, true);


--
-- TOC entry 2428 (class 1259 OID 41265)
-- Dependencies: 3413 3414 3415 3416 7
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
-- TOC entry 2429 (class 1259 OID 41275)
-- Dependencies: 7
-- Name: sch_bankseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_bankseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_bankseq OWNER TO postgres;

--
-- TOC entry 4717 (class 0 OID 0)
-- Dependencies: 2429
-- Name: sch_bankseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_bankseq', 4, true);


--
-- TOC entry 2430 (class 1259 OID 41277)
-- Dependencies: 3417 3418 3419 3420 7
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
-- TOC entry 2431 (class 1259 OID 41287)
-- Dependencies: 7
-- Name: sch_complaintseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_complaintseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_complaintseq OWNER TO postgres;

--
-- TOC entry 4719 (class 0 OID 0)
-- Dependencies: 2431
-- Name: sch_complaintseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_complaintseq', 22, true);


--
-- TOC entry 2432 (class 1259 OID 41289)
-- Dependencies: 3421 3422 3423 3424 7
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
-- TOC entry 2433 (class 1259 OID 41299)
-- Dependencies: 7
-- Name: sch_complaintstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_complaintstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_complaintstatusseq OWNER TO postgres;

--
-- TOC entry 4721 (class 0 OID 0)
-- Dependencies: 2433
-- Name: sch_complaintstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_complaintstatusseq', 6, true);


--
-- TOC entry 2434 (class 1259 OID 41301)
-- Dependencies: 3425 3426 3427 3428 7
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
-- TOC entry 2435 (class 1259 OID 41311)
-- Dependencies: 7
-- Name: sch_decisioncriteriaseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_decisioncriteriaseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_decisioncriteriaseq OWNER TO postgres;

--
-- TOC entry 4723 (class 0 OID 0)
-- Dependencies: 2435
-- Name: sch_decisioncriteriaseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_decisioncriteriaseq', 66, true);


--
-- TOC entry 2436 (class 1259 OID 41313)
-- Dependencies: 3429 3430 3431 3432 7
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
-- TOC entry 2437 (class 1259 OID 41323)
-- Dependencies: 7
-- Name: sch_scholarshipseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_scholarshipseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_scholarshipseq OWNER TO postgres;

--
-- TOC entry 4725 (class 0 OID 0)
-- Dependencies: 2437
-- Name: sch_scholarshipseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_scholarshipseq', 17, true);


--
-- TOC entry 2438 (class 1259 OID 41325)
-- Dependencies: 3433 3434 3435 3436 7
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
-- TOC entry 2439 (class 1259 OID 41335)
-- Dependencies: 7
-- Name: sch_scholarshipapplicationseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_scholarshipapplicationseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_scholarshipapplicationseq OWNER TO postgres;

--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 2439
-- Name: sch_scholarshipapplicationseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_scholarshipapplicationseq', 1030, true);


--
-- TOC entry 2440 (class 1259 OID 41337)
-- Dependencies: 3437 3438 3439 3440 3441 3442 7
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
-- TOC entry 2441 (class 1259 OID 41349)
-- Dependencies: 7
-- Name: sch_scholarshiptypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_scholarshiptypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_scholarshiptypeseq OWNER TO postgres;

--
-- TOC entry 4729 (class 0 OID 0)
-- Dependencies: 2441
-- Name: sch_scholarshiptypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_scholarshiptypeseq', 48, true);


--
-- TOC entry 2442 (class 1259 OID 41351)
-- Dependencies: 3443 3444 3445 3446 7
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
-- TOC entry 2443 (class 1259 OID 41361)
-- Dependencies: 7
-- Name: sch_sponsorseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_sponsorseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_sponsorseq OWNER TO postgres;

--
-- TOC entry 4731 (class 0 OID 0)
-- Dependencies: 2443
-- Name: sch_sponsorseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_sponsorseq', 23, true);


--
-- TOC entry 2444 (class 1259 OID 41363)
-- Dependencies: 3447 3448 3449 3450 7
-- Name: sch_sponsor; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_sponsor (
    id integer DEFAULT nextval('sch_sponsorseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    sponsortypecode character varying NOT NULL
);


ALTER TABLE opuscollege.sch_sponsor OWNER TO postgres;

--
-- TOC entry 2445 (class 1259 OID 41373)
-- Dependencies: 7
-- Name: sch_sponsorfeepercentage_seq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_sponsorfeepercentage_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_sponsorfeepercentage_seq OWNER TO postgres;

--
-- TOC entry 4733 (class 0 OID 0)
-- Dependencies: 2445
-- Name: sch_sponsorfeepercentage_seq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_sponsorfeepercentage_seq', 1, false);


--
-- TOC entry 2446 (class 1259 OID 41375)
-- Dependencies: 3451 3452 3453 3454 7
-- Name: sch_sponsorfeepercentage; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE sch_sponsorfeepercentage (
    id integer DEFAULT nextval('sch_sponsorfeepercentage_seq'::regclass) NOT NULL,
    feecategorycode character varying NOT NULL,
    percentage character varying NOT NULL,
    writewho character varying DEFAULT 'opusscholarship'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    sponsorid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL
);


ALTER TABLE opuscollege.sch_sponsorfeepercentage OWNER TO postgres;

--
-- TOC entry 2447 (class 1259 OID 41385)
-- Dependencies: 7
-- Name: sch_sponsorpayment_seq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_sponsorpayment_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_sponsorpayment_seq OWNER TO postgres;

--
-- TOC entry 4735 (class 0 OID 0)
-- Dependencies: 2447
-- Name: sch_sponsorpayment_seq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_sponsorpayment_seq', 9, true);


--
-- TOC entry 2448 (class 1259 OID 41387)
-- Dependencies: 3455 7
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
-- TOC entry 2449 (class 1259 OID 41391)
-- Dependencies: 7
-- Name: sch_sponsortype_seq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_sponsortype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_sponsortype_seq OWNER TO postgres;

--
-- TOC entry 4737 (class 0 OID 0)
-- Dependencies: 2449
-- Name: sch_sponsortype_seq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_sponsortype_seq', 6, true);


--
-- TOC entry 2450 (class 1259 OID 41393)
-- Dependencies: 3456 3457 3458 3459 7
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
    writewhen timestamp without time zone DEFAULT now() NOT NULL,
    titleshort character(1)
);


ALTER TABLE opuscollege.sch_sponsortype OWNER TO postgres;

--
-- TOC entry 2451 (class 1259 OID 41403)
-- Dependencies: 7
-- Name: sch_studentseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_studentseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_studentseq OWNER TO postgres;

--
-- TOC entry 4739 (class 0 OID 0)
-- Dependencies: 2451
-- Name: sch_studentseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_studentseq', 20, true);


--
-- TOC entry 2452 (class 1259 OID 41405)
-- Dependencies: 3460 3461 3462 3463 3464 3465 7
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
-- TOC entry 2453 (class 1259 OID 41417)
-- Dependencies: 7
-- Name: sch_subsidyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_subsidyseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_subsidyseq OWNER TO postgres;

--
-- TOC entry 4741 (class 0 OID 0)
-- Dependencies: 2453
-- Name: sch_subsidyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_subsidyseq', 9, true);


--
-- TOC entry 2454 (class 1259 OID 41419)
-- Dependencies: 3466 3467 3468 3469 7
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
-- TOC entry 2455 (class 1259 OID 41429)
-- Dependencies: 7
-- Name: sch_subsidytypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE sch_subsidytypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.sch_subsidytypeseq OWNER TO postgres;

--
-- TOC entry 4743 (class 0 OID 0)
-- Dependencies: 2455
-- Name: sch_subsidytypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('sch_subsidytypeseq', 8, true);


--
-- TOC entry 2456 (class 1259 OID 41431)
-- Dependencies: 3470 3471 3472 3473 7
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
-- TOC entry 2457 (class 1259 OID 41441)
-- Dependencies: 7
-- Name: secondaryschoolsubjectseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE secondaryschoolsubjectseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.secondaryschoolsubjectseq OWNER TO postgres;

--
-- TOC entry 4745 (class 0 OID 0)
-- Dependencies: 2457
-- Name: secondaryschoolsubjectseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('secondaryschoolsubjectseq', 31, true);


--
-- TOC entry 2458 (class 1259 OID 41443)
-- Dependencies: 3474 3475 3476 3477 7
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
-- TOC entry 2459 (class 1259 OID 41453)
-- Dependencies: 7
-- Name: secondaryschoolsubjectgroupseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE secondaryschoolsubjectgroupseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.secondaryschoolsubjectgroupseq OWNER TO postgres;

--
-- TOC entry 4747 (class 0 OID 0)
-- Dependencies: 2459
-- Name: secondaryschoolsubjectgroupseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('secondaryschoolsubjectgroupseq', 92, true);


--
-- TOC entry 2460 (class 1259 OID 41455)
-- Dependencies: 3478 3479 3480 3481 7
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
-- TOC entry 2461 (class 1259 OID 41465)
-- Dependencies: 7
-- Name: staffmemberseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE staffmemberseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.staffmemberseq OWNER TO postgres;

--
-- TOC entry 4749 (class 0 OID 0)
-- Dependencies: 2461
-- Name: staffmemberseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('staffmemberseq', 164, true);


--
-- TOC entry 2462 (class 1259 OID 41467)
-- Dependencies: 3482 3483 3484 3485 3486 7
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
-- TOC entry 2463 (class 1259 OID 41478)
-- Dependencies: 3487 3488 3489 7
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
-- TOC entry 2464 (class 1259 OID 41487)
-- Dependencies: 7
-- Name: stafftypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE stafftypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.stafftypeseq OWNER TO postgres;

--
-- TOC entry 4752 (class 0 OID 0)
-- Dependencies: 2464
-- Name: stafftypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('stafftypeseq', 16, true);


--
-- TOC entry 2465 (class 1259 OID 41489)
-- Dependencies: 3490 3491 3492 3493 7
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
-- TOC entry 2466 (class 1259 OID 41499)
-- Dependencies: 7
-- Name: statusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE statusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.statusseq OWNER TO postgres;

--
-- TOC entry 4754 (class 0 OID 0)
-- Dependencies: 2466
-- Name: statusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('statusseq', 80, true);


--
-- TOC entry 2467 (class 1259 OID 41501)
-- Dependencies: 3494 3495 3496 3497 7
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
-- TOC entry 2468 (class 1259 OID 41511)
-- Dependencies: 7
-- Name: studentseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentseq OWNER TO postgres;

--
-- TOC entry 4756 (class 0 OID 0)
-- Dependencies: 2468
-- Name: studentseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentseq', 314, true);


--
-- TOC entry 2469 (class 1259 OID 41513)
-- Dependencies: 3498 3499 3500 3501 3502 3503 3504 3505 3506 3507 3508 3509 3510 3511 3512 3513 7
-- Name: student; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE student (
    studentid integer DEFAULT nextval('studentseq'::regclass) NOT NULL,
    studentcode character varying NOT NULL,
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
    relativestaffmemberid integer DEFAULT 0 NOT NULL,
    ruralareaorigin character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE opuscollege.student OWNER TO postgres;

--
-- TOC entry 2470 (class 1259 OID 41535)
-- Dependencies: 7
-- Name: studentabsenceseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentabsenceseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentabsenceseq OWNER TO postgres;

--
-- TOC entry 4758 (class 0 OID 0)
-- Dependencies: 2470
-- Name: studentabsenceseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentabsenceseq', 14, true);


--
-- TOC entry 2471 (class 1259 OID 41537)
-- Dependencies: 3514 3515 3516 7
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
-- TOC entry 2472 (class 1259 OID 41546)
-- Dependencies: 7
-- Name: studentactivityseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentactivityseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentactivityseq OWNER TO postgres;

--
-- TOC entry 4760 (class 0 OID 0)
-- Dependencies: 2472
-- Name: studentactivityseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentactivityseq', 14, true);


--
-- TOC entry 2473 (class 1259 OID 41548)
-- Dependencies: 3517 7
-- Name: studentactivity; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentactivity (
    id integer DEFAULT nextval('studentactivityseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    description character varying
);


ALTER TABLE opuscollege.studentactivity OWNER TO postgres;

--
-- TOC entry 2474 (class 1259 OID 41555)
-- Dependencies: 7
-- Name: studentbalance_seq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentbalance_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentbalance_seq OWNER TO postgres;

--
-- TOC entry 4762 (class 0 OID 0)
-- Dependencies: 2474
-- Name: studentbalance_seq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentbalance_seq', 116, true);


--
-- TOC entry 2475 (class 1259 OID 41557)
-- Dependencies: 3518 3519 3520 3521 3522 3523 3524 7
-- Name: studentbalance; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentbalance (
    id integer DEFAULT nextval('studentbalance_seq'::regclass) NOT NULL,
    studentid integer DEFAULT 0 NOT NULL,
    feeid integer DEFAULT 0 NOT NULL,
    studyplancardinaltimeunitid integer DEFAULT 0 NOT NULL,
    studyplandetailid integer DEFAULT 0 NOT NULL,
    academicyearid integer DEFAULT 0 NOT NULL,
    exemption character(1) DEFAULT 'N'::bpchar NOT NULL
);


ALTER TABLE opuscollege.studentbalance OWNER TO postgres;

--
-- TOC entry 2476 (class 1259 OID 41567)
-- Dependencies: 7
-- Name: studentcareerseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentcareerseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentcareerseq OWNER TO postgres;

--
-- TOC entry 4764 (class 0 OID 0)
-- Dependencies: 2476
-- Name: studentcareerseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentcareerseq', 9, true);


--
-- TOC entry 2477 (class 1259 OID 41569)
-- Dependencies: 3525 7
-- Name: studentcareer; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentcareer (
    id integer DEFAULT nextval('studentcareerseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    description character varying
);


ALTER TABLE opuscollege.studentcareer OWNER TO postgres;

--
-- TOC entry 2478 (class 1259 OID 41576)
-- Dependencies: 7
-- Name: studentcounselingseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentcounselingseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentcounselingseq OWNER TO postgres;

--
-- TOC entry 4766 (class 0 OID 0)
-- Dependencies: 2478
-- Name: studentcounselingseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentcounselingseq', 4, true);


--
-- TOC entry 2479 (class 1259 OID 41578)
-- Dependencies: 3526 7
-- Name: studentcounseling; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentcounseling (
    id integer DEFAULT nextval('studentcounselingseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    description character varying
);


ALTER TABLE opuscollege.studentcounseling OWNER TO postgres;

--
-- TOC entry 2480 (class 1259 OID 41585)
-- Dependencies: 7
-- Name: studentexpulsionseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentexpulsionseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentexpulsionseq OWNER TO postgres;

--
-- TOC entry 4768 (class 0 OID 0)
-- Dependencies: 2480
-- Name: studentexpulsionseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentexpulsionseq', 11, true);


--
-- TOC entry 2481 (class 1259 OID 41587)
-- Dependencies: 3527 3528 3529 7
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
-- TOC entry 2482 (class 1259 OID 41596)
-- Dependencies: 7
-- Name: studentplacementseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentplacementseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentplacementseq OWNER TO postgres;

--
-- TOC entry 4770 (class 0 OID 0)
-- Dependencies: 2482
-- Name: studentplacementseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentplacementseq', 7, true);


--
-- TOC entry 2483 (class 1259 OID 41598)
-- Dependencies: 3530 7
-- Name: studentplacement; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studentplacement (
    id integer DEFAULT nextval('studentplacementseq'::regclass) NOT NULL,
    studentid integer NOT NULL,
    description character varying
);


ALTER TABLE opuscollege.studentplacement OWNER TO postgres;

--
-- TOC entry 2484 (class 1259 OID 41605)
-- Dependencies: 7
-- Name: studentstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentstatusseq OWNER TO postgres;

--
-- TOC entry 4772 (class 0 OID 0)
-- Dependencies: 2484
-- Name: studentstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentstatusseq', 10, true);


--
-- TOC entry 2485 (class 1259 OID 41607)
-- Dependencies: 3531 3532 3533 3534 7
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
-- TOC entry 2486 (class 1259 OID 41617)
-- Dependencies: 7
-- Name: studentstudentstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studentstudentstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studentstudentstatusseq OWNER TO postgres;

--
-- TOC entry 4774 (class 0 OID 0)
-- Dependencies: 2486
-- Name: studentstudentstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studentstudentstatusseq', 243, true);


--
-- TOC entry 2487 (class 1259 OID 41619)
-- Dependencies: 3535 3536 3537 7
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
-- TOC entry 2488 (class 1259 OID 41628)
-- Dependencies: 7
-- Name: studyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyseq OWNER TO postgres;

--
-- TOC entry 4776 (class 0 OID 0)
-- Dependencies: 2488
-- Name: studyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyseq', 1209, true);


--
-- TOC entry 2489 (class 1259 OID 41630)
-- Dependencies: 3538 3539 3540 3541 3542 7
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
-- TOC entry 2490 (class 1259 OID 41641)
-- Dependencies: 7
-- Name: studyformseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyformseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyformseq OWNER TO postgres;

--
-- TOC entry 4778 (class 0 OID 0)
-- Dependencies: 2490
-- Name: studyformseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyformseq', 25, true);


--
-- TOC entry 2491 (class 1259 OID 41643)
-- Dependencies: 3543 3544 3545 3546 7
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
-- TOC entry 2492 (class 1259 OID 41653)
-- Dependencies: 7
-- Name: studygradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studygradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studygradetypeseq OWNER TO postgres;

--
-- TOC entry 4780 (class 0 OID 0)
-- Dependencies: 2492
-- Name: studygradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studygradetypeseq', 249, true);


--
-- TOC entry 2493 (class 1259 OID 41655)
-- Dependencies: 3547 3548 3549 3550 3551 3552 3553 3554 3555 3556 3557 3558 3559 3560 3561 7
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
-- TOC entry 2494 (class 1259 OID 41676)
-- Dependencies: 3562 3563 3564 7
-- Name: studygradetypeprerequisite; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE studygradetypeprerequisite (
    studygradetypeid integer NOT NULL,
    requiredstudygradetypeid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.studygradetypeprerequisite OWNER TO postgres;

--
-- TOC entry 2495 (class 1259 OID 41685)
-- Dependencies: 7
-- Name: studyintensityseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyintensityseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyintensityseq OWNER TO postgres;

--
-- TOC entry 4783 (class 0 OID 0)
-- Dependencies: 2495
-- Name: studyintensityseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyintensityseq', 5, true);


--
-- TOC entry 2496 (class 1259 OID 41687)
-- Dependencies: 3565 3566 3567 3568 7
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
-- TOC entry 2497 (class 1259 OID 41697)
-- Dependencies: 7
-- Name: studyplanseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyplanseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyplanseq OWNER TO postgres;

--
-- TOC entry 4785 (class 0 OID 0)
-- Dependencies: 2497
-- Name: studyplanseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyplanseq', 252, true);


--
-- TOC entry 2498 (class 1259 OID 41699)
-- Dependencies: 3569 3570 3571 3572 3573 3574 3575 3576 3577 3578 3579 3580 7
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
-- TOC entry 2499 (class 1259 OID 41717)
-- Dependencies: 7
-- Name: studyplancardinaltimeunitseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyplancardinaltimeunitseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyplancardinaltimeunitseq OWNER TO postgres;

--
-- TOC entry 4787 (class 0 OID 0)
-- Dependencies: 2499
-- Name: studyplancardinaltimeunitseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyplancardinaltimeunitseq', 410, true);


--
-- TOC entry 2500 (class 1259 OID 41719)
-- Dependencies: 3581 3582 3583 3584 3585 3586 3587 7
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
-- TOC entry 2501 (class 1259 OID 41732)
-- Dependencies: 7
-- Name: studyplandetailseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyplandetailseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyplandetailseq OWNER TO postgres;

--
-- TOC entry 4789 (class 0 OID 0)
-- Dependencies: 2501
-- Name: studyplandetailseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyplandetailseq', 1007, true);


--
-- TOC entry 2502 (class 1259 OID 41734)
-- Dependencies: 3588 3589 3590 3591 3592 3593 3594 3595 7
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
-- TOC entry 2503 (class 1259 OID 41748)
-- Dependencies: 3596 3597 3598 3599 3600 3601 7
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
-- TOC entry 2504 (class 1259 OID 41760)
-- Dependencies: 7
-- Name: studyplanstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studyplanstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studyplanstatusseq OWNER TO postgres;

--
-- TOC entry 4792 (class 0 OID 0)
-- Dependencies: 2504
-- Name: studyplanstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studyplanstatusseq', 138, true);


--
-- TOC entry 2505 (class 1259 OID 41762)
-- Dependencies: 3602 3603 3604 3605 7
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
-- TOC entry 2506 (class 1259 OID 41772)
-- Dependencies: 7
-- Name: studytimeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studytimeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studytimeseq OWNER TO postgres;

--
-- TOC entry 4794 (class 0 OID 0)
-- Dependencies: 2506
-- Name: studytimeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studytimeseq', 22, true);


--
-- TOC entry 2507 (class 1259 OID 41774)
-- Dependencies: 3606 3607 3608 3609 7
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
-- TOC entry 2508 (class 1259 OID 41784)
-- Dependencies: 7
-- Name: studytypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE studytypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.studytypeseq OWNER TO postgres;

--
-- TOC entry 4796 (class 0 OID 0)
-- Dependencies: 2508
-- Name: studytypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('studytypeseq', 75, true);


--
-- TOC entry 2509 (class 1259 OID 41786)
-- Dependencies: 3610 3611 3612 3613 7
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
-- TOC entry 2510 (class 1259 OID 41796)
-- Dependencies: 7
-- Name: subjectseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectseq OWNER TO postgres;

--
-- TOC entry 4798 (class 0 OID 0)
-- Dependencies: 2510
-- Name: subjectseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectseq', 1665, true);


--
-- TOC entry 2511 (class 1259 OID 41798)
-- Dependencies: 3614 3615 3616 3617 3618 3619 3620 3621 7
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
-- TOC entry 2512 (class 1259 OID 41812)
-- Dependencies: 7
-- Name: subjectblockseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectblockseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectblockseq OWNER TO postgres;

--
-- TOC entry 4800 (class 0 OID 0)
-- Dependencies: 2512
-- Name: subjectblockseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectblockseq', 131, true);


--
-- TOC entry 2513 (class 1259 OID 41814)
-- Dependencies: 3622 3623 3624 3625 3626 3627 3628 3629 7
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
-- TOC entry 2514 (class 1259 OID 41828)
-- Dependencies: 3630 3631 3632 7
-- Name: subjectblockprerequisite; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectblockprerequisite (
    subjectblockid integer NOT NULL,
    subjectblockstudygradetypeid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.subjectblockprerequisite OWNER TO postgres;

--
-- TOC entry 2515 (class 1259 OID 41837)
-- Dependencies: 7
-- Name: subjectblockstudygradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectblockstudygradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectblockstudygradetypeseq OWNER TO postgres;

--
-- TOC entry 4803 (class 0 OID 0)
-- Dependencies: 2515
-- Name: subjectblockstudygradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectblockstudygradetypeseq', 136, true);


--
-- TOC entry 2516 (class 1259 OID 41839)
-- Dependencies: 3633 3634 3635 3636 3637 7
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
-- TOC entry 2517 (class 1259 OID 41850)
-- Dependencies: 3638 3639 3640 7
-- Name: subjectprerequisite; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectprerequisite (
    subjectid integer NOT NULL,
    subjectstudygradetypeid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.subjectprerequisite OWNER TO postgres;

--
-- TOC entry 2518 (class 1259 OID 41859)
-- Dependencies: 7
-- Name: subjectresultseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectresultseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectresultseq OWNER TO postgres;

--
-- TOC entry 4806 (class 0 OID 0)
-- Dependencies: 2518
-- Name: subjectresultseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectresultseq', 236, true);


--
-- TOC entry 2519 (class 1259 OID 41861)
-- Dependencies: 3641 3642 3643 3644 3645 7
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
-- TOC entry 2520 (class 1259 OID 41872)
-- Dependencies: 7
-- Name: subjectstudygradetypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectstudygradetypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectstudygradetypeseq OWNER TO postgres;

--
-- TOC entry 4808 (class 0 OID 0)
-- Dependencies: 2520
-- Name: subjectstudygradetypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectstudygradetypeseq', 2075, true);


--
-- TOC entry 2521 (class 1259 OID 41874)
-- Dependencies: 3646 3647 3648 3649 3650 7
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
-- TOC entry 2522 (class 1259 OID 41885)
-- Dependencies: 7
-- Name: subjectstudytypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectstudytypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectstudytypeseq OWNER TO postgres;

--
-- TOC entry 4810 (class 0 OID 0)
-- Dependencies: 2522
-- Name: subjectstudytypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectstudytypeseq', 122, true);


--
-- TOC entry 2523 (class 1259 OID 41887)
-- Dependencies: 3651 3652 3653 3654 7
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
-- TOC entry 2524 (class 1259 OID 41897)
-- Dependencies: 7
-- Name: subjectsubjectblockseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectsubjectblockseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectsubjectblockseq OWNER TO postgres;

--
-- TOC entry 4812 (class 0 OID 0)
-- Dependencies: 2524
-- Name: subjectsubjectblockseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectsubjectblockseq', 193, true);


--
-- TOC entry 2525 (class 1259 OID 41899)
-- Dependencies: 3655 3656 3657 3658 7
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
-- TOC entry 2526 (class 1259 OID 41909)
-- Dependencies: 7
-- Name: subjectteacherseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE subjectteacherseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.subjectteacherseq OWNER TO postgres;

--
-- TOC entry 4814 (class 0 OID 0)
-- Dependencies: 2526
-- Name: subjectteacherseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('subjectteacherseq', 394, true);


--
-- TOC entry 2527 (class 1259 OID 41911)
-- Dependencies: 3659 3660 3661 3662 7
-- Name: subjectteacher; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE subjectteacher (
    id integer DEFAULT nextval('subjectteacherseq'::regclass) NOT NULL,
    staffmemberid integer NOT NULL,
    subjectid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.subjectteacher OWNER TO postgres;

--
-- TOC entry 2528 (class 1259 OID 41921)
-- Dependencies: 7
-- Name: tabledependencyseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE tabledependencyseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.tabledependencyseq OWNER TO postgres;

--
-- TOC entry 4816 (class 0 OID 0)
-- Dependencies: 2528
-- Name: tabledependencyseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('tabledependencyseq', 80, true);


--
-- TOC entry 2529 (class 1259 OID 41923)
-- Dependencies: 3663 3664 3665 3666 7
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
-- TOC entry 2530 (class 1259 OID 41933)
-- Dependencies: 7
-- Name: targetgroupseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE targetgroupseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.targetgroupseq OWNER TO postgres;

--
-- TOC entry 4818 (class 0 OID 0)
-- Dependencies: 2530
-- Name: targetgroupseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('targetgroupseq', 16, true);


--
-- TOC entry 2531 (class 1259 OID 41935)
-- Dependencies: 3667 3668 3669 3670 7
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
-- TOC entry 2532 (class 1259 OID 41945)
-- Dependencies: 7
-- Name: testseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE testseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.testseq OWNER TO postgres;

--
-- TOC entry 4820 (class 0 OID 0)
-- Dependencies: 2532
-- Name: testseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('testseq', 94, true);


--
-- TOC entry 2533 (class 1259 OID 41947)
-- Dependencies: 3671 3672 3673 3674 7
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
-- TOC entry 2534 (class 1259 OID 41957)
-- Dependencies: 7
-- Name: testresultseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE testresultseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.testresultseq OWNER TO postgres;

--
-- TOC entry 4822 (class 0 OID 0)
-- Dependencies: 2534
-- Name: testresultseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('testresultseq', 74, true);


--
-- TOC entry 2535 (class 1259 OID 41959)
-- Dependencies: 3675 3676 3677 3678 3679 3680 7
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
-- TOC entry 2536 (class 1259 OID 41971)
-- Dependencies: 7
-- Name: testteacherseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE testteacherseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.testteacherseq OWNER TO postgres;

--
-- TOC entry 4824 (class 0 OID 0)
-- Dependencies: 2536
-- Name: testteacherseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('testteacherseq', 103, true);


--
-- TOC entry 2537 (class 1259 OID 41973)
-- Dependencies: 3681 3682 3683 3684 7
-- Name: testteacher; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE testteacher (
    id integer DEFAULT nextval('testteacherseq'::regclass) NOT NULL,
    staffmemberid integer NOT NULL,
    testid integer NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.testteacher OWNER TO postgres;

--
-- TOC entry 2538 (class 1259 OID 41983)
-- Dependencies: 7
-- Name: thesisseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE thesisseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.thesisseq OWNER TO postgres;

--
-- TOC entry 4826 (class 0 OID 0)
-- Dependencies: 2538
-- Name: thesisseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('thesisseq', 52, true);


--
-- TOC entry 2539 (class 1259 OID 41985)
-- Dependencies: 3685 3686 3687 3688 3689 3690 3691 7
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
-- TOC entry 2540 (class 1259 OID 41998)
-- Dependencies: 7
-- Name: thesisresultseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE thesisresultseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.thesisresultseq OWNER TO postgres;

--
-- TOC entry 4828 (class 0 OID 0)
-- Dependencies: 2540
-- Name: thesisresultseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('thesisresultseq', 3, true);


--
-- TOC entry 2541 (class 1259 OID 42000)
-- Dependencies: 3692 3693 3694 3695 3696 3697 3698 7
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
-- TOC entry 2542 (class 1259 OID 42013)
-- Dependencies: 7
-- Name: thesisstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE thesisstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.thesisstatusseq OWNER TO postgres;

--
-- TOC entry 4830 (class 0 OID 0)
-- Dependencies: 2542
-- Name: thesisstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('thesisstatusseq', 12, true);


--
-- TOC entry 2543 (class 1259 OID 42015)
-- Dependencies: 3699 3700 3701 3702 7
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
-- TOC entry 2544 (class 1259 OID 42025)
-- Dependencies: 7
-- Name: thesissupervisorseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE thesissupervisorseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.thesissupervisorseq OWNER TO postgres;

--
-- TOC entry 4832 (class 0 OID 0)
-- Dependencies: 2544
-- Name: thesissupervisorseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('thesissupervisorseq', 23, true);


--
-- TOC entry 2545 (class 1259 OID 42027)
-- Dependencies: 3703 3704 3705 3706 3707 7
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
-- TOC entry 2546 (class 1259 OID 42038)
-- Dependencies: 7
-- Name: thesisthesisstatusseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE thesisthesisstatusseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.thesisthesisstatusseq OWNER TO postgres;

--
-- TOC entry 4834 (class 0 OID 0)
-- Dependencies: 2546
-- Name: thesisthesisstatusseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('thesisthesisstatusseq', 3, true);


--
-- TOC entry 2547 (class 1259 OID 42040)
-- Dependencies: 3708 3709 3710 3711 7
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
-- TOC entry 2548 (class 1259 OID 42050)
-- Dependencies: 7
-- Name: timeunitseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE timeunitseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.timeunitseq OWNER TO postgres;

--
-- TOC entry 4836 (class 0 OID 0)
-- Dependencies: 2548
-- Name: timeunitseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('timeunitseq', 83, true);


--
-- TOC entry 2549 (class 1259 OID 42052)
-- Dependencies: 3712 3713 3714 3715 7
-- Name: timeunit; Type: TABLE; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE TABLE timeunit (
    id integer DEFAULT nextval('timeunitseq'::regclass) NOT NULL,
    code character varying NOT NULL,
    lang character(6) NOT NULL,
    active character(1) DEFAULT 'Y'::bpchar NOT NULL,
    description character varying,
    writewho character varying DEFAULT 'opuscollege'::character varying NOT NULL,
    writewhen timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE opuscollege.timeunit OWNER TO postgres;

--
-- TOC entry 2550 (class 1259 OID 42062)
-- Dependencies: 7
-- Name: unitareaseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE unitareaseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.unitareaseq OWNER TO postgres;

--
-- TOC entry 4838 (class 0 OID 0)
-- Dependencies: 2550
-- Name: unitareaseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('unitareaseq', 6, true);


--
-- TOC entry 2551 (class 1259 OID 42064)
-- Dependencies: 3716 3717 3718 3719 7
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
-- TOC entry 2552 (class 1259 OID 42074)
-- Dependencies: 7
-- Name: unittypeseq; Type: SEQUENCE; Schema: opuscollege; Owner: postgres
--

CREATE SEQUENCE unittypeseq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE opuscollege.unittypeseq OWNER TO postgres;

--
-- TOC entry 4840 (class 0 OID 0)
-- Dependencies: 2552
-- Name: unittypeseq; Type: SEQUENCE SET; Schema: opuscollege; Owner: postgres
--

SELECT pg_catalog.setval('unittypeseq', 73, true);


--
-- TOC entry 2553 (class 1259 OID 42076)
-- Dependencies: 3720 3721 3722 3723 7
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

SET search_path = audit, pg_catalog;

--
-- TOC entry 4310 (class 0 OID 39795)
-- Dependencies: 2213
-- Data for Name: acc_accommodationfee_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY acc_accommodationfee_hist (operation, accommodationfeeid, hosteltypecode, roomtypecode, feeid, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4311 (class 0 OID 39803)
-- Dependencies: 2214
-- Data for Name: acc_block_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY acc_block_hist (operation, id, code, description, hostelid, numberoffloors, writewho, writewhen, active) FROM stdin;
\.


--
-- TOC entry 4312 (class 0 OID 39811)
-- Dependencies: 2215
-- Data for Name: acc_hostel_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY acc_hostel_hist (operation, id, code, description, numberoffloors, hosteltypecode, writewho, writewhen, active) FROM stdin;
\.


--
-- TOC entry 4313 (class 0 OID 39819)
-- Dependencies: 2216
-- Data for Name: acc_room_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY acc_room_hist (operation, id, code, description, numberofbedspaces, hostelid, blockid, floornumber, writewho, writewhen, active, availablebedspace, roomtypecode) FROM stdin;
\.


--
-- TOC entry 4314 (class 0 OID 39827)
-- Dependencies: 2217
-- Data for Name: acc_studentaccommodation_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY acc_studentaccommodation_hist (operation, id, studentid, bednumber, academicyearid, dateapplied, dateapproved, approved, approvedbyid, accepted, dateaccepted, reasonforapplyingforaccommodation, comment, roomid, writewho, writewhen, allocated, datedeallocated) FROM stdin;
\.


--
-- TOC entry 4315 (class 0 OID 39835)
-- Dependencies: 2218
-- Data for Name: cardinaltimeunitresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY cardinaltimeunitresult_hist (operation, writewho, writewhen, id, studyplanid, studyplancardinaltimeunitid, cardinaltimeunitresultdate, active, passed, mark, endgradecomment) FROM stdin;
\.


--
-- TOC entry 4316 (class 0 OID 39847)
-- Dependencies: 2219
-- Data for Name: endgrade_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY endgrade_hist (operation, id, code, lang, active, endgradetypecode, gradepoint, percentagemin, percentagemax, comment, description, temporarygrade, writewho, writewhen, passed, academicyearid) FROM stdin;
\.


--
-- TOC entry 4317 (class 0 OID 39855)
-- Dependencies: 2220
-- Data for Name: examinationresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY examinationresult_hist (operation, writewho, writewhen, id, examinationid, subjectid, studyplandetailid, examinationresultdate, attemptnr, mark, staffmemberid, active, passed, subjectresultid) FROM stdin;
\.


--
-- TOC entry 4318 (class 0 OID 39864)
-- Dependencies: 2221
-- Data for Name: fee_fee_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY fee_fee_hist (operation, writewho, writewhen, id, feedue, deadline, categorycode, subjectblockstudygradetypeid, subjectstudygradetypeid, studygradetypeid, academicyearid, numberofinstallments, tuitionwaiverdiscountpercentage, fulltimestudentdiscountpercentage, localstudentdiscountpercentage, continuedregistrationdiscountpercentage, postgraduatediscountpercentage, active, branchid, studyintensitycode, feeunitcode, applicationmode, cardinaltimeunitnumber) FROM stdin;
\.


--
-- TOC entry 4319 (class 0 OID 39887)
-- Dependencies: 2222
-- Data for Name: fee_feedeadline_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY fee_feedeadline_hist (operation, id, feeid, deadline, active, writewho, writewhen, cardinaltimeunitcode, cardinaltimeunitnumber) FROM stdin;
\.


--
-- TOC entry 4320 (class 0 OID 39895)
-- Dependencies: 2223
-- Data for Name: fee_payment_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY fee_payment_hist (operation, writewho, writewhen, id, paydate, studentid, feeid, studentbalanceid, installmentnumber, sumpaid, active) FROM stdin;
\.


--
-- TOC entry 4321 (class 0 OID 39909)
-- Dependencies: 2224
-- Data for Name: financialrequest_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY financialrequest_hist (operation, writewho, id, requestid, requesttypeid, financialrequestid, statuscode, timestampreceived, requestversion, requeststring, timestampmodified, errorcode, processedtofinancetransaction, errorreportedtofinancialsystem, writewhen) FROM stdin;
\.


--
-- TOC entry 4322 (class 0 OID 39920)
-- Dependencies: 2225
-- Data for Name: financialtransaction_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY financialtransaction_hist (operation, writewho, id, transactiontypeid, financialrequestid, requestid, statuscode, errorcode, nationalregistrationnumber, academicyearid, timestampprocessed, amount, name, cell, requeststring, processedtostudentbalance, errorreportedtofinancialbankrequest, writewhen, studentcode) FROM stdin;
\.


--
-- TOC entry 4323 (class 0 OID 39930)
-- Dependencies: 2226
-- Data for Name: gradedsecondaryschoolsubject_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY gradedsecondaryschoolsubject_hist (operation, id, secondaryschoolsubjectid, studyplanid, grade, active, writewho, writewhen, secondaryschoolsubjectgroupid, level) FROM stdin;
\.


--
-- TOC entry 4324 (class 0 OID 39939)
-- Dependencies: 2227
-- Data for Name: sch_sponsor_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY sch_sponsor_hist (operation, id, code, name, active, writewho, writewhen, sponsortypecode) FROM stdin;
D	12	1	GOVERNMENT OF ZAMBIA	Y	admin:226	2012-11-11 12:24:29.895	
D	13	2	ZAMBIA ARMY	Y	admin:226	2012-11-11 12:24:32.469	
D	14	3	AA INSTITUTE	Y	admin:226	2012-11-11 12:24:34.824	
D	15	4	UGANDAN GOVERNMENT	Y	admin:226	2012-11-11 12:24:37.352	
D	16	5	BARCLAYS BANK	Y	admin:226	2012-11-11 12:24:40.409	
D	17	6	SIAME ASSOCIATES	Y	admin:226	2012-11-11 12:24:43.124	
D	18	7	BOTSWANA GOVERNMENT	Y	admin:226	2012-11-11 12:24:46.852	
D	19	8	MOBILE OIL (z) LTD	Y	admin:226	2012-11-11 12:24:49.364	
D	20	11	RETIRED STAFF	Y	admin:226	2012-11-11 12:24:52.718	
D	21	12	UNIVERSITY OF ZAMBIA	Y	admin:226	2012-11-11 12:24:55.65	
D	22	13	STUDENT	Y	admin:226	2012-11-11 12:24:58.614	
D	23	14	GUARDIAN	Y	admin:226	2012-11-11 12:25:01.017	
\.


--
-- TOC entry 4325 (class 0 OID 39946)
-- Dependencies: 2228
-- Data for Name: sch_sponsorfeepercentage_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY sch_sponsorfeepercentage_hist (operation, id, feecategorycode, percentage, writewho, writewhen, sponsorid, active) FROM stdin;
\.


--
-- TOC entry 4326 (class 0 OID 39953)
-- Dependencies: 2229
-- Data for Name: staffmember_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY staffmember_hist (operation, staffmemberid, staffmembercode, personid, dateofappointment, appointmenttypecode, stafftypecode, primaryunitofappointmentid, educationtypecode, writewho, writewhen, startworkday, endworkday, teachingdaypartcode, supervisingdaypartcode, id, personcode, active, surnamefull, surnamealias, firstnamesfull, firstnamesalias, nationalregistrationnumber, civiltitlecode, gradetypecode, gendercode, birthdate, nationalitycode, placeofbirth, districtofbirthcode, provinceofbirthcode, countryofbirthcode, cityoforigin, administrativepostoforigincode, districtoforigincode, provinceoforigincode, countryoforigincode, civilstatuscode, housingoncampus, identificationtypecode, identificationnumber, identificationplaceofissue, identificationdateofissue, identificationdateofexpiration, professioncode, professiondescription, languagefirstcode, languagefirstmasteringlevelcode, languagesecondcode, languagesecondmasteringlevelcode, languagethirdcode, languagethirdmasteringlevelcode, contactpersonemergenciesname, contactpersonemergenciestelephonenumber, bloodtypecode, healthissues, photograph, remarks, registrationdate, photographname, photographmimetype, publichomepage, socialnetworks, hobbies, motivation) FROM stdin;
U	101	STA6417052011141947	242	2008-01-01	1	1	94	3	Admin101:226	2012-10-15 17:03:36.179	\N	\N	\N	\N	242	P897897	Y	Admin	\N	M.M.J.	M.M.		0	0	1	1950-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2012-10-15	\N	\N	N	\N	\N	\N
U	101	STA6417052011141947	242	2008-01-01	1	1	94	3	Admin101:226	2012-10-15 17:03:50.398	\N	\N	\N	\N	242	P897897	Y	Admin	\N	M.M.J.	M.M.		0	0	1	1950-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2012-10-15	\N	\N	N	\N	\N	\N
U	101	STA6417052011141947	242	2008-01-01	1	1	94	3	Admin101:226	2012-10-15 17:03:58.882	\N	\N	\N	\N	242	P897897	Y	Admin	\N	M.M.J.	M.M.		0	0	1	1950-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2012-10-15	\N	\N	N	\N	\N	\N
U	72	STA022022011112253	183	\N	1	1	94	3	admin:226	2012-11-11 12:38:05.778	\N	\N	\N	\N	183	P0987	Y	Registrar	\N	V.C.		234243234	1	PHD	1	1960-09-23	130	Ndola	0	ZM-02	894	Lusaka	\N	0	ZM-05	894	1	N	3	12430802834	Lusaka	2010-10-20	2020-10-20	\N	Professor	eng	1	cha	1	dut	2	Mother	034554235235	3	\N	\N	The photo didn't upload	2012-11-11	\N	\N	Y	Facebook and twitter	Reading\r\nMovies	\N
U	101	STA6417052011141947	242	2008-01-01	1	1	94	3	admin:226	2012-11-11 12:38:15.06	\N	\N	\N	\N	242	P897897	Y	Admin	\N	M.M.J.	M.M.		0	0	1	1950-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2012-11-11	\N	\N	N	\N	\N	\N
\.


--
-- TOC entry 4327 (class 0 OID 39967)
-- Dependencies: 2230
-- Data for Name: student_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY student_hist (operation, studentid, studentcode, personid, dateofenrolment, primarystudyid, expellationdate, reasonforexpellation, previousinstitutionid, previousinstitutionname, previousinstitutiondistrictcode, previousinstitutionprovincecode, previousinstitutioncountrycode, previousinstitutioneducationtypecode, previousinstitutionfinalgradetypecode, previousinstitutionfinalmark, previousinstitutiondiplomaphotograph, scholarship, fatherfullname, fathereducationcode, fatherprofessioncode, fatherprofessiondescription, motherfullname, mothereducationcode, motherprofessioncode, motherprofessiondescription, financialguardianfullname, financialguardianrelation, financialguardianprofession, writewho, writewhen, expellationenddate, expellationtypecode, previousinstitutiondiplomaphotographremarks, previousinstitutiondiplomaphotographname, previousinstitutiondiplomaphotographmimetype, subscriptionrequirementsfulfilled, secondarystudyid, foreignstudent, nationalitygroupcode, fathertelephone, mothertelephone, relativeofstaffmember, relativestaffmemberid, ruralareaorigin, id, personcode, active, surnamefull, surnamealias, firstnamesfull, firstnamesalias, nationalregistrationnumber, civiltitlecode, gradetypecode, gendercode, birthdate, nationalitycode, placeofbirth, districtofbirthcode, provinceofbirthcode, countryofbirthcode, cityoforigin, administrativepostoforigincode, districtoforigincode, provinceoforigincode, countryoforigincode, civilstatuscode, housingoncampus, identificationtypecode, identificationnumber, identificationplaceofissue, identificationdateofissue, identificationdateofexpiration, professioncode, professiondescription, languagefirstcode, languagefirstmasteringlevelcode, languagesecondcode, languagesecondmasteringlevelcode, languagethirdcode, languagethirdmasteringlevelcode, contactpersonemergenciesname, contactpersonemergenciestelephonenumber, bloodtypecode, healthissues, photograph, remarks, registrationdate, photographname, photographmimetype, publichomepage, socialnetworks, hobbies, motivation) FROM stdin;
\.


--
-- TOC entry 4328 (class 0 OID 39992)
-- Dependencies: 2231
-- Data for Name: studentabsence_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY studentabsence_hist (operation, id, studentid, startdatetemporaryinactivity, enddatetemporaryinactivity, reasonforabsence, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4329 (class 0 OID 39999)
-- Dependencies: 2232
-- Data for Name: studentbalance_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY studentbalance_hist (operation, writewho, writewhen, id, studentid, feeid, studyplancardinaltimeunitid, studyplandetailid, academicyearid, exemption, studentaccommodationid) FROM stdin;
\.


--
-- TOC entry 4330 (class 0 OID 40014)
-- Dependencies: 2233
-- Data for Name: studentexpulsion_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY studentexpulsion_hist (operation, id, studentid, startdate, enddate, expulsiontypecode, reasonforexpulsion, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4331 (class 0 OID 40021)
-- Dependencies: 2234
-- Data for Name: studyplanresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY studyplanresult_hist (operation, writewho, writewhen, id, studyplanid, examdate, finalmark, mark, active, passed) FROM stdin;
\.


--
-- TOC entry 4332 (class 0 OID 40029)
-- Dependencies: 2235
-- Data for Name: subjectresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY subjectresult_hist (operation, writewho, writewhen, id, subjectid, studyplandetailid, subjectresultdate, mark, staffmemberid, active, passed, endgradecomment) FROM stdin;
\.


--
-- TOC entry 4333 (class 0 OID 40037)
-- Dependencies: 2236
-- Data for Name: testresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY testresult_hist (operation, writewho, writewhen, id, testid, examinationid, studyplandetailid, testresultdate, attemptnr, mark, passed, staffmemberid, active, examinationresultid) FROM stdin;
\.


--
-- TOC entry 4334 (class 0 OID 40046)
-- Dependencies: 2237
-- Data for Name: thesisresult_hist; Type: TABLE DATA; Schema: audit; Owner: postgres
--

COPY thesisresult_hist (operation, writewho, writewhen, id, studyplanid, thesisid, thesisresultdate, mark, active, passed) FROM stdin;
\.


SET search_path = opuscollege, pg_catalog;

--
-- TOC entry 4335 (class 0 OID 40056)
-- Dependencies: 2239
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
-- TOC entry 4336 (class 0 OID 40068)
-- Dependencies: 2241
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
-- TOC entry 4337 (class 0 OID 40081)
-- Dependencies: 2243
-- Data for Name: acc_accommodationfee; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_accommodationfee (accommodationfeeid, hosteltypecode, roomtypecode, feeid) FROM stdin;
\.


--
-- TOC entry 4338 (class 0 OID 40094)
-- Dependencies: 2247
-- Data for Name: acc_block; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_block (id, code, description, hostelid, numberoffloors, writewho, writewhen, active) FROM stdin;
\.


--
-- TOC entry 4339 (class 0 OID 40106)
-- Dependencies: 2249
-- Data for Name: acc_hostel; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_hostel (id, code, description, numberoffloors, hosteltypecode, writewho, writewhen, active) FROM stdin;
\.


--
-- TOC entry 4340 (class 0 OID 40121)
-- Dependencies: 2251
-- Data for Name: acc_hosteltype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_hosteltype (id, code, description, lang, writewho, writewhen, active) FROM stdin;
\.


--
-- TOC entry 4341 (class 0 OID 40134)
-- Dependencies: 2253
-- Data for Name: acc_room; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_room (id, code, description, numberofbedspaces, hostelid, blockid, floornumber, writewho, writewhen, active, availablebedspace, roomtypecode) FROM stdin;
\.


--
-- TOC entry 4342 (class 0 OID 40150)
-- Dependencies: 2255
-- Data for Name: acc_roomtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_roomtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4343 (class 0 OID 40162)
-- Dependencies: 2257
-- Data for Name: acc_studentaccommodation; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY acc_studentaccommodation (id, studentid, bednumber, academicyearid, dateapplied, dateapproved, approved, approvedbyid, accepted, dateaccepted, reasonforapplyingforaccommodation, comment, roomid, writewho, writewhen, allocated, datedeallocated) FROM stdin;
\.


--
-- TOC entry 4344 (class 0 OID 40182)
-- Dependencies: 2260
-- Data for Name: address; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY address (id, addresstypecode, personid, studyid, organizationalunitid, active, street, number, numberextension, zipcode, pobox, city, administrativepostcode, districtcode, provincecode, countrycode, telephone, faxnumber, mobilephone, emailaddress, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4345 (class 0 OID 40198)
-- Dependencies: 2262
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
-- TOC entry 4346 (class 0 OID 40210)
-- Dependencies: 2264
-- Data for Name: administrativepost; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY administrativepost (id, code, lang, active, description, districtcode, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4347 (class 0 OID 40222)
-- Dependencies: 2266
-- Data for Name: admissionregistrationconfig; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY admissionregistrationconfig (id, organizationalunitid, academicyearid, startofregistration, endofregistration, active, writewho, writewhen, startofadmission, endofadmission, startofrefundperiod, endofrefundperiod) FROM stdin;
\.


--
-- TOC entry 4348 (class 0 OID 40234)
-- Dependencies: 2268
-- Data for Name: appconfig; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY appconfig (id, appconfigattributename, appconfigattributevalue, writewho, writewhen, startdate, enddate) FROM stdin;
62	academicYearOfAdmission	14	opuscollege	2012-10-02 18:07:04.815	2011-01-01	2011-12-31
63	academicYearOfAdmission	16	opuscollege	2012-10-02 18:07:04.815	2012-01-01	2012-12-31
64	academicYearOfAdmission	17	opuscollege	2012-10-02 18:07:04.815	2013-01-01	2013-12-31
1	numberOfSubjectsToCountForStudyPlanMark	16	opuscollege	2011-07-25 14:14:50.826485	1970-01-01	\N
5	numberOfSubjectsToGrade	5	opuscollege	2011-12-13 14:50:39.092887	1970-01-01	\N
23	cntdRegistrationBachelorCutOffPointCreditFemale	2	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
24	cntdRegistrationBachelorCutOffPointCreditMale	1	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
25	cntdRegistrationMasterCutOffPointCreditFemale	0.5	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
26	cntdRegistrationMasterCutOffPointCreditMale	1	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
27	admissionBachelorCutOffPointCreditFemale	1	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
28	admissionBachelorCutOffPointCreditMale	3	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
29	cntdRegistrationBachelorCutOffPointRelativesCreditFemale	2.5	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
30	cntdRegistrationBachelorCutOffPointRelativesCreditMale	1.5	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
31	cntdRegistrationMasterCutOffPointRelativesCreditFemale	0	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
32	cntdRegistrationMasterCutOffPointRelativesCreditMale	0.5	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
33	admissionBachelorCutOffPointRelativesCreditFemale	0	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
34	admissionBachelorCutOffPointRelativesCreditMale	2	opuscollege	2012-01-26 12:52:28.394172	1970-01-01	\N
36	maxUploadSizeImage	300000	opuscollege	2012-04-03 13:12:04.889282	1970-01-01	\N
37	maxUploadSizeDoc	300000	opuscollege	2012-04-03 13:12:04.889282	1970-01-01	\N
38	useOfStudentBalancesGeneration	Y	opuscollege	2012-04-03 14:00:36.224466	1970-01-01	\N
39	admissionInitialStudyPlanStatus	1	opuscollege	2012-04-16 14:01:11.752894	1970-01-01	\N
40	cntdRegistrationInitialCardinalTimeUnitStatus	5	opuscollege	2012-04-16 14:01:11.752894	1970-01-01	\N
43	useOfFinanceMenu	Y	opuscollege	2012-04-17 15:07:15.786107	1970-01-01	\N
53	BANK_RESPONSE_URL	127.0.0.1	opuscollege	2012-04-23 17:41:18.553256	1970-01-01	\N
55	admissionBachelorCutOffPointCreditRuralAreas	-0.5	opuscollege	2012-05-14 16:56:00.942047	1970-01-01	\N
42	administratorMailAddress	admin@unza.zm	opuscollege	2012-04-17 15:03:26.508134	1970-01-01	\N
9	smtpBulkServerAddress	smtp.unza.zm	opuscollege	2011-12-22 14:05:47.862809	1970-01-01	\N
8	smtpServerAddress	smtp.unza.zm	opuscollege	2011-12-22 13:36:18.039582	1970-01-01	\N
56	useOfScholarshipPercentages	Y	opuscollege	2012-05-25 14:39:12.273	1970-01-01	\N
57	useOfScholarshipDecisionCriteria	N	opuscollege	2012-05-25 14:39:12.273	1970-01-01	\N
41	useOfSubjectBlocks	N	opuscollege	2012-04-16 14:01:33.045436	1970-01-01	\N
58	useOfSubsidies	N	opuscollege	2012-05-25 14:40:36.636	1970-01-01	\N
60	BANK_WHITELIST_ADDRESSES	127.0.0.1,72.229.186.130,41.72.96.130,192.168.99.5,41.133.54.17	opuscollege	2012-10-02 18:07:04.815	1970-01-01	\N
61	mailEnabled	N	opuscollege	2012-10-02 18:07:04.815	1970-01-01	\N
65	USE_HOSTELBLOCKS	Y	opuscollege	2012-10-02 18:07:04.815	1970-01-01	\N
\.


--
-- TOC entry 4349 (class 0 OID 40247)
-- Dependencies: 2270
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
-- TOC entry 4350 (class 0 OID 40259)
-- Dependencies: 2272
-- Data for Name: appointmenttype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY appointmenttype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
11	1	en    	Y	tenured	opuscollege	2010-11-02 16:22:58.674788
12	2	en    	Y	associate	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4351 (class 0 OID 40271)
-- Dependencies: 2274
-- Data for Name: appversions; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY appversions (id, writewho, writewhen, module, state, db, dbversion) FROM stdin;
49	opuscollege	2010-04-07 15:26:39.196747	alumni	A	Y	3.00
71	opuscollege	2011-05-17 14:01:34.875173	dbconversion	A	Y	3.12
103	opuscollege	2011-10-18 15:17:25.608551	mozambique	A	Y	3.21
104	opuscollege	2011-10-18 15:17:37.064825	netherlands	A	Y	3.21
124	opuscollege	2011-12-22 13:42:22.798643	ucm	A	Y	3.03
135	opuscollege	2012-04-03 13:10:19.726344	cbu	A	Y	3.16
198	opuscollege	2012-10-15 17:04:33.366	accommodation	A	Y	4.00
199	opuscollege	2012-10-15 17:04:33.366	accommodationfee	A	Y	4.00
200	opuscollege	2012-10-15 17:04:33.366	admission	A	Y	4.00
201	opuscollege	2012-10-15 17:04:33.366	college	A	Y	4.00
203	opuscollege	2012-10-15 17:04:33.366	report	A	Y	4.00
204	opuscollege	2012-10-15 17:04:33.366	scholarship	A	Y	4.00
205	opuscollege	2012-10-15 17:04:33.366	unza	A	Y	4.00
206	opuscollege	2012-10-15 17:04:33.366	zambia	A	Y	4.00
207	opuscollege	2012-10-15 17:04:33.366	fee	A	Y	4.01
\.


--
-- TOC entry 4352 (class 0 OID 40284)
-- Dependencies: 2275
-- Data for Name: authorisation; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY authorisation (code, description, active, writewho, writewhen) FROM stdin;
E	editable	Y	opuscollege	2010-09-30 14:20:03.500628
V	visible	Y	opuscollege	2010-09-30 14:20:03.500628
H	hidden	Y	opuscollege	2010-09-30 14:20:03.500628
\.


--
-- TOC entry 4353 (class 0 OID 40295)
-- Dependencies: 2277
-- Data for Name: blocktype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY blocktype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
5	1	en    	Y	thematic	opuscollege	2010-11-02 16:22:58.674788
6	2	en    	Y	study year	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4354 (class 0 OID 40307)
-- Dependencies: 2279
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
-- TOC entry 4355 (class 0 OID 40319)
-- Dependencies: 2281
-- Data for Name: branch; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY branch (id, branchcode, branchdescription, institutionid, active, registrationdate, writewho, writewhen) FROM stdin;
120	01	Central Registry	120	Y	2010-10-16	opuscollege	2010-10-16 17:23:16.594706
\.


--
-- TOC entry 4356 (class 0 OID 40332)
-- Dependencies: 2283
-- Data for Name: cardinaltimeunit; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY cardinaltimeunit (id, code, lang, active, description, writewho, writewhen, nrofunitsperyear) FROM stdin;
13	1	en    	Y	year	opuscollege	2011-07-22 18:08:38.426949	1
14	2	en    	Y	semester	opuscollege	2011-07-22 18:08:38.426949	2
15	3	en    	Y	trimester	opuscollege	2011-07-22 18:08:38.426949	3
\.


--
-- TOC entry 4357 (class 0 OID 40345)
-- Dependencies: 2285
-- Data for Name: cardinaltimeunitresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY cardinaltimeunitresult (id, studyplanid, studyplancardinaltimeunitid, cardinaltimeunitresultdate, active, passed, writewho, writewhen, mark, endgradecomment) FROM stdin;
\.


--
-- TOC entry 4358 (class 0 OID 40360)
-- Dependencies: 2287
-- Data for Name: cardinaltimeunitstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY cardinaltimeunitstatus (id, code, lang, description, active, writewho, writewhen) FROM stdin;
17	5	en    	Waiting for payment	Y	opuscollege	2011-10-27 15:16:18.2245
18	6	en    	Waiting for selection	Y	opuscollege	2011-10-27 15:16:18.2245
19	7	en    	Customize programme	Y	opuscollege	2011-10-27 15:16:18.2245
20	8	en    	Waiting for approval of registration	Y	opuscollege	2011-10-27 15:16:18.2245
21	9	en    	Rejected registration	Y	opuscollege	2011-10-27 15:16:18.2245
22	10	en    	Actively registered	Y	opuscollege	2011-10-27 15:16:18.2245
23	20	en    	Request for change	Y	opuscollege	2011-10-27 15:16:18.2245
\.


--
-- TOC entry 4359 (class 0 OID 40372)
-- Dependencies: 2289
-- Data for Name: cardinaltimeunitstudygradetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY cardinaltimeunitstudygradetype (id, studygradetypeid, cardinaltimeunitnumber, numberofelectivesubjectblocks, numberofelectivesubjects, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4360 (class 0 OID 40387)
-- Dependencies: 2291
-- Data for Name: careerposition; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY careerposition (id, studyplanid, employer, startdate, enddate, careerposition, responsibility, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4361 (class 0 OID 40399)
-- Dependencies: 2293
-- Data for Name: civilstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY civilstatus (id, code, lang, active, description, writewho, writewhen) FROM stdin;
17	1	en    	Y	married	opuscollege	2010-11-02 16:22:58.674788
18	2	en    	Y	single	opuscollege	2010-11-02 16:22:58.674788
19	3	en    	Y	widow	opuscollege	2010-11-02 16:22:58.674788
20	4	en    	Y	divorced	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4362 (class 0 OID 40411)
-- Dependencies: 2295
-- Data for Name: civiltitle; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY civiltitle (id, code, lang, active, description, writewho, writewhen) FROM stdin;
10	1	en    	Y	mr.	opuscollege	2010-11-02 16:22:58.674788
11	2	en    	Y	mrs.	opuscollege	2010-11-02 16:22:58.674788
12	3	en    	Y	ms.	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4363 (class 0 OID 40423)
-- Dependencies: 2297
-- Data for Name: contract; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY contract (id, contractcode, staffmemberid, contracttypecode, contractdurationcode, contractstartdate, contractenddate, contacthours, fteappointmentoverall, fteeducation, fteresearch, fteadministrativetasks, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4364 (class 0 OID 40435)
-- Dependencies: 2299
-- Data for Name: contractduration; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY contractduration (id, code, lang, active, description, writewho, writewhen) FROM stdin;
5	1	en    	Y	permanent	opuscollege	2010-11-02 16:22:58.674788
6	2	en    	Y	temporary	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4365 (class 0 OID 40447)
-- Dependencies: 2301
-- Data for Name: contracttype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY contracttype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
9	1	en    	Y	full	opuscollege	2010-11-02 16:22:58.674788
10	2	en    	Y	partial	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4366 (class 0 OID 40459)
-- Dependencies: 2303
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
-- TOC entry 4367 (class 0 OID 40471)
-- Dependencies: 2305
-- Data for Name: daypart; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY daypart (id, code, lang, active, description, writewho, writewhen) FROM stdin;
4	1	en    	Y	morning	opuscollege	2010-08-23 22:46:06.977017
6	3	en    	Y	evening	opuscollege	2010-08-23 22:46:06.977017
5	2	en    	Y	afternoon	opuscollege	2010-08-23 22:46:06.977017
\.


--
-- TOC entry 4368 (class 0 OID 40483)
-- Dependencies: 2307
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
-- TOC entry 4369 (class 0 OID 40495)
-- Dependencies: 2309
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
-- TOC entry 4370 (class 0 OID 40507)
-- Dependencies: 2311
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
-- TOC entry 4371 (class 0 OID 40519)
-- Dependencies: 2313
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
-- TOC entry 4372 (class 0 OID 40531)
-- Dependencies: 2315
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
857	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-07-26 18:00:59.70967	N	8
927	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	19
997	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1067	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1137	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1207	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1277	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1347	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1417	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1487	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1557	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1627	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1697	U	en    	Y	AR	0.00	0.00	54.70	Unsatisfactory		N	opuscollege	2011-12-13 16:51:25.592402	N	20
900	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
901	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
902	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
903	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
904	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
906	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
907	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
908	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
909	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
910	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
911	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
912	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
914	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
915	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
916	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
917	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
918	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
919	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
920	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
921	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
922	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
923	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
924	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
925	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-07-26 18:00:59.70967	Y	8
858	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
860	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
861	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
862	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
863	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
864	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
865	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
866	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
868	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
869	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
870	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
871	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
872	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
873	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
874	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
876	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
877	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
878	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
879	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
880	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-07-26 18:00:59.70967	N	8
881	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
883	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
884	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
885	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
886	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
887	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-07-26 18:00:59.70967	N	8
888	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
890	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
891	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
892	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
893	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
894	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
895	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
896	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
898	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
899	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
928	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
930	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
931	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
932	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
933	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
934	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
935	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
936	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
938	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
939	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
940	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
941	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
942	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
943	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
944	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
946	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
947	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
948	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
949	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
950	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	19
951	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
953	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
954	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
955	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
956	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
957	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	19
958	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
960	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
961	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
962	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
963	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
964	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
965	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
966	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
968	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
969	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
970	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
971	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
972	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
973	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1482	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
974	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
976	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
977	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
978	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
979	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
980	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
981	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
982	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
984	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
985	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
986	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
987	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
988	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
989	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
990	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
991	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
992	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
993	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
994	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
995	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	19
998	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1000	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1001	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1002	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1003	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1004	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1005	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1006	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1008	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1009	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1010	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1011	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1012	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1013	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1014	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1016	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1017	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1018	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1019	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1020	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1021	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1023	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1024	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1025	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1026	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1027	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1028	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1030	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1031	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1032	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1033	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1034	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1035	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1036	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1038	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1039	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1040	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1041	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1042	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1043	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1044	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1483	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1046	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1047	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1048	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1049	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1050	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1051	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1052	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1054	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1055	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1056	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1057	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1058	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1059	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1060	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1061	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1062	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1063	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1064	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1065	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1068	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1070	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1071	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1072	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1073	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1074	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1075	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1076	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1078	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1079	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1080	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1081	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1082	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1083	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1084	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1086	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1087	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1088	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1089	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1090	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1091	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1093	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1094	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1095	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1096	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1097	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1098	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1100	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1101	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1102	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1103	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1104	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1105	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1106	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1108	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1109	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1110	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1111	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1112	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1113	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1114	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1116	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1117	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1484	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1118	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1119	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1120	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1121	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1122	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1124	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1125	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1126	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1127	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1128	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1129	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1130	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1131	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1132	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1133	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1134	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1135	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1138	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1140	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1141	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1142	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1143	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1144	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1145	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1146	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1148	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1149	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1150	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1151	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1152	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1153	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1154	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1156	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1157	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1158	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1159	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1160	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1161	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1163	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1164	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1165	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1166	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1167	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1168	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1170	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1171	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1172	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1173	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1174	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1175	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1176	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1178	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1179	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1180	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1181	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1182	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1183	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1184	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1186	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1187	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1188	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1189	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1190	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1191	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1192	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1194	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1195	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1196	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1197	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1198	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1199	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1200	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1201	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1202	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1203	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1204	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1205	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1208	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1210	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1211	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1212	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1213	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1214	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1215	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1216	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1218	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1219	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1220	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1221	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1222	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1223	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1224	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1226	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1227	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1228	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1229	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1230	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1231	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1233	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1234	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1235	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1236	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1237	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1238	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1240	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1241	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1242	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1243	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1244	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1245	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1246	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1248	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1249	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1250	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1251	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1252	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1253	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1254	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1256	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1257	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1258	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1259	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1260	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1261	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1262	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1264	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1265	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1266	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1267	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1268	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1269	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1270	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1271	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1272	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1273	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1274	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1275	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1278	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1280	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1281	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1282	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1283	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1284	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1285	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1286	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1288	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1289	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1290	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1291	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1292	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1293	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1294	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1296	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1297	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1298	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1299	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1300	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1301	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1303	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1304	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1305	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1306	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1307	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1308	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1310	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1311	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1312	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1313	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1314	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1315	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1316	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1318	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1319	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1320	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1321	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1322	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1323	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1324	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1326	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1327	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1328	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1329	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1330	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1331	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1332	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1334	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1335	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1485	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1336	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1337	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1338	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1339	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1340	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1341	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1342	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1343	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1344	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1345	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1348	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1350	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1351	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1352	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1353	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1354	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1355	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1356	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1358	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1359	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1360	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1361	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1362	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1363	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1364	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1366	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1367	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1368	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1369	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1370	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1371	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1373	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1374	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1375	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1376	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1377	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1378	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1380	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1381	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1382	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1383	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1384	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1385	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1386	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1388	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1389	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1390	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1391	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1392	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1393	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1394	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1396	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1397	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1398	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1399	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1400	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1401	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1402	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1404	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1405	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1406	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1407	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1408	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1409	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1410	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1411	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1412	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1413	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1414	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1415	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1418	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1420	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1421	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1422	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1423	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1424	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1425	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1426	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1428	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1429	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1430	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1431	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1432	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1433	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1434	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1436	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1437	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1438	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1439	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1440	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1441	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1443	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1444	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1445	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1446	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1447	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1448	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1450	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1451	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1452	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1453	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1454	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1455	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1456	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1458	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1459	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1460	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1461	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1462	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1463	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1464	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1466	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1467	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1468	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1469	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1470	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1471	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1472	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1474	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1475	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1476	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1477	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1478	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1479	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1480	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1481	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1488	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1490	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1491	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1492	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1493	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1494	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1495	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1496	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1498	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1499	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1500	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1501	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1502	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1503	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1504	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1506	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1507	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1508	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1509	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1510	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1511	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1513	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1514	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1515	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1516	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1517	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1518	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1520	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1521	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1522	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1523	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1524	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1525	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1526	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1528	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1529	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1530	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1531	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1532	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1533	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1534	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1536	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1537	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1538	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1539	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1540	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1541	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1542	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1544	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1545	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1546	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1547	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1548	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1549	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1550	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1551	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1552	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1553	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1554	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1555	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1558	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1489	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1560	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1561	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1562	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1563	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1564	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1565	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1566	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1568	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1569	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1570	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1571	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1572	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1573	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1574	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1576	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1577	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1578	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1579	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1580	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1581	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1583	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1584	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1585	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1586	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1587	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1588	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1590	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1591	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1592	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1593	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1594	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1595	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1596	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1598	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1599	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1600	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1601	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1602	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1603	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1604	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1606	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1607	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1608	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1609	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1610	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1611	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1612	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1614	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1615	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1616	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1617	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1618	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1619	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1620	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1621	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1622	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1623	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1624	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1625	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1628	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1630	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1631	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1632	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1633	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1634	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1635	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1636	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1638	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1639	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1640	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1641	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1642	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1643	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1644	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1646	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1647	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1648	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1649	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1650	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1651	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1653	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1654	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1655	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1656	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1657	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1658	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1660	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1661	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1662	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1663	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1664	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1665	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1666	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1668	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1669	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1670	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1671	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1672	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1673	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1674	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1676	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1677	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1678	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1679	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1680	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1681	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1682	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1684	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1685	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1686	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1687	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1688	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1689	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1690	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1691	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1692	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1693	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1694	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1695	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1698	A+	en    	Y	BSC	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1700	B+	en    	Y	BSC	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1701	B	en    	Y	BSC	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1702	C+	en    	Y	BSC	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1703	C	en    	Y	BSC	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1704	D+	en    	Y	BSC	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1705	D	en    	Y	BSC	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1706	A+	en    	Y	BA	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1708	B+	en    	Y	BA	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1709	B	en    	Y	BA	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1710	C+	en    	Y	BA	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1711	C	en    	Y	BA	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1712	D+	en    	Y	BA	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1713	D	en    	Y	BA	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1714	A+	en    	Y	MSC	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1716	B+	en    	Y	MSC	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1717	B	en    	Y	MSC	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1718	C+	en    	Y	MSC	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1719	C	en    	Y	MSC	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1720	F	en    	Y	MSC	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1721	A+	en    	Y	MA	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1723	B+	en    	Y	MA	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1724	B	en    	Y	MA	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1725	C+	en    	Y	MA	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1726	C	en    	Y	MA	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1727	F	en    	Y	MA	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1728	A+	en    	Y	DA	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1730	B+	en    	Y	DA	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1731	B	en    	Y	DA	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1732	C+	en    	Y	DA	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1733	C	en    	Y	DA	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1734	D+	en    	Y	DA	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1735	D	en    	Y	DA	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1736	A+	en    	Y	DSC	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1738	B+	en    	Y	DSC	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1739	B	en    	Y	DSC	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1740	C+	en    	Y	DSC	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1741	C	en    	Y	DSC	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1742	D+	en    	Y	DSC	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1743	D	en    	Y	DSC	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1744	A+	en    	Y	DIST-DEGR	5.00	86.00	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1746	B+	en    	Y	DIST-DEGR	3.00	68.00	75.00	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1747	B	en    	Y	DIST-DEGR	2.00	62.00	67.00	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1748	C+	en    	Y	DIST-DEGR	1.00	56.00	61.00	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1749	C	en    	Y	DIST-DEGR	0.00	50.00	55.00	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1750	D+	en    	Y	DIST-DEGR	0.00	40.00	49.00	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1751	D	en    	Y	DIST-DEGR	0.00	0.00	39.00	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1752	A+	en    	Y	DIST	5.00	89.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1754	B+	en    	Y	DIST	3.00	79.60	84.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1755	B	en    	Y	DIST	2.00	69.60	79.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1756	C+	en    	Y	DIST	1.00	59.60	69.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1757	C	en    	Y	DIST	0.00	49.60	59.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1758	D+	en    	Y	DIST	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1759	D	en    	Y	DIST	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1760	ONE	en    	Y	SEC	1.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1761	TWO	en    	Y	SEC	2.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1762	THREE	en    	Y	SEC	3.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1763	FOUR	en    	Y	SEC	4.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1764	FIVE	en    	Y	SEC	5.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1765	SIX	en    	Y	SEC	6.00	0.00	0.00			N	opuscollege	2011-12-13 16:51:25.592402	Y	20
905	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
913	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
859	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
867	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
875	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
882	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
889	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
897	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
929	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
937	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
945	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
952	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
959	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
967	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
975	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
983	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
999	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1007	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1015	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1022	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1029	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1037	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1045	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1053	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1069	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1077	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1085	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1092	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1099	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1107	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1115	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1123	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1139	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1147	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1155	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1162	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1169	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1177	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1185	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1193	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1209	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1217	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1225	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1232	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1239	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1247	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1255	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1263	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1279	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1287	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1295	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1302	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1309	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1317	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1325	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1333	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1349	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1357	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1365	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1372	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1379	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1387	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1395	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1403	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1419	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1427	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1435	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1442	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1449	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1457	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1465	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1473	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1497	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1505	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1512	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1519	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1527	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1535	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1543	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1559	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1567	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1575	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1582	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1589	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1597	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1605	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1613	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1629	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1637	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1645	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1652	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1659	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1667	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1675	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1683	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1699	A	en    	Y	BSC	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1707	A	en    	Y	BA	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1715	A	en    	Y	MSC	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1722	A	en    	Y	MA	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1729	A	en    	Y	DA	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1737	A	en    	Y	DSC	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1745	A	en    	Y	DIST-DEGR	4.00	76.00	85.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1753	A	en    	Y	DIST	4.00	84.60	89.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1766	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1767	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1768	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1769	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1770	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1771	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1772	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1773	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1774	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1775	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1776	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1777	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1778	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1779	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1780	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1781	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1782	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1783	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1784	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1785	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1786	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1787	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1788	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1789	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1790	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1791	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1792	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1793	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1794	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1795	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1796	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1797	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1798	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1799	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1800	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1801	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1802	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1803	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1804	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1805	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1806	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1807	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1808	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1809	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1810	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1811	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1812	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1813	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1814	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1815	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1816	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1817	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1818	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1819	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1820	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1821	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1822	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1823	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1824	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1825	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1826	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1827	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1828	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1829	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1830	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1831	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1832	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1833	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1834	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1835	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1836	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1837	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1838	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1839	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1840	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1841	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1842	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1843	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1844	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1845	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1846	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1847	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1848	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1849	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1850	A+	en    	Y	B	2.50	85.80	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1851	B+	en    	Y	B	1.50	65.80	74.70	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1852	B	en    	Y	B	1.00	55.80	65.70	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1853	C+	en    	Y	B	0.50	45.80	55.70	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1854	C	en    	Y	B	0.00	39.80	45.70	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1855	D+	en    	Y	B	0.00	34.80	39.70	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1856	D	en    	Y	B	0.00	0.00	34.70	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1857	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1858	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1859	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1860	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1861	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1862	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1863	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1864	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1865	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1866	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1867	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1868	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1869	A	en    	Y	B	2.00	74.80	85.70	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1870	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1871	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1872	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1873	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1874	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1875	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1876	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1877	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1878	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1879	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1880	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1881	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1882	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1883	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1884	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1885	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1886	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1887	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1888	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1889	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1890	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1891	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1892	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1893	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1894	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1895	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1896	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1897	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
1898	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1899	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1900	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1901	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1902	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1903	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1904	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
1905	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1906	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1907	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1908	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1909	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1910	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1911	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
1912	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1913	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1914	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1915	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1916	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1917	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1918	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
1919	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1920	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1921	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1922	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1923	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1924	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1925	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
1926	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1927	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1928	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1929	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1930	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1931	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1932	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
1933	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1934	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1935	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1936	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1937	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1938	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1939	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
1940	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1941	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1942	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1943	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1944	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1945	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1946	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
1947	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1948	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1949	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1950	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1951	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1952	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1953	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
1954	A+	en    	Y	ADVCERT	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1955	B+	en    	Y	ADVCERT	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1956	B	en    	Y	ADVCERT	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1957	C+	en    	Y	ADVCERT	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1958	C	en    	Y	ADVCERT	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1959	D+	en    	Y	ADVCERT	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1960	D	en    	Y	ADVCERT	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
1961	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1962	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1963	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1964	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1965	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
1966	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
1967	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
1968	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
1969	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
1970	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
1971	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
1972	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
1973	A	en    	Y	ADVCERT	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
1974	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1975	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1976	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1977	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1978	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
1979	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1980	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-07-26 18:00:59.70967	N	8
1981	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1982	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1983	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1984	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1985	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
1986	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1987	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	19
1988	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1989	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1990	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1991	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1992	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
1993	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1994	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	15
1995	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1996	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1997	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1998	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
1999	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2000	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
2001	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	9
2002	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2003	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2004	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2005	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2006	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2007	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
2008	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	10
2009	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2010	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2011	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2012	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2013	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2014	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
2015	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	11
2016	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2017	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2018	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2019	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2020	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2021	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
2022	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	12
2023	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2024	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2025	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2026	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2027	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2028	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
2029	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	13
2030	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2031	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2032	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2033	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2034	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2035	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
2036	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	16
2037	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2038	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2039	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2040	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2041	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2042	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
2043	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	17
2044	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2045	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2046	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2047	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2048	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2049	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
2050	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	18
2051	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2052	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2053	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2054	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2055	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2056	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
2057	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	14
2058	A+	en    	Y	ADVTECH	5.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2059	B+	en    	Y	ADVTECH	3.00	67.60	75.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2060	B	en    	Y	ADVTECH	2.00	61.60	67.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2061	C+	en    	Y	ADVTECH	1.00	55.60	61.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2062	C	en    	Y	ADVTECH	0.00	49.60	55.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2063	D+	en    	Y	ADVTECH	0.00	39.60	49.50	Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
2064	D	en    	Y	ADVTECH	0.00	0.00	39.50	Definite Fail		N	opuscollege	2011-12-13 16:51:25.592402	N	20
2065	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2066	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2067	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2068	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2069	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2070	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2071	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2072	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2073	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2074	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2075	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2076	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2077	A	en    	Y	ADVTECH	4.00	75.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2078	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2079	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2080	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2081	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2082	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2083	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-07-26 18:00:59.70967	N	8
2084	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2085	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2086	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2087	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2088	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2089	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	19
2090	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2091	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2092	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2093	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2094	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2095	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	15
2096	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2097	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2098	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2099	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2100	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2101	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	9
2102	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2103	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2104	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2105	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2106	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2107	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	10
2108	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2109	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2110	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2111	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2112	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2113	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	11
2114	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2115	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2116	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2117	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2118	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2119	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	12
2120	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2121	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2122	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2123	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2124	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2125	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	13
2126	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2127	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2128	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2129	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2130	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2131	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	16
2132	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2133	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2134	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2135	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2136	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2137	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	17
2138	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2139	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2140	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2141	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2142	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2143	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	18
2144	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2145	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2146	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2147	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2148	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2149	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	14
2150	A+	en    	Y	M	6.00	85.60	100.00	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2151	B+	en    	Y	M	4.00	69.60	74.50	Meritorious		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2152	B	en    	Y	M	3.00	64.60	69.50	Very Satisfactory		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2153	C+	en    	Y	M	2.00	54.60	64.50	Clear Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2154	C	en    	Y	M	1.00	49.60	54.50	Bare Pass		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
2155	F	en    	Y	M	0.00	0.00	49.50	Fail in a Supplementary Examination		N	opuscollege	2011-12-13 16:51:25.592402	N	20
2156	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-07-26 18:00:59.70967	Y	8
2157	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	19
2158	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	15
2159	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	9
2160	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	10
2161	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	11
2162	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	12
2163	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	13
2164	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	16
2165	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	17
2166	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	18
2167	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	14
2168	A	en    	Y	M	5.00	74.60	85.50	Distinction		N	opuscollege	2011-12-13 16:51:25.592402	Y	20
\.


--
-- TOC entry 4373 (class 0 OID 40545)
-- Dependencies: 2317
-- Data for Name: endgradegeneral; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY endgradegeneral (id, code, lang, active, comment, description, temporarygrade, writewho, writewhen) FROM stdin;
1	WP	en    	Y	Withdrawn from course with permission		N	opuscollege	2010-11-02 16:39:22.709387
2	DC	en    	Y	Deceased during course		N	opuscollege	2010-11-02 16:39:22.709387
\.


--
-- TOC entry 4374 (class 0 OID 40558)
-- Dependencies: 2319
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
-- TOC entry 4375 (class 0 OID 40572)
-- Dependencies: 2322
-- Data for Name: examination; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY examination (id, examinationcode, examinationdescription, subjectid, examinationtypecode, numberofattempts, weighingfactor, brspassingexamination, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4376 (class 0 OID 40584)
-- Dependencies: 2324
-- Data for Name: examinationresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY examinationresult (id, examinationid, subjectid, studyplandetailid, examinationresultdate, attemptnr, mark, staffmemberid, active, writewho, writewhen, passed, subjectresultid) FROM stdin;
\.


--
-- TOC entry 4377 (class 0 OID 40598)
-- Dependencies: 2326
-- Data for Name: examinationteacher; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY examinationteacher (id, staffmemberid, examinationid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4378 (class 0 OID 40610)
-- Dependencies: 2328
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
-- TOC entry 4379 (class 0 OID 40624)
-- Dependencies: 2331
-- Data for Name: examtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY examtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
9	1	en    	Y	multiple event	opuscollege	2010-11-02 16:22:58.674788
10	2	en    	Y	single event	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4380 (class 0 OID 40636)
-- Dependencies: 2333
-- Data for Name: expellationtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY expellationtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
1	1	en    	Y	Falsification of certificates	opuscollege	2008-02-01 08:20:15.179914
2	2	en    	Y	Academic fraude	opuscollege	2008-02-01 08:20:15.179914
3	3	en    	Y	Disobedience	opuscollege	2008-02-01 08:20:15.179914
4	4	en    	Y	Other motives	opuscollege	2008-02-01 08:20:15.179914
\.


--
-- TOC entry 4381 (class 0 OID 40648)
-- Dependencies: 2335
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
-- TOC entry 4382 (class 0 OID 40661)
-- Dependencies: 2337
-- Data for Name: fee_fee; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY fee_fee (id, feedue, active, writewho, writewhen, categorycode, subjectblockstudygradetypeid, subjectstudygradetypeid, studygradetypeid, academicyearid, numberofinstallments, tuitionwaiverdiscountpercentage, fulltimestudentdiscountpercentage, localstudentdiscountpercentage, continuedregistrationdiscountpercentage, postgraduatediscountpercentage, branchid, studyintensitycode, feeunitcode, applicationmode, cardinaltimeunitnumber) FROM stdin;
\.


--
-- TOC entry 4383 (class 0 OID 40687)
-- Dependencies: 2339
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
-- TOC entry 4384 (class 0 OID 40699)
-- Dependencies: 2341
-- Data for Name: fee_feedeadline; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY fee_feedeadline (id, feeid, deadline, active, writewho, writewhen, cardinaltimeunitcode, cardinaltimeunitnumber) FROM stdin;
\.


--
-- TOC entry 4385 (class 0 OID 40713)
-- Dependencies: 2343
-- Data for Name: fee_payment; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY fee_payment (id, paydate, studentid, studyplandetailid, subjectblockid, subjectid, sumpaid, active, writewho, writewhen, feeid, studentbalanceid, installmentnumber) FROM stdin;
\.


--
-- TOC entry 4386 (class 0 OID 40731)
-- Dependencies: 2345
-- Data for Name: fee_unit; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY fee_unit (id, code, lang, active, description, writewho, writewhen) FROM stdin;
5	1	en	Y	Course	opuscollege	2012-10-02 18:07:04.815
6	2	en	Y	Cardinal time unit	opuscollege	2012-10-02 18:07:04.815
7	4	en	Y	Study programme	opuscollege	2012-10-02 18:07:04.815
\.


--
-- TOC entry 4387 (class 0 OID 40743)
-- Dependencies: 2347
-- Data for Name: fieldofeducation; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY fieldofeducation (id, code, lang, active, description, writewho, writewhen) FROM stdin;
9	1	en    	Y	general	opuscollege	2010-11-02 16:22:58.674788
10	2	en    	Y	agricultural	opuscollege	2010-11-02 16:22:58.674788
12	4	en    	Y	pedagogical	opuscollege	2010-11-02 16:22:58.674788
11	3	en    	Y	technical	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4388 (class 0 OID 40755)
-- Dependencies: 2349
-- Data for Name: financialrequest; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY financialrequest (id, requestid, financialrequestid, statuscode, timestampreceived, requestversion, requeststring, timestampmodified, errorcode, processedtofinancetransaction, errorreportedtofinancialsystem, writewho, requesttypeid, writewhen, studentcode) FROM stdin;
\.


--
-- TOC entry 4389 (class 0 OID 40768)
-- Dependencies: 2351
-- Data for Name: financialtransaction; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY financialtransaction (id, transactiontypeid, financialrequestid, requestid, statuscode, errorcode, nationalregistrationnumber, academicyearid, timestampprocessed, amount, name, cell, requeststring, processedtostudentbalance, errorreportedtofinancialbankrequest, writewho, writewhen, studentcode) FROM stdin;
\.


--
-- TOC entry 4390 (class 0 OID 40781)
-- Dependencies: 2353
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
-- TOC entry 4391 (class 0 OID 40793)
-- Dependencies: 2355
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
-- TOC entry 4392 (class 0 OID 40805)
-- Dependencies: 2357
-- Data for Name: functionlevel; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY functionlevel (id, code, lang, active, description, writewho, writewhen) FROM stdin;
5	1	en    	Y	management	opuscollege	2008-02-01 08:20:15.179914
6	2	en    	Y	non-management	opuscollege	2008-02-01 08:20:15.179914
\.


--
-- TOC entry 4393 (class 0 OID 40817)
-- Dependencies: 2359
-- Data for Name: gender; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY gender (id, code, lang, active, description, writewho, writewhen) FROM stdin;
14	1	en    	Y	male	opuscollege	2010-11-02 16:22:58.674788
15	2	en    	Y	female	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4394 (class 0 OID 40829)
-- Dependencies: 2361
-- Data for Name: gradedsecondaryschoolsubject; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY gradedsecondaryschoolsubject (id, secondaryschoolsubjectid, studyplanid, grade, active, writewho, writewhen, secondaryschoolsubjectgroupid, level) FROM stdin;
\.


--
-- TOC entry 4395 (class 0 OID 40842)
-- Dependencies: 2363
-- Data for Name: gradetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY gradetype (id, code, lang, active, description, title, writewho, writewhen, titleshort) FROM stdin;
109	SEC	en    	Y	Secondary school	sec.	opuscollege	2011-12-12 13:46:13.271927	\N
111	LIC	en    	Y	Licentiate	Lic..	opuscollege	2011-12-12 13:46:13.271927	\N
113	PHD	en    	Y	Doctor	Ph.D.	opuscollege	2011-12-12 13:46:13.271927	\N
116	DA	en    	Y	Diploma other than maths and science	Dpl.A.	opuscollege	2011-12-12 13:46:13.271927	\N
117	DSC	en    	Y	Diploma maths and science	Dpl.M.Sc.	opuscollege	2011-12-12 13:46:13.271927	\N
122	SEC	pt    	Y	Ensino secund&aacute;rio	Ensino sec.	opuscollege	2012-05-21 15:39:19.182758	\N
124	LIC	pt    	Y	Licentiatura	Lic..	opuscollege	2012-05-21 15:39:19.182758	\N
126	PHD	pt    	Y	Ph.D.	Ph.D.	opuscollege	2012-05-21 15:39:19.182758	\N
131	ADVTECH	en    	Y	Advanced Technology	Adv.Tech.	opuscollege	2012-10-02 18:07:04.815	\N
132	ADVCERT	en    	Y	Advanced Certificate	Adv.Cert.	opuscollege	2012-10-02 18:07:04.815	\N
110	BSC	en    	Y	Bachelor of science	B.Sc.	opuscollege	2011-12-12 13:46:13.271927	B
114	BA	en    	Y	Bachelor of art	B.A.	opuscollege	2011-12-12 13:46:13.271927	B
118	BEng	en    	Y	Bachelor of Engineering	B.Eng.	opuscollege	2011-12-12 13:46:13.271927	B
123	BSC	pt    	Y	Bacharelato	B.Sc.	opuscollege	2012-05-21 15:39:19.182758	B
127	BA	pt    	Y	Bachelor of art	B.A.	opuscollege	2012-05-21 15:39:19.182758	B
130	B	en    	Y	Bachelor	B	opuscollege	2012-10-02 18:07:04.815	B
112	MSC	en    	Y	Master of science	M.Sc.	opuscollege	2011-12-12 13:46:13.271927	M
115	MA	en    	Y	Master of art	M.A.	opuscollege	2011-12-12 13:46:13.271927	M
119	MEngSc	en    	Y	Master of Engineering Science	M.Eng.Sc.	opuscollege	2011-12-12 13:46:13.271927	M
120	MScEng	en    	Y	Master of Science Engineering 	M.Sc.Eng.	opuscollege	2011-12-12 13:46:13.271927	M
121	MBA	en    	Y	Master of Business Administration	M.BA.	opuscollege	2012-01-31 14:43:41.108296	M
125	MSC	pt    	Y	Mestre	M.Sc.	opuscollege	2012-05-21 15:39:19.182758	M
128	MA	pt    	Y	Master of art	M.A.	opuscollege	2012-05-21 15:39:19.182758	M
129	M	en    	Y	Master	M.	opuscollege	2012-10-02 18:07:04.815	M
\.


--
-- TOC entry 4396 (class 0 OID 40854)
-- Dependencies: 2365
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
-- TOC entry 4397 (class 0 OID 40866)
-- Dependencies: 2367
-- Data for Name: groupedsecondaryschoolsubject; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY groupedsecondaryschoolsubject (id, secondaryschoolsubjectid, secondaryschoolsubjectgroupid, active, writewho, writewhen, weight, minimumgradepoint, maximumgradepoint) FROM stdin;
\.


--
-- TOC entry 4398 (class 0 OID 40881)
-- Dependencies: 2369
-- Data for Name: identificationtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY identificationtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
24	1	en    	Y	National Registration Card	opuscollege	2011-03-15 17:17:12.177
25	3	en    	Y	passport	opuscollege	2011-03-15 17:17:12.177
26	4	en    	Y	drivers license	opuscollege	2011-03-15 17:17:12.177
\.


--
-- TOC entry 4399 (class 0 OID 40893)
-- Dependencies: 2371
-- Data for Name: importancetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY importancetype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
5	1	en    	Y	major	opuscollege	2010-11-02 16:22:58.674788
6	2	en    	Y	minor	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4400 (class 0 OID 40905)
-- Dependencies: 2373
-- Data for Name: institution; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY institution (id, institutioncode, educationtypecode, institutiondescription, active, provincecode, rector, registrationdate, writewho, writewhen) FROM stdin;
125	ELEM01	-1	Elementary Test School	Y	02	T.H.E. Nurse	2010-01-01	opuscollege	2011-01-11 10:14:24.658192
124	PRIM01	0	Primary Test School	Y	02	T.H.E. School Leader	2010-01-01	opuscollege	2011-01-11 10:13:08.583358
120	OPUS01	3	OPUS-College University	Y	0		2010-10-16	opuscollege	2010-10-16 19:37:42.413129
\.


--
-- TOC entry 4401 (class 0 OID 40918)
-- Dependencies: 2375
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
-- TOC entry 4402 (class 0 OID 40930)
-- Dependencies: 2377
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
-- TOC entry 4403 (class 0 OID 40942)
-- Dependencies: 2379
-- Data for Name: logmailerror; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY logmailerror (id, recipients, msgsubject, msgsender, errormsg, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4404 (class 0 OID 40957)
-- Dependencies: 2381
-- Data for Name: logrequesterror; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY logrequesterror (id, ipaddress, requeststring, errormsg, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4405 (class 0 OID 40971)
-- Dependencies: 2383
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
23	gradetype	Lookup6	N	opuscollege	2009-02-05 16:49:32.224762
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
77	acc_roomtype	Lookup	Y	opuscollege	2012-10-02 18:07:04.815
78	acc_hosteltype	Lookup	Y	opuscollege	2012-10-02 18:07:04.815
76	penaltytype	Lookup	Y	opuscollege	2012-04-16 14:01:11.752894
79	fee_unit	Lookup	N	opuscollege	2012-10-02 18:07:04.815
\.


--
-- TOC entry 4406 (class 0 OID 40983)
-- Dependencies: 2385
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
-- TOC entry 4407 (class 0 OID 40998)
-- Dependencies: 2387
-- Data for Name: masteringlevel; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY masteringlevel (id, code, lang, active, description, writewho, writewhen) FROM stdin;
7	1	en    	Y	fluent	opuscollege	2010-11-02 16:22:58.674788
8	2	en    	Y	basic	opuscollege	2010-11-02 16:22:58.674788
9	3	en    	Y	poor	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4408 (class 0 OID 41010)
-- Dependencies: 2389
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
-- TOC entry 4409 (class 0 OID 41022)
-- Dependencies: 2391
-- Data for Name: nationalitygroup; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY nationalitygroup (id, code, lang, active, description, writewho, writewhen) FROM stdin;
3	SADC	en	Y	SADC	opuscollege	2011-12-12 13:46:13.271927
4	OTNA	en	Y	Other National	opuscollege	2011-12-12 13:46:13.271927
\.


--
-- TOC entry 4309 (class 0 OID 39777)
-- Dependencies: 2212
-- Data for Name: node_relationships_n_level; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY node_relationships_n_level (id, organizationalunitcode, organizationalunitdescription, active, branchid, unitlevel, parentorganizationalunitid, unitareacode, unittypecode, academicfieldcode, directorid, registrationdate, writewho, writewhen, level) FROM stdin;
\.


--
-- TOC entry 4410 (class 0 OID 41034)
-- Dependencies: 2393
-- Data for Name: obtainedqualification; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY obtainedqualification (id, studyplanid, university, startdate, enddate, qualification, endgradedate, gradetypecode, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4411 (class 0 OID 41046)
-- Dependencies: 2395
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
2838	DELETE_SUBJECTBLOCKS	en    	Y	Delete subjects	opuscollege	2011-08-29 13:33:51.297472	\N	\N
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
2907	UPDATE_STUDENT_SUBSCRIPTION_DATA	en    	Y	View student subscription data	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2908	UPDATE_STUDENT_ABSENCES	en    	Y	Delete student absences	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2909	UPDATE_STUDENT_ADDRESSES	en    	Y	Delete student addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2910	UPDATE_STUDENT_MEDICAL_DATA	en    	Y	Update student medical data	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2911	UPDATE_STUDIES	en    	Y	Update studies	opuscollege	2011-08-29 13:33:51.297472	\N	\N
2912	UPDATE_STUDY_ADDRESSES	en    	Y	Create study addresses	opuscollege	2011-08-29 13:33:51.297472	\N	\N
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
2929	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR	en    	Y	Set the cut-off point for registering bachelor students	opuscollege	2011-10-18 15:12:19.972188	\N	\N
2933	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR	pt    	Y	Set the cut-off point for registering bachelor students	opuscollege	2011-10-18 15:17:25.608551	\N	\N
2937	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR	nl    	Y	Set the cut-off point for registering bachelor students	opuscollege	2011-10-18 15:17:37.064825	\N	\N
2930	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER	en    	Y	Set the cut-off point for registering master / postgraduate students	opuscollege	2011-10-18 15:12:19.972188	\N	\N
2934	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER	pt    	Y	Set the cut-off point for registering master / postgraduate students	opuscollege	2011-10-18 15:17:25.608551	\N	\N
2938	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER	nl    	Y	Set the cut-off point for registering master / postgraduate students	opuscollege	2011-10-18 15:17:37.064825	\N	\N
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
3420	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR	en_ZM 	Y	Set the cut-off point for registering bachelor students	opuscollege	2012-05-21 10:59:57.956764	\N	\N
3421	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER	en_ZM 	Y	Set the cut-off point for registering master / postgraduate students	opuscollege	2012-05-21 10:59:57.988352	\N	\N
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
3434	ALLOCATE_ROOM	en    	Y	Allocate Room	opuscollege	2012-10-02 18:07:04.815	\N	\N
3435	ALLOCATE_ROOM	en_ZM 	Y	Allocate Room	opuscollege	2012-10-02 18:07:04.815	\N	\N
3436	APPLY_FOR_ACCOMMODATION	en    	Y	Apply for accommodation	opuscollege	2012-10-02 18:07:04.815	\N	\N
3437	CREATE_SPONSORS	en    	Y	Create information on sponsors	opuscollege	2012-10-02 18:07:04.815	\N	\N
3438	READ_SPONSORS	en    	Y	Read information on sponsors	opuscollege	2012-10-02 18:07:04.815	\N	\N
3439	UPDATE_SPONSORS	en    	Y	Update information on sponsors	opuscollege	2012-10-02 18:07:04.815	\N	\N
3440	DELETE_SPONSORS	en    	Y	Delete information on sponsors	opuscollege	2012-10-02 18:07:04.815	\N	\N
3441	CREATE_FEE_PAYMENTS	en    	Y	Allow the execution of payments payments	opuscollege	2012-10-15 17:04:33.366	\N	\N
3442	UPDATE_FEE_PAYMENTS	en    	Y	Allow edition of payments	opuscollege	2012-10-15 17:04:33.366	\N	\N
3443	DELETE_FEE_PAYMENTS	en    	Y	Allow removal of payments	opuscollege	2012-10-15 17:04:33.366	\N	\N
3444	READ_FEE_PAYMENTS	en    	Y	Read fee payments	opuscollege	2012-10-15 17:04:33.366	\N	\N
3445	CREATE_FEE_PAYMENTS	pt    	Y	Permite pagar propinas	opuscollege	2012-10-15 17:04:33.366	\N	\N
3446	UPDATE_FEE_PAYMENTS	pt    	Y	Permite actualizar o pagamento de propinas	opuscollege	2012-10-15 17:04:33.366	\N	\N
3447	DELETE_FEE_PAYMENTS	pt    	Y	Permite remover pagamento de propinas	opuscollege	2012-10-15 17:04:33.366	\N	\N
3448	READ_FEE_PAYMENTS	pt    	Y	Permite visualizar o pagamento de propinas	opuscollege	2012-10-15 17:04:33.366	\N	\N
\.


--
-- TOC entry 4412 (class 0 OID 41058)
-- Dependencies: 2397
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
28168	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR	opuscollege	2011-11-16 17:15:35.820205	registry	\N	\N	Y
28169	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER	opuscollege	2011-11-16 17:15:35.820205	registry	\N	\N	Y
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
27936	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR	opuscollege	2011-10-18 15:12:19.972188	admin-S	\N	\N	Y
27937	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR	opuscollege	2011-10-18 15:12:19.972188	admin-B	\N	\N	Y
27939	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER	opuscollege	2011-10-18 15:12:19.972188	admin-S	\N	\N	Y
27940	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER	opuscollege	2011-10-18 15:12:19.972188	admin-B	\N	\N	Y
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
28068	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_BACHELOR	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
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
28094	TOGGLE_CUTOFFPOINT_CONTINUED_REGISTRATION_MASTER	opuscollege	2011-10-18 15:12:19.972188	admin	\N	\N	Y
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
28746	ALLOCATE_ROOM	opuscollege	2012-10-02 18:07:04.815	admin	\N	\N	Y
28747	ALLOCATE_ROOM	opuscollege	2012-10-02 18:07:04.815	dos	\N	\N	Y
28748	CREATE_OWN_STUDYPLANDETAILS_PENDING_APPROVAL	opuscollege	2012-10-02 18:07:04.815	student	\N	\N	Y
28749	APPROVE_SUBJECT_SUBSCRIPTIONS	opuscollege	2012-10-02 18:07:04.815	registry	\N	\N	Y
28750	APPROVE_SUBJECT_SUBSCRIPTIONS	opuscollege	2012-10-02 18:07:04.815	admin-C	\N	\N	Y
28751	APPROVE_SUBJECT_SUBSCRIPTIONS	opuscollege	2012-10-02 18:07:04.815	admin-S	\N	\N	Y
28752	APPROVE_SUBJECT_SUBSCRIPTIONS	opuscollege	2012-10-02 18:07:04.815	admin-B	\N	\N	Y
28753	APPROVE_SUBJECT_SUBSCRIPTIONS	opuscollege	2012-10-02 18:07:04.815	admin-D	\N	\N	Y
28754	APPLY_FOR_ACCOMMODATION	opuscollege	2012-10-02 18:07:04.815	student	\N	\N	Y
28755	APPLY_FOR_ACCOMMODATION	opuscollege	2012-10-02 18:07:04.815	admin	\N	\N	Y
28756	CREATE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	admin	\N	\N	Y
28757	UPDATE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	admin	\N	\N	Y
28758	DELETE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	admin	\N	\N	Y
28759	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	admin	\N	\N	Y
28760	CREATE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	registry	\N	\N	Y
28761	UPDATE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	registry	\N	\N	Y
28762	DELETE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	registry	\N	\N	Y
28763	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	registry	\N	\N	Y
28764	CREATE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	admin-C	\N	\N	Y
28765	UPDATE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	admin-C	\N	\N	Y
28766	DELETE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	admin-C	\N	\N	Y
28767	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	admin-C	\N	\N	Y
28768	CREATE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	finance	\N	\N	Y
28769	UPDATE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	finance	\N	\N	Y
28770	DELETE_SPONSORS	opuscollege	2012-10-02 18:07:04.815	finance	\N	\N	Y
28771	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	finance	\N	\N	Y
28772	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	admin-B	\N	\N	Y
28773	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	admin-D	\N	\N	Y
28774	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	admin-S	\N	\N	Y
28775	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	teacher	\N	\N	Y
28776	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	student	\N	\N	Y
28777	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	dos	\N	\N	Y
28778	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	library	\N	\N	Y
28779	READ_SPONSORS	opuscollege	2012-10-02 18:07:04.815	audit	\N	\N	Y
28780	GENERATE_STUDENT_REPORTS	opuscollege	2012-10-02 18:07:04.815	teacher	\N	\N	Y
28781	READ_STUDENT_SUBSCRIPTION_DATA	opuscollege	2012-10-02 18:07:04.815	admin-D	\N	\N	Y
28782	READ_ORG_UNITS	opuscollege	2012-10-02 18:07:04.815	dos	\N	\N	Y
28783	READ_BRANCHES	opuscollege	2012-10-02 18:07:04.815	dos	\N	\N	Y
28784	CREATE_FEE_PAYMENTS	opuscollege	2012-10-15 17:04:33.366	admin	\N	\N	Y
28785	UPDATE_FEE_PAYMENTS	opuscollege	2012-10-15 17:04:33.366	admin	\N	\N	Y
28786	DELETE_FEE_PAYMENTS	opuscollege	2012-10-15 17:04:33.366	admin	\N	\N	Y
28787	READ_FEE_PAYMENTS	opuscollege	2012-10-15 17:04:33.366	admin	\N	\N	Y
\.


--
-- TOC entry 4413 (class 0 OID 41070)
-- Dependencies: 2399
-- Data for Name: opususer; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY opususer (id, personid, username, pw, writewho, writewhen, lang, preferredorganizationalunitid, failedloginattempts) FROM stdin;
174	183	registry	a9205dcfd4a6f7c2cbe8be01566ff84a	opuscollege	2011-02-22 11:24:02.206331	en   	94	0
226	242	admin	21232f297a57a5a743894a0e4a801fc3	opuscollege	2011-05-17 14:20:49.072314	en   	94	0
\.


--
-- TOC entry 4414 (class 0 OID 41085)
-- Dependencies: 2401
-- Data for Name: opususerrole; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY opususerrole (id, role, username, writewho, writewhen, validfrom, validthrough, organizationalunitid, active) FROM stdin;
312	registry	registry	opuscollege	2011-08-04 20:11:08.279632	2011-08-04	\N	94	Y
243	admin	admin	opuscollege	2011-05-17 14:20:49.188692	2011-05-17	\N	94	Y
\.


--
-- TOC entry 4308 (class 0 OID 39764)
-- Dependencies: 2211
-- Data for Name: organizationalunit; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY organizationalunit (id, organizationalunitcode, organizationalunitdescription, active, branchid, unitlevel, parentorganizationalunitid, unitareacode, unittypecode, academicfieldcode, directorid, registrationdate, writewho, writewhen) FROM stdin;
59	UNZABRANCH1UNIT1	UNZA-unit1	Y	119	1	0	1	1	1	160	2010-01-01	opuscollege	2011-01-06 15:32:36.928222
94	O12105082011101053	Registrars Office	Y	120	1	0	0	0	0	0	2011-08-05	opuscollege	2011-08-05 10:11:56.473823
129	O14222052012150717	Faculteit Biologie	Y	142	1	0	0	0	0	0	2012-05-22	opuscollege	2012-05-22 15:07:36.752191
130	O14222052012151229	vakgroep Ethologie	Y	142	2	129	0	0	0	0	2012-05-22	opuscollege	2012-05-22 15:13:05.534068
\.


--
-- TOC entry 4415 (class 0 OID 41099)
-- Dependencies: 2403
-- Data for Name: penalty; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY penalty (id, studentid, penaltytypecode, amount, startdate, enddate, remark, paid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4416 (class 0 OID 41113)
-- Dependencies: 2405
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
-- TOC entry 4417 (class 0 OID 41125)
-- Dependencies: 2407
-- Data for Name: person; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY person (id, personcode, active, surnamefull, surnamealias, firstnamesfull, firstnamesalias, nationalregistrationnumber, civiltitlecode, gradetypecode, gendercode, birthdate, nationalitycode, placeofbirth, districtofbirthcode, provinceofbirthcode, countryofbirthcode, cityoforigin, administrativepostoforigincode, districtoforigincode, provinceoforigincode, countryoforigincode, civilstatuscode, housingoncampus, identificationtypecode, identificationnumber, identificationplaceofissue, identificationdateofissue, identificationdateofexpiration, professioncode, professiondescription, languagefirstcode, languagefirstmasteringlevelcode, languagesecondcode, languagesecondmasteringlevelcode, languagethirdcode, languagethirdmasteringlevelcode, contactpersonemergenciesname, contactpersonemergenciestelephonenumber, bloodtypecode, healthissues, photograph, remarks, registrationdate, writewho, writewhen, photographname, photographmimetype, publichomepage, socialnetworks, hobbies, motivation) FROM stdin;
183	P0987	Y	Registrar	\N	V.C.		234243234	1	PHD	1	1960-09-23	130	Ndola	0	ZM-02	894	Lusaka	\N	0	ZM-05	894	1	N	3	12430802834	Lusaka	2010-10-20	2020-10-20	\N	Professor	eng	1	cha	1	dut	2	Mother	034554235235	3	\N	\\377\\330\\377\\340\\000\\020JFIF\\000\\001\\001\\001\\000H\\000H\\000\\000\\377\\333\\000C\\000\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\002\\002\\001\\001\\002\\001\\001\\001\\002\\002\\002\\002\\002\\002\\002\\002\\002\\001\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\377\\333\\000C\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\002\\001\\001\\001\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\377\\300\\000\\021\\010\\000K\\000d\\003\\001"\\000\\002\\021\\001\\003\\021\\001\\377\\304\\000\\037\\000\\000\\001\\005\\001\\001\\001\\001\\001\\001\\000\\000\\000\\000\\000\\000\\000\\000\\001\\002\\003\\004\\005\\006\\007\\010\\011\\012\\013\\377\\304\\000\\265\\020\\000\\002\\001\\003\\003\\002\\004\\003\\005\\005\\004\\004\\000\\000\\001}\\001\\002\\003\\000\\004\\021\\005\\022!1A\\006\\023Qa\\007"q\\0242\\201\\221\\241\\010#B\\261\\301\\025R\\321\\360$3br\\202\\011\\012\\026\\027\\030\\031\\032%&'()*456789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz\\203\\204\\205\\206\\207\\210\\211\\212\\222\\223\\224\\225\\226\\227\\230\\231\\232\\242\\243\\244\\245\\246\\247\\250\\251\\252\\262\\263\\264\\265\\266\\267\\270\\271\\272\\302\\303\\304\\305\\306\\307\\310\\311\\312\\322\\323\\324\\325\\326\\327\\330\\331\\332\\341\\342\\343\\344\\345\\346\\347\\350\\351\\352\\361\\362\\363\\364\\365\\366\\367\\370\\371\\372\\377\\304\\000\\037\\001\\000\\003\\001\\001\\001\\001\\001\\001\\001\\001\\001\\000\\000\\000\\000\\000\\000\\001\\002\\003\\004\\005\\006\\007\\010\\011\\012\\013\\377\\304\\000\\265\\021\\000\\002\\001\\002\\004\\004\\003\\004\\007\\005\\004\\004\\000\\001\\002w\\000\\001\\002\\003\\021\\004\\005!1\\006\\022AQ\\007aq\\023"2\\201\\010\\024B\\221\\241\\261\\301\\011#3R\\360\\025br\\321\\012\\026$4\\341%\\361\\027\\030\\031\\032&'()*56789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz\\202\\203\\204\\205\\206\\207\\210\\211\\212\\222\\223\\224\\225\\226\\227\\230\\231\\232\\242\\243\\244\\245\\246\\247\\250\\251\\252\\262\\263\\264\\265\\266\\267\\270\\271\\272\\302\\303\\304\\305\\306\\307\\310\\311\\312\\322\\323\\324\\325\\326\\327\\330\\331\\332\\342\\343\\344\\345\\346\\347\\350\\351\\352\\362\\363\\364\\365\\366\\367\\370\\371\\372\\377\\332\\000\\014\\003\\001\\000\\002\\021\\003\\021\\000?\\000\\3764<a\\340\\017\\026\\370"\\327M\\276\\325m\\274=\\250\\333k\\266\\261\\337i\\255\\341\\337\\026xk\\305\\214l\\366\\306\\216/\\307\\205\\265k\\303\\245\\316\\011\\377\\000Ut\\260\\313\\337f\\007\\035\\317\\303\\237\\032\\374,\\322\\276\\022\\374M\\360\\357\\211>\\015k\\332\\347\\304\\375}\\255%\\370{\\361kO\\361\\346\\255\\341\\330<\\014\\226V\\362\\255\\366\\225y\\341\\270\\264\\311l\\374I\\005\\314\\205\\011\\022\\311\\014\\203n\\324u\\316O\\211\\371W\\266\\267\\027w\\226\\227_e\\2326O6\\010\\310\\363fWE\\332p\\240\\206 u\\357\\217\\306\\275\\013\\300_\\0325\\377\\000\\207\\027\\006=6\\332\\302\\361/\\346W\\235o\\241\\212`\\357p6\\260x\\245R\\035H\\356:f\\277:\\342L5\\014\\323\\3534\\362\\314\\272\\255\\012Q\\235\\031\\302\\214\\361\\325!YJ\\222\\247'\\012\\225\\351R\\303\\251\\301\\3117\\311\\354\\324%\\011:S\\214\\265\\223\\373\\334\\273\\023\\230\\345tp\\370\\214]JX\\314|}\\244gR\\225\\005J\\204\\343:\\223P\\224)\\312\\266*T\\347\\030r\\302nU&\\345(\\272\\211F2T\\343\\345\\032F\\2275\\355\\313:\\316\\243U\\215f\\236;i\\336\\030\\032F\\003\\001\\220\\315"\\220\\375\\3609\\342\\267ll\\242\\206\\342\\366\\013\\275Qax\\236Hf\\206\\346o&I\\345VF\\217aR\\0262\\223)!\\203\\355!9\\305}\\333\\341\\377\\000\\331\\317D\\370\\263e\\342_\\213>1\\361\\226\\221\\340\\366\\360\\363[\\314\\221\\330i\\266\\266\\332=\\351\\232\\316\\346\\366\\322+\\255@\\310F\\235w$\\266\\346%q\\003\\304\\031v\\315$l\\353_\\013i\\3324\\272\\307\\210LR\\233+\\230./uX\\204\\255p>\\315n#\\022\\312.&\\224\\355\\016\\236V]J3\\026\\013\\362\\356<W\\271\\227\\340s\\334N\\036\\246%eU\\245\\014V\\032\\236&\\321\\303\\312\\245EEM6\\360\\357\\227\\337\\204\\232i\\3124\\371\\255\\314\\272J\\336F:\\244hC\\015'V\\015:\\362\\207$\\253A\\3023pM*\\3122J2Q\\222\\222U\\032m4\\334~\\023\\352\\277\\206\\320\\374U\\3254\\017\\212\\337\\006e\\361\\375\\352x&\\373L\\360\\235\\336\\265\\341M\\017\\304\\026Z\\237\\2075\\235m\\265k{\\177\\011\\353si\\232U\\334\\222x\\252\\347K\\271\\324\\267\\301%\\222\\334H\\237:\\310Da\\310\\366\\017\\204\\377\\000\\360L\\017\\213~8\\325\\355\\247\\361.\\271\\247\\370B$\\2732E=\\244r\\352\\232\\310HX\\224\\2766\\011\\265lD\\233w,r\\272\\270\\3362\\240\\361_s~\\302\\377\\000\\263\\035\\217\\204|;a\\251\\336\\301aw\\342\\355LK$\\372\\342C\\005\\324\\272n\\2319\\216Qi\\246\\337)a\\3457\\230\\2442\\271\\352z\\021\\212\\375\\376\\370W\\360\\207I\\3234\\270"\\265\\264\\213\\346\\216'\\363^ \\3171\\333\\231$\\222V^X\\222FI<\\342\\2775\\361_\\307lmy\\345|?\\301\\371$05\\362,2\\303W\\314q8\\231\\343j\\342 \\361\\030\\212\\364a\\012N\\235\\0324}\\205\\032\\360\\303\\267\\010\\2655J\\356\\021\\272Q\\375\\357\\301\\357\\000\\262lN_\\211\\317\\370\\313\\024\\361\\037\\333\\225\\326*\\236\\017\\015F8H\\323\\227\\325\\360\\324*N\\265hN\\245j\\362\\253<;\\252\\234\\247\\031B\\022\\2155)()K\\361\\203\\300?\\360OS\\360\\243\\303\\366\\236/\\370_\\342\\315V/\\217\\032&\\243\\251i\\367\\0369\\3264\\353_\\370Gn<\\037\\251\\331\\004\\272\\322\\233\\302\\223i\\362\\217\\3553~\\242G\\236G\\226\\332x%xe\\207\\007&\\226\\261\\252\\370/\\340\\375\\305\\256\\242?g\\373\\357\\001\\374@\\277\\266\\212\\307\\304~'\\370\\021?\\374#\\032g\\214\\265\\233x\\245\\232\\343\\305\\223\\350\\221\\371\\326\\226\\367\\257\\253\\254\\015,\\026\\361[\\302\\273\\314\\202\\024 \\023\\375$\\370w\\300\\253d\\217<v\\360I\\023\\0147\\233\\0227 \\020\\000\\302\\364\\316\\007>\\325\\341\\377\\000\\032\\376\\000\\370#\\342\\237\\2035\\317\\010x\\233B\\262XnD\\332\\206\\233u\\005\\262C\\177\\245j\\302&H\\365\\033\\011\\321\\003C+\\014\\254\\2006\\327F*\\340\\202+\\371\\203\\305\\017\\030\\370\\307\\210%\\226cx\\217\\013O\\021\\203\\312p\\2640u%\\202\\244\\260\\225+\\341\\260\\362\\224\\243,Z\\245.Lt\\351s\\313\\221WM\\244\\337+\\272\\263\\376\\200\\311|\\013\\341L\\253\\013\\230C\\204\\252\\324\\313\\363\\034Ej\\270\\232?X\\304U\\305S\\245^\\253\\214\\244\\250\\306\\273\\233\\302\\251\\362\\250\\267KH\\336\\352.\\307\\361\\001\\373YK\\245\\370\\253\\342\\015\\357\\216t\\217\\023\\370\\267\\305w\\3760\\232mg\\305\\367>4\\207JMoI\\326\\235\\222+\\335?Q\\3254\\307X\\257&[\\210\\331\\016a\\202U\\362\\224\\311\\036X\\023\\302\\374\\032\\237\\304~\\032\\231\\256<=m\\246\\336\\235JT\\222k\\013\\333\\302\\227\\211{\\033Ild\\261\\202\\002\\355q\\235\\334\\240\\033\\371\\316\\334\\034\\237J\\375\\265~\\021\\370\\313\\340_\\306O\\020x\\007\\304V\\226\\351mo\\266\\353\\303w\\226p\\272\\303\\253\\350\\227r\\261\\260\\276\\344\\223%\\316U\\243\\223\\251S\\030^\\342\\275\\217\\366P\\360<ZW\\202n\\274A\\250Y,:\\237\\333\\245\\276\\267\\222h1:y7\\032|1\\312w\\246T\\346G\\307C\\306+\\367\\\\\\367\\2112\\374\\277\\302l\\233\\030\\252\\3079\\301f4\\260\\361\\242\\237'-XTW\\247\\013\\322PIR\\212\\214}\\330\\251G\\222\\322\\\\\\334\\307\\345>\\023\\360\\206k\\213\\361c0\\206"\\234\\362\\354^M*\\252\\274\\265R\\205X\\331NI\\276d\\375\\243\\274\\265\\274e\\032\\215\\306\\312\\303\\177h\\273}e>\\020\\377\\000\\304\\305-\\345\\326\\256t\\213i'\\373\\0239Q\\005\\353B,\\341T\\221\\003\\306\\351\\023\\277\\0149\\337\\221\\315~f\\333\\370/\\304PF\\327pA<\\177`\\211\\322\\366Y!\\2225\\214\\002\\256\\245\\013 \\363\\010\\212E\\343\\357\\006!N\\011\\031\\375\\320\\375\\240\\254a\\324\\254\\364\\251\\026\\336%[\\333\\030\\232B\\002\\355-\\016\\253r\\010 .>\\342\\022\\007m\\270\\257\\211<S\\244Z\\257\\302\\353\\250\\243\\271\\026\\227:\\267\\212\\2554\\353y\\2261!2K\\251y\\262\\206V#j-\\274\\0221#\\237\\220W\\007\\203\\231\\244\\243\\300\\253\\037\\354\\343\\207\\372\\346.\\253q\\265\\342\\225\\222\\222\\321|0jI$\\264\\323\\265\\237\\327} \\250\\303\\031\\342-\\014\\015J\\177X\\372\\236\\012\\021\\215\\244\\343(\\336\\254\\334y]\\367k\\331\\337\\232\\367I\\253\\256f\\311~\\012~\\304z\\317\\305o\\000\\351\\3363\\223^\\227L\\216\\376\\342\\346\\013ku\\261y\\213\\333\\332\\371q\\254\\356\\300|\\254\\316d\\371{\\005\\024W\\354O\\302=\\177\\341\\277\\303\\257\\207\\036\\021\\360\\242\\370\\253\\3030\\013\\015\\036\\325\\212\\337k6v\\367n\\363 ye\\236\\027l\\243\\264\\336a \\363\\315\\025\\374\\241\\237x\\365\\342\\264\\263\\274\\331\\344\\361\\255O*\\372\\315e\\207\\217\\325 \\355ETj\\235\\333\\242\\333|\\266\\275\\336\\367?@\\313\\274'\\340\\370`0P\\305\\345^\\337\\025\\032P\\366\\223\\366\\225}\\351\\362\\307\\231\\373\\263KW{[C\\360.\\357\\340/\\211.\\274\\000~"i:\\337\\303;\\3356\\336\\025{\\355*\\323\\342\\207\\202\\217\\215\\020\\227H\\025\\233\\301R\\352\\351\\251L\\373\\344L\\371V\\356B\\345\\316\\025Y\\207\\214j\\311\\246\\215-m\\342\\263\\276\\207]\\267\\274\\264[\\206\\226Ky-6"?\\233\\266\\005\\264Y"\\2302\\256I\\224\\257\\007\\345\\356;}#K\\325\\355m\\347\\267\\202\\325\\365\\004-=\\306\\350ay'\\201X\\022\\344\\244r\\037\\221A\\034\\343\\030\\252^\\017\\233\\302\\032'\\211\\355\\256~!\\370[\\\\\\361\\276\\210U\\332\\347\\303\\3726\\274\\276\\027\\324/"\\210\\023\\266-Ml\\356\\015\\266\\007V\\362\\230\\237N\\365\\376\\232\\342s\\354\\242\\236\\032r\\311xZR\\253K\\017(\\312\\022\\257O\\027V\\275D\\324\\275\\246\\033\\333\\323\\303\\307\\017=\\022\\212\\225t\\226\\251\\325Ql\\377\\000;\\250\\345\\331\\304*T\\216k\\235S\\366u\\261.t\\345\\034=l$(\\321i*tq\\036\\316\\256*X\\231)99T\\215:ji\\307\\367\\012P\\346\\227\\260|:\\361\\276\\247\\340\\357\\205\\036<\\376\\324\\321\\265\\253\\355\\013\\\\\\277\\323\\264\\010\\265\\250\\257RM\\003E\\326o\\255Z\\345!h\\232\\336H\\356nnlE\\332\\265\\274\\256\\212\\027.\\244:du~\\006\\375\\237u\\337\\215\\232\\307\\302\\366\\360\\274\\377\\000\\0154\\311l\\264\\343\\006\\271c\\242\\203\\341\\373\\303\\245\\370{Q\\202{\\275_\\304Zn\\2534\\243P\\361\\015\\316\\223\\250HU\\241)\\347\\0159\\243\\021\\006P\\357\\313O\\244\\376\\315>+\\217\\302:?\\302\\355\\027\\343\\254\\277\\024\\274E\\257\\030\\257|1\\342\\373\\237\\007I\\360\\352\\332\\312\\346f[E\\323\\257\\364\\253\\277\\355+\\231ma*\\014\\323\\242\\371\\242&r\\250[`\\375\\017\\377\\000\\202l~\\317z\\037\\304\\377\\000\\332\\333\\342\\237\\303O\\032\\331\\213O\\022\\370\\017\\302\\215y\\340\\025\\266\\363\\364\\253y\\257WWM*\\353XD\\267\\231\\276\\321\\0346\\363ZN\\003\\031T\\244\\214\\316\\244\\003^\\256W\\342\\357\\366\\177\\017\\3463\\255\\222\\3478\\331\\341\\360\\020\\241\\202Y\\246`\\325,\\256\\255\\032\\361\\366\\2250X\\030\\306-\\341gy\\312\\2358W\\204)\\3639\\272\\225\\332Q\\211\\202\\340\\\\vw\\304y^\\0168\\374\\276\\205,V=\\373Z\\230L=\\276\\265NXyZ\\216/\\023(\\324r\\254\\232Rst\\3439r\\323\\246\\243J.N\\247\\354\\037\\354\\313\\341x\\022\\336+x\\355c\\2054\\377\\000.\\301\\243\\003\\367Q\\305i\\012\\305\\034\\221\\246\\321\\266-\\221\\256\\016\\000\\303\\016\\374\\327\\354\\017\\302\\335:\\312\\033\\0159\\276\\315\\035\\354\\322\\250KhX\\253\\264\\3621e\\335\\345\\354\\303.\\3400I\\306Nk\\362\\367\\340>\\211\\252\\335>\\271g\\034rYj\\222\\353\\017\\247\\0379|\\247\\212O\\236\\313Q\\217h#`\\214\\011\\330\\221\\331\\024\\200H\\305}]s/\\214a\\272\\203N\\322<\\015\\361.\\373\\373>;\\035._\\034\\370o\\306\\332\\177\\203\\264\\217\\016\\333!\\036f\\247\\016\\233$W\\027\\332\\275\\254C\\344\\221R\\325\\244\\221\\337)\\033&d_\\343\\367\\227S\\3143\\254\\312U1\\011Nu\\252\\311I\\362\\336v\\223w\\367\\232J\\313\\273\\265\\317\\356\\334\\2631\\226S\\222\\345\\320\\372\\254\\232\\245B\\224\\\\#\\315x\\355\\024\\255\\010\\312N\\317\\244U\\372\\350\\217\\321\\211\\254/#ciq\\241\\255\\234\\202#!\\266\\227Ob]#\\214>\\370\\332<n\\030\\333\\221\\236\\007<\\342\\274g\\307\\032L\\255\\005\\314\\336R\\304<\\2517!\\022!;Fr\\240\\374\\301\\201\\030\\307\\250\\250|\\023\\361#\\304\\366>\\015\\324/umo_\\324u\\273/\\017O5\\245\\277\\212\\014RkP\\231\\246\\201.Z\\342\\342\\335B\\316\\314\\220\\343xU;\\0160\\011\\305|g\\361#\\343/\\304\\024\\326\\365/\\355Q\\3612\\013\\031\\224\\335XjZg\\201,5\\017\\015Kq%\\334v\\306\\315\\256-\\365&\\324\\310BU\\344+f\\333`f\\270l\\242\\234|\\316o\\30343j8\\354\\035\\014j\\223\\214eS\\367\\220\\212\\2646\\367\\271V\\374\\321k\\341\\355\\261\\366xN$Ylp\\230\\234F\\022T\\275\\244\\243M(9>j\\232^\\334\\326V\\265\\265rz\\337W\\243?\\036\\177\\340\\253\\221\\351^\\011\\325\\276\\022\\374a\\207\\302\\236\\034\\361G\\210|%\\342\\011\\264\\365\\203\\304\\232{\\336\\351\\222*'\\366\\225\\235\\215\\352\\252\\371w\\010\\336\\\\\\316\\260\\317\\303\\210_\\313\\371\\262\\017\\302\\276\\033\\370\\205a\\343O\\012\\317\\342\\0153\\303:/\\204n|K\\257Z\\331\\\\\\370o\\303\\205\\327F\\323u=cW\\373u\\324\\032t\\022\\315#\\333[\\371\\010\\214#-\\204\\336B\\200\\240\\001\\372%\\373w\\370\\253U\\275\\320|\\017\\240j6zF\\253\\252\\370\\367]\\327\\036\\353\\301Z\\245\\325\\215\\307\\207\\265\\247\\360\\346\\211z\\353\\036\\241at\\352\\323jqZ\\\\<\\372\\\\\\261\\010\\245\\212\\355\\011\\206eb\\321\\311\\371a\\360\\376s\\037\\213\\374\\011l-\\232\\035*]^\\337[\\226\\302K\\330\\256\\256a\\223F\\264\\232\\336\\371/\\024Z\\304`\\235n\\036\\035\\252\\341\\210\\014\\006\\366\\301\\257\\217\\3132\\377\\000g\\341\\356K\\200\\307e\\265)c\\2627\\213\\253C\\021RS\\207\\266\\302C\\023\\211\\253\\0324\\351\\312\\247-Z\\012\\244*\\306\\235_eu:uc\\032\\226R\\211\\345\\3403\\234\\307\\013\\343^5e\\365\\343W'\\317\\250\\341\\351b)F\\234e\\354\\253\\324\\303\\322\\214k\\316\\254U\\351\\325iR\\27576\\347Nt\\345\\310\\371\\2433\\322>8\\353\\006\\327M\\360\\334e\\330\\011\\006\\262\\253\\306\\343\\230n\\256\\335\\001\\005\\207\\3352\\257\\035\\263\\305|\\207\\343\\035N\\336\\317\\302~\\022\\023\\355\\221WS\\326\\265VR\\244\\2532\\210\\340\\201d\\007\\253o\\271;I\\347\\223^\\311\\361\\337[}F\\323\\302\\017\\000w{\\213\\337\\0275\\274h\\013<\\216oW\\312\\211U\\007\\314\\3048\\000\\000s\\214\\001^U\\343\\337\\206\\177\\020t\\377\\000\\010\\370j\\353\\304\\276\\023\\3244M6\\353F\\236[Y\\365_&\\315\\256\\245\\277\\221%\\201m\\341i|\\301.\\310U\\2242\\253\\036\\270\\300&\\277_\\340,F\\033-\\340\\034\\227\\003\\213\\304C\\017,^+\\026\\271\\034\\343\\011J\\325j\\251(&\\357'\\265\\355\\265\\325\\354y>'`*f>'\\346\\230\\254-'Vtp\\270GO\\335r\\215\\335:3JZm\\3576\\327[;lx,~5\\361\\034\\255<\\206\\361\\234\\311q3\\222\\363t\\313}\\305\\014x@0\\000\\034\\014Q^\\241\\241|!\\322\\2564\\364\\226\\376\\352]:\\345\\335\\213\\332\\\\\\253\\274\\221\\345P\\203\\2758e9\\310>\\364W\\257W>\\341ZugM\\322M\\301\\333J\\015\\255,\\264kF\\274\\326\\217\\247C\\206\\207\\013q\\374\\350\\323\\233\\307(\\363$\\354\\353$\\365\\266\\352J\\351\\357t\\365Os\\366?\\302\\237\\2677\\374\\023\\276\\376\\330j\\037\\023\\177\\340\\224~\\036\\322\\256\\265\\0139\\240\\273\\274\\3701\\361\\373\\305\\276\\026\\236[[\\210%\\265\\270Xl\\374A\\244^\\010\\221\\355e\\225q\\347n\\001\\362\\030\\034\\021\\371\\373\\373V\\370\\267\\376\\011\\343\\342?\\015\\370\\216\\373\\366S\\370\\033\\373H\\374\\024\\361\\316\\274$T\\322\\374w\\361\\017\\300\\337\\021\\274\\017\\015\\224w\\251\\250\\246\\235n$\\320\\223T\\201\\204\\260\\304\\211$3G!E\\303\\263\\251*\\333\\232\\227\\201c]>\\327e\\272\\004]=_\\312\\333\\263\\010\\343\\345\\332\\0118p\\254s\\317l\\221_4\\370\\313\\3011>\\257\\341\\335"[{s\\026\\252\\327\\326\\237\\3517RYA\\027\\235kp\\260\\\\\\313u\\036\\031|\\226\\333/_\\230\\304\\023\\007$W\\007\\001f\\330<\\323\\2112L6WW\\023\\205\\253S\\023IS\\241C\\0218S\\251(\\317\\335\\243R\\223n\\025!;F\\022\\215E(IJ\\317\\313\\363\\3765\\340:\\031VO\\232\\346U\\022\\254\\350R\\224\\235J\\322\\251>V\\324W\\265NS|\\256-\\271\\251F\\316-h|\\375\\343\\277\\207^(\\370/\\342\\217\\004\\335|E\\322,\\235\\365=\\017\\303>5\\376\\310\\360\\367\\2124\\273\\366\\325<'\\342H"\\277\\2621k\\036\\031\\324.\\227I\\275\\226\\301\\234Ko![\\253Y\\024\\305q\\004r\\002\\265\\372\\005\\373#\\376\\323_\\030|!\\373H\\3742\\375\\242#\\262\\320\\374-\\360\\377\\000Cv\\360\\257\\210\\364\\353\\273\\235#\\303\\037n\\370isa&\\2016\\271-\\345\\372A\\036\\255\\253X\\351\\223C"M \\363/%\\323\\362r\\357\\270|\\003\\340\\217\\206\\272\\307\\304\\037\\023Y\\3747\\266\\327\\3744\\327\\232\\206\\261q\\244\\351\\372\\257\\211|Sc\\341\\315"\\316\\345\\246X\\255\\356\\037\\\\\\326\\256V\\327N\\264i\\030y\\217;$j3\\271\\200\\033\\207Q\\247xGY\\261\\324u=7^\\361f\\205\\252]\\370).\\342\\267K\\337\\020G}\\341\\361k\\243\\206h\\364\\0138TKm\\255jW2\\003\\366+s\\376\\215t\\340\\306'\\313)?\\330\\031\\236\\033\\031\\304yNu\\302<\\031\\302\\263\\304*\\265\\252\\317\\017\\207\\366+\\031\\217r\\214\\02411X\\212P\\247Z\\255*Q\\205NX9S\\204\\022uT'57?\\345\\234\\247\\025[\\207\\363\\\\\\247\\211\\370\\2237\\246\\253\\340\\251\\322ukR\\235L6\\031\\3122s\\245/a:\\230\\210S\\234\\345\\313{{I\\316\\376\\315\\324\\204Z\\345\\376\\306\\376\\010x\\257\\303z\\247\\216/|K\\341\\315j\\317\\304>\\017\\3616\\241&\\263\\246\\353\\272}\\3147\\232v\\251\\016\\253v\\322\\177hi\\363\\332\\310\\311$\\022y\\360d\\243\\020\\257\\275\\016\\322\\010\\037\\255\\256\\236\\024\\217\\303\\026\\272\\364\\272\\210\\266\\330\\261C\\006\\215e\\031{\\335Z\\345\\2271\\307m\\346\\201\\034l\\303\\001\\235\\310TUf=+\\371|\\377\\000\\202?\\370\\207T\\361/\\303\\335K\\301\\336(\\267\\261\\323uM+\\306z\\235\\345\\206\\235\\034\\020if\\313F\\326.\\227P\\266K{+rV\\312\\021x$"\\025\\037\\273R\\000Q\\300\\257\\334/\\036\\305\\343\\257\\017xsH\\324\\264\\333t\\361\\035\\306\\222\\367q\\266\\217\\005\\330\\265\\373<\\232{81\\313,\\203i\\236`-\\3661\\004d\\205e\\332\\314G\\362f3$\\206\\0233\\305\\340\\361n4\\243N^\\364\\245\\314\\234e\\243\\276\\226nW\\322\\337\\0175\\323\\323C\\373_\\207\\270\\231b\\262\\314\\036:\\236\\016U\\253b\\343\\036ZK\\221k\\315\\312\\343'R\\3521\\216\\356OU\\004\\232w\\263;\\275/\\304Z^\\263\\252k\\267\\272\\326\\243\\241x?N:N\\245\\037\\3305;\\313\\201}+\\306\\322'\\221,\\323\\304<\\333\\235\\250\\247\\0126e\\270lc:\\2322\\370\\037\\304\\036\\032\\223SFi\\2574\\353\\010\\331\\236G\\177.i\\021\\\\-\\302\\340(\\226\\027T#\\022\\003\\261\\227\\007\\202+\\346\\211~4\\352\\367~\\033\\223^\\324~\\032\\030%\\323gd\\362d\\272\\266\\023A)1\\026\\202\\346\\333R\\200K,\\376iR]\\021\\325\\367\\260\\301\\004V\\276\\201\\342\\357\\020x\\357\\303\\232\\236\\263\\254h\\020\\370\\002\\346\\346\\310-\\225\\254wP\\011/4\\331\\204\\251!\\274H\\312\\210\\331 \\206k\\245\\177-\\012%\\263+d\\265xY\\326C\\227B\\244*\\323\\305\\270b\\035\\011\\373\\257E8\\374JI\\247k\\306I\\3315\\252\\223m\\237\\243\\324\\307gYv\\026\\204\\263,\\216\\020\\300\\327\\255\\025\\011\\306q\\251(M\\250\\273J7nQ\\345j\\363O\\335i%t\\354~\\031\\377\\000\\301H\\376\\007|H\\370\\355\\373I|\\037\\325\\376\\031\\351?\\360\\231\\272^j>\\020\\265\\360w\\205\\264\\375j\\347\\305z\\\\\\332B\\333x\\257P\\361\\034f\\312?\\263Ej\\366v\\215\\022\\2174]\\023o#,M\\036\\347_\\317\\273-f\\015/\\307\\2760\\326\\265r\\272}\\267\\203\\264\\233\\233k\\351.A\\210\\332^\\314\\323Oz\\327\\000\\256D\\252\\336P|\\214\\344`\\363_b\\370\\333\\366\\256\\202\\037\\332\\017\\304+\\242^x\\273\\301i\\245x\\232M?\\304\\322xO\\\\{\\031\\374O\\247h\\372~\\255i\\245\\353\\026\\226\\367\\354\\361[\\370\\2137\\376D\\245$\\206)\\355\\037\\367x\\235F\\377\\000\\204\\265\\377\\000\\020h\\332\\346\\263\\361"\\336M:\\367H\\321\\274I;\\254B\\362K\\257\\020jr\\331\\336\\210c\\232\\346\\361-\\255\\332\\347Px\\311.\\352"i\\300\\014\\245X\\201\\237:\\031ug\\303\\031\\017\\015\\342\\362\\314\\306\\246/.\\303\\325~\\327\\3672\\243\\034\\036c\\216\\216&p\\243J\\235%Q\\326\\346\\253\\211\\222|\\365y\\350\\316\\237\\265P\\252\\247\\315\\362Y/\\025R\\245\\306y\\316:\\225\\\\\\035\\014\\036i\\211\\214\\346\\334\\247\\031\\375g,\\301\\324\\303\\322u\\252:\\262\\247*\\015S\\303\\245\\030F\\234\\251\\325\\204\\254\\247\\032\\211\\303\\243\\321\\265\\337\\010\\337\\353\\277\\015\\265}K\\304\\276\\034:\\177\\206m5\\335j\\341d\\326\\264\\326\\216MB\\374X\\317\\243\\251\\002\\340\\356c\\231\\237\\030\\340\\305\\206\\000\\361^\\261\\361k\\366\\216\\370}\\343\\217\\001\\247\\207\\365\\237\\022xR\\324\\375\\216+u\\275\\270\\272\\0272\\351\\327Vs\\274\\221\\334X\\333\\332\\231\\036y\\3341\\004\\200\\025wq\\305~j\\370C\\340\\317\\207\\343\\272\\361\\255\\377\\000\\213\\354\\3575?\\015\\350\\332\\234\\336\\036mb\\302\\337X\\321\\337K\\032\\211v\\320|qeg\\250[@\\367Z"\\312\\213\\035\\3042\\306\\035\\022a&>F\\025\\235\\340\\177\\204\\032n\\277&\\251\\257+\\332\\353\\2727\\204\\265\\303\\246\\370\\213\\302\\232>\\254\\320k\\332\\216\\223\\247@f\\324\\365\\253K\\311\\243+e\\346\\332\\226\\232\\317\\231#\\225\\355&\\205\\312\\020\\273\\277Q\\207\\003\\360\\345\\034\\015\\014,\\361\\2651p\\313\\345R\\255\\012\\362\\242\\350N.\\255I\\3424N\\247\\271'\\315\\254j\\244\\254\\241\\031\\255\\317\\313s\\256?\\316\\263|\\3729\\323\\313#\\204\\304U\\247B\\204\\351S\\304\\252\\324\\345,=:t=\\242\\275\\005.Yr\\363r\\302Ri\\3638\\311\\351\\177\\255\\177\\3413\\370C\\252Ems/\\304\\357\\014\\332\\312\\266\\266\\366\\362D'\\276\\265\\304\\220D\\251#2O`\\013\\261p\\307p\\371ObqEq\\020~\\317?\\016\\274w\\030\\361\\007\\301\\357\\206\\377\\000\\027\\274g\\340\\251I\\267\\266\\327\\244\\361o\\2074\\204\\270\\276\\203\\376?`\\206\\323R\\263\\022\\371q;\\244e\\310\\303I\\033\\201\\300\\242\\276]\\360\\317\\016\\301\\270<\\303\\037A\\305\\333\\222o\\005\\011Gm%\\031\\324\\214\\342\\327U$\\232\\355\\261\\365\\020\\361'\\212\\024b\\243\\034\\014\\242\\222\\263N\\254\\223ZZ\\322P\\222}5\\346{n}\\245\\250k\\272L\\367&S\\034\\246\\335`\\225\\224\\243\\207n?u\\021]\\223\\017\\335\\345p~R0k\\342\\217\\332\\027\\\\[\\365\\212;\\007\\177>'6V\\246'a0\\271te\\304[\\006U\\2677\\030\\007\\363\\255\\317\\021k\\332\\317\\204\\3741\\340\\357\\030j\\323\\351\\277\\330\\277\\0204\\341/\\207V\\303Y\\323\\365MG\\026\\370I\\233R\\322\\254.^\\343I$\\200B\\334F\\204\\221\\3235\\341\\362kVz\\267\\2124\\273\\275j{\\243\\247\\330\\352\\361j\\327\\261ZZ\\376\\365\\355`\\225ZH\\322K\\246H\\343\\220\\252\\220\\013\\235\\244\\236k\\302\\340^\\016\\304\\3459\\276\\0335\\302\\316X\\257\\250\\312J\\223\\242\\334\\333\\257FN2\\204\\\\\\034\\255R\\025b\\351\\312\\316\\361\\222\\263\\265\\215x\\337\\2142\\314~K\\212\\312\\252U\\215\\027\\215PU\\024\\332\\246\\343J\\252\\213S\\375\\347.\\222\\247.x;5$\\323W\\271\\341K\\341Y \\363E\\365\\353\\356E\\022\\\\\\333\\220\\3533;|\\315\\022\\307*\\253\\261\\332p\\337/9\\307<\\232\\233I\\321\\256%\\325l\\256t\\223w\\011\\373m\\262\\207\\216WP\\026)\\221\\235%n\\000\\210\\2059V\\004q\\2003_si\\237\\263w\\306?\\332c\\304\\213\\177\\360C\\340\\177\\304/\\030\\333\\307\\032\\301o\\253A\\243^[i\\322\\223\\204In\\265;\\207\\216\\331p\\270\\000\\211@\\302g\\236+\\353\\257\\207?\\360D?\\333\\207\\307ZF\\255\\250jZ_\\202>\\027\\035\\026\\007\\272\\261\\321\\374O\\342&\\233W\\325\\356\\243\\005\\343\\202\\326\\323\\303\\266\\367b\\026fP\\004\\223\\262\\015\\314\\001\\007\\255\\177Rd\\263\\305\\320\\247\\206\\3143l\\322\\236K\\213q\\215IQ\\234\\342\\261\\024\\346\\325\\354\\343NjI\\247gx\\267$\\264\\222N\\366\\376A\\317\\262\\354\\245c\\353\\322\\311)V\\307\\340\\251T\\224a8\\2518N\\011\\307\\225\\363I4\\244\\325\\371\\265p\\277\\300\\334uu\\177b_\\211\\267\\276\\027\\370\\273\\244\\311\\245\\370\\206\\327G\\324\\234\\\\\\177f5\\344\\336F\\235\\255\\231\\256\\022\\362\\013K\\2710U\\037\\315WM\\304\\026\\013( p@\\376\\224\\374\\015\\361\\326\\317\\304\\036*K=r\\325\\254&\\271\\265O\\355\\015\\037Sv/\\036\\254m\\314Sa\\3001\\265\\264\\316\\3215\\273\\357\\021\\313\\273*\\315\\301\\257\\344\\317\\342\\267\\354\\317\\361\\237\\366[\\276\\360\\346\\203\\361f\\333L\\323\\365\\335Z\\316\\343X\\322o<9\\253\\015N5\\206\\326\\365\\255\\244\\205\\356R\\024\\3736\\241\\025\\302e\\343\\306UdS\\374U\\365\\227\\300\\337\\333\\367\\\\\\360U\\206\\235\\340\\377\\000\\215\\336\\013?\\026\\374\\025d#\\266\\262\\326\\254\\365y<5\\361'\\303v\\230\\301\\032/\\211"\\211\\326\\372\\335\\033k\\013[\\304x\\311\\000\\006L\\346\\276G7\\311\\326+\\026\\3611\\344\\314\\024#*r\\264\\243y\\356\\234\\24195\\011\\267\\275\\246\\323\\276\\252Z\\362\\237\\244p\\367\\022K\\013\\205xz\\225'\\201U**\\261\\223\\214\\234c.e'\\031\\306*S\\207f\\351\\251]Z\\361\\323\\231\\177MZ\\307\\203\\374\\021sq\\015\\355\\337\\211ux\\232\\371\\\\\\311\\246\\304\\266\\002\\322\\031\\321\\203[F\\354\\321\\226\\202\\026}\\300\\234\\2142\\256X\\356\\257\\226\\277i\\337\\027\\337\\035\\002\\367\\301\\377\\000\\017o :\\316\\251\\341\\373\\235%5(\\260\\355\\341\\370\\256 \\232+\\211\\256$H\\312\\334\\317$E\\240\\211\\0060n\\231\\213\\015\\245O\\215|\\035\\370\\267\\373\\031\\374c\\236\\322\\377\\000\\303\\037\\265\\007\\210|){p\\246\\007\\370\\177\\361J\\336\\303@\\326\\341\\270\\223i\\020[\\353O(\\265\\270P\\353\\21722\\345\\312\\356\\371I\\257q\\3617\\201\\374\\013?\\202\\265\\357\\025\\370g\\307zf\\261\\341}\\016\\337U\\325\\257u\\355\\022\\362\\015N+\\213\\275\\002\\336f{Yu4\\236EfYH\\015\\222B\\227\\332\\221\\251m\\325\\370\\317\\032W\\247\\226\\341j\\302\\216\\013\\021\\365\\227jq\\215Z.1\\263\\225\\371og\\031_\\272\\225\\236\\213S\\367\\256\\027\\305\\342\\263\\272\\224\\275\\2463\\017\\0344\\027;\\235*\\261\\224\\271\\243\\025i]Y\\306\\326OX\\351\\327\\262\\376O>&\\307&\\233\\3439\\256\\257f\\331\\177\\016\\227\\017\\366\\235\\312\\226\\001\\357\\355..\\255e\\221\\200\\347{\\030\\324\\340\\362q\\216k\\357\\357\\370&\\207\\355\\237\\360\\033\\340\\237\\305{\\315+\\366\\200\\370I\\341\\255gB\\361.\\237tt\\277\\213R\\370~\\337\\\\\\361\\207\\2055\\255>\\321\\256-,f\\2606\\356n\\364k\\305\\205\\242c\\036&\\267\\225\\243\\220\\271\\214\\312\\243\\363O\\342&\\247s\\251x\\313\\304\\327S\\311\\035\\364\\262\\337^\\333H\\317\\023\\307\\033\\244\\263\\313pBF\\370l\\250c\\264\\361\\2227`\\002+'\\302\\251m\\246\\335\\303=\\324\\0154\\346\\011!\\215\\335\\216-|\\320\\252\\314\\213\\216d(6\\347\\260<c'?\\262\\3469]<\\327%\\306,E\\032\\212\\275Z\\034\\264\\335\\012\\216\\224\\240\\345\\033\\333G\\037v-&\\340\\371\\241$\\222p\\226\\307\\363\\2443\\210ey\\276\\027\\015\\034m8\\340\\375\\2775GV\\016\\252\\234a;'\\025i\\265)+\\245Q%4\\333jK\\257\\364\\353\\361\\273\\376\\012\\257\\373\\012|K\\320u\\177\\006\\353\\177\\262\\337\\210\\376#\\370n\\366\\336}\\027P\\275\\270\\322\\374\\037\\341\\231\\347\\323\\356\\021\\355\\215\\305\\224\\341\\336\\352\\332O-\\230\\307\\222\\254\\010\\004\\220s_\\317\\017\\305\\337\\200\\337\\014\\274-y/\\217?f\\017\\020\\370\\337V\\370i\\342\\017\\023C\\246\\370\\353\\303\\336!\\212(\\274s\\360\\363\\302\\372\\303\\254\\226\\372G\\211\\364\\373\\031dMO\\303kq\\210\\341\\326l\\335\\342p\\273nV\\332S\\266N^[\\231\\004\\214\\024F\\221K\\230\\3379$g\\033\\\\\\356\\353\\363\\001\\351\\3375{B\\361\\377\\000\\211\\274\\007\\252Yx\\253B\\2700\\353^\\0372\\333^\\252"\\311\\015\\376\\207r\\2469\\355\\357m\\244\\214\\307{b\\361\\310\\351$n\\031Z9\\216\\341\\362\\203_\\235\\344\\274%\\217\\341\\252\\262\\305dX\\272\\265]k{L-z\\312T1+x\\306\\244\\0249i\\317\\233\\335\\215ji8Jps\\215X)A\\375\\246;\\2142<\\326\\234px\\372J\\207%\\375\\236&\\235)s\\341\\335\\265\\234%)9\\265\\313i8=$\\2414\\234%i/\\033\\361\\277\\307_\\036|'\\361^\\267\\341\\017\\204\\236$\\233\\303\\036\\026\\267\\272[\\271\\364k[;[\\253\\013mnx!\\213T}:G\\004\\255\\234\\217o\\023\\205\\340\\007w\\343$\\321]\\337\\305\\277\\201Z\\354\\236'\\265\\3617\\205&\\322\\354<=\\343\\375\\007K\\361\\346\\231c\\255\\311umug\\037\\210\\204\\362\\334\\332\\300"\\263\\221f\\260K\\330n\\226\\007\\004f0\\024\\250*rW\\330\\340\\363~\\026\\257\\205\\241W\\021C\\014\\261\\022\\212\\366\\212\\264a\\355cQi8T\\346\\247'\\317\\011'\\011^R\\326?\\023\\265\\3173\\021\\224q\\023\\255Q\\341)W\\255\\205\\223\\275)\\321\\222\\366U)\\2738T\\247j\\321\\\\\\263\\213SV\\214wZ-\\225\\037\\205\\237\\010t\\377\\000\\215\\272\\357\\205\\374\\027\\360\\256\\033\\237\\013\\352\\036\\034\\360\\246\\243\\256|`\\370\\201\\343\\015f[\\317\\012\\350V6W\\022\\334_\\353\\313c\\375\\227\\023hv\\266\\326M\\014)o\\034\\327F\\366\\342D14e\\312\\257\\3547\\374\\022\\223\\376\\011\\325\\341\\217\\332#\\342>\\273\\361\\203\\307\\0267\\376+\\375\\237\\376\\033j2\\351~\\021\\213\\304\\232p\\323\\177\\341l\\370\\266\\321\\3246\\257{a\\033\\225\\036\\030\\265d\\363\\026\\327\\314\\225d\\222H\\343\\225\\333l\\200\\374=\\341\\006\\376\\300\\375\\213?h]SEX\\364\\315J\\373\\306?\\016\\274/y\\177i\\024q^\\\\\\370~}2\\347S\\233I\\232\\344.\\371-\\036\\371\\214\\214\\244\\344\\220\\001;T\\001\\375\\250\\376\\314\\376\\036\\321>\\037~\\314\\276\\032\\323\\274\\027\\245\\331\\370v\\307\\303\\377\\000\\004m\\365\\035\\036\\323O\\211R\\013;\\350|\\036\\272\\212]\\210\\344\\334&\\234\\337\\023+\\264\\233\\314\\216\\304\\311\\273'=\\271~&X\\014\\257\\031\\232Ss\\225z\\265g\\207\\246\\3477Rt\\334\\341\\034Mz\\252\\244\\375\\373\\270\\326\\215*1MF\\214y\\324U\\2249|.&\\303\\250\\343\\260\\271TTa\\027\\025V\\247"p\\204\\243J\\177W\\247MC\\231\\2539S\\225J\\262i\\271\\276M\\275\\364\\377\\000;\\377\\000h?\\370*\\337\\300\\017\\331/\\305\\232\\357\\301?\\005|&\\324\\374u\\342/\\005\\307\\375\\225\\250i\\276\\037\\274\\322|#\\340\\317\\017\\353Q\\333\\202\\272T\\267\\237c\\232Y\\332-\\321\\211\\276\\317lB\\020P1l\\343\\363\\363_\\377\\000\\202\\361\\376\\320\\262C1\\360\\267\\301\\177\\203\\236\\034\\275+p\\226w\\327rx\\257_\\270\\206\\336`\\313\\011h\\037R\\266\\216\\356\\3426eo\\231B1A\\271\\002\\222\\265\\370u\\342\\177\\020k^(\\361\\257\\213|E\\342\\035J\\353W\\326\\365\\275wV\\325\\265mN\\366O6\\352\\373Q\\275\\232\\342\\346\\352\\352y07H\\363\\2631\\300\\000g\\000\\001\\305ey\\322\\230\\225\\313\\222\\311!\\332\\334d\\005\\223\\000g\\0351\\333\\241\\357^\\256\\027!\\303AS\\253Q{j\\225\\024e')K\\342\\222\\346v\\265\\264\\336\\327\\327c\\300\\304\\347\\016\\021\\235.NH\\323\\272\\3221wPq\\215\\3375\\322z\\247ee\\277\\221\\354\\177\\037\\277i\\177\\216\\277\\264.\\252|G\\361K\\306\\267>&\\273\\216\\362\\366\\356\\326\\337\\354:u\\225\\256\\214u\\035\\211r\\272=\\265\\245\\240\\026p\\005\\2120";\\321J\\006!\\210\\311\\360(^\\376x\\266\\246\\247r\\255\\317\\311r\\321]\\235\\370?3\\031\\220\\224\\333\\337\\004u\\351Z\\227D\\231\\271$\\356\\224\\202;\\020C\\022\\010\\351\\214\\250\\374\\253\\036\\360ywi\\263\\345\\314\\210\\016;\\202#'\\365\\257\\264\\302eTU:jQ\\212\\206\\213\\2261I+\\352\\265k\\357\\331\\237\\005\\214\\342<D\\252\\326\\216\\031J\\022\\213i9I\\332\\352\\315\\3361\\322\\335\\225\\367.X\\\\K\\007\\230/\\204\\237h2\\022\\267QF\\256\\214\\213\\363)\\005\\012\\210\\316\\340\\337\\207rz\\375\\017\\360\\377\\000\\343\\307\\305\\017\\006\\370'\\305\\336\\020\\360\\357\\212u\\307\\360\\246\\245\\014)\\177\\341\\213\\233\\313\\227\\360\\361\\213S\\231\\242\\324\\365\\007\\260\\216q\\233\\202\\221\\303\\036\\340P\\005\\231\\267n\\310\\257\\011\\260P\\372\\205\\274\\014\\003B\\322\\300\\254\\207\\241Wh\\325\\206z\\362\\030\\376u\\365m\\366\\201\\243iZ.\\243\\006\\235\\247[ZEq\\246\\\\\\307:\\304\\234\\314\\236To\\266GbY\\376c\\236Ns_/\\306\\023\\312r\\330\\321\\303\\3420/\\031<d\\257\\010\\313\\221\\323\\213\\246\\342\\356\\324\\223w[\\306\\333=n\\267>\\327\\303\\247\\3049\\375Z\\325\\360\\331\\2440\\024\\262\\345\\005RqU\\025j\\212\\263pQN\\022\\214l\\355i_G\\0359e\\261\\363\\263x.\\357\\305\\272\\332j:bn7\\026\\326\\372\\357\\222$\\221-R\\342\\345\\245\\262\\231\\303\\314K\\230RE\\233dyc\\316r@\\347\\320t\\177\\204\\033]%\\326\\265\\006*2\\357oe\\230\\334\\203\\214\\376\\376A\\226\\355\\300\\035\\001\\256\\317\\341\\333\\026\\322\\022rs7\\366V\\237\\027\\233\\300\\177)5\\035T,y\\037\\300\\002\\257\\035>QV\\276"\\352w\\332g\\207ool.\\032\\332\\3528\\330$\\310\\261\\226L\\313\\267\\345\\016\\204\\003\\216\\370\\315~q\\217\\3163\\332\\371\\312\\341\\354\\267\\025\\014\\034kT\\2055Q\\306\\363\\275E\\013^mI\\244\\224\\222\\\\\\251;+\\335\\263\\366l\\263\\204xj\\246X\\270\\2237\\301\\317\\037<5:\\222\\366\\\\\\315RQ\\245)\\267\\313N.\\012R\\223NO\\236N-\\273YE$\\254\\333\\370s\\301\\3325\\271\\226[;\\030\\304\\012\\312'\\324$W\\336r\\247s<\\362`\\246q\\320\\016\\225\\235q\\342\\377\\000\\205\\321\\303">\\241\\341\\3432[\\274\\027\\226\\246,\\307{lT\\244\\220I$Q\\3606\\222\\247\\007%[#\\220+\\341]c^\\326\\265f\\236MKT\\275\\274d}\\251\\347\\334H\\352\\252[\\240M\\330\\003\\223\\333\\275sO$\\201\\031\\267\\266@\\300$\\347\\206\\004\\036\\275x\\003\\362\\257\\255\\217\\202\\022\\257\\027\\210\\316\\270\\257\\025_\\023\\361Z\\203q\\214v\\272\\275W7$\\357\\374\\260\\266\\352\\315#\\346_\\215\\230<$\\243\\203\\310\\2703\\007C\\013\\360\\267^1\\273\\351~J1\\202OG{\\316WM\\255\\233?X>1\\376\\332Zw\\213\\365\\237\\012\\257\\303\\317\\205?\\017\\240\\360\\227\\205>\\037xO\\301Z]\\265\\336\\243\\014\\323[\\017\\017\\332\\315\\025\\304;\\347\\362\\334E\\366\\231\\345d\\014\\245\\266\\31073\\034\\232+\\361\\037P\\276\\274[\\311\\302\\334\\312\\243w@\\304\\016\\202\\212\\342\\304x\\031\\302\\365\\261\\025\\353b!\\014^"\\264\\3459\\325\\250\\261>\\322\\244\\345.iN~\\317\\027J\\2374\\233n\\\\\\224\\341\\033\\267h\\253\\234xo\\0333L.\\036\\206\\033\\011\\205\\236\\017\\015\\207\\204aN\\225*\\230\\177gN\\021IF\\020\\366\\270:\\2659"\\222Q\\347\\2519[y3\\377\\331	The photo didn't upload	2011-02-22	opuscollege	2011-02-22 11:24:02.201299	sergey.jpg	image/jpeg	Y	Facebook and twitter	Reading\r\nMovies	\N
242	P897897	Y	Admin	\N	M.M.J.	M.M.		0	0	1	1950-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-17	opuscollege	2011-05-17 14:20:49.003771	\N	\N	N	\N	\N	\N
\.


--
-- TOC entry 4418 (class 0 OID 41141)
-- Dependencies: 2409
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
-- TOC entry 4419 (class 0 OID 41153)
-- Dependencies: 2411
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
-- TOC entry 4420 (class 0 OID 41169)
-- Dependencies: 2413
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
\.


--
-- TOC entry 4421 (class 0 OID 41181)
-- Dependencies: 2415
-- Data for Name: referee; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY referee (id, studyplanid, name, address, telephone, email, orderby, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4422 (class 0 OID 41193)
-- Dependencies: 2417
-- Data for Name: relationtype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY relationtype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
9	1	en    	Y	brother	opuscollege	2010-11-02 16:22:58.674788
10	2	en    	Y	sister	opuscollege	2010-11-02 16:22:58.674788
11	3	en    	Y	uncle	opuscollege	2010-11-02 16:22:58.674788
12	4	en    	Y	aunt	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4423 (class 0 OID 41205)
-- Dependencies: 2419
-- Data for Name: reportproperty; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY reportproperty (id, reportname, propertyname, propertytype, propertyfile, propertytext, visible, active, writewho, writewhen) FROM stdin;
4	StudentsPerStudyGradeAcadyear	reportLogo	image/pjpeg	\\377\\330\\377\\340\\000\\020JFIF\\000\\001\\001\\001\\000H\\000H\\000\\000\\377\\333\\000C\\000\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\002\\002\\001\\001\\002\\001\\001\\001\\002\\002\\002\\002\\002\\002\\002\\002\\002\\001\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\377\\333\\000C\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\001\\002\\001\\001\\001\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\002\\377\\300\\000\\021\\010\\000?\\001\\037\\003\\001"\\000\\002\\021\\001\\003\\021\\001\\377\\304\\000\\037\\000\\000\\001\\005\\001\\001\\001\\001\\001\\001\\000\\000\\000\\000\\000\\000\\000\\000\\001\\002\\003\\004\\005\\006\\007\\010\\011\\012\\013\\377\\304\\000\\265\\020\\000\\002\\001\\003\\003\\002\\004\\003\\005\\005\\004\\004\\000\\000\\001}\\001\\002\\003\\000\\004\\021\\005\\022!1A\\006\\023Qa\\007"q\\0242\\201\\221\\241\\010#B\\261\\301\\025R\\321\\360$3br\\202\\011\\012\\026\\027\\030\\031\\032%&'()*456789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz\\203\\204\\205\\206\\207\\210\\211\\212\\222\\223\\224\\225\\226\\227\\230\\231\\232\\242\\243\\244\\245\\246\\247\\250\\251\\252\\262\\263\\264\\265\\266\\267\\270\\271\\272\\302\\303\\304\\305\\306\\307\\310\\311\\312\\322\\323\\324\\325\\326\\327\\330\\331\\332\\341\\342\\343\\344\\345\\346\\347\\350\\351\\352\\361\\362\\363\\364\\365\\366\\367\\370\\371\\372\\377\\304\\000\\037\\001\\000\\003\\001\\001\\001\\001\\001\\001\\001\\001\\001\\000\\000\\000\\000\\000\\000\\001\\002\\003\\004\\005\\006\\007\\010\\011\\012\\013\\377\\304\\000\\265\\021\\000\\002\\001\\002\\004\\004\\003\\004\\007\\005\\004\\004\\000\\001\\002w\\000\\001\\002\\003\\021\\004\\005!1\\006\\022AQ\\007aq\\023"2\\201\\010\\024B\\221\\241\\261\\301\\011#3R\\360\\025br\\321\\012\\026$4\\341%\\361\\027\\030\\031\\032&'()*56789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz\\202\\203\\204\\205\\206\\207\\210\\211\\212\\222\\223\\224\\225\\226\\227\\230\\231\\232\\242\\243\\244\\245\\246\\247\\250\\251\\252\\262\\263\\264\\265\\266\\267\\270\\271\\272\\302\\303\\304\\305\\306\\307\\310\\311\\312\\322\\323\\324\\325\\326\\327\\330\\331\\332\\342\\343\\344\\345\\346\\347\\350\\351\\352\\362\\363\\364\\365\\366\\367\\370\\371\\372\\377\\332\\000\\014\\003\\001\\000\\002\\021\\003\\021\\000?\\000\\371\\177\\376\\012\\231\\361G\\342f\\221\\373{~\\320\\272v\\223\\361\\027\\307Zf\\237m\\253\\370,[X\\351\\376.\\361\\005\\225\\235\\270\\223\\341\\227\\202\\246\\220Akm\\250*D\\032Y$c\\265FY\\313\\036I5\\371\\375\\377\\000\\013\\217\\342\\357\\375\\025O\\210\\377\\000\\370\\\\x\\233\\377\\000\\226\\225\\366?\\374\\025w\\376R\\007\\373E\\377\\000\\330c\\301\\037\\372\\253\\274\\017_\\2365\\375oB\\215\\037cG\\367Q\\370c\\366We\\344\\177,\\342*\\325\\372\\305\\177\\336\\313\\343\\227\\332\\177\\314\\374\\317G\\377\\000\\205\\307\\361w\\376\\212\\247\\304\\177\\374.<M\\377\\000\\313J?\\341q\\374]\\377\\000\\242\\251\\361\\037\\377\\000\\013\\217\\023\\177\\362\\322\\274\\342\\212\\327\\330\\321\\377\\000\\237Q\\377\\000\\300W\\371\\030\\373j\\277\\363\\366_\\370\\023\\377\\0003\\321\\377\\000\\341q\\374]\\377\\000\\242\\251\\361\\037\\377\\000\\013\\217\\023\\177\\362\\322\\217\\370\\\\\\177\\027\\177\\350\\252|G\\377\\000\\302\\343\\304\\337\\374\\264\\2578\\255\\213_\\017\\353\\227\\261x\\202{]&\\376x\\274)`\\272\\257\\211]-e#B\\323\\237\\\\\\322|4\\267\\232\\250+\\233(?\\341 \\327tk=\\317\\217\\364\\235N\\030\\276\\373\\201B\\241I\\355F.\\337\\335^\\275\\274\\277\\017!{j\\213GZI\\277\\357?\\363\\363G_\\377\\000\\013\\217\\342\\357\\375\\025O\\210\\377\\000\\370\\\\x\\233\\377\\000\\226\\224\\177\\302\\343\\370\\273\\377\\000ES\\342?\\376\\027\\036&\\377\\000\\345\\245p\\027\\026wv\\236G\\332\\355n-~\\325o\\025\\345\\267\\332 \\226\\037\\264ZM\\273\\311\\272\\203\\314Q\\346\\333\\276\\326\\332\\353\\225m\\247\\004\\342\\253\\320\\350R\\213\\263\\243\\024\\327\\367W\\371\\002\\257Q\\253\\252\\322i\\366\\223\\377\\0003\\321\\377\\000\\341q\\374]\\377\\000\\242\\251\\361\\037\\377\\000\\013\\217\\023\\177\\362\\322\\217\\370\\\\\\177\\027\\177\\350\\252|G\\377\\000\\302\\343\\304\\337\\374\\264\\2578\\242\\217cG\\376}G\\377\\000\\001_\\344?mW\\376~\\313\\377\\000\\002\\177\\346z?\\374.?\\213\\277\\364U>#\\377\\000\\341q\\342o\\376ZQ\\377\\000\\013\\217\\342\\357\\375\\025O\\210\\377\\000\\370\\\\x\\233\\377\\000\\226\\225\\347\\024Q\\354h\\377\\000\\317\\250\\377\\000\\340+\\374\\203\\333U\\377\\000\\237\\262\\377\\000\\300\\237\\371\\236\\217\\377\\000\\013\\217\\342\\357\\375\\025O\\210\\377\\000\\370\\\\x\\233\\377\\000\\226\\224\\177\\302\\343\\370\\273\\377\\000ES\\342?\\376\\027\\036&\\377\\000\\345\\245y\\305\\024{\\032?\\363\\352?\\370\\012\\377\\000 \\366\\325\\177\\347\\354\\277\\360'\\376g\\243\\377\\000\\302\\343\\370\\273\\377\\000ES\\342?\\376\\027\\036&\\377\\000\\345\\245\\037\\360\\270\\376.\\377\\000\\321T\\370\\217\\377\\000\\205\\307\\211\\277\\371i^qE\\036\\306\\217\\374\\372\\217\\376\\002\\277\\310=\\265_\\371\\373/\\374\\011\\377\\000\\231\\350\\377\\000\\360\\270\\376.\\377\\000\\321T\\370\\217\\377\\000\\205\\307\\211\\277\\371iG\\374.?\\213\\277\\364U>#\\377\\000\\341q\\342o\\376ZW\\234QG\\261\\243\\377\\000>\\243\\377\\000\\200\\257\\362\\017mW\\376~\\313\\377\\000\\002\\177\\346z?\\374.?\\213\\277\\364U>#\\377\\000\\341q\\342o\\376ZQ\\377\\000\\013\\217\\342\\357\\375\\025O\\210\\377\\000\\370\\\\x\\233\\377\\000\\226\\225\\347\\024Q\\354h\\377\\000\\317\\250\\377\\000\\340+\\374\\203\\333U\\377\\000\\237\\262\\377\\000\\300\\237\\371\\236\\217\\377\\000\\013\\217\\342\\357\\375\\025O\\210\\377\\000\\370\\\\x\\233\\377\\000\\226\\224\\177\\302\\343\\370\\273\\377\\000ES\\342?\\376\\027\\036&\\377\\000\\345\\245y\\305\\024{\\032?\\363\\352?\\370\\012\\377\\000 \\366\\325\\177\\347\\354\\277\\360'\\376g\\243\\377\\000\\302\\343\\370\\273\\377\\000ES\\342?\\376\\027\\036&\\377\\000\\345\\245\\037\\360\\270\\376.\\377\\000\\321T\\370\\217\\377\\000\\205\\307\\211\\277\\371i^qE\\036\\306\\217\\374\\372\\217\\376\\002\\277\\310=\\265_\\371\\373/\\374\\011\\377\\000\\231\\350\\377\\000\\360\\270\\376.\\377\\000\\321T\\370\\217\\377\\000\\205\\307\\211\\277\\371iG\\374.?\\213\\277\\364U>#\\377\\000\\341q\\342o\\376ZW\\234QG\\261\\243\\377\\000>\\243\\377\\000\\200\\257\\362\\017mW\\376~\\313\\377\\000\\002\\177\\346z?\\374.?\\213\\277\\364U>#\\377\\000\\341q\\342o\\376ZQ\\377\\000\\013\\217\\342\\357\\375\\025O\\210\\377\\000\\370\\\\x\\233\\377\\000\\226\\225\\347\\024Q\\354h\\377\\000\\317\\250\\377\\000\\340+\\374\\203\\333U\\377\\000\\237\\262\\377\\000\\300\\237\\371\\236\\217\\377\\000\\013\\217\\342\\357\\375\\025O\\210\\377\\000\\370\\\\x\\233\\377\\000\\226\\224\\177\\302\\343\\370\\273\\377\\000ES\\342?\\376\\027\\036&\\377\\000\\345\\245y\\305\\024{\\032?\\363\\352?\\370\\012\\377\\000 \\366\\325\\177\\347\\354\\277\\360'\\376g\\243\\377\\000\\302\\343\\370\\273\\377\\000ES\\342?\\376\\027\\036&\\377\\000\\345\\245\\037\\360\\270\\376.\\377\\000\\321T\\370\\217\\377\\000\\205\\307\\211\\277\\371i^qE\\036\\306\\217\\374\\372\\217\\376\\002\\277\\310=\\265_\\371\\373/\\374\\011\\377\\000\\231\\350\\377\\000\\360\\270\\376.\\377\\000\\321T\\370\\217\\377\\000\\205\\307\\211\\277\\371iG\\374.?\\213\\277\\364U>#\\377\\000\\341q\\342o\\376ZW\\234QG\\261\\243\\377\\000>\\243\\377\\000\\200\\257\\362\\017mW\\376~\\313\\377\\000\\002\\177\\346z?\\374.?\\213\\277\\364U>#\\377\\000\\341q\\342o\\376ZW\\320\\377\\000\\262\\227\\305\\237\\212\\227\\237\\037|\\005mw\\3613\\342\\005\\325\\274\\237\\360\\224\\371\\220\\\\\\370\\317\\304s\\303&\\317\\005\\370\\216D\\337\\024\\272\\221V\\303\\252\\260\\310\\340\\250#\\221_\\030\\327\\321\\337\\262O\\374\\234\\037\\303\\377\\000\\373\\232\\377\\000\\365\\011\\361%sc(\\321\\372\\236+\\367Q\\376\\034\\376\\312\\376W\\344ta*\\325\\372\\326\\033\\367\\262\\376$>\\323\\376e\\346}\\001\\377\\000\\005]\\377\\000\\224\\201\\376\\321\\177\\366\\030\\360G\\376\\252\\357\\003\\327\\347\\215~\\207\\177\\301W\\177\\345 \\177\\264_\\375\\206<\\021\\377\\000\\252\\273\\300\\365\\371\\343]\\024?\\201G\\374\\021\\374\\221\\216#\\375\\342\\277\\370\\345\\377\\000\\2450\\242\\212+S\\023\\327>\\021\\217\\204:\\206\\245\\254xc\\342\\377\\000\\366\\306\\203\\247x\\246\\302\\0357\\303\\237\\023\\364yooG\\302\\317\\021%\\312\\315g\\342O\\020\\370>\\312\\326Y<m\\340\\271q\\366]^\\326\\320&\\253igr\\332\\236\\222\\267\\367\\226I\\243j\\237r'\\201\\265U\\361\\026\\221\\017\\304K\\275%\\274e\\027\\204\\364\\377\\000\\202\\337\\0255\\373MN\\316\\177\\003\\374J\\370\\011\\361OM\\266\\370w\\360\\017\\366\\247\\320|L\\221\\245\\257\\210|;\\241x\\227Q\\360M\\246\\245y\\266"\\323\\370W\\302\\327\\027\\251&\\271u\\342\\031!\\374\\277\\256\\341\\276$\\370\\345\\374\\017c\\360\\335\\374G{'\\202\\364\\255cV\\3274\\235\\026T\\266\\224i\\027\\376 \\264\\265\\262\\361\\022i\\032\\204\\220\\033\\275+L\\324\\241\\323\\364\\306\\324\\254m\\347\\216\\313P\\233H\\262\\270\\274\\267\\236\\342\\312\\326XzhW\\366R\\\\\\315\\362G\\244RWw\\272\\346j\\315\\332\\357V\\333\\265\\342\\254\\236\\234\\365\\250\\373H\\276T\\271\\333\\336M\\264\\225\\254\\354\\235\\322\\364I+\\373\\316\\355\\037AJ,\\365/\\007\\370SW\\325t\\213]cZ\\360\\347\\354\\361u\\360\\353\\303\\332\\023\\351\\317\\251n\\370\\221\\342\\317\\215\\277\\022|\\031\\242h\\323\\351\\206)\\236\\017\\026\\303\\340K\\237\\025k\\226\\010\\350\\222\\245\\347\\207`\\271\\203\\313\\224[\\327\\316^0\\360\\345\\267\\206u{\\275\\032\\316\\377\\000\\373fM\\014\\301\\245\\370\\207T\\263U\\227F\\217\\304\\304\\3355\\376\\235\\245^\\304Y/l\\240\\222\\336{x\\356\\003\\024\\275}6{\\253b\\326\\257\\023W9e}{\\246]C}\\247^]i\\367\\266\\354^\\336\\362\\312\\342kK\\250\\034\\253!hn ux\\230\\2430\\312\\220p\\304t5\\321\\352Z\\356\\237\\252YZGw\\005\\340{;9m4\\315+Lh4\\255\\017B \\266&\\210\\\\}\\266mjK\\211vMr\\3625\\254\\355"\\0253L\\014m\\026\\362\\253B\\275\\031s.J\\321\\266\\256\\316\\375\\335\\322N\\362\\322\\351\\306mr\\256[FSp\\3064\\353Q\\253\\016W\\317E\\337H\\351n\\312\\315\\265\\246\\266\\263\\212w|\\327\\224`\\245\\336~\\316_\\004\\365\\337\\332C\\343\\277\\302\\177\\201\\036\\033\\324l\\364mc\\342\\247\\2164\\037\\007[kW\\361Iqe\\242C\\252\\336$w\\372\\325\\325\\264.\\257w\\015\\236\\236.\\256Z\\024ey\\205\\257\\224\\214\\254\\340\\217\\336\\177\\015~\\312\\237\\360JO\\213\\037\\265G\\215\\177\\340\\232\\036\\004\\370}\\361\\323\\302\\337\\032\\374<>!|?\\360\\257\\355_\\255|G}n\\015{\\343\\037\\303]\\007Z\\325<Si\\342\\037\\206\\320I\\016\\221m\\341\\373k\\277\\012\\353\\221\\304\\326\\326\\366\\262\\337\\274\\022\\332\\005\\260\\222[K\\225\\374V\\375\\210>7h\\237\\263\\177\\355s\\373=\\374o\\361<WR\\370W\\341\\357\\304\\357\\016j\\376,61\\274\\367\\320xR\\346\\340\\351^'\\275\\261\\265\\215K_^\\333\\350:\\206\\241<6\\343o\\332$\\267X7\\307\\346o_\\350G\\301\\337\\263\\337\\300\\237\\331\\373\\376\\012\\033\\361\\007\\376\\012\\217\\343\\037\\333\\017\\366n\\361/\\354\\265\\377\\000\\011W\\306\\037\\332'\\301:o\\204>#\\332\\353_\\030<]\\342_\\213:W\\211.\\255\\274\\011c\\360\\372\\322\\325\\032]R\\307\\304\\0367\\324\\0268\\242\\273\\232yWJ\\262K\\250 {\\213\\350\\354~W4\\251\\210\\203\\251\\354\\275\\242\\234p\\365eG\\331\\252\\216\\370\\225of\\232\\202\\344\\233\\351\\032U[\\247;\\311\\312\\022Q\\346\\207\\323e\\224\\350MC\\332\\252n\\022\\257J5\\275\\243\\246\\255\\207w\\366\\2159\\276h/\\346\\251M*\\220\\264Tf\\234\\271e\\361\\346\\227\\3736\\376\\303\\277\\263?\\354\\015\\360\\237\\343\\257\\355[\\373:x\\367\\342\\317\\304\\377\\000\\026\\376\\321\\037\\027\\276\\000\\370\\332\\347\\300\\237\\031<I\\340[\\237\\016\\335x\\013\\304\\377\\000\\0204\\2515\\235+K\\225^\\303S\\271\\264\\207\\302\\002\\030\\255\\345\\267\\265[\\211\\030Iq*\\341\\321\\375\\253@\\377\\000\\202U~\\312Zw\\355]\\343\\377\\000\\012A/\\217|y\\360+\\306\\277\\360L\\337\\025~\\333?\\0064\\277\\030j\\367\\336\\032\\361\\327\\202<Eq\\342\\317\\012i\\032\\006\\227\\342[\\317\\014\\2335\\326#\\264\\263\\275\\277u\\206d\\003n\\246\\266\\327\\221\\334Og\\366\\313\\211<A\\377\\000\\005\\010\\360\\217\\303\\337\\370&\\207\\301\\277\\034\\351\\377\\000\\014\\377\\000d_\\217\\037\\022\\374w\\373`\\374\\177\\361\\266\\271\\360{\\366\\206\\360\\236\\223\\361j\\177\\207V>6\\361\\327\\305o\\031X\\370\\263O\\360=\\257\\212\\354\\257\\2743\\251y\\3276\\326\\326\\372\\224\\237\\273{{\\367\\2162\\306ej\\360\\357\\370'\\337\\355\\377\\000\\252\\374g\\377\\000\\202\\200\\374Q\\370\\207\\373b\\374W\\360\\377\\000\\206.\\277i\\037\\331\\217\\342?\\354\\317\\244x\\317YX<;\\360\\367\\341\\252\\370\\202\\367\\303:\\347\\204t[\\033w\\235m|1\\341h\\356\\3749{\\024~|\\311\\034\\227\\272\\333\\334^\\\\\\265\\315\\334\\367/\\314\\377\\000\\265yq\\325c\\011\\322\\366U+4\\371\\3457R\\021\\257\\027\\005J\\224\\243+F4\\2415\\027\\016YU\\274R\\205gR\\360\\350\\377\\000\\204\\327,\\025'8Tui\\321V\\344\\214=\\234\\345E\\251:\\265b\\343yJ\\244\\342\\344\\246\\245\\032m6\\345IB\\323\\3713\\366.\\375\\231~\\020|e\\375\\214\\377\\000\\340\\245\\037\\030\\274}\\240\\337\\352~=\\375\\234<\\003\\360o^\\370O\\251\\332\\353\\272\\276\\231m\\241\\352~0\\324~&[\\353\\323_i\\226\\027q\\333\\353i,^\\032\\322\\002\\245\\334r\\254^C\\030\\302\\231\\037?t\\374G\\375\\223?bO\\330\\253\\366t\\375\\233>#|Q\\375\\217\\177h?\\333"\\313\\343\\227\\301\\317\\007|S\\361\\307\\307\\337\\014|R\\361\\037\\200>\\025\\374:\\277\\361m\\256\\211\\253'\\2064)<\\021\\247Il\\227Kgs \\267\\217]d\\373U\\265\\340\\232\\013\\311\\247i\\023K\\347t?\\207\\332G\\374\\023w\\366\\013\\375\\277~\\036\\374e\\370\\315\\360\\027\\307?\\022\\377\\000k\\313\\037\\203\\377\\000\\017\\376\\015\\370\\027\\340\\247\\304\\333\\017\\210\\372\\276\\245\\247\\370+Y\\361\\314\\372\\357\\217\\265\\177\\354\\273%:\\017\\203\\216\\227\\342\\271g\\265\\236\\361 i\\245\\322\\015\\224\\213\\005\\335\\325\\264o\\365\\237\\374\\023\\263\\301_\\265\\257\\354\\247w\\360\\313U\\324\\177\\340\\242?\\261\\206\\265\\373\\012^\\333\\351Z\\357\\304?\\003\\370\\277\\343\\306\\221\\342\\215#K\\360V\\275`uO\\021xk\\303\\276\\037\\361&\\214\\017\\201|\\\\\\263\\352\\227j\\366\\332~\\251k\\247\\276\\245+K~\\267\\310\\322\\301.\\265\\252\\342=\\236>\\263\\227\\265\\243G\\027xSu*\\322\\366\\264\\226\\017\\014\\371)\\326\\241\\373\\330\\332\\277\\265iEJ\\022\\252\\245\\011\\244\\234\\214\\350\\323\\241\\35504T}\\225j\\330[J\\242\\205*\\276\\312\\253\\305\\327\\\\\\325)W\\375\\324\\233\\242\\351\\251]\\306q\\246\\343(]\\245o\\345\\247\\3067\\036\\027\\273\\361w\\212\\256\\274\\017a\\252i^\\013\\271\\361\\036\\271q\\341\\015/[\\271\\212\\363Z\\323|/6\\247u'\\207\\3545{\\310X\\245\\326\\251\\016\\222\\326\\221\\334H\\204\\253\\313\\033\\262\\222\\010\\256r\\276\\230\\375\\263<Q\\360\\213\\306\\277\\265g\\355\\001\\342\\257\\200\\232e\\216\\221\\360s\\\\\\370\\245\\342\\273\\337\\207\\266zV\\225\\375\\207\\244?\\207\\233Q\\226;}CG\\321v!\\3224k\\271c\\232\\356\\322\\330\\305\\003Am{\\024Mml\\312m\\343\\371\\236\\275\\345.d\\245\\312\\341\\315\\255\\232\\263W\\350\\326\\266kf\\257\\243<6\\271[\\2172\\237.\\227N\\351\\333\\252}S\\335>\\241E\\024P\\001E\\024P\\001E\\024P\\001E\\024P\\001E\\024P\\001E\\024P\\001E\\024P\\001E\\024P\\001E\\024P\\001_G~\\311?\\362p\\177\\017\\377\\000\\356k\\377\\000\\324'\\304\\225\\363\\215}\\035\\373$\\377\\000\\311\\301\\374?\\377\\000\\271\\257\\377\\000P\\237\\022W67\\375\\317\\027\\377\\000^\\252\\177\\351,\\350\\302\\177\\275\\341\\177\\353\\344?\\364\\244}\\001\\377\\000\\005]\\377\\000\\224\\201\\376\\321\\177\\366\\030\\360G\\376\\252\\357\\003\\327\\347\\215~\\207\\177\\301W\\177\\345 \\177\\264_\\375\\206<\\021\\377\\000\\252\\273\\300\\365\\371\\343ZP\\376\\005\\037\\360G\\362D\\342?\\336+\\377\\000\\216_\\372S=W\\341\\257\\200<\\035\\343\\005\\324\\357\\274o\\361\\223\\300\\377\\000\\0114\\215*[8\\324x\\213H\\361\\377\\000\\211\\274G\\342#p\\2272\\\\\\303\\341O\\017\\370\\017\\302:\\222\\313q\\004pD]\\365{\\315\\026\\305\\332\\3628\\342\\276y\\004\\253\\027\\351\\027\\354\\353\\373\\034\\374\\034\\370\\231\\245_x\\327\\302_\\013>:|_\\370]\\2433G\\342\\037\\332+\\366\\204\\361\\307\\303\\357\\330c\\366[\\360k\\305t-\\356\\356u\\355l\\037\\034\\336x\\312\\332\\013\\244\\362$\\264\\321\\374Ee\\253\\225\\225dk\\010d\\221a\\213\\363\\203\\340\\247\\3058>\\015x\\376\\303\\307\\323\\3744\\370_\\361e\\264\\315?X\\266\\263\\360\\207\\306\\037\\014?\\214\\274\\012\\332\\216\\241\\247\\\\Zi\\272\\326\\243\\341\\223}\\004\\032\\325\\305\\205\\364\\220]Coy\\347\\331L\\366\\302+\\273i\\341wC\\372A\\341/\\333\\017L\\370\\226\\236\\021\\370\\223\\361\\363S\\361W\\355\\231\\373R\\337\\370\\315<-\\373=\\376\\313\\236&\\265\\036\\015\\375\\222>\\011\\334\\254\\232N\\213\\341\\037\\023\\370\\233\\301zW\\366f\\225\\3429\\356\\265\\033\\273x\\264\\317\\014h1i\\3729\\267\\323\\246\\227\\304\\232\\211ya\\26677Q8\\373(\\251+]\\335sI\\313\\2315\\030\\305\\3738\\265\\356\\336\\356\\254t\\223\\213\\366\\211\\362\\221MS|\\336\\326N.\\366M{\\261Q\\263\\274\\245/\\336;\\373\\315YR\\226\\261M:o\\337?j\\264/\\370&\\337\\354\\373\\373J~\\302\\277\\031<\\007\\360\\027\\300_\\005t\\257\\214>"\\322\\364\\377\\000\\030|\\011\\370\\235\\340\\357\\205\\3364\\370s\\245\\370\\354\\370\\013R\\323\\356\\365\\235\\017\\300^8\\375\\240>$\\370\\203\\306\\337\\021\\276\\034\\335j3\\351\\372U\\367\\213%M\\017\\3037\\327>$\\322\\257\\354md\\212\\037\\335\\377\\000"\\237\\021~\\032\\374@\\370G\\343\\015g\\300\\037\\024<\\031\\342O\\000\\370\\327\\303\\3672Zk\\036\\031\\361^\\221y\\242\\352\\366R\\307#\\306\\035\\355/bF\\226\\331\\314l\\321O\\036\\350fLI\\014\\217\\033+\\037\\3537\\340\\317\\355a\\342_\\202\\376-\\370\\351\\343\\215[\\342\\013\\374m\\361\\227\\354\\373\\340\\313o\\024~\\331\\277\\035\\022_\\370\\247\\376$\\376\\321\\032\\333\\337\\370\\013\\366\\177\\375\\201\\277g\\226\\261\\263\\266\\261\\360O\\301m'\\342&\\253%\\325\\365\\336\\231k\\014z\\265\\347\\206\\365\\011\\232(t\\205\\304\\337\\320\\036\\211\\373E\\374=\\361\\007\\211\\233\\302\\332\\245\\202\\352~+\\360\\377\\000\\307\\255[\\366t\\322\\257t\\333\\033K\\273-S\\342\\307\\207\\277g'\\375\\240\\374X\\276\\035mB\\345f\\322\\354\\241\\360\\336\\237\\342\\255721\\230\\336\\350O\\033\\223o \\234|^;9\\315\\262:\\370\\232\\263\\301\\3138\\300\\342\\023\\251\\031\\373W\\011\\320\\225:tT\\341)N\\233R\\207$\\250\\325Q\\345\\2475\\032\\336\\332Q\\214\\247:4\\276\\303\\005\\224eY\\325\\0344!\\213\\216S\\215\\242\\3259ASS\\215h\\316u\\\\'\\025\\012\\212\\323\\347Ui\\271sN\\015\\322\\366Q\\224\\243\\010V\\251\\374\\340\\177\\301\\001\\277\\340\\233\\0364\\323\\265\\377\\000\\030~\\325\\377\\000\\264g\\303(\\264\\337\\006k^\\010\\270\\360G\\302O\\004|H\\360\\2742\\336\\370\\235\\265\\275[G\\325\\265\\177\\210\\262\\370o\\3046E\\2544hl\\264[{M*y\\242\\037\\332\\013\\256]\\334\\300\\005\\2746\\363\\334\\376\\251\\177\\301P5O\\205\\277\\263o\\354\\373\\342\\257\\022\\370k\\341V\\205\\340\\013\\201\\341o\\021\\\\\\332\\374E\\320\\177d?\\007\\374h\\360J\\353CN\\273\\203C\\360g\\213\\256\\254\\256l\\337\\341\\304\\272\\256\\256t\\373\\033mj\\375#\\323\\241\\237[\\203\\375%\\246S\\032\\375\\015\\343\\317\\370(\\037\\303\\3357\\302W\\336#\\360.\\203\\342?\\032Cg\\360c\\302_\\264\\253X\\350\\362\\351v\\236+\\361\\037\\354\\335\\2576\\245\\246x\\343\\342'\\302\\2752\\372;\\230<U\\343o\\005j\\266\\250|A\\341\\233\\361esh\\257n\\2237\\231\\250XEq\\374c\\377\\000\\301N\\177m\\213o\\217\\336<\\324\\274\\031\\340\\217\\023\\370O\\307:]\\215\\320\\265\\361\\207\\355\\015\\360\\332\\317\\307\\177\\013\\377\\000\\341\\247|3\\015\\247\\205\\265O\\000\\267\\306/\\204S\\315g\\242M\\343\\337\\017]\\351\\323A{\\251\\303\\247\\030\\257.\\354m_M\\217L\\260\\261\\264\\263^<\\236\\206\\177\\233\\347\\377\\000\\333Y\\212\\226]\\202\\302\\351O\\015\\177k\\013\\306\\317\\222\\244n\\240\\245i\\2719T\\247)J\\253\\345\\215\\036Zue\\207\\352\\315kdYVE\\375\\221\\200\\345\\3141\\230\\244\\334\\361\\026\\366rjZ9\\302Vsq\\274RQ\\2478\\3064\\322r\\255\\315:Q\\257\\371/E\\024W\\350G\\301\\005\\024Q@\\032\\272\\016\\205\\254\\370\\243\\\\\\321\\2745\\341\\3352\\367Z\\361\\007\\210\\265];B\\320\\264m6\\336K\\275GV\\326u{\\310t\\3753L\\260\\265\\211K\\334\\336\\334^\\334A\\024Q\\250,\\362J\\252\\240\\222+\\364?\\305\\177\\360H?\\370)\\037\\202|1\\342/\\031x\\223\\366S\\361\\275\\227\\207|)\\241\\352\\276$\\327\\257m\\365\\317\\001j\\323\\331\\350\\332%\\214\\372\\226\\247u\\026\\227\\243\\370\\266\\342\\357Px\\354\\255\\246q\\015\\264\\023O&\\315\\261F\\356B\\237\\230\\277d6T\\375\\254\\177f\\007vUE\\375\\242>\\01233\\020\\252\\252\\277\\022\\2744Y\\231\\217\\001@\\004\\222}+\\372\\246\\375\\256?f_\\370)N\\251\\377\\000\\005\\013\\377\\000\\202\\203\\374f\\375\\236\\374l~\\005|\\017\\327\\177g\\357\\017\\215S\\342\\017\\217\\374?\\245\\370\\233\\301_\\021\\374\\025\\240\\374\\016\\370Uc\\343\\237\\001\\370&\\327Z\\360\\266\\265\\026\\231\\342\\0115]\\013\\\\\\363.\\241\\213M\\225\\037G\\234\\013\\325\\016\\304\\370\\370\\334\\302\\245\\014\\303\\011\\202\\205Z8h\\342(\\325\\253\\317[\\341\\224\\251\\326\\303S\\215%/iMA\\315W\\223R\\375\\343\\346\\214b\\251\\276f\\327\\257\\202\\300S\\257\\200\\305cgJ\\266!\\320\\253J\\227%\\037\\2121\\235,EGU\\307\\222nj.\\214S\\217\\356\\327,\\245'=\\022\\177\\316\\337\\303?\\370%7\\374\\024#\\343\\027\\200|)\\361C\\341\\307\\354\\313\\343\\017\\022x\\023\\307\\032E\\276\\277\\341O\\020&\\271\\340].-kE\\273-\\366=N\\332\\313[\\361U\\265\\314v\\223"\\357\\205\\344\\201\\004\\261:K\\036\\350\\235\\035\\277B\\177f\\357\\201\\267\\337\\015\\177\\340\\224\\377\\000\\360V\\377\\000\\014\\374\\\\\\370o\\247h_\\030>\\024x\\357\\341\\177\\207.\\243\\361\\016\\217\\243\\336\\370\\253\\301z\\231\\327<+\\006\\251a\\247k(\\223=\\212\\313\\014\\244;Z\\\\yS\\3056C<n\\011\\375B\\360\\347\\301\\277\\216\\337\\022\\374\\007\\377\\000\\006\\354x\\327\\341O\\204<a\\342_\\207\\277\\011\\364K\\015o\\343N\\263\\341\\271\\\\h~\\025\\320\\256\\242\\375\\237\\347\\323/<X\\251v\\212\\366\\206?\\017\\370\\215\\243\\014\\222m\\376\\317\\237\\345\\007 \\371\\277\\355\\000\\312\\377\\000\\263\\217\\374\\034@U\\225\\200\\375\\242\\376\\033\\251*A\\001\\223T\\360":\\344\\177\\020u`Gb\\010<\\327&\\0236\\255\\214\\235\\024\\252\\302-\\346\\030H8B\\352t\\343K>\\303\\341\\271j?i.uZ\\234y\\257\\311I|p\\345\\224W1\\333\\210\\312\\250\\341=\\243\\366s\\232\\372\\216*\\\\\\363\\264\\2419T\\311+by\\251\\256H\\362:S\\235\\222\\347\\250\\364\\204\\371\\242\\335\\217\\212\\277\\340\\254\\277\\262\\357\\215>2\\374r\\375\\201>\\021~\\314\\337\\007\\340\\361\\007\\217<e\\373\\016x'\\304\\323xc\\300\\332>\\205\\240\\276\\255uc'\\2105\\015w\\304Z\\335\\3316v\\221\\314,\\254\\327\\315\\274\\275\\235\\014\\216!\\203\\315y\\244\\2067\\374\\253\\370\\343\\377\\000\\004\\327\\375\\271?f\\357\\002K\\3613\\343W\\354\\355\\343\\017\\004\\370\\026\\337W\\322t\\033\\237\\021K\\250xS]\\265\\265\\3255\\353\\203g\\243\\333]A\\341\\217\\020\\336\\317j\\227\\027\\336]\\274r\\311\\022\\302n.a\\203\\314\\023O\\012?\\365\\307\\341&U\\377\\000\\202\\255\\377\\000\\3016C2\\202\\377\\000\\360K\\333\\205@H\\005\\230Z\\352\\356UA\\373\\315\\261X\\340vRz\\003_\\002~\\322:W\\306\\377\\000\\205?\\360N\\257\\214\\036\\021\\270\\375\\215\\365\\177\\331\\237\\340\\216\\243\\373e\\374>\\361\\207\\213<I\\361\\313\\366\\245\\325>&|K\\273\\324\\017\\214\\276\\027Co\\256\\370C\\301\\367?\\006\\364\\253kO\\001^6\\213\\240\\244o&\\272\\026\\313\\373;Vak)\\333-iC1\\304K0\\3130\\022\\253\\016\\\\D0.r\\253()\\311bj\\342\\251NQ\\224\\353\\302M\\323Xx\\270\\306\\024\\253s\\271\\270\\312T\\275\\316|\\253e\\330\\177\\250\\346\\030\\325NjT%\\213QT\\343'\\010\\274=\\034-X\\251F\\024g\\024\\252K\\021%)J\\255.U\\016h\\306\\247\\277\\313\\370\\265g\\377\\000\\004~\\377\\000\\202\\226\\337\\\\i\\226\\320~\\310_\\023\\222M_G\\217\\\\\\265k\\307\\360\\276\\235\\004VR\\210\\331`\\324\\356\\265\\017\\020\\305\\026\\211\\254\\001*\\356\\323\\357^\\336\\375\\010`\\366\\312Q\\302\\360_\\004?\\340\\231\\377\\000\\267O\\355\\037\\360\\347G\\370\\267\\360W\\366u\\361w\\216>\\034x\\202\\347V\\264\\320\\274Wo\\252xCG\\323\\365\\211t-N\\353E\\325\\337MO\\021\\370\\216\\316k\\333h5\\213\\033\\353W\\2328\\232\\037\\264XO\\010\\220\\311\\014\\252\\237\\332\\267\\206~\\024\\376\\320q\\377\\000\\301k<i\\361\\265t\\017\\0337\\354\\313\\342\\017\\331'K\\360\\346\\235\\343\\030u)%\\370s\\251\\370\\276\\013\\257\\013\\315ma\\035\\264:\\203C.\\250\\246-RH\\311\\203!^I\\021\\266\\311\\271\\2775\\277f\\217\\005x\\223\\306\\337\\360G\\017\\370&\\362\\370G\\366f\\370\\227\\373Pk>\\033\\370\\371\\361;]\\207\\303\\237\\015>5]|\\023>\\015\\270\\263\\370\\353\\361\\321\\355|[\\343-v\\313\\301Z\\353j\\276\\022\\216ym\\241\\272\\2626\\261\\214_$\\376a\\362\\304o\\343S\\342\\232\\365e\\202\\214]\\013c!\\201\\223\\232\\263Te\\213\\241\\214\\255:sS\\304R\\204\\245I\\341\\243O\\336\\253F\\356NN)\\332\\007\\253S\\206hRX\\311K\\333_\\011,lT]\\323\\253\\034-l%\\030N.\\024*IF\\252\\304J\\247\\273J\\256\\221QM\\253\\314\\376N\\3763\\374\\023\\370\\253\\373<\\374E\\327~\\023|i\\360N\\257\\360\\373\\342'\\206\\206\\236\\372\\317\\2065\\241j\\327v\\261j\\272u\\256\\255\\246\\334\\307sas5\\275\\365\\244\\372}\\345\\264\\261\\315o4\\2612\\311\\200\\373\\225\\200\\362\\332\\375[\\377\\000\\202\\325\\353\\177\\024<A\\377\\000\\005\\014\\370\\267\\250\\374b\\360G\\204\\276\\035x\\361\\374;\\360\\276-G\\302>\\011\\361\\365\\347\\304\\315\\013K\\262\\217\\341\\337\\207\\177\\262\\012x\\302\\373\\301\\332\\004\\272\\215\\334\\332a\\265\\232e:U\\250\\211\\356\\014j$U\\022\\277\\345%}\\216\\026\\254\\253\\340\\3608\\211\\245\\032\\230\\254=\\012\\262Q\\222\\224T\\252\\321\\205I(I6\\247\\005)5\\011\\246\\324\\342\\224\\223i\\334\\371,U(\\320\\305\\343p\\360rt\\360\\325\\353S\\213\\222q\\223\\215:\\263\\204\\\\\\342\\322q\\233\\214S\\224ZN2\\272i5`\\242\\212+s\\000\\242\\212(\\000\\242\\212(\\000\\242\\212(\\000\\242\\212(\\000\\242\\212(\\000\\257\\243\\277d\\237\\3718?\\207\\377\\000\\3675\\377\\000\\352\\023\\342J\\371\\306\\276\\216\\375\\222\\177\\344\\340\\376\\037\\377\\000\\334\\327\\377\\000\\250O\\211+\\233\\033\\376\\347\\213\\377\\000\\257U?\\364\\226ta?\\336\\360\\277\\365\\362\\037\\372R>\\200\\377\\000\\202\\256\\377\\000\\312@\\377\\000h\\277\\373\\014x#\\377\\000Uw\\201\\353\\363\\306\\277s?\\340\\244\\377\\000\\260_\\355a\\361\\027\\366\\333\\370\\355\\343?\\006\\374)\\376\\330\\360\\326\\267\\252\\370F]/R\\377\\000\\204\\347\\341\\266\\237\\366\\244\\264\\370u\\341\\015>\\341\\276\\307\\252\\370\\306\\013\\210v\\336Z\\\\&$\\211\\011\\362\\367.T\\253\\037\\206\\377\\000\\341\\332\\337\\266\\267\\375\\021\\177\\374\\310\\337\\011\\277\\371\\273\\256J\\031\\256X\\250\\321\\276cC\\341\\217\\374\\276\\247\\331\\177x\\353\\304e\\231\\223\\257Y\\254\\276\\273Nr\\377\\000\\227U?\\231\\377\\000t\\370^\\212\\373\\243\\376\\035\\255\\373k\\177\\321\\027\\377\\000\\314\\215\\360\\233\\377\\000\\233\\272?\\341\\332\\337\\266\\267\\375\\021\\177\\374\\310\\337\\011\\277\\371\\273\\255\\177\\265r\\277\\372\\031a\\377\\000\\360u?\\376H\\313\\37332\\377\\000\\241u\\177\\374\\023S\\377\\000\\221>X\\360\\227\\305o\\210\\336\\005\\262\\265\\322\\274-\\343\\015kK\\320\\255<s\\341?\\211k\\341\\257\\264\\213\\357\\012\\\\\\370\\357\\300\\306\\373\\376\\021/\\023j~\\025\\324Rm;X\\324\\254c\\324\\365\\030\\3427v\\263!\\206\\372hdG\\212FC\\365\\357\\206\\277\\340\\245\\377\\000\\265O\\205\\265\\013-r\\313\\304~\\034\\273\\361%\\247\\355g\\342\\337\\333Fo\\021\\337\\370|6\\241\\250\\374f\\361\\277\\203\\007\\200\\274B/\\255m/a\\261\\377\\000\\2046_\\015\\265\\304\\021\\351p\\332C\\035\\272\\335\\311\\024\\022GnV\\005\\311\\377\\000\\207k~\\332\\337\\364E\\377\\000\\363#|&\\377\\000\\346\\356\\217\\370v\\267\\355\\255\\377\\000D_\\377\\00027\\302o\\376n\\352g\\231e\\025y}\\256;\\013[\\223nz\\224f\\225\\327+\\322M\\2538\\350\\326\\315Y=\\221T\\362\\374\\332\\2277\\262\\301bis\\357\\313N\\254o\\255\\356\\371R\\325=S\\335;\\333vx\\027\\217\\277h\\217\\214\\037\\023<3\\341_\\004\\370\\263\\3067w~\\013\\360\\035\\327\\216\\347\\360/\\205m-,4\\355'\\301\\326\\277\\022\\374B\\376)\\361\\236\\213\\240\\233;T\\270\\267\\360\\365\\346\\266\\351+X\\311<\\266\\310-\\241H\\343T\\2060\\276)_t\\177\\303\\265\\277mo\\372"\\377\\000\\371\\221\\276\\023\\177\\363wG\\374;[\\366\\326\\377\\000\\242/\\377\\000\\231\\033\\3417\\377\\0007u\\244\\263|\\266M\\271ft\\035\\334\\245\\374j{\\312NRv\\346\\262r\\223r}\\333os5\\225f1\\265\\262\\332\\352\\312+\\3705/h\\245\\030\\253\\362\\336\\321\\212IvI%\\241\\360\\275\\025\\367G\\374;[\\366\\326\\377\\000\\242/\\377\\000\\231\\033\\3417\\377\\0007t\\177\\303\\265\\277mo\\372"\\377\\000\\371\\221\\276\\023\\177\\363wS\\375\\253\\225\\377\\000\\320\\313\\017\\377\\000\\203\\251\\377\\000\\362E\\177ff_\\364.\\257\\377\\000\\202j\\177\\362'\\302\\364W\\335\\037\\360\\355o\\333[\\376\\210\\277\\376do\\204\\337\\374\\335\\321\\377\\000\\016\\326\\375\\265\\277\\350\\213\\377\\000\\346F\\370M\\377\\000\\315\\335\\037\\332\\271_\\375\\014\\260\\377\\000\\370:\\237\\377\\000$\\037\\331\\231\\227\\375\\013\\253\\377\\000\\340\\232\\237\\374\\211\\360\\275z^\\243\\361\\243\\343\\026\\257ay\\245j\\337\\026>%\\352\\232^\\243m=\\226\\241\\246\\352>;\\361E\\355\\205\\375\\235\\314m\\015\\315\\245\\345\\235\\316\\252\\321\\335[I\\023\\262\\274n\\254\\216\\254U\\201\\004\\212\\372w\\376\\035\\255\\373k\\177\\321\\027\\377\\000\\314\\215\\360\\233\\377\\000\\233\\272?\\341\\332\\337\\266\\267\\375\\021\\177\\374\\310\\337\\011\\277\\371\\273\\252\\216o\\226\\306\\374\\271\\245\\010\\337\\265zk\\377\\000n%\\3459\\204\\255\\315\\226\\326\\225\\266\\275\\031\\277\\375\\264\\371sH\\370\\301\\361o\\303\\372m\\246\\215\\240\\374R\\370\\213\\242i\\026\\021\\230lt\\255#\\306\\376&\\323t\\333(\\213\\264\\206+K\\033-M"\\266\\214\\310\\356\\333QTnrq\\222k\\015|s\\343e\\261\\327\\364\\305\\361\\217\\212WM\\361]\\334\\272\\207\\212t\\365\\361\\016\\254,|I\\1774\\276|\\327\\272\\375\\240\\273\\362\\365\\213\\267\\230\\007in\\026Gf\\033\\213\\023\\315}\\177\\377\\000\\016\\326\\375\\265\\277\\350\\213\\377\\000\\346F\\370M\\377\\000\\315\\335\\037\\360\\355o\\333[\\376\\210\\277\\376do\\204\\337\\374\\335\\325\\177m`?\\350mG\\377\\000\\007\\303\\377\\000\\223\\027\\366>;\\376\\205u\\177\\360D\\377\\000\\371\\023\\344\\271~$\\374D\\237V\\321\\365\\351\\274}\\343I\\265\\337\\016\\332\\265\\217\\207\\365\\251|S\\256I\\253hVO\\024\\260=\\236\\217\\250\\275\\361\\233L\\2650M2\\030\\340tB\\222\\262\\221\\206 \\273\\304\\237\\022\\376#\\370\\316\\306-/\\306\\037\\020<m\\342\\2752\\013\\270\\357\\340\\323\\274I\\342\\275w]\\261\\206\\372(g\\267\\212\\366+MR\\376X\\343\\273[{\\253\\244Y\\002\\207\\011s"\\206\\012\\354\\017\\326_\\360\\355o\\333[\\376\\210\\277\\376do\\204\\337\\374\\335\\321\\377\\000\\016\\326\\375\\265\\277\\350\\213\\377\\000\\346F\\370M\\377\\000\\315\\335'\\234\\345\\362\\2776kE\\363oz\\360\\327m\\375\\375v_r\\005\\224c\\325\\255\\225\\326\\\\\\273Z\\204\\364\\364\\367t?X\\276\\020\\177\\301l\\177d\\317\\200~*\\266\\370\\233\\360\\207\\366\\013\\361\\337\\202<ue\\360\\325\\374\\003e\\341\\235;\\366\\250\\361e\\327\\302+(\\244\\216\\322\\340\\305g\\340mW\\303W\\026v\\220\\256\\241ci\\032]\\307h\\267q\\332B#\\217nJ\\237\\347\\277\\303\\337\\024~&xGO\\376\\310\\360\\247\\304_\\035\\370cI\\023\\313r4\\317\\017x\\273\\304\\032.\\236.g\\012&\\270\\373\\026\\233\\250E\\037\\236\\341\\023s\\355\\334\\333\\006I\\300\\257\\253\\277\\341\\332\\337\\266\\267\\375\\021\\177\\374\\310\\337\\011\\277\\371\\273\\243\\376\\035\\255\\373k\\177\\321\\027\\377\\000\\314\\215\\360\\233\\377\\000\\233\\272\\345\\241\\213\\310\\360\\325\\252\\342p\\370\\372P\\304b#N\\025*K\\033V\\274\\347\\032\\\\\\336\\315Jx\\214Ei%\\036y4\\242\\342\\265\\333En\\252\\330\\\\\\347\\023F\\226\\036\\276\\002\\244\\260\\364%9\\323\\247\\014\\035:0\\204\\252r\\363\\265\\032\\024)E\\271rF\\356I\\2754z\\273\\374Q\\253k\\032\\266\\277\\251]\\353\\032\\356\\251\\250\\353Z\\275\\374\\276}\\376\\253\\253^\\334\\352Z\\225\\354\\333U<\\353\\273\\353\\311^[\\231v"\\215\\316\\314p\\240g\\000Vu}\\321\\377\\000\\016\\326\\375\\265\\277\\350\\213\\377\\000\\346F\\370M\\377\\000\\315\\335\\037\\360\\355o\\333[\\376\\210\\277\\376do\\204\\337\\374\\335\\327C\\315\\262\\306\\333y\\235\\006\\336\\255\\272\\324\\356\\337\\376\\004s\\254\\2531I%\\227WIh\\222\\243R\\311\\177\\340'\\302\\364W\\335\\037\\360\\355o\\333[\\376\\210\\277\\376do\\204\\337\\374\\335\\321\\377\\000\\016\\326\\375\\265\\277\\350\\213\\377\\000\\346F\\370M\\377\\000\\315\\335/\\355\\\\\\257\\376\\206X\\177\\374\\035O\\377\\000\\222\\037\\366fe\\377\\000B\\352\\377\\000\\370&\\247\\377\\000"|/E}\\321\\377\\000\\016\\326\\375\\265\\277\\350\\213\\377\\000\\346F\\370M\\377\\000\\315\\335\\037\\360\\355o\\333[\\376\\210\\277\\376do\\204\\337\\374\\335\\321\\375\\253\\225\\377\\000\\320\\313\\017\\377\\000\\203\\251\\377\\000\\362A\\375\\231\\231\\177\\320\\272\\277\\376\\011\\251\\377\\000\\310\\237\\013\\321_t\\177\\303\\265\\277mo\\372"\\377\\000\\371\\221\\276\\023\\177\\363wG\\374;[\\366\\326\\377\\000\\242/\\377\\000\\231\\033\\3417\\377\\0007t\\177j\\345\\177\\3642\\303\\377\\000\\340\\352\\177\\374\\220\\177ff_\\364.\\257\\377\\000\\202j\\177\\362'\\302\\364W\\335\\037\\360\\355o\\333[\\376\\210\\277\\376do\\204\\337\\374\\335\\321\\377\\000\\016\\326\\375\\265\\277\\350\\213\\377\\000\\346F\\370M\\377\\000\\315\\335\\037\\332\\271_\\375\\014\\260\\377\\000\\370:\\237\\377\\000$\\037\\331\\231\\227\\375\\013\\253\\377\\000\\340\\232\\237\\374\\211\\360\\275\\025\\367G\\374;[\\366\\326\\377\\000\\242/\\377\\000\\231\\033\\3417\\377\\0007t\\177\\303\\265\\277mo\\372"\\377\\000\\371\\221\\276\\023\\177\\363wG\\366\\256W\\377\\000C,?\\376\\016\\247\\377\\000\\311\\007\\366fe\\377\\000B\\352\\377\\000\\370&\\247\\377\\000"|/E}\\321\\377\\000\\016\\326\\375\\265\\277\\350\\213\\377\\000\\346F\\370M\\377\\000\\315\\335\\037\\360\\355o\\333[\\376\\210\\277\\376do\\204\\337\\374\\335\\321\\375\\253\\225\\377\\000\\320\\313\\017\\377\\000\\203\\251\\377\\000\\362A\\375\\231\\231\\177\\320\\272\\277\\376\\011\\251\\377\\000\\310\\237\\013\\327\\321\\337\\262O\\374\\234\\037\\303\\377\\000\\373\\232\\377\\000\\365\\011\\361%z\\327\\374;[\\366\\326\\377\\000\\242/\\377\\000\\231\\033\\3417\\377\\0007u\\357\\037\\263/\\374\\023\\313\\366\\302\\360\\337\\306\\377\\000\\004\\353Z\\327\\302\\017\\261i\\226_\\360\\222}\\246\\347\\376\\023\\377\\000\\205\\367>W\\332|#\\257\\332C\\373\\233O\\033I#\\356\\270\\236%\\371P\\343~N\\024\\0229\\361\\231\\246X\\360\\230\\244\\263\\032\\015\\272sI*\\324\\356\\337+\\376\\361\\276\\027,\\314\\226+\\014\\336_]%R\\027~\\312\\247\\363/\\356\\237\\377\\331	\N	t	Y	opuscollege	2009-06-15 11:26:28.146359
5	StudentsBySubject	reportTitle	text	\N	List of Students by Subject	t	Y	opuscollege	2010-07-21 10:02:28.343449
9	CurriculumPerYear	reportTitle	text	\N	Curriculum per Academic	t	Y	opuscollege	2011-02-23 16:37:24.315383
8	StudentsBySubject	reportLogo	image/gif	GIF89a\\212\\000\\211\\000\\367\\000\\000\\21411\\21499\\224BB\\224JB\\224JJ\\224JR\\234JJ\\234RJ\\234RR\\234ZR\\234ZZ\\245ZZ\\245cZ\\245cc\\245kk\\255kk\\255sk\\255ss\\255{s\\255{{\\265{s\\265{{\\265\\204{\\265\\204\\204\\265\\214\\204\\265\\214\\214\\275\\204\\204\\275\\214\\204\\275\\214\\214\\275\\224\\214\\275\\224\\224\\306\\224\\224\\306\\234\\224\\306\\234\\234\\306\\245\\234\\306\\245\\245\\306\\255\\255\\316\\245\\245\\316\\255\\245\\316\\255\\255\\316\\265\\255\\316\\265\\265\\316\\275\\275\\326\\255\\255\\326\\265\\255\\326\\265\\265\\326\\275\\265\\326\\275\\275\\326\\306\\275\\326\\306\\306\\336\\275\\275\\336\\306\\306\\336\\316\\306\\336\\316\\316\\336\\326\\326\\347\\316\\316\\347\\326\\316\\347\\326\\326\\347\\336\\336\\357\\326\\326\\357\\336\\336\\357\\347\\347\\357\\357\\357\\367\\347\\347\\367\\357\\347\\367\\357\\357\\367\\367\\367\\377\\367\\367\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377,\\000\\000\\000\\000\\212\\000\\211\\000\\000\\010\\376\\000OX\\250p\\241\\302\\300\\202\\007\\015\\022T\\210pa\\302\\207\\016#6\\234\\310\\260"D\\212\\027-J\\324\\210qc\\306\\217\\033O\\\\\\000@\\262\\244\\311\\223(S\\252\\\\\\311\\262\\245\\313\\2270c\\312\\034(\\263\\246\\315\\2338s\\352,9\\301\\302\\316\\237-\\003\\014\\000J\\024(\\315\\242:\\0074h\\200\\301\\203\\007\\022\\036Dxp\\200\\264\\252\\315\\236VkNH\\001\\303\\303\\322\\006$a\\220\\034\\340!\\253Y\\227G\\317\\216\\255\\201\\301\\244\\203\\021) \\250<\\001V\\300\\010\\265xQb\\315+"\\300\\205\\0241H\\330\\2500t\\245W\\000\\001N\\344]L2\\355Y\\262'U\\264L \\031\\000\\006\\004\\214\\027\\357}L"@\\344\\226*<\\003\\030!:\\263Z\\307U\\003\\210\\030A\\000e\\345\\225"&4~a\\032\\357\\346\\252\\011H\\264N\\371z\\245b\\2221b\\210p\\260\\033e\\000\\022}k\\333DM\\224\\300]\\343\\023Ftp\\231`\\344a\\000\\0128\\214\\030iR\\000\\011\\001\\003B\\376\\\\(\\255\\334\\345m\\242\\003z\\227\\034\\020#AL\\335!P\\3068\\251\\243\\270\\003\\032!\\234\\026\\036[\\274<\\000\\346?\\221\\226R\\010\\375\\271\\324\\200\\016\\002\\240\\204\\301\\010P\\265\\326\\003J\\022\\214\\320\\000\\011.x\\220\\001\\011)\\254f\\241\\007\\356\\325v\\036P4\\244\\224\\202\\0046\\221\\300R\\0025x\\200\\003J\\011\\224\\205\\330W$\\021\\260Tn\\312\\001\\250\\223\\003m\\231\\224[\\20259 \\333M-\\272d\\242\\207>\\025\\025@\\012\\2105E\\341x7]gS\\220+\\231h\\001X\\246\\331x\\223\\0036$\\350A\\005\\005\\332\\344dMP\\252\\344C\\005K\\021I\\324\\004\\036\\360\\250\\036Na\\202\\351\\242J$\\234\\260A\\207\\231Y\\031S\\003\\303\\2314\\037P\\031\\260\\371fJ\\021\\306g\\246N\\007\\202\\220\\037\\010\\036\\214\\360gNS\\371\\331\\022\\011t\\326YAN\\252-\\372_\\015T\\351\\324\\246\\233.\\235@\\236fE\\336\\024\\003f\\000\\250\\220\\002\\206\\247\\002\\200\\246N\\226\\312\\264iJ\\376\\011<')N\\023P9\\200\\254:v\\206\\023\\2079\\275:`\\227j}\\010\\023\\012%A\\360\\243IN\\215PC\\2441\\035\\327k\\253(\\335Z\\345\\2446a\\020AI"tY\\331\\221T\\326\\004\\001\\264\\324\\201\\033\\331\\247\\301\\206\\032\\223\\002\\334)U\\003o&up\\254L\\030\\364y\\022\\263\\260\\212k\\022\\003\\366"egJ\\003 I\\022\\011\\015\\320\\013\\300\\242\\023\\344XS\\234$\\014\\345\\000\\0125\\244\\000lI\\276\\252\\344/\\2502\\035'\\232j\\206\\241\\344@\\276&m\\245\\000b#\\314\\000A\\003\\036\\0040\\202\\010+E\\234\\322\\204\\214\\355{\\222\\010tB\\220iJ\\2552\\020\\232y1tk\\022\\004\\244*\\020\\203\\\\,\\352\\240\\302\\320D\\027=4\\014G\\317\\200\\353Y\\302\\252\\244@\\303\\035d\\360\\024K\\320\\036\\267\\037\\213$P\\233\\322\\310\\310\\352\\360\\251\\312*9\\300\\335iZ\\273\\204\\301\\330B\\256\\024@\\007\\327\\236\\204\\347\\004\\344\\232\\024\\000m:r \\002\\217\\000\\200\\255\\022\\376\\312\\266\\231\\033T\\3160\\211\\305\\322\\306\\317Q\\366.K7\\237drg\\015\\344g\\223\\240d\\3134\\261Kk\\246$\\302\\204%\\307\\364\\245I\\003\\274P\\303\\005\\017\\263\\264tVM\\303\\031S\\345(5@C\\350*m\\3762N\\016\\314l\\226\\313&\\011\\376\\022\\352'Mp\\370K#\\\\\\215\\022\\307{\\313kV\\351\\226\\307d;K\\272\\3264\\372I\\300\\253\\324\\203\\316U\\321^\\322\\2720\\341n\\022\\3372\\255J5N\\307=\\340\\351\\360~\\263\\204\\246\\010)\\340\\275R\\342+a\\000\\275\\331\\311g|S\\255\\000\\220<{\\331-\\245\\010\\000\\001*\\254\\177\\322\\267'6OR\\343/\\361_\\273D3$\\253\\020\\017Y:3Q\\0022\\300\\024\\025\\234\\300)\\036\\000\\001TT\\022\\000\\025\\204 n+\\351\\234K\\006\\200\\002\\001\\226\\244\\200\\030\\020\\330Oh'-da\\200.\\030x\\300KdD\\202\\366\\305\\244wf\\323\\037Ld\\225\\036R!\\345\\200$9\\233\\002\\022\\340\\200\\302\\330\\000\\203\\376,\\362\\300\\005\\000\\226\\022\\326!&\\006\\276C\\011\\001\\012\\370\\244\\361\\\\N\\001\\001\\260\\200\\360\\210B\\273\\000\\304\\300\\003'\\240\\001\\017\\022\\264'\\363`/[r\\353\\240\\211\\212\\303A\\0258\\005\\005\\030\\250\\201\\371\\214C,\\234(\\300\\006.PT\\007f\\240\\000\\004\\264\\361L\\341\\233\\313\\011$\\024\\202\\004Y\\217$\\023 \\301\\273\\254\\270\\037\\011\\015\\014?6H\\324\\315\\226\\342\\231\\027\\320-l\\006\\253\\211\\311\\024P\\201\\266\\005`Yv,\\012\\355\\016\\224\\202\\021|\\300\\006#\\350`K\\234";\\222\\004\\000\\005\\236aJ\\352\\004V\\241\\335\\225\\004\\003\\364\\213I\\012\\350\\225\\230\\012L\\340\\216;\\301!IT\\260\\033$9'\\004\\015\\210\\001\\015>5\\002\\021\\336\\357\\005"\\230\\201L p\\001\\310\\031\\347\\004m\\223\\011d\\346\\362\\202b\\016n\\212+\\221\\336\\255h\\360\\271\\365\\214\\347K\\023@\\233q\\312\\347\\277\\021@\\200\\211)\\241\\236L\\300\\250\\222\\001\\330 \\004\\313\\213\\237\\012\\316\\026I\\225\\350\\262$\\223\\376\\223\\333\\010\\216\\365\\232X%+\\224{\\364L\\027\\315\\326'\\023\\264\\004\\2115\\301\\236J\\030\\020\\202\\027\\224f\\000\\0230\\225\\004Z#\\277\\226H\\017\\220\\006\\255\\340,M\\342\\002\\251\\271 \\007\\242)S\\336\\254E\\252\\000\\270\\000&\\325\\011@\\003~\\343\\264=\\326$_\\027\\350\\300\\025=p\\252\\012\\220\\247\\001\\256\\314]\\036\\007\\027\\003\\023\\020`n\\257\\024\\217g\\022p\\202Y\\212\\264\\001\\027\\370\\200h^`DS\\306\\200\\000/p]I\\032p\\027\\377\\341\\310%&\\223!I`\\206\\226X\\032(G\\272#\\311\\005\\350\\245\\202\\250\\222$\\001\\356\\372X\\012_\\022\\200\\325\\001`\\003U;g\\202\\222\\303\\326\\024\\0001w(x\\200\\300\\376\\010\\310\\235\\262\\344\\002\\014\\000\\200]J\\320\\247F\\215\\223$\\002`[`\\363\\271\\222\\261\\2762\\232\\210\\021A\\0152\\0004\\301v\\322\\206*!\\000\\0120\\213U\\011H\\215\\004\\0168@\\2148vQ\\210\\311&\\006\\236\\361@\\004\\030K\\222a\\222D\\001^\\231\\376\\024_I\\362\\247\\212\\002\\300\\0015\\300\\240\\311ZB\\000\\030\\304\\363%'$\\011\\012\\232\\252*\\277"/\\002.\\032\\300jSr\\312\\222(\\000\\004\\015\\220\\013:\\243\\0250g\\242\\300\\001\\031x\\240\\005X\\027J\\264`\\023&\\211\\021\\015kSR\\332\\222\\034\\211-gu\\346T\\377\\304\\232\\262<\\320\\003\\300\\302@\\234\\034j\\336\\237\\021\\027\\2209\\325\\323]\\367F*\\234\\302\\344\\236\\366\\374^8\\243\\305\\304\\204\\315`\\006\\352k\\200\\013>f\\022\\333\\356,\\277\\206\\261\\227\\002\\264\\032\\266c\\011\\350%\\345e\\221\\277ZU\\231\\026US\\205&\\371\\216yQ\\027V\\233(T%\\256}\\341T\\353)>\\343\\302\\004\\001\\244!\\026lQ`\\252\\021\\210%\\234\\242]Y\\250x\\245\\222\\343\\375\\353\\207r\\223\\032\\012\\024E\\203\\010\\250\\364a\\232\\335o\\336\\030\\324-\\377e\\230\\271"\\320\\301\\011l\\352\\026s>\\312\\003*\\210c\\011\\036\\231;\\331\\2313\\002/\\210\\301\\2242 \\202\\2539\\347\\004g\\343e\\376\\356\\320\\234\\202\\023T\\026\\000\\205i@\\012P0\\201\\376\\014\\340\\273-.J\\022c"#\\222\\024\\000O\\260\\011@\\006\\334\\363'\\011\\030v%\\02002rT\\020\\203\\031\\210\\206\\000\\023x\\201{\\344\\033\\234\\016\\304-a3\\361\\252\\177\\220\\3650\\010\\330\\340\\001\\237\\303eL|\\260:*9\\000zN\\231T\\010\\030\\214\\022+g\\317\\305\\376\\271\\200\\005.\\240\\332\\261|\\214\\000\\202\\232\\365Ml\\340\\032\\014\\266jm\\024V\\311\\223\\363b\\003\\020d\\240\\007\\036\\350\\201\\017z\\300\\350\\036<\\010\\000\\016\\023\\025\\010N\\202\\001\\016\\250d\\240$\\211\\200\\016 \\033\\023\\000\\233\\246\\215{\\012\\000\\010X\\272U\\234X\\353$\\2476\\235[\\320W\\223a\\007Ki\\265>\\353\\242<\\210\\030r\\303\\031\\225*\\341\\032bR0\\355\\234x\\2331\\254m\\000\\211L\\242\\336\\377\\026H\\315*\\311@k\\216cL\\230\\270\\373,\\\\^\\257\\216 \\354\\276\\365\\260\\330$\\3453)\\253\\375\\015k\\345L\\027d\\030W2\\213\\376\\250\\242\\0244\\315\\200u\\014\\230@\\007\\356kQMo\\272T\\327\\206\\330\\307]"\\202\\030 \\033\\230K9\\001\\353R`m\\240\\374[3\\003?\\011\\276-f\\023\\005 \\211\\307\\246\\314\\337\\336\\350-l\\227\\277|[\\360\\205\\350\\250\\000\\260\\331\\233\\250\\000\\001\\011\\250@,\\343\\005!n\\347\\262\\343\\312)\\030\\000H\\240\\200\\021\\204@k\\021\\217I2G\\360\\300\\2248 \\006\\006\\253`\\364\\234\\376r\\007\\210\\240\\340H\\257\\011e\\001p\\202=\\267V4\\360\\273!\\330\\313\\323\\270\\035"\\025\\322tg\\211\\004\\0320\\350\\023\\335l\\266\\355N\\374\\313I`\\202\\027\\000S*:\\201\\355\\007\\260\\352\\202\\251W\\345\\347\\265a;Q\\016\\304\\331vB>\\362/\\177\\211\\241\\277\\362\\025\\221\\247\\004\\333+!\\000\\323[\\002\\372\\332\\244\\200\\365$\\373\\323\\000\\356\\013{\\012\\262\\233\\212\\222O\\275z\\010`\\203\\201\\007@\\007P\\361\\273\\216\\012\\236\\357`\\277o\\360\\233\\016!J\\034*_\\020\\250\\264\\367\\255\\206\\211H\\365\\376\\025\\374\\324\\333\\0331 \\230\\000\\253O\\374\\273![\\332@\\316\\277\\012\\3647=\\363\\223\\204(e\\362j\\300\\013\\202\\256\\222\\355k\\262\\373/\\347X\\332M\\242\\2007{\\000\\302\\213g@\\353\\347\\037\\034\\243o\\365\\222;\\344W\\022\\027@W\\367\\227z0\\201\\001M\\225\\000\\361\\321\\000kt?\\330t Ze!\\2377\\200\\345A\\000\\337\\227\\022\\013\\362v'\\240+\\2551an#\\002\\337\\263\\036\\204\\023\\\\\\334\\347\\2003\\024X0\\2012\\011`\\0035\\360\\002\\020 \\201:\\203\\001uV\\0030\\240\\0034%!\\011\\220 \\037\\310"\\256W{\\312\\361{N\\3032&\\241(\\027\\200\\002\\254\\346\\000'\\220\\000\\233\\027?\\362\\341\\022\\012 J\\030\\206\\177\\233\\006[\\033\\224H \\340uo\\261}w\\341,\\022\\343\\022w\\001yF\\230\\031\\030c\\205\\375\\246\\022\\010@\\00296\\000|\\2239\\354\\302\\022"\\320'\\355w\\022\\017\\307\\030\\272\\361\\022\\016\\226A\\023\\322s\\177\\210O,1\\000C\\342c\\376+\\221\\206\\214\\221\\200)\\361\\\\.\\021\\002)\\260]\\216D\\025.T\\022\\210\\250_$\\241sY\\350\\202\\217\\242}\\342\\022\\000\\022\\200>\\0100\\035Wu\\022\\0040^\\031\\340y\\003p\\001\\351\\247\\210y\\341#0\\341\\210\\0244K\\002\\200f\\236A\\000(\\323\\207/S \\341Q\\003:\\243\\003\\222\\266\\211\\234\\330:\\367\\3254\\247T\\034\\011\\300T|\\027\\000S\\0101!p8\\206\\326%\\225\\230\\210\\034h\\032R\\021\\0038\\222\\001Q\\223\\001\\213wS\\321\\2468t6/e\\201\\001'\\267\\036$`}\\271\\003-y\\307\\022{\\230\\027D\\344\\001#\\303zC\\024I3\\330B\\242\\321/\\227\\366?#\\0267\\242\\026bEX\\215\\231a/\\020@\\003$\\320h\\321v\\000\\246\\362\\002\\031\\200A\\352\\025+\\231\\305\\210\\002pqM7\\214*\\201\\220\\001\\364;ZE\\206c\\221\\207\\361\\004\\201\\335\\006\\220\\231\\241N,\\321\\206\\034\\265\\022{G\\022\\010\\220%\\333\\223\\022y\\210\\022\\355\\230\\02704\\376J\\260\\302|G\\364/t\\270\\022\\303\\205\\022\\012@\\177\\346\\001\\222\\231\\221\\223+\\371;\\011(}\\003\\363\\022\\2757\\215\\354\\250\\205\\376\\201T2\\0316\\320\\243A\\377B\\035,\\266[\\257F\\221\\310sW\\340r+o\\262#\\204\\310\\022\\252A.\\036\\220c1\\361\\222\\213\\241\\203*\\021\\001\\214\\2466$\\020J*\\200\\202\\314sW\\022PzkX\\225V\\271\\022\\373g\\031\\024\\346B\\021g\\200)\\221\\001\\033G\\022\\254\\261\\034J\\271i\\003\\246 Ze\\226&\\361~<\\321p\\027\\340;\\016\\300\\201\\256\\230\\031\\276\\242>*A\\031\\256q\\022\\227\\250'\\2123^]U\\227,\\301Z\\224\\251\\027\\360\\365;\\346\\345\\001.\\306$%\\201p\\352\\347\\231+q\\211\\241\\211\\030\\236aEq\\3037\\030\\0008-\\021\\200y\\243=7A\\226\\214\\321{\\241YF\\035\\020\\214\\363B\\0029\\000\\000\\261\\001^$\\220\\001\\031\\340\\002\\342\\244\\025>Y\\033\\256\\011\\026\\015\\200o;\\224\\022\\275CG\\277\\305/\\366\\376\\207\\023\\274\\271\\030\\014\\370J\\240\\264\\001\\373\\205J\\015\\323\\214\\246\\021\\231\\231A\\000\\337\\365\\232-Ak\\243\\370\\227-3\\230/w\\234\\307\\302\\236\\306Q w\\231\\027\\350i\\032\\302\\301\\001%3\\001>`L\\011\\220\\002J\\267U\\351\\227\\025\\335\\311\\030\\020\\200$$\\363f\\012r\\027\\016@-\\016\\300\\223\\347\\371\\234\\345a,\\267So\\2678{F!\\237\\016\\310\\231&\\201\\001!\\220b\\337\\031v\\026z\\241\\316\\307x\\020\\243L/\\227\\240\\246\\201g)\\223\\235\\214\\261\\237\\312\\301\\210\\314\\205}\\265\\341\\242\\231!\\001\\315y\\243\\256\\3277\\254\\371\\022\\350\\322\\022\\312ua\\016\\250\\243\\214q6(\\201!\\021\\031\\0035H\\2214Z\\033tX\\000\\206h\\003#\\343\\001\\034\\300r\\263\\022\\244-q\\000]\\321\\003\\241\\004E\\\\Z\\\\cj \\312W\\227HZ\\246\\376\\021\\245j\\332\\242\\036\\332\\246V\\311\\246pZ\\036i:\\247\\231!\\247vZ%7p\\002(\\300\\247|J\\002}\\212\\002\\200\\372\\247*\\201:\\250\\202Z\\250\\210J\\250\\212z\\250\\213j\\250\\216\\232\\250\\214\\372\\247~\\372\\250\\215\\012\\251\\224\\312\\250\\230z\\251\\232\\012\\251'P\\003\\001\\001\\000\\000;	\N	t	Y	opuscollege	2011-02-23 16:36:39.568268
7	StudentCard	studentCardBackgroundImage	image/gif	GIF89a\\212\\000\\211\\000\\367\\000\\000\\21411\\21499\\224BB\\224JB\\224JJ\\224JR\\234JJ\\234RJ\\234RR\\234ZR\\234ZZ\\245ZZ\\245cZ\\245cc\\245kk\\255kk\\255sk\\255ss\\255{s\\255{{\\265{s\\265{{\\265\\204{\\265\\204\\204\\265\\214\\204\\265\\214\\214\\275\\204\\204\\275\\214\\204\\275\\214\\214\\275\\224\\214\\275\\224\\224\\306\\224\\224\\306\\234\\224\\306\\234\\234\\306\\245\\234\\306\\245\\245\\306\\255\\255\\316\\245\\245\\316\\255\\245\\316\\255\\255\\316\\265\\255\\316\\265\\265\\316\\275\\275\\326\\255\\255\\326\\265\\255\\326\\265\\265\\326\\275\\265\\326\\275\\275\\326\\306\\275\\326\\306\\306\\336\\275\\275\\336\\306\\306\\336\\316\\306\\336\\316\\316\\336\\326\\326\\347\\316\\316\\347\\326\\316\\347\\326\\326\\347\\336\\336\\357\\326\\326\\357\\336\\336\\357\\347\\347\\357\\357\\357\\367\\347\\347\\367\\357\\347\\367\\357\\357\\367\\367\\367\\377\\367\\367\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377!\\371\\004\\001\\000\\000\\000\\000,\\000\\000\\000\\000\\212\\000\\211\\000\\000\\010\\376\\000OX\\250p\\241\\302\\300\\202\\007\\015\\022T\\210pa\\302\\207\\016#6\\234\\310\\260"D\\212\\027-J\\324\\210qc\\306\\217\\033O\\\\\\000@\\262\\244\\311\\223(S\\252\\\\\\311\\262\\245\\313\\2270c\\312\\034(\\263\\246\\315\\2338s\\352,9\\301\\302\\316\\237-\\003\\014\\000J\\024(\\315\\242:\\0074h\\200\\301\\203\\007\\022\\036Dxp\\200\\264\\252\\315\\236VkNH\\001\\303\\303\\322\\006$a\\220\\034\\340!\\253Y\\227G\\317\\216\\255\\201\\301\\244\\203\\021) \\250<\\001V\\300\\010\\265xQb\\315+"\\300\\205\\0241H\\330\\2500t\\245W\\000\\001N\\344]L2\\355Y\\262'U\\264L \\031\\000\\006\\004\\214\\027\\357}L"@\\344\\226*<\\003\\030!:\\263Z\\307U\\003\\210\\030A\\000e\\345\\225"&4~a\\032\\357\\346\\252\\011H\\264N\\371z\\245b\\2221b\\210p\\260\\033e\\000\\022}k\\333DM\\224\\300]\\343\\023Ftp\\231`\\344a\\000\\0128\\214\\030iR\\000\\011\\001\\003B\\376\\\\(\\255\\334\\345m\\242\\003z\\227\\034\\020#AL\\335!P\\3068\\251\\243\\270\\003\\032!\\234\\026\\036[\\274<\\000\\346?\\221\\226R\\010\\375\\271\\324\\200\\016\\002\\240\\204\\301\\010P\\265\\326\\003J\\022\\214\\320\\000\\011.x\\220\\001\\011)\\254f\\241\\007\\356\\325v\\036P4\\244\\224\\202\\0046\\221\\300R\\0025x\\200\\003J\\011\\224\\205\\330W$\\021\\260Tn\\312\\001\\250\\223\\003m\\231\\224[\\20259 \\333M-\\272d\\242\\207>\\025\\025@\\012\\2105E\\341x7]gS\\220+\\231h\\001X\\246\\331x\\223\\0036$\\350A\\005\\005\\332\\344dMP\\252\\344C\\005K\\021I\\324\\004\\036\\360\\250\\036Na\\202\\351\\242J$\\234\\260A\\207\\231Y\\031S\\003\\303\\2314\\037P\\031\\260\\371fJ\\021\\306g\\246N\\007\\202\\220\\037\\010\\036\\214\\360gNS\\371\\331\\022\\011t\\326YAN\\252-\\372_\\015T\\351\\324\\246\\233.\\235@\\236fE\\336\\024\\003f\\000\\250\\220\\002\\206\\247\\002\\200\\246N\\226\\312\\264iJ\\376\\011<')N\\023P9\\200\\254:v\\206\\023\\2079\\275:`\\227j}\\010\\023\\012%A\\360\\243IN\\215PC\\2441\\035\\327k\\253(\\335Z\\345\\2446a\\020AI"tY\\331\\221T\\326\\004\\001\\264\\324\\201\\033\\331\\247\\301\\206\\032\\223\\002\\334)U\\003o&up\\254L\\030\\364y\\022\\263\\260\\212k\\022\\003\\366"egJ\\003 I\\022\\011\\015\\320\\013\\300\\242\\023\\344XS\\234$\\014\\345\\000\\0125\\244\\000lI\\276\\252\\344/\\2502\\035'\\232j\\206\\241\\344@\\276&m\\245\\000b#\\314\\000A\\003\\036\\0040\\202\\010+E\\234\\322\\204\\214\\355{\\222\\010tB\\220iJ\\2552\\020\\232y1tk\\022\\004\\244*\\020\\203\\\\,\\352\\240\\302\\320D\\027=4\\014G\\317\\200\\353Y\\302\\252\\244@\\303\\035d\\360\\024K\\320\\036\\267\\037\\213$P\\233\\322\\310\\310\\352\\360\\251\\312*9\\300\\335iZ\\273\\204\\301\\330B\\256\\024@\\007\\327\\236\\204\\347\\004\\344\\232\\024\\000m:r \\002\\217\\000\\200\\255\\022\\376\\312\\266\\231\\033T\\3160\\211\\305\\322\\306\\317Q\\366.K7\\237drg\\015\\344g\\223\\240d\\3134\\261Kk\\246$\\302\\204%\\307\\364\\245I\\003\\274P\\303\\005\\017\\263\\264tVM\\303\\031S\\345(5@C\\350*m\\3762N\\016\\314l\\226\\313&\\011\\376\\022\\352'Mp\\370K#\\\\\\215\\022\\307{\\313kV\\351\\226\\307d;K\\272\\3264\\372I\\300\\253\\324\\203\\316U\\321^\\322\\2720\\341n\\022\\3372\\255J5N\\307=\\340\\351\\360~\\263\\204\\246\\010)\\340\\275R\\342+a\\000\\275\\331\\311g|S\\255\\000\\220<{\\331-\\245\\010\\000\\001*\\254\\177\\322\\267'6OR\\343/\\361_\\273D3$\\253\\020\\017Y:3Q\\0022\\300\\024\\025\\234\\300)\\036\\000\\001TT\\022\\000\\025\\204 n+\\351\\234K\\006\\200\\002\\001\\226\\244\\200\\030\\020\\330Oh'-da\\200.\\030x\\300KdD\\202\\366\\305\\244wf\\323\\037Ld\\225\\036R!\\345\\200$9\\233\\002\\022\\340\\200\\302\\330\\000\\203\\376,\\362\\300\\005\\000\\226\\022\\326!&\\006\\276C\\011\\001\\012\\370\\244\\361\\\\N\\001\\001\\260\\200\\360\\210B\\273\\000\\304\\300\\003'\\240\\001\\017\\022\\264'\\363`/[r\\353\\240\\211\\212\\303A\\0258\\005\\005\\030\\250\\201\\371\\214C,\\234(\\300\\006.PT\\007f\\240\\000\\004\\264\\361L\\341\\233\\313\\011$\\024\\202\\004Y\\217$\\023 \\301\\273\\254\\270\\037\\011\\015\\014?6H\\324\\315\\226\\342\\231\\027\\320-l\\006\\253\\211\\311\\024P\\201\\266\\005`Yv,\\012\\355\\016\\224\\202\\021|\\300\\006#\\350`K\\234";\\222\\004\\000\\005\\236aJ\\352\\004V\\241\\335\\225\\004\\003\\364\\213I\\012\\350\\225\\230\\012L\\340\\216;\\301!IT\\260\\033$9'\\004\\015\\210\\001\\015>5\\002\\021\\336\\357\\005"\\230\\201L p\\001\\310\\031\\347\\004m\\223\\011d\\346\\362\\202b\\016n\\212+\\221\\336\\255h\\360\\271\\365\\214\\347K\\023@\\233q\\312\\347\\277\\021@\\200\\211)\\241\\236L\\300\\250\\222\\001\\330 \\004\\313\\213\\237\\012\\316\\026I\\225\\350\\262$\\223\\376\\223\\333\\010\\216\\365\\232X%+\\224{\\364L\\027\\315\\326'\\023\\264\\004\\2115\\301\\236J\\030\\020\\202\\027\\224f\\000\\0230\\225\\004Z#\\277\\226H\\017\\220\\006\\255\\340,M\\342\\002\\251\\271 \\007\\242)S\\336\\254E\\252\\000\\270\\000&\\325\\011@\\003~\\343\\264=\\326$_\\027\\350\\300\\025=p\\252\\012\\220\\247\\001\\256\\314]\\036\\007\\027\\003\\023\\020`n\\257\\024\\217g\\022p\\202Y\\212\\264\\001\\027\\370\\200h^`DS\\306\\200\\000/p]I\\032p\\027\\377\\341\\310%&\\223!I`\\206\\226X\\032(G\\272#\\311\\005\\350\\245\\202\\250\\222$\\001\\356\\372X\\012_\\022\\200\\325\\001`\\003U;g\\202\\222\\303\\326\\024\\0001w(x\\200\\300\\376\\010\\310\\235\\262\\344\\002\\014\\000\\200]J\\320\\247F\\215\\223$\\002`[`\\363\\271\\222\\261\\2762\\232\\210\\021A\\0152\\0004\\301v\\322\\206*!\\000\\0120\\213U\\011H\\215\\004\\0168@\\2148vQ\\210\\311&\\006\\236\\361@\\004\\030K\\222a\\222D\\001^\\231\\376\\024_I\\362\\247\\212\\002\\300\\0015\\300\\240\\311ZB\\000\\030\\304\\363%'$\\011\\012\\232\\252*\\277"/\\002.\\032\\300jSr\\312\\222(\\000\\004\\015\\220\\013:\\243\\0250g\\242\\300\\001\\031x\\240\\005X\\027J\\264`\\023&\\211\\021\\015kSR\\332\\222\\034\\211-gu\\346T\\377\\304\\232\\262<\\320\\003\\300\\302@\\234\\034j\\336\\237\\021\\027\\2209\\325\\323]\\367F*\\234\\302\\344\\236\\366\\374^8\\243\\305\\304\\204\\315`\\006\\352k\\200\\013>f\\022\\333\\356,\\277\\206\\261\\227\\002\\264\\032\\266c\\011\\350%\\345e\\221\\277ZU\\231\\026US\\205&\\371\\216yQ\\027V\\233(T%\\256}\\341T\\353)>\\343\\302\\004\\001\\244!\\026lQ`\\252\\021\\210%\\234\\242]Y\\250x\\245\\222\\343\\375\\353\\207r\\223\\032\\012\\024E\\203\\010\\250\\364a\\232\\335o\\336\\030\\324-\\377e\\230\\271"\\320\\301\\011l\\352\\026s>\\312\\003*\\210c\\011\\036\\231;\\331\\2313\\002/\\210\\301\\2242 \\202\\2539\\347\\004g\\343e\\376\\356\\320\\234\\202\\023T\\026\\000\\205i@\\012P0\\201\\376\\014\\340\\273-.J\\022c"#\\222\\024\\000O\\260\\011@\\006\\334\\363'\\011\\030v%\\02002rT\\020\\203\\031\\210\\206\\000\\023x\\201{\\344\\033\\234\\016\\304-a3\\361\\252\\177\\220\\3650\\010\\330\\340\\001\\237\\303eL|\\260:*9\\000zN\\231T\\010\\030\\214\\022+g\\317\\305\\376\\271\\200\\005.\\240\\332\\261|\\214\\000\\202\\232\\365Ml\\340\\032\\014\\266jm\\024V\\311\\223\\363b\\003\\020d\\240\\007\\036\\350\\201\\017z\\300\\350\\036<\\010\\000\\016\\023\\025\\010N\\202\\001\\016\\250d\\240$\\211\\200\\016 \\033\\023\\000\\233\\246\\215{\\012\\000\\010X\\272U\\234X\\353$\\2476\\235[\\320W\\223a\\007Ki\\265>\\353\\242<\\210\\030r\\303\\031\\225*\\341\\032bR0\\355\\234x\\2331\\254m\\000\\211L\\242\\336\\377\\026H\\315*\\311@k\\216cL\\230\\270\\373,\\\\^\\257\\216 \\354\\276\\365\\260\\330$\\3453)\\253\\375\\015k\\345L\\027d\\030W2\\213\\376\\250\\242\\0244\\315\\200u\\014\\230@\\007\\356kQMo\\272T\\327\\206\\330\\307]"\\202\\030 \\033\\230K9\\001\\353R`m\\240\\374[3\\003?\\011\\276-f\\023\\005 \\211\\307\\246\\314\\337\\336\\350-l\\227\\277|[\\360\\205\\350\\250\\000\\260\\331\\233\\250\\000\\001\\011\\250@,\\343\\005!n\\347\\262\\343\\312)\\030\\000H\\240\\200\\021\\204@k\\021\\217I2G\\360\\300\\2248 \\006\\006\\253`\\364\\234\\376r\\007\\210\\240\\340H\\257\\011e\\001p\\202=\\267V4\\360\\273!\\330\\313\\323\\270\\035"\\025\\322tg\\211\\004\\0320\\350\\023\\335l\\266\\355N\\374\\313I`\\202\\027\\000S*:\\201\\355\\007\\260\\352\\202\\251W\\345\\347\\265a;Q\\016\\304\\331vB>\\362/\\177\\211\\241\\277\\362\\025\\221\\247\\004\\333+!\\000\\323[\\002\\372\\332\\244\\200\\365$\\373\\323\\000\\356\\013{\\012\\262\\233\\212\\222O\\275z\\010`\\203\\201\\007@\\007P\\361\\273\\216\\012\\236\\357`\\277o\\360\\233\\016!J\\034*_\\020\\250\\264\\367\\255\\206\\211H\\365\\376\\025\\374\\324\\333\\0331 \\230\\000\\253O\\374\\273![\\332@\\316\\277\\012\\3647=\\363\\223\\204(e\\362j\\300\\013\\202\\256\\222\\355k\\262\\373/\\347X\\332M\\242\\2007{\\000\\302\\213g@\\353\\347\\037\\034\\243o\\365\\222;\\344W\\022\\027@W\\367\\227z0\\201\\001M\\225\\000\\361\\321\\000kt?\\330t Ze!\\2377\\200\\345A\\000\\337\\227\\022\\013\\362v'\\240+\\2551an#\\002\\337\\263\\036\\204\\023\\\\\\334\\347\\2003\\024X0\\2012\\011`\\0035\\360\\002\\020 \\201:\\203\\001uV\\0030\\240\\0034%!\\011\\220 \\037\\310"\\256W{\\312\\361{N\\3032&\\241(\\027\\200\\002\\254\\346\\000'\\220\\000\\233\\027?\\362\\341\\022\\012 J\\030\\206\\177\\233\\006[\\033\\224H \\340uo\\261}w\\341,\\022\\343\\022w\\001yF\\230\\031\\030c\\205\\375\\246\\022\\010@\\00296\\000|\\2239\\354\\302\\022"\\320'\\355w\\022\\017\\307\\030\\272\\361\\022\\016\\226A\\023\\322s\\177\\210O,1\\000C\\342c\\376+\\221\\206\\214\\221\\200)\\361\\\\.\\021\\002)\\260]\\216D\\025.T\\022\\210\\250_$\\241sY\\350\\202\\217\\242}\\342\\022\\000\\022\\200>\\0100\\035Wu\\022\\0040^\\031\\340y\\003p\\001\\351\\247\\210y\\341#0\\341\\210\\0244K\\002\\200f\\236A\\000(\\323\\207/S \\341Q\\003:\\243\\003\\222\\266\\211\\234\\330:\\367\\3254\\247T\\034\\011\\300T|\\027\\000S\\0101!p8\\206\\326%\\225\\230\\210\\034h\\032R\\021\\0038\\222\\001Q\\223\\001\\213wS\\321\\2468t6/e\\201\\001'\\267\\036$`}\\271\\003-y\\307\\022{\\230\\027D\\344\\001#\\303zC\\024I3\\330B\\242\\321/\\227\\366?#\\0267\\242\\026bEX\\215\\231a/\\020@\\003$\\320h\\321v\\000\\246\\362\\002\\031\\200A\\352\\025+\\231\\305\\210\\002pqM7\\214*\\201\\220\\001\\364;ZE\\206c\\221\\207\\361\\004\\201\\335\\006\\220\\231\\241N,\\321\\206\\034\\265\\022{G\\022\\010\\220%\\333\\223\\022y\\210\\022\\355\\230\\02704\\376J\\260\\302|G\\364/t\\270\\022\\303\\205\\022\\012@\\177\\346\\001\\222\\231\\221\\223+\\371;\\011(}\\003\\363\\022\\2757\\215\\354\\250\\205\\376\\201T2\\0316\\320\\243A\\377B\\035,\\266[\\257F\\221\\310sW\\340r+o\\262#\\204\\310\\022\\252A.\\036\\220c1\\361\\222\\213\\241\\203*\\021\\001\\214\\2466$\\020J*\\200\\202\\314sW\\022PzkX\\225V\\271\\022\\373g\\031\\024\\346B\\021g\\200)\\221\\001\\033G\\022\\254\\261\\034J\\271i\\003\\246 Ze\\226&\\361~<\\321p\\027\\340;\\016\\300\\201\\256\\230\\031\\276\\242>*A\\031\\256q\\022\\227\\250'\\2123^]U\\227,\\301Z\\224\\251\\027\\360\\365;\\346\\345\\001.\\306$%\\201p\\352\\347\\231+q\\211\\241\\211\\030\\236aEq\\3037\\030\\0008-\\021\\200y\\243=7A\\226\\214\\321{\\241YF\\035\\020\\214\\363B\\0029\\000\\000\\261\\001^$\\220\\001\\031\\340\\002\\342\\244\\025>Y\\033\\256\\011\\026\\015\\200o;\\224\\022\\275CG\\277\\305/\\366\\376\\207\\023\\274\\271\\030\\014\\370J\\240\\264\\001\\373\\205J\\015\\323\\214\\246\\021\\231\\231A\\000\\337\\365\\232-Ak\\243\\370\\227-3\\230/w\\234\\307\\302\\236\\306Q w\\231\\027\\350i\\032\\302\\301\\001%3\\001>`L\\011\\220\\002J\\267U\\351\\227\\025\\335\\311\\030\\020\\200$$\\363f\\012r\\027\\016@-\\016\\300\\223\\347\\371\\234\\345a,\\267So\\2678{F!\\237\\016\\310\\231&\\201\\001!\\220b\\337\\031v\\026z\\241\\316\\307x\\020\\243L/\\227\\240\\246\\201g)\\223\\235\\214\\261\\237\\312\\301\\210\\314\\205}\\265\\341\\242\\231!\\001\\315y\\243\\256\\3277\\254\\371\\022\\350\\322\\022\\312ua\\016\\250\\243\\214q6(\\201!\\021\\031\\0035H\\2214Z\\033tX\\000\\206h\\003#\\343\\001\\034\\300r\\263\\022\\244-q\\000]\\321\\003\\241\\004E\\\\Z\\\\cj \\312W\\227HZ\\246\\376\\021\\245j\\332\\242\\036\\332\\246V\\311\\246pZ\\036i:\\247\\231!\\247vZ%7p\\002(\\300\\247|J\\002}\\212\\002\\200\\372\\247*\\201:\\250\\202Z\\250\\210J\\250\\212z\\250\\213j\\250\\216\\232\\250\\214\\372\\247~\\372\\250\\215\\012\\251\\224\\312\\250\\230z\\251\\232\\012\\251'P\\003\\001\\001\\000\\000;	\N	t	Y	opuscollege	2011-02-23 16:35:46.993779
10	StudentCard	reportLogo	image/gif	GIF89a\\265\\0001\\000\\367\\000\\000\\000\\000\\010\\010\\030)!Jk1k\\245B\\204\\306J\\214\\316cccckkc\\234\\316kssss{s{\\204s\\214\\245s\\245\\326{\\214\\245\\204\\255\\336\\224\\265\\336\\234\\275\\336\\234\\275\\347\\245\\245\\245\\245\\306\\347\\255\\275\\306\\265\\316\\347\\275\\326\\357\\306\\336\\367\\316\\336\\357\\326\\347\\377\\336\\357\\357\\336\\357\\367\\347\\357\\377\\357\\367\\377\\367\\367\\377\\367\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377\\377,\\000\\000\\000\\000\\265\\0001\\000\\000\\010\\376\\000'0`\\340``A\\202\\006\\023"\\\\x\\260\\241B\\207\\014\\037J\\214H\\021\\242\\305\\211\\027+b\\334\\250\\261c\\306\\217\\034\\017V8 \\240\\244\\311\\223(S\\252\\\\\\311\\262\\245\\313\\2270c\\312\\234I\\263\\346J\\007$m\\352\\334\\311\\263\\247\\317\\237>q\\002\\035J\\264\\250\\321\\2437s"]\\312\\264\\251S\\225B\\237\\012\\030 \\265\\252U\\236Q\\221R5I\\301\\344\\200\\255W\\303\\212M\\351@\\001S\\002\\017L6\\330:\\240\\301\\330\\267o\\3136\\245\\300\\326\\355T\\273\\002\\322\\302\\335\\353Tn\\321\\002\\005NZ\\340Z\\262ma\\0045\\021X\\350`\\001\\002\\330\\007\\026"[h\\020\\330d\\344\\312%/{\\205`\\341\\203f\\276=\\375\\022\\035\\240\\001s\\001\\273\\017\\266\\332E\\000\\026lK\\014\\037<\\310\\376\\300a\\253\\005\\017\\261sg\\330\\372\\341\\003^\\001\\261Q\\367\\226\\215{0h\\254f\\217f\\300l\\201\\352\\000\\304\\002P\\233$\\340z%\\204\\330\\251\\033l\\370\\220!\\263\\207\\013\\003\\010\\376@\\300\\335\\035\\270\\207\\337\\301\\247\\306\\276@\\375\\371\\357\\3435E\\033\\305\\000\\241pW\\001\\365\\243\\227\\324;\\0003\\313\\001\\351\\225T@l\\201\\335f\\\\t\\270Q\\025`I\\351\\015\\350Au\\360\\355$\\237Q\\020\\344\\207@`\\371\\271\\365UI\\357\\255\\204@\\202'a'\\200\\201^\\305\\246\\340y!\\242H@l\\371E\\030ZrKUXRW\\033R\\005]\\001\\255\\261\\324@l(e\\340\\331\\210\\036\\034\\350\\340\\211\\350\\241(\\300v\\036l\\340\\230\\213\\022\\302\\270T\\001\\030L\\005\\341T\\004\\0246\\245I\\343y\\200\\022\\211$N\\325\\201\\007\\345-h\\236]\\003p\\020[qW2\\331\\322\\204H\\025\\320\\342\\177i\\356\\307\\243`A\\002\\211\\333\\235\\033\\360f$\\203{\\012P@\\006\\304\\325\\246\\346Ll\\216\\265\\241K\\015\\340\\206\\322\\227\\021\\330yf\\004`\\211)fa\\200\\3726\\250L\\205\\356\\365\\325\\224\\016VYXl\\210u\\231\\222\\217z\\361\\331\\241z}^\\272\\246\\223|\\035\\312Rl\\376\\345\\011\\020\\201\\211@\\036\\210\\222\\004\\334\\225\\370\\240\\224'}\\350\\001t\\252\\272\\224\\351\\245\\211z\\300\\201\\005>\\032)*J\\016f\\320\\300\\003_\\032\\267c\\006\\221a\\200\\333\\006\\301\\3024\\354\\245\\017\\344&[\\251\\313\\242\\364\\300\\235\\262\\035\\230\\350\\231\\260\\306\\231mI\\333^\\352\\036\\216'm\\332R\\177\\015\\254\\205\\022\\275\\015\\260\\266\\256\\266\\013\\034\\245\\356I\\247\\325+\\260\\300\\376\\251I@\\275T\\035lo\\204\\016$0\\324s\\024X\\032Sg\\275U\\\\\\261\\255j6\\020B\\010Uj\\314\\261\\213\\015\\367\\324\\037\\004\\035p\\007\\033\\306-\\225|go\\031P@Y\\260\\032\\177\\320q\\0102\\203\\314\\252Lhi\\300\\335\\003U\\016@\\361\\277\\002\\2548\\034\\010\\261a\\260\\260\\252\\036w\\374\\301\\307\\014;,S['\\037\\375\\347p\\037\\334\\347\\022l\\270\\345\\246\\265\\247\\304\\322<s\\315M\\307D\\201\\006\\223U75\\007\\017 \\220[\\301)]74\\213\\317\\242\\314d\\322\\321m\\314\\365q\\355Z\\251\\022\\376\\002:s\\340V\\001fV\\014l\\333og\\275\\301\\251M\\015p\\201\\005\\213/~\\037\\001\\214G~\\001]u\\327\\274#\\323\\024H\\316\\370V\\220_@Y\\004\\214\\013\\330x\\344\\245\\352\\024\\262M\\015\\230\\271\\\\I\\327q\\240v\\326\\026\\334\\355\\247\\316Z\\307F\\364\\265@\\017u\\301\\306\\033/\\035\\202[\\026\\360\\356\\373\\357u\\177\\034\\363\\314\\302o<\\330\\000\\2747\\037BI\\316\\373.;M\\247\\317\\324@\\311\\030T6\\300\\311\\003\\214G5\\313\\213Y\\214\\033\\010Y\\357\\346\\246\\334L\\005\\3171\\001j\\023\\257>\\001\\354/\\355\\326\\361\\305+\\035\\002\\002\\360/=\\030\\0014Sp\\360\\0064\\203\\036w\\340\\007\\001\\257!\\347ink\\316t\\314\\3647\\356\\334\\346v\\342{[n\\310\\267\\201\\351=E}%Y\\221\\3736\\226A\\371U\\316~_\\363\\224\\362\\202\\2661\\273`P\\000#\\254\\037V\\234\\006\\223\\001-\\311$\\335\\332\\215z\\362\\224\\001\\242\\331Nk\\036\\200\\340\\007@\\320\\234J\\261\\315)\\376\\273\\373\\200JN\\250\\301\\371\\331\\355\\203\\225\\213@\\275\\364\\0274\\017\\216\\210\\203(\\374\\300\\341\\032\\020<\\260\\231\\216\\2050q\\315\\366>\\220\\2372\\325f\\000<\\274\\015\\325t\\010+\\026\\371\\011}M9\\341\\226\\240\\310?\\342]\\016y\\310\\033\\236\\245\\370'\\261\\023\\366\\356\\216y:\\240M\\006\\320\\001\\016p\\0156T\\351\\214\\342\\252\\226\\265B\\326\\360\\003\\010\\370\\020\\027\\337\\242F\\370\\005\\222\\215\\036\\244\\337\\033\\243\\263\\264\\351\\02513P\\244\\031\\032mR=\\232P\\361$\\021\\013\\014\\200\\006\\323\\0330\\372\\346\\003\\223\\343\\342\\207\\362D\\200\\015\\010J,A\\314 \\315\\200\\307\\306Y\\252P\\222\\006\\034\\221\\005\\322BG\\023f2\\004\\306)@drw\\023,\\356dG\\225\\271\\316Wx\\010\\240\\007\\201 O<\\212\\330\\362\\210i\\024\\365\\325kV\\033\\374]\\003\\012\\350\\306J"\\321c\\020\\250\\327\\010\\333\\350,\\355,M\\200S|\\237\\036{"\\243\\251\\360\\260\\211k\\331!p>\\320=K\\371\\310\\202V\\354\\241\\300\\035{\\207\\030}\\312\\361~\\337<b\\373\\366y\\037\\037\\355\\363y\\002\\350\\300>\\227FM\\262\\030\\323'\\003\\242\\312\\216\\252\\224+A\\202\\261;\\256\\202\\313\\300\\352\\005\\235\\266l\\024:\\012KX\\276\\266\\202\\200\\215\\376\\246\\244\\365\\332\\016B=:0|bJ)\\017\\233\\221\\020\\2013\\230\\035\\271\\245B\\015\\335\\327K\\352U\\0315\\032%+\\376\\312LZ\\006\\3003\\235"\\205f\\214Y\\014\\024\\217\\002T\\243:\\265G\\321\\213\\325Oa\\372\\324\\252f\\020~XeJS\\255\\312\\325\\247l\\265\\253`E\\312W\\303J\\326\\2418\\300\\000\\000Hk\\000\\326\\312\\326\\266\\272\\365\\255p\\215\\253\\\\\\347J\\327\\272\\332\\365\\256x\\315\\253^\\367\\312\\326\\264\\036\\240\\217\\034\\010,\\007\\000;X\\301\\022\\366\\260\\206Ml`\\021\\273X\\305\\026\\266\\261\\220}\\254d\\031;Y\\307R\\366\\262\\226\\315ld1+\\330\\316nV\\263\\225\\215\\254a\\003\\002\\000;	\N	t	Y	opuscollege	2011-07-25 10:59:14.521142
11	StudentProfile	reportLogo	image/gif	GIF89a\\007\\002^\\000\\367\\000\\000!Jk!Js!Rs)Rs!R{)R{)Z{1Z{9Z{9c{!R\\204)R\\204)Z\\2041Z\\2041c\\2049Z\\2049c\\204Bc\\204Bk\\204Jk\\204)Z\\214)c\\2141c\\2149c\\2149k\\214Bc\\214Bk\\214Jk\\214Js\\214Rs\\214)Z\\224)c\\2241c\\2241k\\2249k\\224Bk\\224Bs\\224Jk\\224Js\\224Rs\\224R{\\224Z{\\224)c\\234)k\\2341c\\2341k\\2349k\\2349s\\234Bs\\234Js\\234Rs\\234R{\\234Z{\\234Z\\204\\234k\\204\\2341k\\2451s\\2459k\\2459s\\245Bs\\245B{\\245Js\\245J{\\245R{\\2451k\\2551s\\2551s\\2659s\\2559s\\2659{\\2659{\\2759{\\306Bs\\255B{\\255B{\\265B{\\275B\\204\\265B\\204\\275B\\204\\306B\\204\\316B\\214\\316J{\\255J{\\265J\\204\\255J\\204\\265J\\204\\275J\\204\\306J\\214\\275J\\214\\306J\\214\\316R{\\255R\\204\\255R\\204\\265R\\204\\275R\\214\\265R\\214\\275Z\\204\\245^\\204\\251Z\\204\\265Z\\214\\265c\\210\\251g\\214\\251k\\214\\255c\\214\\265c\\224\\265k\\214\\265k\\224\\265Z\\214\\275Z\\224\\275c\\214\\275c\\224\\275k\\224\\275R\\214\\306Z\\214\\306Z\\224\\306c\\224\\306k\\224\\306k\\234\\306R\\214\\316R\\224\\316Z\\224\\316c\\224\\316c\\234\\316k\\234\\316R\\224\\326Z\\224\\326Z\\234\\326c\\234\\326s\\214\\245{\\224\\245s\\224\\255s\\224\\265{\\234\\265s\\224\\275s\\234\\275{\\234\\275s\\234\\306s\\234\\316s\\245\\306s\\245\\316\\177\\240\\275\\204\\245\\275{\\234\\306{\\245\\312\\204\\245\\306\\204\\245\\316\\204\\255\\316\\214\\234\\265\\214\\245\\265\\214\\245\\275\\214\\245\\306\\214\\255\\306\\214\\255\\316\\224\\245\\275\\224\\255\\275\\224\\255\\306\\234\\255\\306\\234\\265\\306\\245\\265\\306\\255\\275\\306k\\234\\326k\\245\\326k\\245\\336s\\245\\326s\\245\\336{\\245\\326{\\245\\336{\\255\\326{\\255\\336\\204\\251\\326\\204\\255\\336\\204\\265\\336\\214\\255\\326\\214\\261\\332\\214\\265\\336\\214\\265\\347\\224\\261\\316\\214\\275\\336\\231\\265\\323\\234\\275\\322\\214\\275\\347\\224\\265\\336\\224\\271\\342\\230\\275\\342\\250\\277\\324\\251\\306\\336\\237\\300\\347\\245\\306\\347\\242\\310\\354\\245\\316\\357\\255\\306\\347\\255\\306\\357\\255\\316\\347\\255\\316\\357\\265\\306\\326\\265\\306\\336\\265\\306\\347\\265\\316\\336\\265\\316\\347\\265\\326\\347\\275\\306\\326\\275\\316\\336\\306\\316\\336\\275\\316\\347\\275\\326\\336\\301\\322\\347\\306\\326\\347\\313\\330\\344\\316\\336\\347\\265\\316\\357\\265\\326\\357\\275\\316\\357\\275\\326\\357\\306\\326\\357\\306\\336\\357\\316\\326\\357\\316\\336\\357\\316\\347\\357\\265\\326\\367\\275\\326\\367\\306\\326\\367\\306\\336\\367\\316\\336\\367\\316\\336\\377\\316\\347\\367\\316\\347\\377\\326\\336\\347\\326\\336\\357\\326\\336\\367\\326\\347\\357\\326\\347\\367\\326\\347\\377\\326\\357\\357\\326\\357\\367\\336\\336\\357\\336\\347\\357\\336\\347\\367\\336\\347\\377\\336\\357\\357\\336\\357\\367\\336\\357\\377\\336\\367\\367\\347\\347\\357\\347\\347\\367\\347\\357\\357\\347\\357\\367\\347\\357\\377\\347\\367\\367\\347\\367\\377\\357\\357\\377\\357\\367\\367\\357\\367\\377\\357\\377\\377\\367\\367\\377\\367\\377\\377\\377\\377\\377,\\000\\000\\000\\000\\007\\002^\\000\\000\\010\\376\\000?\\001\\032H\\260\\240\\301\\203\\010\\023*\\\\\\310\\260!\\302I\\236<}\\222\\0301\\342\\304\\212\\024/Z\\244\\270QcF\\214\\036?V\\0149\\321cI\\220\\030EnDi\\222\\343\\312\\221.c\\252Ty\\022fK\\2268;\\346|\\251\\023\\346\\316\\231$c\\006m\\251\\261fO\\236@]\\032M\\372\\323\\350\\322\\247)\\2416\\025\\212q\\222\\303\\253X\\263\\016\\024\\010\\240\\253\\327\\257`\\303\\212\\035K\\266\\254\\331\\263b\\007$@\\300\\226\\355\\332\\266k\\337\\302m;\\227\\256\\334\\272n\\021\\334\\325k\\227o_\\272~\\363\\356\\275\\033\\027\\360\\336\\300|\\007\\367Ul\\270\\261c\\301\\217\\361\\346\\215\\\\\\370/d\\313\\222+gF\\314\\231\\363a\\302\\236\\001\\207\\246<\\032sg\\320\\214/K\\236<y\\000\\332\\327\\260cw\\035(\\273\\266\\355\\333\\270s\\353\\336\\315\\273\\267\\357\\337\\300\\203\\013\\037N\\274\\270q\\335\\264\\217+_\\316\\274\\271\\363\\347\\320\\243K\\237N\\275v\\362\\352\\330\\263k\\337\\316\\275\\273\\367\\357\\324\\257\\376\\203\\037O\\276\\274\\371\\363\\350\\323\\007\\027\\257\\276\\275\\373\\367\\360\\343\\313W\\316~\\276\\375\\373\\370\\363\\353W_\\177\\277\\377\\377\\000\\006(\\340o\\375\\015h\\340\\201\\010&\\370_\\201\\012nW\\300\\012,4(\\341\\204\\0232H!u\\005\\334\\240\\302\\205\\034v\\270  \\036:'\\000\\010\\024\\214\\245A*\\210\\204\\305\\300\\007\\037\\220\\030\\342\\2130\\202ga\\214\\276e\\270\\241X'\\354\\322JX\\024\\334\\340c\\2044\\006)dt3\\016\\231\\033\\003E(\\361\\303\\017a\\221\\340\\312#\\024\\224\\350U\\217H|\\021\\205\\221XfI\\\\\\221Z\\312\\306\\200\\023X\\250\\242\\212k_i0\\212\\036>~\\325#\\025\\243\\314\\321\\345\\233p\\342\\306e\\234g\\031\\220\\203\\022\\256\\270\\302@\\001\\001xe\\201\\034qH\\241\\204\\2327\\260\\351&X\\007\\214p\\000\\235\\2146:g\\243e\\035\\260\\313.C\\334@\\200W\\031\\0161\\312(\\002Ly\\203\\024m\\206\\025\\206*b@jj\\227\\2172Z\\200\\000\\005\\220\\371\\325\\001\\376\\262\\264\\022E\\022\\005`\\252\\202\\016\\245\\234B\\250\\241`\\005 \\206*a07@\\001\\007\\034\\300\\227\\261\\006\\034\\020@\\237a\\035@\\254\\261\\305"P\\254\\263\\006\\014KV\\264\\007T\\313lX\\003@\\353l\\247a\\005 \\300\\264\\007$\\020\\201\\264\\320\\022\\340\\352\\251\\035\\246\\032\\347\\000Y\\304\\233\\005\\003c\\345b\\214\\006`!0\\251\\253k\\206\\352\\325\\0077T\\241\\207\\017\\314\\255\\241\\307-\\306Xc\\017;\\306\\030SK-HX\\012\\326\\000b\\372\\322\\360\\305\\015\\003\\263i\\274\\364\\212eo\\303\\247d\\201\\304X\\202\\\\\\274K\\274*\\336\\200\\304\\303\\015\\327\\323\\0176\\027\\353\\2022\\273\\036\\272\\013'\\274\\362v\\034\\226\\275\\033 \\272\\257\\247\\240\\036\\332\\025\\300_\\350\\301C\\301\\007\\033\\203\\215=\\346\\030C\\314\\303\\225\\326\\372\\025\\305\\252X\\214q\\303\\276ljG\\026\\025\\214\\205\\313\\305!\\017Ar\\3143\\177\\225a\\022\\017[\\3542\\314\\015\\313\\234\\005\\3155\\203\\010w\\270>r\\323M(V\\200\\020\\026\\376\\026v\\350\\261\\007\\011^\\035 \\346\\015-\\\\\\332\\325\\010\\376v\\305\\205\\036J\\334\\2407X\\037\\260\\260\\200o\\002PC\\315<\\371\\334c\\317>\\234\\333\\243O>\\371\\224S\\216\\0337\\350<\\2001\\300\\324\\203O>\\373d\\316z?\\365\\330SO>\\3204\\343H\\013\\036|\\265N>\\375\\344\\2235\\027ce\\362\\371>\\346\\214\\022\\312\\266?\\224\\262\\313<\\263\\177\\216\\017\\347\\371\\254\\256\\317<\\300\\37027\\2076\\277)\\200\\217\\335\\234CJ\\026!\\204eE\\026\\240\\214\\002C\\340\\203\\337 5\\000"\\214\\342\\306W^\\350!\\305\\015R~\\305B\\351\\276\\015`M7\\274s\\356?\\347\\375\\350\\307;\\336\\361\\006\\372y\\345t\\306\\330\\\\\\000\\375\\267\\300}\\004\\320\\034\\330x\\304\\015>\\360\\025y\\004\\260\\037\\306\\030E\\251\\304\\222\\211~p\\216\\035\\233r\\025\\030\\252vA\\017\\376\\017\\200\\371h\\330\\365.\\224\\2757\\021\\240\\000\\0348\\001,|\\261\\207$\\264\\340+\\014`\\200$rq\\206\\017\\320k\\000\\376J\\220\\002\\034\\276\\320\\000\\257\\230Ih\\000\\240C)x\\260\\252\\257\\014\\241R\\370\\333\\315\\001\\014\\341\\210\\330q\\216\\032\\272\\210D\\033\\352`\\213[\\320\\303\\035\\234[\\006.\\310p\\300\\206m\\016\\202\\262h\\303\\034\\0261\\012_\\370bs\\237sF.\\010QA\\023fm\\203a\\351\\240\\007\\213\\307)\\000\\254\\010\\023\\344`G\\353\\254\\201\\015\\343\\265\\341\\220m@\\304*Zq\\012U\\254\\220B-\\244S'\\260\\341\\212,\\210\\015,\\2270\\006\\035n\\320\\265\\000\\370H\\017z(bW\\332\\207D:\\250\\302\\004aq\\202\\023\\202p\\203\\311\\355\\006\\002\\265\\260E\\003w\\241\\2128\\334 \\011\\243(\\205;\\334\\021\\300r`\\203\\216]A\\340\\346\\260A\\015\\011\\006\\301\\011Vx\\230\\002\\373\\301\\016lpBw&\\324\\030\\036\\301\\322\\301\\017n\\252+\\367\\233\\305\\002\\355a9UB\\361\\006J\\000\\3455\\037)\\241H\\306)\\005\\200x\\204+J\\021\\006\\032|%\\014t\\250\\003"\\230\\024\\200\\034\\346\\352\\001F\\376L\\\\\\022U\\021\\0035Q\\000L\\037X\\000\\270pC\\000\\012\\314\\240\\032\\327\\360`4|\\241\\206\\031\\210\\200\\001\\026\\200A\\014b\\341\\012\\227\\325\\343\\035\\230\\310\\201\\005\\000 \\314}Xc\\031o`\\000\\005@\\000\\202\\031\\314@\\027\\276\\020d>\\336\\201\\013\\012t\\314\\202\\234\\223f\\360\\026\\310G\\327\\334`\\011\\2710\\2419\\020\\201\\010\\222\\2724\\207\\026\\020\\001\\014$J\\316r\\312\\255\\250a!D7\\242Q\\213H|\\005`\\210\\330\\205!\\276\\322\\212Z@\\300+\\210+\\345)\\275\\262\\275\\033\\304\\313\\000\\274Y\\300\\015\\332\\320\\300U\\214\\002__\\011@\\274\\330a\\302\\223\\025\\201\\243f\\364\\2501\\314\\020\\226:\\214\\302\\032\\016\\354G24\\324\\025\\230\\356C\\246\\0344!\\010\\373\\250\\204,\\354b\\201\\330H\\023R_dN:\\321\\340\\022\\230\\250\\005&FP\\202\\256\\254\\250\\015\\256x\\203\\005:V\\325\\253\\036\\316}]!\\300\\002\\306\\220\\207\\021`J\\011Tx\\342\\272pS\\001%\\324\\301\\204\\373H\\376\\204\\034\\034\\020\\226'\\256\\303\\216}\\240\\002\\\\\\023(\\327\\243z\\345\\013q\\250\\006\\000\\215q\\003 \\371\\025\\260y\\244i\\010\\0010\\004\\303.p\\034\\\\\\350\\302b\\031\\353\\333\\351ze\\003\\017{\\230\\253v\\240\\007<d\\241\\011]\\351,V\\375\\345#\\037\\351\\354\\000\\343\\354\\315\\010\\364\\260\\012\\000\\366C\\013\\255\\034\\2138LH\\015U\\274a\\267\\233\\263\\2061\\312\\020\\226\\026\\334`\\031&,Fq\\273r\\333\\230jp\\246\\326\\034EW\\206\\340\\204\\303z\\360\\035\\017\\263n\\334$\\014\\026\\015D"\\022\\017\\203\\300\\242\\000\\000\\2035\\310\\341\\016p\\350J$Rq\\001p]`\\017kX\\260\\016X\\300\\202K\\005\\240\\000\\016\\330\\203\\036\\304"\\200m\\305f\\275\\355\\315k\\024Z,_\\326\\355\\203\\032\\255\\270oG\\365[]\\000\\334 \\010\\000\\346\\3340\\010\\327W;\\0368\\260{\\\\.8u\\241\\017\\316\\315C\\027\\272\\210\\300Z\\276Ea\\0055\\026R\\007\\310n-"\\340\\025\\023\\354\\202\\025])/\\376\\376\\304z#P\\212\\022\\000\\026\\310\\202\\023\\024\\213C\\307\\331\\006\\006\\243\\250E\\003\\311L\\226a`\\303eM\\263\\004~\\345\\312_\\2608!\\013\\3250!q\\201T\\340\\277>9\\271\\011\\036(%\\334A\\217\\006\\3562\\027\\265X\\203\\001\\273|\\240/7*\\314\\331\\365,\\000r\\264#\\000\\370\\327\\274\\000 \\300\\200\\001\\000J\\260v\\005\\004r\\246\\263W\\0300\\301;\\347y\\317e\\021\\306\\237\\373\\021\\350\\335\\326C\\256t\\005K\\023\\020\\035\\340U\\037\\367\\321\\324T\\356(\\\\5i\\227\\371o\\227\\273\\310\\364\\2469= O7\\3125X0,5\\370\\273\\000\\035\\370\\250\\0056\\246qW(\\320\\002\\006\\277\\365_\\204\\233vmfP\\213]\\374\\217\\317c\\231\\2051\\004\\331\\353!\\033\\343\\250\\001\\360/6\\332\\261\\271f>\\323+\\307\\236\\346W\\252\\271\\217\\301~\\245\\0029@\\304;\\\\\\326\\217\\347\\351\\303\\036\\371\\250\\3078r!\\013&S\\373C\\027\\007\\313\\370x\\321\\015\\272f\\250\\274\\260\\351\\021\\021\\376\\234pnl\\226\\267~\\353\\256\\205/\\376\\227\\200\\262\\310[\\220\\3400\\206\\240\\021\\370k\\375\\006;\\3157 \\307\\346\\012\\216\\215N@\\323\\300\\002\\367\\212\\036\\211\\267\\334q\\337\\300\\020\\003l\\240{\\031v\\013Yg\\034?\\326\\206T\\016\\327\\000\\212=\\034\\002\\014\\004P\\227\\341\\320\\022\\200\\027\\356ih\\000+\\035\\001\\006Z\\233\\030\\250B\\027\\270&\\313\\313\\211'\\363A_\\024\\032\\312@F2\\222\\341\\014gl\\256\\036\\356\\230\\205\\030\\316\\007\\360h"{\\340\\202\\335\\324@\\305\\325\\200\\016\\240\\200\\024\\243\\030G9v\\276\\217{\\314\\303\\034\\3050\\006\\010>@\\366\\247\\313'\\352\\246*l\\236\\323\\320\\0335\\353\\3546fG\\273\\011\\341-\\226\\265\\307\\374\\022\\276\\376_\\003\\033\\370\\016wH\\242\\326}\\007\\372L\\243\\274l\\261\\024 ^\\204\\374\\365\\011\\007\\350\\243\\312[\\036>\\230\\207\\224\\005@\\000\\003\\031\\240\\0257\\001\\210\\222y\\031\\020\\356\\262\\227\\342\\026\\014$}X\\212A\\216w\\354\\003\\033\\271`\\304\\240\\031\\376\\010\\333}8\\203\\032\\260x\\304\\017\\276\\356\\225F#7\\331\\011\\036\\313\\210@P\\006@\\034"\\022\\306X\\207\\365\\3671\\2735\\300\\301\\325\\277\\277|\\221\\363\\277\\233\\256\\366\\2367xf\\013\\356%}`\\361\\014;W\\015\\267p\\010\\333\\347^\\377\\223\\013\\267\\300\\005QTG\\262\\007eDW{f\\0010\\230\\200\\015\\346\\340^\\233\\362f\\374\\367\\036\\301\\307\\177\\001P\\001\\024\\360\\001\\024\\260-\\002\\260\\000\\004\\260'\\012\\200\\177g1\\002\\177\\220c\\036\\024\\003\\025\\260Z\\000\\240\\000\\005\\200\\015>F\\015\\254 dq\\365\\016\\354\\220\\014)\\341\\011\\203\\240\\006.P\\001\\353\\343\\025\\3430;\\373\\220Ac0{\\005'xg!Rg \\013\\306\\000@\\373\\260)\\264\\365\\201\\300\\267\\177\\\\\\010\\034\\264\\246f7\\340{c\\001k\\243\\320@x\\340\\004(\\207s\\346\\247\\007\\300co^H\\026\\313\\260k\\323\\240\\012g\\000\\205|D\\206b\\321#\\216\\320@\\035\\370\\205 \\030\\207\\200\\210|\\002Pc\\014\\240\\002\\376,\\240\\002 \\200\\210z\\030\\026\\026\\260\\004{\\340\\207x\\260Q`\\221\\004I\\300V\\234\\223\\013rp%\\366vs\\257a\\014\\316\\3402\\324P\\013\\367\\325+\\0020t\\346 c]!.5\\326|]a\\001C\\360\\010~8\\012\\0368\\210\\347\\021\\202\\200\\010\\002'\\247\\033\\035\\320@\\343\\200\\015\\35645\\267p\\013\\316\\266\\017\\025GA\\366Vh\\260Q\\013\\267\\300V\\315\\264\\011a\\0010\\262\\260@\\331\\240X\\272\\350#]#\\026=p0\\377\\003J\\033f\\213\\350\\201\\213_x?>\\262\\206\\265\\321\\213&\\364\\213\\301x@\\2670\\013\\375c\\214\\265\\006\\207\\262\\301\\214\\316\\210\\015\\320\\010970\\215\\036\\224X704\\345\\225\\215a\\341\\003z \\200\\376\\343\\215\\340\\230\\036\\342x\\220\\271\\001\\001\\243p\\012\\377\\363\\016\\345`\\015\\303\\000\\212\\330\\320;\\234\\243\\013\\243@0\\301\\024W\\372\\245\\214\\2571>\\211\\3069\\365\\340\\014\\315\\020\\012\\211p\\012\\251\\300\\015\\363\\320o\\306\\200\\013_\\261\\006\\243`\\376\\014\\3710\\017u\\347\\013\\305\\340\\013\\303`9\\346\\260:\\375\\240\\017\\273d\\203\\0129\\036\\011\\031\\224\\266\\341\\000\\271\\364?\\027\\245_sX\\221&\\204\\221\\0329hD&\\033\\207\\026\\222\\364GL\\233"&\\336`\\017\\317\\3030\\263\\360\\025m0\\012\\307\\000;\\330\\240_\\027C\\015\\335\\000\\017\\356\\265KD\\031\\216\\202\\270\\226\\315!\\000\\015\\000\\001\\267\\240\\013\\272\\3479\\365\\020;\\272\\267\\013\\272\\360\\003\\015\\340*\\311(\\033\\006\\300\\000\\216\\240\\013x\\005:\\365`\\016\\340`\\016\\346\\2609\\343@\\015\\233 \\001\\242\\006\\0000I\\015\\255\\023q\\027\\265p\\020'\\222\\345\\260\\014c\\000<nY\\036C\\371\\231\\262!&\\305\\230W\\377c\\013\\252p|\\033\\311[QY\\033n\\240\\012\\323\\300\\200'\\0043\\215\\020\\026_y\\205\\246\\311}"\\211\\015\\276\\340t\\242\\331\\035\\241\\371\\233\\257\\021\\0031\\340\\010\\220P\\013\\272\\220\\013\\223\\342\\012\\266\\360\\010\\2210\\0031\\340\\202\\034\\365\\006o\\340\\234u\\360\\006\\246U\\033\\032\\376\\020\\003g\\000\\011\\251`\\013\\2660)\\223\\202\\011\\221\\240\\0065\\3203`q\\0010\\320\\235\\222\\000\\236\\3429)\\272\\020~\\207@\\0065\\260\\000\\237'\\234\\334\\021\\234\\370\\211\\026\\367S4{0\\012\\240\\220\\005P\\340#\\256\\350Ibh\\216\\260AkD\\220\\005v\\260)\\233\\3228\\367\\011\\026"\\227\\005w\\340\\240g\\242\\007L\\240n\\373\\351\\035\\372\\311!\\005\\020\\241\\276\\301\\000  \\002#0\\002$j\\242%z\\242*\\232\\242#0|@y\\026Q\\002\\003>0\\005[\\020\\005:\\240\\003Q\\242\\207\\024@\\202;J\\001I(\\033\\004P\\001 \\240\\003H\\260\\005[\\240\\005[ \\002\\024\\260u\\266W\\001,p\\243F\\212\\244>\\340\\003.\\340R\\275a\\001\\024\\240\\242\\027\\300\\000\\206\\203\\245Z\\212\\203\\033z\\026\\035z!>\\302\\244\\277QX\\177`\\241j\\272\\246\\026z\\007Y\\3608\\344\\244J\\345\\263)\\232FA\\000 \\247\\016\\372\\005\\260\\027\\246d1\\246\\003".\\005\\220,\\020\\000\\001\\376\\0230\\001O\\364\\243\\276\\321\\005xP\\012\\253\\220'\\256\\320\\012\\215\\372\\250\\256\\320\\250\\255\\220'\\213\\224'\\177\\200\\007"\\200TV\\020&\\216:\\007A\\000$X\\340\\251y2\\007+\\306\\247e\\341\\247\\002\\0020T\\240\\007\\312\\003\\014\\001T\\012\\243\\020\\231\\277\\001\\013\\363VB\\270\\232\\253%\\324\\014\\306\\260\\216\\217\\264)\\365\\360\\017\\302\\012\\014N 6\\001\\000\\254\\302\\372\\017\\276P\\254\\250\\332\\247m\\011'\\000#0\\257\\032@\\2470\\012\\0270\\034\\233p\\253\\272\\272\\255\\027D\\015\\306\\220\\002H\\205\\254\\303\\312\\254\\000 \\256\\312J\\256\\315\\032\\026\\252j\\037\\264\\326\\\\vP\\013\\255\\300\\016\\020\\327\\017\\3530\\226\\335\\340\\015\\001\\3240\\350\\031\\034\\3030\\257&\\264z\\027T\\017\\330P\\015\\223\\262)n\\012\\247\\277:\\012\\301\\032@\\313zI\\310\\032@\\273\\200\\256\\351\\372\\025\\353:\\037\\012J\\241\\017\\303o\\016\\324L\\330\\320\\015\\335\\020@\\313`\\014\\373\\012\\034\\3110\\257\\272\\231W\\001$\\260\\004\\273\\013\\006\\233\\376\\005\\224HN\\017\\333\\017\\313J\\004]\\021\\263\\021{I\\023K\\261\\317\\332!E@\\004o@\\007\\263\\340\\013\\313\\000\\015\\316@\\014\\300 &\\240\\240\\0073\\260\\0013\\300\\005\\210`\\014\\211\\006;\\365\\320C\\256\\324\\033CP\\004\\327\\200\\262\\260\\345\\017\\271\\371\\016Ku\\012\\247\\200\\004C\\220C\\256\\0107\\342\\352\\017\\313zn\\2332\\017\\375\\360\\017h+\\2619\\013\\000\\025\\233\\036\\002\\240J\\246\\240\\012\\333p\\016\\366 \\226\\325 &V\\340\\004\\364\\322#c`\\014\\000vA\\244\\003\\242\\270\\241JLYB\\234\\343\\017\\376\\320@\\360\\260T\\233\\362\\177\\213e\\256\\304\\352\\260\\243\\360\\016\\001t\\2568\\033\\267r\\273\\263\\007"R;\\360\\003j\\300\\010\\225\\300\\011\\235\\300\\012\\252p\\012\\245\\220\\010\\2100\\010\\201\\000\\0106\\000\\006&\\020\\003`R\\010\\215\\300\\011\\270@\\014\\354 Hy%\\013\\213\\200J\\276\\301\\234l\\345A\\013\\004[\\027\\324:\\357`\\016\\325@\\015\\270\\200\\013Qp\\003\\322y=1\\333\\2605\\376\\253\\260m\\333\\0177\\353\\271^1\\267\\336q?r0\\012\\272\\320\\015\\346\\320;\\015#\\253\\215c\\216\\207\\266\\013\\330\\300\\266J\\027@\\324\\260\\013`\\360\\033v\\263\\267\\334\\007\\260\\311\\253\\265z\\240\\206\\341\\252\\260\\377\\300\\260$w\\275\\013\\253\\275p\\233\\263\\336\\213\\035\\0070\\0034@\\006ep\\006n\\220\\010\\015\\311\\012\\260\\320\\011\\234@\\010\\204`\\244JZ+#"\\0026`\\003\\253P\\013\\324\\340K\\325\\320\\274\\315\\200\\205\\336P\\015\\206\\000\\002\\210\\013\\033\\003p\\0021\\240\\230\\246i\\274\\357\\333L\\315K\\015#\\334\\273[ \\275\\375\\033\\254\\377k\\275\\345\\352\\277=\\\\\\300\\023{\\300\\325\\241\\001\\273\\340\\013\\347p\\016!kV]\\260\\247{\\230\\005x@H\\016tQ\\301\\240\\012\\245\\240\\007g\\370\\257\\375p\\013\\226\\244\\033\\240\\246\\253\\215\\373\\270\\212V\\013\\252\\220Kb\\3220\\264\\232\\260<\\374\\017\\227+\\300\\311\\352\\303\\334K\\304\\323!\\000#\\320\\012\\2550\\014\\024\\007\\013\\210\\340\\006Q\\240\\002\\346\\330-\\376\\020\\240\\0013\\020\\012\\246\\200\\015\\330\\320\\273\\315P\\014\\262@\\012\\271\\342\\012\\000\\353\\013\\241\\260\\006\\006\\200\\250h1\\000\\020P\\002\\223\\222\\274\\371\\313\\265\\015T\\015\\272P\\013\\243\\260\\010t\\200\\010\\260\\000\\013\\010\\200 \\205\\370\\000\\021\\020\\001\\020\\260\\312\\255\\334\\312\\254\\314\\312\\032f6\\005\\360\\312\\256\\274\\312\\261\\014\\313\\032F\\000\\314r\\266i\\353\\306\\302\\272\\275^1\\250\\261\\234\\313\\270\\014\\313\\007\\300\\313\\264\\354\\000\\307\\334\\000\\331\\262\\000\\011\\360\\000\\260\\034\\001\\337\\010\\000\\201\\252\\313\\267\\214\\315\\020\\340\\314\\250\\002\\272\\373\\021\\206\\276I\\026[\\240\\007\\272p\\016\\360\\020@\\003T\\255\\327\\352\\002Y\\200\\012I\\247\\253\\325\\240\\007l`\\033%\\320n\\214\\353@\\216\\213\\274\\027\\364E\\031\\364>\\022\\342#\\267\\340\\255\\306p\\014\\226\\3230\\005m\\014\\276\\260\\013\\203\\360\\025\\252\\2040\\004-\\320\\007m9\\300\\260\\013\\211`g?<\\300>\\274)l%\\254p\\014\\000\\254\\260\\013\\300`\\320\\020=\\322\\213`\\321]a\\004NP\\376\\013\\003\\035\\277\\306\\023/\\3148\\221\\004\\215z^1>\\272 \\320\\017-\\322\\015s\\013v\\330\\315\\023\\002\\316@\\202\\026\\343\\\\\\316\\347\\274R\\357 \\253\\353\\334\\316\\357\\234\\253\\361<\\317\\265a\\002\\366\\234\\277\\375\\220\\317Z\\234\\262\\356P\\014\\240\\365\\31770\\013\\002m\\014\\021-\\320\\023\\275\\320^\\321\\320\\204K\\015\\322\\200\\323\\\\M\\015\\023]\\322@R\\275\\344\\252\\321m\\373\\017\\302\\334\\025\\262\\000\\322c]\\326g-\\322\\022d\\247]\\261\\004N\\340\\012\\006\\315\\262\\243\\340\\322Ak\\3202\\335\\0254M\\015\\307`\\326\\007\\255\\323w\\250%rL\\036\\003\\260)\\331`}\\314\\204\\015'\\003^^Q\\010\\265\\020\\222\\357\\200\\015\\240\\364\\216(\\233B\\306\\360\\267+\\014\\000E\\220\\005B}\\317\\271\\352?R\\315@\\373\\260K\\004\\212 \\\\\\275\\017\\311Z\\333\\377\\373\\326\\302j\\015\\376\\022y\\371`\\333\\267\\355\\333\\325p\\325\\226\\333\\326\\376\\013\\261\\314z\\254@\\354\\333\\233\\233\\254MS\\011\\000`\\240\\364\\340\\333\\322\\376\\235\\254\\310\\360\\025\\321=\\335\\277\\235\\254\\315\\020\\300X\\362\\330\\343\\021\\331\\243`\\016\\357\\240\\017\\225}2V\\360\\025\\232\\235h\\372\\360\\016\\331\\000J\\305XB\\365\\3200\\244]\\026\\205u\\013\\346\\254\\332\\253\\275\\017\\255\\215\\205\\260=\\206\\262M\\015\\275-\\335\\313\\235\\333WM\\014\\306\\240\\017\\266}A\\300-\\334\\311\\375\\313\\027}\\333\\333\\013\\336k\\234\\340\\270\\375\\017\\353\\320vFv\\003\\023\\216\\335\\324m\\335\\034>\\340\\377@\\015\\334m$\\336\\315\\035#\\340\\006\\217\\320\\014\\312\\320\\273\\336\\320\\015\\253\\000\\012[\\300\\312\\037\\272\\210\\263\\220\\013\\355;\\260\\263\\300\\005k\\300\\012\\255\\240@(+\\222\\365@\\016\\343\\000\\015\\317\\200\\014\\317\\013\\013\\263\\240\\014\\313\\360\\014\\3170\\016\\346\\320\\016?\\356@\\370|\\277\\373P\\016\\343\\200\\010\\\\0\\007\\240\\240\\012\\273\\220\\013\\313\\260\\014\\205\\230 \\026\\203\\340\\302\\032\\317\\240\\224\\007`\\273\\321\\377\\020\\334\\207\\022yd\\036\\342~\\243\\007h\\236\\012\\232[\\346\\014\\216\\321\\304\\275\\306\\326\\213\\334\\376.S\\346`\\233\\007g\\336\\347\\377\\320k\\002\\260\\004F0\\300M\\243\\013~\\223'\\273\\364\\326\\375 \\014\\036\\236\\262\\345@\\014\\240$\\347\\3119\\300\\3130\\342CR\\342\\333\\021\\003\\243`\\013\\366\\260\\267\\375\\320\\342\\337\\343\\002^a\\240\\322\\320\\015{;\\016\\306\\300\\01270\\004\\312\\244\\265S}A4l\\014\\315\\020\\352\\334\\352^\\216{\\277/\\203\\015\\020\\270\\004Y\\360\\007\\314\\250B\\012b/o\\236\\351\\252\\344\\004\\240D\\016Q\\375\\017\\272\\355\\317-\\223\\254\\306\\220\\354\\312\\256\\007\\345\\333\\266\\301\\355\\317l\\255\\266\\015\\316\\254\\002\\260\\266\\315n\\014\\335E\\355j\\3160\\316]\\267N0\\300\\226\\275\\012\\310$\\331\\356\\200\\340\\001\\004\\351^\\021\\335\\001\\324L\\272@\\355U5\\300\\323>(\\335\\355\\315\\001\\262\\243ap\\006\\231\\340\\011\\302`\\303\\326P\\015\\216\\360\\010\\3649\\002 \\000V\\031\\262\\003\\2630\\013\\354\\000\\017\\306\\260\\013\\214@\\003?\\260\\004p`\\310\\346P\\257\\207\\334\\270\\271\\031@\\021\\367x*\\345\\376^\\233\\254\\265\\334\\367\\270\\3570\\017\\2710\\013\\373K\\005.\\234\\002\\276z \\306\\236\\254\\302@\\202X\\012\\007XP\\221v~(\\015\\363\\346\\270\\200\\2459\\217\\005\\314.\\254\\316p\\347\\267\\235\\321\\330\\033\\314\\314*\\341\\331\\353\\013X\\320\\004BO\\001\\353\\360\\277\\377\\30002\\255J<\\334\\017\\325\\260\\012t`\\001\\026P\\242\\305`\\015d\\376\\350\\036\\376\\277\\354\\320\\014\\2300\\365\\245\\220\\012\\354 \\254\\375\\260\\335%\\267\\351\\376\\016 >\\302\\012\\265\\300\\354\\0014\\017\\306\\220\\013\\276\\371%v\\360\\316\\2670\\012\\375T\\001\\301\\036@\\206\\034\\262\\033\\250\\337bl\\362\\371}\\317\\214\\017\\371\\001\\264\\353\\257\\355\\016\\2470g\\027R\\363\\302\\372\\011\\014\\355\\004L\\351\\354\\273-\\223\\311\\352\\011\\235\\317\\354\\376\\260\\346H\\017\\300\\230\\253\\346{n\\263\\022+\\017\\311z\\341\\202\\206\\356kL\\015\\243\\360\\204^\\3615k\\\\\\335\\363\\236\\254\\345`\\014\\265\\351\\025\\377i\\016\\311*\\342s/$\\234\\036\\035\\001\\320\\263B[\\015\\330\\376 F\\2600\\010\\202\\020%\\333\\002\\0011\\020\\006\\314Y\\016\\346\\360\\274g\\240\\005\\017\\325\\003]\\244\\017\\365 \\013\\230\\340\\013\\315\\260\\201b\\214\\277\\306\\233\\233(\\257\\337\\262N\\177\\315\\204\\013\\271\\300\\016\\013W\\017\\300\\020d \\360\\262\\0122\\346V\\317\\371^\\001\\020-nL\\342\\344\\311\\023\\241\\0371\\000\\000\\000fL\\337?\\210\\236\\026.t\\342d\\\\?\\177\\377\\252\\215r\\263p\\324\\250z\\020\\373\\371rR\\304#\\310~\\375\\376\\355r2\\004\\200\\200\\217!S\\032\\323\\323\\006\\306\\010\\022#\\344e\\374\\307\\316X\\245\\227\\025\\347\\361\\\\6j\\314D\\000\\271\\210\\205\\204(\\014)=\\221\\354\\234\\315\\3029\\002\\006+W\\357D.+\\211\\324\\353W\\260a\\305\\216%[\\326\\354Y\\261\\200\\000\\241e\\333\\326\\355[\\262\\002\\262da\\327\\317X\\25567>\\204\\375\\241jW\\277|\\330\\260!\\271A\\000\\000\\205\\033\\206\\372\\355s\\347n\\307\\015\\\\\\330\\352\\371\\363\\2272\\345\\276}\\374*_\\336gy\\361>\\312\\376\\2331{\\246\\374\\316\\230\\254\\0337\\004\\333\\353\\334\\017X\\026%pe\\317\\246\\375\\325\\030\\265}"%\\2365f\\214\\351\\277\\335\\024\\235\\220\\303\\370\\317\\031\\307\\223\\277\\201\\265L\\376/%K\\227\\003b:\\357\\207\\355V\\255\\2171S\\3664vIx]\\210\\306\\214"\\305\\345\\033\\342?dO\\251\\337sw,\\373\\250\\2062\\355:\\211]\\333\\376}\\374^\\325\\346\\347\\337\\177\\254\\022&\\226q\\006\\026G\\270\\000\\201\\002\\244\\004 \\000\\202\\010\\006\\271\\205\\030v\\330\\301\\005\\027\\027>` \\000\\030\\270\\220\\244\\237z\\212)f\\210\\033r1\\307\\235zJ\\254\\347\\263\\316*\\353l4\\313F\\023m\\264}\\362\\321\\247\\263w\\252\\311E\\212$&t\\246\\033v\\352\\311E\\011\\227\\374\\0232?`\\226y(\\245O\\320\\362\\305\\241\\363\\202\\003\\240\\242\\213 \\332\\250#\\000>\\322\\012"\\222\\202\\234.\\245,\\001\\010`\\313~\\312\\361%\\227Zlq\\305\\226\\023\\235+g\\027F\\202rb\\036\\225\\372\\241f\\0241\\220\\376\\312\\305\\274\\246\\324KI\\037z\\254)\\363\\314f\\2529R\\037c\\226 bHD\\023\\375j?E\\033\\265\\217\\205\\302\\302\\202\\364\\026\\036\\3731\\247\\226H\\220\\372\\340\\006L\\336\\361\\324\\232\\324Rs\\306\\237lz\\273\\215E\\316Z\\243\\2143\\317Z\\334\\247\\034l\\340\\\\\\214\\235ZjYh\\211,Z1f\\020G{m\\353\\316\\207 J\\2227&#B\\252"s\\316;\\216\\312\\217\\352Ri9-A:\\257K\\230\\244\\025i\\273\\363\\256\\215f<\\001*\\222O\\274\\243&*\\357\\267\\364&\\202\\352Z\\225\\316\\303V\\037wf\\271\\201\\005_\\343\\305\\217Qy\\353-\\013\\322\\002\\302J\\215Rv\\366\\031\\007S\\244@\\340\\324Ss@\\015u\\324l\\210i\\250\\031\\030SMiU\\024[\\375L\\260\\2720\\243\\325V\\000\\224\\310b\\225ax\\265\\367c;\\213\\375gX\\263z\\373\\315\\311\\212\\3129o\\312\\223\\300\\373\\207$\\223\\252\\264\\366e\\346\\276\\234y\\317\\207\\267\\323'\\037\\361\\352\\354\\326\\211o\\376\\307\\233H\\251\\337\\2342W]\\3136\\3339%z\\332}\\027d\\250\\321\\2427j\\252\\301\\012 \\265q\\354\\361\\324\\026't\\370\\012\\226n\\340\\351g\\230\\247\\2232\\006NLnh\\203\\032k\\236\\333\\245\\337\\326Xu\\265\\036l\\262\\2018\\025=\\362\\276\\205\\305Z!\\250:\\352;\\3639\\217\\344\\211\\206\\250\\310\\011#\\312n(X\\340\\216\\035\\256\\270e\\233\\343\\2229\\231]\\206\\016\\000\\351F\\2013\\243\\313\\343\\252\\310ep\\311\\303\\023==\\373\\031\\307\\230F\\376V\\335\\255\\251W\\377;5r\\264~'\\026\\312\\221\\002\\273\\256b\\312\\276\\363\\304\\264\\327`\\233\\313]\\314\\211[n\\316\\336\\301f\\034\\210U\\311[\\217\\275[\\353\\333u{\\201\\035\\374+\\303+J\\034\\204\\205\\026o\\322\\361\\2132bYf\\371\\272\\254<\\335.m\\336|\\245\\332\\305\\372\\331\\3459\\353\\034zt\\243\\027\\202*\\245\\323S\\207\\376\\376\\264\\326\\302\\237\\352\\001\\3626\\246\\0312D\\340\\000\\005\\020\\000R \\201\\211q\\354c\\027\\376\\240\\340\\202\\202X\\240\\202u\\320\\255\\031f\\020\\200\\015\\354\\221\\217\\224p!\\011\\326\\330\\0146\\\\q\\213\\224X\\243\\032\\3220\\2069\\372A\\216[\\334\\342\\024\\247\\310\\307>\\262\\001\\015E\\014\\201\\012y\\030E\\323\\262\\001\\016-| _\\373k\\324m\\344C8"\\024\\301\\030\\354(\\0079|\\241\\2075,\\304d\\333\\233\\010\\262\\250\\0239\\360M\\253+Q|\\016s\\252%\\237\\316-\\304\\022\\262\\340\\242$\\020\\021\\006/y\\213:\\241\\023\\327\\350\\312%\\277\\363\\224\\303\\030m\\232\\210\\022\\232\\020\\011.\\312\\302\\020,\\330\\013\\017\\243\\326:;\\312+sK\\342@Xn\\361\\266~\\350"\\013.\\271\\332\\015NT\\015c\\220\\001\\0006\\360\\014\\210F\\225\\222\\215\\264"%\\324\\240\\206/vA\\034l\\324\\242\\025y\\303Lc\\034q\\003\\303\\351\\001\\035\\356\\360\\024\\027n\\300\\200<&\\3526G\\352\\007\\341\\240D\\235\\215\\314a!\\305\\020\\031\\312\\234\\240\\262I"'\\212X\\242\\034\\230.\\2279,\\246o\\026\\246\\376\\322\\205*\\332\\340\\246\\240\\205k!D;O\\374\\000p\\256\\177\\250\\321~\\013\\261B\\026na*I\\224-\\225\\366\\302\\3436{5\\002\\021\\240\\200\\006\\007\\360\\312\\000\\266\\260\\205k\\230C\\027\\256\\030\\203\\005P9\\200: \\302\\036\\375\\300D\\033vP\\201A,F09\\270\\2013>c\\014*\\314\\001#\\345\\310\\206#\\326@\\014\\016ac\\030"\\270\\000%\\353\\241\\217\\\\D\\342\\014\\025\\020\\201!\\020a\\210:\\\\`\\001\\005\\364\\246\\177\\226\\024\\254~4\\343\\234\\347,E)p\\371\\017k\\214B\\226\\000 \\206\\310\\2221\\322-|d\\036"\\371^\\263\\322\\005-\\311\\365\\343r6cJHG\\261\\007\\230\\216\\243G\\364\\250\\206.\\332\\364\\263\\236\\212\\251\\0250uF6\\322D\\272\\243\\245\\244\\036\\320\\300\\005L[\\341\\012l\\274c\\036>2B\\220:\\032\\257n~\\365c\\300\\354\\007*\\262\\320\\202\\211\\034\\240V\\030\\314Kj\\020\\341\\017B\\031C\\0077h\\306erq\\003.P\\2461c\\270\\376\\301,.\\363\\214\\205\\350b\\027'\\302\\2061\\010\\001\\000\\002\\204\\352\\006\\001\\020\\253\\177\\244\\007\\021l\\274'\\205\\347\\373\\336\\022!\\222\\322\\354\\324\\35275\\035\\205\\313`\\226\\323_N\\007\\262\\232|\\217\\340 \\242FK \\363<t\\023Ov\\312\\341\\016}l\\347\\214\\317\\\\O{\\336\\023\\237\\363Pc\\212\\215uTXy\\033\\257\\001\\244\\342\\024\\325\\270\\306\\031r\\200J\\001,@\\004\\315\\240F9\\330\\001\\006\\304\\014a\\021\\034J!?\\375\\211\\031\\\\P \\006\\225)\\021_1Q\\215~\\215\\203\\00400\\203\\031\\236Q\\017r`\\003\\026 \\250\\000\\005\\334K\\001\\216\\376\\366>\\271\\360\\305o\\330\\341\\013_\\000\\303\\027\\325x\\006\\006\\235c\\215=Pi\\027\\300\\000);\\364k\\014`\\004*\\266R\\332C\\022\\307\\347\\034\\361\\211v$5\\333C(\\236:\\017\\346\\346\\027\\277\\2719-0 \\261\\220\\026\\264`\\034'\\362G>\\350\\201\\015\\375\\342\\267\\036\\367\\300\\2263\\345\\321\\231\\177\\350C\\037b\\322p\\3769\\306\\261\\340\\177,\\243\\010^\\225/\\242|\\333\\343F\\015\\300\\026\\265\\252\\205\\006&R\\200\\033$\\2012\\3130\\206\\221[\\340\\204Tp\\350#\\242zX\\222"\\340\\2313\\334`\\016\\2650F?\\330\\361\\221\\205D\\346D\\237\\0052\\177\\004\\373\\033\\352d\\353Z\\324\\320\\303\\027\\026\\262\\213\\301R']\\331\\302\\026\\233\\275\\220S2\\213\\226f.\\021@\\336\\\\\\246flA\\304\\034lBJ2$3\\347k\\251\\031\\252\\013\\311\\032O\\344L\\347\\355\\344\\016^e\\036\\322\\217)=\\244\\0018\\342\\020\\2108\\204\\337\\026\\302\\000\\031bd\\026\\265\\220\\000\\000\\\\\\220+/\\353\\001\\024*\\000A]g$\\221\\010\\324c\\036\\235\\311\\313\\032"\\361\\227z\\250\\242\\025Z\\314\\205\\200X1\\204\\034\\\\\\032?\\220\\200\\2045\\326\\301\\216c\\233C\\250\\307F\\366;l\\234\\013.\\370`!\\254`\\2055\\220m\\016s\\034\\233\\331\\353P\\2669\\312\\001mi\\003@\\017\\17706\\021k\\261\\204 ,D\\325\\345.G-\\376\\232\\000\\204\\205x\\201\\013\\315\\030\\2079\\220}o"\\222c\\333\\305\\210\\204\\031\\220\\262\\011\\\\\\320;\\333\\367Vv?\\036\\302\\023g\\366\\332\\271\\314.\\342\\266\\275M\\216q\\310\\342\\003u\\0246\\177,]qGY \\013}H\\011a\\014\\343\\203Q\\350\\302\\313\\025a,2\\274\\214\\015M\\000 \\001\\275\\351L\\226S\\343\\010\\177\\354C0\\013\\331Tj*\\200\\361\\374\\264\\341=;\\317\\316\\036\\364\\020\\356\\205\\244F\\017<\\347\\271\\317\\201\\376$'\\200";k\\320K\\030\\235\\260\\207\\237\\352\\241\\012M\\237\\010\\033\\364\\020\\012\\242\\357\\374\\350H\\231\\202\\036\\240\\276\\363\\327\\306V%\\263\\025\\310\\034\\262\\376\\036<8\\001\\0078\\357\\317\\305\\331\\216\\250\\006@!\\017\\365\\310\\307c\\014\\363\\203\\220\\367c\\035Nh\\002c\\225\\241wl\\000\\005\\001\\300 \\006\\255C\\345\\010~\\350\\243\\032\\330X\\210\\300R\\203\\240\\267\\327f\\014\\213\\000\\305"\\240\\276\\007\\312[>\\352z\\340\\001R\\3365\\207P$"\\364\\243\\027}\\351\\363\\376\\006\\203c5A\\017\\245\\377\\002\\325\\371>t=\\314\\201\\012T_\\310\\032\\344\\200\\371\\312_>\\363\\227\\337\\372D\\270\\340\\365Q\\220>\\024\\320\\200\\255l\\221\\242\\202\\033\\310\\241\\364\\302_>\\034\\234\\020\\354\\310\\337\\307\\355\\321\\027R!\\221R\\206]P\\243\\037\\342@\\212\\311O\\327\\246\\003|\\2443\\330A\\275\\011\\210\\\\\\213\\324\\030\\206\\372\\353\\307O\\035\\262\\243\\207,\\304,\\314fd\\377\\307\\246_\\177\\374X\\177"\\330\\327>\\367'\\222\\014\\323Y#\\0000\\200\\217\\300 \\354 \\001\\0000?"K\\215\\035\\302?\\007t\\013\\367\\373\\010<\\310\\202$\\010\\231\\242y@\\260\\322\\037\\014T\\024\\001`\\254\\211\\030\\000\\004\\320\\000.\\350\\201\\177\\243\\006]h\\2053\\300\\234!\\030\\002[\\260\\005<\\300\\002\\354\\031\\200\\003\\230\\301\\003\\350\\300\\015\\274A\\263\\200\\206\\022a\\007s\\360\\006j\\220\\205Y\\000Br\\370\\263\\331\\302\\301J\\323@#\\354\\025\\005\\320&\\000\\270\\004c\\270\\005UH\\301BR\\005U\\260\\003'\\260\\266\\200$\\314B\\263\\220\\007\\352\\310\\007{0\\007S1\\006{\\230\\247f\\322\\302#4\\303^a\\000\\365[\\210\\015@\\001\\023\\030\\001O[\\000\\003\\030\\201\\021\\260\\000\\012h@4\\314\\303\\205p\\206u\\300\\210=)\\221\\255\\212\\033}`\\007'\\321C\\373\\270?CLDEl\\024Cc\\034E\\243\\016v\\300\\206MX\\304CT\\206O\\370\\004O\\300DM\\314DN\\334DO\\354DP\\374DQ\\014ER\\034ES,ET<EULEV\\\\EWlEX|EY\\214EZ\\234E[\\254E\\\\\\274E]\\314EP|\\206gX\\207m\\3037mc\\007qx\\006K\\344\\305]LFd\\\\Fe\\034\\305g\\010\\010\\000\\000;	\N	t	Y	opuscollege	2011-07-25 11:07:20.005985
13	AdmissionLetter	reportDeanName	text	\N		t	Y	opuscollege	2012-05-22 13:55:39.171142
14	AdmissionLetter	reportConclusionDate	text	\N		t	Y	opuscollege	2012-05-22 13:55:54.270965
15	AdmissionSummary	reportLogo	image/gif	GIF87aA\\000/\\000\\347\\377\\000\\376\\376{\\372\\206g\\363\\364\\363\\373\\372\\255N\\266E\\251\\035\\033\\267\\266\\271\\254\\333\\247*\\220C\\247\\245\\247\\364\\260\\253\\233^]t\\305lRjV\\005\\314=\\376\\376v\\352\\366\\351\\366KK\\374\\371\\346\\323\\317\\223\\354\\353\\354\\342\\343\\343\\370\\377\\376\\376\\000\\000\\362\\376\\375\\271\\342\\264E\\264:\\373\\375\\207\\332\\346\\347 \\254E\\366\\222\\216\\226\\226\\226\\36466\\310\\310\\251\\2021-\\376\\376\\371\\364{{\\353\\371\\367\\013\\313E\\330\\354\\325\\376U\\002\\370\\371\\370\\263\\257\\235\\376\\376\\355\\335\\334\\335\\234zv\\206\\205\\205\\323\\323\\323\\015\\014\\014\\312\\346\\307\\313\\312\\314\\377\\372\\377\\302\\270\\256\\270\\272r\\376\\375\\376\\373\\372\\303k\\275dfhj\\376\\376\\374\\345\\346\\212)**\\374\\374\\374xwx\\232\\325\\224\\344\\357\\361\\371\\360\\342\\371\\376\\370XYX\\261\\214\\210\\373\\377\\376\\330\\361\\330\\350\\342\\332\\311\\022\\021\\373\\331\\326\\372\\306\\303d98\\363\\373\\361\\372\\001\\000\\373\\374\\235\\301\\301\\301\\375\\376\\327\\236\\250\\246\\315,*\\200\\312y\\232\\347\\260\\314VOFGE\\210\\314\\202\\343\\343\\240\\373\\376\\373\\362\\263K\\374\\366\\373\\001\\322;\\342\\005\\005\\213\\227\\227AwN\\330\\311\\303\\337\\331\\343\\236B>\\324\\225\\222\\001\\3146:[D\\215\\322\\205\\356\\332\\3317\\321c\\367\\366\\365\\314rr\\365\\366\\372^\\267V_ec\\310\\321\\322\\341\\260\\260}OJ!\\317T\\223\\325\\214\\377\\374\\374\\353\\353\\307\\254\\271\\267\\345\\354\\353X\\332~\\374\\343\\341\\276\\241\\235MYYd\\302^\\243\\330\\237\\371\\027\\027\\372\\372\\373\\336\\334\\304\\373\\373\\376\\277\\272\\232/k=\\365\\001\\001\\321\\354\\316\\254\\253\\255\\264\\263\\262\\346\\347\\347c\\\\`\\340\\340\\340\\352\\347\\346\\374\\372\\367\\010\\312>\\375\\376p\\360\\360\\361\\352\\346\\355\\325\\335\\336{ns\\375\\001\\003\\272\\275\\276\\221\\316\\214\\352\\311\\310wc^\\353\\322\\320I\\257doqq\\232\\317\\225\\300\\344\\277\\334\\324\\332\\315\\205\\036\\316\\317\\316\\333\\333\\211pln\\332\\331\\326\\207\\236\\215m\\242w\\360')\\320\\315\\327\\346c[\\367\\322\\316\\230\\235\\235\\340\\363\\340\\307\\362\\323\\303\\305\\310\\347\\027\\030\\356\\360\\337\\322\\320\\321\\374\\025\\002\\212\\215\\215\\323\\322\\334\\261\\257\\261\\364\\365\\202\\371\\374~arnSNQ?QF\\000\\313-|\\343\\231\\365\\274\\270\\015\\303>\\372\\011\\014\\310\\303\\277\\373\\014\\001\\217\\221\\221\\223\\216\\225\\375\\004\\001\\372\\001\\004\\347\\013\\015\\266\\305\\300\\361\\015\\016\\352\\353\\202[W:\\373\\016\\017\\242\\240\\241\\177~\\200ODA\\256\\263\\255\\314\\307\\311\\372\\003\\001\\371_`\\365\\351\\213\\004\\3119v\\330\\222\\224\\211\\205\\373\\002\\011\\327\\326\\327\\306\\310\\307DNNZ\\274R\\372\\370}\\000\\3074\\367\\003\\004\\013\\3073\\357\\006\\011\\376\\007\\005\\336\\017\\020\\356\\012\\011\\011\\3124\\376\\376\\376\\376\\377\\377\\377\\376\\377\\377\\377\\375\\376\\377\\376\\377\\376\\376\\376\\376\\377\\370\\244\\243\\360\\365y\\302@@\\365\\367y\\374\\360w[\\207l\\342\\352\\337\\362\\365\\211\\356\\357\\236\\222\\304\\242\\024\\272A\\366\\343\\302\\313\\341\\335\\261\\354\\303\\317\\332\\327Z^^+\\021\\021:;:\\375\\315\\314\\304\\306c\\352\\341\\202\\000\\000\\000\\377\\377\\377,\\000\\000\\000\\000A\\000/\\000\\000\\010\\376\\000\\377\\011\\034H\\260\\240\\301\\202\\343\\204\\024\\261\\241\\303\\034:\\033#\\016J\\234H\\261\\242\\300s\\344\\306\\215#\\367o\\\\\\021<\\272H<\\213\\000"\\3023\\022\\012\\360\\010,2N G\\2130afaYD\\001\\210&\\027p^\\330\\311\\223'NR\\036z\\214\\233\\021\\263\\250\\301s\\3430\\326\\344\\265SR0I\\222zJ\\335\\331D\\022Nj\\036Z\\352xi\\324\\3428\\033E\\262<\\253\\332\\363\\233\\210%\\327\\364\\264iS\\253V\\2166\\370\\340\\210\\370&\\265\\011\\010\\001#lt\\255xN\\\\\\221\\010\\027\\234E\\225T`\\231\\236L\\323\\012\\365r\\305\\242\\302!E\\207\\022\\205\\222a\\000\\225\\2626\\005\\242:\\023f\\327B9s:\\366\\032\\364\\350\\241\\311SI\\337\\014\\373H\\340\\351P\\032\\275\\003\\305\\031\\364\\343\\210\\305\\244_\\226\\350\\006nB\\302\\202\\005\\321\\027\\213\\220+\\327\\347B\\324oV\\360}\\220A!\\264\\300\\206\\350\\304\\221\\233>\\375\\234\\216r\\323\\321\\351H\\223\\310\\200\\017\\272\\333$\\376\\361ju\\356\\334\\336r\\350,(1n|\\211\\236\\017/\\322\\374\\223=\\220\\245\\366\\025P\\362C\\221\\2207\\243\\363\\177~(2I$\\3028\\263\\315\\005c\\000b\\324F\\345\\024A\\002{H\\330\\002\\312\\013\\002\\310\\206\\2169\\035\\221\\263\\302\\000\\000<\\320\\010\\000 > \\242\\210\\000lp\\303\\034\\377\\230cC9\\026(R\\210\\024\\2228\\323D\\004\\030\\224ST\\021\\026<3\\330\\022<\\370\\343\\343\\007\\377\\254\\010\\221\\023\\215<\\020"\\000\\352\\030\\263\\303';\\030CK\\207F~x\\203\\015Y\\010\\224\\302\\013-\\360\\004\\002\\0060\\221c\\316_\\222xS\\200\\217d\\222)\\313\\010\\033\\220\\310\\316\\004*$S\\210!\\223<\\261\\2125OL"K!\\201\\364\\323!\\000\\215\\014\\000\\3108\\350\\214\\363H29IB\\312\\032\\030\\322g\\320\\026\\026\\330@\\2023c\\226)\\251\\217\\374\\000\\360I2\\011L\\342I"\\024\\010\\220B\\012~\\204\\232\\202\\000\\024$\\342\\212\\001\\201d\\023\\345\\015=\\024\\361\\217\\000\\376u4!+\\010kT\\224N\\032 H2\\210\\0250L:)*\\325<\\222\\202\\242\\007\\211#N\\017)\\034\\342\\006\\015\\263t\\270\\001\\242\\377\\2440\\311+\\2768\\243\\306\\032\\350\\230w\\020\\010@\\274!\\205\\025\\312\\034b\\215\\257\\222\\302\\260W\\017\\216\\304\\022\\002\\210\\215\\004\\241\\2038\\322\\262G\\203\\202\\022U\\242\\306#<\\270\\300\\202^\\275\\222\\353\\017\\017\\260\\025%\\233\\016=P`\\015< \\322\\321\\320\\032y\\030\\327D=\\302\\031\\304\\342\\005\\220\\370\\223\\210l~\\370\\353\\317\\023\\300\\305\\346G\\030;tH\\207\\037\\344\\010P\\2053\\316H\\341\\210\\253\\005\\2253\\202)H\\370#\\200\\015\\346P@\\356\\020A\\022\\013\\034:v`!"\\035=\\350\\000\\0048\\234\\345\\261\\310As\\264\\322\\205?\\357D\\364\\317\\244<L\\322\\261D\\3448\\202\\005\\237G\\350\\240\\003\\0309\\025\\003\\311A6\\330\\020A\\027R\\324H\\016>\\222\\266\\021\\312|\\007\\221\\243mW\\3478\\022O\\207\\217X\\220\\002\\010\\202\\021\\221\\202\\376D@\\\\\\020L1\\020\\000B\\301\\020>\\302`K2\\362\\035\\344\\033\\315\\242\\331\\360H#\\215\\304\\263\\3069\\034T\\005\\016$U\\032$\\304\\030(7a\\212\\020\\034\\240\\342\\203\\017\\205P\\200^K/\\215\\223D\\004\\272\\244\\200\\241h#\\034\\001\\342\\037B\\000\\222\\353\\005\\250\\034}\\220\\000\\244\\004CU\\037\\317\\244\\243K\\022\\304\\357\\243\\213\\007\\317\\200p\\301 }\\020\\363\\004\\005:\\013\\014H<\\264\\320B\\301\\010\\227\\340$E\\005\\305\\226\\303\\3010\\2056!cNREu\\201\\030\\231$S\\201\\037\\321\\013\\354H\\221\\236\\244`Ax\\027Lb\\254A\\346PQG7\\346O\\325S\\001\\327\\310\\304\\023*45\\201dan\\263x\\304?\\306r\\001\\027\\010@"&\\340\\206(\\244\\340?\\363\\0010\\007Q\\250@\\017\\332\\267\\027q\\010\\240H2\\350\\301\\021\\002\\263\\216D\\030\\3043d`D8F\\261\\200nH\\305,\\001L\\000\\013\\374P\\300\\202\\210\\303\\006\\033\\000\\300\\004\\004`\\201\\234|c\\025\\376-\\263\\001\\025\\034\\340\\000F8`\\027\\230\\250\\305\\020\\216a\\213\\303\\374b\\022\\207\\320]\\015\\015r\\003\\000\\314"\\021\\026@\\2063.\\020\\205\\314\\015d\\016q \\242\\030\\211H\\206y\\024\\342\\005\\256\\261\\001\\007\\247(\\001#\\311`\\004\\200\\271\\000,\\0227\\020r\\340b\\214D\\214\\206\\003\\314H\\2545\\026\\020\\020E\\232D\\032<\\260\\023\\037P\\240 \\366\\300\\343\\030;\\220\\000?NQ \\346HS\\010\\034\\241\\213\\235X\\202{\\004\\211\\203\\021\\211\\310\\205E\\312\\302\\221\\217\\314B\\016'`\\207S\\354\\004\\016,p\\211@\\264!F.\\224\\201\\014bD\\200!^\\367\\310\\211\\350\\300\\011\\226\\252@\\022NY\\015\\201\\214c\\016\\366\\330\\244\\003\\004\\221\\211N\\022\\021\\001R\\253%Et\\300\\241O$"\\011\\301\\010\\006\\034^\\340\\313s\\240\\201\\210\\341\\230\\007"\\232q\\315crL\\231\\023A\\307\\015\\2401\\001\\026\\004\\241\\023\\235\\260\\304\\332|\\311J\\007pa\\031\\011H\\301&`\\351\\200/X\\003\\234\\023\\376!\\207\\037\\\\\\361\\204C\\000\\342\\011\\277H\\206"\\006\\242\\012X\\272\\322\\005\\320\\333\\002=\\277 \\003|N\\304\\006)H\\003\\373\\374\\220\\206\\024\\350e#h`\\004\\031\\020\\220\\203\\027\\350e\\016\\335\\374\\202'\\330\\326\\225\\317\\320r\\034\\257\\263QG|\\231"\\201X\\210>\\262\\221\\015+\\031a\\013C\\354-E\\363t@\\003\\250\\331\\0255\\232#\\025L\\010XA\\204@\\254\\031\\274-E\\264\\264\\201*\\334y\\213_8b #P(\\031\\032\\260N\\243\\210\\303\\016\\004\\300\\001\\001\\246\\360\\217r\\340\\200\\001\\002\\301\\001%t\\220\\001\\002h@\\003\\330\\200@\\0210D\\000\\002\\374\\303\\213\\350@\\003\\027\\020\\020\\211\\252\\012\\304\\006rmC*\\213%\\233\\012@\\217 \\344\\230\\002%\\310\\001\\201=\\364`\\016W0\\203@\\256\\300\\007s\\304\\000\\007\\213e@9\\262 \\204=0 \\025\\231\\333\\2106va\\213'\\320\\213 \\363\\314\\201\\011%\\302\\002}\\014\\001g\\004\\261\\301\\001\\2460\\223 \\351\\340\\007|\\020\\376\\310\\017\\016P\\004B\\\\\\341\\037:\\330\\304\\025\\310\\221[J\\300\\0266\\3440\\002\\027\\206\\200\\2124\\350\\254\\034\\012\\005\\005&\\015\\222\\210\\034\\374\\003\\037\\321\\362\\203Eu@%M\\230\\341\\000A:\\007\\037\\260\\373\\017>d\\240\\010F\\220C\\0142 \\007B\\254\\210\\017\\233H\\205\\034\\270\\202\\206Q(c\\271\\005\\001i\\270$\\342\\217\\017\\030\\302\\0202 \\023\\364XB\\216\\023\\230u&_\\265\\021\\016\\256\\200\\216Mh \\006\\0328@\\330\\262\\240\\001\\010\\374C\\003F\\030H\\034`!\\003\\016\\232\\303\\036\\011\\260\\303A\\\\\\300\\203\\177T\\300\\\\\\003Q\\243\\015\\230\\300\\004Wi\\200\\020\\350\\370j\\330\\366@\\011ql\\302\\255?pk\\026\\312\\332V\\002\\200\\325\\034F\\340\\204 '2\\2024\\270\\342\\251\\006\\341\\201^\\375\\341\\322\\330\\330\\200\\000\\330\\370G*\\032\\234\\005>h \\013=8pn\\335\\372`J\\330\\000\\033\\014\\240lY\\377\\021\\026\\026<u\\2156HC\\017\\016b\\013\\177\\350\\203\\244\\004I\\010\\032\\033\\316\\272[\\331\\254Y\\003\\220\\025G\\014\\334\\332\\203\\262\\012\\341\\304\\006$\\200\\021l\\020\\020\\000;H#\\215\\304\\263\\3069\\034T\\005\\016$U\\032$\\304\\030(7a\\212\\020\\034\\240\\342\\203\\017\\205P\\200^K/\\215\\223D\\004\\272\\244\\200\\241h#\\034\\001\\342\\037B\\000\\222\\353\\005\\250\\034}\\220\\000\\244\\004CU\\037\\317\\244\\243K\\022\\304\\357\\243\\213\\007\\317\\200p\\301 }\\020\\363\\004\\005:\\013\\014H<\\264\\320B\\301\\010\\227\\340$E\\005\\305\\226\\303\\3010\\2056!cNREu\\201\\030\\231$S\\201\\037\\321\\013\\354H\\221\\236\\244`Ax\\027Lb\\254A\\346PQG7\\346O\\325S\\001\\327\\310\\304\\023*45\\201dan\\263x\\304?\\306r\\001\\027\\010@"&\\340\\206(\\244\\340?\\363\\0010\\007Q\\250@\\017\\332\\267\\027q\\010\\240H2\\350\\301\\021\\002\\263\\216D\\030\\3043d`D8F\\261\\200nH\\305,\\001L\\000\\013\\374P\\300\\202\\210\\303\\006\\033\\000\\300\\004\\004`\\201\\234|c\\025\\376-\\263\\001\\025\\034\\340\\000F8`\\027\\230\\250\\305\\020\\216a\\213\\303\\374b\\022\\207\\320]\\015\\015r\\003\\000\\314"\\021\\026@\\2063.\\020\\205\\314\\015d\\016q \\242\\030\\211H\\206y\\024\\342\\005\\256\\261\\001\\007\\247(\\001#\\311`\\004\\200\\271\\000,\\0227\\020r\\340b\\214D\\214\\206\\003\\314H\\2545\\026\\020\\020E\\232D\\032<\\260\\023\\037P\\240 \\366\\300\\343\\030;\\220\\000?NQ \\346HS\\010\\034\\241\\213\\235X\\202{\\004\\211\\203\\021\\211\\310\\205E\\312\\302\\221\\217\\314B\\016'`\\207S\\354\\004\\016,p\\211@\\264!F.\\224\\201\\014bD\\200!^\\367\\310\\211\\350\\300\\011\\226\\252@\\022NY\\015\\201\\214c\\016\\366\\330\\244\\003\\004\\221\\211N\\022\\021\\001R\\253%Et\\300\\241O$"\\011\\301\\010\\006\\034^\\340\\313s\\240\\201\\210\\341\\230\\007"\\232q\\315crL\\231\\023A\\307\\015\\2401\\001\\026\\004\\241\\023\\235\\260\\304\\332	\N	t	Y	opuscollege	2012-05-24 16:12:15.672962
\.


--
-- TOC entry 4424 (class 0 OID 41216)
-- Dependencies: 2420
-- Data for Name: requestadmissionperiod; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY requestadmissionperiod (startdate, enddate, academicyearid, numberofsubjectstograde, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4425 (class 0 OID 41226)
-- Dependencies: 2422
-- Data for Name: requestforchange; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY requestforchange (id, requestinguserid, respondinguserid, rfc, comments, entityid, entitytypecode, rfcstatuscode, expirationdate, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4426 (class 0 OID 41241)
-- Dependencies: 2424
-- Data for Name: rfcstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY rfcstatus (id, code, lang, description, writewho, writewhen, active) FROM stdin;
1	1	en    	New	opuscollege	2011-02-22 16:26:34.386311	Y
2	2	en    	Resolved	opuscollege	2011-02-22 16:26:34.386311	Y
3	3	en    	Refused	opuscollege	2011-02-22 16:26:34.386311	Y
\.


--
-- TOC entry 4427 (class 0 OID 41253)
-- Dependencies: 2426
-- Data for Name: rigiditytype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY rigiditytype (id, code, lang, active, description, writewho, writewhen) FROM stdin;
13	1	en    	Y	compulsory	opuscollege	2011-02-15 17:15:14.600271
14	3	en    	Y	elective	opuscollege	2011-02-15 17:15:14.600271
\.


--
-- TOC entry 4428 (class 0 OID 41265)
-- Dependencies: 2428
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
-- TOC entry 4429 (class 0 OID 41277)
-- Dependencies: 2430
-- Data for Name: sch_bank; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_bank (id, code, name, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4430 (class 0 OID 41289)
-- Dependencies: 2432
-- Data for Name: sch_complaint; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_complaint (id, complaintdate, reason, complaintstatuscode, scholarshipapplicationid, active, writewho, writewhen, result) FROM stdin;
\.


--
-- TOC entry 4431 (class 0 OID 41301)
-- Dependencies: 2434
-- Data for Name: sch_complaintstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_complaintstatus (id, description, code, lang, active, writewho, writewhen) FROM stdin;
1	resolved	RS	en    	Y	opusscholarship	2008-08-15 17:38:10.590138
2	not resolved	NR	en    	Y	opusscholarship	2008-08-15 17:38:10.590138
3	open	OP	en    	Y	opusscholarship	2008-08-15 17:38:10.590138
\.


--
-- TOC entry 4432 (class 0 OID 41313)
-- Dependencies: 2436
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
-- TOC entry 4433 (class 0 OID 41325)
-- Dependencies: 2438
-- Data for Name: sch_scholarship; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_scholarship (id, scholarshiptypecode, sponsorid, active, writewho, writewhen, amount, housingcosts, academicyearid) FROM stdin;
\.


--
-- TOC entry 4434 (class 0 OID 41337)
-- Dependencies: 2440
-- Data for Name: sch_scholarshipapplication; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_scholarshipapplication (id, scholarshipstudentid, scholarshipappliedforid, scholarshipgrantedid, decisioncriteriacode, scholarshipamount, observation, validfrom, validuntil, active, writewho, writewhen, studyplanid, feeid) FROM stdin;
\.


--
-- TOC entry 4435 (class 0 OID 41351)
-- Dependencies: 2442
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
-- TOC entry 4436 (class 0 OID 41363)
-- Dependencies: 2444
-- Data for Name: sch_sponsor; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_sponsor (id, code, name, active, writewho, writewhen, sponsortypecode) FROM stdin;
9	GOV	Government	Y	opusscholarship	2011-01-06 11:01:57.171649	
10	PRIV	Private	Y	opusscholarship	2011-01-06 11:01:57.171649	
11	OTH	Other	Y	opusscholarship	2011-01-06 11:01:57.171649	
\.


--
-- TOC entry 4437 (class 0 OID 41375)
-- Dependencies: 2446
-- Data for Name: sch_sponsorfeepercentage; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_sponsorfeepercentage (id, feecategorycode, percentage, writewho, writewhen, sponsorid, active) FROM stdin;
\.


--
-- TOC entry 4438 (class 0 OID 41387)
-- Dependencies: 2448
-- Data for Name: sch_sponsorpayment; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_sponsorpayment (id, scholarshipapplicationid, academicyearid, paymentduedate, paymentreceiveddate) FROM stdin;
\.


--
-- TOC entry 4439 (class 0 OID 41393)
-- Dependencies: 2450
-- Data for Name: sch_sponsortype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_sponsortype (id, code, title, lang, description, active, writewho, writewhen, titleshort) FROM stdin;
1	GRZ-S	GRZ sponsorship	en	Government Sponsored Tuition Waiver through Bursaries committee. This covers Tuition only.	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353	\N
2	EX-S	External sponsorsip	en	Sponsorship provided by institutions other than UNZA	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353	\N
3	SDF-S	Staff Development Fellow (SDF)	en	Applicable to members of staff	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353	\N
4	TW-S	Tution Waiver	en	Applicable to members of staff and their dependants	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353	\N
5	STB-S	Staff Terminal Benefits Sponsorship	en	The fees due are deducted from a member of staffs unpaid terminal benefits. Beneficiaries include dependants	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353	\N
6	SLF-S	Self sponsorship	en	The student pays all fees themselves	Y	opuscollege-scholarship	2011-09-29 11:08:15.162353	\N
\.


--
-- TOC entry 4440 (class 0 OID 41405)
-- Dependencies: 2452
-- Data for Name: sch_student; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_student (scholarshipstudentid, studentid, account, accountactivated, active, writewho, writewhen, bankid) FROM stdin;
\.


--
-- TOC entry 4441 (class 0 OID 41419)
-- Dependencies: 2454
-- Data for Name: sch_subsidy; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_subsidy (id, scholarshipstudentid, subsidytypecode, sponsorid, amount, subsidydate, observation, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4442 (class 0 OID 41431)
-- Dependencies: 2456
-- Data for Name: sch_subsidytype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY sch_subsidytype (id, description, code, lang, active, writewho, writewhen) FROM stdin;
1	Material	mat	en    	Y	opusscholarship	2008-08-21 10:54:37.762649
2	Thesis (Bank)	tesB	en    	Y	opusscholarship	2008-08-21 10:54:37.762649
3	Thesis (Signature)	tesA	en    	Y	opusscholarship	2008-08-21 10:54:37.762649
4	Thesis (Final)	tesF	en    	Y	opusscholarship	2008-08-21 10:54:37.762649
\.


--
-- TOC entry 4443 (class 0 OID 41443)
-- Dependencies: 2458
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
-- TOC entry 4444 (class 0 OID 41455)
-- Dependencies: 2460
-- Data for Name: secondaryschoolsubjectgroup; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY secondaryschoolsubjectgroup (id, groupnumber, minimumnumbertograde, maximumnumbertograde, studygradetypeid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4445 (class 0 OID 41467)
-- Dependencies: 2462
-- Data for Name: staffmember; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY staffmember (staffmemberid, staffmembercode, personid, dateofappointment, appointmenttypecode, stafftypecode, primaryunitofappointmentid, educationtypecode, writewho, writewhen, startworkday, endworkday, teachingdaypartcode, supervisingdaypartcode) FROM stdin;
72	STA022022011112253	183	\N	1	1	94	3	opuscollege	2011-02-22 11:24:02.20943	\N	\N	\N	\N
101	STA6417052011141947	242	2008-01-01	1	1	94	3	opuscollege	2011-05-17 14:20:49.113706	00:00:00	00:00:00	0	0
\.


--
-- TOC entry 4446 (class 0 OID 41478)
-- Dependencies: 2463
-- Data for Name: staffmemberfunction; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY staffmemberfunction (staffmemberid, functioncode, functionlevelcode, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4447 (class 0 OID 41489)
-- Dependencies: 2465
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
-- TOC entry 4448 (class 0 OID 41501)
-- Dependencies: 2467
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
-- TOC entry 4449 (class 0 OID 41513)
-- Dependencies: 2469
-- Data for Name: student; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY student (studentid, studentcode, personid, dateofenrolment, primarystudyid, statuscode, expellationdate, reasonforexpellation, previousinstitutionid, previousinstitutionname, previousinstitutiondistrictcode, previousinstitutionprovincecode, previousinstitutioncountrycode, previousinstitutioneducationtypecode, previousinstitutionfinalgradetypecode, previousinstitutionfinalmark, previousinstitutiondiplomaphotograph, scholarship, fatherfullname, fathereducationcode, fatherprofessioncode, fatherprofessiondescription, motherfullname, mothereducationcode, motherprofessioncode, motherprofessiondescription, financialguardianfullname, financialguardianrelation, financialguardianprofession, writewho, writewhen, expellationenddate, expellationtypecode, previousinstitutiondiplomaphotographremarks, previousinstitutiondiplomaphotographname, previousinstitutiondiplomaphotographmimetype, subscriptionrequirementsfulfilled, secondarystudyid, foreignstudent, nationalitygroupcode, fathertelephone, mothertelephone, relativeofstaffmember, relativestaffmemberid, ruralareaorigin) FROM stdin;
\.


--
-- TOC entry 4450 (class 0 OID 41537)
-- Dependencies: 2471
-- Data for Name: studentabsence; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentabsence (id, studentid, startdatetemporaryinactivity, enddatetemporaryinactivity, reasonforabsence, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4451 (class 0 OID 41548)
-- Dependencies: 2473
-- Data for Name: studentactivity; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentactivity (id, studentid, description) FROM stdin;
\.


--
-- TOC entry 4452 (class 0 OID 41557)
-- Dependencies: 2475
-- Data for Name: studentbalance; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentbalance (id, studentid, feeid, studyplancardinaltimeunitid, studyplandetailid, academicyearid, exemption) FROM stdin;
\.


--
-- TOC entry 4453 (class 0 OID 41569)
-- Dependencies: 2477
-- Data for Name: studentcareer; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentcareer (id, studentid, description) FROM stdin;
\.


--
-- TOC entry 4454 (class 0 OID 41578)
-- Dependencies: 2479
-- Data for Name: studentcounseling; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentcounseling (id, studentid, description) FROM stdin;
\.


--
-- TOC entry 4455 (class 0 OID 41587)
-- Dependencies: 2481
-- Data for Name: studentexpulsion; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentexpulsion (id, studentid, startdate, enddate, expulsiontypecode, reasonforexpulsion, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4456 (class 0 OID 41598)
-- Dependencies: 2483
-- Data for Name: studentplacement; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentplacement (id, studentid, description) FROM stdin;
\.


--
-- TOC entry 4457 (class 0 OID 41607)
-- Dependencies: 2485
-- Data for Name: studentstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentstatus (id, code, lang, active, description, writewho, writewhen) FROM stdin;
7	1	en    	Y	active	opuscollege	2011-06-14 16:54:51.91068
8	5	en    	Y	deceased	opuscollege	2011-06-14 16:54:51.91068
9	101	en    	Y	expelled	opuscollege	2011-06-14 16:54:51.91068
10	102	en    	Y	suspended	opuscollege	2011-06-14 16:54:51.91068
\.


--
-- TOC entry 4458 (class 0 OID 41619)
-- Dependencies: 2487
-- Data for Name: studentstudentstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studentstudentstatus (id, studentid, startdate, studentstatuscode, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4459 (class 0 OID 41630)
-- Dependencies: 2489
-- Data for Name: study; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY study (id, studydescription, active, organizationalunitid, academicfieldcode, dateofestablishment, startdate, registrationdate, writewho, writewhen, minimummarksubject, maximummarksubject, brspassingsubject) FROM stdin;
\.


--
-- TOC entry 4460 (class 0 OID 41643)
-- Dependencies: 2491
-- Data for Name: studyform; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyform (id, code, lang, active, description, writewho, writewhen) FROM stdin;
15	1317302927520	en_ZM 	Y	regular programme alternative	opuscollege	2011-09-29 15:28:50.118965
23	1	en    	Y	Regular learning	opuscollege	2012-10-02 18:07:04.815
24	2	en    	Y	Parallel programme	opuscollege	2012-10-02 18:07:04.815
25	3	en    	Y	Distant learning	opuscollege	2012-10-02 18:07:04.815
\.


--
-- TOC entry 4461 (class 0 OID 41655)
-- Dependencies: 2493
-- Data for Name: studygradetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studygradetype (id, studyid, gradetypecode, active, contactid, registrationdate, writewho, writewhen, currentacademicyearid, cardinaltimeunitcode, numberofcardinaltimeunits, maxnumberofcardinaltimeunits, numberofsubjectspercardinaltimeunit, maxnumberofsubjectspercardinaltimeunit, studytimecode, brspassingsubject, studyformcode, maxnumberoffailedsubjectspercardinaltimeunit, studyintensitycode, maxnumberofstudents, disciplinegroupcode) FROM stdin;
\.


--
-- TOC entry 4462 (class 0 OID 41676)
-- Dependencies: 2494
-- Data for Name: studygradetypeprerequisite; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studygradetypeprerequisite (studygradetypeid, requiredstudygradetypeid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4463 (class 0 OID 41687)
-- Dependencies: 2496
-- Data for Name: studyintensity; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyintensity (id, code, lang, active, description, writewho, writewhen) FROM stdin;
4	F	en	Y	fulltime	opuscollege	2012-10-02 18:07:04.815
5	P	en	Y	parttime	opuscollege	2012-10-02 18:07:04.815
\.


--
-- TOC entry 4464 (class 0 OID 41699)
-- Dependencies: 2498
-- Data for Name: studyplan; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyplan (id, studentid, studyplandescription, active, writewho, writewhen, brspassingexam, studyplanstatuscode, studyid, gradetypecode, minor1id, major2id, minor2id, applicationnumber, applicantcategorycode, firstchoiceonwardstudyid, firstchoiceonwardgradetypecode, secondchoiceonwardstudyid, secondchoiceonwardgradetypecode, thirdchoiceonwardstudyid, thirdchoiceonwardgradetypecode, previousdisciplinecode, previousdisciplinegrade) FROM stdin;
\.


--
-- TOC entry 4465 (class 0 OID 41719)
-- Dependencies: 2500
-- Data for Name: studyplancardinaltimeunit; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyplancardinaltimeunit (id, studyplanid, cardinaltimeunitnumber, progressstatuscode, active, writewho, writewhen, studygradetypeid, cardinaltimeunitstatuscode, tuitionwaiver, studyintensitycode) FROM stdin;
\.


--
-- TOC entry 4466 (class 0 OID 41734)
-- Dependencies: 2502
-- Data for Name: studyplandetail; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyplandetail (id, studyplanid, subjectid, subjectblockid, active, writewho, writewhen, studyplancardinaltimeunitid, studygradetypeid) FROM stdin;
\.


--
-- TOC entry 4467 (class 0 OID 41748)
-- Dependencies: 2503
-- Data for Name: studyplanresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studyplanresult (id, studyplanid, examdate, finalmark, mark, active, writewho, writewhen, passed) FROM stdin;
\.


--
-- TOC entry 4468 (class 0 OID 41762)
-- Dependencies: 2505
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
-- TOC entry 4469 (class 0 OID 41774)
-- Dependencies: 2507
-- Data for Name: studytime; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY studytime (id, code, lang, active, description, writewho, writewhen) FROM stdin;
21	1	en    	Y	Daytime	opuscollege	2012-04-24 15:12:49.734024
22	2	en    	Y	Evening	opuscollege	2012-04-24 15:12:49.734024
\.


--
-- TOC entry 4470 (class 0 OID 41786)
-- Dependencies: 2509
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
-- TOC entry 4471 (class 0 OID 41798)
-- Dependencies: 2511
-- Data for Name: subject; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subject (id, subjectcode, subjectdescription, subjectcontentdescription, primarystudyid, active, targetgroupcode, freechoiceoption, creditamount, hourstoinvest, frequencycode, studytimecode, examtypecode, maximumparticipants, brspassingsubject, registrationdate, writewho, writewhen, currentacademicyearid, resulttype) FROM stdin;
\.


--
-- TOC entry 4472 (class 0 OID 41814)
-- Dependencies: 2513
-- Data for Name: subjectblock; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectblock (id, subjectblockcode, subjectblockdescription, active, targetgroupcode, brsapplyingtosubjectblock, registrationdate, writewho, writewhen, brspassingsubjectblock, currentacademicyearid, brsmaxcontacthours, studytimecode, blocktypecode, primarystudyid, freechoiceoption) FROM stdin;
\.


--
-- TOC entry 4473 (class 0 OID 41828)
-- Dependencies: 2514
-- Data for Name: subjectblockprerequisite; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectblockprerequisite (subjectblockid, subjectblockstudygradetypeid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4474 (class 0 OID 41839)
-- Dependencies: 2516
-- Data for Name: subjectblockstudygradetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectblockstudygradetype (id, subjectblockid, studygradetypeid, cardinaltimeunitnumber, rigiditytypecode, active, writewho, writewhen, importancetypecode) FROM stdin;
\.


--
-- TOC entry 4475 (class 0 OID 41850)
-- Dependencies: 2517
-- Data for Name: subjectprerequisite; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectprerequisite (subjectid, subjectstudygradetypeid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4476 (class 0 OID 41861)
-- Dependencies: 2519
-- Data for Name: subjectresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectresult (id, subjectid, studyplandetailid, subjectresultdate, mark, staffmemberid, active, writewho, writewhen, passed, endgradecomment) FROM stdin;
\.


--
-- TOC entry 4477 (class 0 OID 41874)
-- Dependencies: 2521
-- Data for Name: subjectstudygradetype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectstudygradetype (id, subjectid, studygradetypeid, active, writewho, writewhen, cardinaltimeunitnumber, rigiditytypecode, importancetypecode) FROM stdin;
\.


--
-- TOC entry 4478 (class 0 OID 41887)
-- Dependencies: 2523
-- Data for Name: subjectstudytype; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectstudytype (id, subjectid, studytypecode, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4479 (class 0 OID 41899)
-- Dependencies: 2525
-- Data for Name: subjectsubjectblock; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectsubjectblock (id, subjectid, subjectblockid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4480 (class 0 OID 41911)
-- Dependencies: 2527
-- Data for Name: subjectteacher; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY subjectteacher (id, staffmemberid, subjectid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4481 (class 0 OID 41923)
-- Dependencies: 2529
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
79	77	acc_room	roomTypeCode	Y	opuscollege	2012-10-02 18:07:04.815
80	78	acc_hostel	hostelTypeCode	Y	opuscollege	2012-10-02 18:07:04.815
\.


--
-- TOC entry 4482 (class 0 OID 41935)
-- Dependencies: 2531
-- Data for Name: targetgroup; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY targetgroup (id, code, lang, active, description, writewho, writewhen) FROM stdin;
13	1	en    	Y	all students	opuscollege	2010-11-02 16:22:58.674788
14	2	en    	Y	students from study	opuscollege	2010-11-02 16:22:58.674788
15	3	en    	Y	all international students	opuscollege	2010-11-02 16:22:58.674788
16	4	en    	Y	all national students	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4483 (class 0 OID 41947)
-- Dependencies: 2533
-- Data for Name: test; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY test (id, testcode, testdescription, examinationid, examinationtypecode, numberofattempts, weighingfactor, minimummark, maximummark, brspassingtest, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4484 (class 0 OID 41959)
-- Dependencies: 2535
-- Data for Name: testresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY testresult (id, testid, examinationid, studyplandetailid, testresultdate, attemptnr, mark, passed, staffmemberid, active, writewho, writewhen, examinationresultid) FROM stdin;
\.


--
-- TOC entry 4485 (class 0 OID 41973)
-- Dependencies: 2537
-- Data for Name: testteacher; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY testteacher (id, staffmemberid, testid, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4486 (class 0 OID 41985)
-- Dependencies: 2539
-- Data for Name: thesis; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY thesis (id, thesiscode, thesisdescription, thesiscontentdescription, studyplanid, creditamount, hourstoinvest, brsapplyingtothesis, brspassingthesis, keywords, researchers, supervisors, publications, readingcommittee, defensecommittee, statusofclearness, thesisstatusdate, startacademicyearid, affiliationfee, research, nonrelatedpublications, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4487 (class 0 OID 42000)
-- Dependencies: 2541
-- Data for Name: thesisresult; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY thesisresult (id, studyplanid, thesisresultdate, mark, active, passed, writewho, writewhen, thesisid) FROM stdin;
\.


--
-- TOC entry 4488 (class 0 OID 42015)
-- Dependencies: 2543
-- Data for Name: thesisstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY thesisstatus (id, code, lang, active, description, writewho, writewhen) FROM stdin;
1	1	en    	Y	admission requested	opuscollege	2010-08-24 15:14:52.551731
2	2	en    	Y	proposal cleared	opuscollege	2010-08-24 15:14:52.551731
3	3	en    	Y	thesis accepted	opuscollege	2010-08-24 15:14:52.551731
\.


--
-- TOC entry 4489 (class 0 OID 42027)
-- Dependencies: 2545
-- Data for Name: thesissupervisor; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY thesissupervisor (id, thesisid, name, address, telephone, email, principal, orderby, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4490 (class 0 OID 42040)
-- Dependencies: 2547
-- Data for Name: thesisthesisstatus; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY thesisthesisstatus (id, thesisid, startdate, thesisstatuscode, active, writewho, writewhen) FROM stdin;
\.


--
-- TOC entry 4491 (class 0 OID 42052)
-- Dependencies: 2549
-- Data for Name: timeunit; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY timeunit (id, code, lang, active, description, writewho, writewhen) FROM stdin;
74	1	en    	Y	semester 1	opuscollege	2010-11-02 16:22:58.674788
75	2	en    	Y	semester 2	opuscollege	2010-11-02 16:22:58.674788
76	3	en    	Y	trimester 1	opuscollege	2010-11-02 16:22:58.674788
77	4	en    	Y	trimester 2	opuscollege	2010-11-02 16:22:58.674788
78	5	en    	Y	trimester 3	opuscollege	2010-11-02 16:22:58.674788
79	6	en    	Y	semester 1 - block 1	opuscollege	2010-11-02 16:22:58.674788
80	7	en    	Y	semester 1 - block 2	opuscollege	2010-11-02 16:22:58.674788
81	8	en    	Y	semester 2 - block 1	opuscollege	2010-11-02 16:22:58.674788
82	9	en    	Y	semester 2 - block 2	opuscollege	2010-11-02 16:22:58.674788
83	10	en    	Y	yearly	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4492 (class 0 OID 42064)
-- Dependencies: 2551
-- Data for Name: unitarea; Type: TABLE DATA; Schema: opuscollege; Owner: postgres
--

COPY unitarea (id, code, lang, active, description, writewho, writewhen) FROM stdin;
5	1	en    	Y	Academic	opuscollege	2010-11-02 16:22:58.674788
6	2	en    	Y	Administrative	opuscollege	2010-11-02 16:22:58.674788
\.


--
-- TOC entry 4493 (class 0 OID 42076)
-- Dependencies: 2553
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
-- TOC entry 3729 (class 2606 OID 42094)
-- Dependencies: 2239 2239
-- Name: academicfield_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY academicfield
    ADD CONSTRAINT academicfield_id_key UNIQUE (id);


--
-- TOC entry 3731 (class 2606 OID 42096)
-- Dependencies: 2239 2239 2239
-- Name: academicfield_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY academicfield
    ADD CONSTRAINT academicfield_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3733 (class 2606 OID 42098)
-- Dependencies: 2241 2241
-- Name: academicyear_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY academicyear
    ADD CONSTRAINT academicyear_pkey PRIMARY KEY (id);


--
-- TOC entry 3735 (class 2606 OID 42100)
-- Dependencies: 2243 2243
-- Name: acc_accommodationfee_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_accommodationfee
    ADD CONSTRAINT acc_accommodationfee_pkey PRIMARY KEY (accommodationfeeid);


--
-- TOC entry 3737 (class 2606 OID 42102)
-- Dependencies: 2247 2247
-- Name: acc_block_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_block
    ADD CONSTRAINT acc_block_pkey PRIMARY KEY (id);


--
-- TOC entry 3739 (class 2606 OID 42104)
-- Dependencies: 2249 2249
-- Name: acc_hostel_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_hostel
    ADD CONSTRAINT acc_hostel_pkey PRIMARY KEY (id);


--
-- TOC entry 3742 (class 2606 OID 42106)
-- Dependencies: 2251 2251
-- Name: acc_hosteltype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_hosteltype
    ADD CONSTRAINT acc_hosteltype_pkey PRIMARY KEY (id);


--
-- TOC entry 3744 (class 2606 OID 42108)
-- Dependencies: 2253 2253
-- Name: acc_room_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_room
    ADD CONSTRAINT acc_room_pkey PRIMARY KEY (id);


--
-- TOC entry 3747 (class 2606 OID 42110)
-- Dependencies: 2255 2255
-- Name: acc_roomtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_roomtype
    ADD CONSTRAINT acc_roomtype_id_key UNIQUE (id);


--
-- TOC entry 3749 (class 2606 OID 42112)
-- Dependencies: 2255 2255 2255
-- Name: acc_roomtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_roomtype
    ADD CONSTRAINT acc_roomtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3753 (class 2606 OID 42114)
-- Dependencies: 2257 2257
-- Name: acc_studentaccommodation_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_studentaccommodation
    ADD CONSTRAINT acc_studentaccommodation_pkey PRIMARY KEY (id);


--
-- TOC entry 3755 (class 2606 OID 42116)
-- Dependencies: 2260 2260
-- Name: address_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- TOC entry 3757 (class 2606 OID 42118)
-- Dependencies: 2262 2262
-- Name: addresstype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY addresstype
    ADD CONSTRAINT addresstype_id_key UNIQUE (id);


--
-- TOC entry 3759 (class 2606 OID 42120)
-- Dependencies: 2262 2262 2262
-- Name: addresstype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY addresstype
    ADD CONSTRAINT addresstype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3761 (class 2606 OID 42122)
-- Dependencies: 2264 2264
-- Name: administrativepost_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY administrativepost
    ADD CONSTRAINT administrativepost_id_key UNIQUE (id);


--
-- TOC entry 3763 (class 2606 OID 42124)
-- Dependencies: 2264 2264 2264
-- Name: administrativepost_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY administrativepost
    ADD CONSTRAINT administrativepost_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3767 (class 2606 OID 42126)
-- Dependencies: 2268 2268 2268
-- Name: appconfig_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY appconfig
    ADD CONSTRAINT appconfig_pkey PRIMARY KEY (startdate, appconfigattributename);


--
-- TOC entry 3769 (class 2606 OID 42128)
-- Dependencies: 2270 2270
-- Name: applicantcategory_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY applicantcategory
    ADD CONSTRAINT applicantcategory_id_key UNIQUE (id);


--
-- TOC entry 3771 (class 2606 OID 42130)
-- Dependencies: 2270 2270 2270
-- Name: applicantcategory_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY applicantcategory
    ADD CONSTRAINT applicantcategory_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3773 (class 2606 OID 42132)
-- Dependencies: 2272 2272
-- Name: appointmenttype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY appointmenttype
    ADD CONSTRAINT appointmenttype_id_key UNIQUE (id);


--
-- TOC entry 3775 (class 2606 OID 42134)
-- Dependencies: 2272 2272 2272
-- Name: appointmenttype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY appointmenttype
    ADD CONSTRAINT appointmenttype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3777 (class 2606 OID 42136)
-- Dependencies: 2274 2274
-- Name: appversions_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY appversions
    ADD CONSTRAINT appversions_pkey PRIMARY KEY (id);


--
-- TOC entry 3779 (class 2606 OID 42138)
-- Dependencies: 2275 2275
-- Name: authorisation_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY authorisation
    ADD CONSTRAINT authorisation_pkey PRIMARY KEY (code);


--
-- TOC entry 3781 (class 2606 OID 42140)
-- Dependencies: 2277 2277
-- Name: blocktype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY blocktype
    ADD CONSTRAINT blocktype_id_key UNIQUE (id);


--
-- TOC entry 3783 (class 2606 OID 42142)
-- Dependencies: 2277 2277 2277
-- Name: blocktype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY blocktype
    ADD CONSTRAINT blocktype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3785 (class 2606 OID 42144)
-- Dependencies: 2279 2279
-- Name: bloodtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bloodtype
    ADD CONSTRAINT bloodtype_id_key UNIQUE (id);


--
-- TOC entry 3787 (class 2606 OID 42146)
-- Dependencies: 2279 2279 2279
-- Name: bloodtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bloodtype
    ADD CONSTRAINT bloodtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3789 (class 2606 OID 42148)
-- Dependencies: 2281 2281
-- Name: branch_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY branch
    ADD CONSTRAINT branch_pkey PRIMARY KEY (id);


--
-- TOC entry 3791 (class 2606 OID 42150)
-- Dependencies: 2283 2283
-- Name: cardinaltimeunit_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunit
    ADD CONSTRAINT cardinaltimeunit_id_key UNIQUE (id);


--
-- TOC entry 3793 (class 2606 OID 42152)
-- Dependencies: 2283 2283 2283
-- Name: cardinaltimeunit_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunit
    ADD CONSTRAINT cardinaltimeunit_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3795 (class 2606 OID 42154)
-- Dependencies: 2285 2285
-- Name: cardinaltimeunitresult_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunitresult
    ADD CONSTRAINT cardinaltimeunitresult_pkey PRIMARY KEY (id);


--
-- TOC entry 3797 (class 2606 OID 42156)
-- Dependencies: 2285 2285 2285
-- Name: cardinaltimeunitresult_studyplanid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunitresult
    ADD CONSTRAINT cardinaltimeunitresult_studyplanid_key UNIQUE (studyplanid, studyplancardinaltimeunitid);


--
-- TOC entry 3799 (class 2606 OID 42158)
-- Dependencies: 2287 2287
-- Name: cardinaltimeunitstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunitstatus
    ADD CONSTRAINT cardinaltimeunitstatus_id_key UNIQUE (id);


--
-- TOC entry 3801 (class 2606 OID 42160)
-- Dependencies: 2287 2287 2287
-- Name: cardinaltimeunitstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunitstatus
    ADD CONSTRAINT cardinaltimeunitstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3803 (class 2606 OID 42162)
-- Dependencies: 2289 2289
-- Name: cardinaltimeunitstudygradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardinaltimeunitstudygradetype
    ADD CONSTRAINT cardinaltimeunitstudygradetype_pkey PRIMARY KEY (id);


--
-- TOC entry 3805 (class 2606 OID 42164)
-- Dependencies: 2291 2291
-- Name: careerposition_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY careerposition
    ADD CONSTRAINT careerposition_pkey PRIMARY KEY (id);


--
-- TOC entry 3807 (class 2606 OID 42166)
-- Dependencies: 2293 2293
-- Name: civilstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY civilstatus
    ADD CONSTRAINT civilstatus_id_key UNIQUE (id);


--
-- TOC entry 3809 (class 2606 OID 42168)
-- Dependencies: 2293 2293 2293
-- Name: civilstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY civilstatus
    ADD CONSTRAINT civilstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3811 (class 2606 OID 42170)
-- Dependencies: 2295 2295
-- Name: civiltitle_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY civiltitle
    ADD CONSTRAINT civiltitle_id_key UNIQUE (id);


--
-- TOC entry 3813 (class 2606 OID 42172)
-- Dependencies: 2295 2295 2295
-- Name: civiltitle_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY civiltitle
    ADD CONSTRAINT civiltitle_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4084 (class 2606 OID 42174)
-- Dependencies: 2458 2458
-- Name: code_unique_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY secondaryschoolsubject
    ADD CONSTRAINT code_unique_key UNIQUE (code);


--
-- TOC entry 3815 (class 2606 OID 42176)
-- Dependencies: 2297 2297
-- Name: contract_contractcode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT contract_contractcode_key UNIQUE (contractcode);


--
-- TOC entry 3817 (class 2606 OID 42178)
-- Dependencies: 2297 2297
-- Name: contract_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (id);


--
-- TOC entry 3819 (class 2606 OID 42180)
-- Dependencies: 2299 2299
-- Name: contractduration_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contractduration
    ADD CONSTRAINT contractduration_id_key UNIQUE (id);


--
-- TOC entry 3821 (class 2606 OID 42182)
-- Dependencies: 2299 2299 2299
-- Name: contractduration_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contractduration
    ADD CONSTRAINT contractduration_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3823 (class 2606 OID 42184)
-- Dependencies: 2301 2301
-- Name: contracttype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contracttype
    ADD CONSTRAINT contracttype_id_key UNIQUE (id);


--
-- TOC entry 3825 (class 2606 OID 42186)
-- Dependencies: 2301 2301 2301
-- Name: contracttype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contracttype
    ADD CONSTRAINT contracttype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3827 (class 2606 OID 42188)
-- Dependencies: 2303 2303
-- Name: country_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_id_key UNIQUE (id);


--
-- TOC entry 3829 (class 2606 OID 42190)
-- Dependencies: 2303 2303 2303
-- Name: country_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3831 (class 2606 OID 42192)
-- Dependencies: 2305 2305
-- Name: daypart_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY daypart
    ADD CONSTRAINT daypart_id_key UNIQUE (id);


--
-- TOC entry 3833 (class 2606 OID 42194)
-- Dependencies: 2305 2305 2305
-- Name: daypart_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY daypart
    ADD CONSTRAINT daypart_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3835 (class 2606 OID 42196)
-- Dependencies: 2307 2307
-- Name: discipline_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discipline
    ADD CONSTRAINT discipline_id_key UNIQUE (id);


--
-- TOC entry 3837 (class 2606 OID 42198)
-- Dependencies: 2307 2307 2307
-- Name: discipline_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discipline
    ADD CONSTRAINT discipline_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3839 (class 2606 OID 42200)
-- Dependencies: 2309 2309
-- Name: disciplinegroup_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY disciplinegroup
    ADD CONSTRAINT disciplinegroup_id_key UNIQUE (id);


--
-- TOC entry 3841 (class 2606 OID 42202)
-- Dependencies: 2311 2311
-- Name: district_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY district
    ADD CONSTRAINT district_id_key UNIQUE (id);


--
-- TOC entry 3843 (class 2606 OID 42204)
-- Dependencies: 2311 2311 2311
-- Name: district_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY district
    ADD CONSTRAINT district_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3845 (class 2606 OID 42206)
-- Dependencies: 2313 2313
-- Name: educationtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY educationtype
    ADD CONSTRAINT educationtype_id_key UNIQUE (id);


--
-- TOC entry 3847 (class 2606 OID 42208)
-- Dependencies: 2313 2313 2313
-- Name: educationtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY educationtype
    ADD CONSTRAINT educationtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3849 (class 2606 OID 42210)
-- Dependencies: 2315 2315
-- Name: endgrade_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY endgrade
    ADD CONSTRAINT endgrade_pkey PRIMARY KEY (id);


--
-- TOC entry 3853 (class 2606 OID 42212)
-- Dependencies: 2317 2317
-- Name: endgradegeneral_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY endgradegeneral
    ADD CONSTRAINT endgradegeneral_pkey PRIMARY KEY (id);


--
-- TOC entry 3855 (class 2606 OID 42214)
-- Dependencies: 2319 2319
-- Name: endgradetype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY endgradetype
    ADD CONSTRAINT endgradetype_id_key UNIQUE (id);


--
-- TOC entry 3857 (class 2606 OID 42216)
-- Dependencies: 2319 2319 2319
-- Name: endgradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY endgradetype
    ADD CONSTRAINT endgradetype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4158 (class 2606 OID 42218)
-- Dependencies: 2503 2503
-- Name: exam_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplanresult
    ADD CONSTRAINT exam_pkey PRIMARY KEY (id);


--
-- TOC entry 4160 (class 2606 OID 42220)
-- Dependencies: 2503 2503
-- Name: exam_studyplanid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplanresult
    ADD CONSTRAINT exam_studyplanid_key UNIQUE (studyplanid);


--
-- TOC entry 3859 (class 2606 OID 42222)
-- Dependencies: 2322 2322
-- Name: examination_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examination
    ADD CONSTRAINT examination_pkey PRIMARY KEY (id);


--
-- TOC entry 3861 (class 2606 OID 42224)
-- Dependencies: 2324 2324 2324 2324 2324 2324
-- Name: examinationresult_examinationattemptnr_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_examinationattemptnr_key UNIQUE (examinationid, subjectid, subjectresultid, studyplandetailid, attemptnr);


--
-- TOC entry 3863 (class 2606 OID 42226)
-- Dependencies: 2324 2324
-- Name: examinationresult_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_pkey PRIMARY KEY (id);


--
-- TOC entry 3865 (class 2606 OID 42228)
-- Dependencies: 2326 2326
-- Name: examinationteacher_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationteacher
    ADD CONSTRAINT examinationteacher_pkey PRIMARY KEY (id);


--
-- TOC entry 3867 (class 2606 OID 42230)
-- Dependencies: 2326 2326 2326
-- Name: examinationteacher_staffmemberid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationteacher
    ADD CONSTRAINT examinationteacher_staffmemberid_key UNIQUE (staffmemberid, examinationid);


--
-- TOC entry 3869 (class 2606 OID 42232)
-- Dependencies: 2328 2328
-- Name: examinationtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationtype
    ADD CONSTRAINT examinationtype_id_key UNIQUE (id);


--
-- TOC entry 3871 (class 2606 OID 42234)
-- Dependencies: 2328 2328 2328
-- Name: examinationtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examinationtype
    ADD CONSTRAINT examinationtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3873 (class 2606 OID 42236)
-- Dependencies: 2331 2331
-- Name: examtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examtype
    ADD CONSTRAINT examtype_id_key UNIQUE (id);


--
-- TOC entry 3875 (class 2606 OID 42238)
-- Dependencies: 2331 2331 2331
-- Name: examtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY examtype
    ADD CONSTRAINT examtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3877 (class 2606 OID 42240)
-- Dependencies: 2333 2333
-- Name: expellationtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY expellationtype
    ADD CONSTRAINT expellationtype_id_key UNIQUE (id);


--
-- TOC entry 3879 (class 2606 OID 42242)
-- Dependencies: 2333 2333 2333
-- Name: expellationtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY expellationtype
    ADD CONSTRAINT expellationtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3881 (class 2606 OID 42244)
-- Dependencies: 2335 2335
-- Name: failgrade_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY failgrade
    ADD CONSTRAINT failgrade_pkey PRIMARY KEY (id);


--
-- TOC entry 3883 (class 2606 OID 42246)
-- Dependencies: 2337 2337
-- Name: fee_fee_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_fee
    ADD CONSTRAINT fee_fee_pkey PRIMARY KEY (id);


--
-- TOC entry 3885 (class 2606 OID 42248)
-- Dependencies: 2339 2339
-- Name: fee_feecategory_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_feecategory
    ADD CONSTRAINT fee_feecategory_id_key UNIQUE (id);


--
-- TOC entry 3887 (class 2606 OID 42250)
-- Dependencies: 2339 2339 2339
-- Name: fee_feecategory_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_feecategory
    ADD CONSTRAINT fee_feecategory_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3889 (class 2606 OID 42252)
-- Dependencies: 2341 2341
-- Name: fee_feedeadline_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_feedeadline
    ADD CONSTRAINT fee_feedeadline_pkey PRIMARY KEY (id);


--
-- TOC entry 3891 (class 2606 OID 42254)
-- Dependencies: 2341 2341 2341
-- Name: fee_feedeadline_unique_fee_deadline; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_feedeadline
    ADD CONSTRAINT fee_feedeadline_unique_fee_deadline UNIQUE (feeid, deadline);


--
-- TOC entry 3893 (class 2606 OID 42256)
-- Dependencies: 2341 2341 2341 2341
-- Name: fee_feedeadline_uq_unit; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_feedeadline
    ADD CONSTRAINT fee_feedeadline_uq_unit UNIQUE (cardinaltimeunitcode, cardinaltimeunitnumber, feeid);


--
-- TOC entry 3895 (class 2606 OID 42258)
-- Dependencies: 2343 2343
-- Name: fee_payment_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_payment
    ADD CONSTRAINT fee_payment_pkey PRIMARY KEY (id);


--
-- TOC entry 3897 (class 2606 OID 42260)
-- Dependencies: 2345 2345
-- Name: fee_unit_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_unit
    ADD CONSTRAINT fee_unit_id_key UNIQUE (id);


--
-- TOC entry 3899 (class 2606 OID 42262)
-- Dependencies: 2345 2345 2345
-- Name: fee_unit_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fee_unit
    ADD CONSTRAINT fee_unit_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3901 (class 2606 OID 42264)
-- Dependencies: 2347 2347
-- Name: fieldofeducation_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fieldofeducation
    ADD CONSTRAINT fieldofeducation_id_key UNIQUE (id);


--
-- TOC entry 3903 (class 2606 OID 42266)
-- Dependencies: 2347 2347 2347
-- Name: fieldofeducation_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fieldofeducation
    ADD CONSTRAINT fieldofeducation_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3905 (class 2606 OID 42268)
-- Dependencies: 2349 2349
-- Name: financialrequest_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY financialrequest
    ADD CONSTRAINT financialrequest_pkey PRIMARY KEY (id);


--
-- TOC entry 3907 (class 2606 OID 42270)
-- Dependencies: 2351 2351
-- Name: financialtransaction_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY financialtransaction
    ADD CONSTRAINT financialtransaction_pkey PRIMARY KEY (id);


--
-- TOC entry 4063 (class 2606 OID 42272)
-- Dependencies: 2444 2444
-- Name: fk_sponsorcode; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsor
    ADD CONSTRAINT fk_sponsorcode UNIQUE (code);


--
-- TOC entry 3909 (class 2606 OID 42274)
-- Dependencies: 2353 2353
-- Name: frequency_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY frequency
    ADD CONSTRAINT frequency_id_key UNIQUE (id);


--
-- TOC entry 3911 (class 2606 OID 42276)
-- Dependencies: 2353 2353 2353
-- Name: frequency_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY frequency
    ADD CONSTRAINT frequency_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3913 (class 2606 OID 42278)
-- Dependencies: 2355 2355
-- Name: function_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY function
    ADD CONSTRAINT function_id_key UNIQUE (id);


--
-- TOC entry 3915 (class 2606 OID 42280)
-- Dependencies: 2355 2355 2355
-- Name: function_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY function
    ADD CONSTRAINT function_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3917 (class 2606 OID 42282)
-- Dependencies: 2357 2357
-- Name: functionlevel_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY functionlevel
    ADD CONSTRAINT functionlevel_id_key UNIQUE (id);


--
-- TOC entry 3919 (class 2606 OID 42284)
-- Dependencies: 2357 2357 2357
-- Name: functionlevel_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY functionlevel
    ADD CONSTRAINT functionlevel_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3921 (class 2606 OID 42286)
-- Dependencies: 2359 2359
-- Name: gender_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gender
    ADD CONSTRAINT gender_id_key UNIQUE (id);


--
-- TOC entry 3923 (class 2606 OID 42288)
-- Dependencies: 2359 2359 2359
-- Name: gender_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gender
    ADD CONSTRAINT gender_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3925 (class 2606 OID 42290)
-- Dependencies: 2361 2361
-- Name: gradedsecondaryschoolsubject_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gradedsecondaryschoolsubject
    ADD CONSTRAINT gradedsecondaryschoolsubject_pkey PRIMARY KEY (id);


--
-- TOC entry 3927 (class 2606 OID 42292)
-- Dependencies: 2361 2361 2361
-- Name: gradedsecondaryschoolsubject_secondaryschoolsubjectid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gradedsecondaryschoolsubject
    ADD CONSTRAINT gradedsecondaryschoolsubject_secondaryschoolsubjectid_key UNIQUE (secondaryschoolsubjectid, studyplanid);


--
-- TOC entry 3929 (class 2606 OID 42294)
-- Dependencies: 2363 2363
-- Name: gradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gradetype
    ADD CONSTRAINT gradetype_pkey PRIMARY KEY (id);


--
-- TOC entry 3931 (class 2606 OID 42296)
-- Dependencies: 2365 2365
-- Name: groupeddiscipline_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groupeddiscipline
    ADD CONSTRAINT groupeddiscipline_pkey PRIMARY KEY (id);


--
-- TOC entry 3935 (class 2606 OID 42298)
-- Dependencies: 2367 2367
-- Name: groupedsecondaryschoolsubject_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groupedsecondaryschoolsubject
    ADD CONSTRAINT groupedsecondaryschoolsubject_pkey PRIMARY KEY (id);


--
-- TOC entry 3937 (class 2606 OID 42300)
-- Dependencies: 2367 2367 2367
-- Name: groupedsecondaryschoolsubject_secondaryschoolsubjectid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groupedsecondaryschoolsubject
    ADD CONSTRAINT groupedsecondaryschoolsubject_secondaryschoolsubjectid_key UNIQUE (secondaryschoolsubjectid, secondaryschoolsubjectgroupid);


--
-- TOC entry 3939 (class 2606 OID 42302)
-- Dependencies: 2369 2369
-- Name: identificationtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY identificationtype
    ADD CONSTRAINT identificationtype_id_key UNIQUE (id);


--
-- TOC entry 3941 (class 2606 OID 42304)
-- Dependencies: 2369 2369 2369
-- Name: identificationtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY identificationtype
    ADD CONSTRAINT identificationtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3947 (class 2606 OID 42306)
-- Dependencies: 2373 2373
-- Name: institution_institutioncode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY institution
    ADD CONSTRAINT institution_institutioncode_key UNIQUE (institutioncode);


--
-- TOC entry 3949 (class 2606 OID 42308)
-- Dependencies: 2373 2373
-- Name: institution_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY institution
    ADD CONSTRAINT institution_pkey PRIMARY KEY (id);


--
-- TOC entry 3951 (class 2606 OID 42310)
-- Dependencies: 2375 2375
-- Name: language_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY language
    ADD CONSTRAINT language_id_key UNIQUE (id);


--
-- TOC entry 3953 (class 2606 OID 42312)
-- Dependencies: 2375 2375 2375
-- Name: language_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY language
    ADD CONSTRAINT language_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3955 (class 2606 OID 42314)
-- Dependencies: 2377 2377
-- Name: levelofeducation_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY levelofeducation
    ADD CONSTRAINT levelofeducation_id_key UNIQUE (id);


--
-- TOC entry 3957 (class 2606 OID 42316)
-- Dependencies: 2377 2377 2377
-- Name: levelofeducation_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY levelofeducation
    ADD CONSTRAINT levelofeducation_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3959 (class 2606 OID 42318)
-- Dependencies: 2379 2379
-- Name: logmailerror_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY logmailerror
    ADD CONSTRAINT logmailerror_pkey PRIMARY KEY (id);


--
-- TOC entry 3961 (class 2606 OID 42320)
-- Dependencies: 2381 2381
-- Name: logrequesterror_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY logrequesterror
    ADD CONSTRAINT logrequesterror_pkey PRIMARY KEY (id);


--
-- TOC entry 3963 (class 2606 OID 42322)
-- Dependencies: 2383 2383
-- Name: lookuptable_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lookuptable
    ADD CONSTRAINT lookuptable_pkey PRIMARY KEY (id);


--
-- TOC entry 3966 (class 2606 OID 42324)
-- Dependencies: 2385 2385
-- Name: mailconfig_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mailconfig
    ADD CONSTRAINT mailconfig_pkey PRIMARY KEY (id);


--
-- TOC entry 3968 (class 2606 OID 42326)
-- Dependencies: 2387 2387
-- Name: masteringlevel_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY masteringlevel
    ADD CONSTRAINT masteringlevel_id_key UNIQUE (id);


--
-- TOC entry 3970 (class 2606 OID 42328)
-- Dependencies: 2387 2387 2387
-- Name: masteringlevel_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY masteringlevel
    ADD CONSTRAINT masteringlevel_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3972 (class 2606 OID 42330)
-- Dependencies: 2389 2389
-- Name: nationality_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nationality
    ADD CONSTRAINT nationality_id_key UNIQUE (id);


--
-- TOC entry 3974 (class 2606 OID 42332)
-- Dependencies: 2389 2389 2389
-- Name: nationality_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nationality
    ADD CONSTRAINT nationality_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3976 (class 2606 OID 42334)
-- Dependencies: 2391 2391
-- Name: nationalitygroup_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nationalitygroup
    ADD CONSTRAINT nationalitygroup_id_key UNIQUE (id);


--
-- TOC entry 3978 (class 2606 OID 42336)
-- Dependencies: 2391 2391 2391
-- Name: nationalitygroup_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nationalitygroup
    ADD CONSTRAINT nationalitygroup_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3980 (class 2606 OID 42338)
-- Dependencies: 2393 2393
-- Name: obtainedqualification_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY obtainedqualification
    ADD CONSTRAINT obtainedqualification_pkey PRIMARY KEY (id);


--
-- TOC entry 3982 (class 2606 OID 42340)
-- Dependencies: 2395 2395
-- Name: opusprivilege_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opusprivilege
    ADD CONSTRAINT opusprivilege_id_key UNIQUE (id);


--
-- TOC entry 3984 (class 2606 OID 42342)
-- Dependencies: 2395 2395 2395
-- Name: opusprivilege_lang_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opusprivilege
    ADD CONSTRAINT opusprivilege_lang_key UNIQUE (lang, code);


--
-- TOC entry 3986 (class 2606 OID 42344)
-- Dependencies: 2395 2395 2395
-- Name: opusprivilege_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opusprivilege
    ADD CONSTRAINT opusprivilege_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3988 (class 2606 OID 42346)
-- Dependencies: 2397 2397
-- Name: opusrole_privilege_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opusrole_privilege
    ADD CONSTRAINT opusrole_privilege_pkey PRIMARY KEY (id);


--
-- TOC entry 3993 (class 2606 OID 42348)
-- Dependencies: 2399 2399
-- Name: opususer_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opususer
    ADD CONSTRAINT opususer_pkey PRIMARY KEY (id);


--
-- TOC entry 3995 (class 2606 OID 42350)
-- Dependencies: 2399 2399
-- Name: opususer_username_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opususer
    ADD CONSTRAINT opususer_username_key UNIQUE (username);


--
-- TOC entry 3997 (class 2606 OID 42352)
-- Dependencies: 2401 2401
-- Name: opususerrole_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opususerrole
    ADD CONSTRAINT opususerrole_pkey PRIMARY KEY (id);


--
-- TOC entry 3725 (class 2606 OID 42354)
-- Dependencies: 2211 2211
-- Name: organizationalunit_organizationalunitcode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY organizationalunit
    ADD CONSTRAINT organizationalunit_organizationalunitcode_key UNIQUE (organizationalunitcode);


--
-- TOC entry 3727 (class 2606 OID 42356)
-- Dependencies: 2211 2211
-- Name: organizationalunit_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY organizationalunit
    ADD CONSTRAINT organizationalunit_pkey PRIMARY KEY (id);


--
-- TOC entry 3765 (class 2606 OID 42358)
-- Dependencies: 2266 2266 2266
-- Name: organizationalunitacademicyear_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY admissionregistrationconfig
    ADD CONSTRAINT organizationalunitacademicyear_pkey PRIMARY KEY (organizationalunitid, academicyearid);


--
-- TOC entry 4001 (class 2606 OID 42360)
-- Dependencies: 2403 2403
-- Name: penalty_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY penalty
    ADD CONSTRAINT penalty_pkey PRIMARY KEY (id);


--
-- TOC entry 4003 (class 2606 OID 42362)
-- Dependencies: 2405 2405
-- Name: penaltytype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY penaltytype
    ADD CONSTRAINT penaltytype_id_key UNIQUE (id);


--
-- TOC entry 4005 (class 2606 OID 42364)
-- Dependencies: 2405 2405 2405
-- Name: penaltytype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY penaltytype
    ADD CONSTRAINT penaltytype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4007 (class 2606 OID 42366)
-- Dependencies: 2407 2407
-- Name: person_personcode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_personcode_key UNIQUE (personcode);


--
-- TOC entry 4009 (class 2606 OID 42368)
-- Dependencies: 2407 2407
-- Name: person_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- TOC entry 4086 (class 2606 OID 42370)
-- Dependencies: 2458 2458
-- Name: primary_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY secondaryschoolsubject
    ADD CONSTRAINT primary_key PRIMARY KEY (id);


--
-- TOC entry 4011 (class 2606 OID 42372)
-- Dependencies: 2409 2409
-- Name: profession_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY profession
    ADD CONSTRAINT profession_id_key UNIQUE (id);


--
-- TOC entry 4013 (class 2606 OID 42374)
-- Dependencies: 2409 2409 2409
-- Name: profession_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY profession
    ADD CONSTRAINT profession_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4015 (class 2606 OID 42376)
-- Dependencies: 2411 2411
-- Name: progressstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY progressstatus
    ADD CONSTRAINT progressstatus_id_key UNIQUE (id);


--
-- TOC entry 4017 (class 2606 OID 42378)
-- Dependencies: 2411 2411 2411
-- Name: progressstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY progressstatus
    ADD CONSTRAINT progressstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4019 (class 2606 OID 42380)
-- Dependencies: 2413 2413
-- Name: province_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY province
    ADD CONSTRAINT province_id_key UNIQUE (id);


--
-- TOC entry 4021 (class 2606 OID 42382)
-- Dependencies: 2413 2413 2413
-- Name: province_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY province
    ADD CONSTRAINT province_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4023 (class 2606 OID 42384)
-- Dependencies: 2415 2415
-- Name: referee_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY referee
    ADD CONSTRAINT referee_pkey PRIMARY KEY (id);


--
-- TOC entry 4025 (class 2606 OID 42386)
-- Dependencies: 2417 2417
-- Name: relationtype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY relationtype
    ADD CONSTRAINT relationtype_id_key UNIQUE (id);


--
-- TOC entry 4027 (class 2606 OID 42388)
-- Dependencies: 2417 2417 2417
-- Name: relationtype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY relationtype
    ADD CONSTRAINT relationtype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4029 (class 2606 OID 42390)
-- Dependencies: 2419 2419
-- Name: reportproperty_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY reportproperty
    ADD CONSTRAINT reportproperty_pkey PRIMARY KEY (id);


--
-- TOC entry 4031 (class 2606 OID 42392)
-- Dependencies: 2419 2419 2419
-- Name: reportproperty_reportname_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY reportproperty
    ADD CONSTRAINT reportproperty_reportname_key UNIQUE (reportname, propertyname);


--
-- TOC entry 4033 (class 2606 OID 42394)
-- Dependencies: 2420 2420 2420 2420
-- Name: requestadmissionperiod_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY requestadmissionperiod
    ADD CONSTRAINT requestadmissionperiod_pkey PRIMARY KEY (startdate, enddate, academicyearid);


--
-- TOC entry 4035 (class 2606 OID 42396)
-- Dependencies: 2422 2422
-- Name: requestforchange_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY requestforchange
    ADD CONSTRAINT requestforchange_pkey PRIMARY KEY (id);


--
-- TOC entry 4037 (class 2606 OID 42398)
-- Dependencies: 2424 2424
-- Name: rfcstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rfcstatus
    ADD CONSTRAINT rfcstatus_id_key UNIQUE (id);


--
-- TOC entry 4039 (class 2606 OID 42400)
-- Dependencies: 2424 2424 2424
-- Name: rfcstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rfcstatus
    ADD CONSTRAINT rfcstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4041 (class 2606 OID 42402)
-- Dependencies: 2426 2426
-- Name: rigiditytype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rigiditytype
    ADD CONSTRAINT rigiditytype_id_key UNIQUE (id);


--
-- TOC entry 4043 (class 2606 OID 42404)
-- Dependencies: 2426 2426 2426
-- Name: rigiditytype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rigiditytype
    ADD CONSTRAINT rigiditytype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4045 (class 2606 OID 42406)
-- Dependencies: 2428 2428 2428
-- Name: role_lang_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_lang_key UNIQUE (lang, role);


--
-- TOC entry 4047 (class 2606 OID 42408)
-- Dependencies: 2428 2428
-- Name: role_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- TOC entry 4049 (class 2606 OID 42410)
-- Dependencies: 2430 2430
-- Name: sch_bank_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_bank
    ADD CONSTRAINT sch_bank_pkey PRIMARY KEY (code);


--
-- TOC entry 4051 (class 2606 OID 42412)
-- Dependencies: 2432 2432
-- Name: sch_complaint_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_complaint
    ADD CONSTRAINT sch_complaint_pkey PRIMARY KEY (id);


--
-- TOC entry 4053 (class 2606 OID 42414)
-- Dependencies: 2434 2434
-- Name: sch_complaintstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_complaintstatus
    ADD CONSTRAINT sch_complaintstatus_pkey PRIMARY KEY (id);


--
-- TOC entry 4055 (class 2606 OID 42416)
-- Dependencies: 2436 2436
-- Name: sch_decisioncriteria_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_decisioncriteria
    ADD CONSTRAINT sch_decisioncriteria_pkey PRIMARY KEY (id);


--
-- TOC entry 4059 (class 2606 OID 42418)
-- Dependencies: 2440 2440
-- Name: sch_scholarship_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_scholarshipapplication
    ADD CONSTRAINT sch_scholarship_pkey PRIMARY KEY (id);


--
-- TOC entry 4061 (class 2606 OID 42420)
-- Dependencies: 2442 2442
-- Name: sch_scholarshiptype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_scholarshiptype
    ADD CONSTRAINT sch_scholarshiptype_pkey PRIMARY KEY (id);


--
-- TOC entry 4057 (class 2606 OID 42422)
-- Dependencies: 2438 2438
-- Name: sch_scholarshiptypeyear_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_scholarship
    ADD CONSTRAINT sch_scholarshiptypeyear_pkey PRIMARY KEY (id);


--
-- TOC entry 4065 (class 2606 OID 42424)
-- Dependencies: 2444 2444
-- Name: sch_sponsor_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsor
    ADD CONSTRAINT sch_sponsor_pkey PRIMARY KEY (id);


--
-- TOC entry 4068 (class 2606 OID 42426)
-- Dependencies: 2446 2446
-- Name: sch_sponsorfeepercentage_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsorfeepercentage
    ADD CONSTRAINT sch_sponsorfeepercentage_pkey PRIMARY KEY (id);


--
-- TOC entry 4072 (class 2606 OID 42428)
-- Dependencies: 2448 2448
-- Name: sch_sponsorpayment_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsorpayment
    ADD CONSTRAINT sch_sponsorpayment_pkey PRIMARY KEY (id);


--
-- TOC entry 4074 (class 2606 OID 42430)
-- Dependencies: 2450 2450
-- Name: sch_sponsortype_code_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsortype
    ADD CONSTRAINT sch_sponsortype_code_key UNIQUE (code);


--
-- TOC entry 4076 (class 2606 OID 42432)
-- Dependencies: 2450 2450
-- Name: sch_sponsortype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsortype
    ADD CONSTRAINT sch_sponsortype_pkey PRIMARY KEY (id);


--
-- TOC entry 4078 (class 2606 OID 42434)
-- Dependencies: 2452 2452
-- Name: sch_student_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_student
    ADD CONSTRAINT sch_student_pkey PRIMARY KEY (scholarshipstudentid);


--
-- TOC entry 4080 (class 2606 OID 42436)
-- Dependencies: 2454 2454
-- Name: sch_subsidy_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_subsidy
    ADD CONSTRAINT sch_subsidy_pkey PRIMARY KEY (id);


--
-- TOC entry 4082 (class 2606 OID 42438)
-- Dependencies: 2456 2456
-- Name: sch_subsidytype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_subsidytype
    ADD CONSTRAINT sch_subsidytype_pkey PRIMARY KEY (id);


--
-- TOC entry 4088 (class 2606 OID 42440)
-- Dependencies: 2458 2458
-- Name: secondaryschoolsubject_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY secondaryschoolsubject
    ADD CONSTRAINT secondaryschoolsubject_id_key UNIQUE (id);


--
-- TOC entry 4090 (class 2606 OID 42442)
-- Dependencies: 2460 2460 2460
-- Name: secondaryschoolsubjectgroup_groupnumber_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY secondaryschoolsubjectgroup
    ADD CONSTRAINT secondaryschoolsubjectgroup_groupnumber_key UNIQUE (groupnumber, studygradetypeid);


--
-- TOC entry 4092 (class 2606 OID 42444)
-- Dependencies: 2460 2460
-- Name: secondaryschoolsubjectgroup_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY secondaryschoolsubjectgroup
    ADD CONSTRAINT secondaryschoolsubjectgroup_pkey PRIMARY KEY (id);


--
-- TOC entry 4094 (class 2606 OID 42446)
-- Dependencies: 2462 2462
-- Name: staffmember_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY staffmember
    ADD CONSTRAINT staffmember_pkey PRIMARY KEY (staffmemberid);


--
-- TOC entry 4096 (class 2606 OID 42448)
-- Dependencies: 2462 2462
-- Name: staffmember_staffmembercode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY staffmember
    ADD CONSTRAINT staffmember_staffmembercode_key UNIQUE (staffmembercode);


--
-- TOC entry 4098 (class 2606 OID 42450)
-- Dependencies: 2463 2463 2463
-- Name: staffmemberfunction_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY staffmemberfunction
    ADD CONSTRAINT staffmemberfunction_pkey PRIMARY KEY (staffmemberid, functioncode);


--
-- TOC entry 4100 (class 2606 OID 42452)
-- Dependencies: 2465 2465
-- Name: stafftype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stafftype
    ADD CONSTRAINT stafftype_id_key UNIQUE (id);


--
-- TOC entry 4102 (class 2606 OID 42454)
-- Dependencies: 2465 2465 2465
-- Name: stafftype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stafftype
    ADD CONSTRAINT stafftype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4104 (class 2606 OID 42456)
-- Dependencies: 2467 2467
-- Name: status_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY status
    ADD CONSTRAINT status_id_key UNIQUE (id);


--
-- TOC entry 4106 (class 2606 OID 42458)
-- Dependencies: 2467 2467 2467
-- Name: status_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4108 (class 2606 OID 42460)
-- Dependencies: 2469 2469
-- Name: student_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY student
    ADD CONSTRAINT student_pkey PRIMARY KEY (studentid);


--
-- TOC entry 4110 (class 2606 OID 42462)
-- Dependencies: 2469 2469
-- Name: student_studentcode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY student
    ADD CONSTRAINT student_studentcode_key UNIQUE (studentcode);


--
-- TOC entry 4112 (class 2606 OID 42464)
-- Dependencies: 2471 2471
-- Name: studentabsence_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentabsence
    ADD CONSTRAINT studentabsence_pkey PRIMARY KEY (id);


--
-- TOC entry 4114 (class 2606 OID 42466)
-- Dependencies: 2471 2471 2471
-- Name: studentabsence_startdatetemporaryinactivity_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentabsence
    ADD CONSTRAINT studentabsence_startdatetemporaryinactivity_key UNIQUE (startdatetemporaryinactivity, enddatetemporaryinactivity);


--
-- TOC entry 4116 (class 2606 OID 42468)
-- Dependencies: 2473 2473
-- Name: studentactivity_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentactivity
    ADD CONSTRAINT studentactivity_pkey PRIMARY KEY (id);


--
-- TOC entry 4118 (class 2606 OID 42470)
-- Dependencies: 2475 2475
-- Name: studentbalance_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentbalance
    ADD CONSTRAINT studentbalance_pkey PRIMARY KEY (id);


--
-- TOC entry 4120 (class 2606 OID 42472)
-- Dependencies: 2477 2477
-- Name: studentcareer_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentcareer
    ADD CONSTRAINT studentcareer_pkey PRIMARY KEY (id);


--
-- TOC entry 4122 (class 2606 OID 42474)
-- Dependencies: 2479 2479
-- Name: studentcounseling_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentcounseling
    ADD CONSTRAINT studentcounseling_pkey PRIMARY KEY (id);


--
-- TOC entry 4124 (class 2606 OID 42476)
-- Dependencies: 2481 2481
-- Name: studentexpulsion_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentexpulsion
    ADD CONSTRAINT studentexpulsion_pkey PRIMARY KEY (id);


--
-- TOC entry 4126 (class 2606 OID 42478)
-- Dependencies: 2481 2481 2481
-- Name: studentexpulsion_startdate_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentexpulsion
    ADD CONSTRAINT studentexpulsion_startdate_key UNIQUE (startdate, enddate);


--
-- TOC entry 4128 (class 2606 OID 42480)
-- Dependencies: 2483 2483
-- Name: studentplacement_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentplacement
    ADD CONSTRAINT studentplacement_pkey PRIMARY KEY (id);


--
-- TOC entry 4130 (class 2606 OID 42482)
-- Dependencies: 2485 2485
-- Name: studentstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentstatus
    ADD CONSTRAINT studentstatus_id_key UNIQUE (id);


--
-- TOC entry 4132 (class 2606 OID 42484)
-- Dependencies: 2485 2485 2485
-- Name: studentstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentstatus
    ADD CONSTRAINT studentstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4134 (class 2606 OID 42486)
-- Dependencies: 2487 2487
-- Name: studentstudentstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studentstudentstatus
    ADD CONSTRAINT studentstudentstatus_pkey PRIMARY KEY (id);


--
-- TOC entry 4142 (class 2606 OID 42488)
-- Dependencies: 2493 2493 2493 2493 2493 2493 2493
-- Name: study_gradetype_studyform_studytime_studyintensity_academicyear; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studygradetype
    ADD CONSTRAINT study_gradetype_studyform_studytime_studyintensity_academicyear UNIQUE (studyid, gradetypecode, studyformcode, studytimecode, studyintensitycode, currentacademicyearid);


--
-- TOC entry 4136 (class 2606 OID 42490)
-- Dependencies: 2489 2489
-- Name: study_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY study
    ADD CONSTRAINT study_pkey PRIMARY KEY (id);


--
-- TOC entry 4138 (class 2606 OID 42492)
-- Dependencies: 2491 2491
-- Name: studyform_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyform
    ADD CONSTRAINT studyform_id_key UNIQUE (id);


--
-- TOC entry 4140 (class 2606 OID 42494)
-- Dependencies: 2491 2491 2491
-- Name: studyform_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyform
    ADD CONSTRAINT studyform_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4144 (class 2606 OID 42496)
-- Dependencies: 2493 2493
-- Name: studygradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studygradetype
    ADD CONSTRAINT studygradetype_pkey PRIMARY KEY (id);


--
-- TOC entry 4146 (class 2606 OID 42498)
-- Dependencies: 2494 2494 2494
-- Name: studygradetypeprerequisite_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studygradetypeprerequisite
    ADD CONSTRAINT studygradetypeprerequisite_pkey PRIMARY KEY (studygradetypeid, requiredstudygradetypeid);


--
-- TOC entry 4148 (class 2606 OID 42500)
-- Dependencies: 2496 2496
-- Name: studyintensity_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyintensity
    ADD CONSTRAINT studyintensity_id_key UNIQUE (id);


--
-- TOC entry 4150 (class 2606 OID 42502)
-- Dependencies: 2496 2496 2496
-- Name: studyintensity_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyintensity
    ADD CONSTRAINT studyintensity_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4152 (class 2606 OID 42504)
-- Dependencies: 2498 2498
-- Name: studyplan_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplan
    ADD CONSTRAINT studyplan_pkey PRIMARY KEY (id);


--
-- TOC entry 4154 (class 2606 OID 42506)
-- Dependencies: 2500 2500
-- Name: studyplancardinaltimeunit_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplancardinaltimeunit
    ADD CONSTRAINT studyplancardinaltimeunit_pkey PRIMARY KEY (id);


--
-- TOC entry 4156 (class 2606 OID 42508)
-- Dependencies: 2502 2502
-- Name: studyplandetail_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplandetail
    ADD CONSTRAINT studyplandetail_pkey PRIMARY KEY (id);


--
-- TOC entry 4162 (class 2606 OID 42510)
-- Dependencies: 2505 2505
-- Name: studyplanstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplanstatus
    ADD CONSTRAINT studyplanstatus_id_key UNIQUE (id);


--
-- TOC entry 4164 (class 2606 OID 42512)
-- Dependencies: 2505 2505 2505
-- Name: studyplanstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studyplanstatus
    ADD CONSTRAINT studyplanstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4166 (class 2606 OID 42514)
-- Dependencies: 2507 2507
-- Name: studytime_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studytime
    ADD CONSTRAINT studytime_id_key UNIQUE (id);


--
-- TOC entry 4168 (class 2606 OID 42516)
-- Dependencies: 2507 2507 2507
-- Name: studytime_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studytime
    ADD CONSTRAINT studytime_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4170 (class 2606 OID 42518)
-- Dependencies: 2509 2509
-- Name: studytype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studytype
    ADD CONSTRAINT studytype_id_key UNIQUE (id);


--
-- TOC entry 4172 (class 2606 OID 42520)
-- Dependencies: 2509 2509 2509
-- Name: studytype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studytype
    ADD CONSTRAINT studytype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4174 (class 2606 OID 42522)
-- Dependencies: 2511 2511
-- Name: subject_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (id);


--
-- TOC entry 4176 (class 2606 OID 42524)
-- Dependencies: 2511 2511 2511 2511
-- Name: subject_subjectcode_subjectdescription_currentacademicyearid_ke; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subject_subjectcode_subjectdescription_currentacademicyearid_ke UNIQUE (subjectcode, subjectdescription, currentacademicyearid);


--
-- TOC entry 4178 (class 2606 OID 42526)
-- Dependencies: 2513 2513
-- Name: subjectblock_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectblock
    ADD CONSTRAINT subjectblock_pkey PRIMARY KEY (id);


--
-- TOC entry 4180 (class 2606 OID 42528)
-- Dependencies: 2513 2513 2513
-- Name: subjectblock_subjectblockcode_currentacademicyearid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectblock
    ADD CONSTRAINT subjectblock_subjectblockcode_currentacademicyearid_key UNIQUE (subjectblockcode, currentacademicyearid);


--
-- TOC entry 4182 (class 2606 OID 42530)
-- Dependencies: 2514 2514 2514
-- Name: subjectblockprerequisite_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectblockprerequisite
    ADD CONSTRAINT subjectblockprerequisite_pkey PRIMARY KEY (subjectblockid, subjectblockstudygradetypeid);


--
-- TOC entry 4184 (class 2606 OID 42532)
-- Dependencies: 2516 2516
-- Name: subjectblockstudygradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectblockstudygradetype
    ADD CONSTRAINT subjectblockstudygradetype_pkey PRIMARY KEY (id);


--
-- TOC entry 4186 (class 2606 OID 42534)
-- Dependencies: 2516 2516 2516 2516 2516
-- Name: subjectblockstudygradetype_subjectblockid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectblockstudygradetype
    ADD CONSTRAINT subjectblockstudygradetype_subjectblockid_key UNIQUE (subjectblockid, studygradetypeid, cardinaltimeunitnumber, rigiditytypecode);


--
-- TOC entry 3943 (class 2606 OID 42536)
-- Dependencies: 2371 2371
-- Name: subjectimportance_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY importancetype
    ADD CONSTRAINT subjectimportance_id_key UNIQUE (id);


--
-- TOC entry 3945 (class 2606 OID 42538)
-- Dependencies: 2371 2371 2371
-- Name: subjectimportance_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY importancetype
    ADD CONSTRAINT subjectimportance_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4188 (class 2606 OID 42540)
-- Dependencies: 2517 2517 2517
-- Name: subjectprerequisite_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectprerequisite
    ADD CONSTRAINT subjectprerequisite_pkey PRIMARY KEY (subjectid, subjectstudygradetypeid);


--
-- TOC entry 4190 (class 2606 OID 42542)
-- Dependencies: 2519 2519
-- Name: subjectresult_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectresult
    ADD CONSTRAINT subjectresult_pkey PRIMARY KEY (id);


--
-- TOC entry 4192 (class 2606 OID 42544)
-- Dependencies: 2521 2521
-- Name: subjectstudygradetype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectstudygradetype
    ADD CONSTRAINT subjectstudygradetype_pkey PRIMARY KEY (id);


--
-- TOC entry 4194 (class 2606 OID 42546)
-- Dependencies: 2523 2523
-- Name: subjectstudytype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectstudytype
    ADD CONSTRAINT subjectstudytype_pkey PRIMARY KEY (id);


--
-- TOC entry 4196 (class 2606 OID 42548)
-- Dependencies: 2523 2523 2523
-- Name: subjectstudytype_subjectid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectstudytype
    ADD CONSTRAINT subjectstudytype_subjectid_key UNIQUE (subjectid, studytypecode);


--
-- TOC entry 4198 (class 2606 OID 42550)
-- Dependencies: 2525 2525
-- Name: subjectsubjectblock_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectsubjectblock
    ADD CONSTRAINT subjectsubjectblock_pkey PRIMARY KEY (id);


--
-- TOC entry 4200 (class 2606 OID 42552)
-- Dependencies: 2525 2525 2525
-- Name: subjectsubjectblock_subjectid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectsubjectblock
    ADD CONSTRAINT subjectsubjectblock_subjectid_key UNIQUE (subjectid, subjectblockid);


--
-- TOC entry 4202 (class 2606 OID 42554)
-- Dependencies: 2527 2527
-- Name: subjectteacher_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectteacher
    ADD CONSTRAINT subjectteacher_pkey PRIMARY KEY (id);


--
-- TOC entry 4204 (class 2606 OID 42556)
-- Dependencies: 2527 2527 2527
-- Name: subjectteacher_staffmemberid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subjectteacher
    ADD CONSTRAINT subjectteacher_staffmemberid_key UNIQUE (staffmemberid, subjectid);


--
-- TOC entry 4206 (class 2606 OID 42558)
-- Dependencies: 2529 2529
-- Name: tabledependency_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tabledependency
    ADD CONSTRAINT tabledependency_pkey PRIMARY KEY (id);


--
-- TOC entry 4208 (class 2606 OID 42560)
-- Dependencies: 2531 2531
-- Name: targetgroup_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY targetgroup
    ADD CONSTRAINT targetgroup_id_key UNIQUE (id);


--
-- TOC entry 4210 (class 2606 OID 42562)
-- Dependencies: 2531 2531 2531
-- Name: targetgroup_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY targetgroup
    ADD CONSTRAINT targetgroup_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4212 (class 2606 OID 42564)
-- Dependencies: 2533 2533
-- Name: test_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY test
    ADD CONSTRAINT test_pkey PRIMARY KEY (id);


--
-- TOC entry 4214 (class 2606 OID 42566)
-- Dependencies: 2535 2535
-- Name: testresult_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_pkey PRIMARY KEY (id);


--
-- TOC entry 4216 (class 2606 OID 42568)
-- Dependencies: 2535 2535 2535 2535 2535 2535
-- Name: testresult_testattemptnr_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_testattemptnr_key UNIQUE (testid, examinationid, examinationresultid, studyplandetailid, attemptnr);


--
-- TOC entry 4218 (class 2606 OID 42570)
-- Dependencies: 2537 2537
-- Name: testteacher_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY testteacher
    ADD CONSTRAINT testteacher_pkey PRIMARY KEY (id);


--
-- TOC entry 4220 (class 2606 OID 42572)
-- Dependencies: 2537 2537 2537
-- Name: testteacher_staffmemberid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY testteacher
    ADD CONSTRAINT testteacher_staffmemberid_key UNIQUE (staffmemberid, testid);


--
-- TOC entry 4222 (class 2606 OID 42574)
-- Dependencies: 2539 2539
-- Name: thesis_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesis
    ADD CONSTRAINT thesis_pkey PRIMARY KEY (id);


--
-- TOC entry 4224 (class 2606 OID 42576)
-- Dependencies: 2539 2539
-- Name: thesis_thesiscode_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesis
    ADD CONSTRAINT thesis_thesiscode_key UNIQUE (thesiscode);


--
-- TOC entry 4226 (class 2606 OID 42578)
-- Dependencies: 2541 2541
-- Name: thesisresult_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesisresult
    ADD CONSTRAINT thesisresult_pkey PRIMARY KEY (id);


--
-- TOC entry 4228 (class 2606 OID 42580)
-- Dependencies: 2541 2541
-- Name: thesisresult_studyplanid_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesisresult
    ADD CONSTRAINT thesisresult_studyplanid_key UNIQUE (studyplanid);


--
-- TOC entry 4230 (class 2606 OID 42582)
-- Dependencies: 2543 2543
-- Name: thesisstatus_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesisstatus
    ADD CONSTRAINT thesisstatus_id_key UNIQUE (id);


--
-- TOC entry 4232 (class 2606 OID 42584)
-- Dependencies: 2543 2543 2543
-- Name: thesisstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesisstatus
    ADD CONSTRAINT thesisstatus_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4234 (class 2606 OID 42586)
-- Dependencies: 2545 2545
-- Name: thesissupervisor_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesissupervisor
    ADD CONSTRAINT thesissupervisor_pkey PRIMARY KEY (id);


--
-- TOC entry 4236 (class 2606 OID 42588)
-- Dependencies: 2547 2547
-- Name: thesisthesisstatus_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY thesisthesisstatus
    ADD CONSTRAINT thesisthesisstatus_pkey PRIMARY KEY (id);


--
-- TOC entry 4238 (class 2606 OID 42590)
-- Dependencies: 2549 2549
-- Name: timeunit_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY timeunit
    ADD CONSTRAINT timeunit_id_key UNIQUE (id);


--
-- TOC entry 4240 (class 2606 OID 42592)
-- Dependencies: 2549 2549 2549
-- Name: timeunit_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY timeunit
    ADD CONSTRAINT timeunit_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3751 (class 2606 OID 42594)
-- Dependencies: 2255 2255 2255
-- Name: unique_acc_roomtype_code_lang; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acc_roomtype
    ADD CONSTRAINT unique_acc_roomtype_code_lang UNIQUE (code, lang);


--
-- TOC entry 3990 (class 2606 OID 42596)
-- Dependencies: 2397 2397 2397
-- Name: unique_role_privilege; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opusrole_privilege
    ADD CONSTRAINT unique_role_privilege UNIQUE (role, privilegecode);


--
-- TOC entry 4070 (class 2606 OID 42598)
-- Dependencies: 2446 2446 2446
-- Name: unique_sch_sponsorfeepercentage_sponsorfeecategory; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sch_sponsorfeepercentage
    ADD CONSTRAINT unique_sch_sponsorfeepercentage_sponsorfeecategory UNIQUE (sponsorid, feecategorycode);


--
-- TOC entry 4242 (class 2606 OID 42600)
-- Dependencies: 2551 2551
-- Name: unitarea_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unitarea
    ADD CONSTRAINT unitarea_id_key UNIQUE (id);


--
-- TOC entry 4244 (class 2606 OID 42602)
-- Dependencies: 2551 2551 2551
-- Name: unitarea_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unitarea
    ADD CONSTRAINT unitarea_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 4246 (class 2606 OID 42604)
-- Dependencies: 2553 2553
-- Name: unittype_id_key; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unittype
    ADD CONSTRAINT unittype_id_key UNIQUE (id);


--
-- TOC entry 4248 (class 2606 OID 42606)
-- Dependencies: 2553 2553 2553
-- Name: unittype_pkey; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unittype
    ADD CONSTRAINT unittype_pkey PRIMARY KEY (id, lang);


--
-- TOC entry 3933 (class 2606 OID 42608)
-- Dependencies: 2365 2365 2365
-- Name: uq_groupeddiscipline_disciplinecode_groupid; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groupeddiscipline
    ADD CONSTRAINT uq_groupeddiscipline_disciplinecode_groupid UNIQUE (disciplinecode, disciplinegroupid);


--
-- TOC entry 3851 (class 2606 OID 42610)
-- Dependencies: 2315 2315 2315 2315 2315
-- Name: uq_lang_code_academicyear_endgradetype; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY endgrade
    ADD CONSTRAINT uq_lang_code_academicyear_endgradetype UNIQUE (code, lang, academicyearid, endgradetypecode);


--
-- TOC entry 3999 (class 2606 OID 42612)
-- Dependencies: 2401 2401 2401
-- Name: user_organizationalunit_unique_constraint; Type: CONSTRAINT; Schema: opuscollege; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY opususerrole
    ADD CONSTRAINT user_organizationalunit_unique_constraint UNIQUE (username, organizationalunitid);


--
-- TOC entry 3745 (class 1259 OID 42613)
-- Dependencies: 2253 2253
-- Name: unique_acc_roomcode; Type: INDEX; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX unique_acc_roomcode ON acc_room USING btree (lower((code)::text));


--
-- TOC entry 3740 (class 1259 OID 42614)
-- Dependencies: 2249 2249
-- Name: unique_hostelcode; Type: INDEX; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX unique_hostelcode ON acc_hostel USING btree (lower((code)::text));


--
-- TOC entry 4066 (class 1259 OID 42615)
-- Dependencies: 2444 2444
-- Name: unique_sch_sponsorcode; Type: INDEX; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX unique_sch_sponsorcode ON sch_sponsor USING btree (lower((code)::text));


--
-- TOC entry 3964 (class 1259 OID 42616)
-- Dependencies: 2383 2383
-- Name: unique_tablename; Type: INDEX; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX unique_tablename ON lookuptable USING btree (lower((tablename)::text));


--
-- TOC entry 3991 (class 1259 OID 42617)
-- Dependencies: 2397 2397 2397
-- Name: uq_opusroleprivilege_roleprivilegecode; Type: INDEX; Schema: opuscollege; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX uq_opusroleprivilege_roleprivilegecode ON opusrole_privilege USING btree (lower((role)::text), lower((privilegecode)::text));


SET search_path = audit, pg_catalog;

--
-- TOC entry 4249 (class 2606 OID 42618)
-- Dependencies: 4107 2469 2223
-- Name: fee_payment_hist_studentid_fkey; Type: FK CONSTRAINT; Schema: audit; Owner: postgres
--

ALTER TABLE ONLY fee_payment_hist
    ADD CONSTRAINT fee_payment_hist_studentid_fkey FOREIGN KEY (studentid) REFERENCES opuscollege.student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = opuscollege, pg_catalog;

--
-- TOC entry 4252 (class 2606 OID 42623)
-- Dependencies: 2249 3738 2253
-- Name: acc_room_hostelid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_room
    ADD CONSTRAINT acc_room_hostelid_fkey FOREIGN KEY (hostelid) REFERENCES acc_hostel(id);


--
-- TOC entry 4253 (class 2606 OID 42628)
-- Dependencies: 2257 2241 3732
-- Name: acc_studentaccommodation_academicyearid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_studentaccommodation
    ADD CONSTRAINT acc_studentaccommodation_academicyearid_fkey FOREIGN KEY (academicyearid) REFERENCES academicyear(id);


--
-- TOC entry 4254 (class 2606 OID 42633)
-- Dependencies: 4107 2469 2257
-- Name: acc_studentaccommodation_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_studentaccommodation
    ADD CONSTRAINT acc_studentaccommodation_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid);


--
-- TOC entry 4257 (class 2606 OID 42638)
-- Dependencies: 2281 2373 3948
-- Name: branch_institutionid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY branch
    ADD CONSTRAINT branch_institutionid_fkey FOREIGN KEY (institutionid) REFERENCES institution(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4258 (class 2606 OID 42643)
-- Dependencies: 2289 4143 2493
-- Name: cardinaltimeunitstudygradetype_studygradetypeid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY cardinaltimeunitstudygradetype
    ADD CONSTRAINT cardinaltimeunitstudygradetype_studygradetypeid_fkey FOREIGN KEY (studygradetypeid) REFERENCES studygradetype(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4259 (class 2606 OID 42648)
-- Dependencies: 4093 2297 2462
-- Name: contract_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT contract_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4260 (class 2606 OID 42653)
-- Dependencies: 2315 2241 3732
-- Name: endgrade_academicyearid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY endgrade
    ADD CONSTRAINT endgrade_academicyearid_fkey FOREIGN KEY (academicyearid) REFERENCES academicyear(id) ON UPDATE CASCADE;


--
-- TOC entry 4290 (class 2606 OID 42658)
-- Dependencies: 2498 4151 2503
-- Name: exam_studyplanid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studyplanresult
    ADD CONSTRAINT exam_studyplanid_fkey FOREIGN KEY (studyplanid) REFERENCES studyplan(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4261 (class 2606 OID 42663)
-- Dependencies: 3858 2324 2322
-- Name: examinationresult_examinationid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_examinationid_fkey FOREIGN KEY (examinationid) REFERENCES examination(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4262 (class 2606 OID 42668)
-- Dependencies: 4093 2324 2462
-- Name: examinationresult_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4263 (class 2606 OID 42673)
-- Dependencies: 2502 4155 2324
-- Name: examinationresult_studyplandetailid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_studyplandetailid_fkey FOREIGN KEY (studyplandetailid) REFERENCES studyplandetail(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4264 (class 2606 OID 42678)
-- Dependencies: 2511 4173 2324
-- Name: examinationresult_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationresult
    ADD CONSTRAINT examinationresult_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4265 (class 2606 OID 42683)
-- Dependencies: 3858 2322 2326
-- Name: examinationteacher_examinationid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationteacher
    ADD CONSTRAINT examinationteacher_examinationid_fkey FOREIGN KEY (examinationid) REFERENCES examination(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4266 (class 2606 OID 42688)
-- Dependencies: 2462 4093 2326
-- Name: examinationteacher_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY examinationteacher
    ADD CONSTRAINT examinationteacher_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4268 (class 2606 OID 42693)
-- Dependencies: 3882 2343 2337
-- Name: fee_payment_feeid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY fee_payment
    ADD CONSTRAINT fee_payment_feeid_fkey FOREIGN KEY (feeid) REFERENCES fee_fee(id) ON UPDATE CASCADE;


--
-- TOC entry 4269 (class 2606 OID 42698)
-- Dependencies: 4117 2343 2475
-- Name: fee_payment_studentbalanceid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY fee_payment
    ADD CONSTRAINT fee_payment_studentbalanceid_fkey FOREIGN KEY (studentbalanceid) REFERENCES studentbalance(id) ON UPDATE CASCADE;


--
-- TOC entry 4270 (class 2606 OID 42703)
-- Dependencies: 2343 4107 2469
-- Name: fee_payment_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY fee_payment
    ADD CONSTRAINT fee_payment_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4250 (class 2606 OID 42708)
-- Dependencies: 3882 2337 2243
-- Name: fk_accommodationfee_feeid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_accommodationfee
    ADD CONSTRAINT fk_accommodationfee_feeid FOREIGN KEY (feeid) REFERENCES fee_fee(id) ON UPDATE CASCADE;


--
-- TOC entry 4251 (class 2606 OID 42713)
-- Dependencies: 2249 2247 3738
-- Name: fk_block_hostelid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY acc_block
    ADD CONSTRAINT fk_block_hostelid FOREIGN KEY (hostelid) REFERENCES acc_hostel(id) ON UPDATE CASCADE;


--
-- TOC entry 4273 (class 2606 OID 42718)
-- Dependencies: 2432 2440 4058
-- Name: fk_complaintscholarshipid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_complaint
    ADD CONSTRAINT fk_complaintscholarshipid FOREIGN KEY (scholarshipapplicationid) REFERENCES sch_scholarshipapplication(id);


--
-- TOC entry 4275 (class 2606 OID 42723)
-- Dependencies: 2438 2440 4056
-- Name: fk_scholarshiptypeyearappliedforid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_scholarshipapplication
    ADD CONSTRAINT fk_scholarshiptypeyearappliedforid FOREIGN KEY (scholarshipappliedforid) REFERENCES sch_scholarship(id);


--
-- TOC entry 4276 (class 2606 OID 42728)
-- Dependencies: 4056 2438 2440
-- Name: fk_scholarshiptypeyeargrantedid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_scholarshipapplication
    ADD CONSTRAINT fk_scholarshiptypeyeargrantedid FOREIGN KEY (scholarshipgrantedid) REFERENCES sch_scholarship(id);


--
-- TOC entry 4274 (class 2606 OID 42733)
-- Dependencies: 2438 4064 2444
-- Name: fk_sponsor; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_scholarship
    ADD CONSTRAINT fk_sponsor FOREIGN KEY (sponsorid) REFERENCES sch_sponsor(id);


--
-- TOC entry 4278 (class 2606 OID 42738)
-- Dependencies: 4064 2444 2446
-- Name: fk_sponsor_sponsorfeepercentage; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_sponsorfeepercentage
    ADD CONSTRAINT fk_sponsor_sponsorfeepercentage FOREIGN KEY (sponsorid) REFERENCES sch_sponsor(id) ON UPDATE CASCADE;


--
-- TOC entry 4279 (class 2606 OID 42743)
-- Dependencies: 4107 2452 2469
-- Name: fk_student; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_student
    ADD CONSTRAINT fk_student FOREIGN KEY (studentid) REFERENCES student(studentid);


--
-- TOC entry 4277 (class 2606 OID 42748)
-- Dependencies: 2452 4077 2440
-- Name: fk_studentscholarship; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_scholarshipapplication
    ADD CONSTRAINT fk_studentscholarship FOREIGN KEY (scholarshipstudentid) REFERENCES sch_student(scholarshipstudentid);


--
-- TOC entry 4280 (class 2606 OID 42753)
-- Dependencies: 2454 4064 2444
-- Name: fk_subsidysponsorid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY sch_subsidy
    ADD CONSTRAINT fk_subsidysponsorid FOREIGN KEY (sponsorid) REFERENCES sch_sponsor(id);


--
-- TOC entry 4267 (class 2606 OID 42758)
-- Dependencies: 3882 2337 2341
-- Name: fkey_fee_feedeadline_feeid; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY fee_feedeadline
    ADD CONSTRAINT fkey_fee_feedeadline_feeid FOREIGN KEY (feeid) REFERENCES fee_fee(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4271 (class 2606 OID 42763)
-- Dependencies: 2365 3838 2309
-- Name: groupeddiscipline_disciplinegroupid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY groupeddiscipline
    ADD CONSTRAINT groupeddiscipline_disciplinegroupid_fkey FOREIGN KEY (disciplinegroupid) REFERENCES disciplinegroup(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4272 (class 2606 OID 42768)
-- Dependencies: 3994 2399 2401
-- Name: opususerrole_username_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY opususerrole
    ADD CONSTRAINT opususerrole_username_fkey FOREIGN KEY (username) REFERENCES opususer(username) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4255 (class 2606 OID 42773)
-- Dependencies: 3732 2241 2266
-- Name: organizationalunitacademicyear_academicyearid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY admissionregistrationconfig
    ADD CONSTRAINT organizationalunitacademicyear_academicyearid_fkey FOREIGN KEY (academicyearid) REFERENCES academicyear(id);


--
-- TOC entry 4256 (class 2606 OID 42778)
-- Dependencies: 3726 2211 2266
-- Name: organizationalunitacademicyear_organizationalunitid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY admissionregistrationconfig
    ADD CONSTRAINT organizationalunitacademicyear_organizationalunitid_fkey FOREIGN KEY (organizationalunitid) REFERENCES organizationalunit(id);


--
-- TOC entry 4281 (class 2606 OID 42783)
-- Dependencies: 4008 2407 2462
-- Name: staffmember_personid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY staffmember
    ADD CONSTRAINT staffmember_personid_fkey FOREIGN KEY (personid) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4282 (class 2606 OID 42788)
-- Dependencies: 2463 4093 2462
-- Name: staffmemberfunction_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY staffmemberfunction
    ADD CONSTRAINT staffmemberfunction_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4283 (class 2606 OID 42793)
-- Dependencies: 2469 4008 2407
-- Name: student_personid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY student
    ADD CONSTRAINT student_personid_fkey FOREIGN KEY (personid) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4284 (class 2606 OID 42798)
-- Dependencies: 4107 2469 2471
-- Name: studentabsence_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studentabsence
    ADD CONSTRAINT studentabsence_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4285 (class 2606 OID 42803)
-- Dependencies: 2469 2481 4107
-- Name: studentexpulsion_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studentexpulsion
    ADD CONSTRAINT studentexpulsion_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4286 (class 2606 OID 42808)
-- Dependencies: 2469 4107 2487
-- Name: studentstudentstatus_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studentstudentstatus
    ADD CONSTRAINT studentstudentstatus_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4287 (class 2606 OID 42813)
-- Dependencies: 4107 2469 2498
-- Name: studyplan_studentid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studyplan
    ADD CONSTRAINT studyplan_studentid_fkey FOREIGN KEY (studentid) REFERENCES student(studentid) ON UPDATE CASCADE;


--
-- TOC entry 4288 (class 2606 OID 42818)
-- Dependencies: 4151 2498 2500
-- Name: studyplancardinaltimeunit_studyplanid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studyplancardinaltimeunit
    ADD CONSTRAINT studyplancardinaltimeunit_studyplanid_fkey FOREIGN KEY (studyplanid) REFERENCES studyplan(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4289 (class 2606 OID 42823)
-- Dependencies: 2498 4151 2502
-- Name: studyplandetail_studyplanid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY studyplandetail
    ADD CONSTRAINT studyplandetail_studyplanid_fkey FOREIGN KEY (studyplanid) REFERENCES studyplan(id) ON UPDATE CASCADE;


--
-- TOC entry 4291 (class 2606 OID 42828)
-- Dependencies: 2493 2516 4143
-- Name: subjectblockstudygradetype_studygradetypeid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectblockstudygradetype
    ADD CONSTRAINT subjectblockstudygradetype_studygradetypeid_fkey FOREIGN KEY (studygradetypeid) REFERENCES studygradetype(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4292 (class 2606 OID 42833)
-- Dependencies: 2516 4177 2513
-- Name: subjectblockstudygradetype_subjectblockid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectblockstudygradetype
    ADD CONSTRAINT subjectblockstudygradetype_subjectblockid_fkey FOREIGN KEY (subjectblockid) REFERENCES subjectblock(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4293 (class 2606 OID 42838)
-- Dependencies: 4093 2462 2519
-- Name: subjectresult_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectresult
    ADD CONSTRAINT subjectresult_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4294 (class 2606 OID 42843)
-- Dependencies: 4155 2502 2519
-- Name: subjectresult_studyplandetailid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectresult
    ADD CONSTRAINT subjectresult_studyplandetailid_fkey FOREIGN KEY (studyplandetailid) REFERENCES studyplandetail(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4295 (class 2606 OID 42848)
-- Dependencies: 2511 4173 2519
-- Name: subjectresult_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectresult
    ADD CONSTRAINT subjectresult_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4296 (class 2606 OID 42853)
-- Dependencies: 2521 2511 4173
-- Name: subjectstudygradetype_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectstudygradetype
    ADD CONSTRAINT subjectstudygradetype_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4297 (class 2606 OID 42858)
-- Dependencies: 2523 4173 2511
-- Name: subjectstudytype_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectstudytype
    ADD CONSTRAINT subjectstudytype_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4298 (class 2606 OID 42863)
-- Dependencies: 2525 2513 4177
-- Name: subjectsubjectblock_subjectblockid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectsubjectblock
    ADD CONSTRAINT subjectsubjectblock_subjectblockid_fkey FOREIGN KEY (subjectblockid) REFERENCES subjectblock(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4299 (class 2606 OID 42868)
-- Dependencies: 4173 2525 2511
-- Name: subjectsubjectblock_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectsubjectblock
    ADD CONSTRAINT subjectsubjectblock_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4300 (class 2606 OID 42873)
-- Dependencies: 2462 2527 4093
-- Name: subjectteacher_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectteacher
    ADD CONSTRAINT subjectteacher_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4301 (class 2606 OID 42878)
-- Dependencies: 2511 2527 4173
-- Name: subjectteacher_subjectid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY subjectteacher
    ADD CONSTRAINT subjectteacher_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4302 (class 2606 OID 42883)
-- Dependencies: 2535 3858 2322
-- Name: testresult_examinationid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_examinationid_fkey FOREIGN KEY (examinationid) REFERENCES examination(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4303 (class 2606 OID 42888)
-- Dependencies: 2535 4093 2462
-- Name: testresult_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4304 (class 2606 OID 42893)
-- Dependencies: 2502 2535 4155
-- Name: testresult_studyplandetailid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_studyplandetailid_fkey FOREIGN KEY (studyplandetailid) REFERENCES studyplandetail(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4305 (class 2606 OID 42898)
-- Dependencies: 2533 4211 2535
-- Name: testresult_testid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testresult
    ADD CONSTRAINT testresult_testid_fkey FOREIGN KEY (testid) REFERENCES test(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4306 (class 2606 OID 42903)
-- Dependencies: 2537 2462 4093
-- Name: testteacher_staffmemberid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testteacher
    ADD CONSTRAINT testteacher_staffmemberid_fkey FOREIGN KEY (staffmemberid) REFERENCES staffmember(staffmemberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4307 (class 2606 OID 42908)
-- Dependencies: 2533 4211 2537
-- Name: testteacher_testid_fkey; Type: FK CONSTRAINT; Schema: opuscollege; Owner: postgres
--

ALTER TABLE ONLY testteacher
    ADD CONSTRAINT testteacher_testid_fkey FOREIGN KEY (testid) REFERENCES test(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4497 (class 0 OID 0)
-- Dependencies: 6
-- Name: audit; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA audit FROM PUBLIC;
REVOKE ALL ON SCHEMA audit FROM postgres;
GRANT ALL ON SCHEMA audit TO postgres;


--
-- TOC entry 4498 (class 0 OID 0)
-- Dependencies: 7
-- Name: opuscollege; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA opuscollege FROM PUBLIC;
REVOKE ALL ON SCHEMA opuscollege FROM postgres;
GRANT ALL ON SCHEMA opuscollege TO postgres;


--
-- TOC entry 4500 (class 0 OID 0)
-- Dependencies: 8
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 4502 (class 0 OID 0)
-- Dependencies: 2211
-- Name: organizationalunit; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE organizationalunit FROM PUBLIC;
REVOKE ALL ON TABLE organizationalunit FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE organizationalunit TO postgres;


SET search_path = audit, pg_catalog;

--
-- TOC entry 4503 (class 0 OID 0)
-- Dependencies: 2213
-- Name: acc_accommodationfee_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE acc_accommodationfee_hist FROM PUBLIC;
REVOKE ALL ON TABLE acc_accommodationfee_hist FROM postgres;
GRANT ALL ON TABLE acc_accommodationfee_hist TO postgres;


--
-- TOC entry 4504 (class 0 OID 0)
-- Dependencies: 2214
-- Name: acc_block_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE acc_block_hist FROM PUBLIC;
REVOKE ALL ON TABLE acc_block_hist FROM postgres;
GRANT ALL ON TABLE acc_block_hist TO postgres;


--
-- TOC entry 4505 (class 0 OID 0)
-- Dependencies: 2215
-- Name: acc_hostel_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE acc_hostel_hist FROM PUBLIC;
REVOKE ALL ON TABLE acc_hostel_hist FROM postgres;
GRANT ALL ON TABLE acc_hostel_hist TO postgres;


--
-- TOC entry 4506 (class 0 OID 0)
-- Dependencies: 2216
-- Name: acc_room_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE acc_room_hist FROM PUBLIC;
REVOKE ALL ON TABLE acc_room_hist FROM postgres;
GRANT ALL ON TABLE acc_room_hist TO postgres;


--
-- TOC entry 4507 (class 0 OID 0)
-- Dependencies: 2217
-- Name: acc_studentaccommodation_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE acc_studentaccommodation_hist FROM PUBLIC;
REVOKE ALL ON TABLE acc_studentaccommodation_hist FROM postgres;
GRANT ALL ON TABLE acc_studentaccommodation_hist TO postgres;


--
-- TOC entry 4508 (class 0 OID 0)
-- Dependencies: 2218
-- Name: cardinaltimeunitresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE cardinaltimeunitresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE cardinaltimeunitresult_hist FROM postgres;
GRANT ALL ON TABLE cardinaltimeunitresult_hist TO postgres;


--
-- TOC entry 4509 (class 0 OID 0)
-- Dependencies: 2219
-- Name: endgrade_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE endgrade_hist FROM PUBLIC;
REVOKE ALL ON TABLE endgrade_hist FROM postgres;
GRANT ALL ON TABLE endgrade_hist TO postgres;


--
-- TOC entry 4510 (class 0 OID 0)
-- Dependencies: 2220
-- Name: examinationresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE examinationresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE examinationresult_hist FROM postgres;
GRANT ALL ON TABLE examinationresult_hist TO postgres;


--
-- TOC entry 4511 (class 0 OID 0)
-- Dependencies: 2221
-- Name: fee_fee_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE fee_fee_hist FROM PUBLIC;
REVOKE ALL ON TABLE fee_fee_hist FROM postgres;
GRANT ALL ON TABLE fee_fee_hist TO postgres;


--
-- TOC entry 4512 (class 0 OID 0)
-- Dependencies: 2222
-- Name: fee_feedeadline_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE fee_feedeadline_hist FROM PUBLIC;
REVOKE ALL ON TABLE fee_feedeadline_hist FROM postgres;
GRANT ALL ON TABLE fee_feedeadline_hist TO postgres;


--
-- TOC entry 4513 (class 0 OID 0)
-- Dependencies: 2223
-- Name: fee_payment_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE fee_payment_hist FROM PUBLIC;
REVOKE ALL ON TABLE fee_payment_hist FROM postgres;
GRANT ALL ON TABLE fee_payment_hist TO postgres;


--
-- TOC entry 4514 (class 0 OID 0)
-- Dependencies: 2224
-- Name: financialrequest_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE financialrequest_hist FROM PUBLIC;
REVOKE ALL ON TABLE financialrequest_hist FROM postgres;
GRANT ALL ON TABLE financialrequest_hist TO postgres;


--
-- TOC entry 4515 (class 0 OID 0)
-- Dependencies: 2225
-- Name: financialtransaction_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE financialtransaction_hist FROM PUBLIC;
REVOKE ALL ON TABLE financialtransaction_hist FROM postgres;
GRANT ALL ON TABLE financialtransaction_hist TO postgres;


--
-- TOC entry 4516 (class 0 OID 0)
-- Dependencies: 2226
-- Name: gradedsecondaryschoolsubject_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE gradedsecondaryschoolsubject_hist FROM PUBLIC;
REVOKE ALL ON TABLE gradedsecondaryschoolsubject_hist FROM postgres;
GRANT ALL ON TABLE gradedsecondaryschoolsubject_hist TO postgres;


--
-- TOC entry 4517 (class 0 OID 0)
-- Dependencies: 2227
-- Name: sch_sponsor_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE sch_sponsor_hist FROM PUBLIC;
REVOKE ALL ON TABLE sch_sponsor_hist FROM postgres;
GRANT ALL ON TABLE sch_sponsor_hist TO postgres;


--
-- TOC entry 4518 (class 0 OID 0)
-- Dependencies: 2228
-- Name: sch_sponsorfeepercentage_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE sch_sponsorfeepercentage_hist FROM PUBLIC;
REVOKE ALL ON TABLE sch_sponsorfeepercentage_hist FROM postgres;
GRANT ALL ON TABLE sch_sponsorfeepercentage_hist TO postgres;


--
-- TOC entry 4519 (class 0 OID 0)
-- Dependencies: 2229
-- Name: staffmember_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE staffmember_hist FROM PUBLIC;
REVOKE ALL ON TABLE staffmember_hist FROM postgres;
GRANT ALL ON TABLE staffmember_hist TO postgres;


--
-- TOC entry 4520 (class 0 OID 0)
-- Dependencies: 2230
-- Name: student_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE student_hist FROM PUBLIC;
REVOKE ALL ON TABLE student_hist FROM postgres;
GRANT ALL ON TABLE student_hist TO postgres;


--
-- TOC entry 4521 (class 0 OID 0)
-- Dependencies: 2231
-- Name: studentabsence_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE studentabsence_hist FROM PUBLIC;
REVOKE ALL ON TABLE studentabsence_hist FROM postgres;
GRANT ALL ON TABLE studentabsence_hist TO postgres;


--
-- TOC entry 4522 (class 0 OID 0)
-- Dependencies: 2232
-- Name: studentbalance_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE studentbalance_hist FROM PUBLIC;
REVOKE ALL ON TABLE studentbalance_hist FROM postgres;
GRANT ALL ON TABLE studentbalance_hist TO postgres;


--
-- TOC entry 4523 (class 0 OID 0)
-- Dependencies: 2233
-- Name: studentexpulsion_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE studentexpulsion_hist FROM PUBLIC;
REVOKE ALL ON TABLE studentexpulsion_hist FROM postgres;
GRANT ALL ON TABLE studentexpulsion_hist TO postgres;


--
-- TOC entry 4524 (class 0 OID 0)
-- Dependencies: 2234
-- Name: studyplanresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE studyplanresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE studyplanresult_hist FROM postgres;
GRANT ALL ON TABLE studyplanresult_hist TO postgres;


--
-- TOC entry 4525 (class 0 OID 0)
-- Dependencies: 2235
-- Name: subjectresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE subjectresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE subjectresult_hist FROM postgres;
GRANT ALL ON TABLE subjectresult_hist TO postgres;


--
-- TOC entry 4526 (class 0 OID 0)
-- Dependencies: 2236
-- Name: testresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE testresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE testresult_hist FROM postgres;
GRANT ALL ON TABLE testresult_hist TO postgres;


--
-- TOC entry 4527 (class 0 OID 0)
-- Dependencies: 2237
-- Name: thesisresult_hist; Type: ACL; Schema: audit; Owner: postgres
--

REVOKE ALL ON TABLE thesisresult_hist FROM PUBLIC;
REVOKE ALL ON TABLE thesisresult_hist FROM postgres;
GRANT ALL ON TABLE thesisresult_hist TO postgres;


SET search_path = opuscollege, pg_catalog;

--
-- TOC entry 4529 (class 0 OID 0)
-- Dependencies: 2239
-- Name: academicfield; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE academicfield FROM PUBLIC;
REVOKE ALL ON TABLE academicfield FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE academicfield TO postgres;


--
-- TOC entry 4531 (class 0 OID 0)
-- Dependencies: 2241
-- Name: academicyear; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE academicyear FROM PUBLIC;
REVOKE ALL ON TABLE academicyear FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE academicyear TO postgres;


--
-- TOC entry 4533 (class 0 OID 0)
-- Dependencies: 2243
-- Name: acc_accommodationfee; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_accommodationfee FROM PUBLIC;
REVOKE ALL ON TABLE acc_accommodationfee FROM postgres;
GRANT ALL ON TABLE acc_accommodationfee TO postgres;


--
-- TOC entry 4537 (class 0 OID 0)
-- Dependencies: 2247
-- Name: acc_block; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_block FROM PUBLIC;
REVOKE ALL ON TABLE acc_block FROM postgres;
GRANT ALL ON TABLE acc_block TO postgres;


--
-- TOC entry 4539 (class 0 OID 0)
-- Dependencies: 2249
-- Name: acc_hostel; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_hostel FROM PUBLIC;
REVOKE ALL ON TABLE acc_hostel FROM postgres;
GRANT ALL ON TABLE acc_hostel TO postgres;


--
-- TOC entry 4541 (class 0 OID 0)
-- Dependencies: 2251
-- Name: acc_hosteltype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_hosteltype FROM PUBLIC;
REVOKE ALL ON TABLE acc_hosteltype FROM postgres;
GRANT ALL ON TABLE acc_hosteltype TO postgres;


--
-- TOC entry 4543 (class 0 OID 0)
-- Dependencies: 2253
-- Name: acc_room; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_room FROM PUBLIC;
REVOKE ALL ON TABLE acc_room FROM postgres;
GRANT ALL ON TABLE acc_room TO postgres;


--
-- TOC entry 4545 (class 0 OID 0)
-- Dependencies: 2255
-- Name: acc_roomtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_roomtype FROM PUBLIC;
REVOKE ALL ON TABLE acc_roomtype FROM postgres;
GRANT ALL ON TABLE acc_roomtype TO postgres;


--
-- TOC entry 4547 (class 0 OID 0)
-- Dependencies: 2257
-- Name: acc_studentaccommodation; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE acc_studentaccommodation FROM PUBLIC;
REVOKE ALL ON TABLE acc_studentaccommodation FROM postgres;
GRANT ALL ON TABLE acc_studentaccommodation TO postgres;


--
-- TOC entry 4550 (class 0 OID 0)
-- Dependencies: 2260
-- Name: address; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE address FROM PUBLIC;
REVOKE ALL ON TABLE address FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE address TO postgres;


--
-- TOC entry 4552 (class 0 OID 0)
-- Dependencies: 2262
-- Name: addresstype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE addresstype FROM PUBLIC;
REVOKE ALL ON TABLE addresstype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE addresstype TO postgres;


--
-- TOC entry 4554 (class 0 OID 0)
-- Dependencies: 2264
-- Name: administrativepost; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE administrativepost FROM PUBLIC;
REVOKE ALL ON TABLE administrativepost FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE administrativepost TO postgres;


--
-- TOC entry 4557 (class 0 OID 0)
-- Dependencies: 2268
-- Name: appconfig; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE appconfig FROM PUBLIC;
REVOKE ALL ON TABLE appconfig FROM postgres;
GRANT ALL ON TABLE appconfig TO postgres;


--
-- TOC entry 4559 (class 0 OID 0)
-- Dependencies: 2270
-- Name: applicantcategory; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE applicantcategory FROM PUBLIC;
REVOKE ALL ON TABLE applicantcategory FROM postgres;
GRANT ALL ON TABLE applicantcategory TO postgres;


--
-- TOC entry 4561 (class 0 OID 0)
-- Dependencies: 2272
-- Name: appointmenttype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE appointmenttype FROM PUBLIC;
REVOKE ALL ON TABLE appointmenttype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE appointmenttype TO postgres;


--
-- TOC entry 4563 (class 0 OID 0)
-- Dependencies: 2274
-- Name: appversions; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE appversions FROM PUBLIC;
REVOKE ALL ON TABLE appversions FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE appversions TO postgres;


--
-- TOC entry 4564 (class 0 OID 0)
-- Dependencies: 2275
-- Name: authorisation; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE authorisation FROM PUBLIC;
REVOKE ALL ON TABLE authorisation FROM postgres;
GRANT ALL ON TABLE authorisation TO postgres;


--
-- TOC entry 4566 (class 0 OID 0)
-- Dependencies: 2277
-- Name: blocktype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE blocktype FROM PUBLIC;
REVOKE ALL ON TABLE blocktype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE blocktype TO postgres;


--
-- TOC entry 4568 (class 0 OID 0)
-- Dependencies: 2279
-- Name: bloodtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE bloodtype FROM PUBLIC;
REVOKE ALL ON TABLE bloodtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE bloodtype TO postgres;


--
-- TOC entry 4570 (class 0 OID 0)
-- Dependencies: 2281
-- Name: branch; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE branch FROM PUBLIC;
REVOKE ALL ON TABLE branch FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE branch TO postgres;


--
-- TOC entry 4572 (class 0 OID 0)
-- Dependencies: 2283
-- Name: cardinaltimeunit; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE cardinaltimeunit FROM PUBLIC;
REVOKE ALL ON TABLE cardinaltimeunit FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE cardinaltimeunit TO postgres;


--
-- TOC entry 4574 (class 0 OID 0)
-- Dependencies: 2285
-- Name: cardinaltimeunitresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE cardinaltimeunitresult FROM PUBLIC;
REVOKE ALL ON TABLE cardinaltimeunitresult FROM postgres;
GRANT ALL ON TABLE cardinaltimeunitresult TO postgres;


--
-- TOC entry 4576 (class 0 OID 0)
-- Dependencies: 2287
-- Name: cardinaltimeunitstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE cardinaltimeunitstatus FROM PUBLIC;
REVOKE ALL ON TABLE cardinaltimeunitstatus FROM postgres;
GRANT ALL ON TABLE cardinaltimeunitstatus TO postgres;


--
-- TOC entry 4578 (class 0 OID 0)
-- Dependencies: 2289
-- Name: cardinaltimeunitstudygradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE cardinaltimeunitstudygradetype FROM PUBLIC;
REVOKE ALL ON TABLE cardinaltimeunitstudygradetype FROM postgres;
GRANT ALL ON TABLE cardinaltimeunitstudygradetype TO postgres;


--
-- TOC entry 4580 (class 0 OID 0)
-- Dependencies: 2291
-- Name: careerposition; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE careerposition FROM PUBLIC;
REVOKE ALL ON TABLE careerposition FROM postgres;
GRANT ALL ON TABLE careerposition TO postgres;


--
-- TOC entry 4582 (class 0 OID 0)
-- Dependencies: 2293
-- Name: civilstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE civilstatus FROM PUBLIC;
REVOKE ALL ON TABLE civilstatus FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE civilstatus TO postgres;


--
-- TOC entry 4584 (class 0 OID 0)
-- Dependencies: 2295
-- Name: civiltitle; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE civiltitle FROM PUBLIC;
REVOKE ALL ON TABLE civiltitle FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE civiltitle TO postgres;


--
-- TOC entry 4586 (class 0 OID 0)
-- Dependencies: 2297
-- Name: contract; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE contract FROM PUBLIC;
REVOKE ALL ON TABLE contract FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE contract TO postgres;


--
-- TOC entry 4588 (class 0 OID 0)
-- Dependencies: 2299
-- Name: contractduration; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE contractduration FROM PUBLIC;
REVOKE ALL ON TABLE contractduration FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE contractduration TO postgres;


--
-- TOC entry 4590 (class 0 OID 0)
-- Dependencies: 2301
-- Name: contracttype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE contracttype FROM PUBLIC;
REVOKE ALL ON TABLE contracttype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE contracttype TO postgres;


--
-- TOC entry 4592 (class 0 OID 0)
-- Dependencies: 2303
-- Name: country; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE country FROM PUBLIC;
REVOKE ALL ON TABLE country FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE country TO postgres;


--
-- TOC entry 4594 (class 0 OID 0)
-- Dependencies: 2305
-- Name: daypart; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE daypart FROM PUBLIC;
REVOKE ALL ON TABLE daypart FROM postgres;
GRANT ALL ON TABLE daypart TO postgres;


--
-- TOC entry 4596 (class 0 OID 0)
-- Dependencies: 2307
-- Name: discipline; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE discipline FROM PUBLIC;
REVOKE ALL ON TABLE discipline FROM postgres;
GRANT ALL ON TABLE discipline TO postgres;


--
-- TOC entry 4598 (class 0 OID 0)
-- Dependencies: 2309
-- Name: disciplinegroup; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE disciplinegroup FROM PUBLIC;
REVOKE ALL ON TABLE disciplinegroup FROM postgres;
GRANT ALL ON TABLE disciplinegroup TO postgres;


--
-- TOC entry 4600 (class 0 OID 0)
-- Dependencies: 2311
-- Name: district; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE district FROM PUBLIC;
REVOKE ALL ON TABLE district FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE district TO postgres;


--
-- TOC entry 4602 (class 0 OID 0)
-- Dependencies: 2313
-- Name: educationtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE educationtype FROM PUBLIC;
REVOKE ALL ON TABLE educationtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE educationtype TO postgres;


--
-- TOC entry 4604 (class 0 OID 0)
-- Dependencies: 2315
-- Name: endgrade; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE endgrade FROM PUBLIC;
REVOKE ALL ON TABLE endgrade FROM postgres;
GRANT ALL ON TABLE endgrade TO postgres;


--
-- TOC entry 4606 (class 0 OID 0)
-- Dependencies: 2317
-- Name: endgradegeneral; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE endgradegeneral FROM PUBLIC;
REVOKE ALL ON TABLE endgradegeneral FROM postgres;
GRANT ALL ON TABLE endgradegeneral TO postgres;


--
-- TOC entry 4608 (class 0 OID 0)
-- Dependencies: 2319
-- Name: endgradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE endgradetype FROM PUBLIC;
REVOKE ALL ON TABLE endgradetype FROM postgres;
GRANT ALL ON TABLE endgradetype TO postgres;


--
-- TOC entry 4611 (class 0 OID 0)
-- Dependencies: 2322
-- Name: examination; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE examination FROM PUBLIC;
REVOKE ALL ON TABLE examination FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE examination TO postgres;


--
-- TOC entry 4613 (class 0 OID 0)
-- Dependencies: 2324
-- Name: examinationresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE examinationresult FROM PUBLIC;
REVOKE ALL ON TABLE examinationresult FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE examinationresult TO postgres;


--
-- TOC entry 4615 (class 0 OID 0)
-- Dependencies: 2326
-- Name: examinationteacher; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE examinationteacher FROM PUBLIC;
REVOKE ALL ON TABLE examinationteacher FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE examinationteacher TO postgres;


--
-- TOC entry 4617 (class 0 OID 0)
-- Dependencies: 2328
-- Name: examinationtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE examinationtype FROM PUBLIC;
REVOKE ALL ON TABLE examinationtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE examinationtype TO postgres;


--
-- TOC entry 4620 (class 0 OID 0)
-- Dependencies: 2331
-- Name: examtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE examtype FROM PUBLIC;
REVOKE ALL ON TABLE examtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE examtype TO postgres;


--
-- TOC entry 4622 (class 0 OID 0)
-- Dependencies: 2333
-- Name: expellationtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE expellationtype FROM PUBLIC;
REVOKE ALL ON TABLE expellationtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE expellationtype TO postgres;


--
-- TOC entry 4624 (class 0 OID 0)
-- Dependencies: 2335
-- Name: failgrade; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE failgrade FROM PUBLIC;
REVOKE ALL ON TABLE failgrade FROM postgres;
GRANT ALL ON TABLE failgrade TO postgres;


--
-- TOC entry 4626 (class 0 OID 0)
-- Dependencies: 2337
-- Name: fee_fee; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE fee_fee FROM PUBLIC;
REVOKE ALL ON TABLE fee_fee FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE fee_fee TO postgres;


--
-- TOC entry 4628 (class 0 OID 0)
-- Dependencies: 2339
-- Name: fee_feecategory; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE fee_feecategory FROM PUBLIC;
REVOKE ALL ON TABLE fee_feecategory FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE fee_feecategory TO postgres;


--
-- TOC entry 4630 (class 0 OID 0)
-- Dependencies: 2341
-- Name: fee_feedeadline; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE fee_feedeadline FROM PUBLIC;
REVOKE ALL ON TABLE fee_feedeadline FROM postgres;
GRANT ALL ON TABLE fee_feedeadline TO postgres;


--
-- TOC entry 4632 (class 0 OID 0)
-- Dependencies: 2343
-- Name: fee_payment; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE fee_payment FROM PUBLIC;
REVOKE ALL ON TABLE fee_payment FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE fee_payment TO postgres;


--
-- TOC entry 4634 (class 0 OID 0)
-- Dependencies: 2345
-- Name: fee_unit; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE fee_unit FROM PUBLIC;
REVOKE ALL ON TABLE fee_unit FROM postgres;
GRANT ALL ON TABLE fee_unit TO postgres;


--
-- TOC entry 4636 (class 0 OID 0)
-- Dependencies: 2347
-- Name: fieldofeducation; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE fieldofeducation FROM PUBLIC;
REVOKE ALL ON TABLE fieldofeducation FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE fieldofeducation TO postgres;


--
-- TOC entry 4638 (class 0 OID 0)
-- Dependencies: 2349
-- Name: financialrequest; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE financialrequest FROM PUBLIC;
REVOKE ALL ON TABLE financialrequest FROM postgres;
GRANT ALL ON TABLE financialrequest TO postgres;


--
-- TOC entry 4640 (class 0 OID 0)
-- Dependencies: 2351
-- Name: financialtransaction; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE financialtransaction FROM PUBLIC;
REVOKE ALL ON TABLE financialtransaction FROM postgres;
GRANT ALL ON TABLE financialtransaction TO postgres;


--
-- TOC entry 4642 (class 0 OID 0)
-- Dependencies: 2353
-- Name: frequency; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE frequency FROM PUBLIC;
REVOKE ALL ON TABLE frequency FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE frequency TO postgres;


--
-- TOC entry 4644 (class 0 OID 0)
-- Dependencies: 2355
-- Name: function; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE function FROM PUBLIC;
REVOKE ALL ON TABLE function FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE function TO postgres;


--
-- TOC entry 4646 (class 0 OID 0)
-- Dependencies: 2357
-- Name: functionlevel; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE functionlevel FROM PUBLIC;
REVOKE ALL ON TABLE functionlevel FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE functionlevel TO postgres;


--
-- TOC entry 4648 (class 0 OID 0)
-- Dependencies: 2359
-- Name: gender; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE gender FROM PUBLIC;
REVOKE ALL ON TABLE gender FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE gender TO postgres;


--
-- TOC entry 4650 (class 0 OID 0)
-- Dependencies: 2361
-- Name: gradedsecondaryschoolsubject; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE gradedsecondaryschoolsubject FROM PUBLIC;
REVOKE ALL ON TABLE gradedsecondaryschoolsubject FROM postgres;
GRANT ALL ON TABLE gradedsecondaryschoolsubject TO postgres;


--
-- TOC entry 4652 (class 0 OID 0)
-- Dependencies: 2363
-- Name: gradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE gradetype FROM PUBLIC;
REVOKE ALL ON TABLE gradetype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE gradetype TO postgres;


--
-- TOC entry 4654 (class 0 OID 0)
-- Dependencies: 2365
-- Name: groupeddiscipline; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE groupeddiscipline FROM PUBLIC;
REVOKE ALL ON TABLE groupeddiscipline FROM postgres;
GRANT ALL ON TABLE groupeddiscipline TO postgres;


--
-- TOC entry 4656 (class 0 OID 0)
-- Dependencies: 2367
-- Name: groupedsecondaryschoolsubject; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE groupedsecondaryschoolsubject FROM PUBLIC;
REVOKE ALL ON TABLE groupedsecondaryschoolsubject FROM postgres;
GRANT ALL ON TABLE groupedsecondaryschoolsubject TO postgres;


--
-- TOC entry 4658 (class 0 OID 0)
-- Dependencies: 2369
-- Name: identificationtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE identificationtype FROM PUBLIC;
REVOKE ALL ON TABLE identificationtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE identificationtype TO postgres;


--
-- TOC entry 4660 (class 0 OID 0)
-- Dependencies: 2371
-- Name: importancetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE importancetype FROM PUBLIC;
REVOKE ALL ON TABLE importancetype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE importancetype TO postgres;


--
-- TOC entry 4662 (class 0 OID 0)
-- Dependencies: 2373
-- Name: institution; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE institution FROM PUBLIC;
REVOKE ALL ON TABLE institution FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE institution TO postgres;


--
-- TOC entry 4664 (class 0 OID 0)
-- Dependencies: 2375
-- Name: language; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE language FROM PUBLIC;
REVOKE ALL ON TABLE language FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE language TO postgres;


--
-- TOC entry 4666 (class 0 OID 0)
-- Dependencies: 2377
-- Name: levelofeducation; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE levelofeducation FROM PUBLIC;
REVOKE ALL ON TABLE levelofeducation FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE levelofeducation TO postgres;


--
-- TOC entry 4668 (class 0 OID 0)
-- Dependencies: 2379
-- Name: logmailerror; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE logmailerror FROM PUBLIC;
REVOKE ALL ON TABLE logmailerror FROM postgres;
GRANT ALL ON TABLE logmailerror TO postgres;


--
-- TOC entry 4670 (class 0 OID 0)
-- Dependencies: 2381
-- Name: logrequesterror; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE logrequesterror FROM PUBLIC;
REVOKE ALL ON TABLE logrequesterror FROM postgres;
GRANT ALL ON TABLE logrequesterror TO postgres;


--
-- TOC entry 4672 (class 0 OID 0)
-- Dependencies: 2383
-- Name: lookuptable; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE lookuptable FROM PUBLIC;
REVOKE ALL ON TABLE lookuptable FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE lookuptable TO postgres;


--
-- TOC entry 4674 (class 0 OID 0)
-- Dependencies: 2385
-- Name: mailconfig; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE mailconfig FROM PUBLIC;
REVOKE ALL ON TABLE mailconfig FROM postgres;
GRANT ALL ON TABLE mailconfig TO postgres;


--
-- TOC entry 4676 (class 0 OID 0)
-- Dependencies: 2387
-- Name: masteringlevel; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE masteringlevel FROM PUBLIC;
REVOKE ALL ON TABLE masteringlevel FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE masteringlevel TO postgres;


--
-- TOC entry 4678 (class 0 OID 0)
-- Dependencies: 2389
-- Name: nationality; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE nationality FROM PUBLIC;
REVOKE ALL ON TABLE nationality FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE nationality TO postgres;


--
-- TOC entry 4680 (class 0 OID 0)
-- Dependencies: 2391
-- Name: nationalitygroup; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE nationalitygroup FROM PUBLIC;
REVOKE ALL ON TABLE nationalitygroup FROM postgres;
GRANT ALL ON TABLE nationalitygroup TO postgres;


--
-- TOC entry 4682 (class 0 OID 0)
-- Dependencies: 2393
-- Name: obtainedqualification; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE obtainedqualification FROM PUBLIC;
REVOKE ALL ON TABLE obtainedqualification FROM postgres;
GRANT ALL ON TABLE obtainedqualification TO postgres;


--
-- TOC entry 4684 (class 0 OID 0)
-- Dependencies: 2395
-- Name: opusprivilege; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE opusprivilege FROM PUBLIC;
REVOKE ALL ON TABLE opusprivilege FROM postgres;
GRANT ALL ON TABLE opusprivilege TO postgres;


--
-- TOC entry 4686 (class 0 OID 0)
-- Dependencies: 2397
-- Name: opusrole_privilege; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE opusrole_privilege FROM PUBLIC;
REVOKE ALL ON TABLE opusrole_privilege FROM postgres;
GRANT ALL ON TABLE opusrole_privilege TO postgres;


--
-- TOC entry 4688 (class 0 OID 0)
-- Dependencies: 2399
-- Name: opususer; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE opususer FROM PUBLIC;
REVOKE ALL ON TABLE opususer FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE opususer TO postgres;


--
-- TOC entry 4690 (class 0 OID 0)
-- Dependencies: 2401
-- Name: opususerrole; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE opususerrole FROM PUBLIC;
REVOKE ALL ON TABLE opususerrole FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE opususerrole TO postgres;


--
-- TOC entry 4692 (class 0 OID 0)
-- Dependencies: 2403
-- Name: penalty; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE penalty FROM PUBLIC;
REVOKE ALL ON TABLE penalty FROM postgres;
GRANT ALL ON TABLE penalty TO postgres;


--
-- TOC entry 4694 (class 0 OID 0)
-- Dependencies: 2405
-- Name: penaltytype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE penaltytype FROM PUBLIC;
REVOKE ALL ON TABLE penaltytype FROM postgres;
GRANT ALL ON TABLE penaltytype TO postgres;


--
-- TOC entry 4696 (class 0 OID 0)
-- Dependencies: 2407
-- Name: person; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE person FROM PUBLIC;
REVOKE ALL ON TABLE person FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE person TO postgres;


--
-- TOC entry 4698 (class 0 OID 0)
-- Dependencies: 2409
-- Name: profession; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE profession FROM PUBLIC;
REVOKE ALL ON TABLE profession FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE profession TO postgres;


--
-- TOC entry 4700 (class 0 OID 0)
-- Dependencies: 2411
-- Name: progressstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE progressstatus FROM PUBLIC;
REVOKE ALL ON TABLE progressstatus FROM postgres;
GRANT ALL ON TABLE progressstatus TO postgres;


--
-- TOC entry 4702 (class 0 OID 0)
-- Dependencies: 2413
-- Name: province; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE province FROM PUBLIC;
REVOKE ALL ON TABLE province FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE province TO postgres;


--
-- TOC entry 4704 (class 0 OID 0)
-- Dependencies: 2415
-- Name: referee; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE referee FROM PUBLIC;
REVOKE ALL ON TABLE referee FROM postgres;
GRANT ALL ON TABLE referee TO postgres;


--
-- TOC entry 4706 (class 0 OID 0)
-- Dependencies: 2417
-- Name: relationtype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE relationtype FROM PUBLIC;
REVOKE ALL ON TABLE relationtype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE relationtype TO postgres;


--
-- TOC entry 4708 (class 0 OID 0)
-- Dependencies: 2419
-- Name: reportproperty; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE reportproperty FROM PUBLIC;
REVOKE ALL ON TABLE reportproperty FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE reportproperty TO postgres;


--
-- TOC entry 4709 (class 0 OID 0)
-- Dependencies: 2420
-- Name: requestadmissionperiod; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE requestadmissionperiod FROM PUBLIC;
REVOKE ALL ON TABLE requestadmissionperiod FROM postgres;
GRANT ALL ON TABLE requestadmissionperiod TO postgres;


--
-- TOC entry 4712 (class 0 OID 0)
-- Dependencies: 2424
-- Name: rfcstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE rfcstatus FROM PUBLIC;
REVOKE ALL ON TABLE rfcstatus FROM postgres;
GRANT ALL ON TABLE rfcstatus TO postgres;


--
-- TOC entry 4714 (class 0 OID 0)
-- Dependencies: 2426
-- Name: rigiditytype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE rigiditytype FROM PUBLIC;
REVOKE ALL ON TABLE rigiditytype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE rigiditytype TO postgres;


--
-- TOC entry 4716 (class 0 OID 0)
-- Dependencies: 2428
-- Name: role; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE role FROM PUBLIC;
REVOKE ALL ON TABLE role FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE role TO postgres;


--
-- TOC entry 4718 (class 0 OID 0)
-- Dependencies: 2430
-- Name: sch_bank; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_bank FROM PUBLIC;
REVOKE ALL ON TABLE sch_bank FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_bank TO postgres;


--
-- TOC entry 4720 (class 0 OID 0)
-- Dependencies: 2432
-- Name: sch_complaint; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_complaint FROM PUBLIC;
REVOKE ALL ON TABLE sch_complaint FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_complaint TO postgres;


--
-- TOC entry 4722 (class 0 OID 0)
-- Dependencies: 2434
-- Name: sch_complaintstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_complaintstatus FROM PUBLIC;
REVOKE ALL ON TABLE sch_complaintstatus FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_complaintstatus TO postgres;


--
-- TOC entry 4724 (class 0 OID 0)
-- Dependencies: 2436
-- Name: sch_decisioncriteria; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_decisioncriteria FROM PUBLIC;
REVOKE ALL ON TABLE sch_decisioncriteria FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_decisioncriteria TO postgres;


--
-- TOC entry 4726 (class 0 OID 0)
-- Dependencies: 2438
-- Name: sch_scholarship; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_scholarship FROM PUBLIC;
REVOKE ALL ON TABLE sch_scholarship FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_scholarship TO postgres;


--
-- TOC entry 4728 (class 0 OID 0)
-- Dependencies: 2440
-- Name: sch_scholarshipapplication; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_scholarshipapplication FROM PUBLIC;
REVOKE ALL ON TABLE sch_scholarshipapplication FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_scholarshipapplication TO postgres;


--
-- TOC entry 4730 (class 0 OID 0)
-- Dependencies: 2442
-- Name: sch_scholarshiptype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_scholarshiptype FROM PUBLIC;
REVOKE ALL ON TABLE sch_scholarshiptype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_scholarshiptype TO postgres;


--
-- TOC entry 4732 (class 0 OID 0)
-- Dependencies: 2444
-- Name: sch_sponsor; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_sponsor FROM PUBLIC;
REVOKE ALL ON TABLE sch_sponsor FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_sponsor TO postgres;


--
-- TOC entry 4734 (class 0 OID 0)
-- Dependencies: 2446
-- Name: sch_sponsorfeepercentage; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_sponsorfeepercentage FROM PUBLIC;
REVOKE ALL ON TABLE sch_sponsorfeepercentage FROM postgres;
GRANT ALL ON TABLE sch_sponsorfeepercentage TO postgres;


--
-- TOC entry 4736 (class 0 OID 0)
-- Dependencies: 2448
-- Name: sch_sponsorpayment; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_sponsorpayment FROM PUBLIC;
REVOKE ALL ON TABLE sch_sponsorpayment FROM postgres;
GRANT ALL ON TABLE sch_sponsorpayment TO postgres;


--
-- TOC entry 4738 (class 0 OID 0)
-- Dependencies: 2450
-- Name: sch_sponsortype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_sponsortype FROM PUBLIC;
REVOKE ALL ON TABLE sch_sponsortype FROM postgres;
GRANT ALL ON TABLE sch_sponsortype TO postgres;


--
-- TOC entry 4740 (class 0 OID 0)
-- Dependencies: 2452
-- Name: sch_student; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_student FROM PUBLIC;
REVOKE ALL ON TABLE sch_student FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_student TO postgres;


--
-- TOC entry 4742 (class 0 OID 0)
-- Dependencies: 2454
-- Name: sch_subsidy; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_subsidy FROM PUBLIC;
REVOKE ALL ON TABLE sch_subsidy FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_subsidy TO postgres;


--
-- TOC entry 4744 (class 0 OID 0)
-- Dependencies: 2456
-- Name: sch_subsidytype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE sch_subsidytype FROM PUBLIC;
REVOKE ALL ON TABLE sch_subsidytype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE sch_subsidytype TO postgres;


--
-- TOC entry 4746 (class 0 OID 0)
-- Dependencies: 2458
-- Name: secondaryschoolsubject; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE secondaryschoolsubject FROM PUBLIC;
REVOKE ALL ON TABLE secondaryschoolsubject FROM postgres;
GRANT ALL ON TABLE secondaryschoolsubject TO postgres;


--
-- TOC entry 4748 (class 0 OID 0)
-- Dependencies: 2460
-- Name: secondaryschoolsubjectgroup; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE secondaryschoolsubjectgroup FROM PUBLIC;
REVOKE ALL ON TABLE secondaryschoolsubjectgroup FROM postgres;
GRANT ALL ON TABLE secondaryschoolsubjectgroup TO postgres;


--
-- TOC entry 4750 (class 0 OID 0)
-- Dependencies: 2462
-- Name: staffmember; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE staffmember FROM PUBLIC;
REVOKE ALL ON TABLE staffmember FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE staffmember TO postgres;


--
-- TOC entry 4751 (class 0 OID 0)
-- Dependencies: 2463
-- Name: staffmemberfunction; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE staffmemberfunction FROM PUBLIC;
REVOKE ALL ON TABLE staffmemberfunction FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE staffmemberfunction TO postgres;


--
-- TOC entry 4753 (class 0 OID 0)
-- Dependencies: 2465
-- Name: stafftype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE stafftype FROM PUBLIC;
REVOKE ALL ON TABLE stafftype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE stafftype TO postgres;


--
-- TOC entry 4755 (class 0 OID 0)
-- Dependencies: 2467
-- Name: status; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE status FROM PUBLIC;
REVOKE ALL ON TABLE status FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE status TO postgres;


--
-- TOC entry 4757 (class 0 OID 0)
-- Dependencies: 2469
-- Name: student; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE student FROM PUBLIC;
REVOKE ALL ON TABLE student FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE student TO postgres;


--
-- TOC entry 4759 (class 0 OID 0)
-- Dependencies: 2471
-- Name: studentabsence; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentabsence FROM PUBLIC;
REVOKE ALL ON TABLE studentabsence FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studentabsence TO postgres;


--
-- TOC entry 4761 (class 0 OID 0)
-- Dependencies: 2473
-- Name: studentactivity; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentactivity FROM PUBLIC;
REVOKE ALL ON TABLE studentactivity FROM postgres;
GRANT ALL ON TABLE studentactivity TO postgres;


--
-- TOC entry 4763 (class 0 OID 0)
-- Dependencies: 2475
-- Name: studentbalance; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentbalance FROM PUBLIC;
REVOKE ALL ON TABLE studentbalance FROM postgres;
GRANT ALL ON TABLE studentbalance TO postgres;


--
-- TOC entry 4765 (class 0 OID 0)
-- Dependencies: 2477
-- Name: studentcareer; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentcareer FROM PUBLIC;
REVOKE ALL ON TABLE studentcareer FROM postgres;
GRANT ALL ON TABLE studentcareer TO postgres;


--
-- TOC entry 4767 (class 0 OID 0)
-- Dependencies: 2479
-- Name: studentcounseling; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentcounseling FROM PUBLIC;
REVOKE ALL ON TABLE studentcounseling FROM postgres;
GRANT ALL ON TABLE studentcounseling TO postgres;


--
-- TOC entry 4769 (class 0 OID 0)
-- Dependencies: 2481
-- Name: studentexpulsion; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentexpulsion FROM PUBLIC;
REVOKE ALL ON TABLE studentexpulsion FROM postgres;
GRANT ALL ON TABLE studentexpulsion TO postgres;


--
-- TOC entry 4771 (class 0 OID 0)
-- Dependencies: 2483
-- Name: studentplacement; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentplacement FROM PUBLIC;
REVOKE ALL ON TABLE studentplacement FROM postgres;
GRANT ALL ON TABLE studentplacement TO postgres;


--
-- TOC entry 4773 (class 0 OID 0)
-- Dependencies: 2485
-- Name: studentstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentstatus FROM PUBLIC;
REVOKE ALL ON TABLE studentstatus FROM postgres;
GRANT ALL ON TABLE studentstatus TO postgres;


--
-- TOC entry 4775 (class 0 OID 0)
-- Dependencies: 2487
-- Name: studentstudentstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studentstudentstatus FROM PUBLIC;
REVOKE ALL ON TABLE studentstudentstatus FROM postgres;
GRANT ALL ON TABLE studentstudentstatus TO postgres;


--
-- TOC entry 4777 (class 0 OID 0)
-- Dependencies: 2489
-- Name: study; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE study FROM PUBLIC;
REVOKE ALL ON TABLE study FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE study TO postgres;


--
-- TOC entry 4779 (class 0 OID 0)
-- Dependencies: 2491
-- Name: studyform; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyform FROM PUBLIC;
REVOKE ALL ON TABLE studyform FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studyform TO postgres;


--
-- TOC entry 4781 (class 0 OID 0)
-- Dependencies: 2493
-- Name: studygradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studygradetype FROM PUBLIC;
REVOKE ALL ON TABLE studygradetype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studygradetype TO postgres;


--
-- TOC entry 4782 (class 0 OID 0)
-- Dependencies: 2494
-- Name: studygradetypeprerequisite; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studygradetypeprerequisite FROM PUBLIC;
REVOKE ALL ON TABLE studygradetypeprerequisite FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studygradetypeprerequisite TO postgres;


--
-- TOC entry 4784 (class 0 OID 0)
-- Dependencies: 2496
-- Name: studyintensity; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyintensity FROM PUBLIC;
REVOKE ALL ON TABLE studyintensity FROM postgres;
GRANT ALL ON TABLE studyintensity TO postgres;


--
-- TOC entry 4786 (class 0 OID 0)
-- Dependencies: 2498
-- Name: studyplan; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyplan FROM PUBLIC;
REVOKE ALL ON TABLE studyplan FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studyplan TO postgres;


--
-- TOC entry 4788 (class 0 OID 0)
-- Dependencies: 2500
-- Name: studyplancardinaltimeunit; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyplancardinaltimeunit FROM PUBLIC;
REVOKE ALL ON TABLE studyplancardinaltimeunit FROM postgres;
GRANT ALL ON TABLE studyplancardinaltimeunit TO postgres;


--
-- TOC entry 4790 (class 0 OID 0)
-- Dependencies: 2502
-- Name: studyplandetail; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyplandetail FROM PUBLIC;
REVOKE ALL ON TABLE studyplandetail FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studyplandetail TO postgres;


--
-- TOC entry 4791 (class 0 OID 0)
-- Dependencies: 2503
-- Name: studyplanresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyplanresult FROM PUBLIC;
REVOKE ALL ON TABLE studyplanresult FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studyplanresult TO postgres;


--
-- TOC entry 4793 (class 0 OID 0)
-- Dependencies: 2505
-- Name: studyplanstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studyplanstatus FROM PUBLIC;
REVOKE ALL ON TABLE studyplanstatus FROM postgres;
GRANT ALL ON TABLE studyplanstatus TO postgres;


--
-- TOC entry 4795 (class 0 OID 0)
-- Dependencies: 2507
-- Name: studytime; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studytime FROM PUBLIC;
REVOKE ALL ON TABLE studytime FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studytime TO postgres;


--
-- TOC entry 4797 (class 0 OID 0)
-- Dependencies: 2509
-- Name: studytype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE studytype FROM PUBLIC;
REVOKE ALL ON TABLE studytype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE studytype TO postgres;


--
-- TOC entry 4799 (class 0 OID 0)
-- Dependencies: 2511
-- Name: subject; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subject FROM PUBLIC;
REVOKE ALL ON TABLE subject FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subject TO postgres;


--
-- TOC entry 4801 (class 0 OID 0)
-- Dependencies: 2513
-- Name: subjectblock; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectblock FROM PUBLIC;
REVOKE ALL ON TABLE subjectblock FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectblock TO postgres;


--
-- TOC entry 4802 (class 0 OID 0)
-- Dependencies: 2514
-- Name: subjectblockprerequisite; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectblockprerequisite FROM PUBLIC;
REVOKE ALL ON TABLE subjectblockprerequisite FROM postgres;
GRANT ALL ON TABLE subjectblockprerequisite TO postgres;


--
-- TOC entry 4804 (class 0 OID 0)
-- Dependencies: 2516
-- Name: subjectblockstudygradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectblockstudygradetype FROM PUBLIC;
REVOKE ALL ON TABLE subjectblockstudygradetype FROM postgres;
GRANT ALL ON TABLE subjectblockstudygradetype TO postgres;


--
-- TOC entry 4805 (class 0 OID 0)
-- Dependencies: 2517
-- Name: subjectprerequisite; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectprerequisite FROM PUBLIC;
REVOKE ALL ON TABLE subjectprerequisite FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectprerequisite TO postgres;


--
-- TOC entry 4807 (class 0 OID 0)
-- Dependencies: 2519
-- Name: subjectresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectresult FROM PUBLIC;
REVOKE ALL ON TABLE subjectresult FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectresult TO postgres;


--
-- TOC entry 4809 (class 0 OID 0)
-- Dependencies: 2521
-- Name: subjectstudygradetype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectstudygradetype FROM PUBLIC;
REVOKE ALL ON TABLE subjectstudygradetype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectstudygradetype TO postgres;


--
-- TOC entry 4811 (class 0 OID 0)
-- Dependencies: 2523
-- Name: subjectstudytype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectstudytype FROM PUBLIC;
REVOKE ALL ON TABLE subjectstudytype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectstudytype TO postgres;


--
-- TOC entry 4813 (class 0 OID 0)
-- Dependencies: 2525
-- Name: subjectsubjectblock; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectsubjectblock FROM PUBLIC;
REVOKE ALL ON TABLE subjectsubjectblock FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectsubjectblock TO postgres;


--
-- TOC entry 4815 (class 0 OID 0)
-- Dependencies: 2527
-- Name: subjectteacher; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE subjectteacher FROM PUBLIC;
REVOKE ALL ON TABLE subjectteacher FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE subjectteacher TO postgres;


--
-- TOC entry 4817 (class 0 OID 0)
-- Dependencies: 2529
-- Name: tabledependency; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE tabledependency FROM PUBLIC;
REVOKE ALL ON TABLE tabledependency FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE tabledependency TO postgres;


--
-- TOC entry 4819 (class 0 OID 0)
-- Dependencies: 2531
-- Name: targetgroup; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE targetgroup FROM PUBLIC;
REVOKE ALL ON TABLE targetgroup FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE targetgroup TO postgres;


--
-- TOC entry 4821 (class 0 OID 0)
-- Dependencies: 2533
-- Name: test; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE test FROM PUBLIC;
REVOKE ALL ON TABLE test FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE test TO postgres;


--
-- TOC entry 4823 (class 0 OID 0)
-- Dependencies: 2535
-- Name: testresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE testresult FROM PUBLIC;
REVOKE ALL ON TABLE testresult FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE testresult TO postgres;


--
-- TOC entry 4825 (class 0 OID 0)
-- Dependencies: 2537
-- Name: testteacher; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE testteacher FROM PUBLIC;
REVOKE ALL ON TABLE testteacher FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE testteacher TO postgres;


--
-- TOC entry 4827 (class 0 OID 0)
-- Dependencies: 2539
-- Name: thesis; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE thesis FROM PUBLIC;
REVOKE ALL ON TABLE thesis FROM postgres;
GRANT ALL ON TABLE thesis TO postgres;


--
-- TOC entry 4829 (class 0 OID 0)
-- Dependencies: 2541
-- Name: thesisresult; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE thesisresult FROM PUBLIC;
REVOKE ALL ON TABLE thesisresult FROM postgres;
GRANT ALL ON TABLE thesisresult TO postgres;


--
-- TOC entry 4831 (class 0 OID 0)
-- Dependencies: 2543
-- Name: thesisstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE thesisstatus FROM PUBLIC;
REVOKE ALL ON TABLE thesisstatus FROM postgres;
GRANT ALL ON TABLE thesisstatus TO postgres;


--
-- TOC entry 4833 (class 0 OID 0)
-- Dependencies: 2545
-- Name: thesissupervisor; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE thesissupervisor FROM PUBLIC;
REVOKE ALL ON TABLE thesissupervisor FROM postgres;
GRANT ALL ON TABLE thesissupervisor TO postgres;


--
-- TOC entry 4835 (class 0 OID 0)
-- Dependencies: 2547
-- Name: thesisthesisstatus; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE thesisthesisstatus FROM PUBLIC;
REVOKE ALL ON TABLE thesisthesisstatus FROM postgres;
GRANT ALL ON TABLE thesisthesisstatus TO postgres;


--
-- TOC entry 4837 (class 0 OID 0)
-- Dependencies: 2549
-- Name: timeunit; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE timeunit FROM PUBLIC;
REVOKE ALL ON TABLE timeunit FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE timeunit TO postgres;


--
-- TOC entry 4839 (class 0 OID 0)
-- Dependencies: 2551
-- Name: unitarea; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE unitarea FROM PUBLIC;
REVOKE ALL ON TABLE unitarea FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE unitarea TO postgres;


--
-- TOC entry 4841 (class 0 OID 0)
-- Dependencies: 2553
-- Name: unittype; Type: ACL; Schema: opuscollege; Owner: postgres
--

REVOKE ALL ON TABLE unittype FROM PUBLIC;
REVOKE ALL ON TABLE unittype FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE unittype TO postgres;


-- Completed on 2012-11-11 12:41:21

--
-- PostgreSQL database dump complete
--

