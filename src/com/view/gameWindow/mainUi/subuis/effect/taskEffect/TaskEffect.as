package com.view.gameWindow.mainUi.subuis.effect.taskEffect
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.EffectConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.npctask.NpcTaskPanelData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class TaskEffect extends MainUi implements ITaskEffect, IUrlSwfLoaderReceiver,IObserver
	{
		private var _typeEffect:String = "";
		private var _urlSwfLoader:UrlSwfLoader;
		private var _taskCompleteEffect:MovieClip;
		private var _taskReceiveEffect:MovieClip;
		private var timer:int = 0;
		private var showReceiveEffect:Boolean;
		
		public function TaskEffect()
		{
			super();
			TaskDataManager.instance.attach(this);
		}
		
		public function showCompleteEffect():void
		{
			if(_taskCompleteEffect && _taskCompleteEffect.parent)
			{
				return;
			}
			_typeEffect = EffectConst.RES_COMPLETE_TASKL;
			destroyLoader();
			if(_taskCompleteEffect)
			{
				if(_taskCompleteEffect.parent)
				{
					_taskCompleteEffect.parent.removeChild(_taskCompleteEffect);
				}
				_taskCompleteEffect.stop();
			}
			load();
		}
		
		override public function initView():void
		{
			
		}
		
		private function load():void
		{
			if(!_urlSwfLoader)
			{
				_urlSwfLoader = new UrlSwfLoader(this);
				var url:String = ResourcePathConstants.IMAGE_EFFECT_FOLDER_LOAD + _typeEffect;
				_urlSwfLoader.loadSwf(url);
			}
		}
		
		public function update(proc:int=0):void
		{
			if(TaskDataManager.instance._hasReceiveTask)
			{
//				showRecceiveEffect();
				showReceiveEffect = true;
				TaskDataManager.instance._hasReceiveTask = false;
			}
			if(TaskDataManager.instance._hasSubmitTask)
			{
				showCompleteEffect();
				resetTime();
				showRollTip();
				TaskDataManager.instance._hasSubmitTask = false;
			}
		}
		
		
		public function showRecceiveEffect():void
		{
			if(_taskReceiveEffect && _taskReceiveEffect.parent)
			{
				return;
			}
			_typeEffect = EffectConst.RES_RECEIVE_TASK;
			destroyLoader();
			if(_taskReceiveEffect)
			{
				if(_taskReceiveEffect.parent)
				{
					_taskReceiveEffect.parent.removeChild(_taskReceiveEffect);
				}
				_taskReceiveEffect.stop();
			}
			load();
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			var effect:MovieClip;
			effect = swf.getChildAt(0) as MovieClip;
			effect.mouseChildren = false;
			effect.mouseEnabled = false;
			effect.x = 0;
			effect.y = 0;
			effect.addFrameScript(effect.totalFrames-1,fun);
			function fun():void
			{
				effect.parent.removeChild(effect);
				effect.stop();
				if(showReceiveEffect)
				{
					showRecceiveEffect();
					showReceiveEffect = false;
				}
			}
			addChild(effect);
			if(_typeEffect == EffectConst.RES_COMPLETE_TASKL)
			{
				_taskCompleteEffect = effect;
			}
			else if(_typeEffect == EffectConst.RES_RECEIVE_TASK)
			{
				_taskReceiveEffect = effect;
			}
			destroyLoader();
		}
		
		private function destroyLoader():void
		{
			if(_urlSwfLoader)
			{
				_urlSwfLoader.destroy();
				_urlSwfLoader = null;
			}
		}
		
		private function showRollTip():void
		{
			var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(NpcTaskPanelData.taskId);
			var color:uint;
			var string:String;
			if(!taskCfgData)
			{
				trace("--------------TaskEffect任务ID配置错误-------------------");
				return;
			}
			/*if(taskCfgData.exp)
			{
				color = ItemType.itemTypeColor(ItemType.IT_EXP);
				string = HtmlUtils.createHtmlStr(color,ItemType.itemTypeName(ItemType.IT_EXP) + taskCfgData.exp,20);
				UtilsTimeOut.dealTimeOut(string,timer);
				timer += 500;
			}
			if(taskCfgData.gold_unbind)
			{
				color = ItemType.itemTypeColor(ItemType.IT_GOLD);
				string = HtmlUtils.createHtmlStr(color,ItemType.itemTypeName(ItemType.IT_GOLD) + taskCfgData.gold_unbind,20);
				UtilsTimeOut.dealTimeOut(string,timer);
				timer += 500;
			}
			if(taskCfgData.gold_bind)
			{
				color = ItemType.itemTypeColor(ItemType.IT_GOLD_BIND);
				string = HtmlUtils.createHtmlStr(color,ItemType.itemTypeName(ItemType.IT_GOLD_BIND) + taskCfgData.gold_bind,20);
				UtilsTimeOut.dealTimeOut(string,timer);
				timer += 500;
			}
			if(taskCfgData.coin_unbind)
			{
				color = ItemType.itemTypeColor(ItemType.IT_MONEY);
				string = HtmlUtils.createHtmlStr(color,ItemType.itemTypeName(ItemType.IT_MONEY) + taskCfgData.coin_unbind,20);
				UtilsTimeOut.dealTimeOut(string,timer);
				timer += 500;
			}
			if(taskCfgData.coin_bind)
			{
				color = ItemType.itemTypeColor(ItemType.IT_MONEY_BIND);
				string = HtmlUtils.createHtmlStr(color,ItemType.itemTypeName(ItemType.IT_MONEY_BIND) + taskCfgData.coin_bind,20);
				UtilsTimeOut.dealTimeOut(string,timer);
				timer += 500;
			}*/
			NpcTaskPanelData.taskId = 0;
		}
		
		private function resetTime():void
		{
			if(!RollTipMediator.instance.rewards.length)
			{
				timer = 0;
			}
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
		}
		
		public function swfError(url:String, info:Object):void
		{
			destroyLoader();
		}
	}
}