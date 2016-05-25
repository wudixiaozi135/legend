package com.view.gameWindow.flyEffect.subs
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.view.gameWindow.flyEffect.FlyEffectBase;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subuis.tasktrace.TaskTrace;
	import com.view.gameWindow.util.UrlPic;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class FlyEffectSpeciaToTask extends FlyEffectBase
	{
		
		private var urlPic:UrlPic;
		public function FlyEffectSpeciaToTask(layer:Sprite)
		{
			super(layer);
		}
		
		private function initialize():void
		{
			var bm:Sprite=new Sprite();
			target=bm;
			urlPic=new UrlPic(bm,function ():void
			{
				var taskTrack : TaskTrace=MainUiMediator.getInstance().taskTrace as TaskTrace
				if(taskTrack.items.length>0)
				{
					toLct=taskTrack.items[0].icon.localToGlobal(new Point(0,0));
				}else
				{
					toLct= taskTrack.localToGlobal(new Point(145,65));
				}
				duration=2;
				FlyEffectMediator.instance.isDoFiy=true;
				fly();
				TweenLite.to(target,duration,{width:26,height:26});
			});
			urlPic.load(ResourcePathConstants.IMAGE_ICON_SKILL_FOLDER_LOAD+"9011"+ResourcePathConstants.POSTFIX_PNG);
		}
		
		public function setFpointAndFly(fPoint:Point):void
		{
			
			fromLct=fPoint;
			initialize();
		}
		
		override protected function onComplete():void
		{
			var taskTrack : TaskTrace=MainUiMediator.getInstance().taskTrace as TaskTrace;
			FlyEffectMediator.instance.isDoFiy=false;
			taskTrack.itemIconVisible=true;
			urlPic.destroy();
			
			super.onComplete();
		}
	}
}