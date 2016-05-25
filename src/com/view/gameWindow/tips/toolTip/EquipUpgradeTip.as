package com.view.gameWindow.tips.toolTip
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.HeroEquipUpgradeCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.ConditionConst;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.trans.ReawardData;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.ServerTime;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class EquipUpgradeTip extends BaseTip
	{
		private var _iconSprite:Sprite;
		
		public function EquipUpgradeTip()
		{
			_skin=new EquipTipUpgradeSkin();
			addChild(_skin);
			initView(_skin);
			mouseEnabled=true;
			mouseChildren=true;
			_iconSprite=new Sprite();
			addChild(_iconSprite);
			addEventListener(MouseEvent.ROLL_OUT,onMouseOutFunc);
		}
		
		override public function setData(data:Object):void
		{
			_data=data;
			var htmlstr:String=HtmlUtils.createHtmlStr(0xff6600,StringConst.HERO_UPGRADE_0001);
			addProperty(htmlstr,16,10);
			maxHeight=30;
			var upgradeCfg:HeroEquipUpgradeCfgData= data as HeroEquipUpgradeCfgData;
			setCondition1(upgradeCfg);
			setCondition2(upgradeCfg);

			addSplitLine(16,maxHeight);
			maxHeight+=10;
			var html1:String=HtmlUtils.createHtmlStr(0xff6600,StringConst.HERO_UPGRADE_0005);
			addProperty(html1,18,maxHeight);
			maxHeight+=20;
			
			var itemStr:String =upgradeCfg.equip ;
			var itemArr:Array = itemStr.split("|");
			var picData:ReawardData;
			for each(var str:String in itemArr)
			{
				var strArr:Array = str.split(":");
				var rewardData:ReawardData = new ReawardData();
				rewardData.type = strArr[1];
				rewardData.id = strArr[0];
				rewardData.count = strArr[2];
				if(rewardData.type == SlotType.IT_EQUIP)
				{
					if(ConfigDataManager.instance.equipCfgData(rewardData.id).sex == 0 || HeroDataManager.instance.sex == ConfigDataManager.instance.equipCfgData(rewardData.id).sex)
					{
						if(ConfigDataManager.instance.equipCfgData(rewardData.id).job == 0 || HeroDataManager.instance.job == ConfigDataManager.instance.equipCfgData(rewardData.id).job)
						{
							picData=rewardData;	
						}
					}
				}
			}
			var tipSprite:EquipTipUpgradeSkin=_skin as EquipTipUpgradeSkin;
			if(picData)
			{
				var equipCfgData:EquipCfgData=ConfigDataManager.instance.equipCfgData(picData.id);
				var url:String = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
				ToolTipManager.getInstance().attachByTipVO(_iconSprite,ToolTipConst.FASHION_TIP,equipCfgData);
				loadPic(url);
			}
			height=maxHeight+90;
		}
		
		override public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			destroyLoader();
			_iconBmp = new Bitmap(bitmapData,"auto",true);
			_iconBmp.width = 60;
			_iconBmp.height = 60;
			_iconSprite.addChild(_iconBmp);
			_iconSprite.x = _skin.mcIcon.x+5;
			_iconSprite.y=maxHeight+5;
			_skin.mcIcon.y=maxHeight;
		}
		
		protected override function destroyIcon():void{
			if(_iconBmp&&_iconBmp.bitmapData)
			{
				_iconBmp.bitmapData.dispose();
				_iconBmp.bitmapData = null;
				
				if(_iconBmp.parent)
					_iconBmp.parent.removeChild(_iconBmp);
			}
		}
		
		private function onMouseOutFunc(e:MouseEvent):void
		{
			ToolTipLayMediator.getInstance().removeAllTip();
		}
		
		public override function dispose():void
		{
			removeEventListener(MouseEvent.ROLL_OUT,onMouseOutFunc);
			ToolTipManager.getInstance().detach(_iconSprite);
			super.dispose();
		}
		
		private function setCondition1(upgradeCfg:HeroEquipUpgradeCfgData):void
		{
			var htmlStr:String="";
			var cut:int;
			var ned:int;
			var color:String="#ff0000";
			switch(upgradeCfg.condition)
			{
				case ConditionConst.TIMER:
					cut=(ServerTime.time-(HeroDataManager.instance.heroActivateData.timer-upgradeCfg.param/1000))/60;
					ned=upgradeCfg.param/60/1000;
					color="#ff0000";
					if(cut>=ned)
					{
						cut=ned;
						color="#00ff00";
					}
					htmlStr=HtmlUtils.createHtmlStr(0xd4a460,StringConst.HERO_UPGRADE_0002+"<font color='"+color+"'>"+cut+"</font><font color='#00ff00'>/"+ned+StringConst.HERO_UPGRADE_0003+"</font> ");
					break;
				case ConditionConst.EXP:
					cut=HeroDataManager.instance.heroActivateData.exp;
					ned=upgradeCfg.param;
					color="#ff0000";
					if(cut>=ned)
					{
						cut=ned;
						color="#00ff00";
					}
					htmlStr=HtmlUtils.createHtmlStr(0xd4a460,StringConst.HERO_UPGRADE_0020+"<font color='"+color+"'>"+cut+"</font><font color='#00ff00'>/"+ ned+"（"+int(cut/ned)*100+"%）</font>");
					break;
				case ConditionConst.LEVEL:
					cut=HeroDataManager.instance.lv;
					ned=upgradeCfg.param;
					color="#ff0000";
					if(cut>=ned)
					{
						color="#00ff00";
					}
					htmlStr=HtmlUtils.createHtmlStr(0xd4a460,(StringConst.HERO_UPGRADE_0009+"<font color='"+color+"'>"+cut+"</font><font color='#00ff00'>/"+ ned+StringConst.LEVEL+"</font>"));
					break;
			}
			addProperty(htmlStr,16,maxHeight);
			maxHeight+=20;
		}
		
		private function setCondition2(upgradeCfg:HeroEquipUpgradeCfgData):void
		{
			var htmlStr:String="";
			if(upgradeCfg.item_id!=0||upgradeCfg.bind_gold!=0)
			{
				htmlStr=HtmlUtils.createHtmlStr(0xd4a460,StringConst.HERO_UPGRADE_0004+"\n");
				addProperty(htmlStr,16,maxHeight);
				maxHeight+=20;
				var itemStr:String="";
				var itemCfg:ItemCfgData=ConfigDataManager.instance.itemCfgData(upgradeCfg.item_id);
				var htmlHei:int=0;
				if(itemCfg)
				{
					var count:int=BagDataManager.instance.getItemNumById(upgradeCfg.item_id);

					if(count>=upgradeCfg.item_count)
					{
						itemStr=HtmlUtils.createHtmlStr(0xffe1aa,itemCfg.name+"<font color='#00ff00'>("+count+"/"+upgradeCfg.item_count+")</font>\n");
					}else
					{
						itemStr=HtmlUtils.createHtmlStr(0xffe1aa,itemCfg.name+"<font color='#ff0000'>("+count+"/"+upgradeCfg.item_count+")</font>\n");
					}
					htmlHei+=20;
				}
				if(upgradeCfg.bind_gold>0)
				{
					var cut:int=BagDataManager.instance.goldBind;
					var ned:int=upgradeCfg.bind_gold;
					if(cut>ned)
					{
						itemStr+=HtmlUtils.createHtmlStr(0xffe1aa,StringConst.DUNGEON_PANEL_0020+"<font color='#00ff00'>("+cut+"/"+ned+")</font>");
						cut=ned;
					}else
					{
						itemStr+=HtmlUtils.createHtmlStr(0xffe1aa,StringConst.DUNGEON_PANEL_0020+"<font color='#ff0000'>("+cut+"/"+ned+")</font>");
					}
					htmlHei+=20;
				}
				if(itemStr.length>0)
				{
					addProperty(itemStr,76,maxHeight);
					maxHeight+=htmlHei;
				}
			}
		}
	}
}