package com.view.gameWindow.panel.panels.forge.compound
{
	//合成中二级分类中所有材料可合成总数
	public class CombineType2Data
	{
		public var canCombineNum:int=0;//该材料可合成数量
		public var type:int;//一级分类
		public var type2:int;//二级分类
		public var combineVec:Vector.<CombineData>;
		public var name:String;
	}
}