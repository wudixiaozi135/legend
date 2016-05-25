package com.view.gameWindow.panel
{
	import com.greensock.TweenLite;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.newMir.NewMirMediator;	

	public class PanelFlyDestHandle
	{
		public function PanelFlyDestHandle()
		{
			mountPanels=new Vector.<PanelBase>();
		}
		
		private var mountPanels:Vector.<PanelBase>;
		private static var _instance:PanelFlyDestHandle;
		private var doing:Boolean=false;
		private var handler:Vector.<PanelBase>;
		
		public static function getInstance():PanelFlyDestHandle
		{
			if(_instance==null)
			{
				_instance=new PanelFlyDestHandle();				
			}
			return _instance;
		}
		
		public function mount(panel:PanelBase):void
		{
			if(mountPanels.indexOf(panel)!=-1)  //如果已经存在，则是在调整位置
			{
				doMount(panel);
				return;
			}
			mountPanels.push(panel);
			/*trace(panel.name+"+mount，count"+mountPanels.length);*/
		}
		/**
		 * 
		 * @param panel
		 */		
		public function panelRunShowMount(panel:PanelBase):void
		{
			panel.alpha=0;
			panel.scaleX=1/panel.width;
			panel.scaleY=1/panel.height;
			panel.x=panel.openX;
			panel.y=panel.openY;
			panel.mouseEnabled=panel.mouseChildren=false;
			/*if(doing==true)
			{
			handler.push(panel);
			return;
			}*/
			panel.moveing=true;
			doMount(panel);
			doing=true;
			TweenLite.to(panel,0.5,{alpha:1,x:panel.flyX,y:panel.flyY,scaleX:1,scaleY:1,onComplete:onOpenComple,onCompleteParams:[panel]});
		}
		
		private function onOpenComple(panel:PanelBase):void
		{
			panel.mouseEnabled = panel.mouseChildren = true;
			panel.moveing = false;
			doing = false;
			/*if(handler.length>0)
			{
			panelRunShowMount(handler.shift());
			return;
			}*/
			doMount(panel);
		}
		/**
		 * 
		 * @param panel
		 * @param isHide 是否调用panel的hide方法
		 */		
		public function panelRunHideMount(panel:PanelBase,isHide:Boolean = false):void
		{
			mountPanels.splice(mountPanels.indexOf(panel),1);
			/*trace(panel.name+"-mount，count"+mountPanels.length);*/
			doMount(panel);
			panel.moveing=true;
			TweenLite.to(panel,0.5,{alpha:0,x:panel.openX,y:panel.openY,scaleX:0.1,scaleY:0.1,onComplete:onCloseComple,onCompleteParams:[panel,isHide]});
		}
		
		private function onCloseComple(panel:PanelBase,isHide:Boolean):void
		{
			panel.moveing=false;
			isHide ? panel.hide() : panel.destroy();
		}
		
		private function doMount(panel:PanelBase):void
		{
//			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
//			for (var i:int=0;i<mountPanels.length;i++)
//			{
//				var newW:Number=newMirMediator.width;
//				var widthc:Number=0;
//				for(var k:int=0;k<mountPanels.length;k++)
//				{
//					newW-=mountPanels[k].getPanelRect().width;
//				}
//				for (var j:int=0;j<i;j++)
//				{
//					widthc+=mountPanels[j].getPanelRect().width;
//				}
//				newW=newW*0.5;
//				mountPanels[i].flyX=newW+widthc;
//				mountPanels[i].flyY=(newMirMediator.height-mountPanels[i].getPanelRect().height)*0.5;
//				mountPanels[i].resetFlyPosInParent();
//				mountPanels[i].doFly();
//			}
			panel.doFly();
		}
	}
}