package com.view.gameWindow.tips.toolTip
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ConstBind;
	import com.model.consts.ConstSell;
	import com.model.consts.ItemType;
	import com.model.consts.JobConst;
	import com.model.consts.StringConst;
	import com.model.frame.FrameManager;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * 道具tip
	 * @author jhj
	 */
	public class ItemTip extends BaseTip
	{
		private var delayTimeText:TextField;
		private var lastTime:int = 300000;
		/** * 使用条件字段 */		
		private var userConditionArr:Array=[StringConst.LEVEL_NEED,StringConst.JOB_NEED];
		
		public function ItemTip()
		{
			super();
			initView(_skin);
		}
		
		override public function setData(obj:Object):void
		{
			_data = obj;
			
			var bgaData:BagData = obj as BagData;
			
			if(bgaData)
				var itemCfgData:ItemCfgData = ConfigDataManager.instance.itemCfgData(bgaData.id);
			
			if(!itemCfgData)
				return;

			setVariableProperty(bgaData,itemCfgData);
			setDelayTime(itemCfgData.expire);
			maxHeight += 18
			height = maxHeight;
		}
		
		override public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			super.urlBitmapDataReceive(url,bitmapData,info);
			_iconBmp.y = 22.5;
		}
		
		override public function updateTime(time:int):void
		{
			var delayTime:int = lastTime-time;
			lastTime = delayTime;
			if(delayTime <= 0)
			{
				delayTimeText.htmlText = "";
				hide(delayTimeText);
				delayTimeText = null;
				FrameManager.instance.removeObj(this);
				return;
			}
			var min:int = delayTime/60000;
			var sec:int = delayTime/1000%60;
			var htmlStr:String = HtmlUtils.createHtmlStr(0xff0000,StringConst.SURPLUS+min+StringConst.MINIUTE+sec+StringConst.SECOND);
			delayTimeText.htmlText = htmlStr;
		}
		
		private function setVariableProperty(bgaData:BagData,itemCfgData:ItemCfgData):void
		{
			var newUrl:String = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+itemCfgData.icon+ResourcePathConstants.POSTFIX_PNG;
			loadPic(newUrl);
			
			var htmlStr:String = HtmlUtils.createHtmlStr(ItemType.getColorByQuality(itemCfgData.quality),itemCfgData.name,15,true);
			addProperty(htmlStr,104,28);
			htmlStr = HtmlUtils.createHtmlStr(0xffe1aa,"("+ItemType.itemName(itemCfgData.type)+")",12);;
			addProperty(htmlStr,104,50);
			setBind(bgaData.bind);
			
			maxHeight = 85;
			setDes(itemCfgData.desc);
			setUseCondition(itemCfgData);
			setUseMethod(itemCfgData.use_method);
			setSell(bgaData,itemCfgData);
		}
		
		private function setBind(bind:int):void
		{
			if(bind == ConstBind.HAS_BIND)
			{
				var htmlStr:String = HtmlUtils.createHtmlStr(0xff0000,StringConst.TYPE_BIND_2,13);
				addProperty(htmlStr,104,69);	
			}
		}
		
		private function setDelayTime(time:int):void
		{
			if(time>0)
			{
				maxHeight += 10;
				loadSplitLine(20,maxHeight);
				FrameManager.instance.addObj(this);
				maxHeight += 10;
				delayTimeText = new TextField();
				delayTimeText.x = 20;
				delayTimeText.y = maxHeight;
				addChild(delayTimeText);
				maxHeight += delayTimeText.textHeight;
			}
		}
		
		private function setUseCondition(itemCfgData:ItemCfgData):void
		{
			var htmlStrArr:Array = [];
			var htmlStr:String;
			
			for each(var propertyName:String in userConditionArr)
			{
				switch(propertyName)
				{
					case StringConst.LEVEL_NEED:
						if(itemCfgData.level <= 0)
							continue
						var levelStr:String = itemCfgData.reincarn == 0? itemCfgData.level+StringConst.LEVEL : itemCfgData.reincarn+StringConst.REINCARN+itemCfgData.level+StringConst.LEVEL;
						var levelColor:int = RoleDataManager.instance.lv >= itemCfgData.level ? 0x009900 : 0xff0000 ;
						htmlStr = HtmlUtils.createHtmlStr(0xd4a460,StringConst.LEVEL_NEED)+HtmlUtils.createHtmlStr(levelColor," "+levelStr,13);
						htmlStrArr.push(htmlStr);
						break;
					case StringConst.JOB_NEED:
						var job:int = itemCfgData.job;
						var myJob:int = RoleDataManager.instance.job;
						if(job == JobConst.TYPE_NO)
							continue;
						var jobValue:String = JobConst.jobName(job);
						var jobColor:int = myJob== job ? 0x009900:0xff0000 ;
						htmlStr = HtmlUtils.createHtmlStr(0xd4a460,StringConst.JOB_NEED)+HtmlUtils.createHtmlStr(jobColor," "+jobValue,12);
						htmlStrArr.push(htmlStr);
						break;
				}
			}
			
			if(htmlStrArr.length>=1 || itemCfgData.use_method != "")
			{
				maxHeight += 9;
				loadSplitLine(15,maxHeight);
			}
				
			for(var i:int = 0;i<htmlStrArr.length;i++)
			{
				if( i == 0)
					maxHeight += 11;
				
				var tf:TextField = addProperty(htmlStrArr[i],18,maxHeight);
				if(htmlStrArr.length == 1)
				{
					if(itemCfgData.use_method == "")
						maxHeight += tf.textHeight+1;
					else
						maxHeight += tf.textHeight-1;;
				}
				else if(i == htmlStrArr.length-1)
				{
					if(itemCfgData.use_method == "")
					   maxHeight += tf.textHeight+1;
					else
					   maxHeight += tf.textHeight-1;
				}
				else
				{
					maxHeight += tf.textHeight+6; 
				}
			}
		}
		
		private function setUseMethod(useMthod:String):void
		{
			if(useMthod == "")
				return;
			
			var htmlStrArr:Array = CfgDataParse.pareseDes(useMthod,0xffffff);
			
			for (var i:int = 0;i<htmlStrArr.length;i++)
			{
				if(i == 0)
					maxHeight += 11;
				var tf:TextField = addProperty(htmlStrArr[i],18,maxHeight,true);
				if(tf.numLines == 1 && htmlStrArr.length == 1)
					maxHeight = tf.y+tf.textHeight-2;
				else if(i<htmlStrArr.length-1)
					maxHeight = tf.y+tf.textHeight+4;
				else if(tf.numLines == 1)
					 maxHeight = tf.y+tf.textHeight-3;
				else 
					 maxHeight = tf.y+tf.textHeight;
			}
		}
		
		private function setDes(desc:String):void
		{
			if(desc == "")
				return;
			
			var htmlStrArr:Array = CfgDataParse.pareseDes(desc,0xffffff);
			
			if(htmlStrArr.length>0)
				maxHeight += 11;
			
			for (var i:int = 0;i<htmlStrArr.length;i++)
			{
				var desText:TextField = addProperty(htmlStrArr[i],18,maxHeight,true);
				if(desText.numLines == 1 && htmlStrArr.length == 1)
				    maxHeight = desText.y+desText.textHeight-2;
				else if(i<htmlStrArr.length-1)
				    maxHeight = desText.y+desText.textHeight+4;
				else
					maxHeight = desText.y+desText.textHeight;
			}
		}
		
		private function setSell(bagData:BagData,itemCfgData:ItemCfgData):void
		{
			var sellStr:String;
			var sellColor:int;
			var htmlStr:String;
			if(itemCfgData.can_sell == ConstSell.CALL_SELL)
			{
				sellColor = 0x00a2ff;
				sellStr = StringConst.SELL_PRIECE+" "+itemCfgData.sell_value+ConstBind.bindName(bagData.bind)+StringConst.GOLD_COIN;
			}
			else
			{
				sellColor = 0xff0000;
				sellStr = StringConst.NO_SELL;
			}
			htmlStr=HtmlUtils.createHtmlStr(sellColor,sellStr);
			//			addProperty(htmlStr,20,maxHeight);
		}
		
		private function addProperty(htmlStr:String, x:int, y:int ,isSetLeading:Boolean = false):TextField
		{
			var text:TextField = new TextField();
			addChild(text);
			text.width = 250;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.htmlText = htmlStr;
			text.wordWrap = true;
			text.multiline =true;
			text.x = x;
			text.y = y;
			text.filters = [_filter];
			return text;
		}
		
		private function loadSplitLine(x:int, y:int):DelimiterLine
		{
			var splitLine:DelimiterLine = new DelimiterLine();
			addChild(splitLine);
			splitLine.x = x;
			splitLine.y = y;
			super.initView(splitLine);
			return splitLine;
		}
		
		override public function initView(mc:MovieClip):void
		{
			_skin = new PropTipSkin();
			addChild(_skin);
			super.initView(_skin);
		}
	}
}