select opuscollege.organizationalUnit.*
        from   opuscollege.organizationalUnit
        INNER JOIN opuscollege.study on opuscollege.study.organizationalUnitId = organizationalunit.id
        INNER JOIN opuscollege.student ON opuscollege.student.primaryStudyId = opuscollege.study.id
        where  opuscollege.student.personId = #value#