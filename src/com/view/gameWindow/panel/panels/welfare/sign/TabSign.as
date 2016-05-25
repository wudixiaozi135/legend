package com.view.gameWindow.panel.panels.welfare.sign
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.welfare.MCSign;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
    import com.view.gameWindow.util.tabsSwitch.TabBase;

    public class TabSign extends TabBase
	{
		internal var viewHandle:SignViewHandle;
		internal var mouseHandle:SignMouseHandle;
		public function TabSign()
		{
			super();
		}
		
		
		override protected function initSkin():void
		{
	    	var skin:MCSign = new MCSign;
			_skin = skin;
			addChild(skin);
			
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			viewHandle = new SignViewHandle(this);
			viewHandle.init(rsrLoader);
			mouseHandle = new SignMouseHandle(this);
			mouseHandle.init(rsrLoader);	
			
		}
 
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_QUERY_SIGN:
				case GameServiceConstants.CM_SIGN:
				case GameServiceConstants.CM_FILL_SIGN:
					//viewHandle.refreshAward();
//					viewHandle.rerfresh();
					var awardIndex:int = WelfareDataMannager.instance.awardIndex;
					mouseHandle.dealBtn(awardIndex);
					break;
				case GameServiceConstants.CM_GET_SIGN_REWARD:
				{
					viewHandle.flyAward();
					//viewHandle.refreshAward();
					//viewHandle.rerfresh();
				}
					
			}
			 
		}
		
		
		override public function destroy():void
		{

			viewHandle.destroy();
			mouseHandle.destroy();
			viewHandle = null;
			mouseHandle = null;
			super.destroy();
		}
 
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			WelfareDataMannager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			WelfareDataMannager.instance.detach(this);
			super.detach();
		}
		
	}
}