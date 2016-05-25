package com.model.configData.cfgdata
{
	public class NpcCfgData
	{
		public var id:int;
		public var name:String;
		public var title:String;
		public var level:int;
		public var damagable:int;
		public var maxhp:int;
		public var revive_time:int;
		public var mapid:int;
		public var x:int;
		public var y:int;
		public var teleport_x:int;
		public var teleport_y:int;
		public var hide_shadow:int;
		public var func:int;
		public var func_extra:int;
		public var func_extra_param:int;
		public var func_url:String;
		public var default_dialog:String;
		public var bubble_dialog:String;
		public var dynamic:int;
		public var body:String;
		public var body1:String;
		public var body2:String;
		public var body3:String;
		public var body4:String;
		public var body5:String;
		public var head:String;
        public var isShowName:int;//不显示1显示名字2显示称号
        public var ismapShowName:int;//0 不显示 1显示名字 2称号  3全部显示
		
		public function NpcCfgData()
		{
		}
	}
}