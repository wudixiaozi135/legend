package com.view.gameWindow.panel.panels.activitys.castellanWorship
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityWorshipCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.interf.INpcDynamic;
	
	import flash.utils.Dictionary;

	/**
	 * 膜拜基本数据类
	 * @author Administrator
	 */	
	public class DataWorshipInfo
	{
		/**1:点赞*/
		public static const TYPE_OPERATE_1:int = 1;
		/**2:扔肥皂*/
		public static const TYPE_OPERATE_2:int = 2;
		/**3:调戏*/
		public static const TYPE_OPERATE_3:int = 3;
		/**4:养护*/
		public static const TYPE_OPERATE_4:int = 4;
		/**5:泼硫酸*/
		public static const TYPE_OPERATE_5:int = 5;
		
		public static function textType(type:int):String
		{
			var str:String = "";
			switch(type)
			{
				case TYPE_OPERATE_1:
					str = StringConst.WORSHIP_INFO_0001;
					break;
				case TYPE_OPERATE_2:
					str = StringConst.WORSHIP_INFO_0002;
					break;
				case TYPE_OPERATE_3:
					str = StringConst.WORSHIP_INFO_0003;
					break;
				case TYPE_OPERATE_4:
					str = StringConst.WORSHIP_INFO_0004;
					break;
				case TYPE_OPERATE_5:
					str = StringConst.WORSHIP_INFO_0005;
					break;
				default:
					break;
			}
			return str;
		}
		
		public function get cfgDt():ActivityWorshipCfgData
		{
			var cfgDt:ActivityWorshipCfgData = ConfigDataManager.instance.worshipCfgData();
			return cfgDt;
		}
		
		private var _shopCfgDts:Dictionary;
		public function get shopCfgDt():Dictionary
		{
			if(!_shopCfgDts)
			{
				_shopCfgDts = new Dictionary();
				var shopCfgDt:NpcShopCfgData = ConfigDataManager.instance.npcShopCfgData1(cfgDt.praise_item_shop);
				_shopCfgDts[TYPE_OPERATE_1] = shopCfgDt;
				shopCfgDt = ConfigDataManager.instance.npcShopCfgData1(cfgDt.soap_item_shop);
				_shopCfgDts[TYPE_OPERATE_2] = shopCfgDt;
				shopCfgDt = ConfigDataManager.instance.npcShopCfgData1(cfgDt.tease_item_shop);
				_shopCfgDts[TYPE_OPERATE_3] = shopCfgDt;
			}
			return _shopCfgDts;
		}
		
		private var _itemIds:Dictionary;
		public function get itemIds():Dictionary
		{
			if(!_itemIds)
			{
				_itemIds = new Dictionary();
				_itemIds[TYPE_OPERATE_1] = cfgDt.praise_item;
				_itemIds[TYPE_OPERATE_2] = cfgDt.soap_item;
				_itemIds[TYPE_OPERATE_3] = cfgDt.tease_item;
			}
			return _itemIds;
		}
		/**城主cid，0代表无*/
		public var cid:int;//  4字节有符号整形 
		/**城主sid，0代表无*/
		public var sid:int;//  4字节有符号整形
		/**城主性别*/
		public var sex:int;
		/**城主名称，""代表无*/
		public var name:String = "";// utf8 名字 
		/**当前尊严值*/
		public var dignity:int;//	4字节有符号整形  
		private const scaleLR:Number = .35075;
		private const scaleC:Number = .2985;
		/**尊严值显示缩放比例*/
		public function get dignityScale():Number
		{
			var dignityMax:int = cfgDt.max_dignity;
			var dignityMin:int = cfgDt.min_dignity;
			var dignityChangeMax:int = cfgDt.glitter_dignity;
			var dignityChangeMin:int = cfgDt.rust_dignity;
			var scale:Number = 0;
			if(dignity < dignityMin)
			{
				scale = 0;
			}
			else if(dignityMin <= dignity && dignity <= dignityChangeMin)
			{
				scale = (dignity - dignityMin)/(dignityChangeMin - dignityMin)*scaleLR;
			}
			else if(dignityChangeMin < dignity && dignity < dignityChangeMax)
			{
				scale = scaleLR + (dignity - dignityChangeMin)/(dignityChangeMax - dignityChangeMin)*scaleC;
			}
			else if(dignityChangeMax <= dignity && dignity <= dignityMax)
			{
				scale = scaleLR + scaleC + (dignity - dignityChangeMax)/(dignityMax - dignityChangeMax)*scaleLR;
			}
			else if(dignityMax < dignity)
			{
				scale = 1;
			}
			return scale;
		}
		/**状态,0：正常，1：灰暗，2：闪亮*/
		public function get bodyState():int
		{
			var dignityChangeMax:int = cfgDt.glitter_dignity;
			var dignityChangeMin:int = cfgDt.rust_dignity;
			var state:int = 0;
			if(dignity <= dignityChangeMin)
			{
				state = 1;
			}
			else if(dignityChangeMin < dignity && dignity < dignityChangeMax)
			{
				state = 0;
			}
			else if(dignityChangeMax <= dignity)
			{
				state = 2;
			}
			return state;
		}
		/**点赞，调戏，扔肥皂今日已用次数*/
		public var firstNum:int;// 1字节有符号整形 
		/**点赞，调戏，扔肥皂今日使用次数文本*/
		public function get strFirstNum():String
		{
			var totalCount:int = cfgDt.free_count + cfgDt.toll_count;
			return isFirstCountOver ? (totalCount + "/" + totalCount) : (firstNum + "/" + totalCount);
		}
		/**点赞，调戏，扔肥皂是否需要购买道具*/
		public function isNeedBuyItem(type:int):Boolean
		{
			var isFirstType:Boolean = isFirstType(type);
			if(!isFirstType)
			{
				return false;
			}
			var itemId:int = itemIds[type] as int;
			var num:int = BagDataManager.instance.getItemNumById(itemId);
			num += HeroDataManager.instance.getItemNumById(itemId);
			return firstNum >= cfgDt.free_count && !num;
		}
		/**点赞，调戏，扔肥皂是否已用完次数*/
		public function get isFirstCountOver():Boolean
		{
			return firstNum >= (cfgDt.free_count + cfgDt.toll_count);
		}
		/**是否为点赞，调戏，扔肥皂*/
		public function isFirstType(type:int):Boolean
		{
			if(type != DataWorshipInfo.TYPE_OPERATE_1 && type != DataWorshipInfo.TYPE_OPERATE_2 && type != DataWorshipInfo.TYPE_OPERATE_3)
			{
				return false;
			}
			return true;
		}
		/**是否为养护，泼硫酸类型*/
		public function isFamilyType(type:int):Boolean
		{
			if(type != DataWorshipInfo.TYPE_OPERATE_4 && type != DataWorshipInfo.TYPE_OPERATE_5)
			{
				return false;
			}
			return true;
		}
		/**养护，泼硫酸已用次数(如果是帮主有)<br>-1表示没有该值*/
		public var familyNum:int;// 1字节有符号整形 
		/**养护，泼硫酸使用次数文本*/
		public function get strFamilyNum():String
		{
			var str:String = familyNum == -1 ? "" : (familyNum + "/" + cfgDt.free_family_count);
			return isFamilyCountOver ? (cfgDt.free_family_count + "/" + cfgDt.free_family_count) : str;
		}
		/**养护，泼硫酸是否已用完次数*/
		public function get isFamilyCountOver():Boolean
		{
			return familyNum >= cfgDt.free_family_count;
		}
		/**是否为帮主*/
		public function get isHead():Boolean
		{
			return familyNum != -1;
		}
		/**相关的动态NPC实体id*/
		public var entityIds:Dictionary;
		
		public function DataWorshipInfo()
		{
			entityIds = new Dictionary();
		}
		
		public function changeNpcDynamicMode():void
		{
			var entityId:int
			for each(entityId in entityIds)
			{
				var entity:INpcDynamic = EntityLayerManager.getInstance().getEntity(EntityTypes.ET_NPC,entityId) as INpcDynamic;
				if(entity)
				{
					entity.changeMode();
				}
			}
		}
	}
}