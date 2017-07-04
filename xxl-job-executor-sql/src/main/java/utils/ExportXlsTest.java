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
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.xxl.job.admin.core.model.XxlJobSubSQL;







public class ExportXlsTest {
	public void exportXls(Connection con,OutputStream out,List<XxlJobSubSQL>list) {
		//Connection con = null;// 创建一个数据库连接
	    PreparedStatement pre = null;// 创建预编译语句对象，一般都是用这个而不用Statement
	    ResultSet rs = null;// 创建一个结果集对象
	    
	        try {
	        	HSSFWorkbook workbook = new HSSFWorkbook();// 创建一个Excel文件，当前这个文件在内存中
	        	for(XxlJobSubSQL xxlJobSubSQL:list){
				pre = con.prepareStatement(xxlJobSubSQL.getSql());// 实例化预编译语句
				rs = pre.executeQuery();// 执行查询
				ResultSetMetaData md = rs.getMetaData();
				HSSFSheet sheet = workbook.createSheet(xxlJobSubSQL.getSubtask_name());// 创建一个sheet页
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
	        	}
		          // OutputStream out=new FileOutputStream(new File("test.xls"));
		           workbook.write(out);
		           out.close();
		             
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
	
	}

