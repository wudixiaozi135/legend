package com.view.gameWindow.util.tabsSwitch
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/**
	 * 选项卡切换类
	 * @author Administrator
	 */	
	public class TabsSwitch
	{
		private var _layer:DisplayObjectContainer;
		private var _index:int;
		private var _tabs:Vector.<Class>;
		private var _dic:Dictionary;
		
		/**
		 * 构造选项卡切换类
		 * @param layer标签页容器
		 * @param tabs继承自TabBase类的类数组
		 * @param callBack点击按钮切换时回调函数
		 * @param index默认页
		 */		
		public function TabsSwitch(layer:DisplayObjectContainer,tabs:Vector.<Class>,index:int = 0)
		{
			_dic=new Dictionary();
			_layer = layer;
			_layer.mouseEnabled = false;
			_tabs = tabs;
			_index = index;
			init();
		}
		
		private function init():void
		{
			if(!(_layer && _tabs && _tabs.length))
			{
				return;
			}
			addTab(_tabs[_index]);
		}
		
		public function onClick(index:int,bool:Boolean = false):void
		{
			var tabClass:Class = _tabs[index];
			if(!tabClass)
			{
				return;
			}
			var tab:TabBase = addTab(tabClass);
			_index = index;
			if(bool)
			{
				tab.refresh();
			}
		}
		
		private function addTab(tabClass:Class):TabBase
		{
			cleanLayer();
			var tab:TabBase;
			if(_dic[tabClass]!=null)
			{
				tab=_dic[tabClass];
				tab.show();
			}else
			{
				tab = new tabClass();
				if(tab.isSingleton)
				{
					_dic[tabClass]=tab;
				}
				tab.initView();
			}
			_layer.addChild(tab);
			return tab;
		}
		
		public function destroy():void
		{
			while(_tabs && _tabs.length)
			{
				var pop:Class = _tabs.pop();
				var tab:TabBase= _dic[pop];
				if(tab!=null)
				{
					tab.destroy();
				}
				delete _dic[pop];
				tab=null;
			}
			cleanLayer();
		}
		
		private function cleanLayer():void
		{
			while(_layer && _layer.numChildren)
			{
				var display:DisplayObject = _layer.getChildAt(0) as DisplayObject;
				var tab:TabBase = display as TabBase;
				if(tab)
				{
					tab.hide();
					if(tab.isSingleton==false)
					{
						tab.destroy();
					}
					tab.parent&&tab.parent.removeChild(tab);
				}
				else
				{
					display.parent&&display.parent.removeChild(display);
				}
				display = null;
			}
		}
		/**
		 * 获取当前标签页
		 * @return 
		 */
		public function get tab():TabBase
		{
			return _layer.getChildAt(0) ? _layer.getChildAt(0) as TabBase : null;
		}

		public function get index():int
		{
			return _index;
		}
	}
}