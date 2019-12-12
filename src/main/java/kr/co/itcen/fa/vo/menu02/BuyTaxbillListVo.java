package kr.co.itcen.fa.vo.menu02;

import org.apache.ibatis.type.Alias;

@Alias("buytaxbilllistvo")
public class BuyTaxbillListVo {
	private String startDate;
	private String endDate;
	private Long no;
	private String companyName;
	private String taxType;
	private String deleteFlag;
	private String order;
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public Long getNo() {
		return no;
	}
	public void setNo(Long no) {
		this.no = no;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public String getTaxType() {
		return taxType;
	}
	public void setTaxType(String taxType) {
		this.taxType = taxType;
	}
	public String getDeleteFlag() {
		return deleteFlag;
	}
	public void setDeleteFlag(String deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	public String getOrder() {
		return order;
	}
	public void setOrder(String order) {
		this.order = order;
	}
	@Override
	public String toString() {
		return "BuyTaxbillListVo [startDate=" + startDate + ", endDate=" + endDate + ", no=" + no + ", companyName="
				+ companyName + ", taxType=" + taxType + ", deleteFlag=" + deleteFlag + ", order=" + order + "]";
	}
	
}