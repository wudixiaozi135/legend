package com.view.gameWindow.panel.panels.hero.tab1.equip.activate
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.HeroEquipUpgradeCfgData;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.hero.ConditionConst;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCell;
	import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class HeroEquipActivateCell extends Sprite implements IUrlSwfLoaderReceiver,IUrlBitmapDataLoaderReceiver,IToolTipClient
	{
		private var _btnLabel:TextField;
		private var _conditionTxt:TextField;
		private var _equipCell:EquipCell;
		private var _bar:Bitmap;
		public var btn:Sprite;
		private var _slot:int;
		private var _type:int;
		private const _barWidth:int=45;
		private var _timerHandlerFunc:Function;
		public var btnType:int;
		public var title:String="";
		
		protected const _filter:GlowFilter = new GlowFilter(0,1,2,2,10);

		private var btnLoader:UrlSwfLoader;

		private var picLoader:UrlBitmapDataLoader;
		
		public function HeroEquipActivateCell()
		{
			this.mouseEnabled=false;
			initView();
		}
		
		public function initView():void
		{
			btnLoader= new UrlSwfLoader(this);
			btnLoader.loadSwf(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"hero/activate"+ResourcePathConstants.POSTFIX_SWF);
			
			_bar=new Bitmap();
			addChild(_bar);
			_bar.x=-6.5;
			_bar.y=40;
			picLoader=new UrlBitmapDataLoader(this);
			picLoader.loadBitmap(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+"hero/layer"+ResourcePathConstants.POSTFIX_JPG);
			btn=new Sprite();
			addChild(btn);
			
			_btnLabel=new TextField();
			_btnLabel.autoSize="left";
			_btnLabel.width=15;
			_btnLabel.wordWrap = true;
			_btnLabel.multiline =true;
			_btnLabel.mouseEnabled=false;
			_btnLabel.filters = [_filter];
			
			_conditionTxt=new TextField();
			_conditionTxt.width=75;
			_conditionTxt.wordWrap = true;
			var txtformat:TextFormat=new TextFormat();
			txtformat.align=TextFormatAlign.CENTER;
			_conditionTxt.defaultTextFormat=txtformat;
			_conditionTxt.multiline =true;
			_conditionTxt.mouseEnabled=false;
			_conditionTxt.filters = [_filter];
			addChild(_conditionTxt);
			_conditionTxt.visible=false;
			_conditionTxt.x=-19.5;
			_conditionTxt.y=0;
		}
		
		public function updateView():void
		{
		
			var heroUpgrade:HeroEquipActivateData =HeroDataManager.instance.heroActivateData;
			var upgradeCfg:HeroEquipUpgradeCfgData=ConfigDataManager.instance.heroEquipUpgradeCfgData(heroUpgrade.grade,heroUpgrade.order);
			visible=HeroDataManager.instance.lv>=upgradeCfg.level_sction;
			
			_bar.visible=true;
			_conditionTxt.visible=_equipCell.onlyId!=0;
			
//			if(upgradeCfg.is_auto==ConditionConst.HAND)
//			{
				btn.visible=true;
				_btnLabel.visible=true;
				setBtnLabel(ConditionConst.TYPE_ACTIVATE);
//			}else
//			{
//				btn.visible=false;
//				_btnLabel.visible=false;
//			}

			switch(upgradeCfg.condition)
			{
				case ConditionConst.LEVEL:
					setLevel(heroUpgrade,upgradeCfg);
					break;
				case ConditionConst.EXP:
					setExp(heroUpgrade,upgradeCfg);
					break;
				case ConditionConst.TIMER:
					setTimer(heroUpgrade,upgradeCfg);
					break;
				default:
					break;
			}
		}
		
		private function setTimer(heroUpgrade:HeroEquipActivateData,upgradeCfg:HeroEquipUpgradeCfgData):void
		{
			timerHandlerFunc(heroUpgrade,upgradeCfg);
			_timerHandlerFunc=timerHandlerFunc;
		}
		
		private function timerHandlerFunc(heroUpgrade:HeroEquipActivateData,upgradeCfg:HeroEquipUpgradeCfgData):void
		{
			var gress:int=heroUpgrade.timer-ServerTime.time;
			if(gress<1)
			{
				_timerHandlerFunc=null;
				title="";
				_conditionTxt.visible=false;
			}
			
			if(_conditionTxt.visible==true)
			{
				var timerStr:String=HtmlUtils.createHtmlStr(0xffe1aa,TimeUtils.formatClock1(heroUpgrade.timer-ServerTime.time))+"\n";
				timerStr+=HtmlUtils.createHtmlStr(0xffe1aa,StringConst.HERO_UPGRADE_0006);
				_conditionTxt.htmlText=timerStr;
			}
			
			var s:Number=(ServerTime.time+upgradeCfg.param/1000-heroUpgrade.timer)/(upgradeCfg.param/1000);
			if(s<1)
			{
				title=StringConst.HERO_UPGRADE_0011.replace("X",TimeUtils.formatClock1(gress));
			}
			setScrollBar(s);
		}
		
		private function setExp(heroUpgrade:HeroEquipActivateData,upgradeCfg:HeroEquipUpgradeCfgData):void
		{
			var s:Number=heroUpgrade.exp/upgradeCfg.param;
			setScrollBar(s);
			if(s>=1)
			{
				setBtnLabel(ConditionConst.TYPE_ACTIVATE);
			}else
			{
				setBtnLabel(ConditionConst.TYPE_CHONGNENG);
			}
		}
		
		private function setBtnLabel(type:int):void
		{
			if(type==ConditionConst.TYPE_CHONGNENG)
			{
				_btnLabel.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringConst.HERO_UPGRADE_0008,12);
			}else
			{
				_btnLabel.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringConst.HERO_UPGRADE_0007,12);
			}
			btnType=type;
		}
		
		private function setLevel(heroUpgrade:HeroEquipActivateData,upgradeCfg:HeroEquipUpgradeCfgData):void
		{
			if(_conditionTxt.visible)
			{
				var str:String=HtmlUtils.createHtmlStr(0xff0000,"LV "+upgradeCfg.param,14,true)+"\n";
				str+=HtmlUtils.createHtmlStr(0xffe1aa,StringConst.HERO_UPGRADE_0006);
				_conditionTxt.htmlText=str;
			}
			var s:Number=HeroDataManager.instance.lv/upgradeCfg.param;
			if(s<1)
			{
				title=StringConst.HERO_UPGRADE_0012.replace("X",upgradeCfg.param-HeroDataManager.instance.lv);
			}else
			{
				title="";
			}
			setScrollBar(s);
		}
		
		public function timer():void
		{
			var heroUpgrade:HeroEquipActivateData =HeroDataManager.instance.heroActivateData;
			var upgradeCfg:HeroEquipUpgradeCfgData=ConfigDataManager.instance.heroEquipUpgradeCfgData(heroUpgrade.grade,heroUpgrade.order);
			if(_timerHandlerFunc!=null)
			{
				_timerHandlerFunc(heroUpgrade,upgradeCfg);	
			}
		}
		
		public function setTimerText():void
		{
			_conditionTxt.x=(_equipCell.width-75)*0.5;
			_conditionTxt.y=(_equipCell.height-_conditionTxt.textHeight)*0.5;
		}
		
		private function setScrollBar(s:Number):void
		{
			_bar.scaleX=s;
			if(s>1)
			{
				_bar.scaleX=1;
			}
		}
		
		public function destory():void
		{
			btnLoader&&btnLoader.destroy();
			btnLoader=null;
			picLoader&&picLoader.destroy();
			picLoader=null;
			if(_btnLabel)
			{
				_btnLabel.parent&&_btnLabel.parent.removeChild(_btnLabel);
			}
			_btnLabel=null;
			
			if(_conditionTxt)
			{
				_conditionTxt.parent&&_conditionTxt.parent.removeChild(_conditionTxt);
			}
			_conditionTxt=null;
			_equipCell = null;
			if (_bar)
			{
				if (_bar.bitmapData)
				{
					_bar.bitmapData.dispose();
					_bar.bitmapData = null;
				}
				if (_bar.parent)
				{
					_bar.parent.removeChild(_bar);
				}
				_bar = null;
			}
			if (btn)
			{
				while (btn.numChildren > 0)
				{
					btn.removeChild(btn.getChildAt(0));
				}
				if (btn.parent)
				{
					btn.parent.removeChild(btn);
				}
				btn = null;
			}
			_timerHandlerFunc = null;
		}

		public function get equipCell():EquipCell
		{
			return _equipCell;
		}

		public function set equipCell(value:EquipCell):void
		{
			_equipCell = value;
			
			this.x=_equipCell.x;
			this.y=_equipCell.y;
		}

		public function get slot():int
		{
			return _slot;
		}

		public function set slot(value:int):void
		{
			_slot = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function urlBitmapDataError(url:String, info:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			// TODO Auto Generated method stub
			if(_bar)
			{
				_bar.bitmapData=bitmapData;
			}
		}
		
		public function swfError(url:String, info:Object):void
		{
			// TODO Auto Generated method stub
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			btn.addChild(swf);
			btn.x=43;
			addChild(btn);
			
			addChild(_btnLabel);
			_btnLabel.x=btn.x+3;
			_btnLabel.y=btn.y+2;
			// TODO Auto Generated method stub			
		}

		public function getTipData():Object
		{
			// TODO Auto Generated method stub
			var heroUpgrade:HeroEquipActivateData =HeroDataManager.instance.heroActivateData;
			return ConfigDataManager.instance.heroEquipUpgradeCfgData(heroUpgrade.grade,heroUpgrade.order);
		}
		
		public function getTipType():int
		{
			// TODO Auto Generated method stub
			return ToolTipConst.EQUIP_UPGRADE_TIP;
		}
		
	}
}