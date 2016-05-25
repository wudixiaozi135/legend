package com.view.gameWindow.panel.panels.convert
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipExchangeCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilNumChange;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	/**
	 * @author wqhk
	 * 2014-8-30
	 */
	public class EquipExchangeCfgDataUtils
	{
		public static const SHENGWANG:String = "shengwang";
		public static function getDes(cfg:EquipExchangeCfgData,preCfg:EquipExchangeCfgData):String
		{
			//字符串 暂时放这 别忘了 stringconst
			var des:String = "";
			
			if(preCfg && preCfg.next_id == cfg.id)
			{
				var equip:EquipCfgData = ConfigDataManager.instance.equipCfgData(preCfg.id);
				
				des+=HtmlUtils.createHtmlStr(0xa56238,StringConst.CONVERT_007,12,false,0);
				
				var color:int = ConvertDataManager.instance.isOwn(cfg.id) ? 0x53b436:0xff0000;
				des+=HtmlUtils.createHtmlStr(color,equip.name,12,false,0,FontFamily.FONT_NAME,true,"equip");
				des+="<br/>";
			}
			
			var firstTip:String = null;
			if(cfg && cfg.des)
			{
				firstTip = CfgDataParse.pareseDesToStr(cfg.des,0xffffff,8);
			}
			//擦
			cfg = preCfg;
			
			if(!cfg)
			{
				des= firstTip ? firstTip : HtmlUtils.createHtmlStr(0xffcc00,StringConst.CONVERT_024,12,false,12,FontFamily.FONT_NAME);
				return des;
			}
			
			if(cfg.player_reincarn>0 || cfg.player_level>0)
			{
				des+=HtmlUtils.createHtmlStr(0xa56238,StringConst.CONVERT_008,12,false,0);
				des+=HtmlUtils.createHtmlStr(getColor(RoleDataManager.instance.reincarn>cfg.player_reincarn||
												RoleDataManager.instance.reincarn==cfg.player_reincarn && RoleDataManager.instance.lv>=cfg.player_level),
												(cfg.player_reincarn>0 ? cfg.player_reincarn+StringConst.CONVERT_014:"")+cfg.player_level+StringConst.CONVERT_015,12,false,0);
				
				des+="<br/>";
			}
			
			var numChange:UtilNumChange = new UtilNumChange();
			if(cfg.coin>0)
			{
				des+=HtmlUtils.createHtmlStr(0xa56238,StringConst.CONVERT_009,12,false,0);
				des+=HtmlUtils.createHtmlStr(getColor(BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind >= cfg.coin),
												numChange.changeNum(cfg.coin),12,false,0);
				des+="<br/>";
			}
			
			if(cfg.zhuangyuanshengwang>0)
			{
				des+=HtmlUtils.createHtmlStr(0xa56238,StringConst.CONVERT_010,12,false,0);
				des+=HtmlUtils.createHtmlStr(getColor(RoleDataManager.instance.reputation>=cfg.zhuangyuanshengwang),"("+numChange.changeNum(RoleDataManager.instance.reputation)+"/"+numChange.changeNum(cfg.zhuangyuanshengwang)+")",12,false,0);
				des+="<br/>";
				des+="<br/>";
				des+=HtmlUtils.createHtmlStr(0x70ad47,StringConst.CONVERT_021,12,false,2,FontFamily.FONT_NAME,true,SHENGWANG);
				des+="<br/>";
			}
			
			if(cfg.item>0)
			{
				
				var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(cfg.item);
				var num:int = BagDataManager.instance.getItemNumById(itemCfg.id);
				des+=HtmlUtils.createHtmlStr(0xa56238,StringConst.CONVERT_020+"["+itemCfg.name+"]"+StringConst.COLON,12,false,0);
				des+=HtmlUtils.createHtmlStr(getColor(num>=cfg.item_count),num+"/"+cfg.item_count,12,false,0);
				
				des+="<br/>";
			}
			
			if(cfg.hero_grade>0)
			{
				des+=HtmlUtils.createHtmlStr(0xa56238,StringConst.CONVERT_012,12,false,0);
				des+=HtmlUtils.createHtmlStr(getColor(HeroDataManager.instance.grade>=cfg.hero_grade),cfg.hero_grade.toString(),12,false,0);
				des+="<br/>";
			}
			
			if(cfg.hero_love>0)
			{
				des+=HtmlUtils.createHtmlStr(0xa56238,StringConst.CONVERT_013,12,false,0);
				des+=HtmlUtils.createHtmlStr(getColor(HeroDataManager.instance.love>=cfg.hero_love),cfg.hero_love.toString(),12,false,0);
				des+="<br/>";
				des+=HtmlUtils.createHtmlStr(0x70ad47,StringConst.CONVERT_022,12,false,2,FontFamily.FONT_NAME,true,"love");
				des+="<br/>";
			}
			
			return des;
		}
		
		private static function getColor(complete:Boolean):uint
		{
			if(complete)
			{
				return 0x53b436;
			}
			else
			{
				return 0xff0000;
			}
		}
	}
}