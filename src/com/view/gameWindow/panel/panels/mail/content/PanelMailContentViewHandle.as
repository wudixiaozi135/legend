package com.view.gameWindow.panel.panels.mail.content
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.cfgdata.MailCfgData;
	import com.model.consts.StringConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.mail.data.MailData;
	import com.view.gameWindow.panel.panels.mail.data.MailState;
	import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;

	import flash.display.Bitmap;
	import flash.display.MovieClip;

	public class PanelMailContentViewHandle implements IObserver
	{
		private var _panel:PanelMailContent;
		private var _mc:McMailContent;
		private var _cells:Vector.<IconCellEx>;
		private var _selectData:MailData;
		internal var selectIndex:int;
		
		public function PanelMailContentViewHandle(panel:PanelMailContent)
		{
			_panel = panel;
			_mc = _panel.skin as McMailContent;
			init();
            PanelMailDataManager.instance.attach(this);
		}
		
		private function init():void
		{
			selectIndex = PanelMailDataManager.instance.selectIndex;
			_selectData = PanelMailDataManager.instance.selectData;
			if(_selectData)
			{
				if(_selectData.sender == MailCfgData.SENDER_SYSTEM)
				{
					_mc.txtSenderValue.text = StringConst.MAIL_PANEL_0014;
				}
				else if(_selectData.sender == MailCfgData.SENDER_GM)
				{
					_mc.txtSenderValue.text = StringConst.MAIL_PANEL_0014;
				}
				else
				{
					_mc.txtSenderValue.text = StringConst.MAIL_PANEL_0014;
				}
				_mc.txtThemeValue.text = _selectData.title;
				var htmlStrArr:Array = CfgDataParse.pareseDes(_selectData.content,0xffffff);
				var str:String = "";
				for(var i:int = 0;i<htmlStrArr.length;i++){
					str+=htmlStrArr[i]+"\n";
				}
				_mc.txtContentValue.htmlText = str;
			}
		}
		
		public function refresh():void
		{
			var cell:IconCellEx;
			if(_selectData && _selectData.state != MailState.GET)
			{
				if(_cells)
				{
					return;
				}
				var attachment:String = _selectData.attachment;
				if(attachment)
				{
					var rewards:Array = attachment.split("|");
					_cells = new Vector.<IconCellEx>(rewards.length,true);
					var i:int,l:int = rewards.length;
					for(i=0;i<l;i++)
					{
						var mcBg:MovieClip = _mc["mcBg"+i] as MovieClip;
						cell = new IconCellEx(mcBg.parent,mcBg.x,mcBg.y,mcBg.width,mcBg.height);
						ToolTipManager.getInstance().attach(cell);
						_cells[i] = cell;
						var itemStrs:Array = UtilItemParse.getItemString(rewards[i]);
						var dt:ThingsData = new ThingsData();
						dt.count = itemStrs[2];
						dt.id = itemStrs[3];
						dt.type = itemStrs[4];
						IconCellEx.setItemByThingsData(cell,dt);
					}
				}
				else
				{
					for each(cell in _cells)
					{
						ToolTipManager.getInstance().detach(cell);
						cell.setNull();
					}
				}
			}
			else
			{
				for each(cell in _cells)
				{
					ToolTipManager.getInstance().detach(cell);
					cell.setNull();
				}
			}
		}

        public function getBitmaps():Array
        {
            var arr:Array = [];
            for each(var cell:IconCellEx in _cells)
            {
                var bmp:Bitmap = cell.getBitmap();
                if (bmp)
                {
                    bmp.width = bmp.height = 40;
                    bmp.name = cell.id.toString();
                    arr.push(bmp);
                    cell.addChild(bmp);
                }
            }
            return arr;
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.CM_GET_MAIL_ATTACHMENT)
            {
                successHandler();
            }
        }

        private function successHandler():void
        {
            var bmps:Array = getBitmaps();
            FlyEffectMediator.instance.doFlyReceiveThings2(bmps);
            for each(var bmp:Bitmap in bmps)
            {
                if (bmp)
                {
                    if (bmp.bitmapData)
                    {
                        bmp.bitmapData.dispose();
                        if (bmp.parent)
                        {
                            bmp.parent.removeChild(bmp);
                        }
                    }
                    bmp = null;
                }
            }
            bmps = null;
            PanelMediator.instance.closePanel(PanelConst.TYPE_MAIL_CONTENT);
        }

		public function destroy():void
		{
            PanelMailDataManager.instance.detach(this);
			var cell:IconCellEx;
			for each(cell in _cells)
			{
				ToolTipManager.getInstance().detach(cell);
				cell.setNull();
			}
			_selectData = null;
			_mc = null;
			_panel = null;
		}

    }
}