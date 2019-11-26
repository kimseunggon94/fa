package kr.co.itcen.fa.service.menu12;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.itcen.fa.repository.menu12.Menu15Repository;

/**
 * 
 * @author 양홍석
 * 매출거래처관리
 *
 */
@Service
public class Menu15Service {
	
	@Autowired
	private Menu15Repository menu15Repository;
	
	public void test() {
		menu15Repository.test();
	}

}