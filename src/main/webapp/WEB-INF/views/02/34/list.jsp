<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 
<!DOCTYPE html>
<html lang="ko">
<head>
<c:import url="/WEB-INF/views/common/head.jsp" />

<script src="/fa/ace/assets/js/jquery-2.0.3.min.js"></script>
<script src="/fa/ace/assets/js/jquery-ui-1.10.3.full.min.js"></script>
<link href="/fa/ace/assets/css/jquery-ui-1.10.3.full.min.css" type="text/css" rel="stylesheet" />
<script src="/fa/ace/assets/js/ace-elements.min.js"></script>
<script src="/fa/ace/assets/js/ace.min.js"></script>
<script src="${pageContext.request.contextPath }/assets/ace/js/chosen.jquery.min.js"></script>
<link rel="stylesheet" href="/fa/assets/ace/css/chosen.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/ace/css/datepicker.css" />

<style>
	html, body {
	   overflow-x: hidden;
	   height: 100%;
	}
	
	.main-container {
	   height: calc(100% - 45px);
	   overflow-x: hidden;
	}
	
	.main-content {
	   overflow: auto;
	}
	
	.page-content {
	   min-width: 1280px;
	}
	
	@media screen and (max-width: 920px) {
	   .main-container {
	      height: calc(100% - 84px);
	   }
	}
</style>

<script type="text/javascript">
	$(function(){
		$(".chosen-select").chosen(); 
	});
	
	$(function() {
		$("#search-section-dialog").click(function(event) {
			$("#dialog-section-main").dialog({
				autoOpen : false
			});
			
			$("#dialog-section-main").dialog('open');
			$("#dialog-section-main").dialog({
				resizable: false,
				height: 400,
				width: 400,
				modal: true,
				close: function() {
					$("#search-section-name").data("searchsectionname", "");
					$("#search-section-name").val("");
					var search_sectiondata = $("#search-section-name").data("searchsectionname");
					var section_page_num = 1;
					var section_page_group = parseInt((section_page_num-1)/5);
					
					$.ajax({
						url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/sectionpaging",
						type:"get",
						dataType:"json",
						data:{"section_page" : section_page_num, "section_page_group" : section_page_group, "search_sectiondata" : search_sectiondata},
						success:function(data) {
							section_updateTable(data.pagesectionList, section_page_num);
							section_updatePagination(data.sectionListall, data.sectionList, section_page_num, section_page_group);
						}, error:function(error) {
							dialog("찾을 수 없는 대분류명입니다.", false);
						}
					});
				},
				buttons: {
					"확인": function() {
						$(this).dialog("close");
					}
				}
			});
		});
		
		$("#search-factory-dialog").click(function(event) {
			$("#dialog-factory-main").dialog({
				autoOpen : false
			});
			
			$("#dialog-factory-main").dialog('open');
			$("#dialog-factory-main").dialog({
				resizable: false,
			    height: 400,
			    width: 400,
			    modal: true,
			    close: function() {
			    	$("#search-factory-name").data("searchfactoryname", "");
			    	$("#search-factory-name").val("");
			    	var search_factorydata = $("#search-factory-name").data("searchfactoryname");
			    	var factory_page_num = 1;
			    	var factory_page_group = parseInt((factory_page_num-1)/5);
			    	
			    	$.ajax({
			    		url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/factorypaging",
			    		type:"get",
			    		dataType:"json",
			    		data:{"factory_page" : factory_page_num, "factory_page_group" : factory_page_group, "search_factorydata" : search_factorydata},
			    		success:function(data) {
			    			factory_updateTable(data.pagefactoryList, factory_page_num);
			    			factory_updatePagination(data.factoryListall, data.factoryList, factory_page_num, factory_page_group);
			    		}, error:function(error) {
			    			alert("찾을 수 없는 공장명입니다.");
			    		}
			    	});
			    },
			    buttons: {
			    	"확인": function() {
			    		$(this).dialog("close");
			    	}
			    }
			});
		});
		
		function isEmpty(value) {
			if(value == null || value.length === 0) {
				return "";
			} else {
				return value;
			}
		}
		
		function form_datas(no, sectionname, factoryname, price_start, price_end, name, sectioncode, factorycode, producedate_start, producedate_end, deleteflag) {
			$("#form").data("formdatasno", no);
			$("#form").data("formdatassectionname", sectionname);
			$("#form").data("formdatasfactoryname", factoryname);
			$("#form").data("formdataspricestart", price_start);
			$("#form").data("formdataspriceend", price_end);
			$("#form").data("formdatasname", name);
			$("#form").data("formdatassectioncode", sectioncode);
			$("#form").data("formdatasfactorycode", factorycode);
			$("#form").data("formdatasproducedatestart", producedate_start);
			$("#form").data("formdatasproducedateend", producedate_end);
			$("#form").data("formdatasdeleteflag", deleteflag);
		}
		
		$("body").on("click", "#purchaseitem_search", function(e) {
			e.preventDefault();
			
			if($("input:checkbox[id='id-delete-check']").is(":checked") == true) {
				$("#id-delete-check").data("deleteflag", "Y");
			} else {
				$("#id-delete-check").data("deleteflag", "N");
			}
			
			var check_price1 = $("#form-field-price1").val().replace(/[^0-9]/g,"");
			var check_price2 = $("#form-field-price2").val().replace(/[^0-9]/g,"");
			var price1 = Number($("#form-field-price1").val().replace(/[^0-9]/g,""));
			var price2 = Number($("#form-field-price2").val().replace(/[^0-9]/g,""));
			var date1 = $("#id-date-picker-1").val();
			var date2 = $("#id-date-picker-2").val();
			
			if((check_price1 != null && check_price1.length !== 0) || (check_price2 != null && check_price2.length !== 0)) {
				if((check_price1 != null && check_price1.length !== 0) && (check_price2 != null && check_price2.length !== 0)) {
					if(price1 > price2) {
						dialog("단가 범위를 다시 설정해주세요.", false);
						return;
					}
				} else {
					dialog("단가 범위를 다시 설정해주세요.", false);
					return;
				}
			}
			
			if((date1 != null && date1.length !== 0) || (date2 != null && date2.length !== 0)) {
				if((date1 != null && date1.length !== 0) && (date2 != null && date2.length !== 0)) {
					if(date1 > date2) {
						dialog("생산 일자 범위를 다시 설정해주세요.", false);
						return;
					}
				} else {
					dialog("생산 일자 범위를 다시 설정해주세요.", false);
					return;
				}
			}
			
			form_datas($("#form-field-item-id").val(),
					   $("#form-field-section-name").val(),
					   $("#form-field-factory-name").val(),
					   $("#form-field-price1").val(),
					   $("#form-field-price2").val(),
					   $("#form-field-item-name").val(),
					   $("#form-field-section-code").val(),
					   $("#form-field-factory-code").val(),
					   $("#id-date-picker-1").val(),
					   $("#id-date-picker-2").val(),
					   $("#id-delete-check").data("deleteflag"));
			
			var page_num = 1;
			var page_group = parseInt((page_num-1)/5);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/paging",
				type:"get",
				dataType:"json",
				data:{"no" : $("#form").data("formdatasno"),
					  "sectionname" : $("#form").data("formdatassectionname"),
					  "factoryname" : $("#form").data("formdatasfactoryname"),
					  "price_start" : $("#form").data("formdataspricestart"),
					  "price_end" : $("#form").data("formdataspriceend"),
					  "name" : $("#form").data("formdatasname"),
					  "sectioncode" : $("#form").data("formdatassectioncode"),
					  "factorycode" : $("#form").data("formdatasfactorycode"),
					  "producedate_start" : $("#form").data("formdatasproducedatestart"),
					  "producedate_end" : $("#form").data("formdatasproducedateend"),
					  "deleteflag" : $("#form").data("formdatasdeleteflag"),
					  "page" : page_num,
					  "page_group" : page_group},
				success:function(data) {
					console.log(data);
					updateTable(data.pagepurchaseitemList, page_num, data.purchaseitemListall);
					updatePagination(data.purchaseitemListall, data.purchaseitemList, page_num, page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 품목입니다.", false);
				}
			});
		});
		
		$("body").on("click",".page_go",function(e) {
			var page_num = $(this).text();
			var page_group = parseInt((page_num-1)/5);
			var deleteflag = $("#id-delete-check").data("deleteflag");
			var form_data = $("#form").data("formdata");
			console.log("page_num : " + page_num);
			console.log("page_group : " + page_group);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/paging",
				type:"get",
				dataType:"json",
				data:{"no" : $("#form").data("formdatasno"),
					  "sectionname" : $("#form").data("formdatassectionname"),
					  "factoryname" : $("#form").data("formdatasfactoryname"),
					  "price_start" : $("#form").data("formdataspricestart"),
					  "price_end" : $("#form").data("formdataspriceend"),
					  "name" : $("#form").data("formdatasname"),
					  "sectioncode" : $("#form").data("formdatassectioncode"),
					  "factorycode" : $("#form").data("formdatasfactorycode"),
					  "producedate_start" : $("#form").data("formdatasproducedatestart"),
					  "producedate_end" : $("#form").data("formdatasproducedateend"),
					  "deleteflag" : $("#form").data("formdatasdeleteflag"),
					  "page" : page_num,
					  "page_group" : page_group},
				success:function(data) {
					console.log(data);
					updateTable(data.pagepurchaseitemList, page_num, data.purchaseitemListall);
					updatePagination(data.purchaseitemListall, data.purchaseitemList, page_num, page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 품목입니다.", false);
				}
			});
		});
		
		$("body").on("click",".page_go_prev",function(e) {
			var page_num = $("#select_num").text();
			var page_group = parseInt((page_num-1)/5);
			
			page_group = page_group - 1;
			page_num = (page_group*5) + 5;
			
			var deleteflag = $("#id-delete-check").data("deleteflag");
			var form_data = $("#form").data("formdata");
			
			console.log("page_num : " + page_num);
			console.log("page_group : " + page_group);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/paging",
				type:"get",
				dataType:"json",
				data:{"no" : $("#form").data("formdatasno"),
					  "sectionname" : $("#form").data("formdatassectionname"),
					  "factoryname" : $("#form").data("formdatasfactoryname"),
					  "price_start" : $("#form").data("formdataspricestart"),
					  "price_end" : $("#form").data("formdataspriceend"),
					  "name" : $("#form").data("formdatasname"),
					  "sectioncode" : $("#form").data("formdatassectioncode"),
					  "factorycode" : $("#form").data("formdatasfactorycode"),
					  "producedate_start" : $("#form").data("formdatasproducedatestart"),
					  "producedate_end" : $("#form").data("formdatasproducedateend"),
					  "deleteflag" : $("#form").data("formdatasdeleteflag"),
					  "page" : page_num,
					  "page_group" : page_group},
				success:function(data) {
					updateTable(data.pagepurchaseitemList, page_num, data.purchaseitemListall);
					updatePagination(data.purchaseitemListall, data.purchaseitemList, page_num, page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 품목입니다.", false);
				}
			});
		});
		
		$("body").on("click",".page_go_next",function(e) {
			var page_num = $("#select_num").text();
			var page_group = parseInt((page_num-1)/5);
			
			page_group = page_group + 1;
			page_num = (page_group*5) + 1;
			
			var deleteflag = $("#id-delete-check").data("deleteflag");
			var form_data = $("#form").data("formdata");
			
			console.log("page_num : " + page_num);
			console.log("page_group : " + page_group);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/paging",
				type:"get",
				dataType:"json",
				data:{"no" : $("#form").data("formdatasno"),
					  "sectionname" : $("#form").data("formdatassectionname"),
					  "factoryname" : $("#form").data("formdatasfactoryname"),
					  "price_start" : $("#form").data("formdataspricestart"),
					  "price_end" : $("#form").data("formdataspriceend"),
					  "name" : $("#form").data("formdatasname"),
					  "sectioncode" : $("#form").data("formdatassectioncode"),
					  "factorycode" : $("#form").data("formdatasfactorycode"),
					  "producedate_start" : $("#form").data("formdatasproducedatestart"),
					  "producedate_end" : $("#form").data("formdatasproducedateend"),
					  "deleteflag" : $("#form").data("formdatasdeleteflag"),
					  "page" : page_num,
					  "page_group" : page_group},
				success:function(data) {
					updateTable(data.pagepurchaseitemList, page_num, data.purchaseitemListall);
					updatePagination(data.purchaseitemListall, data.purchaseitemList, page_num, page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 품목입니다.", false);
				}
			});
		});
		
		function numberFormat(number) {
			return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		
		function updateTable(purchaseitemList, page_num, purchaseitemListall) {
			$("#select-purchaseitem-list").remove();
			
			$("#purchaseitem_allcount").text("총 " + purchaseitemListall.length + "건");
			
			$newTbody = $("<tbody id='select-purchaseitem-list'></tbody>");
			
			$("#sample-table-1").append($newTbody);
			var i = 1;
			
			for(var pur in purchaseitemList) {
				$newTbody.append(
					"<tr>" +
					"<td>" + isEmpty((i + (page_num-1)*11)) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].no) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].name) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].sectioncode) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].sectionname) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].standard) + "</td>" +
					"<td style='text-align:right'>" + isEmpty(numberFormat(purchaseitemList[pur].price)) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].purpose) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].factorycode) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].factoryname) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].factorypostaddress) + " " + isEmpty(purchaseitemList[pur].factoryroadaddress) + " " + isEmpty(purchaseitemList[pur].factorydetailaddress) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].managername) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].producedate) + "</td>" +
					"<td>" + isEmpty(purchaseitemList[pur].deleteflag) + "</td>" +
					"</tr>"
				);
				i++;
			}
		}
			
		function updatePagination(purchaseitemListall, purchaseitemList, page_num, page_group) {
			$("#pagination_list").remove();
			$newUl = $("<ul id='pagination_list'></ul>");
			$("#purchase_pagination").append($newUl);
			var page_all_count = parseInt((purchaseitemListall.length-1)/11 + 1);
			var list_size = parseInt((purchaseitemList.length-1)/11 + 1);
			var page_group_max = parseInt((page_all_count-1) / 5);
			
			console.log(page_group_max);
			
			if(0 < page_group) {
				$newUl.append("<li><a class='page_go_prev' href='javascript:void(0);'><i class='icon-double-angle-left'></i></a></li>");
			} else {
				$newUl.append("<li class='disabled'><a href='javascript:void(0);'><i class='icon-double-angle-left'></i></a></li>");
			}
			
			for(var li = 1; li <= list_size; li++) {
				if(page_num == (li + page_group*5)) {
					$newUl.append(
						"<li class='active'><a id='select_num' href='javascript:void(0);'>" + (li + page_group*5) + "</a></li>"
					);
				} else {
					$newUl.append(
						"<li><a class='page_go' href='javascript:void(0);'>" + (li + page_group*5) + "</a></li>"
					);
				}
			}
			
			if(page_group_max > page_group) {
				$newUl.append("<li><a class='page_go_next' href='javascript:void(0);'><i class='icon-double-angle-right'></i></a></li>");
			} else {
				$newUl.append("<li class='disabled'><a href='javascript:void(0);'><i class='icon-double-angle-right'></i></a></li>");
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		

		$("#btn-search-section").click(function() {
			var search_section = $("#search-section-name").val();
			$("#search-section-name").data("searchsectionname", search_section);
			
			var search_sectiondata = $("#search-section-name").data("searchsectionname");
			var section_page_num = 1;
			var section_page_group = parseInt((section_page_num-1)/5);
			
			console.log("search_sectiondata : " + search_sectiondata);
			console.log("section_page_num : " + section_page_num);
			console.log("section_page_group : " + section_page_group);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/sectionpaging",
				type:"get",
				dataType:"json",
				data:{"section_page" : section_page_num, "section_page_group" : section_page_group, "search_sectiondata" : search_sectiondata},
				success:function(data) {
					section_updateTable(data.pagesectionList, section_page_num);
					section_updatePagination(data.sectionListall, data.sectionList, section_page_num, section_page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 대분류명입니다.", false);
				}
			});
		});
		
		$("body").on("click",".section_page_go",function(e) {
			var section_page_num = $(this).text();
			var section_page_group = parseInt((section_page_num-1)/5);
			var search_sectiondata = $("#search-section-name").data("searchsectionname");
			
			console.log("search_sectiondata : " + search_sectiondata);
			console.log("section_page_num : " + section_page_num);
			console.log("section_page_group : " + section_page_group);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/sectionpaging",
				type:"get",
				dataType:"json",
				data:{"section_page" : section_page_num, "section_page_group" : section_page_group, "search_sectiondata" : search_sectiondata},
				success:function(data) {
					section_updateTable(data.pagesectionList, section_page_num);
					section_updatePagination(data.sectionListall, data.sectionList, section_page_num, section_page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 대분류명입니다.", false);
				}
			});
		});
		
		$("body").on("click",".section_page_go_prev",function(e) {
			var section_page_num = $("#section_select_num").text();
			var section_page_group = parseInt((section_page_num-1)/5);
			var search_sectiondata = $("#search-section-name").data("searchsectionname");
			
			section_page_group = section_page_group - 1;
			section_page_num = (section_page_group*5) + 5;
			
			console.log("section_page_num : " + section_page_num);
			console.log("section_page_group : " + section_page_group);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/sectionpaging",
				type:"get",
				dataType:"json",
				data:{"section_page" : section_page_num, "section_page_group" : section_page_group, "search_sectiondata" : search_sectiondata},
				success:function(data) {
					section_updateTable(data.pagesectionList, section_page_num);
					section_updatePagination(data.sectionListall, data.sectionList, section_page_num, section_page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 대분류명입니다.", false);
				}
			});
		});
		
		$("body").on("click",".section_page_go_next",function(e) {
			var section_page_num = $("#section_select_num").text();
			var section_page_group = parseInt((section_page_num-1)/5);
			var search_sectiondata = $("#search-section-name").data("searchsectionname");
			
			section_page_group = section_page_group + 1;
			section_page_num = (section_page_group*5) + 1;
			
			console.log("section_page_num : " + section_page_num);
			console.log("section_page_group : " + section_page_group);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/sectionpaging",
				type:"get",
				dataType:"json",
				data:{"section_page" : section_page_num, "section_page_group" : section_page_group, "search_sectiondata" : search_sectiondata},
				success:function(data) {
					section_updateTable(data.pagesectionList, section_page_num);
					section_updatePagination(data.sectionListall, data.sectionList, section_page_num, section_page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 대분류명입니다.", false);
				}
			});
		});
	
		function section_updateTable(pagesectionList, section_page_num) {
			$("#tbody-section-list").remove();
			$newTbody = $("<tbody id='tbody-section-list'></tbody>");
			$("#section-table").append($newTbody);
			
			for(var sec in pagesectionList) {
				$newTbody.append(
					"<tr>" +
					"<td class='center'>" + isEmpty(pagesectionList[sec].classification) + "</td>" +
					"<td class='center'>" + isEmpty(pagesectionList[sec].code) + "</td>" +
					"</tr>"
				);
			}
		}
		
		function section_updatePagination(sectionListall, sectionList, section_page_num, section_page_group) {
			$("#section_pagination_list").remove();
			$newUl = $("<ul id='section_pagination_list'></ul>");
			$("#section_pagination").append($newUl);
			var section_page_all_count = parseInt((sectionListall.length-1)/6 + 1);
			var section_list_size = parseInt((sectionList.length-1)/6 + 1);
			var section_page_group_max = parseInt((section_page_all_count-1) / 5);
			
			console.log(section_page_group_max);
			
			if(0 < section_page_group) {
				$newUl.append("<li><a class='section_page_go_prev' href='javascript:void(0);'><i class='icon-double-angle-left'></i></a></li>");
			} else {
				$newUl.append("<li class='disabled'><a href='javascript:void(0);'><i class='icon-double-angle-left'></i></a></li>");
			}
			
			for(var li = 1; li <= section_list_size; li++) {
				if(section_page_num == (li + section_page_group*5)) {
					$newUl.append(
						"<li class='active'><a id='section_select_num' href='javascript:void(0);'>" + (li + section_page_group*5) + "</a></li>"
					);
				} else {
					$newUl.append(
						"<li><a class='section_page_go' href='javascript:void(0);'>" + (li + section_page_group*5) + "</a></li>"
					);
				}
			}
			
			if(section_page_group_max > section_page_group) {
				$newUl.append("<li><a class='section_page_go_next' href='javascript:void(0);'><i class='icon-double-angle-right'></i></a></li>");
			} else {
				$newUl.append("<li class='disabled'><a href='javascript:void(0);'><i class='icon-double-angle-right'></i></a></li>");
			}
		}
		
		$("body").on("click", "#search-section-dialog-refresh", function(e) {
			$("#form-field-section-name").val("");
			$("#form-field-section-code").val("");
		});
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		$("#btn-search-factory").click(function() {
			var search_factory = $("#search-factory-name").val();
			$("#search-factory-name").data("searchfactoryname", search_factory);
			
			var search_factorydata = $("#search-factory-name").data("searchfactoryname");
			var factory_page_num = 1;
			var factory_page_group = parseInt((factory_page_num-1)/5);
			
			console.log("search_factorydata : " + search_factorydata);
			console.log("factory_page_num : " + factory_page_num);
			console.log("factory_page_group : " + factory_page_group);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/factorypaging",
				type:"get",
				dataType:"json",
				data:{"factory_page" : factory_page_num, "factory_page_group" : factory_page_group, "search_factorydata" : search_factorydata},
				success:function(data) {
					factory_updateTable(data.pagefactoryList, factory_page_num);
					factory_updatePagination(data.factoryListall, data.factoryList, factory_page_num, factory_page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 공장명입니다.", false);
				}
			});
		});
		
		$("body").on("click",".factory_page_go",function(e) {
			var search_factorydata = $("#search-factory-name").data("searchfactoryname");
			var factory_page_num = $(this).text();
			var factory_page_group = parseInt((factory_page_num-1)/5);
			
			console.log("factory_page_num : " + factory_page_num);
			console.log("factory_page_group : " + factory_page_group);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/factorypaging",
				type:"get",
				dataType:"json",
				data:{"factory_page" : factory_page_num, "factory_page_group" : factory_page_group, "search_factorydata" : search_factorydata},
				success:function(data) {
					factory_updateTable(data.pagefactoryList, factory_page_num);
					factory_updatePagination(data.factoryListall, data.factoryList, factory_page_num, factory_page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 공장명입니다.", false);
				}
			});
		});
		
		$("body").on("click",".factory_page_go_prev",function(e) {
			var search_factorydata = $("#search-factory-name").data("searchfactoryname");
			var factory_page_num = $("#factory_select_num").text();
			var factory_page_group = parseInt((factory_page_num-1)/5);
			
			factory_page_group = factory_page_group - 1;
			factory_page_num = (factory_page_group*5) + 5;
			
			console.log("factory_page_num : " + factory_page_num);
			console.log("factory_page_group : " + factory_page_group);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/factorypaging",
				type:"get",
				dataType:"json",
				data:{"factory_page" : factory_page_num, "factory_page_group" : factory_page_group, "search_factorydata" : search_factorydata},
				success:function(data) {
					factory_updateTable(data.pagefactoryList, factory_page_num);
					factory_updatePagination(data.factoryListall, data.factoryList, factory_page_num, factory_page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 공장명입니다.", false);
				}
			});
		});
		
		$("body").on("click",".factory_page_go_next",function(e) {
			var search_factorydata = $("#search-factory-name").data("searchfactoryname");
			var factory_page_num = $("#factory_select_num").text();
			var factory_page_group = parseInt((factory_page_num-1)/5);
			
			factory_page_group = factory_page_group + 1;
			factory_page_num = (factory_page_group*5) + 1;
			
			console.log("factory_page_num : " + factory_page_num);
			console.log("factory_page_group : " + factory_page_group);
			
			$.ajax({
				url:"${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/factorypaging",
				type:"get",
				dataType:"json",
				data:{"factory_page" : factory_page_num, "factory_page_group" : factory_page_group, "search_factorydata" : search_factorydata},
				success:function(data) {
					factory_updateTable(data.pagefactoryList, factory_page_num);
					factory_updatePagination(data.factoryListall, data.factoryList, factory_page_num, factory_page_group);
				}, error:function(error) {
					dialog("찾을 수 없는 공장명입니다.", false);
				}
			});
		});
		
		function factory_updateTable(pagefactoryList, factory_page_num) {
			$("#tbody-factory-list").remove();
			$newTbody = $("<tbody id='tbody-factory-list'></tbody>");
			$("#factory-table").append($newTbody);
			
			for(var fac in pagefactoryList) {
				$newTbody.append(
					"<tr>" +
					"<td class='center'>" + isEmpty(pagefactoryList[fac].classification) + "</td>" +
					"<td class='center'>" + isEmpty(pagefactoryList[fac].code) + "</td>" +
					"</tr>"
				);
			}
		}
		
		function factory_updatePagination(factoryListall, factoryList, factory_page_num, factory_page_group) {
			$("#factory_pagination_list").remove();
			$newUl = $("<ul id='factory_pagination_list'></ul>");
			$("#factory_pagination").append($newUl);
			var factory_page_all_count = parseInt((factoryListall.length-1)/6 + 1);
			var factory_list_size = parseInt((factoryList.length-1)/6 + 1);
			var factory_page_group_max = parseInt((factory_page_all_count-1) / 5);
			
			console.log(factory_page_group_max);
			
			if(0 < factory_page_group) {
				$newUl.append("<li><a class='factory_page_go_prev' href='javascript:void(0);'><i class='icon-double-angle-left'></i></a></li>");
			} else {
				$newUl.append("<li class='disabled'><a href='javascript:void(0);'><i class='icon-double-angle-left'></i></a></li>");
			}
			
			for(var li = 1; li <= factory_list_size; li++) {
				if(factory_page_num == (li + factory_page_group*5)) {
					$newUl.append(
						"<li class='active'><a id='factory_select_num' href='javascript:void(0);'>" + (li + factory_page_group*5) + "</a></li>"
					);
				} else {
					$newUl.append(
						"<li><a class='factory_page_go' href='javascript:void(0);'>" + (li + factory_page_group*5) + "</a></li>"
					);
				}
			}
			
			if(factory_page_group_max > factory_page_group) {
				$newUl.append("<li><a class='factory_page_go_next' href='javascript:void(0);'><i class='icon-double-angle-right'></i></a></li>");
			} else {
				$newUl.append("<li class='disabled'><a href='javascript:void(0);'><i class='icon-double-angle-right'></i></a></li>");
			}
		}
		
		$("body").on("click", "#search-factory-dialog-refresh", function(e) {
			$("#form-field-factory-name").val("");
			$("#form-field-factory-code").val("");
		});
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		function addCommas(price) {
			return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		
		$("#form-field-price1").on('keyup', function(event){
			$(this).val(addCommas($(this).val().replace(/[^0-9]/g,"")));
		});
		
		$("#form-field-price2").on('keyup', function(event){
			$(this).val(addCommas($(this).val().replace(/[^0-9]/g,"")));
		});
		
		function dialog(txt, flag) {
	        $("#dialog-txt").html(txt);
	    	var dialog = $( "#dialog-confirm" ).dialog({
				resizable: false,
				modal: true,
				buttons: [
					{
						text: "OK",
						"class" : "btn btn-danger btn-mini",
						click: function() {
							if(flag){
								$(this).dialog("close");
								location.reload();
							} else {
								$(this).dialog("close");
							}
						}
					}
				]
			});
	    }
	});
</script>

</head>
<body class="skin-3">
<c:import url="/WEB-INF/views/common/navbar.jsp" />
<div class="main-container container-fluid">
	<c:import url="/WEB-INF/views/common/sidebar.jsp" />
	<div class="main-content">
		<div class="page-content">
		
			<div class="page-header position-relative">
				<h1 class="pull-left">매입품목 현황조회</h1>
			</div><!-- /.page-header -->
			
			<div class="row-fluid">
				<!-- PAGE CONTENT BEGINS -->
				<div class="span12">
				<div class="row-fluid" style="height:300px">
					<form id="form" class="form-horizontal" style="margin:0 0 0 0; height:200px"
					data-formdatasno=""
					data-formdatassectionname=""
					data-formdatasfactoryname=""
					data-formdataspricestart=""
					data-formdataspriceend=""
					data-formdatasname=""
					data-formdatasectioncode=""
					data-formdatasfactorycode=""
					data-formdatasproducedatestart=""
					data-formdatasproducedateend=""
					data-formdatasdeleteflag=""
					 method="post" action="${pageContext.request.contextPath }/${menuInfo.mainMenuCode }/${menuInfo.subMenuCode }/list">
						<div style="height:200px">
							<div class="span6">
								<div class="control-group">
									<label class="control-label" for="form-field-item-id" style="text-align:initial; width:100px;">품목코드</label>
									<div class="controls" style="margin-left:150px;">
										<input class="span4" type="text" id="form-field-item-id" name="no" placeholder="품목코드" maxlength="10"/>
									</div>
								</div>
								
								
								<div id="dialog-confirm" class="hide">
									<p id="dialog-txt" class="bolder grey"></p>
								</div>
								
								
								
								<div class="control-group">
									<label class="control-label" for="form-field-section-name" style="text-align:initial; width:100px;">품목 대분류명</label>
									<div class="controls" style="margin-left:150px">
										<div class="row-fluid input-append">
											<input class="span5" id="form-field-section-name" name="sectionname" type="text" placeholder="품목 대분류명" readonly/>
											<span class="add-on">
												<a href="javascript:void(0);" id="search-section-dialog" style="text-decoration:none"><i class="icon-search icon-on-right bigger-110"></i></a>
											</span>
											<span class="add-on">
												<a href="javascript:void(0);" id="search-section-dialog-refresh" style="text-decoration:none"><i class="icon-refresh"></i></a>
											</span>
										</div>
									</div>
								</div>
								
								<div id="dialog-section-main" title="품목 대분류명 조회" hidden="hidden">
									<table id ="dialog-message-section-table">
										<tr>
											<td>
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;품목 대분류명&nbsp;&nbsp;
												<div class="row-fluid input-append" style="width:200px">
													<input class="span9" type="text" id="search-section-name" data-searchsectionname="" placeholder="품목 대분류명"/>
													<span class="add-on">
														<a href="javascript:void(0);" id="btn-search-section" style="text-decoration:none"><i class="icon-search icon-on-right bigger-110"></i></a>
													</span>
												</div>
											</td>
										</tr>
									</table>
									
									<table id="section-table" class="table table-bordered table-hover">
										<thead>
											<tr>
												<th class="center">대분류명</th>
												<th class="center">대분류코드</th>
											</tr>
										</thead>
										<tbody id="tbody-section-list">
										<c:forEach items="${pagesectionList}" var="sl" varStatus="status">
											<tr>
												<td class="center">${sl.classification}</td>
												<td class="center">${sl.code}</td>
											</tr>
										</c:forEach>
										</tbody>
									</table>
									
									<div class="pagination" id="section_pagination">
										<ul id="section_pagination_list">
											<fmt:parseNumber var="section_page_all_count" integerOnly="true" value="${((fn:length(sectionListall)-1)/6) + 1}" />
											<fmt:parseNumber var="section_page_count" integerOnly="true" value="${((fn:length(sectionList)-1)/6) + 1}" />
											<fmt:parseNumber var="section_page_group_max" integerOnly="true" value="${(section_page_all_count-1) / 5 }" />
											
											<c:choose>
												<c:when test="${0 < section_page_group }">
													<li><a class="section_page_go_prev" href="javascript:void(0);"><i class="icon-double-angle-left"></i></a></li>
												</c:when>
												<c:otherwise>
													<li class="disabled"><a href="javascript:void(0);"><i class="icon-double-angle-left"></i></a></li>
												</c:otherwise>
											</c:choose>
											
											<c:forEach var="sec_size" begin="1" end="${section_page_count }" step="1">
												<c:choose>
													<c:when test="${section_cur_page == sec_size }">
														<li class="active"><a id="section_select_num" href="javascript:void(0);">${sec_size }</a></li>
													</c:when>
													<c:otherwise>
														<li><a class="section_page_go" href="javascript:void(0);">${sec_size }</a></li>
													</c:otherwise>
												</c:choose>
											</c:forEach>
											
											<c:choose>
												<c:when test="${section_page_group_max > section_page_group }">
													<li><a class="section_page_go_next" href="javascript:void(0);"><i class="icon-double-angle-right"></i></a></li>
												</c:when>
												<c:otherwise>
													<li class="disabled"><a href="javascript:void(0);"><i class="icon-double-angle-right"></i></a></li>
												</c:otherwise>
											</c:choose>
										</ul>
									</div>
								</div>
								
								
								
								<div class="control-group">
									<label class="control-label" for="form-field-factory-name" style="text-align:initial; width:100px;">생산공장명</label>
									<div class="controls" style="margin-left:150px">
										<div class="row-fluid input-append">
											<input class="span5" type="text" id="form-field-factory-name" name="factoryname" placeholder="생산공장명" readonly/>
											<span class="add-on">
												<a href="javascript:void(0);" id="search-factory-dialog" style="text-decoration:none"><i class="icon-search icon-on-right bigger-110"></i></a>
											</span>
											<span class="add-on">
												<a href="javascript:void(0);" id="search-factory-dialog-refresh" style="text-decoration:none"><i class="icon-refresh"></i></a>
											</span>
										</div>
									</div>
								</div>
								
								<div id="dialog-factory-main" title="생산공장명 조회" hidden="hidden">
									<table id ="dialog-message-factory-table">
										<tr>
											<td>
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;생산공장명&nbsp;&nbsp;
												<div class="row-fluid input-append" style="width:200px">
													<input class="span9" type="text" id="search-factory-name" data-searchfactoryname="" placeholder="생산공장명"/>
													<span class="add-on">
														<a href="javascript:void(0);" id="btn-search-factory" style="text-decoration:none"><i class="icon-search icon-on-right bigger-110"></i></a>
													</span>
												</div>
											</td>
										</tr>
									</table>
									
									<table id="factory-table" class="table table-bordered table-hover">
										<thead>
											<tr>
												<th class="center">공장명</th>
												<th class="center">공장코드</th>
											</tr>
										</thead>
										<tbody id="tbody-factory-list">
										<c:forEach items="${pagefactoryList}" var="fl" varStatus="status">
											<tr>
												<td class="center">${fl.classification}</td>
												<td class="center">${fl.code}</td>
											</tr>
										</c:forEach>
										</tbody>
									</table>
									
									<div class="pagination" id="factory_pagination">
										<ul id="factory_pagination_list">
											<fmt:parseNumber var="factory_page_all_count" integerOnly="true" value="${((fn:length(factoryListall)-1)/6) + 1}" />
											<fmt:parseNumber var="factory_page_count" integerOnly="true" value="${((fn:length(factoryList)-1)/6) + 1}" />
											<fmt:parseNumber var="factory_page_group_max" integerOnly="true" value="${(factory_page_all_count-1) / 5 }" />
											
											<c:choose>
												<c:when test="${0 < factory_page_group }">
													<li><a class="factory_page_go_prev" href="javascript:void(0);"><i class="icon-double-angle-left"></i></a></li>
												</c:when>
												<c:otherwise>
													<li class="disabled"><a href="javascript:void(0);"><i class="icon-double-angle-left"></i></a></li>
												</c:otherwise>
											</c:choose>
											
											<c:forEach var="fac_size" begin="1" end="${factory_page_count }" step="1">
												<c:choose>
													<c:when test="${factory_cur_page == fac_size }">
														<li class="active"><a id="factory_select_num" href="javascript:void(0);">${fac_size }</a></li>
													</c:when>
													<c:otherwise>
														<li><a class="factory_page_go" href="javascript:void(0);">${fac_size }</a></li>
													</c:otherwise>
												</c:choose>
											</c:forEach>
											
											<c:choose>
												<c:when test="${factory_page_group_max > factory_page_group }">
													<li><a class="factory_page_go_next" href="javascript:void(0);"><i class="icon-double-angle-right"></i></a></li>
												</c:when>
												<c:otherwise>
													<li class="disabled"><a href="javascript:void(0);"><i class="icon-double-angle-right"></i></a></li>
												</c:otherwise>
											</c:choose>
										</ul>
									</div>
								</div>
								
								
								
								
								
								
								
								<div class="control-group">
									<label class="control-label" for="form-field-price" style="text-align:initial; width:100px;">단가</label>
									<div class="controls" style="margin-left:150px">
										<input type="text" id="form-field-price1" style="text-align:right; width:160px; margin:0 5px 0 0" name="price_start"/>
										~
										<input type="text" id="form-field-price2" style="text-align:right; width:160px; margin:0 0 0 5px" name="price_end"/> 원
									</div>
								</div>
							</div>
							
							
							
							
							
							
							
								<div class="span6">
									<div class="control-group">
										<label class="control-label" for="form-field-item-name" style="text-align:initial; width:100px;">품목명</label>
										<div class="controls">
											<input class="span5" type="text" id="form-field-item-name" name="name" placeholder="품목명"/>&nbsp;&nbsp;&nbsp;
											<input class="ace" type="checkbox" id="id-delete-check" data-deleteflag="N" style="display:inline">
											<label class="lbl" for="id-delete-check" style="display:inline; margin:0 0 0 10px;"> 삭제 품목 포함</label>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label" for="form-field-section-code" style="text-align:initial; width:110px;">품목 대분류코드</label>
										<div class="controls">
											<input class="span4" type="text" id="form-field-section-code" name="sectioncode" readonly/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label" for="form-field-factory-code" style="text-align:initial; width:110px;">생산공장코드</label>
										<div class="controls">
											<input class="span4" type="text" id="form-field-factory-code" name="factorycode" readonly/>
										</div>
									</div>
									
									<div class="control-group" style="margin:0 0 0 0">
										<label class="control-label" for="form-field-date" style="text-align:initial; width:100px;">생산일자</label>
									<div class="controls">
										<div class="control-group">
											<div class="input-append" style="margin:0 5px 0 0">
												<input class="span7 cl-date-picker" id="id-date-picker-1" name="producedate_start" type="text" data-date-format="yyyy-mm-dd" style="width:160px">
												<span class="add-on">
													<i class="icon-calendar"></i>
												</span>
											</div>
											~
											<div class="input-append" style="margin:0 0 0 5px">
												<input class="span7 cl-date-picker" id="id-date-picker-2" name="producedate_end" type="text" data-date-format="yyyy-mm-dd" style="width:160px">
												<span class="add-on">
													<i class="icon-calendar"></i>
												</span>
											</div>
										</div>
									</div> 
								</div>
								
							</div>
						</div>
						<div class="hr hr-18 dotted"></div>
							<button class="btn btn-info btn-small" id="purchaseitem_search" style="display:inline">조회</button>
							<button class="btn btn-default btn-small" type="reset" id="reset">초기화</button>
						<div class="hr hr-18 dotted"></div>
					</form>
				</div>
				
					
					<div class="row-fluid">
						<div class="span12" id="purchaseitem_list" style="margin:0 0 10px 0; overflow-x: scroll;">
							<label id="purchaseitem_allcount">총 ${fn:length(purchaseitemListall) }건</label>
							<table id="sample-table-1" class="table table-striped table-bordered table-hover" style="width:1920px;">
								<thead>
									<tr>
										<th style="text-align:center">번호</th>
										<th style="text-align:center">품목코드</th>
										<th style="text-align:center">품목명</th>
										<th style="text-align:center">대분류코드</th>
										<th style="text-align:center">대분류명</th>
										<th style="text-align:center">규격</th>
										<th style="text-align:center">단가(원)</th>
										<th style="text-align:center">사용용도</th>
										<th style="text-align:center">생산공장코드</th>
										<th style="text-align:center">생산공장명</th>
										<th style="text-align:center">생산공장 주소</th>
										<th style="text-align:center">생산담당자</th>
										<th style="text-align:center">생산일자</th>
										<th style="text-align:center">삭제여부</th>
									</tr>
								</thead>

								<tbody id="select-purchaseitem-list">
									<fmt:parseNumber var="pc" integerOnly="true" value="${(fn:length(purchaseitemList)-1) / 11 }" />
									<c:forEach items="${pagepurchaseitemList }" var="pl" varStatus="status">
										<tr>
											<td>${status.count}</td>
											<td>${pl.no }</td>
											<td>${pl.name }</td>
											<td>${pl.sectioncode }</td>
											<td>${pl.sectionname }</td>
											<td>${pl.standard }</td>
											<td style="text-align:right"><fmt:formatNumber value="${pl.price }" pattern="#,###"/></td>
											<td>${pl.purpose }</td>
											<td>${pl.factorycode }</td>
											<td>${pl.factoryname }</td>
											<td>${pl.factorypostaddress } ${pl.factoryroadaddress } ${pl.factorydetailaddress }</td>
											<td>${pl.managername }</td>
											<td>${pl.producedate }</td>
											<td>${pl.deleteflag }</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div><!-- /span -->
						
						<div class="pagination" id="purchase_pagination">
							<ul id="pagination_list">
								<fmt:parseNumber var="page_all_count" integerOnly="true" value="${((fn:length(purchaseitemListall)-1)/11) + 1}" />
								<fmt:parseNumber var="page_count" integerOnly="true" value="${((fn:length(purchaseitemList)-1)/11) + 1}" />
								<fmt:parseNumber var="page_group_max" integerOnly="true" value="${(page_all_count-1) / 5 }" />
								
								<c:choose>
									<c:when test="${0 < page_group }">
										<li><a class="page_go_prev" href="javascript:void(0);"><i class="icon-double-angle-left"></i></a></li>
									</c:when>
									<c:otherwise>
										<li class="disabled"><a href="javascript:void(0);"><i class="icon-double-angle-left"></i></a></li>
									</c:otherwise>
								</c:choose>
								
								<c:forEach var="pur_size" begin="1" end="${page_count }" step="1">
									<c:choose>
										<c:when test="${cur_page == pur_size }">
											<li class="active"><a id="select_num" href="javascript:void(0);">${pur_size }</a></li>
										</c:when>
										<c:otherwise>
											<li><a class="page_go" href="javascript:void(0);">${pur_size }</a></li>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								
								<c:choose>
									<c:when test="${page_group_max > page_group }">
										<li><a class="page_go_next" href="javascript:void(0);"><i class="icon-double-angle-right"></i></a></li>
									</c:when>
									<c:otherwise>
										<li class="disabled"><a href="javascript:void(0);"><i class="icon-double-angle-right"></i></a></li>
									</c:otherwise>
								</c:choose>
							</ul>
						</div>
					</div>
				<!-- PAGE CONTENT ENDS -->
				</div>
			</div><!-- /.row-fluid -->
		</div><!-- /.page-content -->
	</div><!-- /.main-content -->
</div><!-- /.main-container -->
<!-- basic scripts -->
<c:import url="/WEB-INF/views/common/footer.jsp" />
<script src="${pageContext.request.contextPath }/assets/ace/js/chosen.jquery.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="${pageContext.request.contextPath }/assets/ace/js/date-time/bootstrap-datepicker.min.js"></script>
<script>
	$(function() {
		$.fn.datepicker.dates['ko'] = {
			days: ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"],
			daysShort: ["일", "월", "화", "수", "목", "금", "토"],
			daysMin: ["일", "월", "화", "수", "목", "금", "토"],
			months: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
			monthsShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
			today: "Today",
			clear: "Clear",
			format: "yyyy-mm-dd",
			titleFormat: "yyyy MM",
			weekStart: 0
		};

		$('#cl-ym-date-picker').datepicker({
			maxViewMode: 4,
			minViewMode: 1,
			language: 'ko'
		}).next().on(ace.click_event, function(){
			$(this).prev().focus();
		});

		$('.cl-date-picker').datepicker({
			language: 'ko'
		}).next().on(ace.click_event, function(){
			$(this).prev().focus();
		});
	})
	
	$("body").on("click","#section-table tr",function(e) {
		var tr = $(this);
		var td = tr.children();
		$("input[name=sectionname]").val(td.eq(0).text());
		$("input[name=sectioncode]").val(td.eq(1).text());
	});
	
	$("body").on("click","#factory-table tr",function(e) {
		var tr = $(this);
		var td = tr.children();
		$("input[name=factoryname]").val(td.eq(0).text());
		$("input[name=factorycode]").val(td.eq(1).text());
	});
	
	function execDaumPostcode() {
		new daum.Postcode({
			oncomplete : function(data) {
				var fullRoadAddr = data.roadAddress;
				var extraRoadAddr = '';
				
				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
					extraRoadAddr += data.bname;
				}
				
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				
				if (extraRoadAddr !== '') {
					extraRoadAddr = ' (' + extraRoadAddr + ')';
				}
				
				if (fullRoadAddr !== '') {
					fullRoadAddr += extraRoadAddr;
				}
				
				document.getElementById('form-field-factory-postaddress').value = data.zonecode;
				document.getElementById('form-field-factory-roadaddress').value = fullRoadAddr;
				
				if (data.autoRoadAddress) {
					var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
					document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
				} else if (data.autoJibunAddress) {
					var expJibunAddr = data.autoJibunAddress;
					document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
				} else {
					document.getElementById('guide').innerHTML = '';
				}
			}
		}).open();
	};
	
	function reset() {
		$("#form")[0].reset();
	};
	
	$(function() {
		$(".chosen-select").chosen();
		
		$('.date-picker').datepicker().next().on(ace.click_event, function(){
			$(this).prev().focus();
		});
	});
</script>
</body>
</html>