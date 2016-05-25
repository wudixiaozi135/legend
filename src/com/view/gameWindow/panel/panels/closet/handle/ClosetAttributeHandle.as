package com.view.gameWindow.panel.panels.closet.handle
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ClosetCfgData;
	import com.model.consts.RolePropertyConst;
	import com.view.gameWindow.panel.panels.closet.ClosetData;
	import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
	import com.view.gameWindow.panel.panels.closet.McClosetPanel;
	import com.view.gameWindow.util.NumPic;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.propertyParse.PropertyData;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * 衣柜属性处理类
	 * @author Administrator
	 */	
	public class ClosetAttributeHandle
	{
		private var _mc:McClosetPanel;
		
		public function ClosetAttributeHandle(mc:McClosetPanel)
		{
			_mc = mc;
		}
		
		public function refresh():void
		{
			var currentClosetData:ClosetData = ClosetDataManager.instance.currentClosetData();
			
			if(!currentClosetData)
			{
				return;
			}
			_mc.mcName.gotoAndStop(currentClosetData.frame);
			if(_mc.btnPutIn.txt)
				_mc.btnPutIn.txt.text = currentClosetData.textPutInBtn;
			if(!currentClosetData.level)
			{
				_mc.mcLevel.visible = false;
			}
			else
			{
				_mc.mcLevel.visible = true;
				_mc.mcLevel.gotoAndStop(currentClosetData.level);
			}
			//根据衣柜等级去衣柜配置表取数据刷新属性信息
			var closetCfgData:ClosetCfgData = ConfigDataManager.instance.closetCfgData(currentClosetData.type,currentClosetData.level);
			var nextClosetCfgData:ClosetCfgData = ConfigDataManager.instance.closetCfgData(currentClosetData.type,currentClosetData.level+1);
			//
			var num:int = CfgDataParse.getFightPower(closetCfgData.attr);
			/*_mc.txtFightPower1.text = num + "";*/
			var numPic:NumPic = new NumPic();
			numPic.init("fight_",num+"",_mc.mcFighter);
			//
			if(nextClosetCfgData)
			{
				var dAtt:Vector.<PropertyData> = CfgDataParse.getDAttStringArray(closetCfgData.attr,nextClosetCfgData.attr);
			}
			var attStringArray:Vector.<PropertyData> = CfgDataParse.getPropertyDatas(closetCfgData.attr);
			var i:int,l:int = 7;
			for(i=0;i<l;i++)
			{
				if(i < attStringArray.length)
				{
					var propertyData:PropertyData = attStringArray[i];
					(_mc["txtClosetAttribute"+i+"0"] as TextField).text = propertyData.name+"：";
					var strValue:String = propertyData.type == RolePropertyConst.PERCENT_TYPE ? CfgDataParse.getPercentValue(propertyData.value)+"%" : propertyData.value+"";
					(_mc["txtClosetAttribute"+i+"1"] as TextField).text = strValue;
					if(dAtt)
					{
						(_mc["mcEnhance"+i+"0"] as MovieClip).visible = true;
						var value:Number = dAtt[i].value;
						if(value)
						{
							//修改所有提升都使用文本显示
							/*if(value == int(value))
							{
								numPic = new NumPic();
								numPic.init("green_",value+"",_mc["mcEnhance"+i]);
								(_mc["mcEnhance"+i+"1"] as MovieClip).visible = true;
								(_mc["mcEnhance"+i] as MovieClip).visible = true;
							}
							else
							{*/
								strValue = dAtt[i].type == RolePropertyConst.PERCENT_TYPE ? CfgDataParse.getPercentValue(value)+"%" : value+"";
								(_mc["txtEnhance"+i] as TextField).text = strValue;
								(_mc["mcEnhance"+i+"1"] as MovieClip).visible = false;
								(_mc["mcEnhance"+i] as MovieClip).visible = false;
							/*}*/
						}
						else
						{
							(_mc["mcEnhance"+i+"0"] as MovieClip).visible = false;
							(_mc["mcEnhance"+i+"1"] as MovieClip).visible = false;
							(_mc["mcEnhance"+i] as MovieClip).visible = false;
							(_mc["txtEnhance"+i] as TextField).text = "";
						}
					}
					else
					{
						(_mc["mcEnhance"+i+"0"] as MovieClip).visible = false;
						(_mc["mcEnhance"+i+"1"] as MovieClip).visible = false;
						(_mc["mcEnhance"+i] as MovieClip).visible = false;
						(_mc["txtEnhance"+i] as TextField).text = "";
					}
				}
				else
				{
					(_mc["txtClosetAttribute"+i+"0"] as TextField).text = "";
					(_mc["txtClosetAttribute"+i+"1"] as TextField).text = "";
					(_mc["mcEnhance"+i+"0"] as MovieClip).visible = false;
					(_mc["mcEnhance"+i+"1"] as MovieClip).visible = false;
					(_mc["mcEnhance"+i] as MovieClip).visible = false;
					(_mc["txtEnhance"+i] as TextField).text = "";
				}
			}
			var gorgeousLevel:int,gorgeousMax:int;
			//刷新华丽度
			gorgeousLevel = currentClosetData.gorgeousLevel;
			gorgeousMax = closetCfgData.stylish;
			_mc.txtGorgeousLevel.text = gorgeousLevel+"/"+gorgeousMax;
			(_mc.mcGorgeousLevel.mcMask as MovieClip).scaleX = gorgeousLevel/gorgeousMax;
		}
		
		public function destroy():void
		{
			_mc = null;
		}
	}
}