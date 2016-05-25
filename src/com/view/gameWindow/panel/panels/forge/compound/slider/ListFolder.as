package com.view.gameWindow.panel.panels.forge.compound.slider
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.view.gameWindow.common.McFactory;
	import com.view.gameWindow.panel.panels.forge.compound.CombineType1Data;
	import com.view.gameWindow.panel.panels.forge.compound.CombineType2Data;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 二级分类容器
	 */
	public class ListFolder extends Sprite
	{
		private var _itemFactory:McFactory;
		private var _itemSetCallback:Function;
		private var _itemList:Array;
		private var _dataList:CombineType1Data;
		/**该一级目录下所有二级分类可合成总数总数*/
		private var _totalCombineNum:int = 0;
		/**所属一级分类类型*/
		public var type:int = 0;
		private var _getListFolderCompoundNum:Function;
		/**clickCallback(index:int,data:Object,target:DisplayObject);*/
		public var clickCallback:Function;
		
		public var slider:CompoundItemSlider;
		
		/**@see #clickCallback*/
		public function ListFolder()
		{
			super();
		}
		
		public function drawBorder(thickness:int,color:int):void
		{
			graphics.clear();
			graphics.lineStyle(thickness,color);
			graphics.beginFill(0,0);
			graphics.drawRect(-thickness,-thickness,width+thickness,height+thickness);
			graphics.endFill();
		}
		/**itemSetCallback(index:int,data:Object,target:DisplayObject);*/
		public function setStyle(itemClass:Class,itemSetCallback:Function,itemCallback:Object):void
		{
			_itemFactory = new McFactory(itemClass);
			_itemFactory.prefixUrl = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD;
			_itemFactory.callbacks = itemCallback;
			_itemSetCallback = itemSetCallback;
		}
		
		public function clear():void
		{
			for each(var item:DisplayObject in _itemList)
			{
				if(item.parent)
				{
					item.parent.removeChild(item);
				}
			}
			_dataList = null;
			_itemList = [];
		}
		
		public function get data():CombineType1Data
		{
			return _dataList;
		}
		
		public function set data(value:CombineType1Data):void
		{
			clear();
			
			if(value)
			{
				_dataList = value;
				type = value.type;
			}
			else
			{
				_dataList = new CombineType1Data();
			}
			
			var index:int = 0;
			var i:int = 0;
			for each(var data:CombineType2Data in value.combineVec)
			{
				var item:MovieClip = _itemFactory.create();
				if(_itemSetCallback != null)
				{
					_itemSetCallback(index,data,item);
				}
				var itemList:ItemList = new ItemList();
				itemList.initialize(item,data,clickCallback,slider);
				i++;
				itemList.index=i;
				addChild(itemList);
				_itemList.push(itemList);
			}
			updatePos();
		}
		
		public function changNum(data:CombineType1Data,isShowCombine:Boolean):void
		{
			var itemList:ItemList;
			var combineType2Data:CombineType2Data;
			for(var i:int=0;i<data.combineVec.length;i++)
			{
				combineType2Data=data.combineVec[i];
				itemList=_itemList[i];
				itemList.changNum(combineType2Data);
			}
		}
		
		public function updatePos():void
		{
			var y:Number = 0;
			for each(var item:DisplayObject in _itemList)
			{
				item.y = y;
				y+=item.height;
			}
			
			if(this.parent)
			{
				(this.parent as Accordion2).updatePos();
			}
		}
		/**将其他选中取消*/
		public function cancelSelectedIndex():void
		{
			var itemList:ItemList;
			for each(itemList in _itemList)
			{
				if(itemList.type != slider.selectedType || itemList.type2 != slider.selectedType2)
				{
					itemList.cancelSelectedIndex();
				}
			}
		}
	}
}