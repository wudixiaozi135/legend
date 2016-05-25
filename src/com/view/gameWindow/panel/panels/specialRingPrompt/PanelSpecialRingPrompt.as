package com.view.gameWindow.panel.panels.specialRingPrompt
{
	import com.model.consts.EffectConst;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.onhook.AutoSystem;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.util.Cover;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/**
	 * 特级激活提示面板类
	 * @author Administrator
	 */	
	public class PanelSpecialRingPrompt extends PanelBase
	{
		private var _uiEffectLoader:UIEffectLoader;
		/**达到条件激活的戒子id*/
		private var _ringGet:int;
		
		private var _cover:Cover;
		
		public function PanelSpecialRingPrompt()
		{
			super();
			canEscExit = false;
		}
		
		override protected function initSkin():void
		{
			_cover = new Cover(0x000000,.6);
			addChild(_cover);
			var skin:McSpecialRingPrompt = new McSpecialRingPrompt();
			_skin = skin;
			addChild(_skin);
			addEventListener(MouseEvent.CLICK,onClick);
			//
			skin.txtBtn.text = StringConst.SPECIAL_RING_PANEL_0031;
			skin.txtBtn.mouseEnabled = false;
			var defaultTextFormat:TextFormat = skin.txt.defaultTextFormat;
			defaultTextFormat.bold = true;
			defaultTextFormat.size=12;
			skin.txt.defaultTextFormat = defaultTextFormat;
			skin.txt.setTextFormat(defaultTextFormat);
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var desc:String = manager.getDataById(manager.ringGet).specialRingCfgData.desc;
			skin.txt.htmlText = CfgDataParse.pareseDesToStr(desc);

		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McSpecialRingPrompt = _skin as McSpecialRingPrompt;
			if(event.target == skin.btn)
			{
				showFlyEffect();
				PanelMediator.instance.closePanel(PanelConst.TYPE_SPECIAL_RING_PROMPT);
			}
		}
		
		private function showFlyEffect():void
		{
			SpecialRingDataManager.instance.select = _ringGet;
			SpecialRingDataManager.instance.getRing(_ringGet);
			FlyEffectMediator.instance.doFlySpecialRing();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McSpecialRingPrompt = _skin as McSpecialRingPrompt;
			rsrLoader.addCallBack(skin.mcName,function (mc:MovieClip):void
			{
				var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
				mc.gotoAndStop(manager.ringGet);
			});
			
			rsrLoader.addCallBack(skin.btn,function (mc:MovieClip):void
			{
				InterObjCollector.instance.add(mc);
				InterObjCollector.autoCollector.add(mc);
			});
		}
		
		override protected function initData():void
		{
			if(_uiEffectLoader)
			{
				_uiEffectLoader.destroy();
			}
			var skin:McSpecialRingPrompt = _skin as McSpecialRingPrompt;
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			_ringGet = manager.ringGet;
			var cX:int = skin.mcRingLayer.width/2;
			var cY:int = skin.mcRingLayer.height/2;
			var url:String = EffectConst.RES_SPECIAL_RING.replace("&x",_ringGet);
			_uiEffectLoader = new UIEffectLoader(skin.mcRingLayer,cX,cY,1,1,url);
			skin.mcName.gotoAndStop(manager.ringGet);
			
			
			//暂时
			AutoSystem.instance.tempStop = true;
		}
		
		override public function setPostion():void
		{
			super.setPostion();
			_cover.x = -x;
			_cover.y = -y;
		}
		
		override public function destroy():void
		{
			if(_cover)
			{
				if(_cover.parent)
					_cover.parent.removeChild(_cover);
				_cover = null;
			}
			if(_skin)
			{
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				InterObjCollector.instance.remove(_skin.btn);
				InterObjCollector.autoCollector.remove(_skin.btn);
			}
			SpecialRingDataManager.instance.ringGet = 0;
			if(_uiEffectLoader)
			{
				_uiEffectLoader.destroy();
			}
			super.destroy();
		}
	}
}