package kr.co.itcen.fa.service.menu11;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.itcen.fa.repository.menu11.Menu46Repository;
import kr.co.itcen.fa.service.menu01.Menu03Service;
import kr.co.itcen.fa.util.Pagination;
import kr.co.itcen.fa.vo.UserVo;
import kr.co.itcen.fa.vo.menu01.BankAccountVo;
import kr.co.itcen.fa.vo.menu01.ItemVo;
import kr.co.itcen.fa.vo.menu01.MappingVo;
import kr.co.itcen.fa.vo.menu01.VoucherVo;
import kr.co.itcen.fa.vo.menu11.RepayVo;
import kr.co.itcen.fa.vo.menu11.STermDebtVo;

/**
 * 
 * @author 반현길
 * 단기차입금관리
 *
 */
@Service
public class Menu46Service {
	
	@Autowired
	private Menu46Repository menu46Repository;
	
	@Autowired
	Menu03Service menu03Service;
	
	public STermDebtVo get(Long no) {
		return menu46Repository.get(no);
	}
	//기본
	public Map getList() {
		return getList(null, null, 11, 1);
	}
	
	public Map getList(String code, String financialYear, int pageSize, int page) {
		Map map = new HashMap<>();
		map.put("code", code);
		map.put("financialYear", financialYear);
		int totalCnt = menu46Repository.getTotalCnt(map);
		Pagination pagination = new Pagination(page, totalCnt, pageSize);
		
		map.putAll(pagination.getRowRangeMap());						//Limit 범위 데이터 set
		List<STermDebtVo> list = menu46Repository.getList(map);
		System.out.println("pageSize : " + map.get("pageSize"));		//startRow가 찍히는지 확인하자
		System.out.println("totalCnt : " + pagination.getTotalCnt());
		
		map.clear();
		map.put("list", list);
		map.put("pagination", pagination);
		
		return map;
	}
	
	public void deleteChecked(List<STermDebtVo> list) {
		menu46Repository.updateDeleteFlag(list);
	}
	
	public void insert(STermDebtVo sTermDebtVo) throws ParseException {
		menu46Repository.insert(sTermDebtVo);
	}
	
	public void update(STermDebtVo sTermDebtVo) {
		menu46Repository.update(sTermDebtVo);
	}
	
	public Boolean exist(String code) {
		return (menu46Repository.exist(code) > 0);
	}
	
	public Boolean existRepay(String code) {
		return menu46Repository.existRepay(code);
	}
	//-------------------상환------------------------//
	public List<RepayVo> getRepayList(Long no){
		return menu46Repository.getRepayList(no);
	}
	public void updateRepayBal(STermDebtVo vo) {
		menu46Repository.updateRepayBal(vo);
	}
	
	public void insertRepay(RepayVo repayVo) {
		menu46Repository.insertRepay(repayVo);
	}
	//-------------------상환------------------------//
	
	//상환 데이터 전표입력
	public Long insertVoucherWithRepay(STermDebtVo stermdebtVo, RepayVo repayVo, UserVo userVo) {
		VoucherVo voucherVo = new VoucherVo();
		List<ItemVo> itemVoList = new ArrayList<ItemVo>();
		ItemVo itemVo = new ItemVo();
		ItemVo itemVo2 = new ItemVo();
		ItemVo itemVo3 = new ItemVo();
		
		MappingVo mappingVo = new MappingVo();
		voucherVo.setRegDate(repayVo.getPayDate());
		
		itemVo.setAmount(repayVo.getIntAmount());		//이자납입금
		itemVo.setAmountFlag("d");						//차변
		itemVo.setAccountNo(repayVo.getAccountNo());	//이자비용 계정과목코드
		itemVoList.add(itemVo);
		
		itemVo2.setAmount(repayVo.getPayPrinc());				//납입원금
		itemVo2.setAmountFlag("d");								//차변
		itemVo2.setAccountNo(stermdebtVo.getAccountNo());		//단기차입금 계정과목코드					
		itemVoList.add(itemVo2);
		
		itemVo3.setAmount(repayVo.getTotalPayPrinc());							//보통예금
		itemVo3.setAmountFlag("c");												//대변
		itemVo3.setAccountNo(new BankAccountVo().getAccountNo());				//보통예금 계정과목 코드
		itemVoList.add(itemVo3);
		
		mappingVo.setVoucherUse(stermdebtVo.getName());						//사용목적
		mappingVo.setSystemCode(stermdebtVo.getCode());						//차입금코드
		mappingVo.setCustomerNo(stermdebtVo.getBankCode());
		mappingVo.setDepositNo(stermdebtVo.getDepositNo());					//계좌번호
		
		//전표입력후 전표번호를 반환
		return menu03Service.createVoucher(voucherVo, itemVoList, mappingVo, userVo);
	}
	
	//차입금 데이터 전표입력
	public Long insertVoucherWithDebt(STermDebtVo vo, UserVo userVo) {
		List<ItemVo> itemVoList = new ArrayList<ItemVo>();
		ItemVo itemVo1 = new ItemVo();
		ItemVo itemVo2 = new ItemVo();
		
		itemVo1.setAmount(vo.getDebtAmount());							//보통예금
		itemVo1.setAmountFlag("d");										//차변
		itemVo1.setAccountNo(new BankAccountVo().getAccountNo());		//보통예금 계정과목코드
		itemVoList.add(itemVo1);
		
		itemVo2.setAmount(vo.getDebtAmount());							//단기차입금액
		itemVo2.setAmountFlag("c");										//대변
		itemVo2.setAccountNo(vo.getAccountNo());									//계정과목코드
		itemVoList.add(itemVo2);
		
		MappingVo mappingVo = new MappingVo();
		mappingVo.setVoucherUse(vo.getName());				//사용목적
		mappingVo.setSystemCode(vo.getCode());				//차입금코드
		mappingVo.setCustomerNo(vo.getBankCode());
		mappingVo.setDepositNo(vo.getDepositNo());			//계좌번호
		
		VoucherVo voucherVo = new VoucherVo();
		voucherVo.setRegDate(vo.getDebtDate());
		
		return menu03Service.createVoucher(voucherVo, itemVoList, mappingVo, userVo);
	}
	
	//차입금데이터 전표수정
	public Long updateVoucherWithDebt(STermDebtVo vo, UserVo userVo) {
		System.out.println("-------------updateVoucherWithDebt-------------");
		System.out.println("vo : " + vo);
		List<ItemVo> itemVoList = new ArrayList<ItemVo>();
		ItemVo itemVo1 = new ItemVo();
		ItemVo itemVo2 = new ItemVo();
		
		itemVo1.setAmount(vo.getDebtAmount());							//보통예금
		itemVo1.setAmountFlag("d");										//차변
		itemVo1.setAccountNo(new BankAccountVo().getAccountNo());		//보통예금 계정과목코드
		itemVo1.setVoucherNo(vo.getVoucherNo());
		itemVoList.add(itemVo1);
		
		itemVo2.setAmount(vo.getDebtAmount());							//단기차입금액
		itemVo2.setAmountFlag("c");										//대변
		itemVo2.setAccountNo(2401101L);									//계정과목코드
		itemVo2.setVoucherNo(vo.getVoucherNo());
		itemVoList.add(itemVo2);
		
		MappingVo mappingVo = new MappingVo();
		mappingVo.setVoucherUse(vo.getName());				//사용목적
		mappingVo.setSystemCode(vo.getCode());				//차입금코드
		mappingVo.setCustomerNo(vo.getBankCode());
		mappingVo.setDepositNo(vo.getDepositNo());			//계좌번호
		mappingVo.setVoucherNo(vo.getVoucherNo());			
		
		VoucherVo voucherVo = new VoucherVo();
		voucherVo.setNo(vo.getVoucherNo());
		voucherVo.setRegDate(vo.getDebtDate());
		
		return menu03Service.updateVoucher(voucherVo, itemVoList, mappingVo, userVo);
	}
	
	/**
	 * 상환내역이 있는 차입금은 삭제 List에서 제외시킨다. 그리고 상환내역 리스트를 가져온다.
	 */
	public List<List<RepayVo>> possibleDelete(List<STermDebtVo> list) {
		List<List<RepayVo>> repayLists = new ArrayList<>();					//각 차입금에 대한 상환내역 리스트를 담을 리스트
		
		for(STermDebtVo vo : list) {
			List<RepayVo> repayList = getRepayList(vo.getNo());
			if(repayList != null && repayList.size() != 0) {
				System.out.println("repayList : " + repayList);
				repayLists.add(repayList);
			}
		}
		return repayLists;
	}
	
	/**
	 * 	전표에서 삭제리스트 데이터 삭제
	 */
	public void deleteVoucerList(List<STermDebtVo> list, UserVo userVo) {
		List<VoucherVo> voucherVolist = new ArrayList<VoucherVo>();
		
		for(STermDebtVo sTermDebtvo : list) {
			VoucherVo vo = new VoucherVo();
			vo.setNo(sTermDebtvo.getVoucherNo());
			voucherVolist.add(vo);
		}
		
		menu03Service.deleteVoucher(voucherVolist, userVo);
	}
	public List<STermDebtVo> getRepayDueList() {
		List<STermDebtVo> list= null;
		try {
			list = menu46Repository.getRepayDueList(getDateMap());
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	
	//현재 날짜 일요일

	public String getCurSunday(){
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd");
		Calendar c = Calendar.getInstance();
		c.set(Calendar.DAY_OF_WEEK,Calendar.SUNDAY);
		c.add(c.DATE,7);
		
		System.out.println(formatter.format(c.getTime()));
		return formatter.format(c.getTime());
	}
	
	public Map getDateMap() throws ParseException {
		Calendar calendar = new GregorianCalendar(Locale.KOREA);
		SimpleDateFormat format1 = new SimpleDateFormat ( "yyyy-MM-dd");		//현재날짜만 가져오기위해 사용
		String dayOfSunday = getCurSunday();
		
		Map map = new HashMap();
		map.put("curYear",calendar.get(Calendar.YEAR));
		map.put("curMonth",calendar.get(Calendar.MONTH));
		map.put("curDay",calendar.get(Calendar.DATE));
		map.put("today", format1.parse(format1.format(calendar.getTime())));
		map.put("dateOfSunday",format1.parse(dayOfSunday));
		map.put("sunDay", dayOfSunday.substring(dayOfSunday.length()-2, dayOfSunday.length()));
		
		
		return map;
	}
}
