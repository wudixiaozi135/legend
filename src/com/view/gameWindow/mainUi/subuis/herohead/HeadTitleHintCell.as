//package com.view.gameWindow.mainUi.subuis.herohead
//{
//	import com.greensock.TimelineLite;
//	import com.greensock.TweenLite;
//	import com.model.business.fileService.UrlBitmapDataLoader;
//	import com.model.business.fileService.constants.ResourcePathConstants;
//	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
//	import com.model.configData.ConfigDataManager;
//	import com.model.configData.cfgdata.EquipCfgData;
//	import com.model.configData.cfgdata.HeroEquipUpgradeCfgData;
//	import com.model.consts.SlotType;
//	import com.model.consts.StringConst;
//	import com.view.gameWindow.mainUi.subclass.McHeroHead;
//	import com.view.gameWindow.mainUi.subclass.McHeroHeadEquipTip;
//	import com.view.gameWindow.panel.panels.hero.ConditionConst;
//	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
//	import com.view.gameWindow.panel.panels.hero.tab1.equip.activate.HeroEquipActivateData;
//	import com.view.gameWindow.panel.panels.trans.ReawardData;
//	import com.view.gameWindow.scene.entity.EntityLayerManager;
//	import com.view.gameWindow.scene.entity.entityItem.interf.IHero;
//	import com.view.gameWindow.util.HtmlUtils;
//	import com.view.gameWindow.util.ServerTime;
//	import com.view.gameWindow.util.TimerManager;
//	import com.view.gameWindow.util.cooldown.ShapeDraw;
//
//	import flash.display.Bitmap;
//	import flash.display.BitmapData;
//	import flash.display.Shape;
//	import flash.filters.GlowFilter;
//	import flash.utils.getTimer;
//
//	public class HeadTitleHintCell implements IUrlBitmapDataLoaderReceiver
//	{
//		private var _icon:Bitmap;
//		private var _panel:McHeroHeadEquipTip;
//		private var _loadBitmap:UrlBitmapDataLoader;
//		private var _iconUrl:String;
//		protected const _filter:GlowFilter = new GlowFilter(0,1,2,2,10);
//		private var _mask:Shape;
//		private var _cdShape:Shape;
//		private var _grade:int=0;
//		private var _order:int=0;
//		private var _flyIn:Boolean;
//
//		private var gress:Number;
//
//		public function HeadTitleHintCell(skin:McHeroHead)
//		{
//			super();
//			_icon=new Bitmap();
//			_panel=skin.mcEquipHint;
//			_panel.addChild(_icon);
//			_icon.x=_panel.mcBagCell.x+5;
//			_icon.y=_panel.mcBagCell.y+5;
//			_cdShape=new Shape();
//			_cdShape.graphics.beginFill(0x000000,0.1);
//			_cdShape.graphics.drawRect(0,0,36,36);
//			_cdShape.graphics.endFill();
//			_panel.addChild(_cdShape);
//			_cdShape.x=	_icon.x;
//			_cdShape.y=	_icon.y;
//			_mask=new Shape();
//			_panel.addChild(_mask);
//			_mask.x=_icon.x;
//			_mask.y=_icon.y;
//			_cdShape.mask=_mask;
//			_panel.txtTitle.filters=[_filter];
//			_iconUrl="";
//
//			_flyIn=false;
//			TimerManager.getInstance().add(1000,timerFunc);
//		}
//
//		private function drawCD(gress:Number):void
//		{
//			var endAngle:Number =360* (1-gress);
//			var radius:Number = Math.sqrt(36 * 36 + 36 * 36) / 2;
//			_mask.graphics.clear();
//			_mask.graphics.beginFill(0x000000, 0.5);
//			ShapeDraw.drawFan(_mask.graphics, radius, -90, 0-endAngle-90, 18, 18);
//		}
//
//		private function updateGress():void
//		{
//			var upgradeData:HeroEquipActivateData=HeroDataManager.instance.heroActivateData;
//			if(upgradeData.grade==0||upgradeData.order==0)return;
//			var upgradeCfg:HeroEquipUpgradeCfgData=ConfigDataManager.instance.heroEquipUpgradeCfgData(upgradeData.grade,upgradeData.order);
//			if(upgradeCfg==null)return;
//			var htmlStr:String="";
//			gress=1;
//			if(upgradeCfg.item_id==0&&upgradeCfg.bind_gold==0)
//			{
//				if(upgradeCfg.condition==ConditionConst.LEVEL)
//				{
//					htmlStr=HtmlUtils.createHtmlStr(0xffcc00,upgradeCfg.param+StringConst.HERO_UPGRADE_0015);
//					gress=HeroDataManager.instance.lv/upgradeCfg.param;
//
//				}else if(upgradeCfg.condition==ConditionConst.TIMER)
//				{
//					if(ServerTime.timeMs+10000<getTimer())return;
//					var m:int= Math.ceil((upgradeData.timer-ServerTime.time)/60);
//					gress=(upgradeData.timer-ServerTime.time)/(upgradeCfg.param/1000);
//					if(m<0)
//					{
//						htmlStr=HtmlUtils.createHtmlStr(0xffcc00,StringConst.HERO_UPGRADE_0017);
//					}else
//					{
//						htmlStr=HtmlUtils.createHtmlStr(0xffcc00,m+StringConst.HERO_UPGRADE_0016);
//					}
//				}else
//				{
//					gress=upgradeData.exp/upgradeCfg.param;
//				}
//			}else
//			{
//				htmlStr=HtmlUtils.createHtmlStr(0xffcc00,StringConst.HERO_UPGRADE_0017);
//				gress=0;
//			}
//			if(gress>1||gress<0)gress=1
//			drawCD(gress);
//			_panel.txtTitle.htmlText=htmlStr;
//		}
//
//		private function updateIcon():void
//		{
//			var upgradeData:HeroEquipActivateData=HeroDataManager.instance.heroActivateData;
//			var upgradeCfg:HeroEquipUpgradeCfgData=ConfigDataManager.instance.heroEquipUpgradeCfgData(upgradeData.grade,upgradeData.order);
//			if(upgradeCfg==null)
//			{
//				return;
//			}
//			_grade=upgradeData.grade;
//			_order=upgradeData.order;
//
//			updateGress();
//
//			var itemStr:String =upgradeCfg.equip ;
//			var itemArr:Array = itemStr.split("|");
//			var picData:ReawardData;
//
//			for each(var str:String in itemArr)
//			{
//				var strArr:Array = str.split(":");
//				var rewardData:ReawardData = new ReawardData();
//				rewardData.type = strArr[1];
//				rewardData.id = strArr[0];
//				rewardData.count = strArr[2];
//				if(rewardData.type == SlotType.IT_EQUIP)
//				{
//					if(ConfigDataManager.instance.equipCfgData(rewardData.id).sex == 0 || HeroDataManager.instance.sex == ConfigDataManager.instance.equipCfgData(rewardData.id).sex)
//					{
//						if(ConfigDataManager.instance.equipCfgData(rewardData.id).job == 0 || HeroDataManager.instance.job == ConfigDataManager.instance.equipCfgData(rewardData.id).job)
//						{
//							picData=rewardData;
//						}
//					}
//				}
//			}
//			if(picData)
//			{
//				var equipCfgData:EquipCfgData=ConfigDataManager.instance.equipCfgData(picData.id);
//				var url:String = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
//				if(_iconUrl!=url)
//				{
//					if(_loadBitmap)
//					{
//						_loadBitmap.destroy();
//						_loadBitmap=null;
//					}
//					_loadBitmap=new UrlBitmapDataLoader(this);
//					_loadBitmap.loadBitmap(url);
//					_iconUrl=url;
//				}
//			}
//		}
//
//		public function refresh():void
//		{
//			if(_flyIn)return;
//			var upgradeData:HeroEquipActivateData=HeroDataManager.instance.heroActivateData;
//			if(_grade==0&&_order==0)
//			{
//				_grade=upgradeData.grade;
//				_order=upgradeData.order;
//			}
//
//			if(_grade!=upgradeData.grade||_order!=upgradeData.order)  //如果是装备更新了
//			{
//				_flyIn=true;
////				_panel.txtBg.visible=false;
//				_panel.mcBagCell.visible=false;
//				_panel.txtTitle.visible=false;
//				var timeLine:TimelineLite= new TimelineLite();
//				timeLine.append(TweenLite.to(_panel,2,{x:"-172",y:"8"}));
//				timeLine.append(TweenLite.to(_panel,2,{alpha:0,onComplete:onFinishTween}));
//				timeLine.play();
//			}else
//			{
//				updateIcon();
//			}
//		}
//
//		private function onFinishTween():void
//		{
//			var hero:IHero=EntityLayerManager.getInstance().myHero;
//			hero&&hero.say(StringConst.HERO_SAY_0001);
//			updateIcon();
//			_panel.x=170;
//			_panel.y=4;
//			_panel.alpha=1;
////			_panel.txtBg.visible=true;
//			_panel.mcBagCell.visible=true;
//			_panel.txtTitle.visible=true;
//			_flyIn=false;
//		}
//
//		private function timerFunc():void
//		{
//			updateGress();
//			drawCD(gress);
//		}
//
//		private function destory():void
//		{
//
//		}
//
//		public function urlBitmapDataError(url:String, info:Object):void
//		{
//			// TODO Auto Generated method stub
//		}
//
//		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
//		{
//			// TODO Auto Generated method stub
//		}
//
//		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
//		{
//			// TODO Auto Generated method stub
//			_icon.bitmapData=bitmapData;
//			_icon.scaleX=36/bitmapData.width;
//			_icon.scaleY=36/bitmapData.height;
//			_loadBitmap.destroy();
//			_loadBitmap=null;
//		}
//	}
//}