package kr.co.itcen.fa.vo.menu02;

import org.apache.ibatis.type.Alias;

/**
 * 
 * @author 이지은 
 * 매입거래처 테이블
 *
 */

@Alias("purchasecustomer35vo")
public class CustomerVo {
	private String no;						//사업자등록번호
	private String name;					//상호
	private String ceo;						//대표자
	private String corporationNo;			//법인번호
	private String zipCode;					//우편번호
	private String address;					//도로명주소
	private String detailAddress;			//상세주소
	private String phone;					//전화번호
	private String conditions;				//업태
	private String item;					//종목
	private String openDate;				//개설일자
	private String jurisdictionOffice;		//관할사무소
	private String managerName;				//거래처 담당자 성명
	private String managerEmail;			//담당자 Email
	private String depositNo;				//계좌번호
	private String depositHost;				//예금주
	private String insertUserid;			//입력자
	private String insertDay;				//입력일자
	private String updateUserid;			//수정자
	private String updateDay;				//수정일자
	private String deleteFlag;				//삭제 Flag
	
	public String getNo() {
		return no;
	}
	public void setNo(String no) {
		this.no = no;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCeo() {
		return ceo;
	}
	public void setCeo(String ceo) {
		this.ceo = ceo;
	}
	public String getCorporationNo() {
		return corporationNo;
	}
	public void setCorporationNo(String corporationNo) {
		this.corporationNo = corporationNo;
	}
	public String getZipCode() {
		return zipCode;
	}
	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getDetailAddress() {
		return detailAddress;
	}
	public void setDetailAddress(String detailAddress) {
		this.detailAddress = detailAddress;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getConditions() {
		return conditions;
	}
	public void setConditions(String conditions) {
		this.conditions = conditions;
	}
	public String getItem() {
		return item;
	}
	public void setItem(String item) {
		this.item = item;
	}
	public String getOpenDate() {
		return openDate;
	}
	public void setOpenDate(String openDate) {
		this.openDate = openDate;
	}
	public String getJurisdictionOffice() {
		return jurisdictionOffice;
	}
	public void setJurisdictionOffice(String jurisdictionOffice) {
		this.jurisdictionOffice = jurisdictionOffice;
	}
	public String getManagerName() {
		return managerName;
	}
	public void setManagerName(String managerName) {
		this.managerName = managerName;
	}
	public String getManagerEmail() {
		return managerEmail;
	}
	public void setManagerEmail(String managerEmail) {
		this.managerEmail = managerEmail;
	}
	public String getDepositNo() {
		return depositNo;
	}
	public void setDepositNo(String depositNo) {
		this.depositNo = depositNo;
	}
	public String getDepositHost() {
		return depositHost;
	}
	public void setDepositHost(String depositHost) {
		this.depositHost = depositHost;
	}
	public String getInsertUserid() {
		return insertUserid;
	}
	public void setInsertUserid(String insertUserid) {
		this.insertUserid = insertUserid;
	}
	public String getInsertDay() {
		return insertDay;
	}
	public void setInsertDay(String insertDay) {
		this.insertDay = insertDay;
	}
	public String getUpdateUserid() {
		return updateUserid;
	}
	public void setUpdateUserid(String updateUserid) {
		this.updateUserid = updateUserid;
	}
	public String getUpdateDay() {
		return updateDay;
	}
	public void setUpdateDay(String updateDay) {
		this.updateDay = updateDay;
	}
	public String getDeleteFlag() {
		return deleteFlag;
	}
	public void setDeleteFlag(String deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	
	@Override
	public String toString() {
		return "CustomerVo [no=" + no + ", name=" + name + ", ceo=" + ceo + ", corporationNo=" + corporationNo
				+ ", zipCode=" + zipCode + ", address=" + address + ", detailAddress=" + detailAddress + ", phone="
				+ phone + ", conditions=" + conditions + ", item=" + item + ", openDate=" + openDate
				+ ", jurisdictionOffice=" + jurisdictionOffice + ", managerName=" + managerName + ", managerEmail="
				+ managerEmail + ", depositNo=" + depositNo + ", depositHost=" + depositHost + ", insertUserid="
				+ insertUserid + ", insertDay=" + insertDay + ", updateUserid=" + updateUserid + ", updateDay="
				+ updateDay + ", deleteFlag=" + deleteFlag + "]";
	}
}
