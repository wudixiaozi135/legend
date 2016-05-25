package com.view.gameWindow.tips.toolTip
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipPolishCfgData;
	import com.model.consts.ConstStarsFlag;
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * 锻造进度tip
	 * @author jhj
	 */
	public class ForgeProgressTip extends BaseTip
	{
		private var memEquipData:MemEquipData;
		private var equipCfgData:EquipCfgData;
		private var equipPolishCfgData:EquipPolishCfgData;
		
		public function ForgeProgressTip()
		{
			super();
			initView(_skin);
		}
		
		override public function setData(obj:Object):void
		{
		    _data = obj;
			memEquipData = obj as MemEquipData;
			if(!memEquipData)
				return;
			equipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData)
				return;
			equipPolishCfgData = ConfigDataManager.instance.equipPolishCfgData(memEquipData.polish+1);
			if(!equipPolishCfgData)
				return;
			setForgeValue();
			setPolishValue();
			/*setStars();*/
			setTip();
			width = maxWidth;
		}
		
		override protected function addCallBack(mc:MovieClip, rsrLoader:RsrLoader):void
		{
			if(mc is Stars)
			{
				rsrLoader.addCallBack(mc.star,function():void
				{
					mc.star.gotoAndStop(mc.name);
				});
			}
			
			rsrLoader.addCallBack(_skin.forgProgressBa,function():void
			{
				if(memEquipData && equipPolishCfgData)
				{
					_skin.forgProgressBa.width = 156*(memEquipData.polishExp/equipPolishCfgData.max_exp);
				}
			});
		}
		
		private function setForgeValue():void
		{
			var htmlStr:String = HtmlUtils.createHtmlStr(0xd4a460,StringConst.CURRENT_FORGE_VALUE+": "+equipCfgData.name);
			htmlStr += " " + HtmlUtils.createHtmlStr(0xd4a460,memEquipData.polishExp+"/"+equipPolishCfgData.max_exp);
			var tf:TextField = addText(htmlStr,25,25);
			maxWidth = tf.x+tf.textWidth+230;
			
			htmlStr = HtmlUtils.createHtmlStr(0xd4a460,StringConst.FORGE_VALUE_STRING+": "+memEquipData.polishExp+"/"+equipPolishCfgData.max_exp);
			addText(htmlStr,155,92);
		}
		
		private function setPolishValue():void
		{
			var strPolish:String = HtmlUtils.createHtmlStr(0x00cece,memEquipData.polish+"");
			var strHtml:String = HtmlUtils.createHtmlStr(0xd4a460,StringConst.CURRENT_POLISH_VALUE+strPolish);
			addText(strHtml,25,43);
		}
		
		private function setStars():void
		{
			var strengthen:int = memEquipData.strengthen;
			
			for(var i:int = 0; i<equipCfgData.strengthen; i++)
			{
				var star:Stars = new Stars();
				addChild(star);
				if(i <= strengthen-1)
					star.name = ConstStarsFlag.STAR_FRAME;
				else 
					star.name = ConstStarsFlag.STAR_GREY_FRAME;
				if(i == strengthen)
					star.filters = [BaseTip.GLOW_FILTER];
				star.x = 40+(i-1)*24;
				star.y = 50;
				super.initView(star);
			}
			
			maxWidth = Math.max(maxWidth, equipCfgData.strengthen*24+40);
			maxWidth = Math.max(maxWidth, _skin.forgProgressBa.x+_skin.forgProgressBa.width+80);
		}
		
		private function setTip():void
		{
			var htmlStr:String = HtmlUtils.createHtmlStr(0xff6600,StringConst.TIP_001);
			addText(htmlStr,90,131);
			
			htmlStr = HtmlUtils.createHtmlStr(0xff0000,StringConst.TIP_002);
			addText(htmlStr,40,171);
			
			htmlStr = HtmlUtils.createHtmlStr(0xff0000,StringConst.TIP_004);
			addText(htmlStr,40,195);
			
			htmlStr = HtmlUtils.createHtmlStr(0xff0000,StringConst.TIP_001);
			addText(htmlStr,40,219);
			
			htmlStr = HtmlUtils.createHtmlStr(0xac00ff,StringConst.TIP_003);
			addText(htmlStr,40,243);
			
			height = 263;
		}
		
		private function addText(htmlStr:String, x:int, y:int):TextField
		{
			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.filters = [_filter];
			tf.htmlText = htmlStr;
			tf.x = x;
			tf.y = y;
			filters = [_filter];
			addChild(tf);
			return tf;
		}
		
		override public function initView(mc:MovieClip):void
		{
			_skin = new ForgeProgressTipSkin();
			addChild(_skin);
			super.initView(_skin);
		}
	}
}