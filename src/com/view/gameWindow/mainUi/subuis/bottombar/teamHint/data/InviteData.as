package com.view.gameWindow.mainUi.subuis.bottombar.teamHint.data
{
/**
 * Created by Administrator on 2014/11/11.
 * 邀请组队
 */
public class InviteData
{
    private var _cid:int;
    private var _sid:int;
    private var _name:String;
    private var _job:int;
    private var _reincarn:int;
    private var _level:int;
    public function InviteData()
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

    public function get job():int
    {
        return _job;
    }

    public function set job(value:int):void
    {
        _job = value;
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
}
}
