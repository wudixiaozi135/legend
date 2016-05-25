package com.view.gameWindow.panel.panels.activitys.seaFeast
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.cfgdata.ActivitySeaFeastCfgData;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.pattern.Observer.IObserverEx;
    import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.cooldown.CoolDownEffect;
    import com.view.newMir.NewMirMediator;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
	 * 塔防副本按钮面板类
	 * @author Administrator
	 */	
	public class PanelSeaFeastBtns extends PanelBase implements IObserverEx
	{
		private var _coolDownEffects:Vector.<CoolDownEffect>;
		
		public function PanelSeaFeastBtns()
		{
			super();
            canEscExit = false;
			ActivityDataManager.instance.seaFeastDataManager.attach(this);
			//
			_coolDownEffects = new Vector.<CoolDownEffect>(SeaFeastDataManager.NUM_BTNS,true);
		}
		
		override protected function initSkin():void
		{
			var skin:McSeaFeastBtns = new McSeaFeastBtns();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var i:int,l:int = SeaFeastDataManager.NUM_BTNS;
			for (i=0;i<l;i++) 
			{
				var btn:MovieClip = skin["btn"+i] as MovieClip;
				rsrLoader.addCallBack(btn,callBack(i));
			}
		}
		
		private function callBack(index:int):Function
		{
			var fun:Function = function(mc:MovieClip):void
			{
				ToolTipManager.getInstance().detach(mc);
				ToolTipManager.getInstance().attachByTipVO(mc,ToolTipConst.TEXT_TIP,getTipText(index));
			};
			return fun;
		}
		
		private function getTipText(index:int):String
		{
			var cfgDt:ActivitySeaFeastCfgData = ActivityDataManager.instance.seaFeastDataManager.seaFeastCfgData;
			var str:String;
			if(index == SeaFeastDataManager.BTNS_SUNBATHE)
			{
				var ratio:Number = cfgDt.lay_exp_ratio*.01;
				str = StringConst.SEA_FEAST_0005.replace("&x",ratio);
			}
			else if(index == SeaFeastDataManager.BTNS_FOOTSIE)
			{
				str = StringConst.SEA_FEAST_0006.replace("&x",cfgDt.free_tease_count);
			}
			else if(index == SeaFeastDataManager.BTNS_MASSAGE)
			{
				str = StringConst.SEA_FEAST_0007.replace("&x",cfgDt.push_oil_time).replace("&y",cfgDt.free_push_oil_count);
			}
			else
			{
				str = StringConst.SEA_FEAST_0008.replace("&x",cfgDt.free_watermelon_count);
			}
			return str;
		}
		
		override protected function initData():void
		{
			updateBtnRemainNum();
			skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		/*private function updateBtnTip():void
		{
			var i:int,l:int = SeaFeastDataManager.NUM_BTNS;
			for (i=1;i<l;i++)
			{
				var mc:MovieClip = skin["btn"+i] as MovieClip;
				ToolTipManager.getInstance().detach(mc);
				ToolTipManager.getInstance().attachByTipVO(mc,ToolTipConst.TEXT_TIP,getTipText(index));
			}
		}*/
		
		private function updateBtnRemainNum():void
		{
			var manager:SeaFeastDataManager = ActivityDataManager.instance.seaFeastDataManager;
			var i:int,l:int = SeaFeastDataManager.NUM_BTNS;
			for (i=0;i<l;i++)
			{
				var num:int = manager.arrayRemainTotal[i];
				var txt:TextField = skin["txt"+i] as TextField;
				txt.text = num != int.MAX_VALUE ? (num < 0 ? "0" : (num + "")) : "";
				txt.mouseEnabled = false;
				var defaultTextFormat:TextFormat = txt.defaultTextFormat;
				defaultTextFormat.bold = true;
				txt.defaultTextFormat = defaultTextFormat;
				txt.setTextFormat(defaultTextFormat);
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				default:
					break;
				case skin.btn0:
					dealBtn(SeaFeastDataManager.BTNS_SUNBATHE);
					break;
				case skin.btn1:
					dealBtn(SeaFeastDataManager.BTNS_FOOTSIE);
					break;
				case skin.btn2:
					dealBtn(SeaFeastDataManager.BTNS_MASSAGE);
					break;
				case skin.btn3:
					dealBtn(SeaFeastDataManager.BTNS_WATERMELON);
					break;
			}
		}
		
		private function dealBtn(index:int):void
		{
			ActivityDataManager.instance.seaFeastDataManager.dealBtnClick(index);
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_ACTIVITY_SEA_SIDE_INFO)
			{
				updateBtnRemainNum();
			}
		}
		
		public function updateData(proc:int, data:*):void
		{
			if(proc == SeaFeastDataManager.PROC_SHOW_CD)
			{
				var index:int = int(data);
				var manager:SeaFeastDataManager = ActivityDataManager.instance.seaFeastDataManager;
				var btn:MovieClip = skin["btn"+index] as MovieClip;
				if(!btn.hasOwnProperty("resUrl"))
				{
					var remainCDTime:int = manager.remainCDTime(index);
					if(!_coolDownEffects[index])
					{
						_coolDownEffects[index] = new CoolDownEffect();
					}
					_coolDownEffects[index].play(btn,remainCDTime,-90);
				}
			}
		}
		
		override public function setPostion():void
		{
			x =(NewMirMediator.getInstance().width - _skin.width)*.5;
			y = NewMirMediator.getInstance().height - 190 - _skin.height;
		}
		
		override public function destroy():void
		{
			var coolDownEffect:CoolDownEffect;
			for each(coolDownEffect in _coolDownEffects)
			{
				if(_coolDownEffects[index])
				{
					_coolDownEffects[index].stop();
				}
			}
			_coolDownEffects = null;
			var manager:SeaFeastDataManager = ActivityDataManager.instance.seaFeastDataManager;
			var i:int,l:int = SeaFeastDataManager.NUM_BTNS;
			for (i=0;i<l;i++) 
			{
				var btn:MovieClip = skin["btn"+i] as MovieClip;
				ToolTipManager.getInstance().detach(btn);
			}
			ActivityDataManager.instance.seaFeastDataManager.detach(this);
			super.destroy();
		}
	}
}