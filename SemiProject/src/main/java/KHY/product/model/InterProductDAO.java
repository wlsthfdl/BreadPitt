package KHY.product.model;

import java.sql.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import parkjuenyub.order.model.OrderDeatailVO;
import parkjuneyub.product.model.*;

public interface InterProductDAO {
	
	// 상품페이지에 상품에 대한 정보를 출력하기 위한 메소드
	ProductVO showItemInfo(String product_num) throws SQLException;

	// 유저아이디로 장바구니 내용물 가져오는 메소드
	List<CartVO> getCartList(String userid) throws SQLException;
	
	// 주문코드를 위한 시퀀스 가져오기
	int getSeq_tbl_order() throws SQLException;
	
	// 트랜잭션을 처리해주는 메소드
	int orderAdd(HashMap<String, Object> paraMap) throws SQLException;

	// 주문한 상품 내역 조회하기
	List<OrderDeatailVO> selectOrderList(String user_id) throws SQLException;

	//페이징 처리를 위한 회원의 주문에 대한 총페이지 알아오기
	int getTotalPageOrder(Map<String, String> paraMap) throws SQLException;

	//페이징 처리를 한 회원의 주문 목록 알아오기
	List<OrderDeatailVO> selectPagingOrderList(Map<String, String> paraMap) throws SQLException;
	
	
	
}
