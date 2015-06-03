package dragonbones.objects;
import openfl.geom.Point;

@:final class TransformTimeline extends Timeline
{
    public var name:String;
    public var transformed:Bool;
    public var originTransform:DBTransform;
    public var originPivot:Point;
    public var offset:Float;
    public var timelineCached:TimelineCached;
    
    var _slotTimelineCachedMap:Map<String, TimelineCached>;
    
    public function new()
    {
        super();
        _slotTimelineCachedMap = new Map();
        originTransform = new DBTransform();
        originTransform.scaleX = 1;
        originTransform.scaleY = 1;
        originPivot = new Point();
        offset = 0;
        timelineCached = new TimelineCached();
    }
    
    public function getSlotTimelineCached(slotName:String):TimelineCached
    {
        var slotTimelineCached = _slotTimelineCachedMap.get(slotName);
        if(slotTimelineCached == null) {
			slotTimelineCached = new TimelineCached();
			_slotTimelineCachedMap.set(slotName, slotTimelineCached);
        }
        return slotTimelineCached;
    }
    
    public override function dispose():Void
    {
        super.dispose();
        timelineCached.dispose();
        for (slotTimelineCached in _slotTimelineCachedMap)
        {
            slotTimelineCached.dispose();
        } 
        originTransform = null;
        originPivot = null;
        timelineCached = null;
        _slotTimelineCachedMap = null;
    }
}