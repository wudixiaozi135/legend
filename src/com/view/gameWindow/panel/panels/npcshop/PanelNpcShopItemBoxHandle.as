package com.view.gameWindow.panel.panels.npcshop
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFuncData;
	import com.view.gameWindow.panel.panels.welfare.OpenDayConsts;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.scrollBar.PageScrollBar;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * NPC商店物品框处理类
	 * @author Administrator
	 */	
	public class PanelNpcShopItemBoxHandle
	{
		private var _mc:McPanelNpcShop;
		private var _itemContainer:Sprite;
		private var _NUM_BOX:int = 6;
		private var _vector:Vector.<PanelNpcShopItemBox>;
		private var _cfgDts:Vector.<NpcShopCfgData>;
		private var _totalPage:int;
		private var _pageScrollBar:PageScrollBar;
		private var DrugShop:Array = [10101,10102,10103,10104,10105,10106,10107,10108,10109,10110,10111,10112
										,10331,10332,10333,10334,10335,10336,10337,10338,10339,10340
										,10411,10412,10413,10414,10415,10416,10417,10418,10419,10420];
		
		public function PanelNpcShopItemBoxHandle(mc:McPanelNpcShop)
		{
			_mc = mc;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,onClick);
			if(!_itemContainer)
			{
				_itemContainer = new Sprite();
				_itemContainer.x = 40;
				_itemContainer.y = 84;
			}
			if(!_itemContainer.parent)
			{
				_mc.addChild(_itemContainer);
			}
			if(!PanelNpcFuncData.npcId)
			{
				return;
			}
			var npcShopCfgDatas:Dictionary,cfgDt:NpcShopCfgData,panelNpcShopItemBox:PanelNpcShopItemBox;
			npcShopCfgDatas = ConfigDataManager.instance.npcShopCfgDatas(PanelNpcFuncData.npcId);
			_cfgDts = new Vector.<NpcShopCfgData>();
			var day:int = WelfareDataMannager.instance.openServiceDay;
			var isDrug:Boolean;
			for each(cfgDt in npcShopCfgDatas)
			{
				isDrug = DrugShop.indexOf(cfgDt.id) == -1 ? false:true;
				var last:int;
				if(day+1<OpenDayConsts.FIRST&&isDrug){
					last = int(cfgDt.base.toString().charAt( cfgDt.base.toString().length-1));
					if(last==1)
					{
						_cfgDts.length < cfgDt.rank? _cfgDts.length = cfgDt.rank : null;
						_cfgDts[cfgDt.rank-1] = cfgDt;
					}
				}
				else if(day+1<OpenDayConsts.SECOND&&isDrug)
				{
					last = int(cfgDt.base.toString().charAt( cfgDt.base.toString().length-1));
					if(last!=3)
					{
						_cfgDts.length < cfgDt.rank? _cfgDts.length = cfgDt.rank : null;
						_cfgDts[cfgDt.rank-1] = cfgDt;
					}
				}
				else
				{
					_cfgDts.length < cfgDt.rank? _cfgDts.length = cfgDt.rank : null;
					_cfgDts[cfgDt.rank-1] = cfgDt;
				}
			}
			var l:uint = _cfgDts.length;
			while(l--)
			{
				cfgDt = _cfgDts[l];
				if(!cfgDt)
				{
					var indexOf:int = _cfgDts.indexOf(cfgDt);
					_cfgDts.splice(indexOf,1);
				}
			}
			_totalPage = int((_cfgDts.length+_NUM_BOX-1)/_NUM_BOX);
			_vector = new Vector.<PanelNpcShopItemBox>(_NUM_BOX,true);
			var i:int;
			for(i=0;i<_NUM_BOX;i++)
			{
				panelNpcShopItemBox = new PanelNpcShopItemBox();
				panelNpcShopItemBox.x = (i%3)*123;
				panelNpcShopItemBox.y = int(i/3)*180;
				_itemContainer.addChild(panelNpcShopItemBox);
				_vector[i] = panelNpcShopItemBox;
				ToolTipManager.getInstance().attach(panelNpcShopItemBox.tipMc);
			}
			refreshData();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var movieClip:MovieClip = event.target as MovieClip;
			if(!movieClip || !movieClip.parent)
			{
				return;
			}
			var panelNpcShopItemBox:PanelNpcShopItemBox = movieClip.parent as PanelNpcShopItemBox;
			if(!panelNpcShopItemBox)
			{
				return;
			}
			panelNpcShopItemBox.onClick();
		}
		
		public function initPageScrollBar(mc:MovieClip):void
		{
			_pageScrollBar = new PageScrollBar(mc,360,refreshData,_totalPage);
		}
		
		private function refreshData():void
		{
			var page:int,itemBox:PanelNpcShopItemBox,i:int,dtIndex:int;
			if(!_pageScrollBar)
			{
				page = 1;
			}
			else
			{
				page = _pageScrollBar.page
			}
			for each(itemBox in _vector)
			{
				dtIndex = (page-1)*_NUM_BOX+i;
				if(dtIndex < _cfgDts.length)
				{
					itemBox.refreshData(_cfgDts[dtIndex]);
				}
				else
				{
					itemBox.setNull();
				}
				i++;
			}
		}
		
		public function destroy():void
		{
			if(_pageScrollBar)
			{
				_pageScrollBar.destroy();
				_pageScrollBar = null;
			}
			while(_itemContainer && _itemContainer.numChildren)
			{
				var panelNpcShopItemBox:PanelNpcShopItemBox = _itemContainer.removeChildAt(0) as PanelNpcShopItemBox;
				ToolTipManager.getInstance().detach(panelNpcShopItemBox.tipMc);
				panelNpcShopItemBox.destroy();
			}
			_itemContainer = null;
			_cfgDts = null;
			while(_vector && _vector.length)
			{
				var pop:PanelNpcShopItemBox = _vector.pop();
				pop.destroy();
			}
			_vector = null;
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
			}
			_mc = null;
		}
	}
}