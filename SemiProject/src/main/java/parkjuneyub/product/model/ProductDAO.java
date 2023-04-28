package parkjuneyub.product.model;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

//

public class ProductDAO implements InterProductDAO  {
	private DataSource ds;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private void close() {
		try {
			if(rs != null) {
				rs.close();
				rs=null;
			}
			
			if(pstmt != null) {
				pstmt.close();
				pstmt=null;
			}
			
			if(conn != null) {
				conn.close();
				conn=null;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public ProductDAO() {
		try {
			Context initContext = new InitialContext();
			Context envContext  = (Context)initContext.lookup("java:/comp/env");
			ds = (DataSource)envContext.lookup("jdbc/semi_oracle");
			
		}
		catch(NamingException e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public ProductVO showItemInfo(String product_num) throws SQLException {
		
		conn = ds.getConnection();
		ProductVO pvo = new ProductVO();
		
		try {
			String sql = " select * from tbl_product where product_num = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,  product_num);
			
			rs = pstmt.executeQuery();
			rs.next();
			
			pvo.setProduct_num(rs.getLong(1));
			pvo.setCategory_num(rs.getLong(2));
			pvo.setProduct_title(rs.getString(3));
			pvo.setMain_image(rs.getLong(4));
			pvo.setProduct_price(rs.getLong(5));
			pvo.setProduct_detail(rs.getString(6));
			pvo.setProduct_inventory(rs.getLong("product_inventory"));
			pvo.setProduct_date(rs.getString(8));
			pvo.setSale_count(rs.getInt(9));
			
		}
		finally {
			close();
		}
		
		
		return pvo;
	}

	@Override
	public List<CartVO> getCartList(String userid) throws SQLException {
		
		List<CartVO> cartList = new ArrayList<>();
		try {
			conn = ds.getConnection();
			
			String sql = " select cart_num, A.product_num as product_num, product_count, cart_date, product_price "+
					" from "+
					" ( "+
					" select cart_num, product_num, product_count, cart_date "+
					" from tbl_cart "+
					" where user_id = ? "+
					" ) A "+
					" join "+
					" (select product_num, product_price from tbl_product ) B "+
					" on A.product_num = B.product_num ";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				CartVO cvo = new CartVO();
				ProductVO pvo = new ProductVO();
				pvo.setProduct_num(rs.getLong("product_num"));
				pvo.setProduct_price(rs.getLong("product_price"));;
				cvo.setCart_num(rs.getLong("cart_num"));
				cvo.setProduct_count(rs.getLong("product_count"));
				cvo.setCart_date(rs.getString("cart_date"));
				
				
				cartList.add(cvo);
			}
		} finally {
			close();
		}
		return cartList;
		
	} // end of public List<CartVO> getCartList(String userid)

	@Override
	public int getSeq_tbl_order() throws SQLException {
		
		int seq = 0;

		try {
			conn = ds.getConnection();
			String sql = " select seq_tbl_order.nextval as seq from dual ";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			rs.next();
			seq = rs.getInt("seq");
		}
		finally {
			close();
		}
		
		return seq;
	}

	@Override
	public int orderAdd(HashMap<String, Object> paraMap) throws SQLException {
		
		int isSuccess = 0;
		int n1 = 0, n2 = 0, n3= 0, n4 = 0, n5 = 0;
		
		try {
			conn = ds.getConnection();
			conn.setAutoCommit(false);
			
			// 1. 주문 테이블에 데이터 넣기
			String sql = " insert into tbl_order( order_num, user_id, order_price_total, order_mileage_total, order_date ) "
					+ " values( ?, ?, ?, ?, sysdate) ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, (String)paraMap.get("oderNum") );
			pstmt.setString(2, (String)paraMap.get("userid") );
			pstmt.setLong(3, Long.parseLong((String)paraMap.get("finalTotalPrice")) );
			pstmt.setLong(4, Long.parseLong((String)paraMap.get("useMileage")) );
			
			n1 = pstmt.executeUpdate();
			System.out.println("n1 " +  n1);
			// 2. 주문 상세 테이블에 주문 id 와 그 이외에 데이터 넣기
			if(n1 == 1) {
				String[] productNum_arr = (String[]) paraMap.get("productNum_arr"); 
				String[] productCnt_arr = (String[]) paraMap.get("productCnt_arr"); 
				String[] productPrice_arr = (String[]) paraMap.get("productPrice_arr"); 
				
				int cnt = 0;
				
				for(int i = 0; i < productNum_arr.length; i++) {
					sql = " insert into tbl_order_detail(order_details_num, order_num, product_num, order_name, "
							+ "order_quantity, product_selling_price, recipient_name, recipient_mobile, "
							+ "recipient_telephone, forwarded_message, orderer_mobile, "
							+ "delivery_status, payment_time, use_mileage, postcode, address, detailAddress, extraAddress) "
							+ " values(seq_order_detail.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '0', sysdate, ?, ?, ?,?,? )";
					pstmt = conn.prepareStatement(sql);
					
					pstmt.setString(1, (String)paraMap.get("oderNum"));
					pstmt.setLong(2, Long.parseLong(productNum_arr[i]));
					pstmt.setString(3, (String)paraMap.get("order_name"));
					pstmt.setLong(4, Long.parseLong(productCnt_arr[i]));
					pstmt.setLong(5, Long.parseLong(productPrice_arr[i]));
					pstmt.setString(6, (String)paraMap.get("receive_name"));
					pstmt.setString(7, (String)paraMap.get("receive_mobile"));
					pstmt.setString(8, (String)paraMap.get("receive_phone"));
					pstmt.setString(9, (String)paraMap.get("receive_last_say"));
					pstmt.setString(10, (String)paraMap.get("order_mobile"));
					pstmt.setLong(11, Long.parseLong((String)paraMap.get("useMileage")));
					
					pstmt.setString(12, (String)paraMap.get("postcode"));
					pstmt.setString(13, (String)paraMap.get("address"));
					pstmt.setString(14, (String)paraMap.get("detailAddress"));
					pstmt.setString(15, (String)paraMap.get("extraAddress"));
					
					pstmt.executeUpdate();
					cnt++;		
				}
				
				if(cnt == productNum_arr.length) {
					n2 = 1;
				}
			}
			System.out.println("n2 " +  n2);
			// 3. 제품 테이블 재고량 업데이트하기
			if(n2 == 1) {
				String[] productNum_arr = (String[]) paraMap.get("productNum_arr"); 
				String[] productCnt_arr = (String[]) paraMap.get("productCnt_arr"); 
				
				int cnt = 0;
				for(int i = 0; i < productNum_arr.length; i++) {
					sql = " update tbl_product set product_inventory =  product_inventory - ? "
							+ "where product_num = ? ";
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setLong(1, Long.parseLong(productCnt_arr[i]));
					pstmt.setLong(2, Long.parseLong(productNum_arr[i]));
					
					pstmt.executeUpdate();
					cnt++;
				}
				if(cnt == productNum_arr.length) {
					n3 = 1;
				}
			}
			System.out.println("n3 " +  n3);
			// 4. cartno가 null이 아니면 장바구니 테이블에서 해당 행들을 삭제하기
			if(n3 == 1) {
				if(paraMap.get("carno_arr") != null & n3 == 1) {
					
					String cartno_join = String.join("','", (String[])paraMap.get("cartno_arr"));
					
					cartno_join = "'"+cartno_join+"'";
					sql = " delete from tbl_cart where cartno in (" + cartno_join +") ";
					pstmt = conn.prepareStatement(sql);
					n4 = pstmt.executeUpdate();
				}
				if(paraMap.get("carno_arr") == null & n3 == 1) {
					n4 = 1;
				}
			}
			System.out.println("n4 " +  n4);
			if(n4 > 0) {
				sql = " update tbl_member set mileage = mileage - ? + ? "
						+ " where user_id = ? ";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setLong(1, Long.parseLong((String)paraMap.get("useMileage")));
				pstmt.setLong(2, Long.parseLong((String)paraMap.get("save_mileage")));
				pstmt.setString(3, (String)paraMap.get("userid"));
				
				n5 = pstmt.executeUpdate();
			}
			
			if((n1 * n2 * n3 * n4 * n5) > 0) {
				conn.commit();
				conn.setAutoCommit(true);
				
				System.out.println("주문 완료");
				isSuccess = 1;
			}
			
			
			// 5. 회원테이블에 마일리지 업데이트하기
		} 
		catch(SQLException e) {
			e.printStackTrace();
			conn.rollback();
			conn.setAutoCommit(true);
			isSuccess = 0;
		}
		finally {
			close();
		}
				
				
		System.out.println(isSuccess);
		return isSuccess;
	}
	
}
