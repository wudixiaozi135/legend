package com.view.gameWindow.panel.panels.forge.extend
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipPolishAttrCfgData;
	import com.model.configData.cfgdata.EquipPolishCfgData;
	import com.model.configData.cfgdata.EquipRefinedCostCfgData;
	import com.model.configData.cfgdata.EquipStrengthenAttrCfgData;
	import com.model.configData.cfgdata.EquipStrengthenCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.AttrRandomData;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.McExtend;
	import com.view.gameWindow.panel.panels.forge.extend.select.ExtendSelectData;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.CellData;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.propertyParse.PropertyData;

	/**
	 * 强化转移面板界面显示处理类
	 * @author Administrator
	 */	
	public class ExtendViewHandle
	{
		private var _panel:TabExtend;
		private var _skin:McExtend;
		internal var costCoin:int;
		internal var isCoinEnough:Boolean;
		
		public function ExtendViewHandle(panel:TabExtend)
		{
			_panel = panel;
			_skin = _panel.skin as McExtend;
			init();
		}
		
		private function init():void
		{
			_skin.txtCost0.text = StringConst.EXTEND_PANEL_0001;
			//
			_skin.txtAttrSP0.text = StringConst.EXTEND_PANEL_0002;
			_skin.txtAttrRd0.text = StringConst.EXTEND_PANEL_0017;
			_skin.txtAttrSP1.text = StringConst.EXTEND_PANEL_0002;
			_skin.txtAttrRd1.text = StringConst.EXTEND_PANEL_0017;
			//
			_skin.txtMoveSP.text = StringConst.EXTEND_PANEL_0009 + StringConst.EXTEND_PANEL_0002;
			_skin.txtMoveRd.text = StringConst.EXTEND_PANEL_0009 + StringConst.EXTEND_PANEL_0017;
			//显示规则及提示信息
			_skin.txtRule.text = StringConst.EXTEND_PANEL_0003;
			/*_mc.txtTip.htmlText = StringConst.EXTEND_PANEL_0004;*/
			_skin.txtMoveRd.visible = _skin.btnMoveRd.visible = false;//隐藏转移随机属性
			_skin.txtMoveSP.visible = _skin.btnMoveSP.visible = false;
		}
		
		public function refresh():void
		{
			updateAttrs();
			updateCost();
		}
		/**跟新强化、打磨、随机属性*/
		private function updateAttrs():void
		{
			var cellData1:CellData = ExtendSelectData.cellData1;
			assignTextSP(cellData1,0);
			assignTextRd(cellData1,0);
			var cellData2:CellData = ExtendSelectData.cellData2;
			assignTextSP(cellData2,1);
			assignTextRd(cellData2,1);
		}
		
		private function assignTextSP(cellData:CellData,index:int):void
		{
			var strs:Vector.<String>,str:String,tempStr:String = "";
			if(cellData)
			{
				strs = getTheStrsSP(cellData);
				for each(str in strs)
				{
					tempStr += str+"\n";
				}
				_skin["txtAttrSPValue"+index].htmlText = tempStr != "" ? tempStr : StringConst.EXTEND_PANEL_0007;
			}
			else
			{
				_skin["txtAttrSPValue"+index].htmlText = "";
			}
		}
		/**获取强化、打磨字符串*/
		private function getTheStrsSP(cellData:CellData):Vector.<String>
		{
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(cellData.bornSid,cellData.id);
			if(!memEquipData)
			{
				return null;
			}
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData)
			{
				return null;
			}
			if(equipCfgData.type != ConstEquipCell.TYPE_XUNZHANG)
			{
				var strengthenAttr:EquipStrengthenAttrCfgData = ConfigDataManager.instance.equipStrengthenAttr(equipCfgData.type,memEquipData.strengthen);
			}
			if(!strengthenAttr)
			{
				return null;
			}
			var equipPolishAttrCfgData:EquipPolishAttrCfgData = ConfigDataManager.instance.equipPolishAttrCfgData(equipCfgData.type,memEquipData.polish);
			var strs:Vector.<String> = new Vector.<String>();
			var filterArr:Array = CfgDataParse.getFilterArr();
			var dtsStrengthen:Vector.<PropertyData> = CfgDataParse.getPropertyDatas(strengthenAttr.attr,true,filterArr);
			var dtsPolish:Vector.<PropertyData> = equipPolishAttrCfgData ? CfgDataParse.getPropertyDatas(equipPolishAttrCfgData.attr) : null;
			var i:int,l:int = dtsStrengthen.length;
			for (i=0;i<l;i++)
			{
				var strStrengthen:String = CfgDataParse.propertyToStr(dtsStrengthen[i],6,0xb4b4b4,0xd4a460,true,true,"&x");
				var arrayStrengthen:Array = strStrengthen.split("&x");
				strStrengthen = arrayStrengthen[0] + " " + HtmlUtils.createHtmlStr(0xd4a460,StringConst.FORGE_PANEL_00011,12,false,6) + arrayStrengthen[1];
				//
				var strPolishAdd:String = equipPolishAttrCfgData ? "[+"+(equipPolishAttrCfgData.attr_rate * .1) + "%]" : "";
				//
				var strPolish:String = "";
				var dtPolish:PropertyData = dtsPolish && i < dtsPolish.length ? dtsPolish[i] : null;
				var index:int = dtPolish ? indexOfProperty(dtPolish.propertyId,dtsStrengthen) : -1
				if(index != -1)
				{
					strPolish = " "+HtmlUtils.createHtmlStr(0x00ffe5,StringConst.POLISH+CfgDataParse.propertyToStr(dtPolish,6,0,0x00ffe5,false));
				}
				var strHtml:String = strStrengthen + HtmlUtils.createHtmlStr(0xd4a460,strPolishAdd) + strPolish;
				strs.push(strHtml);
			}
			return strs;
		}
		
		private function indexOfProperty(propertyId:int,list:Vector.<PropertyData>):int
		{
			var index:int = -1;
			for each(var data:PropertyData in list)
			{
				++index;
				if(data && (propertyId == data.propertyId || (data.isMain && data.propertyId+1 == propertyId)))
				{
					return index;
				}
			}
			return -1;
		}
		
		private function assignTextRd(cellData:CellData,index:int):void
		{
			var i:int,l:int = 6;
			for (i=0;i<l;i++)
			{
				if(cellData && cellData.memEquipData)
				{
					var memEquipData:MemEquipData = cellData.memEquipData;
					var attrRdCount:int = memEquipData.attrRdCount;
					if(i < attrRdCount)
					{
						var attrRdDt:AttrRandomData = memEquipData.attrRdDt(i);
						var attrDt:PropertyData = attrRdDt ? attrRdDt.attrDt : null;
						if(attrRdDt && attrDt)
						{
							var text:String = CfgDataParse.propertyToStr(attrDt,2,0xffcc00,0xffcc00);
							_skin["txtAttrRdValue"+index+i].htmlText = text;
							_skin["txtAttrRdStar"+index+i].text = attrRdDt.star+"";
							_skin["txtAttrRdStar"+index+i].textColor = attrRdDt.starColor;
							var ceil:Number = Math.ceil(attrRdDt.star/3);
							_skin["mcAttrRdStar"+index+i].gotoAndStop(ceil);
							_skin["mcAttrRdStar"+index+i].visible = true;
						}
						else
						{
							clear(StringConst.EXTEND_PANEL_0007);
						}
					}
					else
					{
						clear("");
					}
				}
				else
				{
					clear("");
				}
			}
			function clear(text:String):void
			{
				_skin["txtAttrRdValue"+index+i].text = text;
				_skin["txtAttrRdStar"+index+i].text = "";
				_skin["mcAttrRdStar"+index+i].visible = false;
			}
		}
		/**跟新消耗*/
		public function updateCost():void
		{
			costCoin = 0;
			var cellData1:CellData = ExtendSelectData.cellData1;
			if(cellData1)
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(cellData1.bornSid,cellData1.id);
				if(!memEquipData)
				{
					return;
				}
				var filter:int = ExtendSelectData.filter;
				if(filter == 1 || filter == 2)
				{
					var equipStrengthenCfgData:EquipStrengthenCfgData = memEquipData.equipStrengthenCfgData;
					costCoin += equipStrengthenCfgData ? equipStrengthenCfgData.move_coin : 0;
					var equipPolishCfgData:EquipPolishCfgData = memEquipData.equipPolishCfgData;
					costCoin += equipPolishCfgData ? equipPolishCfgData.move_coin : 0;
				}
				if(filter == 1 || filter == 3)
				{
					var equipRefinedCostCfgData:EquipRefinedCostCfgData = memEquipData.equipRefinedCostCfgData;
					costCoin += equipRefinedCostCfgData ? equipRefinedCostCfgData.move_coin : 0;
				}
				_skin.txtCost1.text = costCoin+"";
				var coin:int = BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind;
				isCoinEnough = coin >= costCoin;
				_skin.txtCost1.textColor = isCoinEnough ? 0xffcc00 : 0xff0000;
			}
		}
		
		public function destroy():void
		{
			_skin = null;
			_panel = null;
		}
	}
}