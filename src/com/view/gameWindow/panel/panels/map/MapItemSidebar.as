package com.view.gameWindow.panel.panels.map
{
	import com.model.configData.cfgdata.MonsterCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Accordion;
	import com.view.gameWindow.common.List;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author wqhk
	 * 2014-9-18
	 */
	public class MapItemSidebar extends Sprite implements IScrollee
	{
		private var _accordion:Accordion;
		
		private var _npcList:List;
		private var _areaList:List;
		private var _monsterList:List;
		private var _scrollRect:Rectangle;
		
		private var _searchList:List;
		
		private var _npcSearch:Array;
		private var _monsterSearch:Array;
		private var _areaSearch:Array;
		
		public var clearPathHandler:Function;
		public var needShowFly:Boolean = true;
		public var mapId:int;
		
		public static const FLY_WORD:String = "iconFly";
		
		public function MapItemSidebar(width:Number,height:Number)
		{
			super();
			
			_accordion = new Accordion();
			_accordion.setStyle(McMapItemListFolder,changeStateCallback,{"btnZoom":btnLoadComplete});
			
			_npcList = createList(npcClickCallback,npcSetCallback,FLY_WORD);
			_areaList = createList(areaClickCallback,areaSetCallback);
			_monsterList = createList(monsterClickCallback,monsterSetCallback,FLY_WORD);
			
			_searchList = createList(searchClickCallback,searchSetCallback,FLY_WORD);
			
			addChild(_accordion);
			
			_scrollRect = new Rectangle(0,0,width,height);
			this.scrollRect = _scrollRect;
			
			_accordion.addEventListener(Event.CHANGE,accordionChangeHandler);
		}
		
		public function showSearch(pattern:String,anchor:DisplayObjectContainer,x:Number,y:Number):void
		{
			_searchList.x = x;
			_searchList.y = y;
			
			var data:Array = getSearchResult(pattern);
			
			if(data.length == 0)
			{
				data.push(StringConst.MAP_PANEL_NO_SEARCH);
			}
			_searchList.data = data;
			_searchList.drawBorder(1,0xb4b4b4);
			anchor.addChild(_searchList);
			
			if(stage)
			{
				stage.addEventListener(MouseEvent.CLICK,stageClickHandler,false,0,false);
			}
		}
		
		public function getSearchResult(pattern:String):Array
		{
			var re:Array = [];
			var index:int = 0;
			var result:Array;
			
			result = search(pattern,_npcSearch);
			for each(index in result)
			{
				re.push(_npcList.data[index]);
			}
			
			result = search(pattern,_areaSearch);
			for each(index in result)
			{
				re.push(_areaList.data[index]);
			}
				
			result = search(pattern,_monsterSearch);
			for each(index in result)
			{
				re.push(_monsterList.data[index]);
			}
			
			return re;
		}
		
		private function search(pattern:String,arr:Array):Array
		{
			var re:Array = [];
			for(var i:int = 0;i < arr.length;++i)
			{
				if(String(arr[i]).indexOf(pattern) != -1)
				{
					re.push(i);
				}
			}
			
			return re;
		}
		
		public function hideSearch():void
		{
			if(_searchList && _searchList.parent)
			{
				_searchList.parent.removeChild(_searchList);
			}
		}
		
		private function stageClickHandler(e:MouseEvent):void
		{
			if(!_searchList.parent)
			{
				if(stage)
				{
					stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageClickHandler);
				}
				return;
			}
			
			var pos:Point = _searchList.parent.localToGlobal(new Point(_searchList.x,_searchList.y));
			var re:Array = _searchList.getObjectsUnderPoint(new Point(e.stageX,e.stageY));
			
			//24为输入框的高度
			if(e.stageX>pos.x && e.stageX < pos.x + _searchList.width &&
				e.stageY>pos.y - 24 && e.stageY < pos.y + _searchList.height)
			{
				return;
			}
			
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageClickHandler);
			}
			
			hideSearch();
		}
		
		private function accordionChangeHandler(e:Event):void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setContent(isNpc:Boolean,isArea:Boolean,isMonster:Boolean):void
		{
			_accordion.clear();
			
			var index:int = 0;
			if(isNpc)
			{
				_accordion.addContent(index,StringConst.MAP_PANEL_NPC,_npcList);
				++index;
			}
			
			if(isArea)
			{
				_accordion.addContent(index,StringConst.MAP_PANEL_AREA,_areaList);
				++index;
			}
			
			if(isMonster)
			{
				_accordion.addContent(index,StringConst.MAP_PANEL_MONSTER,_monsterList);
			}
		}
		
		public function setNpcData(list:Array):void
		{
			_npcSearch = [];
			_npcList.data = list;
		}
		
		public function setAreaData(list:Array):void
		{
			_areaSearch = [];
			_areaList.data = list;
		}
		
		public function setMonsterData(list:Array):void
		{
			_monsterSearch = [];
			_monsterList.data = list;
		}
		
		public function updatePos():void
		{
			_accordion.updatePos();
		}
		
		private function createList(clickCallback:Function,setCallback:Function,linkWord:String = ""):List
		{
			var list:List = new List();
			list.setStyle(McMapItemCell,setCallback,null,linkWord);
			list.clickCallback = clickCallback;
			
			return list;
		}
		
		private function searchSetCallback(index:int,data:Object,item:MovieClip):void
		{
			if(data is String)
			{
				item.txt.htmlText = HtmlUtils.createHtmlStr(0xb4b4b4,data as String);
			}
			else if(data is MonsterCfgData)
			{
				monsterSet(index,data,item);
			}
			else if(data is NpcCfgData)
			{
				npcSet(index,data,item);
			}
			else
			{
				areaSet(index,data,item);
			}
		}
		
		private function searchClickCallback(index:int,data:Object,item:MovieClip,clickWord:String):void
		{
			if(data is String)
			{
			}
			else if(data is MonsterCfgData)
			{
				monsterClickCallback(index,data,item,clickWord);
				hideSearch();
			}
			else if(data is NpcCfgData)
			{
				npcClickCallback(index,data,item,clickWord);
				hideSearch();
			}
			else
			{
				areaClickCallback(index,data,item);
				hideSearch();
			}
		}
		
		private function npcSetCallback(index:int,data:Object,item:MovieClip):void
		{
			npcSet(index,data,item);
			_npcSearch.push(data.name);
		}
		
		private function npcSet(index:int,data:Object,item:MovieClip):void
		{
			var title:String = "";
			
			if(data is NpcCfgData)
			{
				title = NpcCfgData(data).title;
			}
			item.txt.htmlText = HtmlUtils.createHtmlStr(0xb4b4b4,title?data.name+"-":data.name)+(title?HtmlUtils.createHtmlStr(0x009900,title):"");
//			item[FLY_WORD].x = item.txt.textWidth + 10;
			item[FLY_WORD].visible = flyVisible;
		}
		
		private function monsterSetCallback(index:int,data:Object,item:MovieClip):void
		{
			monsterSet(index,data,item);
			_monsterSearch.push(data.name);	
		}
		
		private function monsterSet(index:int,data:Object,item:MovieClip):void
		{
			var monsterCfg:MonsterCfgData = MonsterCfgData(data);
			var lv:int = RoleDataManager.instance.lv;
			
			var color:int = 0x009900;
			if(lv - monsterCfg.level >= 5)
			{
				color = 0xb4b4b4;
			}
			else if(monsterCfg.level - lv >= 5)
			{
				color = 0xff0000;
			}
			
			item.txt.htmlText = HtmlUtils.createHtmlStr(color,monsterCfg.name+" ("+monsterCfg.level+StringConst.LEVEL+")");
			
//			item[FLY_WORD].x = item.txt.textWidth + 10;
			item[FLY_WORD].visible = flyVisible;
		}
		
		private function areaSetCallback(index:int,data:Object,item:MovieClip):void
		{
			areaSet(index,data,item);
			_areaSearch.push(data.name);
		}
		
		private function areaSet(index:int,data:Object,item:MovieClip):void
		{
			item.txt.htmlText = HtmlUtils.createHtmlStr(0xb4b4b4,data.name);
			item[FLY_WORD].visible = false;
		}
		
		private function get flyVisible():Boolean
		{
			return RoleDataManager.instance.isCanFly > 0 && needShowFly;
		}
		
		private function npcClickCallback(index:int,data:Object,item:MovieClip,clickWord:String):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			
			if(clickWord == FLY_WORD)
			{
				GameFlyManager.getInstance().flyToMapByNPC(data.id);
			}
			else
			{
				AutoSystem.instance.stopAutoEx();
				AutoJobManager.getInstance().setAutoTargetData(data.id,EntityTypes.ET_NPC);
			}
			
			if(clearPathHandler != null)
			{
				clearPathHandler();
			}
		}
		
		private function monsterClickCallback(index:int,data:Object,item:MovieClip,clickWord:String):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			
			if(clickWord == FLY_WORD)
			{
				GameFlyManager.getInstance().flyToMapByMonster(data.group_id,mapId);
			}
			else
			{
				AutoSystem.instance.stopAutoEx();
				/*AutoJobManager.getInstance().setAutoTargetData(data.group_id,EntityTypes.ET_MONSTER);*/
				AutoSystem.instance.setTarget(data.group_id,EntityTypes.ET_MONSTER);
			}
			
			if(clearPathHandler != null)
			{
				clearPathHandler();
			}
		}
		
		private function areaClickCallback(index:int,data:Object,item:MovieClip):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			AutoSystem.instance.stopAutoEx();
			AutoJobManager.getInstance().setAutoTargetData(data.id,EntityTypes.ET_TELEPORTER);
			
			if(clearPathHandler != null)
			{
				clearPathHandler();
			}
		}
		
		private function btnLoadComplete(mc:MovieClip):void
		{
			_accordion.updateHeaderStateAll();
		}
		
		private function changeStateCallback(header:MovieClip,state:int):void
		{
			header.btnZoom.selected = state == 1 ? false : true;
		}
		
		/**
		 * 
		 * @param pos 被滚动内容的scrollRect的y坐标
		 */		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			this.scrollRect = _scrollRect;
		}
		public function get contentHeight():int
		{
			return _accordion.height;
		}
		
		public function get scrollRectHeight():int
		{
			return _scrollRect.height;
		}
		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
	}
}