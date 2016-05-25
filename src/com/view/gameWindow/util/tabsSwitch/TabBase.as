package com.view.gameWindow.util.tabsSwitch
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * 标签类
	 * @author Administrator
	 */	
	public class TabBase extends Sprite implements ITabBase
	{
		protected var _skin:MovieClip;
		private var _rsrLoader:RsrLoader;
		public var isSingleton:Boolean = false;
		
		public function TabBase()
		{
			super();
			mouseEnabled = false;
		}
		
		public function get rsrLoader():RsrLoader
		{
			return _rsrLoader;
		}
		/**初始化界面<br>加载图片及SWF资源并刷新界面*/
		public function initView():void
		{
			rsrLoad();
			attach();
			initData();
			update();
		}
		/**初始资源加载*/
		private function rsrLoad():void
		{
			initSkin();
			_rsrLoader = new RsrLoader();
			addCallBack(_rsrLoader);
			_rsrLoader.load(_skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
		}
		/**初始化皮肤<br>初始化数据或添加需要加载资源的元件请在initData中添加*/
		protected function initSkin():void
		{
			//子类重写
			throw new Error(this+"继承自PanelBase，该子类必须覆盖重写initSkin方法");
		}
		/**添加初始资源加载完成的回调函数*/
		protected function addCallBack(rsrLoader:RsrLoader):void
		{
			//有需要子类重写
		}
		/**初始化数据*/
		protected function initData():void
		{
			
		}
		
		/***
		 * 如果界面内有某个元件更新了，可以使用这个方法重新加载一次 
		 * @param mc 需要重新加载的元件
		 * */
		public function loadNewSource(mc:MovieClip):void
		{
			_rsrLoader.loadItemRes(mc);
		}
		
		public function refresh():void
		{
			update();
		}
		
		public function show():void
		{
			attach();
			refresh();
		}
		
		protected function attach():void
		{
			
		}
		
		public function hide():void
		{
			detach();
		}
		
		protected function detach():void
		{
			
		}
		
		public function update(proc:int = 0):void
		{
			
		}
		/**搜索面板中的文本框 */		
		public function searchText(mc:MovieClip,str:String,strLength:int,searchLength:int,sufLeng:int):Vector.<TextField>
		{
			var leng:int = mc.numChildren;
			var index:int;
			var sortTxtArr:Vector.<TextField> = new Vector.<TextField>();
			var txtArr:Vector.<TextField> = new Vector.<TextField>();
			for(var i:int = 0;i<leng;i++)
			{
				var textField:TextField = mc.getChildAt(i) as TextField;
				if(textField)
				{
					var name2:String = textField.name;
					if(name2.substr(strLength,searchLength) == str)
					{
						index = int(name2.substr(searchLength,sufLeng));
						if(txtArr.length < index)
							txtArr.length = index;
						txtArr[index] = textField;
					}
				}
			}
			return txtArr;
		}
		/**由子类继承实现，销毁数据*/		
		public function destroy():void
		{
			hide();
			if(_skin)
			{
				destroySkin(_skin);
				if(_skin.parent)
				{
					_skin.parent.removeChild(_skin);
				}
				_skin = null;
			}
			//
			if(_rsrLoader)
			{
				_rsrLoader.destroy();
				_rsrLoader = null;
			}
		}
		
		private function destroySkin(skin:DisplayObjectContainer):void
		{
			var childLen:int = skin.numChildren; 
			while ( childLen>0)
			{
				var subSkin:DisplayObject = skin.getChildAt(0) as DisplayObject;
				childLen--;
				if (subSkin)
				{
					var subSkinContainer:DisplayObjectContainer = subSkin as DisplayObjectContainer;
					if (subSkinContainer)
					{
						destroySkin(subSkinContainer);
					}
					skin.removeChild(subSkin);
					if (skin.hasOwnProperty(subSkin.name))
					{
						skin[subSkin.name] = null;
					}
				}
			}
		}
		
		public function get skin():MovieClip
		{
			return _skin;
		}
	}
}