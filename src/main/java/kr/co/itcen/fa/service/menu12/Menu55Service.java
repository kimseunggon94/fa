package kr.co.itcen.fa.service.menu12;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.itcen.fa.repository.menu12.Menu55Repository;

/**
 * 
 * @author 곽세연
 * 품목별매입매출현황
 *
 */
@Service
public class Menu55Service {
	
	@Autowired
	private Menu55Repository menu55Repository;
	
	public void test() {
		menu55Repository.test();
	}

}
