package com.view.gameWindow.panel.panels.dungeon
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFuncData;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	public class DungeonPanel extends PanelBase implements IDungeonPanel
	{
		private var _id:int;
		private var _vector:Vector.<int> = new Vector.<int>();
		private var _vectorTxtLimit:Vector.<TextField> = new Vector.<TextField>();
		private var _vectorDungeonTxt:Vector.<TextField> = new Vector.<TextField>();
		private var _vectorNumTxt:Vector.<TextField> = new Vector.<TextField>();
		private var _mouseEvent:DungeonPanelMouseEvent;
		
		public function DungeonPanel()
		{
			super();
			DgnDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			_mouseEvent = new DungeonPanelMouseEvent();
			_skin = new McDungeonPanelChoice();
			addChild(_skin);
			setTitleBar((_skin as McDungeonPanelChoice).dragBox);
			_skin.closeBtn.addEventListener(MouseEvent.CLICK,clickHandle);
		}		
		
		private function clickHandle():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON);
		}
		
		override protected function initData():void
		{
			DgnDataManager.instance.queryChrDungeonInfo();
		}
		
		
		override public function update(proc:int=0):void
		{
			if(DgnDataManager.instance.isDealChrDgnInfo)
			{  
				if(_mouseEvent)
				{
					_mouseEvent.destoryEvent();
				}
				initText();
				_mouseEvent.addEvent(_skin as McDungeonPanelChoice,_vectorDungeonTxt);
			}
			super.update(proc);
		}
		
		private function initText():void
		{
			var mcDungeon:McDungeonPanelChoice = _skin as McDungeonPanelChoice;
			var npc:int = PanelNpcFuncData.npcId;
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npc);
			var dic:Dictionary =  ConfigDataManager.instance.dungeonCfgData(npc);
			var count:int;
			
			_vectorTxtLimit = searchText(_skin,"txtLimit_",0,9,2);
			_vectorDungeonTxt = searchText(_skin,"dungeonTitle_",0,13,2);
			_vectorNumTxt = searchText(_skin,"numText_",0,8,2);
			
			_vector = new Vector.<int>();
			for (var i:String in dic)
			{
				_vector.push(int(i));
			}
			TextFormatManager.instance.setTextFormat(mcDungeon.title,mcDungeon.title.textColor,false,true);
			mcDungeon.title.text = StringConst.DUNGEON_PANEL_0011;
			mcDungeon.txt.text = npcCfgData.default_dialog;
			var l:int = (_vector.length < _vectorDungeonTxt.length ? _vector.length : _vectorDungeonTxt.length);
			for(var j:int = 0;j<l;j++)
			{
				var dungeonCfgData:DungeonCfgData = dic[_vector[j]] as DungeonCfgData;
				if(!DgnDataManager.instance.getDgnDt(dungeonCfgData.id))
				{
					count = 0;
				}
				else
				{
					count = DgnDataManager.instance.getDgnDt(dungeonCfgData.id).daily_enter_count;
				}
				var strType:String = /*DungeonConst.getResultType(*/dungeonCfgData.result_type/*)*/;
				var strReinLv:String = dungeonCfgData.reincarn ? dungeonCfgData.reincarn + StringConst.DUNGEON_PANEL_0031 : dungeonCfgData.level + StringConst.DUNGEON_PANEL_0028;
				_vectorTxtLimit[j].text = "[" + strType + "]" + "  " + strReinLv;
				_vectorDungeonTxt[j].text = dungeonCfgData.name;
				var totalCount:int = dungeonCfgData.free_count + dungeonCfgData.toll_count;
				_vectorNumTxt[j].htmlText = StringConst.DUNGEON_PANEL_0023 + HtmlUtils.createHtmlStr(count < totalCount ? 0x00ff00 : 0xff0000,count + "/" + totalCount);
			}		
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get vector():Vector.<int>
		{
			return _vector;
		}
		
		override public function destroy():void
		{
			// TODO Auto Generated method stub
			DgnDataManager.instance.detach(this);
			DgnDataManager.instance.isDealChrDgnInfo = false;
			_vector = null;
			_vectorDungeonTxt = null;
			_vectorNumTxt = null;
			if(_mouseEvent)
			{
				_mouseEvent.destoryEvent();
				_mouseEvent = null;
			}
			super.destroy();
		}
		
	}
}