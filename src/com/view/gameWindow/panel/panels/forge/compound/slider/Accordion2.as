package com.view.gameWindow.panel.panels.forge.compound.slider
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.McFactory;
	import com.view.gameWindow.panel.panels.forge.compound.CombineType1Data;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	public class Accordion2 extends Sprite
	{
		private var _headerFactory:McFactory;//一级分类
		private var _seconderFactory:McFactory;//二级分类
		private var _headerList:Array;
		private var _contentList:Array;
		private var _headerStates:Array;
		private var _changeStateCallback:Function;
		
		public var onlyOneSelected:Boolean = false;
		
		public function Accordion2()
		{
			super();
			
			_headerList = [];
			_contentList = [];
			_headerStates = [];
		}
		
		public function get num():int
		{
			return _headerList.length;
		}
		
		public function destroy():void
		{
			_headerFactory = null;
			clear();
		}
		
		public function clear():void
		{
			_headerList = [];
			_contentList = [];
			_headerStates = [];
			while(numChildren)
			{
				removeChildAt(0);
			}
		}
		/**
		 * 
		 * @param headerClass 需要name为“txt”的Textfiled控件
		 * @param changeStateCallback  function f(mc:MovieClip,state:int):void
		 * @param headerCallback {propertyName:callback,...}
		 */
		public function setStyle(headerClass:Class,changeStateCallback:Function,headerCallback:Object):void
		{
			_headerFactory = new McFactory(headerClass);
			_headerFactory.prefixUrl = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD;
			_headerFactory.callbacks = headerCallback;
			_changeStateCallback = changeStateCallback;
		}
		//加载二级分类
		public function setSecondListStyle(headerClass:Class,changeStateCallback:Function,headerCallback:Object):void
		{
			_seconderFactory = new McFactory(headerClass);
			_seconderFactory.prefixUrl = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD;
			_seconderFactory.callbacks = headerCallback;
			_changeStateCallback = changeStateCallback;
		}
		
		private var _combineNumVec:Vector.<int>=new Vector.<int>;
		private var _headCombineNumVec:Vector.<int>=new Vector.<int>;//各个头部合成状态 1,代表可以合成 0，代表不可以合成
		public function changeHeadCombineNum(arr:Array):void
		{
			for(var i:int=0;i<arr.length;i++)
			{
				if(arr[i]>0)
				{
					_headCombineNumVec.push(1);
					_headVec[i].numTxt.text=StringUtil.substitute(StringConst.NUM_MSG,arr[i]);
					
				}
				else
				{
					_headCombineNumVec.push(0);
					_headVec[i].numTxt.text="";
				}
			}
		}
		
		public function changeCombineData(data:Vector.<CombineType1Data>,isShowCombine:Boolean):void
		{
			var i:int=0;
			var arr:Array=new Array;
			var combineType1Data:CombineType1Data;
			var listFolder:ListFolder;
			for(i=0;i<data.length;i++)
			{
				combineType1Data=data[i];
				arr.push(combineType1Data.canCombineNum);
				
				listFolder=_contentList[i];
				listFolder.changNum(combineType1Data,isShowCombine);
			}
			changeHeadCombineNum(arr);
		}
		
		private var _headVec:Vector.<MovieClip>=new Vector.<MovieClip>;
		public function addListFolder(index:int,label:String,content:DisplayObject):void
		{
			var header:MovieClip = _headerFactory.create();
			var format:TextFormat=header.txt.defaultTextFormat;
			format.bold=true;
			header.txt.defaultTextFormat = format;
			header.txt.mouseEnabled=false;
			header.txt.setTextFormat(format);
			header.txt.text = label;
			_headVec.push(header);
			
			header.addEventListener(MouseEvent.CLICK,headerClickHandler,false,0,true);
			
			addChild(header);
			addChild(content);
			content.x=(header.width-content.width)/2;
			
			if(index>_headerList.length)
			{
				index = _headerList.length;
			}
			_headerList.splice(index,0,header);
			_contentList.splice(index,0,content);
			
			if(onlyOneSelected)
			{
				if(_headerStates.length == 0)
				{
					_headerStates.splice(index,0,1);
				}
				else
				{
					_headerStates.splice(index,0,0);
				}
			}
			else
			{
				_headerStates.splice(index,0,1);
			}
			updatePos();
		}
		
		
		private function headerClickHandler(e:MouseEvent):void
		{
			var target:Object = e.currentTarget;
			var index:int = _headerList.indexOf(target);
			
			var state:int = _headerStates[index];
			
			changeState(index,state == 1 ? 0 : 1);
			
			updatePos();
		}
		
		private function updateHeaderState(index:int):void
		{
			if(_changeStateCallback != null)
			{
				_changeStateCallback(_headerList[index],_headerStates[index]);
			}
		}
		
		public function updateHeaderStateAll():void
		{
			for(var i:int = 0; i < _headerStates.length; ++i)
			{
				updateHeaderState(i);
			}
		}
		
		private function changeState(index:int,state:int):void
		{
			if(onlyOneSelected)
			{
				for(var i:int = 0; i < _headerStates.length;++i)
				{
					if(index != i)
					{
						_headerStates[i] = 0;
					}
					else
					{
						_headerStates[i] = 1;
					}
					
					updateHeaderState(i);
				}
			}
			else
			{
				_headerStates[index] = state;
				updateHeaderState(index);
			}
		}
		
		public function updatePos():void
		{
			var y:int = 0;
			for(var i:int = 0;i < _headerStates.length;++i)
			{
				var state:int = _headerStates[i];
				var header:DisplayObject = _headerList[i];
				var content:DisplayObject = _contentList[i];
				
				header.y = y;
				y+=header.height;
				
				trace(i,content.height);
				if(state)
				{
					content.y = y;
					y+=content.height;
					if(!content.parent)
					{
						addChild(content);
					}
				}
				else
				{
					if(content.parent)
					{
						removeChild(content);
					}
				}
			}
			
			this.dispatchEvent(new Event(Event.CHANGE,false,false));
		}
		
		public function foldContent(index:int,isShow:Boolean):void
		{
			changeState(index,isShow?1:0);
			
			updatePos();
		}
		
		public function removeContent(index:int):void
		{
			if(_headerList.length == 0)
			{
				return;
			}
			
			if(index>=_headerList.length)
			{
				index = _headerList.length - 1;
			}
			
			var header:DisplayObject = _headerList[index];
			var content:DisplayObject = _contentList[index];
			
			if(header.parent)
			{
				header.parent.removeChild(header);
			}
			
			if(content.parent)
			{
				content.parent.removeChild(content);
			}
			
			_headerList.splice(index,1);
			_contentList.splice(index,1);
			_headerStates.splice(index,1);
			
			updatePos();
		}
	}
}