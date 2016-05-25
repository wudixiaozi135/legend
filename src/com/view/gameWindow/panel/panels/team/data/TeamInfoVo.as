package com.view.gameWindow.panel.panels.team.data
{
    /**
     * Created by Administrator on 2014/11/8.
     * 组队信息
     */
    public class TeamInfoVo
    {
        private var _cid:int;
        private var _sid:int;
        private var _name:String;
        private var _head:int;
        private var _vip:int;
        private var _reincarn:int;
        private var _level:int;
        private var _hp:int;
        private var _maxHp:int;
        private var _job:int;
        private var _factionName:String = "";
        private var _mapId:int;
        private var _x:int;
        private var _y:int;
        private var _leaderFlag:Boolean;
        private var _mapOnlyId:int;//地图唯一ID
        public function TeamInfoVo()
        {
        }


        public function get cid():int
        {
            return _cid;
        }

        public function set cid(value:int):void
        {
            _cid = value;
        }


        public function get sid():int
        {
            return _sid;
        }

        public function set sid(value:int):void
        {
            _sid = value;
        }


        public function get name():String
        {
            return _name;
        }

        public function set name(value:String):void
        {
            _name = value;
        }


        public function get head():int
        {
            return _head;
        }

        public function set head(value:int):void
        {
            _head = value;
        }


        public function get vip():int
        {
            return _vip;
        }//队长标识

        public function set vip(value:int):void
        {
            _vip = value;
        }


        public function get reincarn():int
        {
            return _reincarn;
        }

        public function set reincarn(value:int):void
        {
            _reincarn = value;
        }


        public function get level():int
        {
            return _level;
        }

        public function set level(value:int):void
        {
            _level = value;
        }


        public function get job():int
        {
            return _job;
        }

        public function set job(value:int):void
        {
            _job = value;
        }


        public function get hp():int
        {
            return _hp;
        }

        public function set hp(value:int):void
        {
            _hp = value;
        }


        public function get maxHp():int
        {
            return _maxHp;
        }

        public function set maxHp(value:int):void
        {
            _maxHp = value;
        }


        public function get factionName():String
        {
            return _factionName;
        }

        public function set factionName(value:String):void
        {
            _factionName = value;
        }


        public function get mapId():int
        {
            return _mapId;
        }

        public function set mapId(value:int):void
        {
            _mapId = value;
        }


        public function get x():int
        {
            return _x;
        }

        public function set x(value:int):void
        {
            _x = value;
        }


        public function get y():int
        {
            return _y;
        }

        public function set y(value:int):void
        {
            _y = value;
        }

        public function get leaderFlag():Boolean
        {
            return _leaderFlag;
        }

        public function set leaderFlag(value:Boolean):void
        {
            _leaderFlag = value;
        }

        public function get mapOnlyId():int
        {
            return _mapOnlyId;
        }

        public function set mapOnlyId(value:int):void
        {
            _mapOnlyId = value;
        }
    }
}
