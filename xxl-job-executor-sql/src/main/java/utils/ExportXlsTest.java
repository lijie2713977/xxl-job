package utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;







public class ExportXlsTest {
	public void exportXls(Connection con,String sql,OutputStream out,String fileName) {
		//Connection con = null;// 创建一个数据库连接
	    PreparedStatement pre = null;// 创建预编译语句对象，一般都是用这个而不用Statement
	    ResultSet rs = null;// 创建一个结果集对象
	    
	        try {
				pre = con.prepareStatement(sql);// 实例化预编译语句
				rs = pre.executeQuery();// 执行查询
				ResultSetMetaData md = rs.getMetaData();
				HSSFWorkbook workbook = new HSSFWorkbook();// 创建一个Excel文件，当前这个文件在内存中
				HSSFSheet sheet = workbook.createSheet(fileName);// 创建一个sheet页
				HSSFRow headRow = sheet.createRow(0);// 创建标题行
				int columnCount = md.getColumnCount();
		           while (rs.next()) { 
		            HSSFRow dataRow = sheet.createRow(sheet.getLastRowNum() + 1);
		            for (int i = 0; i <columnCount; i++) { 
		                    headRow.createCell(i).setCellValue((String)md.getColumnName(i+1));
		                   if(rs.getObject(i+1)==null){
		                	   dataRow.createCell(i).setCellValue("");
		                   }else{
		                    dataRow.createCell(i).setCellValue((String) rs.getObject(i+1).toString());
		                   }
		            }  
		           }  
		          // OutputStream out=new FileOutputStream(new File("test.xls"));
		           workbook.write(out);
		           out.close();
		             
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
	public static void main(String[] args) throws Exception {
        ExportXlsTest ext =new ExportXlsTest();
        Class.forName("oracle.jdbc.driver.OracleDriver");
		String url = "jdbc:oracle:thin:@172.16.136.253:1521:otestdb";
		String user = "query";// 用户名,系统默认的账户名
		String password = "query_on";// 你安装时选设置的密码
		Connection con = DriverManager.getConnection(url, user, password);// 获取连接
       ext.exportXls(con, "sql语句", /*输出流*/new FileOutputStream(new File("test.xls")), "文件名");
		
    }
	}

