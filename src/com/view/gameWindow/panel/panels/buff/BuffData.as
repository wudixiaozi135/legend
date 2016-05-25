package com.view.gameWindow.panel.panels.buff
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.BuffCfgData;
	
	/**
	 * @author wqhk
	 * 2014-9-13
	 */
	public class BuffData
	{
		public static const SPECIAL_NONE:int = 0;
		public static const SPECIAL_TRIGGER_SKILL:int = 1;
		public static const SPECIAL_STEALTHY:int = 2;
		
		private var _cfg:BuffCfgData;
		public var endtime:int;//second unix
		
		public function get cfg():BuffCfgData
		{
			return _cfg;
		}
		
		public function get id():int
		{
			return _cfg?_cfg.id:0;
		}
		
		public function set id(value:int):void
		{
			if(id == value)
			{
				return;
			}
			if(value == 0)
			{
				_cfg = null;
			}
			else
			{
				_cfg = ConfigDataManager.instance.buffCfgData(value);
			}
		}
		
		public function copy(data:BuffData):void
		{
			id = data.id;
			endtime = data.endtime;
		}
		/**
		 * 获得特殊效果触发技能id
		 * @return 触发的技能id，0表示非触发技能
		 */		
		public function get specialTriggerSkill():int
		{
			if(_cfg.special == SPECIAL_TRIGGER_SKILL)
			{
				return _cfg.special_param;
			}
			return 0;
		}
	}
}