package com.view.gameWindow.panel.panels.guideSystem.unlock
{
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * @author wqhk
	 * 2014-12-23
	 */
	public class UIUnlockHandler
	{
		private static var _grayFilter:ColorMatrixFilter;
		private var _unlockObserver:UnlockObserver;
		private var _getUIFunc:Function;
		private var _hideType:int;
		private var _updateCallback:Function;
		
		/**
		 * @param hideType 0 无,  1 visible, 2 filter
		 * @getUIFunc  func(id:int):DisplayObject or func(id:int):Array
		 * @updateCallback 解锁状态发生变化时调用
		 */
		public function UIUnlockHandler(getUIFunc:Function,hideType:int = 1,updateCallback:Function = null)
		{
			_getUIFunc = getUIFunc;
			_hideType = hideType;
			_updateCallback = updateCallback;
			_unlockObserver = new UnlockObserver();
			_unlockObserver.setCallback(updateUIState);
			GuideSystem.instance.unlockStateNotice.attach(_unlockObserver);
			
			if(hideType == 2 && !_grayFilter)
			{
				
				_grayFilter = new ColorMatrixFilter();
				_grayFilter.matrix = [	0.15,0.15,0.15,0,0,
										0.15,0.15,0.15,0,0,
										0.15,0.15,0.15,0,0,
										0,0,0,1,0];
			}
		}
		
		public function updateUIStates(ids:Array):void
		{
			for each(var id:int in ids)
			{
				updateUIState(id);
			}
		}
		
		public function updateUIState(id:int):void
		{
			if(_hideType != 0 && _getUIFunc != null)
			{
				var data:* = _getUIFunc(id);
				
				if(!data)
				{
					return;
				}
				
				var list:Array = null;
				if(data is Array)
				{
					list = data;
				}
				else
				{
					list = [data];
				}
				
				var ui:DisplayObject = null;
				
				for each(ui in list)
				{
					if(ui)
					{
						var isUnlock:Boolean = GuideSystem.instance.isUnlock(id);
						if(_hideType == 1)
						{
							ui.visible = isUnlock;
						}
						else if(_hideType == 2)
						{
							ui.filters = isUnlock ? null : [_grayFilter];
						}
					}
				}
			}
			
			if(_updateCallback != null)
			{
				_updateCallback(id);
			}
		}
		
		public function onClickUnlock(id:int):Boolean
		{
			if(!GuideSystem.instance.isUnlock(id))
			{
				var tip:String = GuideSystem.instance.getUnlockTip(id);
				Alert.warning(tip);
				return false;
			}
			
			return true;
		}
		
		public function destroy():void
		{
			_getUIFunc = null;
			if(_unlockObserver)
			{
				GuideSystem.instance.unlockStateNotice.detach(_unlockObserver);
				_unlockObserver.destroy();
				_unlockObserver = null;
			}
		}
	}
}