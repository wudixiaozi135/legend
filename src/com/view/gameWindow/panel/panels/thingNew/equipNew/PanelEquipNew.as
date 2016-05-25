package com.view.gameWindow.panel.panels.thingNew.equipNew
{
	import com.greensock.TweenMax;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.closet.ClosetDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipCell;
	import com.view.gameWindow.panel.panels.thingNew.McEquipNew;
	import com.view.gameWindow.panel.panels.thingNew.ThingNewData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.NumPic;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.propertyParse.PropertyData;
	import com.view.newMir.NewMirMediator;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 获得新装备提示面板类
	 * @author Administrator
	 */	
	public class PanelEquipNew extends PanelBase implements IPanelEquipNew
	{
		private var _equipCell:EquipCell;
		private var _bagData:BagData;
		private var _timerId:int, _delay:int = 5000;
		private var _btnHight:HighlightEffectManager;
		private var _arrows:Array = [];
		public function PanelEquipNew()
		{
			super();
			isSingleton = true;
		}
		
		override protected function initSkin():void
		{
			var mc:McEquipNew = new McEquipNew();
			_skin = mc;
			addChild(_skin);
			setTitleBar(mc.mcDrag);
			_arrows.push(mc.arrow1, mc.arrow2, mc.arrow3);
			_btnHight = new HighlightEffectManager();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McEquipNew = _skin as McEquipNew;
			rsrLoader.addCallBack(skin.btnDo, function (mc:MovieClip):void
			{
				InterObjCollector.instance.add(mc);
				_btnHight.show(mc, mc);
			});
			initEquipData();
		}
		
		protected function initEquipData():void
		{
			var mc:McEquipNew = _skin as McEquipNew;
			mc.title.mouseEnabled = false;
			mc.title.textColor = 0xffcc00;
			mc.title.text = StringConst.THING_NEW_PANEL_0001;
			
			var equipCfgData:EquipCfgData;
			_bagData = ThingNewData.bagData;
			var isUniqueEquip:int = ThingNewData.isUniqueEquip;
			if(isUniqueEquip == 1)
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(_bagData.bornSid,_bagData.id);
				equipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			}
			else
			{
				equipCfgData = ConfigDataManager.instance.equipCfgData(_bagData.id);
			}
			
			var attrs:Vector.<String> = new Vector.<String>();
			attrs.push(equipCfgData.attr);
			if (equipCfgData && attrs.length > 0)
			{
				var vecAttrs:Vector.<String> = CfgDataParse.getAttHtmlStringArray2(attrs);
				var bool:Boolean,tempText:TextField,vecAttrsLen:int= vecAttrs.length;
				//var preH:Number = 56/(vecAttrsLen+1);
				var yPosObj:Object = {1:[67,93],2:[60,80,100],3:[42,60,80,100]},num:int = vecAttrsLen>3?3:vecAttrsLen;
				
				for (var i:int = 0; i < _arrows.length; i++)
				{
					tempText = mc["txt" + (i + 1)];
					
					if (i < vecAttrsLen)
					{
						bool = true;
						tempText.y = yPosObj[num][i+1];//62 + preH*(i+1) - 16 + i*5;
						tempText.visible = true;
						tempText.htmlText = vecAttrs[i];
						_arrows[i].y = 	tempText.y + 1;
						mc["txtName"].y = yPosObj[num][0];
					} else
					{
						tempText.visible = false;
						//tempText.htmlText = "";
						bool = false;
					}
					_arrows[i].visible = bool;
				}
			}
			
			var slot:int = ConstEquipCell.getRoleEquipSlot(equipCfgData.type);
			_equipCell = new EquipCell(mc.mcBg,slot,equipCfgData.type);
			_equipCell.refreshData(_bagData.id,_bagData.bornSid);
			ToolTipManager.getInstance().attach(_equipCell);
			//
			var color:int = ItemType.getColorByQuality(equipCfgData.color);
			mc.txtName.htmlText = HtmlUtils.createHtmlStr(color, equipCfgData.name, 12, false);
			
			//dealNumPic(isUniqueEquip,mc);
			//
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			//
			_timerId = setTimeout(dealDo,_delay);
			
			handlerEffect();
		}
		
		private function dealNumPic(isUniqueEquip:int,mc:McEquipNew):void
		{
			var fightPower:Number = 0,fightPowerEquiped:Number = 0;
			var equipCfgData:EquipCfgData;
			if(isUniqueEquip == 1)
			{
				var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(_bagData.bornSid,_bagData.id);
				equipCfgData = memEquipData.equipCfgData;
				fightPower = memEquipData.getTotalFightPower();
			}
			else
			{
				equipCfgData = ConfigDataManager.instance.equipCfgData(_bagData.id);
				var propertyDatas:Vector.<PropertyData> = CfgDataParse.getPropertyDatas(equipCfgData.attr),data:PropertyData;
				for each(data in propertyDatas)
				{
					fightPower += data.fightPower;
				}
			}
			var slot:int = ConstEquipCell.getRoleEquipSlot(equipCfgData.type);
			if(slot != -1)
			{
				fightPowerEquiped = RoleDataManager.instance.getEquipPower(slot);
				fightPower -= fightPowerEquiped;
			}
			var numPic:NumPic = new NumPic();
			numPic.init("red_", int(fightPower) + "", mc.mcNumLayer, function ():void
			{
				if (mc && mc.mcNumLayer && mc.upArrow)
				{
					mc.upArrow.x = mc.mcNumLayer.x + mc.mcNumLayer.width + 3;
				}
			});
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mc:McEquipNew = _skin as McEquipNew;
			if (event.target == mc.btnDo)
			{
				dealDo();
			}
		}
		
		private function dealClose():void
		{
			clearTimeout(_timerId);
			PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_NEW,index);
		}
		
		private function dealDo():void
		{
			clearTimeout(_timerId);
			var bagData:BagData = null;
			if (_bagData)
			{
				bagData = BagDataManager.instance.getBagDataById(_bagData.id, _bagData.type, _bagData.bornSid);
			}
			if(!bagData)
			{
				closeHandler();
				trace("PanelEquipNew.dealDo bagData == null");
				return;
			}
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(bagData.bornSid,bagData.id);
			if(!memEquipData)
			{
				closeHandler();
				trace("PanelEquipNew.dealDo memEquipData == null");
				return;
			}
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);
			if(!equipCfgData)
			{
				closeHandler();
				trace("PanelEquipNew.dealDo equipCfgData == null");
				return;
			}
			var type:int = equipCfgData.type;
			var shizhuang:int = ConstEquipCell.TYPE_SHIZHUANG;
			var chibang:int = ConstEquipCell.TYPE_CHIBANG;
			var zuji:int = ConstEquipCell.TYPE_ZUJI;
			var douli:int = ConstEquipCell.TYPE_DOULI;
			var huanwu:int = ConstEquipCell.TYPE_HUANWU;
			if (type == shizhuang || type == zuji || type == douli || type == huanwu)
			{
				ClosetDataManager.instance.request(type,bagData.slot);
				PanelMediator.instance.openPanel(PanelConst.TYPE_CLOSET);
			}
			else if(type==ConstEquipCell.TYPE_HERO_SHIZHUANG)
			{
				ClosetDataManager.instance.requestHero(bagData.storageType,bagData.slot);
			} else if (type == ConstEquipCell.TYPE_CHIBANG)
			{
				////在此之前已发过协议，此处不用重发
			}
			else
			{
				var slot:int = ConstEquipCell.getRoleEquipSlot(type);
				trace("PanelEquipNew.dealDo() name:"+bagData.memEquipData.equipCfgData.name+",slot:"+slot);
				sendData(ConstStorage.ST_CHR_BAG,bagData.slot,ConstStorage.ST_CHR_EQUIP,slot);
				var mc:McEquipNew = _skin as McEquipNew;
				var replace:String = StringConst.THING_NEW_PANEL_0003.replace("&x", mc.txtName.text);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,replace);
			}
			closeHandler();
		}
		
		private function sendData(oldStorage:int,oldSlot:int,newStorage:int,newSlot:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(oldStorage);
			byteArray.writeByte(oldSlot);
			byteArray.writeByte(newStorage);
			byteArray.writeByte(newSlot);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_MOVE_ITEM,byteArray);
		}
		
		override public function setPostion():void
		{
			var rect:Rectangle = getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = int((newMirMediator.width - rect.width));
			var newY:int = int((newMirMediator.height + rect.height - 10));
			x != newX ? x = newX : null;
			y != newY ? y = newY : null;
		}
		
		override public function resetPosInParent():void
		{
			super.resetPosInParent();
			setPostion();
		}
		
		private function handlerEffect():void
		{
			var rect:Rectangle = getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = int(newMirMediator.width - rect.width) - 50;
			var newY:int = int(newMirMediator.height - rect.height) - 100;
			
			TweenMax.fromTo(this, 2, {alpha: 0}, {
				x: newX, y: newY, alpha: 1, onComplete: function ():void
				{
					TweenMax.killTweensOf(this);
				}
			});
		}
		
		private function closeHandler():void
		{
			var rect:Rectangle = getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = int(newMirMediator.width + rect.width);
			
			alpha = 1;
			TweenMax.to(this, 3, {
				x: newX, alpha: 0, onComplete: function ():void
				{
					TweenMax.killTweensOf(this);
					PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_NEW, index);
				}
			});
		}
		
		override public function destroy():void
		{
			if(_bagData)
			{
				_bagData = null;
			}
			if(_equipCell)
			{
				ToolTipManager.getInstance().detach(_equipCell);
				_equipCell.destory();
				_equipCell = null;
			}
			if(_skin)
			{
				if (_btnHight)
				{
					_btnHight.hide(_skin.btnDo);
					_btnHight = null;
				}
				_skin.removeEventListener(MouseEvent.CLICK,onClick);
				InterObjCollector.instance.remove(_skin.btnDo);
			}
			super.destroy();
		}
	}
}