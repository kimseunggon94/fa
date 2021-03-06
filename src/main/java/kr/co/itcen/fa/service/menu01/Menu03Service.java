package kr.co.itcen.fa.service.menu01;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.itcen.fa.dto.DataResult;
import kr.co.itcen.fa.repository.menu01.Menu03Repository;
import kr.co.itcen.fa.security.AuthUser;
import kr.co.itcen.fa.service.menu17.Menu19Service;
import kr.co.itcen.fa.util.PaginationUtil;
import kr.co.itcen.fa.vo.UserVo;
import kr.co.itcen.fa.vo.menu01.ItemVo;
import kr.co.itcen.fa.vo.menu01.MappingVo;
import kr.co.itcen.fa.vo.menu01.VoucherVo;
import kr.co.itcen.fa.vo.menu17.AccountManagementVo;
import kr.co.itcen.fa.vo.menu17.ClosingDateVo;
import kr.co.itcen.fa.vo.menu17.StatementDataVo;

/**
 * 
 * @author 임성주
 * 전표관리
 *
 */
@Service
public class Menu03Service {
		
	@Autowired
	private Menu03Repository menu03Repository;
	
	@Autowired
	private Menu19Service menu19Service;
	
	public void test() {
		menu03Repository.test();
	}
	
	// 전표생성 (다른 팀)
	public Long createVoucher(VoucherVo voucherVo,  List<ItemVo> itemVo, MappingVo mappingVo, @AuthUser UserVo userVo) {
		//마감 여부 체크
		try {
			//String businessDateStr = menu03Repository.businessDateStr();
			List<MappingVo> mappingList = new ArrayList<MappingVo>();
			if(menu19Service.checkClosingDate(userVo, voucherVo.getRegDate())) {
				voucherVo.setInsertUserid(userVo.getId());
				for(int i = 0; i < itemVo.size(); i++) {
					itemVo.get(i).setInsertUserid(userVo.getId());
					
					MappingVo mappingVoTemp = new MappingVo();
					
					mappingVoTemp.setVoucherUse(mappingVo.getVoucherUse());
					mappingVoTemp.setCustomerNo(mappingVo.getCustomerNo());
					mappingVoTemp.setDepositNo(mappingVo.getDepositNo());
					mappingVoTemp.setManageNo(mappingVo.getManageNo());
					mappingVoTemp.setCardNo(mappingVo.getCardNo());
					mappingVoTemp.setInsertTeam(userVo.getTeamName());
					mappingVoTemp.setInsertUserid(userVo.getId());
					mappingVoTemp.setOrderNo(i+1);
					
					mappingList.add(mappingVoTemp);
				}
				
				menu03Repository.createVoucher(voucherVo, itemVo, mappingList);
				return voucherVo.getNo(); // 전표번호
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
		
	}
	
	// 전표 생성 1팀
	public Long createVoucher(VoucherVo voucherVo, List<ItemVo> itemVo, List<MappingVo> mappingList, UserVo userVo) {
		//마감 여부 체크
		try {
			//String businessDateStr = menu03Repository.businessDateStr();
			if(menu19Service.checkClosingDate(userVo, voucherVo.getRegDate())) {
				menu03Repository.createVoucher(voucherVo, itemVo, mappingList, userVo);
				
				return voucherVo.getNo(); // 전표번호
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
		
	}
	
	// 전표수정 1팀(최종)
	public Long updateVoucher(VoucherVo voucherVo, List<ItemVo> itemVo, List<MappingVo> mappingList, UserVo userVo) {
		//마감 여부 체크
		try {
			//String businessDateStr = menu03Repository.businessDateStr();
			if(menu19Service.checkClosingDate(userVo, voucherVo.getRegDate())) {
				menu03Repository.updateVoucher2(voucherVo, itemVo, mappingList, userVo);
				
				return voucherVo.getNo(); // 전표번호
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
		
	}
	
	// 전표수정 (다른 팀)
	public Long updateVoucher(VoucherVo voucherVo,  List<ItemVo> itemVo, MappingVo mappingVo, @AuthUser UserVo userVo) {
		
		//마감 여부 체크
		try {
			//String businessDateStr = menu03Repository.businessDateStr();
			voucherVo.setRegDate2(menu03Repository.getRegDate(voucherVo.getNo()));
			List<MappingVo> mappingList = new ArrayList<MappingVo>();
			System.out.println("setRegDate : " + voucherVo.getRegDate());
			System.out.println("setRegDate2 : " + voucherVo.getRegDate2());
			
			if(menu19Service.checkClosingDate(userVo, voucherVo.getRegDate2())) {
				voucherVo.setUpdateUserid(userVo.getId());
				for(int i = 0; i < itemVo.size(); i++) {
					
					itemVo.get(i).setUpdateUserid(userVo.getId());
					
					MappingVo mappingVoTemp = new MappingVo();
					
					mappingVoTemp.setVoucherUse(mappingVo.getVoucherUse());
					mappingVoTemp.setCustomerNo(mappingVo.getCustomerNo());
					mappingVoTemp.setDepositNo(mappingVo.getDepositNo());
					mappingVoTemp.setManageNo(mappingVo.getManageNo());
					mappingVoTemp.setCardNo(mappingVo.getCardNo());
					mappingVoTemp.setInsertTeam(userVo.getTeamName());
					mappingVoTemp.setInsertUserid(userVo.getId());
					mappingVoTemp.setOrderNo(i+1);
					
					mappingList.add(mappingVoTemp);
					
					voucherVo.setNo(menu03Repository.updateVoucher(voucherVo, itemVo, mappingList, userVo));
				}
				return voucherVo.getNo();
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	// 전표삭제 (다른 팀)
	public Long deleteVoucher(List<VoucherVo> voucherVo, @AuthUser UserVo userVo) {
		
			try {
				for(int i = 0; i < voucherVo.size(); i++) {
					voucherVo.get(i).setRegDate(menu03Repository.getRegDate(voucherVo.get(i).getNo()));
					//String businessDateStr = menu03Repository.businessDateStr();
					if(menu19Service.checkClosingDate(userVo, voucherVo.get(i).getRegDate())) {
						menu03Repository.deleteVoucher(voucherVo, userVo);
						return 1L;
					}
				}
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		return null;
	}
	
	// 전표삭제 (5팀)
	public Long deleteVoucher(String date, Long no, @AuthUser UserVo userVo) {
		try {
			//String businessDateStr = menu03Repository.businessDateStr();
			if(menu19Service.checkClosingDate(userVo, date)) {
				menu03Repository.deleteVoucher(no, userVo);
				return 1L;
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
		
	}
	
	
	// 페이징 처리
	public DataResult<VoucherVo> selectAllVoucherCount(int page) {
		DataResult<VoucherVo> dataResult = new DataResult<VoucherVo>();
		
		int totalCount = menu03Repository.selectAllVoucherCount();
		PaginationUtil paginationUtil = new PaginationUtil(page, totalCount, 11, 5);
		dataResult.setPagination(paginationUtil);
		
		List<VoucherVo> list = menu03Repository.selectAllVoucher(paginationUtil);
		dataResult.setDatas(list);
		
		return dataResult;
	}
	
	// 전표 관리페이지 조회
   public DataResult<VoucherVo> selectVoucherCount(VoucherVo voucherVo, int page) {
   
	   DataResult<VoucherVo> dataResult = new DataResult<VoucherVo>();
	   int totalCount = menu03Repository.selectVoucherCount(voucherVo);
	   PaginationUtil paginationUtil = new PaginationUtil(page, totalCount, 11, 5);
	   dataResult.setPagination(paginationUtil);
	   
	   List<VoucherVo> list = menu03Repository.selectVoucher(voucherVo, paginationUtil);
	   dataResult.setDatas(list);
	   
	   return dataResult;
   }
	
	// 전표생성 (1팀)
	public void createVoucher(VoucherVo voucherVo, @AuthUser UserVo userVo) {
		voucherVo.setInsertTeam(userVo.getTeamName());
		voucherVo.setInsertUserid(userVo.getId());
		voucherVo.setOrderNo(1);
		
		menu03Repository.createVoucher(voucherVo);
	}
	
	// 전표삭제
	public Boolean deleteVoucher(VoucherVo voucherVo) {
		return menu03Repository.deleteVoucher(voucherVo);
	}
	
	// 전표수정
	public Boolean updateVoucher(VoucherVo voucherVo) {
		return menu03Repository.updateVoucher(voucherVo);
		
	}
	
	
	// 결산
	public List<StatementDataVo> statementData(ClosingDateVo closingDataVo) {
		return menu03Repository.statementData(closingDataVo);
	}
	
	// 거래처, 은행, 계좌, 카드 조회
	public Map<String, Object> getCustomer(String customerNo) {
		Map<String, Object> map = menu03Repository.getCustomer(customerNo);
		return map;
	}
	
	// 결산 / 현재시간 구하기
	public String businessDateStr() {
		return menu03Repository.businessDateStr();
	}
	
	// 전표번호로 전표정보 조회하기
	public Map<String, Object> getVoucher(Long voucherNo) {
		return menu03Repository.getVoucher(voucherNo);
	}
	
	// 전표번호로 팀정보 구하기
	public String selectTeam(Long no) {
		return menu03Repository.getSelectTeam(no);
	}
	
	// 계정과목, 계정명칭 조회
	public List<AccountManagementVo> getAllAccountList() {
		return menu03Repository.getAllAccountList();
	}
	
	// 삭제할때 시간구하기
	public String getRegDate(VoucherVo voucherVo) {
		return menu03Repository.getRegDate(voucherVo.getNo());
	}

}