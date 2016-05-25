package com.view.gameWindow.panel.panels.levelReward
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.LevelGiftCfgData;
    import com.view.gameWindow.panel.panels.levelReward.data.LevelRewardVo;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.NumPic;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;

    /**
     * Created by Administrator on 2014/12/8.
     */
    public class LevelRewardViewHandler
    {
        private var _panel:PanelLevelReward;
        private var _skin:McLevelReward;

        private var _iconCells:Vector.<IconCellEx>;
        private var _dataThings:Vector.<ThingsData>;
        private var _lvNum:NumPic;

        public function LevelRewardViewHandler(panel:PanelLevelReward)
        {
            _panel = panel;
            _skin = _panel.skin as McLevelReward;
            initialize();
        }

        private function initialize():void
        {
            _iconCells = new Vector.<IconCellEx>();
            _dataThings = new Vector.<ThingsData>();
            var index:int = LevelRewardDataManager.instance.rewardIndex;
            var datas:Vector.<LevelRewardVo> = LevelRewardDataManager.instance.getLimitRewards(index);
            var len:int = 6;
            for (var i:int = 0; i < len; i++)
            {
                var ex:IconCellEx = new IconCellEx(_skin["item" + i], 0, 0, 39, 39);
                _iconCells.push(ex);
                var dt:ThingsData = new ThingsData();
                _dataThings.push(dt);
            }
            refresh();
        }

        public function refresh():void
        {
            destroyTips();
            var index:int = LevelRewardDataManager.instance.rewardIndex + 1;
            var cfg:LevelGiftCfgData = ConfigDataManager.instance.levelGiftCfgDatas(index);
            if (cfg == null) return;

            if (_lvNum == null)
            {
                _lvNum = new NumPic();
            }

            _lvNum.init("lv_", cfg.gift_level.toString(), _skin.lvContainer, function ():void
            {
                if (!_skin) return;
                _skin.lvContainer.x = 193 + ((62 - _skin.lvContainer.width) >> 1);
            });

            var datas:Vector.<LevelRewardVo> = LevelRewardDataManager.instance.getLimitRewards(index);
            for (var i:int = 0, len:int = datas.length; i < len; i++)
            {
                var vo:LevelRewardVo = datas[i];
                var ex:IconCellEx = _iconCells[i];
                var dt:ThingsData = _dataThings[i];
                dt.id = vo.id;
                dt.type = vo.type;
                dt.count = vo.count;
                IconCellEx.setItemByThingsData(ex, dt);
                ToolTipManager.getInstance().attach(ex);
            }
        }

        private function destroyTips():void
        {
            if (_iconCells)
            {
                _iconCells.forEach(function (mc:IconCellEx, index:int, vec:Vector.<IconCellEx>):void
                {
                    ToolTipManager.getInstance().detach(mc);
                }, null);
            }
        }

        public function destroy():void
        {
            if (_skin.lvContainer && _skin.lvContainer.numChildren)
            {
                ObjectUtils.clearAllChild(_skin.lvContainer);
                _skin.lvContainer = null;
            }
            if (_lvNum)
            {
                _lvNum = null;
            }

            destroyTips();
            for each(var cell:IconCellEx in _iconCells)
            {
                cell.destroy();
                cell = null;
            }

            for each(var dt:ThingsData in _dataThings)
            {
                dt = null;
            }

            if (_skin)
            {
                _skin = null;
            }
        }

    }
}