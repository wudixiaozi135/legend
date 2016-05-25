package com.view.gameWindow.panel.panels.specialRing.upgrade
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.configData.cfgdata.SpecialRingLevelCfgData;
	import com.model.consts.EffectConst;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingData;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	import com.view.gameWindow.util.UtilGetStrLv;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * 特戒升级页显示处理类
	 * @author Administrator
	 */	
	internal class TabSpecialRingUpViewHandle
	{
		private const totalRings:int = 8;
		private const totalStars:int = 10;
		private const totalCells:int = 3;
		private const GuideRing:int = 1;
		private var _tab:TabSpecialRingUpgrade;
		private var _skin:McSpecialRingUpgrade;
		/**目标相关技能框*/
		private var _cellsT:Vector.<RingSkillCell>;
		private var _cellsU:Vector.<RingSkillCell>;
		private var _cellMastery:RingSkillCell;
		private var _uiEffectLoader:UIEffectLoader;
		private var _uiEffLoaderVec:Vector.<UIEffectLoader>;
		private var arrow:TipArrow;
		
		public function TabSpecialRingUpViewHandle(tab:TabSpecialRingUpgrade)
		{
			_tab = tab;
			_skin = _tab.skin as McSpecialRingUpgrade;
			init();
		}
		
		private function init():void
		{
			var htmlStr:String = HtmlUtils.createHtmlStr(0xe616b6,StringConst.SPECIAL_RING_PANEL_0005);
			_skin.mcTarget.txtTarget0.htmlText = StringConst.SPECIAL_RING_PANEL_0004.replace("&x",htmlStr);
			_skin.mcTarget.txtTarget1.text = StringConst.SPECIAL_RING_PANEL_0006;
			_skin.mcTarget.txtTarget3.text = StringConst.SPECIAL_RING_PANEL_0007;
			_skin.mcTarget.txtNoRing.text = StringConst.SPECIAL_RING_PANEL_0008;
			_skin.txtGold.text = StringConst.SPECIAL_RING_PANEL_0009;
			htmlStr = HtmlUtils.createHtmlStr(0x53b436,StringConst.SPECIAL_RING_PANEL_0010,12,false,2,"SimSun",true,"getCoinLine");
			_skin.txtGoldGet.htmlText = htmlStr;
			_skin.txtChip.text = StringConst.SPECIAL_RING_PANEL_0011;
			htmlStr = HtmlUtils.createHtmlStr(0x53b436,StringConst.SPECIAL_RING_PANEL_0012,12,false,2,"SimSun",true,"getShardLine");
			_skin.txtChipGet.htmlText = htmlStr;
			var defaultTextFormat:TextFormat = _skin.txtLv.defaultTextFormat;
			defaultTextFormat.bold = true;
			_skin.txtLv.defaultTextFormat = defaultTextFormat;
			_skin.txtLv.setTextFormat(defaultTextFormat);
			_skin.mcMastery.txtKey.text = StringConst.SPECIAL_RING_PANEL_0042;
			_skin.mcMastery.visible = false;
			//
			var i:int,bg:MovieClip,cell:RingSkillCell;
			_cellsT = new Vector.<RingSkillCell>(totalCells,true);
			for(i=0;i<totalCells;i++)
			{
				bg = _skin.mcTarget["mcKey"+i] as MovieClip;
				cell = new RingSkillCell(bg);
				ToolTipManager.getInstance().attach(cell);
				_cellsT[i] = cell;
			}
			_cellsU = new Vector.<RingSkillCell>(totalCells,true);
			for(i=0;i<totalCells;i++)
			{
				bg = _skin.mcUpgrade["mcKey"+i] as MovieClip;
				cell = new RingSkillCell(bg);
				ToolTipManager.getInstance().attach(cell);
				_cellsU[i] = cell;
			}
			_uiEffLoaderVec = new Vector.<UIEffectLoader>(totalStars,true);
			arrow = new TipArrow();
			bg = _skin.mcMastery.mcKey;
			_cellMastery = new RingSkillCell(bg);
			ToolTipManager.getInstance().attach(_cellMastery);
			//
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var desc:String = manager.getDataById(manager.select).specialRingCfgData.desc;
			var pareseDes:Array = CfgDataParse.pareseDes(desc),htmlText:String = "";
			var l:int = pareseDes.length;
			for(i=0;i<l;i++)
			{
				htmlText += pareseDes[i];
			}
			_skin.txtDesc.htmlText = htmlText;
			_skin.txtDesc.visible = false;	
			
			_skin.txtBtnUse.mouseEnabled = false;
			_skin.txtBtnUse.visible = false;
			//
			var j:int;
			for (j=0;j<totalRings;j++) 
			{
				var iconUse:MovieClip = _skin["iconUse"+(i+1)];
				iconUse.mouseEnabled = false;
				iconUse.visible = false;
			}
			
		}
		
		internal function refreshRingBtns(mc:MovieClip = null):void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var i:int;
			for(i=0;i<totalRings;i++)
			{
				var mcRing:MovieClip = _skin["mcRing"+(i+1)];
				if(!mc || (mc && mcRing == mc))
				{
					var ringId:int = manager.ringIdBy(i+1);
					var isActive:Boolean = manager.datas[ringId].isActive;
					if(!isActive)
					{
						mcRing.filters = UtilColorMatrixFilters.GREY_FILTERS;
					}
					else
					{
						mcRing.filters = null;
					}
					if(mc)
					{
						break;
					}
				}
			}
		}
		
		internal function addStarTip(btnMc:MovieClip):void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var j:int,index:int;
			var mcStarsBtns:McSpecialRingStarsBtns = _skin.mcUpgrade.mcStarsBtns;
			for(j=0;j<totalStars;j++)
			{
				if(mcStarsBtns["btn"+(j+1)] == btnMc)
				{
					index = j+1;
					break;
				}
			}
			if(!index)
			{
				return;
			}
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = getTipData;
			tipVO.tipDataValue = index;
			ToolTipManager.getInstance().hashTipInfo(btnMc,tipVO);
			ToolTipManager.getInstance().attach(btnMc);
		}
		
		private function getTipData(index:int):String
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var data:SpecialRingData = manager.getDataById(manager.select);
			var level:int;
			level = int(data.level/totalStars)*totalStars+index;
			var lvCfgDt:SpecialRingLevelCfgData = data.getSpecialRingLevelCfgData(level);
			if(!lvCfgDt)//若取到的数据为空，在保证数据连续的情况下，表示已升级到最大等级，取前一页的数据
			{
				level -= totalStars
				lvCfgDt = data.getSpecialRingLevelCfgData(level);
			}
			var str:String = "";
			if(lvCfgDt)
			{
				//特戒等级
				str += HtmlUtils.createHtmlStr(0xd4a460,StringConst.SPECIAL_RING_PANEL_0032);
				str += HtmlUtils.createHtmlStr(0x00ff00,level + StringConst.MONSTER_HP_0001) + "\n\n";
				//增加属性
				str += HtmlUtils.createHtmlStr(0xd4a460,StringConst.SPECIAL_RING_PANEL_0033) + "\n";
				str += data.getLevelAttr(level) + "\n\n";
				//特级增强
				str += lvCfgDt.desc ? HtmlUtils.createHtmlStr(0xd4a460,StringConst.SPECIAL_RING_PANEL_0034) + "\n" : "";
				str += lvCfgDt.desc ? CfgDataParse.pareseDesToStr(lvCfgDt.desc,0x00ff00) + "\n\n": "";
				var dt:SpecialRingData = manager.getDataById(manager.select);
				var mcStarsBtns:McSpecialRingStarsBtns = _skin.mcUpgrade.mcStarsBtns;
				var btnMc:MovieClip = mcStarsBtns["btn"+index] as MovieClip;
				if(btnMc.currentFrame != 2 && btnMc.currentFrame != 5)
				{
					//升级消耗
					str += HtmlUtils.createHtmlStr(0xd4a460,StringConst.SPECIAL_RING_PANEL_0035) + "\n";
					//材料
					if(lvCfgDt.item_id)
					{
						var itemCfgDt:ItemCfgData = ConfigDataManager.instance.itemCfgData(lvCfgDt.item_id);
						str += HtmlUtils.createHtmlStr(0xd4a460,itemCfgDt.name + "：");
						var isItemEnough:Boolean = manager.isItemEnough(lvCfgDt);
						str += HtmlUtils.createHtmlStr(isItemEnough ? 0x00ff00 : 0xff0000,lvCfgDt.item_count+"")+"\n";
					}
					//金币
					if(lvCfgDt.coin_cost)
					{
						str += HtmlUtils.createHtmlStr(0xd4a460,StringConst.SPECIAL_RING_PANEL_0009);
						var isCoinEnough:Boolean = manager.isCoinEnough(lvCfgDt);
						str += HtmlUtils.createHtmlStr(isCoinEnough ? 0x00ff00 : 0xff0000,lvCfgDt.coin_cost+"")+"\n";
					}
					//需求等级
					str += HtmlUtils.createHtmlStr(0xd4a460,StringConst.SPECIAL_RING_PANEL_0040);
					var strReincarnLevel:String = UtilGetStrLv.strReincarnLevel(lvCfgDt.reincarn,lvCfgDt.player_level);
					var isLvEnough:Boolean = manager.isLvEnough(lvCfgDt);
					str += HtmlUtils.createHtmlStr(isLvEnough ? 0x00ff00 : 0xff0000,strReincarnLevel);
				}
			}
			return str;
		}
		
		internal function refreshGoldChip():void
		{
			var manager:BagDataManager = BagDataManager.instance;
			var totalCoin:int = manager.coinBind + manager.coinUnBind;
			_skin.txtGoldValue.text = totalCoin+"";
			var num:int = manager.getItemNumByType(ItemType.SPECIAL_RING_PIECES);
			_skin.txtChipValue.text = num+"";
		}
		/**
		 * @param bool 是否全部运行，因为控制元件原因，有时候只用运行某一部分
		 */		
		internal function refreshChangeRing(bool:Boolean=true):void
		{
			ToolTipManager.getInstance().removeTip(ToolTipConst.TEXT_TIP);
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var data:SpecialRingData = manager.getDataById(manager.select);
			//
			if(data.specialRingCfgData.need_use == 1 && data.isActive)
			{
				_skin.btnUse.visible = true;
				_skin.txtBtnUse.visible = true;
				if(data.in_use != 1)
				{
					_skin.txtBtnUse.htmlText=HtmlUtils.createHtmlStr(0xffe1aa,StringConst.SPECIAL_RING_PANEL_0037);
				}
				else
				{
					_skin.txtBtnUse.htmlText=HtmlUtils.createHtmlStr(0xffe1aa,StringConst.SPECIAL_RING_PANEL_0038);
				}
			}
			else
			{
				_skin.btnUse.visible = false;
				_skin.txtBtnUse.visible = false;
			}
			//
			if(!bool)
			{
				return;
			}
			//刷新名称
			_skin.mcName.gotoAndStop(manager.select);
			//刷新选中效果
			var mc:MovieClip = _skin["mcRing"+data.ringIndex] as MovieClip;
			_skin.mcSelect.x = mc.x + (mc.width - _skin.mcSelect.width)/2;
			_skin.mcSelect.y = mc.y + (mc.height - _skin.mcSelect.height)/2;
			//刷新使用中效果
			var dt:SpecialRingData;
			for each (dt in manager.datas)
			{
				var iconUse:MovieClip = _skin["iconUse"+dt.ringIndex] as MovieClip;
				iconUse.visible = dt.in_use == 1;
			}
			if(data.specialRingCfgData.is_ring_only_condition)
			{
				updateMastery();
			}
			else
			{
				_skin.txtLv.text = data.level+StringConst.MONSTER_HP_0001;
				//刷新特戒预览效果
				refreshRings();
				//刷新条件文本
				refreshTargetText();
				//刷新技能框
				refreshSkillCell();
				//刷新属性文本
				var totalAttr:Array = data.totalAttr;
				_skin.txtAttr1.mouseEnabled = _skin.txtAttr2.mouseEnabled = false;
				_skin.txtAttr1.htmlText = totalAttr[0];
				_skin.txtAttr2.htmlText	= totalAttr[1];
				//刷新星座等级
				refreshEffect();
				addTipArrow();
				refreshStars();
				//
				if(data.isActive)
				{
					_skin.mcUpgrade.visible = true;
					_skin.mcTarget.visible = false;
				}
				else
				{
					_skin.mcUpgrade.visible = false;
					_skin.mcTarget.visible = true;
				}
				_skin.mcMastery.visible = false;
			}
		}
		
		private function updateMastery():void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var data:SpecialRingData = manager.getDataById(manager.select);
			//刷新技能框
			_cellMastery.refreshData(data.skillCfgDatas && data.skillCfgDatas[0] ? data.skillCfgDatas[0] : null);
			//刷新特戒预览效果
			destroyLoader();
			//刷新属性文本
			_skin.txtAttr1.mouseEnabled =_skin.txtAttr2.mouseEnabled=false;
			_skin.txtAttr1.htmlText = "";
			_skin.txtAttr2.htmlText	= "";
			//
			var strOnlyRequests:String = data.specialRingCfgData.only_request;
			var onlyRequests:Array = strOnlyRequests.split("|");
			var i:int,l:int = onlyRequests.length;
			var isSatisfy:Boolean = true;
			var str:String = "";
			for(i=0;i<l;i++)
			{
				var strOnlyRequest:String = onlyRequests[i] as String;
				var onlyRequest:Array = strOnlyRequest.split(":");
				var dtI:SpecialRingData = manager.getDataById(onlyRequest[0]);
				var name:String = dtI.specialRingCfgData.name;
				var lvNeed:int = onlyRequest[1];
				var boolean:Boolean = dtI.level >= lvNeed;
				str += name + HtmlUtils.createHtmlStr(boolean ? 0x00ff00 : 0xff0000,"("+dtI.level + "/" + lvNeed+")",12,false,12) + (i < l-1 ? "\n" : "");
				isSatisfy &&= boolean;
			}
			_skin.mcMastery.txtRingNeed.htmlText = str;
			//
			_skin.mcMastery.mcOpen.visible = isSatisfy;
			_skin.mcMastery.mcUnOpen.visible = !isSatisfy;
			//
			_skin.mcMastery.visible = true;
			_skin.mcTarget.visible = false;
			_skin.mcUpgrade.visible = false;
		}
		
		internal function refreshTargetText():void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var data:SpecialRingData = manager.getDataById(manager.select);
			_skin.mcTarget.txtTarget2.htmlText = data.target1;
			
			_skin.mcTarget.txtTarget4.htmlText = data.target2;
			_skin.mcTarget.txtTarget3.visible=_skin.mcTarget.txtTarget4.text!="";
		}
		
		private function refreshRings():void
		{
			destroyLoader();
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var cX:int = _skin.mcRingLayer.width/2;
			var cY:int = _skin.mcRingLayer.height/2;
			var url:String = EffectConst.RES_SPECIAL_RING.replace("&x",manager.select);
			_uiEffectLoader = new UIEffectLoader(_skin.mcRingLayer,cX,cY,1,1,url);
		}
		
		internal function refreshStars():void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var data:SpecialRingData = manager.getDataById(manager.select);
			var i:int;
			var mcStarsBtns:McSpecialRingStarsBtns = _skin.mcUpgrade.mcStarsBtns;
			for(i=0;i<totalStars;i++)
			{
				var btnMc:MovieClip = mcStarsBtns["btn"+(i+1)] as MovieClip;
				updateBtn(btnMc,i);
				updateLocation(btnMc,i);
			}
			drawLine();
		}
		
		
		/**刷新按钮帧数*/
		internal function updateBtn(btn:MovieClip,index:int):void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var data:SpecialRingData = manager.getDataById(manager.select);
			var number:Number = data.level % totalStars;
			number = (number == 0 && !data.specialRingLevelCfgDataNext) ? totalStars : number;
			var level:int = int(data.level / totalStars) * totalStars + index + 1;
			var lvCfgDt:SpecialRingLevelCfgData = data.getSpecialRingLevelCfgData(level);
			if(lvCfgDt == null)
			{
				level -= totalStars;
				lvCfgDt = data.getSpecialRingLevelCfgData(level);
			}
			if(!lvCfgDt)
			{
				return;
			}
			var t:int = lvCfgDt.type;
			if(index < number)//已学
			{
				if(t==1)
				{
					btn.gotoAndStop(2);
				}
				else
				{
					btn.gotoAndStop(5);
				}
			}
			else if(data.specialRingLevelCfgDataNext && index == number)//可学
			{
				if(t==1)
				{
					btn.gotoAndStop(1);
				}
				else
				{
					btn.gotoAndStop(4);
				}
			}
			else//未学
			{
				if(t==1)
				{
					btn.gotoAndStop(3);
				}
				else
				{
					btn.gotoAndStop(6);
				}
			}
		}
		
		internal function updateLocation(btn:MovieClip,index:int):void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var starLactions:Vector.<Vector.<Point>> = TabSpecialConst.starLactions;
			if(manager.select - 1 >= starLactions.length)
			{
				return;
			}
			if(index >= starLactions[manager.select - 1].length)
			{
				return;
			}
			var point:Point = starLactions[manager.select - 1][index];
			btn.x = point.x;
			btn.y = point.y;
		}
		
		private function drawLine(nextPage:Boolean = false):void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var dt:SpecialRingData = manager.getDataById(manager.select);
			var number:Number = dt.level % totalStars;
			var isUpgrade:Boolean = manager.has_upgrade;
			number = (number == 0 && !nextPage && isUpgrade) ? totalStars : number;
			if(dt.specialRingLevelCfgDataNext==null)
			{
				number=totalStars;
			}
			var bg:MovieClip = _skin.mcUpgrade.mcStarsLine;
			bg.graphics.clear();
			
//			if(dt.level == 0)
//			{
//				return;
//			}
			bg.graphics.lineStyle(2,0x56c6c6);
			var i:int,num:int;
			var vector:Vector.<Point> = TabSpecialConst.starLactions[manager.select - 1];
			for(i=0;i<totalStars-1;i++)
			{
				num = number-1;
				if(isUpgrade){
					num = number-2;
				}
				if(i<num)
				{
					bg.graphics.lineStyle(2,0x56c6c6);
				}else
				{
					bg.graphics.lineStyle(2,0x666666);
				}
				var point:Point = vector[i];
				bg.graphics.moveTo(point.x,point.y);
				var point1:Point = vector[i+1];
				bg.graphics.lineTo(point1.x,point1.y);
			}
			
//			for(i=0;i<number-1;i++)
//			{
//				var point:Point = vector[i];
//				bg.graphics.moveTo(point.x,point.y);
//				var point1:Point = vector[i+1];
//				bg.graphics.lineTo(point1.x,point1.y);
//			}
			bg.graphics.endFill();
			if(isUpgrade)
			{
				drawEffect(number-1);
			}
		}
		
		private var pointArr:Array= new Array();
		private var oldPoint:Point;
		private function drawEffect(index:int):void
		{
			if(index <= 0)
				return;
			var bg:MovieClip = _skin.mcUpgrade.mcStarsLine;
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var vector:Vector.<Point> = TabSpecialConst.starLactions[manager.select - 1];
			var point:Point = vector[index-1];
			var point1:Point = vector[index];
			var count:int= 10;
			pointArr.length = 0;
			for(var i:int = 0;i<count-1;i++)
			{
				var x:Number = (point1.x-point.x)*(i+1)/count+point.x;
				var y:Number = (point1.y-point.y)*(i+1)/count+point.y;
				pointArr.push(new Point(x,y));
			}
			pointArr.push(point1);
			bg.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			oldPoint= vector[index-1];
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if(!_skin || !_skin.mcUpgrade || _skin.mcUpgrade.mcStarsLine)
			{
				return;
			}
			var bg:MovieClip = _skin.mcUpgrade.mcStarsLine;
			if(pointArr.length<=1)
			{
				bg.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				SpecialRingDataManager.instance.has_upgrade = false;
				var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
				var dt:SpecialRingData = manager.getDataById(manager.select);
				var number:Number = dt.level % totalStars;
				number = (number == 0 ) ? totalStars : number;
				if(number == 10 && dt.specialRingLevelCfgDataNext)
					drawLine(true);
				return;
			}
			var point:Point = pointArr.shift();
			bg.graphics.lineStyle(2,0x56c6c6);
			bg.graphics.moveTo(oldPoint.x,oldPoint.y);
			bg.graphics.lineTo(point.x,point.y);
			bg.graphics.endFill();
			oldPoint = point;
		}
		
		internal function refreshEffect():void
		{
			destroyEffLoader();
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var data:SpecialRingData = manager.getDataById(manager.select);
			var mcStarsBtns:McSpecialRingStarsBtns = _skin.mcUpgrade.mcStarsBtns;
			var px:int, py:int;
			var number:Number = data.level % totalStars;
			var url:String = EffectConst.RES_SPECIAL_RINGEFF;
			number = (number == 0 && !data.specialRingLevelCfgDataNext) ? totalStars : number;
			var starLactions:Vector.<Vector.<Point>> = TabSpecialConst.starLactions;
			for(var i:int = 0;i<totalStars;i++){
				var level:int = int(data.level / totalStars) * totalStars + i + 1;
				var lvCfgDt:SpecialRingLevelCfgData = data.getSpecialRingLevelCfgData(level);
				if(lvCfgDt == null)
				{
					level -= totalStars;
					lvCfgDt = data.getSpecialRingLevelCfgData(level);
				}
				if(!lvCfgDt)
				{
					return;
				}
				if(i < number)//已学
				{
					px = starLactions[manager.select-1][i].x;
					py = starLactions[manager.select-1][i].y;
					_uiEffLoaderVec[i] = new UIEffectLoader(_skin.mcUpgrade.mcStarsBtns,px,py,1,1,url);
				}
			}
			
			
		}
		
		private function addTipArrow():void
		{
			arrow.visible = false;
			if(arrow.parent)
				arrow.parent.removeChild(arrow);
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var data:SpecialRingData = manager.getDataById(manager.select);
			var mcStarsBtns:McSpecialRingStarsBtns = _skin.mcUpgrade.mcStarsBtns;
			var number:Number = data.level % totalStars;
			var url:String = EffectConst.RES_SPECIAL_RINGEFF;
			var starLactions:Vector.<Vector.<Point>> = TabSpecialConst.starLactions;
			number = (number == 0 && !data.specialRingLevelCfgDataNext) ? totalStars : number;
			if(manager.select == GuideRing){
				if(number<5)
					return;
			}
			if(number == 10)
				return;
			_skin.mcUpgrade.mcStarsBtns.addChild(arrow);
			arrow.x = starLactions[manager.select-1][number].x;
			arrow.y = starLactions[manager.select-1][number].y+30 + 3;
			arrow.visible = true;
		}
		
		private function refreshSkillCell():void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var data:SpecialRingData = manager.getDataById(manager.select);
			var cfgDts:Vector.<SkillCfgData> = data.skillCfgDatas;
			var i:int;
			for(i=0;i<totalCells;i++)
			{
				var cell:RingSkillCell = _cellsT[i];
				if(i < cfgDts.length)
				{
					cell.refreshData(cfgDts[i]);
				}
				else
				{
					cell.refreshData(null);
				}
			}
			for(i=0;i<totalCells;i++)
			{
				cell = _cellsU[i];
				var textField:TextField = _skin.mcUpgrade["txtKey"+i] as TextField;
				if(i < cfgDts.length)
				{
					cell.refreshData(cfgDts[i]);
					
					var skillCfgData:SkillCfgData = cfgDts[i];
					if(data.level >= skillCfgData.ring_level)
					{
						textField.text = skillCfgData.name+"\n"+StringConst.SPECIAL_RING_PANEL_0013;
						textField.textColor = 0xffe1aa;
						var beginIndex:int = skillCfgData.name.length;
						var textFormat:TextFormat = textField.getTextFormat(beginIndex);
						textFormat.color = 0x53b436;
						textField.setTextFormat(textFormat,beginIndex,textField.text.length);
					}
					else
					{
						textField.text = skillCfgData.name+"\n"+StringConst.SPECIAL_RING_PANEL_0014;
						textField.textColor = 0x6a6a6a;
					}
				}
				else
				{
					cell.refreshData(null);
					textField.text = "";
				}
			}
		}
		
		private function destroyLoader():void
		{
			if(_uiEffectLoader)
			{
				_uiEffectLoader.destroy();
			}
		}
		
		private function destroyEffLoader():void
		{
			for(var i:int = 0;i<totalStars;i++)
			{
				if(_uiEffLoaderVec[i]!=null){
					_uiEffLoaderVec[i].destroy();
					_uiEffLoaderVec[i] = null;
				}
			}
		}
		
		internal function destroy():void
		{
			var j:int;
			for(j=0;j<totalStars;j++)
			{
				var btnMc:MovieClip = _skin.mcUpgrade.mcStarsBtns["btn"+(j+1)] as MovieClip;
				ToolTipManager.getInstance().detach(btnMc);
			}
			ToolTipManager.getInstance().detach(_cellMastery);
			var cell:RingSkillCell;
			for each(cell in _cellsT)
			{
				ToolTipManager.getInstance().detach(cell);
				cell.destroy();
			}
			_cellsT = null;
			for each(cell in _cellsU)
			{
				ToolTipManager.getInstance().detach(cell);
				cell.destroy();
			}
			if(arrow)
			{
				arrow.parent&&arrow.parent.removeChild(arrow);
			}
			_cellsU = null;
			destroyLoader();
			_skin = null;
			_tab = null;
		}
	}
}