package com.view.gameWindow.panel.panels.convert
{
	import com.greensock.TweenLite;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.common.LinkButton;
	import com.view.gameWindow.common.ModelAnimBoard;
	import com.view.gameWindow.common.MouseOverEffectManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.buyitemconfirm.PanelBuyItemConfirmData;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.NumPic;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.propertyParse.PropertyData;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;

	/**
	 * @author wqhk
	 * 2014-8-26
	 * 
	 * 兑换界面
	 */
	public class ConvertStartPanel extends PanelBase 
	{
		public static const NUM_CELL:int = 3;
		public static const ITEM_PREFIX:String = "item";
		private var _mc:McConvertStartPanel;
		private var _iconList:Vector.<IconCellEx>;
		private var _dataManager:ConvertDataManager;
		private var _overEffectManager:MouseOverEffectManager;
		private var _getWayButton0:LinkButton;
		private var _getWayButton1:LinkButton;
		private var _grayFilter:ColorMatrixFilter;
		private var _numPic:NumPic;
		private var _animBoard:ModelAnimBoard;
		private var _iconAnim:TweenLite;
		private var _effectLoader:UIEffectLoader;
		
		public function ConvertStartPanel()
		{
			super();
			
			_dataManager = ConvertDataManager.instance;
			
			_getWayButton0 = new LinkButton();
			_getWayButton0.label = HtmlUtils.createHtmlStr(0x53b436,StringConst.CONVERT_005,12,false,2,FontFamily.FONT_NAME,true);
			
			_getWayButton1 = new LinkButton();
			_getWayButton1.label = HtmlUtils.createHtmlStr(0x53b436,StringConst.CONVERT_006,12,false,2,FontFamily.FONT_NAME,true);
			
			_grayFilter = new ColorMatrixFilter();
			_grayFilter.matrix = [0.3,0.3,0.3,0,0,
									0.3,0.3,0.3,0,0,
									0.3,0.3,0.3,0,0,
									0,0,0,1,0];
			
			_numPic = new NumPic();
		}
		
		override public function destroy():void
		{
			_dataManager.detach(this);
			
			removeEventListener(MouseEvent.CLICK,clickHandler);
			
			if(_getWayButton0)
			{
				_getWayButton0.destroy();
				if(_getWayButton0.parent)
				{
					_getWayButton0.parent.removeChild(_getWayButton0);
				}
				_getWayButton0 = null;
			}
			
			if(_getWayButton1)
			{
				_getWayButton1.destroy();
				
				if(_getWayButton1.parent)
				{
					_getWayButton1.parent.removeChild(_getWayButton1);
				}
				
				_getWayButton1 = null;
			}
			
			if(_animBoard)
			{
				_animBoard.destroy();
			}
			
			clearCell();
			
			clearCenterIcon();
			
			super.destroy();
		}
		
		override public function update(proc:int=0):void
		{
			updateBaseInfo();
		}

		private function clearNum():void
		{
			while(_mc.numPos.numChildren)
			{
				_mc.numPos.removeChildAt(0);
			}
		}
		
		public function setItemDetail(item:ConvertStartData):void
		{
			clearCenterIcon();
			
			if(!item || !item.id)
			{
				_mc.desTxt.htmlText = "";
				_mc.propertyTxt0.htmlText = "";
				
				if(_getWayButton0.parent)
				{
					_getWayButton0.parent.removeChild(_getWayButton0);
				}
				
				if(_getWayButton1.parent)
				{
					_getWayButton1.parent.removeChild(_getWayButton1);
				}
				
				_numPic.init("fight_","0",_mc.numPos);
				
				if(_animBoard)
				{
					_animBoard.destroy();
					_animBoard = null;
				}
				
				return;
			}
			
			var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(item.id);
			
//			var desList:Array = CfgDataParse.pareseDes(equipCfg.desc,0xffffff,0);
//			
//			_mc.desTxt.htmlText = desList.join(" ");
			
			//佩戴描述
			var des:String;
			if(equipCfg.entity == EntityTypes.ET_HERO)
			{
				des = StringConst.CONVERT_019;
			}
			else
			{
				des = StringConst.CONVERT_018;
			}
			
			
			_mc.desTxt.htmlText = HtmlUtils.createHtmlStr(0xd4a460,des);
			
			//判断是否是戒
			var isRing:Boolean = equipCfg.type == ConstEquipCell.TYPE_HUANJIE;
			
			//底图
//			_mc.desGroup.gotoAndStop(isRing?1:2);
			_mc.bg0.visible = isRing;
			_mc.bg1.visible = !isRing;
			//
			var attrDatas:Vector.<PropertyData> = CfgDataParse.getPropertyDatas(equipCfg.attr);
//			var attrList:Vector.<String> = CfgDataParse.getAttHtmlStringArray(equipCfg.attr,0,attrDatas);
			
			var propertyTxt0:String = "";
			var propertyTxt1:String = "";
			
			for each(var attrData:PropertyData in attrDatas)
			{
				if(isRing)
				{
					if(!attrData.isMain)
					{
						propertyTxt0 += CfgDataParse.propertyToStr(attrData,2,0xff6600,0x53b436)+"<br/>";
					}
				}
				else
				{
					if(attrData.isMain)
					{
						propertyTxt0 += CfgDataParse.propertyToStr(attrData,2,0xff6600,0x53b436)+"<br/>";
					}
					else
					{
						propertyTxt1 += CfgDataParse.propertyToStr(attrData,2,0xff6600,0x53b436)+"<br/>";
					}
				}
			}
			
			
			_mc.propertyTxt0.htmlText = propertyTxt0;
			
			//暂时还没有套装属性 按策划要求临时设置
			if(isRing)
			{
				propertyTxt1 = HtmlUtils.createHtmlStr(0xff6600,StringConst.CONVERT_023)+HtmlUtils.createHtmlStr(0x53b436,"30%")
			}
			
			_mc.propertyTxt1.htmlText = propertyTxt1;
			
			if(item.isGet)
			{
				if(_getWayButton0.parent)
				{
					_getWayButton0.parent.removeChild(_getWayButton0);
				}
				
				if(_getWayButton1.parent)
				{
					_getWayButton1.parent.removeChild(_getWayButton1);
				}
			}
			else
			{
				_mc.getPos0.addChild(_getWayButton0);
				_mc.getPos1.addChild(_getWayButton1);
			}
			var fightPower:Number = CfgDataParse.getFightPower(equipCfg.attr);
			_numPic.init("fight_",int(fightPower).toString(),_mc.numPos);
//			_effectLoader = new UIEffectLoader(_mc,_mc.iconPos.x,_mc.iconPos.y,1,1,_dataManager.getIconUrl(item.id),function():void
//			{
//				if(_effectLoader.effect)
//				{
//					_effectLoader.effect.mouseEnabled = true;
//					var tipVO:TipVO = new TipVO();
//					tipVO.tipData = equipCfg;
//					tipVO.tipType = ToolTipConst.EQUIP_BASE_TIP;
//					ToolTipManager.getInstance().hashTipInfo(_effectLoader.effect,tipVO);
//					ToolTipManager.getInstance().attach(_effectLoader.effect);
//					_iconAnim = TweenLite.to(_effectLoader.effect,1,{y:_mc.iconPos.y - 8,repeat:-1,onComplete:reverseTween, onReverseComplete:restartTween});
//				}
//			});	
		}
	
		private function clearCenterIcon():void
		{
			if(_effectLoader)
			{
				if( _effectLoader.effect)
				{
					ToolTipManager.getInstance().detach(_effectLoader.effect);
				}
				_effectLoader.destroy();
				_effectLoader = null;
			}
			if(_iconAnim)
			{
				_iconAnim.kill();
			}
		}
		
		private function reverseTween():void
		{
			if(_iconAnim)
			{
				_iconAnim.reverse();
			}
		}
		private function restartTween():void 
		{
			if(_iconAnim)
			{
				_iconAnim.restart();
			}
		}
		
		override protected function initSkin():void
		{
			_skin = new McConvertStartPanel();
			_mc = _skin as McConvertStartPanel;
			addChild(_skin);
			
			setTitleBar(_mc.mcTitleBar);
			addEventListener(MouseEvent.CLICK,clickHandler);
			
			initCell();
			
			_dataManager.attach(this);
			
			setSelected(0);
		}
		
	
		
		private function clickHandler(e:Event):void
		{
			switch(e.target)
			{
				case _mc.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_CONVERT_START);
					break;
				case _getWayButton0:
					//test
					var item:ConvertStartData = _dataManager.getStartItemInfo(selectedIndex);
//					ChatDataManager.instance.checkCmd("equip "+item.id+" 1 1");
					
					var data:NpcShopCfgData = _dataManager.getNpcShopCfgData(item.id);
					if(data)
					{
						PanelBuyItemConfirmData.cfgDt = data;
						PanelMediator.instance.switchPanel(PanelConst.TYPE_BUY_ITEM_CONFIRM);
					}
					break;
			}
			
		}
		
		private function itemClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _mc.item0:
					setSelected(0);
					break;
				case _mc.item1:
					setSelected(1);
					break;
				case _mc.item2:
					setSelected(2);
					break;
			}
		}
		
		private var selectedIndex:int = -1;
		public function setSelected(index:int):void
		{
			var selectedMc:MovieClip;
			if(selectedIndex != index)
			{
				if(selectedIndex != -1)
				{
					selectedMc = _mc[ITEM_PREFIX+selectedIndex];
					_overEffectManager.setSelected(selectedMc,false);
				}
					
				selectedIndex = index;
				selectedMc = _mc[ITEM_PREFIX+selectedIndex];
				_overEffectManager.setSelected(selectedMc,true);
				
				
				var data:ConvertStartData = _dataManager.getStartItemInfo(selectedIndex);
				setItemDetail(data);
			}
		}
		
		public function clearCell():void
		{
			for each(var icon:IconCellEx in _iconList)
			{
				_overEffectManager.remove(icon);
				icon.removeEventListener(MouseEvent.CLICK,itemClickHandler);
				if(icon.parent)
				{
					icon.parent.removeChild(icon);
				}
				icon.destroy();
			}
			
			_iconList = null;
		}
		
		public function initCell():void
		{
			if(_iconList)
				return;
			
			_iconList = new Vector.<IconCellEx>();
			
			_overEffectManager = new MouseOverEffectManager(1,_mc.item0.width,_mc.item0.height);
			
			for(var i:int = 0; i < NUM_CELL; ++i)
			{
				var item:MovieClip = _mc[ITEM_PREFIX+i];
				var cell:IconCellEx = new IconCellEx(item.iconPos,0,0,60,60);
				
				item.useHandCursor = true;
				item.buttonMode = true;
				
				_iconList.push(cell);
				
				_overEffectManager.add(item);
				
				item.addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
		}
		
		public function updateBaseInfo():void
		{
			for(var i:int = 0; i < 3; ++i)
			{
				setItemInfo(i,_dataManager.getStartItemInfo(i));
			}
		}
		
		public function setItemInfo(index:int,item:ConvertStartData):void
		{
			var itemMc:MovieClip = _mc[ITEM_PREFIX+index];
			
			if(!item)
			{
				itemMc.nameTxt.htmlText = "";
				itemMc.stateTxt.text = "";
				itemMc.filters = null;
				_iconList[index].url = "";
				return;
			}
			
			itemMc.nameTxt.htmlText = HtmlUtils.createHtmlStr(0xFFE1AA,item.name,14,true);
			itemMc.stateTxt.text = item.stateDes;
			
			if(item.isGet)
			{
				itemMc.filters = null;
			}
			else
			{
				itemMc.filters = [_grayFilter];
			}
			
			_iconList[index].url = item.url;
		}
	}
}