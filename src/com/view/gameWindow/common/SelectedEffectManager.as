package com.view.gameWindow.common
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.view.gameWindow.util.UrlPic;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;

	public class SelectedEffectManager extends MouseOverEffectManager
	{
		public function SelectedEffectManager(type:int, width:int, height:int)
		{
			super(type, width, height);
			var bm:Sprite=new Sprite();
			store = new Dictionary(true);
			
			overFilter = new GlowFilter(0xffffff,0.5,8,8,2,1,true,true);
			selectedFilter =  new GlowFilter(0x996100,1,8,8,2,1,true,true);
			
			overEffect = new Shape();
			this.type = type;
			overEffect.graphics.beginFill(0x0,1);
			overEffect.graphics.drawRect(0,0,width,height);
			overEffect.graphics.endFill();
			overEffect.filters = [overFilter];
			
			urlPic = new UrlPic(bm,function():void
			{	
				var ctner:DisplayObjectContainer = null;
				var posX:Number;
				var posY:Number;
				if(selectedEffect && selectedEffect.parent)
				{
					ctner = selectedEffect.parent;
					posX = selectedEffect.x;
					posY = selectedEffect.y;
					removeEffect(selectedEffect);
				}
				selectedEffect = bm.getChildAt(0);
				if(ctner)
				{
					selectedEffect.x = posX;
					selectedEffect.y = posY;
					ctner.addChild(selectedEffect);
				}
			});
			urlPic.load(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "atrifact/selected.png");
		}
	}
}