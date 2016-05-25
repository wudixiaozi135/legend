package com.view.newMir
{
	import com.model.business.fileService.UrlSwfLoader;
	import com.model.business.fileService.interf.IUrlSwfLoaderReceiver;
	import com.model.business.flashVars.FlashVarsManager;
	import com.view.selectRole.ISelectRole;
	
	import flash.display.Sprite;
	
	public class SelectRoleLoader implements IUrlSwfLoaderReceiver
	{
		private var _loader:UrlSwfLoader;
		
		public function SelectRoleLoader()
		{
		}
		
		public function initData():void
		{
			_loader = new UrlSwfLoader(this);
			var selectRole:String = FlashVarsManager.getInstance().selectRole;
			_loader.loadSwf(selectRole);
		}
		
		public function swfReceive(url:String, swf:Sprite, info:Object):void
		{
			var mediator:NewMirMediator = NewMirMediator.getInstance();
			mediator.selectRole = swf as ISelectRole;
			mediator.showSelectRole();
			mediator.hideLoading(mediator.loadSrIndex);
			mediator.loadSrIndex = -1;
			mediator.initGameWindow();
		}
		
		public function swfProgress(url:String, progress:Number, info:Object):void
		{
			var mediator:NewMirMediator = NewMirMediator.getInstance();
			mediator.setLoading(mediator.loadSrIndex,progress);
		}
		
		public function swfError(url:String, info:Object):void
		{
			trace("SelectRoleLoader.swfError 加载失败");
		}
	}
}