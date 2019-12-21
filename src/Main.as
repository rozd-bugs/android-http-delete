package {

import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;

public class Main extends Sprite
{
    private static const URL:String = "http://127.11.68.1:8080";

    public function Main()
    {
        super();

        new PlainButton(this, {label : "SEND"}, function(event:Event):void
        {
            var request:URLRequest = new URLRequest(URL);
            request.method = URLRequestMethod.DELETE;
            request.contentType = "application/json";
            request.data = JSON.stringify({ids : ["not-existing-id"]});

            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, function(event:Event):void
            {
                trace("OK", loader.data);
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:ErrorEvent):void
            {
                trace(event.text);
            });

            loader.load(request);
        });
    }
}
}


import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class PlainButton extends Sprite
{
    function PlainButton(parent:DisplayObjectContainer=null, properties:Object=null, clickHandler:Function=null)
    {
        super();

        _props = properties;
        _label = properties ? (properties.label || "") : "";
        _color = properties ? (properties.color || 0) : 0;

        var textColor:uint = properties ? (properties.textColor || 0xFFFFFF) : 0xFFFFFF;

        textDisplay = new TextField();
        textDisplay.defaultTextFormat = new TextFormat("_sans", 24, textColor, null, null, null, null, null, TextFormatAlign.CENTER);
        textDisplay.selectable = false;
        textDisplay.autoSize = "center";
        addChild(textDisplay);

        x = _props.x || 0;
        y = _props.y || 0;

        if (parent)
            parent.addChild(this);

        if (clickHandler != null)
            addEventListener(MouseEvent.CLICK, clickHandler);

        sizeInvalid = true;
        labelInvalid = true;

        addEventListener(Event.ENTER_FRAME, renderHandler);
    }

    private var sizeInvalid:Boolean;
    private var labelInvalid:Boolean;

    private var _label:String;
    private var _color:uint;
    private var _props:Object;

    private var textDisplay:TextField;

    private function renderHandler(event:Event):void
    {
        if (labelInvalid)
        {
            labelInvalid = false;

            textDisplay.text = _label;
        }

        if (sizeInvalid)
        {
            sizeInvalid = false;

            var w:Number = _props.width || _props.w || 100;
            var h:Number = _props.height || _props.h || 40;

            graphics.clear();
            graphics.beginFill(_color);
            graphics.drawRect(0, 0, w, h);
            graphics.endFill();

            textDisplay.x = 0;
            textDisplay.width = w;
            textDisplay.y = (h - textDisplay.height) / 2;
        }
    }
}