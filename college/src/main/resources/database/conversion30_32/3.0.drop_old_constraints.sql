
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
