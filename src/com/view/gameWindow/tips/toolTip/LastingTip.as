package com.view.gameWindow.tips.toolTip
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.util.HtmlUtils;

	public class LastingTip extends BaseTip
	{
		public function LastingTip()
		{
			super();
			_skin = new BigTextTipSkin();
			addChild(_skin);
			initView(_skin);
		}
		
		override public function setData(obj:Object):void
		{
			_data=obj;
			var title:String=HtmlUtils.createHtmlStr(0xff6600,StringConst.LASTING_STRING_0001);
			addProperty(title,16,10);
			maxHeight=30;
			
			var eqArr:Array=obj as Array;
			var roleA:Array=[];
			var heroA:Array=[];
			for each(var tmp:Object in eqArr)
			{
				var color:int=0xffcc00;
				if(tmp.num1==0)
				{
					color=0xff0000;
				}
				var tmpstr:String=HtmlUtils.createHtmlStr(color,tmp.name+"      ("+tmp.num1+"/"+tmp.num2/100+")");
				if(tmp.type==EntityTypes.ET_PLAYER)
				{
					roleA.push(tmpstr);
				}else
				{ 
					heroA.push(tmpstr);
				}
			}
			if(roleA.length>0)
			{
				maxHeight+=12;
				var t1:String=HtmlUtils.createHtmlStr(0x00a2ff,StringConst.STRENGTH_PANEL_0001);
				addProperty(t1,16,maxHeight);
				maxHeight+=18;
			}
			
			while(roleA.length>0)
			{
				var rs:String=roleA.shift();
				addProperty(rs,16,maxHeight);
				maxHeight+=18;
			}
			
			if(heroA.length>0)
			{
				maxHeight+=12;
				var t2:String=HtmlUtils.createHtmlStr(0x00a2ff,StringConst.STRENGTH_PANEL_0002);
				addProperty(t2,16,maxHeight);
				maxHeight+=18;
			}
			
			while(heroA.length>0)
			{
				var hs:String=heroA.shift();
				addProperty(hs,16,maxHeight);
				maxHeight+=18;
			}
			
			maxHeight+=14;
			var boom:String=HtmlUtils.createHtmlStr(0xff6600,StringConst.LASTING_STRING_0002);
			addProperty(boom,16,maxHeight);
			maxHeight+=32;
			width=250;
			maxHeight+=10;
			height=maxHeight;
		}
	}
}