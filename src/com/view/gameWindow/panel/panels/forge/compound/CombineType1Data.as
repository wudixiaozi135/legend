package com.view.gameWindow.panel.panels.forge.compound
{
	//合成中一级分类所有材料可合成总数
	public class CombineType1Data
	{
		public var canCombineNum:int;//该材料可合成数量
		public var type:int;//一级分类
		public var combineVec:Vector.<CombineType2Data>;
		public var name:String;
	}
}