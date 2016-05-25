package com.view.gameWindow.panel.panels.dungeon.rewardCard
{
	import com.greensock.TweenMax;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DgnRewardCardGroupCfgData;
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.panels.dungeon.DgnGoalsDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	public class PanelDgnRewardCardViewHandle
	{
		private const NUM_CELLS:int = 6;
		private var _panel:PanelDgnRewardCard;
		private var _skin:McDgnRewardCard;
		
		private var _cells:Vector.<IconCellEx>;
		private var _texts:Vector.<String>;
		private var _textId2Index:Dictionary
		
		private var _centerX:Number;
		private var _cardWHalf:Number;
		private var _mcBgs:Array;
		private var _mcs:Array;
		/**是否在洗牌中*/
		internal var isShuffle:Boolean;

		public function PanelDgnRewardCardViewHandle(panel:PanelDgnRewardCard)
		{
			_panel = panel;
			_skin = _panel.skin as McDgnRewardCard;
			initialize();
		}
		
		private function initialize():void
		{
			_centerX = (_skin.mcCard0.x + _skin.mcCard5.x)*.5;
			_cardWHalf = _skin.mcCard0.width*.5;
			_mcBgs = [_skin.mcCardBg0,_skin.mcCardBg1,_skin.mcCardBg2,_skin.mcCardBg3,_skin.mcCardBg4,_skin.mcCardBg5];
			_mcs = [_skin.mcCard0,_skin.mcCard1,_skin.mcCard2,_skin.mcCard3,_skin.mcCard4,_skin.mcCard5];
			//
			_skin.txtBtnStart.text = StringConst.DUNGEON_REWARD_CARD_0004/*" "*/;
			_skin.txtBtnStart.mouseEnabled = false;
			_skin.txtCount.text = StringConst.DUNGEON_REWARD_CARD_0006;
			initTxtVip();
			initCells();
			_texts = new Vector.<String>(NUM_CELLS,true);
			_textId2Index = new Dictionary();
		}
		
		private function initTxtVip():void
		{
			var txtVip:TextField = _skin.txtVip;
			txtVip.htmlText = HtmlUtils.createHtmlStr(0x53b436,StringConst.DUNGEON_REWARD_CARD_0007,12,false,2,"SimSun",true);
			ToolTipManager.getInstance().attachByTipVO(txtVip,ToolTipConst.TEXT_TIP,getTxtVipData);
		}
		
		private function getTxtVipData():String
		{
			var manager:VipDataManager = VipDataManager.instance;
			var str:String = StringConst.STRENGTH_PANEL_0037 + HtmlUtils.createHtmlStr(0xffcc00,manager.lv+"",12,false,4) + "\n\n";
			str += StringConst.STRENGTH_PANEL_0038 + "\n";
			var i:int,l:int = VipDataManager.MAX_LV;
			for (i=0;i<l;i++) 
			{
				var lv:int = i+1;
				var vipCfgDt:VipCfgData = manager.vipCfgDataByLv(lv);
				var color:int = lv == manager.lv ? 0x00ff00 : 0xb4b4b4;
				str += HtmlUtils.createHtmlStr(color,lv+StringConst.DUNGEON_REWARD_CARD_0008.replace("&x",vipCfgDt.dungeon_card_num),12,false,4) + "\n";
			}
			return HtmlUtils.createHtmlStr(0xd4a460,str,12,false,4);
		}
		
		private function initCells():void
		{
			_cells = new Vector.<IconCellEx>(NUM_CELLS,true);
			var i:int;
			for(i=0;i<NUM_CELLS;i++)
			{
				var layer:MovieClip = _skin["mcCard"+i].mcLayer as MovieClip;
				var cell:IconCellEx = new IconCellEx(layer.parent,layer.x,layer.y,layer.width,layer.height);
				_cells[i] = cell;
				//
				var mcBg:MovieClip = _skin["mcCardBg"+i] as MovieClip;
				mcBg.postion = i;
				mcBg.visible = false;
			}
		}
		
		public function update(proc:int):void
		{
			if(proc == GameServiceConstants.SM_FINISH_DUNGEON)
			{
				dealFinish();
			}
			else if(proc == GameServiceConstants.CM_DUNGEON_CARD_DRAW)
			{
				dealCardDraw();
			}
			updateTxt();
		}
		
		private function dealFinish():void
		{
			var dt:DataDgnRewardCard = DgnGoalsDataManager.instance.dtDgnRewardCard;
			var cell:IconCellEx;
			var cfgDt:DgnRewardCardGroupCfgData;
			var textField:TextField;
			var cfgDts:Vector.<DgnRewardCardGroupCfgData> = ConfigDataManager.instance.dgnRewardCardGroupCfgDatas(dt.rewardGroupId);
			var i:int;
			for(i=0;i<NUM_CELLS;i++)
			{
				cfgDt = cfgDts[i];
				cell = _cells[i];
				var thingsData:ThingsData = new ThingsData();
				thingsData.id = cfgDt.item_id;
				thingsData.type = cfgDt.type;
				thingsData.count = cfgDt.count;
				IconCellEx.setItemByThingsData(cell,thingsData);
				ToolTipManager.getInstance().attach(cell);
				//
				textField = _skin["mcCard"+i].txt as TextField;
				textField.text = StringConst.DUNGEON_REWARD_CARD_0003 + cfgDt.count;
				textField.cacheAsBitmap = true;
				//
				if(thingsData.cfgData)
				{
					var text:String = thingsData.cfgData.name + "x" + thingsData.count;
					var quality:int = cfgDt.itemCfgData ? cfgDt.itemCfgData.quality : (cfgDt.equipCfgData ? cfgDt.equipCfgData.color : 1);
					var color:int = ItemType.getColorByQuality(quality);
					_texts[i] = HtmlUtils.createHtmlStr(color,text);
				}
				else
				{
					_texts[i] = null;
				}
				_textId2Index[cfgDt.id] = i;
			}
		}
		
		private function dealCardDraw():void
		{
			var dt:DataDgnRewardCard = DgnGoalsDataManager.instance.dtDgnRewardCard;
			dt.count++;
			var postion:int = dt.postion;
			var cell:IconCellEx = _cells[postion];
			var id:int = dt.ids[postion];
			var cfgDt:DgnRewardCardGroupCfgData = ConfigDataManager.instance.dgnRewardCardGroupCfgData(dt.rewardGroupId,id);
			var thingsData:ThingsData = new ThingsData();
			thingsData.id = cfgDt.item_id;
			thingsData.type = cfgDt.type;
			thingsData.count = cfgDt.count;
			IconCellEx.setItemByThingsData(cell,thingsData);
			var textField:TextField = _skin["mcCard"+postion].txt as TextField;
			textField.text = StringConst.DUNGEON_REWARD_CARD_0003 + cfgDt.count;
			_texts[_textId2Index[id]] = null;
			//
			var mcBg:MovieClip = _skin["mcCardBg"+postion] as MovieClip;
			mcBg.buttonMode = false;
			var mc:MovieClip = _skin["mcCard"+postion] as MovieClip;
			TweenMax.to(mcBg,.5,{x:_cardWHalf+'',scaleX:0,onComplete:function():void
			{
				mcBg.x -= _cardWHalf;
				mcBg.scaleX = 1;
				mcBg.visible = false;
				mc.x += _cardWHalf;
				mc.scaleX = 0;
				mc.visible = true;
				TweenMax.to(mc,.5,{x:-_cardWHalf+'',scaleX:1,onComplete:function():void
				{
					var bitmap:Bitmap = cell.bmp;
					bitmap.name = cell.id;
					FlyEffectMediator.instance.doFlyReceiveThing(bitmap,1);
				}});
			}});
		}
		
		private function updateTxt():void
		{
			var str:String = "";
			var i:int;
			for(i=0;i<NUM_CELLS;i++)
			{
				var text:String = _texts[i];
				if(text)
				{
					str += text + ((i != NUM_CELLS-1) ? StringConst.SEMICOLON : "");
				}
			}
			_skin.txtRewards.htmlText = str != "" ? StringConst.DUNGEON_REWARD_CARD_0001 + str : StringConst.DUNGEON_REWARD_CARD_0002;
			//
			var dt:DataDgnRewardCard = DgnGoalsDataManager.instance.dtDgnRewardCard;
			/*_skin.txtBtnStart.htmlText = _skin.txtBtnStart.text == " " ? StringConst.DUNGEON_REWARD_CARD_0004 : dt.goldText;*/
			_skin.txtCountValue.text = dt.countText;
		}
		/**执行洗牌动画*/
		internal function shuffle():void
		{
			isShuffle = true;
			_skin.btnStart.visible = false;
			_skin.txtBtnStart.text = "";
			//
			TweenMax.allTo(_mcs,.5,{x:_cardWHalf+'',scaleX:0},0,function():void
			{
				var i:int;
				for(i=0;i<NUM_CELLS;i++)
				{
					var mc:MovieClip = _skin["mcCard"+i] as MovieClip;
					mc.x -= _cardWHalf;
					mc.scaleX = 1;
					mc.visible = false;
					var mcBg:MovieClip = _skin["mcCardBg"+i] as MovieClip;
					mcBg.x += _cardWHalf;
					mcBg.scaleX = 0;
					mcBg.visible = true;
				}
				TweenMax.allTo(_mcBgs,.5,{x:-_cardWHalf+'',scaleX:1});
			});
			TweenMax.allTo(_mcBgs,.5,{x:_centerX,delay:1.02,repeat:1,yoyo:true},0,function():void
			{
				var i:int;
				for(i=0;i<NUM_CELLS;i++)
				{
					var mcBg:MovieClip = _skin["mcCardBg"+i] as MovieClip;
					mcBg.buttonMode = true;
				}
				isShuffle = false;
			});
		}
		
		public function destroy():void
		{
			ToolTipManager.getInstance().detach(_skin.txtVip);
			var i:int;
			for(i=0;i<NUM_CELLS;i++)
			{
				TweenMax.killTweensOf(_skin["mcCard"+i],true);
				TweenMax.killTweensOf(_skin["mcCardBg"+i],true);
			}
			var cell:IconCellEx;
			for each(cell in _cells)
			{
				ToolTipManager.getInstance().detach(cell);
				cell.destroy();
			}
			_cells = null;
			_skin = null;
			_panel = null;
		}
	}
}