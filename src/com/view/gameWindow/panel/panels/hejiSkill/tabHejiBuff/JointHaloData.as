package com.view.gameWindow.panel.panels.hejiSkill.tabHejiBuff
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.JointHaloCfgData;

	public class JointHaloData
	{
		/**id 4字节有符号整形 合击光环id*/
		public var id:int;
		/**level 4字节有符号整形 合击光环等级*/
		public var level:int;
		/**type  4字节有符号整形 类型1：主光环2：副光环*/
		public var type:int;
		/**first_slot 4字节有符号整形 第一个符文id 没有为0*/
		public var firstSlot:int;
		/**
		 * second_slot 4字节有符号整形 第二个符文id 没有为0
		 * three_slot 4字节有符号整形 第三个符文id 没有为0 
		 * four_slot 4字节有符号整形 第四个符文id 没有为0 
		 * five_slot 4字节有符号整形 第五个符文id 没有为0 
		 * six_slot 4字节有符号整形 第六个符文id 没有为0
		 */		
		public var buffs:Array;
		
		public function get jointHaloCfgDt():JointHaloCfgData
		{
			var cfgDt:JointHaloCfgData = ConfigDataManager.instance.jointHaloCfgData(id,level);
			return cfgDt;
		}
		
		public function JointHaloData()
		{
		}
	}
}