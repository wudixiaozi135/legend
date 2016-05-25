package com.view.gameWindow.scene.stateAlert
{
	import com.greensock.TweenMax;
	import com.model.consts.StringConst;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	public class HorizontalAlert
	{
//		private static const _filter:GlowFilter = new GlowFilter(0x111111,0.7,2,2,10,1,false,false);
		private static const _filter:GlowFilter = new GlowFilter(0xac4d00,0.7,8,8,8,BitmapFilterQuality.MEDIUM,false,false);
		
		private var msgArray:Array=[null,null,null,null,null];
		private static var _instance:HorizontalAlert;
		private var tf:TextFormat;
		private var _layer:Sprite;
		
		public static function getInstance() : HorizontalAlert
		{
			if ( ! _instance )
			{
				_instance = new HorizontalAlert();
				_instance.init();
			}
			return _instance;
		}
		
		private function init():void
		{
			tf=new TextFormat();
			tf.size=24;
			tf.align=TextFormatAlign.CENTER;
			tf.font = StringConst.STRING_0001;
		}
		
		public function showMSG(message:String , fontColor:uint=0xfef5e3/*0xffd700*/,cutTime:int=0,limitCount:int=999,isFilther:Boolean = true) : void
		{
			/*trace("·······························显示信息："+message);*/
			/*if (SystemConfigPanelDataManager.getInstance().isShowHint)
			{*/
				
				var count:int=0;
				var i:int;
				for(i=0;i<5;i++)
				{
					if(msgArray[i])
					{
						if(msgArray[i].limitCount==limitCount)
						{
							count++;
						}
					}
				}
				
				if(limitCount<10 && limitCount<=count)
				{
					for(i=0;i<5;i++)
					{
						if(msgArray[i])
						{
							if(msgArray[i].limitCount==limitCount)
							{
								if(_layer.contains(msgArray[i]))
								{
									_layer.removeChild(msgArray[i]);
								}
								msgArray[i].startTime=0;
								msgArray[i].destroy();
								msgArray[i]=null;
								break;
							}
						}
					}
				}
				if(msgArray[0]!=null)
				{
					if(_layer.contains(msgArray[0]))
					{
						_layer.removeChild(msgArray[0]);
					}
					msgArray[0].destroy();
					msgArray[0]=null;
				}
				var newmsg:AlthaChangeTextField=new AlthaChangeTextField();
				newmsg.startTime=getTimer()-cutTime;
				newmsg.textColor=fontColor;
				newmsg.defaultTextFormat=tf;
				newmsg.htmlText = message;
				newmsg.limitCount=limitCount;
				
				newmsg.width=newmsg.textWidth+100;
				moveMsg(newmsg);
				calPosition();
				_layer.addChild(newmsg);
				newmsg.mouseEnabled=false;
				if(isFilther)
				{
					newmsg.filters = [_filter];
				}
				else
				{
					newmsg.filters = [UtilColorMatrixFilters.BLACK_COLOR_FILTER];
					TweenMax.from(newmsg,0.25,{x:(_layer.stage.stageWidth - newmsg.width*2) / 2.0,scaleX:2,scaleY:2,onComplete:onComplete,onCompleteParams:[newmsg]});
				}
//			}
		}
		
		private function onComplete(newmsg:AlthaChangeTextField):void
		{
			TweenMax.killTweensOf(newmsg,true);
			newmsg.x = (_layer.stage.stageWidth - newmsg.width) / 2.0;
		}
		
		public function initData(layer:Sprite):void
		{
			
			_layer = layer;
			init();
		}
		
		private function moveMsg(msgField:AlthaChangeTextField):void
		{
			msgArray[0]=msgArray[1];
			msgArray[1]=msgArray[2];
			msgArray[2]=msgArray[3];
			msgArray[3]=msgArray[4];
			msgArray[4]=msgField;
		}
		
		private function calPosition():void
		{
			for(var i:int=0;i<5;i++)
			{
				if(msgArray[i])
				{
					msgArray[i].x=(_layer.stage.stageWidth - msgArray[i].width) / 2.0;
					msgArray[i].y=i*20+80;
				}
			}
		}
		
		public function enterframe() : void
		{
//			var showText:Boolean = SystemConfigPanelDataManager.getInstance().isShowHint;
			for(var i:int=0;i<5;i++)
			{
				if(msgArray[i])
				{
					msgArray[i].alphaChange(getTimer());
					if(msgArray[i].alpha<0.05 /*|| !showText*/)
					{
						if(_layer.contains(msgArray[i]))
						{
							_layer.removeChild(msgArray[i]);
						}
						msgArray[i].destroy();
						msgArray[i]=null;
					}
				}
			}
		}
		
		public function destroy() : void
		{
		}
	}
	
}

import com.greensock.TweenMax;

import flash.text.TextField;

class AlthaChangeTextField extends TextField
{
	public var startTime:int;
	public static const fullDisplayTime:int=10000;
	public static const alphaChangeTime:int=2000;
	public var limitCount:int=999;
	public function alphaChange(nowTime:int):void
	{
		alpha=1-((nowTime-startTime-fullDisplayTime)/alphaChangeTime);
	}
	
	public function destroy():void
	{
		this.text="";
		this.alpha=1;
		this.visible=false;
		this.limitCount=999;
		TweenMax.killTweensOf(this,true);
	}
}