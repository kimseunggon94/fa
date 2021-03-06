package kr.co.itcen.fa.controller.menu11;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.co.itcen.fa.dto.JSONResult;
import kr.co.itcen.fa.security.Auth;
import kr.co.itcen.fa.security.AuthUser;
import kr.co.itcen.fa.service.menu01.Menu03Service;
import kr.co.itcen.fa.service.menu11.Menu48Service;
import kr.co.itcen.fa.service.menu17.Menu19Service;
import kr.co.itcen.fa.vo.UserVo;
import kr.co.itcen.fa.vo.menu01.ItemVo;
import kr.co.itcen.fa.vo.menu01.MappingVo;
import kr.co.itcen.fa.vo.menu01.VoucherVo;
import kr.co.itcen.fa.vo.menu11.LTermdebtVo;
import kr.co.itcen.fa.vo.menu11.RepayVo;
@Auth
@Controller("Menu48ApiController")
@RequestMapping("/" + Menu48Controller.MAINMENU)
public class Menu48ApiController {
	public static final String MAINMENU = "11";
	public static final String SUBMENU = "48";
	@Autowired
	private Menu48Service menu48Service;
	
	@Autowired 
	private Menu19Service menu19Service;
	
	@ResponseBody
	@RequestMapping("/"+SUBMENU+"/checkcode")
	public JSONResult checkCode(@RequestParam(value="code", required=true, defaultValue="") String code) {
		LTermdebtVo lvo = menu48Service.existCode(code);
		System.out.println(lvo);
        return JSONResult.success(lvo);
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/"+SUBMENU+"/repay", method = RequestMethod.POST)
	public JSONResult repay(@RequestBody RepayVo vo,@AuthUser UserVo uservo) {
		try {
			if(menu19Service.checkClosingDate(uservo, vo.getPayDate())) { 
				
				LTermdebtVo lvo = menu48Service.insert(vo,uservo);//상환 테이블에 insert -> 
				
				return JSONResult.success(lvo);
				}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return JSONResult.success(null);
	}
	
	
	@ResponseBody
	@RequestMapping("/"+SUBMENU+"/checkrepay")
	public JSONResult checkrepay(@RequestParam(value="no", required=true) Long no) {
		List<RepayVo> list = menu48Service.getRepay(no);
        return JSONResult.success(list);
	}
	@ResponseBody
	@RequestMapping("/"+SUBMENU+"/checkrepaylist")
	public JSONResult checkrepay(@RequestParam(value="no", required=true) Long[] no) {
		List<RepayVo> list = menu48Service.getRepay(no);
		System.out.println(list);
        return JSONResult.success(list);
	}
	
	@ResponseBody
	@RequestMapping("/"+SUBMENU+"/checkrepaydue")
	public JSONResult checkrepaydue() {
		List<LTermdebtVo> list = menu48Service.getRepayDueList();
		
        return JSONResult.success(list);
	}
	
	@ResponseBody
	@RequestMapping(value="/" + SUBMENU + "/getYearDebtStat", method = RequestMethod.POST)
	public JSONResult getYearDebtStat() {			//insert 내테이블에만 할때 사용
		Map map = menu48Service.getYearDebtStat();
		return JSONResult.success(map);
	}
	
	@ResponseBody
	@RequestMapping(value="/" + SUBMENU + "/getMonthDebtStat", method = RequestMethod.POST)
	public JSONResult getMonthDebtStat(@RequestParam(value="searchYear", required=false, defaultValue="2019") int searchYear) {			//insert 내테이블에만 할때 사용
		Map map = menu48Service.getMonthDebtStat(searchYear);
		return JSONResult.success(map);
	}
	
	@ResponseBody
	@RequestMapping(value="/" + SUBMENU + "/getYearIntStat", method = RequestMethod.POST)
	public JSONResult getYearIntStat() {
		Map map = menu48Service.getYearIntStat();
		return JSONResult.success(map);
	}
//	
	@ResponseBody
	@RequestMapping(value="/" + SUBMENU + "/getDebtRatio", method = RequestMethod.POST)
	public JSONResult getDebtRatio() {
		List<Map> list = menu48Service.getDebtRatioStat();
		return JSONResult.success(list);
	}
	
	
	
}