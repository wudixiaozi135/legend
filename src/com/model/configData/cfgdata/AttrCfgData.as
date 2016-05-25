package com.model.configData.cfgdata
{
	import com.model.consts.JobConst;
	import com.model.consts.RolePropertyConst;

	public class AttrCfgData
	{
		public var id:int;//11	序列
		public var name:String;//16	名称
		public var attr_type:int;//11	属性类型
		private var _attr_ratio:int;//11	系数
		public function set attr_ratio(value:int):void
		{
			_attr_ratio = value;
		}
		public var percentage:int;//11	是否使用百分比符号
		public var tips:String;//256	tip文字
		public var is_dialog:int;
		
		public function AttrCfgData()
		{
		}
		
		public function getAttr_ratio(job:int):int
		{
			switch(attr_type)
			{
				case RolePropertyConst.ROLE_PROPERTY_PHSICAL_ATTACK_LOWER_ID:
					return JobConst.isNO(job) || JobConst.isZS(job) ? _attr_ratio : 0;
					break;
				case RolePropertyConst.ROLE_PROPERTY_PHYSICAL_ATTACK_UPPER_ID:
					return JobConst.isNO(job) || JobConst.isZS(job) ? _attr_ratio : 0;
					break;
				case RolePropertyConst.ROLE_PROPERTY_MAGIC_ATTACK_UPPER_ID:
					return JobConst.isNO(job) || JobConst.isFS(job) ? _attr_ratio : 0;
					break;
				case RolePropertyConst.ROLE_PROPERTY_MAGIC_ATTACK_LOWER_ID:
					return JobConst.isNO(job) || JobConst.isFS(job) ? _attr_ratio : 0;
					break;
				case RolePropertyConst.ROLE_PROPERTY_TAOISM_ATTACK_UPPER_ID:
					return JobConst.isNO(job) || JobConst.isDS(job) ? _attr_ratio : 0;
					break;
				case RolePropertyConst.ROLE_PROPERTY_TAOISM_ATTACK_LOWER_ID:
					return JobConst.isNO(job) || JobConst.isDS(job) ? _attr_ratio : 0;
				default:
					return _attr_ratio;
			}
		}
	}
}