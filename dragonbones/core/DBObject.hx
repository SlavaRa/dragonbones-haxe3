package dragonbones.core;
import dragonbones.Armature;
import dragonbones.Bone;
import dragonbones.objects.DBTransform;
import dragonbones.utils.TransformUtil;
import openfl.geom.Matrix;

class DBObject
{
    public var global(get, never):DBTransform;
    public var origin(get, never):DBTransform;
    public var offset(get, never):DBTransform;
    public var visible(get, set):Bool;
    public var armature(get, never):Armature;
    public var parent(get, never):Bone;

    public var name:String;
    
    /**
	 * An object that can contain any user extra data.
	 */
    public var userData:Dynamic;
    public var inheritRotation:Bool;
    public var inheritScale:Bool;
    public var inheritTranslation:Bool;
    
    var _global:DBTransform;
    var _globalTransformMatrix:Matrix;
    
    static var _tempParentGlobalTransformMatrix:Matrix = new Matrix();
    static var _tempParentGlobalTransform:DBTransform = new DBTransform();
    
    /**
	 * This DBObject instance global transform instance.
	 * @see dragonBones.objects.DBTransform
	 */
    function get_global():DBTransform
    {
        return _global;
    }
    
    var _origin:DBTransform;
    /**
		 * This Bone instance origin transform instance.
		 * @see dragonBones.objects.DBTransform
		 */
    function get_origin():DBTransform
    {
        return _origin;
    }
    
    
    var _offset:DBTransform;
    /**
		 * This Bone instance offset transform instance.
		 * @see dragonBones.objects.DBTransform
		 */
    function get_offset():DBTransform
    {
        return _offset;
    }
    
    var _visible:Bool;
    function get_visible():Bool
    {
        return _visible;
    }
    function set_visible(value:Bool):Bool
    {
        _visible = value;
        return value;
    }
    
    var _armature:Armature;
    /**
	 * The armature this DBObject instance belongs to.
	 */
    function get_armature():Armature
    {
        return _armature;
    }

    public
    function setArmature(value:Armature):Void
    {
        if (_armature != null) 
        {
            _armature.removeDBObject(this);
        }
        _armature = value;
        if (_armature != null) 
        {
            _armature.addDBObject(this);
        }
    }
    
    
    var _parent:Bone;
    /**
		 * Indicates the Bone instance that directly contains this DBObject instance if any.
		 */
    function get_parent():Bone
    {
        return _parent;
    }
    
    function setParent(value:Bone):Void
    {
        _parent = value;
    }
    
    public function new()
    {
        _globalTransformMatrix = new Matrix();
        
        _global = new DBTransform();
        _origin = new DBTransform();
        _offset = new DBTransform();
        _offset.scaleX = 1;
		_offset.scaleY = 1;
        _visible = true;
        _armature = null;
        _parent = null;
        userData = null;
        this.inheritRotation = true;
        this.inheritScale = true;
        this.inheritTranslation = true;
    }
    
    /**
		 * Cleans up any resources used by this DBObject instance.
		 */
    public function dispose():Void
    {
        userData = null;
        _globalTransformMatrix = null;
        _global = null;
        _origin = null;
        _offset = null;
        _armature = null;
        _parent = null;
    }
    
    function calculateRelativeParentTransform():Void
    {
        
    }
    
    function calculateParentTransform():Dynamic
    {
        
        if (this.parent != null && (this.inheritTranslation || this.inheritRotation || this.inheritScale)) 
        {
            var parentGlobalTransform:DBTransform = this._parent._globalTransformForChild;
            var parentGlobalTransformMatrix:Matrix = this._parent._globalTransformMatrixForChild;
            
            if (!this.inheritTranslation || !this.inheritRotation || !this.inheritScale) 
            {
                parentGlobalTransform = DBObject._tempParentGlobalTransform;
                parentGlobalTransform.copy(this._parent._globalTransformForChild);
                if (!this.inheritTranslation) 
                {
                    parentGlobalTransform.x = 0;
                    parentGlobalTransform.y = 0;
                }
                if (!this.inheritScale) 
                {
                    parentGlobalTransform.scaleX = 1;
                    parentGlobalTransform.scaleY = 1;
                }
                if (!this.inheritRotation) 
                {
                    parentGlobalTransform.skewX = 0;
                    parentGlobalTransform.skewY = 0;
                }
                
                parentGlobalTransformMatrix = DBObject._tempParentGlobalTransformMatrix;
                TransformUtil.transformToMatrix(parentGlobalTransform, parentGlobalTransformMatrix, true);
            }
            
            return {
                parentGlobalTransform:parentGlobalTransform,
                parentGlobalTransformMatrix:parentGlobalTransformMatrix,
            };
        }
        return null;
    }
    
    function updateGlobal():Dynamic
    {
        calculateRelativeParentTransform();
        TransformUtil.transformToMatrix(_global, _globalTransformMatrix, true);
        var output:Dynamic = calculateParentTransform();
        if (output != null) 
        {
            _globalTransformMatrix.concat(output.parentGlobalTransformMatrix);
            TransformUtil.matrixToTransform(_globalTransformMatrix, _global, _global.scaleX * output.parentGlobalTransform.scaleX >= 0, _global.scaleY * output.parentGlobalTransform.scaleY >= 0);
        }
        return output;
    }
}