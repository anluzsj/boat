import GemBuilder;
import Patterns;
import PrefebPatterns;
import PatternPool;
import GemMatrix;
import MovieClip;
class Item extends MovieClip {

    static public var GemWidth = 50;
    static public var GemHeight = 50;

    public var m_currentInnerType:Number;
    public var m_nextInnerType:Number;
    public var m_itemType:String;
    public var m_gridX:Number;
    public var m_frameCounter:Number;
    public var m_gridY:Number;
    public var m_id;
    public var m_gemBuilder:GemBuilder;
    public var m_tag;
    public var m_gemMatrix:GemMatrix    = null;
    static public var TAG_NONE          = 0;
    static public var TAG_HIGHEST_DEPTH = 1;

    static public var GEM_INNER_TYPE_NORMAL     = 1;
    static public var GEM_INNER_TYPE_HORIZONTAL = 2;
    static public var GEM_INNER_TYPE_VERTICAL   = 3;
    static public var GEM_INNER_TYPE_BLOCK      = 4;
    static public var GEM_INNER_TYPE_CROSS      = 5;
    static public var GEM_INNER_TYPE_SUPER      = 6;

    static public var GEM_STATUS_NONE       = 0;
    static public var GEM_STATUS_IDLE       = 1;
    static public var GEM_STATUS_SWAPING    = 2;
    static public var GEM_STATUS_FALLING    = 3;
    static public var GEM_STATUS_DESTROY    = 4;
    static public var GEM_STATUS_REBORN     = 5;

    static public var DESTROY_TYPE_NORMAL   = 1;

    public var m_currentStatus = Item.GEM_STATUS_IDLE
    public var m_verticalPattern = null;
    public var m_horizontalPattern = null;

    public function Item() {
        gotoAndStop("idle")
    }

    public function reset()
    {
        m_tag = TAG_NONE
        m_currentInnerType  = GEM_INNER_TYPE_NORMAL
        m_nextInnerType     = GEM_INNER_TYPE_NORMAL
        m_currentStatus = GEM_STATUS_IDLE
        m_frameCounter = 0
        m_gridX = -1
        m_gridY = -1
        this._x = 0
        this._y = 0
        m_itemType = "none"
        m_verticalPattern = null;
        m_horizontalPattern = null;
    }

    public function isInVerticalPattern():Boolean
    {
        return m_verticalPattern != null;
    }

    public function setInPattern(pattern)
    {
        if(pattern.getLayout() == Patterns.LAYOUT_VERTICAL)
        {
            m_verticalPattern = pattern
        }
        else
        {
            m_horizontalPattern = pattern
        }

        if((m_verticalPattern and m_verticalPattern.getPatternType() == PrefebPatterns.PT_FIVE and m_verticalPattern.getKeyItem() == this) or (m_horizontalPattern and m_horizontalPattern.getPatternType() == PrefebPatterns.PT_FIVE and m_horizontalPattern.getKeyItem() == this))
        {
            m_nextInnerType = GEM_INNER_TYPE_SUPER
        }
        else if(m_verticalPattern and m_verticalPattern.getPatternType() == PrefebPatterns.PT_FOUR and m_verticalPattern.getKeyItem() == this)
        {
            m_nextInnerType = GEM_INNER_TYPE_VERTICAL
        }
        else if(m_horizontalPattern and m_horizontalPattern.getPatternType() == PrefebPatterns.PT_FOUR and m_horizontalPattern.getKeyItem() == this)
        {
            m_nextInnerType = GEM_INNER_TYPE_HORIZONTAL
        }
        else if(m_verticalPattern and m_horizontalPattern)
        {
            m_nextInnerType = GEM_INNER_TYPE_BLOCK
        }
        else
        {
        }
    }

    public function isInHorizontalPattern():Boolean
    {
        return m_horizontalPattern != null;
    }

    public function setTag(tag:Number)
    {
//        trace("setTag " + this._name + "  " + tag)
        m_tag = tag
    }

    public function setStatus(v:Number)
    {
//      trace("setStatus " + this._name + "  " + v)
        m_currentStatus = v
    }

    public function getItemStatus():Number
    {
        return m_currentStatus;
    }

    public function setParent(gemBuilder:GemBuilder, gemMatrix:GemMatrix)
    {
//        trace("setParent " + gemBuilder.getBuilderName())
        m_gemBuilder    = gemBuilder;
        m_gemMatrix     = gemMatrix;
    }

    public function setID(id:Number)
    {
        m_id = id;
    }

    public function getID() : Number
    {
        return m_id;
    }

    public function getGridX() : Number
    {
        return m_gridX;
    }

    public function getGridY() : Number
    {
        return m_gridY;
    }

    public function checkNeedFalling()
    {

        //we should check when GEM_STATUS_FALLING, so the drop anim is not smooth
        if(m_currentStatus == GEM_STATUS_IDLE )
        {
            if(not m_gemBuilder.isItemReachButtom(this))
            {
                var nextItem = m_gemBuilder.getItem(m_gridY + 1)
                if(not nextItem or nextItem.getItemStatus() == GEM_STATUS_FALLING)
                {
                    m_currentStatus = GEM_STATUS_FALLING
                    return
                }
            }
            var destYPos = m_gemBuilder.getBaseYPos() + getGridY() * Item.GemHeight
            if(this._y < destYPos)
            {
                m_currentStatus = GEM_STATUS_FALLING
            }
        }
    }

    public function onFallingOver()
    {
        m_gemMatrix.tryToFindComboPattern(this)
    }

    public function update(dt)
    {
        m_frameCounter ++;
        var body = this["Body"];
//        body["ColorForm"]._visible = false
        checkNeedFalling()
        var gridPos = String(getGridX()) + getGridY()
        body["GridPos"].text = gridPos
        body["GridPos"]._visible = false    //zsj enable show gridIndex
        if(m_currentStatus == GEM_STATUS_SWAPING || m_currentStatus == GEM_STATUS_DESTROY || m_currentStatus == GEM_STATUS_REBORN )
        {
            return;
        }
        else if(m_currentStatus == GEM_STATUS_FALLING)
        {
            if(not m_gemBuilder.isItemReachButtom(this) )
            {
                var nextItem = m_gemBuilder.getItem(m_gridY + 1)
                if(not nextItem)
                {
                    m_gemBuilder.setItemToIndex(null, getGridY())
                    m_gemBuilder.setItemToIndex(this, getGridY() + 1)
                }
            }

            var destYPos = m_gemBuilder.getBaseYPos() + getGridY() * Item.GemHeight
            if(Math.abs(destYPos - this._y) <= 10)
            {
                this._y = destYPos
                m_currentStatus = GEM_STATUS_IDLE
                onFallingOver()
            }
            else
            {
                this._y += 10;
            }
        }
    }

    public function setItemType(itemType:String)
    {
        m_itemType = itemType;
        var body = this["Body"];
        body.gotoAndStop(m_itemType)
    }

    public function setGridX(x:Number)
    {
        m_gridX = x;
    }

    public function setGridY(y:Number)
    {
        m_gridY = y;
    }

    public function getItemType() :String
    {
        return m_itemType;
    }

    public function onMoveAnimOver()
    {
        gotoAndStop("idle")
        m_currentStatus = Item.GEM_STATUS_IDLE
    }

    public function onReachRight()
    {
        this._x += GemWidth;
        onMoveAnimOver()
    }

    public function onReachLeft()
    {
        this._x -= GemWidth;
        onMoveAnimOver()
    }

    public function onReachButtom()
    {
        this._y += GemHeight;
        onMoveAnimOver()
    }

    public function onReachTop()
    {
        this._y -= GemHeight;
        onMoveAnimOver()
    }
    public function onRollAnimHalfOver()
    {
        if(m_tag == TAG_HIGHEST_DEPTH)
        {
            this.swapDepths(this._parent.getNextHighestDepth())
            m_tag = TAG_NONE
        }
    }
    public function onRollAnimOver()
    {
        m_currentStatus = GEM_STATUS_IDLE
    }

    public function onDestroyAnimOver()
    {
        m_gemBuilder.unlockSwap()
        m_gemBuilder.removeItem(this)
    }

    public function onRebornAnimOver()
    {
        trace("onRebornAnimOver")
        m_gemBuilder.unlockSwap()
        m_currentStatus = GEM_STATUS_IDLE
        m_tag = TAG_NONE
        m_currentInnerType  = GEM_INNER_TYPE_NORMAL
        m_nextInnerType     = GEM_INNER_TYPE_NORMAL
        m_verticalPattern   = null
        m_horizontalPattern = null
    }

    public function playAnim(anim:String)
    {
        gotoAndPlay(anim)
    }

    public function fire()
    {
        if(m_currentStatus == GEM_STATUS_REBORN)
        {
            return
        }

        if(m_nextInnerType == GEM_INNER_TYPE_NORMAL)
        {
            setDestroy(Item.DESTROY_TYPE_NORMAL)
        }
        else
        {
            var body = this["Body"];
            var colorForm = body["ColorForm"]
            var innerType = colorForm["InnerType"]
            innerType.gotoAndStop(m_nextInnerType)
            m_currentInnerType = m_nextInnerType
            m_nextInnerType = GEM_INNER_TYPE_NORMAL
            m_currentStatus = GEM_STATUS_REBORN
            playAnim("reborn")
        }
    }

    public function setDestroy(destroyType)
    {
        if(m_currentStatus == GEM_STATUS_REBORN)
        {
            return
        }

        if(m_currentInnerType == GEM_INNER_TYPE_NORMAL)
        {
            playAnim("destroy")
            setStatus(GEM_STATUS_DESTROY)
            m_gemBuilder.lockSwap()
        }
    }

    public function canBeUsedInPattern(layoutType:Number)
    {
        if(m_currentStatus == GEM_STATUS_IDLE)
        {
            if(layoutType == Patterns.LAYOUT_VERTICAL)
            {
                return m_verticalPattern == null
            }
            else
            {
                return m_horizontalPattern == null
            }
        }
        return false
    }

    public function canSwap()
    {
        return m_currentStatus == GEM_STATUS_IDLE and not m_gemBuilder.isLockedForSwap() and not m_verticalPattern and not m_horizontalPattern
    }

    public function canFire()
    {
        return m_currentStatus == GEM_STATUS_IDLE or m_currentStatus == GEM_STATUS_REBORN
    }
}
