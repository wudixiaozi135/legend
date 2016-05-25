package com.view.gameWindow.panel.panels.demonTower
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DemonTowerCfgData;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	import com.view.gameWindow.util.css.GameStyleSheet;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import com.view.gameWindow.panel.panels.lockDemonTower.McDemonTower;
	import com.view.gameWindow.panel.panels.lockDemonTower.McDemonTowerItem;
	
	/**
	 * 锁妖塔面板类
	 * @author Administrator
	 */	
	public class PanelDemonTower extends PanelBase
	{
		private var _items:Vector.<McDemonTowerItem>;

		private var _reincarn:int;

		private var _lv:int;
		
		public function PanelDemonTower()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McDemonTower = new McDemonTower();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			var skin:McDemonTower = _skin as McDemonTower;
			setTitleBar(skin.mcDrag);
			//
			skin.txtTitle.text = StringConst.DEMON_TOWER_0001;
			var defaultTextFormat:TextFormat = skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			skin.txtTitle.defaultTextFormat = defaultTextFormat;
			skin.txtTitle.setTextFormat(defaultTextFormat);
			//
			var npcId:int = args[0] as int;
			var npcCfgDt:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
			//
			var textColor:uint = skin.txtDesc.textColor;
			var leading:int = skin.txtDesc.defaultTextFormat.leading as int;
			skin.txtDesc.htmlText = CfgDataParse.pareseDesToStr(npcCfgDt.default_dialog,textColor,leading);
			//
			_items = new Vector.<McDemonTowerItem>();
			var npcTeleportCfgDatas:Dictionary = ConfigDataManager.instance.npcTeleportCfgDatas(npcId);
			var npcTeleportCfgData:NpcTeleportCfgData;
			var isRuleInit:Boolean;
			for each(npcTeleportCfgData in npcTeleportCfgDatas)
			{
				if(!npcTeleportCfgData)
				{
					continue;
				}
				var mapRegionCfgData:MapRegionCfgData = npcTeleportCfgData.mapRegionCfgData;
				if(!mapRegionCfgData)
				{
					continue;
				}
				var mapCfgData:MapCfgData = mapRegionCfgData.mapCfgData;
				if(!mapCfgData)
				{
					continue;
				}
				var demonTowerCfgData:DemonTowerCfgData = ConfigDataManager.instance.demonTowerCfgData(mapCfgData.id);
				if(!demonTowerCfgData)
				{
					continue;
				}
				var item:McDemonTowerItem = new McDemonTowerItem();
				item.mouseEnabled = false;
				item.npcId = npcTeleportCfgData.npc;
				item.demonTowerCfgData = demonTowerCfgData;
				var index:int = npcTeleportCfgData.order >= 1 ? npcTeleportCfgData.order - 1 : 0;
				_items.length < index ? _items.length = index : null;
				_items[index] = item;
				var str:String = mapCfgData.name + demonTowerCfgData.strLimit;
				item.txt.htmlText = HtmlUtils.createHtmlStr(item.txt.textColor,str,12,false,2,FontFamily.FONT_NAME,true);
				item.x = (skin.mcContent.width - item.width)*.5;
				//
				if(!isRuleInit)
				{
					isRuleInit = true;
					textColor = skin.txtRule.textColor;
					leading = skin.txtRule.defaultTextFormat.leading as int;
					skin.txtRule.htmlText = CfgDataParse.pareseDesToStr(mapCfgData.desc,textColor,leading);
				}
			}
			var d:Number = (skin.mcContent.height - _items.length * item.height)/(_items.length+1);
			var i:int,l:int = _items.length;
			for (i=0;i<l;i++) 
			{
				item = _items[i];
				if(item)
				{
					item.y = d+i*(item.height+d);
					skin.mcContent.addChild(item);
				}
			}
			//
			skin.addEventListener(MouseEvent.CLICK,onClick);
			//
			RoleDataManager.instance.attach(this);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McDemonTower = _skin as McDemonTower;
			if(event.target == skin.btnClose)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_DEMON_TOWER);
				return;
			}
			if(event.target.parent is McDemonTowerItem)
			{
				var item:McDemonTowerItem = event.target.parent as McDemonTowerItem;
				var cfgDt:DemonTowerCfgData = item.demonTowerCfgData as DemonTowerCfgData;
				var reincarn:int = RoleDataManager.instance.reincarn;
				var lv:int = RoleDataManager.instance.lv;
				if(!cfgDt.isInLimit(reincarn,lv))
				{
					return;
				}
				TeleportDatamanager.instance.requestTeleportNpcNeedCheck(item.npcId);
			}
		}
		
		override public function update(proc:int=0):void
		{
			var reincarn:int = RoleDataManager.instance.reincarn;
			var lv:int = RoleDataManager.instance.lv;
			if(_reincarn == reincarn && _lv == lv)
			{
				return;
			}
			_reincarn = RoleDataManager.instance.reincarn;
			_lv = RoleDataManager.instance.lv;
			var item:McDemonTowerItem;
			for each (item in _items)
			{
				var cfgDt:DemonTowerCfgData = item.demonTowerCfgData as DemonTowerCfgData;
				var isInLimit:Boolean = cfgDt.isInLimit(_reincarn,_lv);
				item.txt.mouseEnabled = isInLimit;
				item.txt.styleSheet = isInLimit ? GameStyleSheet.linkStyle : null;
				item.filters = !isInLimit ? UtilColorMatrixFilters.GREY_FILTERS : null;
			}
		}
		
		override public function destroy():void
		{
			RoleDataManager.instance.detach(this);
			var item:McDemonTowerItem;
			for each (item in _items)
			{
				item.demonTowerCfgData = null;
			}
			_items = null;
			skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}