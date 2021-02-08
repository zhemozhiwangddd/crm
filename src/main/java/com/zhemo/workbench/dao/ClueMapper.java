package com.zhemo.workbench.dao;

import com.zhemo.workbench.domain.Clue;
import com.zhemo.workbench.domain.ClueExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ClueMapper {
    long countByExample(ClueExample example);

    int deleteByExample(ClueExample example);

    int deleteByPrimaryKey(String id);

    int insert(Clue record);

    int insertSelective(Clue record);

    List<Clue> selectByExample(ClueExample example);

    Clue selectByPrimaryKey(String id);

    Clue selectDetailByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") Clue record, @Param("example") ClueExample example);

    int updateByExample(@Param("record") Clue record, @Param("example") ClueExample example);

    int updateByPrimaryKeySelective(Clue record);

    int updateByPrimaryKey(Clue record);
}