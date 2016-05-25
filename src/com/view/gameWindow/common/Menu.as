package com.view.gameWindow.common
{
import com.view.gameWindow.util.ObjectUtils;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

/**
 * Created by Administrator on 2014/11/14.
 */
public class Menu extends Sprite
{
    public function Menu()
    {
        super();
        _container = new Sprite();
        addChild(_container);
        _container.visible = false;

        _labelPanel = new Sprite();
        _container.addChild(_labelPanel);

        _bgPanel = new Sprite();
        _container.addChild(_bgPanel);

        _selectPanel = new Sprite();
        _container.addChild(_selectPanel);
        addEventListener(MouseEvent.ROLL_OUT, onRollOut);
    }

    private var _bgPanel:Sprite;
    private var _selectPanel:Sprite;
    private var _container:Sprite;
    private var _vecItems:Vector.<MenuItem> = new Vector.<MenuItem>();
    private var _labelPanel:Sprite;

    private var _param:Object;

    public function get param():Object
    {
        return _param;
    }

    public function set param(value:Object):void
    {
        _param = value;
    }

    /**选中某一项执行 参数：String*/
    private var _selectHandler:Function;

    public function get selectHandler():Function
    {
        return _selectHandler;
    }

    public function set selectHandler(value:Function):void
    {
        _selectHandler = value;
    }

    /**选中某一项执行 参数 Ojbect*/
    private var _clickHandler:Function;

    public function get clickHandler():Function
    {
        return _clickHandler;
    }

    public function set clickHandler(value:Function):void
    {
        _clickHandler = value;
    }

    public function setLabels(labels:Array):void
    {
        ObjectUtils.clearAllChild(_labelPanel);
        _vecItems.length = 0;

        for (var i:int = 0, len:int = labels.length; i < len; i++)
        {
            var item:MenuItem = new MenuItem(labels[i]);
            item.clickHandler = onClickHandler;

            _vecItems.push(item);
            _labelPanel.addChild(item);
            item.x = (_labelPanel.width - item.width) >> 1;
            item.y = item.height * i;
        }

        _container.graphics.clear();
        _container.graphics.beginFill(0x0, .7);
        _container.graphics.drawRoundRect(0, 0, _labelPanel.width, _labelPanel.height, 3, 3);
        _container.graphics.endFill();
    }

    public function showInParentWindow(parent:DisplayObject):void
    {
        var point:Point = globalToLocal(new Point(parent.stage.mouseX, parent.stage.mouseY));
        _container.x = point.x - 10;
        _container.y = point.y - 10;
        show();
    }

    public function show():void
    {
        if (!_container.visible)
        {
            _container.visible = true;
        }
    }

    public function hide():void
    {
        if (_container.visible)
        {
            _container.visible = false;
        }
    }

    private function onClickHandler(label:String):void
    {
        if (_selectHandler != null)
        {
            _selectHandler(label);
        }
        if (_clickHandler != null)
        {
            _clickHandler(_param);
        }
    }

    private function onRollOut(event:MouseEvent):void
    {
        hide();
    }
}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

class MenuItem extends Sprite
{
    private var _label:String;
    private var _clickHandler:Function;
    private var _rollOverHandler:Function;
    private var _rollOutHandler:Function;
    private var _tf:TextField;

    public function MenuItem(label:String)
    {
        this._label = label;
        _tf = new TextField();
        _tf.borderColor = 0xffff00;
        _tf.selectable = false;
        _tf.autoSize = "left";
        _tf.textColor = 0xffe1aa;
        _tf.text = _label;
        addChild(_tf);

        _tf.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        _tf.addEventListener(MouseEvent.ROLL_OVER, onRoll, false, 0, true);
        _tf.addEventListener(MouseEvent.ROLL_OUT, onRoll, false, 0, true);
        addEventListener(Event.REMOVED, onDispose, false, 0, true);
    }

    private function onDispose(event:Event):void
    {
        removeEventListener(Event.REMOVED, onDispose);
        destroy();
    }

    private function onRoll(event:MouseEvent):void
    {
        var obj:TextField = event.target as TextField;
        if (event.type == MouseEvent.ROLL_OUT)
        {
            if (obj)
                obj.border = false;
            if (_rollOutHandler != null)
            {
                _rollOutHandler(_label);
            }
        } else if (event.type == MouseEvent.ROLL_OVER)
        {
            if (_rollOverHandler != null)
            {
                _rollOverHandler(_label);
            }
            if (obj)
                obj.border = true;
        }
    }

    private function onClick(event:MouseEvent):void
    {
        if (_clickHandler != null)
        {
            _clickHandler(_label);
        }
    }

    public function get clickHandler():Function
    {
        return _clickHandler;
    }

    public function set clickHandler(value:Function):void
    {
        _clickHandler = value;
    }

    public function get rollOverHandler():Function
    {
        return _rollOverHandler;
    }

    public function set rollOverHandler(value:Function):void
    {
        _rollOverHandler = value;
    }

    public function get rollOutHandler():Function
    {
        return _rollOutHandler;
    }

    public function set rollOutHandler(value:Function):void
    {
        _rollOutHandler = value;
    }

    public function destroy():void
    {
        if (null != _tf)
        {
            _tf.removeEventListener(MouseEvent.CLICK, onClick);
            _tf.removeEventListener(MouseEvent.ROLL_OVER, onRoll);
            _tf.removeEventListener(MouseEvent.ROLL_OUT, onRoll)
            if (contains(_tf))
            {
                removeChild(_tf);
                _tf = null;
            }
            if (_label)
            {
                _label = null;
            }
        }
        if (_clickHandler != null)
        {
            _clickHandler = null;
        }
        if (_rollOutHandler != null)
        {
            _rollOutHandler = null;
        }
        if (_rollOverHandler != null)
        {
            _rollOverHandler = null;
        }
    }
}