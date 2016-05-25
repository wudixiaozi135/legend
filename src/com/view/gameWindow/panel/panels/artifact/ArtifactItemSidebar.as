package com.view.gameWindow.panel.panels.artifact
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ArtifactCfgData;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.view.gameWindow.common.Accordion;
	import com.view.gameWindow.common.List;
	import com.view.gameWindow.common.SelectedEffectManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.scrollBar.IScrollee;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import mx.events.Request;

	public class ArtifactItemSidebar extends Sprite implements IScrollee
	{
		
		private var _scrollRect:Rectangle;
		private var _accordion:Accordion;
		private var selectedIndex:int = 0;
		private var _vecList:Vector.<List>;
		public var _selectedItemCfg:ArtifactCfgData;
		
		public var _fun:Function;//点击刷新界面显示函数
		private var _urlSwf:UIEffectLoader;
		
		private var _iconAnim:TweenLite;
		
		public function ArtifactItemSidebar(width:Number,height:Number,type:int)
		{
			super();
			_accordion = new Accordion();
			_vecList = new Vector.<List>();
			_vecList.length = getDicLengthByType(type);
			_accordion.onlyOneSelected = true;
			_accordion.selectHandler = accordionSelectHandler;
			_accordion.addEventListener(Event.SELECT, accordionSelectHandler);
			_accordion.setStyle(McArtifactItemListFolder,changeStateCallback,{"btnZoom":btnLoadComplete});
			if(_vecList.length)
			{
				for(var i:int = 0;i<_vecList.length;i++)
				{
					_vecList[i] = createList(artifactClickCallback,artifactSetCallback);
					_vecList[i].selectable = true;
				}
			}
			addChild(_accordion);
			
			_scrollRect = new Rectangle(0,0,width,height);
			this.scrollRect = _scrollRect;
//			_urlSwf = new UIEffectLoader((this.parent.parent as McArtifact).loader,0,0);
			_accordion.addEventListener(Event.CHANGE,accordionChangeHandler);
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
		
		private function createList(clickCallback:Function,setCallback:Function):List
		{
			var list:List = new List();
			list.setStyle(McArtifactItemCell,setCallback,null);
			list.x = 25;
			list.clickCallback = clickCallback;
			return list;
		}
		
		private function artifactSetCallback(index:int,data:Object,item:MovieClip):void
		{
			var artifactCfg:ArtifactCfgData = ArtifactCfgData(data);
			var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(artifactCfg.equipid);
			item.txt.htmlText = HtmlUtils.createHtmlStr(0xffe1aa,equipCfg.name);
			for(var i:int = 0;i<_vecList.length;i++)
			{
				_vecList[i].selectedIndex = -1;
			}
			_vecList[0].selectedIndex = 0;
			_selectedItemCfg = _vecList[0].selectedItem as ArtifactCfgData;
			if(_fun != null)
			{
				_fun((_vecList[0].data)[0]);
			}
			setUrlSwf();
			if(this.parent.parent is McArtifact)
			{
				_iconAnim = TweenLite.to((this.parent.parent as McArtifact).loader,1,{y:this.parent.parent.y + (this.parent.parent as McArtifact).loader.y - 8,repeat:-1,onComplete:reverseTween, onReverseComplete:restartTween});
//				_iconAnim2 = TweenLite.to((this.parent.parent as McArtifact).loaderPic,1,{y:this.parent.parent.y + (this.parent.parent as McArtifact).loaderPic.y - 8,repeat:-1,onComplete:reverseTween, onReverseComplete:restartTween});
			}
		}
		
		private function artifactClickCallback(index:int,data:Object,item:MovieClip):void
		{
			for(var i:int = 0;i<_vecList.length;i++)
			{
				_vecList[i].selectedIndex = -1;
			}
			_vecList[selectedIndex].selectedIndex = index;
			_selectedItemCfg = _vecList[selectedIndex].selectedItem as ArtifactCfgData;
			if(_fun != null)
			{
				_fun(data);
			}
			setUrlSwf();
		}
		
		private function setUrlSwf():void
		{
			if(_urlSwf)
			{
				_urlSwf.destroy();
				_urlSwf = null;
			}
			/*if(_urlPic)
			{
				_urlPic.destroy();
				_urlPic = null;
			}*/
			if(this.parent.parent is McArtifact)
			{
//				_urlPic = new UrlPic((this.parent.parent as McArtifact).loaderPic);
				var url:String = "artifact/" + _selectedItemCfg.show_icon + ResourcePathConstants.POSTFIX_SWF;
				_urlSwf = new UIEffectLoader((this.parent.parent as McArtifact).loader,(this.parent.parent as McArtifact).loader.width*.5,(this.parent.parent as McArtifact).loader.height*.5,1,1,url);
//				_urlPic.load(ResourcePathConstants.IMAGE_EFFECT_FOLDER_LOAD + "artifact/" + _selectedItemCfg.show_icon + ResourcePathConstants.POSTFIX_PNG);
			}
		}
		
		public function destroyPic():void
		{
			if(_urlSwf)
			{
				_urlSwf.destroy();
				_urlSwf = null;
			}
			/*if(_urlPic)
			{
				_urlPic.destroy();
				_urlPic = null;
			}*/
			if(_iconAnim)
			{
				_iconAnim.kill();
				_iconAnim = null;
			}
			/*if(_iconAnim2)
			{
				_iconAnim2.kill();
				_iconAnim2 = null;
			}*/
		}
		
		private function accordionSelectHandler(e:Request):void
		{
			setAccordionSelectedIndex(int(e.value));
		}
		
		private function setAccordionSelectedIndex(value:int):void
		{
			selectedIndex = value;
		}
		
		private function btnLoadComplete(mc:MovieClip):void
		{
			_accordion.updateHeaderStateAll();
		}
		
		private function changeStateCallback(header:MovieClip,state:int):void
		{
			if (header.btnZoom)
			{
				header.btnZoom.selected = state == 1 ? false : true;
			}
		}
		
		private function accordionChangeHandler(e:Event):void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setContent(datas:Array):void
		{
			_accordion.clear();
			
			var index:int = 0;
			for(var i:int = 0;i<datas.length;i++)
			{
				if(datas[i].length)
				{
					_accordion.addContent(index,ConstEquipCell.getEquipName(datas[i][0].part),_vecList[index]);
					++index;
				}		
			}
		}
		/**
		 *根据TYPE取字典的长度 
		 * @param type
		 * @return 
		 * 
		 */		
		private function getDicLengthByType(type:int):int
		{
			var dic:Dictionary = ConfigDataManager.instance.artifactDic(type);
			var vecInt:Vector.<int> = new Vector.<int>();
			for(var key:* in dic)
			{
				vecInt.push(key);
			}
			if(vecInt)
			{
				return vecInt.length;
			}
			else
			{
				return 0;
			}
			return 0;
		}
		
		public function setData(list:Array,index:int):void
		{
			list.sort(sortListById);
			_vecList[index].classType = SelectedEffectManager;
			_vecList[index].data = list;
		}
		
		private function sortListById(temp1:ArtifactCfgData,temp2:ArtifactCfgData):int
		{
			if(temp1.equipid>temp2.equipid)
			{
				return 1;
			}
			return -1;
		}
		
		public function updatePos():void
		{
			_accordion.updatePos();
		}
		
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