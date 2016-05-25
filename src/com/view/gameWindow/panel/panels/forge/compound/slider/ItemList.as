package com.view.gameWindow.panel.panels.forge.compound.slider
{
	import com.model.configData.cfgdata.CombineCfgData;
	import com.model.consts.ConstBind;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.compound.CombineData;
	import com.view.gameWindow.panel.panels.forge.compound.CombineType2Data;
	import com.view.gameWindow.panel.panels.forge.compound.McCompoundItemCell;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;

	//二级分类，包含二级分类头和内容
	public class ItemList extends Sprite
	{
		//所属的一二级分类
		private var _type:int;
		private var _type2:int;
		private var _list2:List2;
		private var _itemClickFunc:Function;
		/**三级列表是否显示，默认不显示*/
		public var showContent:Boolean = false;
		public var index:int=-1;//在父容器中的索引
		private var _dataList:Array;
		private var _materialNumList:Array=new Array;//各材料数量集合
		private var _bagManager:BagDataManager=BagDataManager.instance;
		private var _heroManager:HeroDataManager=HeroDataManager.instance;
		private var _totalNum:int=0;//二级分类可合成总量
		private var _head:MovieClip;
		private var _getcombineNum:Function;
		
		public function ItemList()
		{
			super();
		}
		
		internal function get type():int
		{
			return _type;
		}
		
		internal function get type2():int
		{
			return _type2;
		}
		
		public function initialize(head:MovieClip,data:CombineType2Data,callFunc:Function,slider:CompoundItemSlider):void
		{
			_head=head;
			_type=data.type;
			_type2=data.type2;
			addChild(head);
			head.txt.mouseEnabled=false;
			
			changeHeadNumTxt(data);
			head.addEventListener(MouseEvent.CLICK,headClickHandler,false,0,true);
			var arr:Vector.<CombineData>=data.combineVec;
			var len:int=arr.length;
			
			if(len>0)
			{
				_list2 = createList(callFunc,setCallback);
				_list2.slider = slider;
				setMaterialData(arr);
				if(showContent)
				{
					addChild(_list2);
				}
				_list2.x = (head.width-_list2.width)/2;
				_list2.y = head.height;
			}
		}
		
		private function changeHeadNumTxt(data:CombineType2Data):void
		{
			if(data.canCombineNum>0)
			{
				_head.numTxt.text=StringUtil.substitute(StringConst.NUM_MSG,data.canCombineNum);
			}
			else
			{
				_head.numTxt.text="";
				/*if(isShowCombine)
				{
					var head:MovieClip=_headVec[i];
					this.removeChild(head);
				}*/
			}
		}
		
		public function changNum(data:CombineType2Data):void
		{
			changeHeadNumTxt(data);
			_list2.changeNum(data.combineVec)
		}
		
		private function headClickHandler(event:MouseEvent):void
		{
			if(_list2)
			{
				if(showContent)
				{
					showContent=false;
					this.removeChild(_list2);
				}
				else
				{
					showContent=true;
					this.addChild(_list2);
				}
				((this.parent) as ListFolder).updatePos();
			}
		}
		
		//获取合成材料
		/*private function getCombine(type:int,type2:int):Array
		{
			var dic:Dictionary=ConfigDataManager.instance.combineData(type);
			var arr:Array=[];
			for each(var comboineMsg:CombineCfgData in dic)
			{
				if(comboineMsg.distinguish==type2)
				{
					arr.push(comboineMsg);
				}
			}
			return arr;
		}*/
		
		private function setMaterialData(list:Vector.<CombineData>):void
		{
			_list2.data = list;
		}
		//计算数量
		public function computerNum():void
		{
			var curNum:int;
			var id:int;
			var bagBindNum:int;
			var heroBindNum:int;
			var bagUnbindNum:int;
			var heroUnbindNum:int;
			var needNum:int;//一次合成需要数量
			var combineNum:int;//各材料可合成次数
			_totalNum=0;
			for each(var data:CombineCfgData in _dataList)
			{
				combineNum=0;
				bagBindNum=_bagManager.getItemNumById(data.material1_id,ConstBind.HAS_BIND);
				heroBindNum=_heroManager.getItemNumById(data.material1_id,ConstBind.HAS_BIND);
				bagUnbindNum=_bagManager.getItemNumById(data.material1_id,ConstBind.NO_BIND);
				heroUnbindNum=_heroManager.getItemNumById(data.material1_id,ConstBind.NO_BIND);
				needNum=data.material1_count+data.material2_count+data.material3_count;
				if(bagBindNum>=needNum)
				{
					combineNum=Math.floor(bagBindNum/needNum);
				}
				else if(heroBindNum>=needNum)
				{
					combineNum=Math.floor(heroBindNum/needNum);
				}
				else if(bagUnbindNum>=needNum)
				{
					combineNum=Math.floor(bagUnbindNum/needNum);
				}
				else if(heroUnbindNum>=needNum)
				{
					combineNum=Math.floor(heroUnbindNum/needNum);
				}
				
				_materialNumList.push(combineNum);
				_totalNum+=combineNum;
			}
			
			//changeTxt();
			//changeListTxt();
			//_getcombineNum(_totalNum);
		}
		
		private function createList(clickCallback:Function,setCallback:Function):List2
		{
			var list:List2 = new List2();
			list.setStyle(McCompoundItemCell,setCallback,null);
			list.clickCallback = clickCallback;
			return list;
		}
		
		private function clickCall():void
		{
			_itemClickFunc();
		}
		
		private function setCallback(index:int,data:Object,item:MovieClip):void
		{
			var color:int = 0xffe1aa;
			item.txt.htmlText = HtmlUtils.createHtmlStr(color,data.name);
		}
		
		public function cancelSelectedIndex():void
		{
			_list2.selectedIndex = -1;
		}
	}
}