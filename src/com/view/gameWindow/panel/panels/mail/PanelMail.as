package com.view.gameWindow.panel.panels.mail
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMapProperty;
    import com.view.gameWindow.mainUi.subuis.minimap.MiniMap;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.text.TextFormat;

    /**
	 * 邮件面板类
	 * @author Administrator
	 */	
	public class PanelMail extends PanelBase
	{
		internal var clickHandle:PanelMailClickHandle;
		internal var itemsHandle:PanelMailItemsHandle;
		
		public function PanelMail()
		{
			super();
			PanelMailDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			_skin = new McMail();
			var mcMail:McMail = _skin as McMail;
			initTitle();
			addChild(mcMail);
			setTitleBar(mcMail.dragBox);
		}
		/**画点击区域*/
		private function drawClick(layer:MovieClip,mc:MovieClip):void
		{
			var sprite:Sprite = new Sprite();
			sprite.buttonMode = true;
			sprite.graphics.beginFill(0,0);
			sprite.graphics.drawRect(0,0,mc.width,mc.height);
			sprite.graphics.endFill();
			layer.addChild(sprite);
		}
		
		private function initTitle():void
		{
			var mcMail:McMail = _skin as McMail;
			var defaultTextFormat:TextFormat = mcMail.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			mcMail.txtTitle.defaultTextFormat = defaultTextFormat;
			mcMail.txtTitle.setTextFormat(defaultTextFormat);
			mcMail.txtTitle.text = StringConst.MAIL_PANEL_0001;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mcMail:McMail = _skin as McMail;
			var panelMailAddCallBack:PanelMailAddCallBack = new PanelMailAddCallBack();
			panelMailAddCallBack.addCallBack(rsrLoader,mcMail);
		}
		
		override protected function initData():void
		{
			clickHandle = new PanelMailClickHandle(this);
			itemsHandle = new PanelMailItemsHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			itemsHandle.refresh();
		}

        override public function setPostion():void
        {
            var mc:McMapProperty = (MainUiMediator.getInstance().miniMap as MiniMap).skin as McMapProperty;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnMail.x, mc.btnMail.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override public function destroy():void
		{
			PanelMailDataManager.instance.detach(this);
			if(itemsHandle)
			{
				itemsHandle.destroy();
				itemsHandle = null;
			}
			if(clickHandle)
			{
				clickHandle.destroy();
				clickHandle = null;
			}
			super.destroy();
		}
	}
}