package org.uci.opus.college.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.uci.opus.college.domain.DisciplineGroup;

public interface DisciplineGroupMapper {

    /*##################### DisciplineGroups queries ###############################*/

    DisciplineGroup findById(int id);
    DisciplineGroup findByCode(String code);
    List<DisciplineGroup> findDisciplineGroups(Map<String, Object> map);
    List<DisciplineGroup> findDisciplineGroups(@Param("searchValue") String searchValue, @Param("active") String active);

    void deleteById(int id);
    void update(DisciplineGroup disciplineGroup);
    int add(DisciplineGroup disciplineGroup);

}
