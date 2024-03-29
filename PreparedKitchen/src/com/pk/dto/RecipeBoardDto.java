package com.pk.dto;

public class RecipeBoardDto {

	private int recipeBoard_no;
	private String id;
	private String recipeBoard_title;
	private String recipeBoard_content;
	private String recipeBoard_regdate;
	private int recipeBoard_readCount = 0;
	private int recipeBoard_like = 0;

	public RecipeBoardDto() {
		super();
	}	

	public RecipeBoardDto(int recipeBoard_no, String id, String recipeBoard_title, String recipeBoard_content,
			String recipeBoard_regdate, int recipeBoard_readCount, int recipeBoard_like) {
		super();
		this.recipeBoard_no = recipeBoard_no;
		this.id = id;
		this.recipeBoard_title = recipeBoard_title;
		this.recipeBoard_content = recipeBoard_content;
		this.recipeBoard_regdate = recipeBoard_regdate;
		this.recipeBoard_readCount = recipeBoard_readCount;
		this.recipeBoard_like = recipeBoard_like;
	}

	public int getRecipeBoard_no() {
		return recipeBoard_no;
	}

	public void setRecipeBoard_no(int recipeBoard_no) {
		this.recipeBoard_no = recipeBoard_no;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getRecipeBoard_title() {
		return recipeBoard_title;
	}

	public void setRecipeBoard_title(String recipeBoard_title) {
		this.recipeBoard_title = recipeBoard_title;
	}

	public String getRecipeBoard_content() {
		return recipeBoard_content;
	}

	public void setRecipeBoard_content(String recipeBoard_content) {
		this.recipeBoard_content = recipeBoard_content;
	}

	public String getRecipeBoard_regdate() {
		return recipeBoard_regdate;
	}

	public void setRecipeBoard_regdate(String recipeBoard_regdate) {
		this.recipeBoard_regdate = recipeBoard_regdate;
	}

	public int getRecipeBoard_readCount() {
		return recipeBoard_readCount;
	}

	public void setRecipeBoard_readCount(int recipeBoard_readCount) {
		this.recipeBoard_readCount = recipeBoard_readCount;
	}

	public int getRecipeBoard_like() {
		return recipeBoard_like;
	}

	public void setRecipeBoard_like(int recipeBoard_like) {
		this.recipeBoard_like = recipeBoard_like;
	}

}
