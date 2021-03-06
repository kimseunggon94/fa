package kr.co.itcen.fa.repository.menu11;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.itcen.fa.vo.menu11.RepayVo;
import kr.co.itcen.fa.vo.menu11.STermDebtVo;

/**
 * @author 반현길
 * 단기차입금관리
 */
@Repository
public class Menu46Repository {

	@Autowired
	private SqlSession sqlSession;
	
	public STermDebtVo get(Long no) {
		return sqlSession.selectOne("menu46.get", no);
	}
	public int exist(String code) {
		return sqlSession.selectOne("menu46.exist", code);
	}
	
	public Boolean existRepay(String code) {						
		int count = sqlSession.selectOne("menu46.existRepay", code);
		return  count > 0;				//존재하면 true
	}
	//기본, 조회
	public List<STermDebtVo> getList(Map map) {
		System.out.println("startRow : " + map.get("startRow") + " pageSize : " + map.get("pageSize"));
		return sqlSession.selectList("menu46.getList", map);
	}
	
	public int getTotalCnt(Map map) {
		System.out.println("financialYear : " + map.get("financialYear"));
		return sqlSession.selectOne("menu46.getTotalCnt", map);
	}
	
	//입력
	public Boolean insert(STermDebtVo sTermDebtVo) {
		int count = sqlSession.insert("menu46.insert", sTermDebtVo);
		return (count==1);
	}
	
	//수정
	public Boolean update(STermDebtVo sTermDebtVo) {
		System.out.println("--------repository update---------");
		System.out.println(sTermDebtVo.getVoucherNo());
		int count = sqlSession.update("menu46.update", sTermDebtVo);
		return (count==1);
	}
	
	public void updateDeleteFlag(List<STermDebtVo> list) {
		sqlSession.update("menu46.updateDeleteFlag", list);
	}
	
	public Boolean updateRepayBal(STermDebtVo vo) {
		int count = sqlSession.update("menu46.updateRepayBal",  vo);
		return (count==1);
	}
	
	public void insertRepay(RepayVo vo) {
		sqlSession.insert("menu46.insertRepay", vo);
	}
	
	public List<RepayVo> getRepayList(Long no){
		return sqlSession.selectList("menu46.getRepayList", no);
	}
	
	public List<STermDebtVo> getRepayDueList(Map dateMap) {
		return sqlSession.selectList("menu46.getRepayDueList", dateMap);
	}
	
	public List<Map> getYearSDebtStat(int searchYear) {
		return sqlSession.selectList("menu46.getYearSDebtStat", searchYear);
	}
	
	public List<Map> getYearLDebtStat(int searchYear) {
		return sqlSession.selectList("menu46.getYearLDebtStat", searchYear);
	}
	
	public List<Map> getYearPDebtStat(int searchYear) {
		return sqlSession.selectList("menu46.getYearPDebtStat", searchYear);
	}
	
	public List<Map> getMonthSDebtStat(int searchYear) {
		return sqlSession.selectList("menu46.getMonthSDebtStat", searchYear);
	}
	
	public List<Map> getMonthLDebtStat(int searchYear) {
		return sqlSession.selectList("menu46.getMonthLDebtStat", searchYear);
	}
	
	public List<Map> getMonthPDebtStat(int searchYear) {
		return sqlSession.selectList("menu46.getMonthPDebtStat", searchYear);
	}
	
	public List<Map> getYearIntStat(Map map) {
		return sqlSession.selectList("menu46.getYearIntStat", map);
	}

	public Map getDebtRatioStat() {
		return sqlSession.selectOne("menu46.getDebtRatioStat");
	}
}
