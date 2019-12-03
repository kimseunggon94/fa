package kr.co.itcen.fa.vo.menu17;

import org.apache.ibatis.type.Alias;

import kr.co.itcen.fa.util.PaginationUtil;

/**
 * @작성자:	kbetter3
 * @작성일:	Dec 2, 2019
 * @이메일:	kbetter3@gmail.com
 * 
 * 결산메뉴 공통 검색 폼
 */
@Alias("menu17SearchForm")
public class Menu17SearchForm {
	private String year;

	private Long accountOrder;           //계정과목 순서
	private Long accountNo;			     //계정과목 코드
	private String accountStatementType; //제무재표 구분
	
	private int page = 1;
	private PaginationUtil pagination;
	
	
	// Getter & Setter
	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}
	
	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public PaginationUtil getPagination() {
		return pagination;
	}

	public void setPagination(PaginationUtil pagination) {
		this.pagination = pagination;
	}

	public Long getAccountOrder() {
		return accountOrder;
	}

	public void setAccountOrder(Long accountOrder) {
		this.accountOrder = accountOrder;
	}

	public Long getAccountNo() {
		return accountNo;
	}

	public void setAccountNo(Long accountNo) {
		this.accountNo = accountNo;
	}

	public String getAccountStatementType() {
		return accountStatementType;
	}

	public void setAccountStatementType(String accountStatementType) {
		this.accountStatementType = accountStatementType;
	}

}
