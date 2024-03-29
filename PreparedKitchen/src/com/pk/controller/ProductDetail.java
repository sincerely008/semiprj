package com.pk.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.pk.biz.MaterialBiz;
import com.pk.biz.ProductDetailBiz;
import com.pk.biz.ProductListBiz;
import com.pk.biz.RecipeBiz;
import com.pk.dto.MartDto;
import com.pk.dto.MaterialDto;
import com.pk.dto.RecipeDto;

@WebServlet("/prodetail.do")
public class ProductDetail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ProductDetail() {
    	
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String command = request.getParameter("command");
		System.out.println("[" + command + "]");
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		RecipeBiz recipeBiz = new RecipeBiz();
		MaterialBiz materialBiz = new MaterialBiz();
		ProductDetailBiz detailBiz = new ProductDetailBiz();
		ProductListBiz pBiz = new ProductListBiz();
		
		if(command.equals("detail")) {
			
			List<Integer> reList = new ArrayList<Integer>();
			int recipeno = Integer.parseInt(request.getParameter("recipeno"));
			
			if(session.getAttribute("reList") != null) {
				reList = (List<Integer>)session.getAttribute("reList");
			}
			
			reList.add(recipeno);
			pBiz.hit(recipeno);
			
			RecipeDto rDto = recipeBiz.selectOne(recipeno);
			List<MaterialDto> mList = materialBiz.materialInRecipe(recipeno);
			
			List<RecipeDto> recipeList = detailBiz.selectRecentlyRecipe(reList);
			
			request.setAttribute("recipe", rDto);
			request.setAttribute("material", mList);
			session.setAttribute("reList", reList);
			session.setAttribute("recipeList", recipeList);
			dispatch(request, response, "product/productdetail.jsp");
			
		} else if(command.equals("showproduct")) {
			
			String mProduct = request.getParameter("mPro");
			String[] material = mProduct.split("/");
			
			String product = "";
			
			List<MartDto> list = detailBiz.selectProduct(material);
			
			for(int i = 0; i < list.size(); i++) {
				
				String proName = list.get(i).getItem_name();
				int proPrice = list.get(i).getMart_price();
				
				if(i == 0) {
					
					product += "<div class='proCategory'><p>" + list.get(i).getCategory() + "</p><div>";
					product += "<input class='selected' type='text' readonly='readonly' title='" + proName + "' value='" + proName + " " + proPrice + "원'/>";
					
				} else if(i != (list.size()-1)) {
					
					if(!list.get(i).getCategory().equals(list.get(i-1).getCategory())) {
						product += "</div></div>";
						product += "<div class='proCategory'><p>" + list.get(i).getCategory() + "</p><div>";
						product += "<input class='selected' type='text' readonly='readonly' title='" + proName + "' value='" + proName + " " + proPrice + "원'/>";
						
					} else {
						product += "<input class='noSelected' type='text' readonly='readonly' title='" + proName + "' value='" + proName + " " + proPrice + "원'/>";
					}
					
				} else if(i == (list.size()-1)) {
					
					product += "<input class='noSelected' type='text' readonly='readonly' title='" + proName + "' value='" + proName + " " + proPrice + "원'/>";
					product += "</div></div>";
				}
			}
			
			out.println(product);
			
		}
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

	public void dispatch(HttpServletRequest request, HttpServletResponse response, String url) throws ServletException, IOException {
		
		RequestDispatcher dispatch = request.getRequestDispatcher(url);
		dispatch.forward(request, response);
	}
	
}
