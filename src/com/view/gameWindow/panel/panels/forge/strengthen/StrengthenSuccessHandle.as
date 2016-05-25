package com.view.gameWindow.panel.panels.forge.strengthen
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.EffectConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
	import com.view.gameWindow.panel.panels.forge.McIntensify;
	import com.view.gameWindow.util.UIEffectLoader;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class StrengthenSuccessHandle implements IObserver
	{
		private var _tab:TabStrengthen;
		private var _skin:McIntensify;
		
		private var _effectLoader:UIEffectLoader;
		private var timerId:uint;
		private var timer2Id:uint;
		
		public function StrengthenSuccessHandle(tab:TabStrengthen)
		{
			_tab = tab;
			_skin = _tab.skin as McIntensify;
			//
			ForgeDataManager.instance.attach(this);
		}
		
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.CM_EQUIP_STRENGTHEN)
			{
				addEffect();
			}
		}
		
		private function addEffect():void
		{
			if(timerId)
			{
				clearTimeout(timerId);
			}
			if(timer2Id)
			{
				clearTimeout(timer2Id);
			}
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			timerId = setTimeout(function():void
			{
				clearTimeout(timerId);
				if(_effectLoader)
				{
					_effectLoader.destroy();
					_effectLoader = null;
				}
				if(!ForgeDataManager.instance.isSuccess)
				{
					_effectLoader = new UIEffectLoader(_tab,290,-18,1,1,EffectConst.RES_STRENGTH_FAILE);
				}
				else
				{
					_effectLoader = new UIEffectLoader(_tab,290,-18,1,1,EffectConst.RES_STRENGTH_SUCCESS);
				}
				timer2Id = setTimeout(function():void
				{
					clearTimeout(timer2Id);
					if(_effectLoader)
					{
						_effectLoader.destroy();
						_effectLoader = null;
					}
				},1800);
			},200);		
		}
		
		public function destory():void
		{
			clearTimeout(timerId);
			clearTimeout(timer2Id);
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			_skin = null;
			_tab = null;
		}
	}
}