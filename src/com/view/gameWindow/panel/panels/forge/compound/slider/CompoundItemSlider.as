package com.view.gameWindow.panel.panels.forge.compound.slider
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.forge.compound.CombineType1Data;
	import com.view.gameWindow.panel.panels.forge.compound.McCompoundItemList2Folder;
	import com.view.gameWindow.panel.panels.forge.compound.McCompoundItemListFolder;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * @author ldq
	 * 2014-9-18
	 */
	public class CompoundItemSlider extends Sprite implements IScrollee
	{
		private var _accordion:Accordion2;

		private var _upMaterialcDataListFolder:ListFolder = new ListFolder();
		private var _strengMaterialListFolder:ListFolder = new ListFolder();
		private var _skillRunesListFolder:ListFolder = new ListFolder();
		private var _expItemListFolder:ListFolder = new ListFolder();
		private var _treasureListFolder:ListFolder = new ListFolder();
		private var _skillBookListFolder:ListFolder = new ListFolder();
		
		private var _scrollRect:Rectangle;
		
		private var _callback:Function;
		
		private var _selectedType:int = 0;
		private var _selectedType2:int = 0;
		
		public function CompoundItemSlider(width:Number,height:Number,callback:Function)
		{
			_callback = callback;
			
			_accordion = new Accordion2();
			_accordion.setStyle(McCompoundItemListFolder,changeStateCallback,{"btnZoom":btnLoadComplete});
			_accordion.setSecondListStyle(McCompoundItemList2Folder,changeState2Callback,{"btnZoom":btnLoadComplete});
			
			_upMaterialcDataListFolder = createListFolder(itmeClickCallback,combineCallback);
			_strengMaterialListFolder = createListFolder(itmeClickCallback,combineCallback);
			_skillRunesListFolder = createListFolder(itmeClickCallback,combineCallback);
			_expItemListFolder = createListFolder(itmeClickCallback,combineCallback);
			_treasureListFolder = createListFolder(itmeClickCallback,combineCallback);
			_skillBookListFolder = createListFolder(itmeClickCallback,combineCallback);
			
			addChild(_accordion);
			
			_scrollRect = new Rectangle(0,0,width,height);
			scrollRect = _scrollRect;
			
			_accordion.addEventListener(Event.CHANGE,accordionChangeHandler);
		}
		
		private function btnLoadComplete(mc:MovieClip):void
		{
			_accordion.updateHeaderStateAll();
		}
		
		private function changeStateCallback(header:MovieClip,state:int):void
		{
			//header.selected = state == 1 ? false : true;
		}
		
		private function changeState2Callback(header:MovieClip,state:int):void
		{
			
		}
		/**二级分类表*/
		private function createListFolder(clickCallback:Function,setCallback:Function):ListFolder
		{
			var listFolder:ListFolder = new ListFolder();
			listFolder.setStyle(McCompoundItemList2Folder,setCallback,null);
			listFolder.clickCallback = clickCallback;
			listFolder.slider = this;
			return listFolder;
		}
		
		private function itmeClickCallback(index:int,data:Object,item:MovieClip):void
		{
			_callback(data);
		}
		/**二级分类赋值*/
		private function combineCallback(index:int,data:Object,item:MovieClip):void
		{
			var color:int = 0xffe1aa;
			item.txt.htmlText = HtmlUtils.createHtmlStr(color,data.name);
		}
		
		private function accordionChangeHandler(e:Event):void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		internal function get selectedType():int
		{
			return _selectedType;
		}
		
		internal function get selectedType2():int
		{
			return _selectedType2;
		}
		
		internal function setSelectedType(type:int,type2:int):void
		{
			_selectedType = type;
			_selectedType2 = type2;
			_upMaterialcDataListFolder.cancelSelectedIndex();
			_strengMaterialListFolder.cancelSelectedIndex();
			_skillRunesListFolder.cancelSelectedIndex();
			_expItemListFolder.cancelSelectedIndex();
			_treasureListFolder.cancelSelectedIndex();
			_skillBookListFolder.cancelSelectedIndex();
		}
		
		public function changMaterialNum(numArr:Array):void
		{
			_accordion.changeHeadCombineNum(numArr);
		}
		
		public function addListFolder():void
		{
			_accordion.clear();
			
			var index:int = 0;
			if(_strengMaterialListFolder.data)
			{
				_accordion.addListFolder(index,StringConst.FORGE_PANEL_00001,_strengMaterialListFolder);
				++index;
			}
			if(_upMaterialcDataListFolder.data)
			{
				_accordion.addListFolder(index,StringConst.FORGE_PANEL_00002,_upMaterialcDataListFolder);
				++index;
			}
			if(_skillRunesListFolder.data)
			{
				_accordion.addListFolder(index,StringConst.FORGE_PANEL_00003,_skillRunesListFolder);
				++index;
			}
			if(_expItemListFolder.data)
			{
				_accordion.addListFolder(index,StringConst.FORGE_PANEL_00004,_expItemListFolder);
				++index;
			}
			if(_treasureListFolder.data)
			{
				_accordion.addListFolder(index,StringConst.FORGE_PANEL_00005,_treasureListFolder);
				++index;
			}
			if(_skillBookListFolder.data)
			{
				_accordion.addListFolder(index,StringConst.FORGE_PANEL_00006,_skillBookListFolder);
			}
		}
		
		public function updatePos():void
		{
			_accordion.updatePos();
		}
		
		public function setStrengMaterialFolderData(list:Array,type:int,type1Data:CombineType1Data):void
		{
			_strengMaterialListFolder.slider = this;
			_strengMaterialListFolder.type = type;
			_strengMaterialListFolder.data = type1Data;
		}
		
		public function setUpMaterialcFolderData(list:Array,type:int,type1Data:CombineType1Data):void
		{
			_upMaterialcDataListFolder.slider = this;
			_upMaterialcDataListFolder.type = type;
			_upMaterialcDataListFolder.data = type1Data;
		}
		
		public function setSkillRunesFolderData(list:Array,type:int,type1Data:CombineType1Data):void
		{
			_skillRunesListFolder.slider = this;
			_skillRunesListFolder.type = type;
			_skillRunesListFolder.data = type1Data;
		}
		
		public function setExpItemFolderData(list:Array,type:int,type1Data:CombineType1Data):void
		{
			_expItemListFolder.slider = this;
			_expItemListFolder.type = type;
			_expItemListFolder.data = type1Data;
		}
		
		public function setTreasureFolderData(list:Array,type:int,type1Data:CombineType1Data):void
		{
			_treasureListFolder.slider = this;
			_treasureListFolder.type = type;
			_treasureListFolder.data = type1Data;
		}
		
		public function setSkillBookFolderData(list:Array,type:int,type1Data:CombineType1Data):void
		{
			_skillBookListFolder.slider = this;
			_skillBookListFolder.type = type;
			_skillBookListFolder.data = type1Data;
		}
		
		public function refreshData(data:Vector.<CombineType1Data>,isShowCombine:Boolean):void
		{
			_accordion.changeCombineData(data,isShowCombine);
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
		/**清空所有内容*/
		public function chear():void
		{
			_accordion.clear();
			_upMaterialcDataListFolder.slider = null;
			_strengMaterialListFolder.slider = null;
			_skillRunesListFolder.slider = null;
			_expItemListFolder.slider = null;
			_treasureListFolder.slider = null;
			_skillBookListFolder.slider = null;
		}
	}
}