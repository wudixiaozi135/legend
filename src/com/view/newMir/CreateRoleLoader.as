package com.view.newMir
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.business.flashVars.FlashVarsManager;
	import com.view.createRole.ICreateRole;
	import com.view.gameWindow.util.HttpServiceUtil;
	
	import flash.display.Sprite;
	
	public class CreateRoleLoader implements IUrlSwfLoaderReceiver
	{
		private var _loader:UrlSwfLoader;
		
		public function CreateRoleLoader()
		{
		}
		
		public function initData():void
		{
			_loader = new UrlSwfLoader(this);
			var createRole:String = FlashVarsManager.getInstance().createRole;
			_loader.loadSwf(createRole);
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			var mediator:NewMirMediator = NewMirMediator.getInstance();
			mediator.createRole = swf as ICreateRole;
			mediator.showCreateRole();
			mediator.hideLoading(mediator.loadCrIndex);
			mediator.loadCrIndex = -1;
			mediator.initGameWindow();
			HttpServiceUtil.getInst().sendHttp(HttpServiceUtil.STEP6,1);
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
			var mediator:NewMirMediator = NewMirMediator.getInstance();
			mediator.setLoading(mediator.loadCrIndex,progress);
		}
		
		public function swfError(url:String, info:Object):void
		{
			trace("CreateRoleLoader.swfError 加载失败");
			HttpServiceUtil.getInst().sendHttp(HttpServiceUtil.STEP6,0);
		}
	}
}