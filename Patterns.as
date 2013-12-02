import Item
import ItemBehavior
import PrefebPatterns;
import PatternPool;

class Patterns
{
    public var m_patterns:Array;
    public var m_items:Array;
    public var m_layoutType;
    public var m_patternType;
    public var m_triggerType;
    public var m_index;
    public var m_keyItem;
    public var m_fireCounter= -1;
    static public var MAX_FIRE_DELAY_COUNT = 3
    static public var LAYOUT_VERTICAL= 1
    static public var LAYOUT_HORIZONTAL= 2
    static public var TRIGGERED_BY_SWAP     = 1
    static public var TRIGGERED_BY_COMBO    = 2

    public function setTriggerType(triggerType:Number)
    {
        m_triggerType = triggerType
    }

    public function isCombo()
    {
        return m_triggerType == TRIGGERED_BY_COMBO
    }

    public function getName()
    {
        return "Patterns_" + m_index
    }

    public function Patterns(idx:Number)
    {
        m_patterns  = new Array()
        m_items     = new Array()
        m_index     = idx
        reset()
    }

    public function reset()
    {
        m_items[0] = null
        m_items[1] = null
        m_items[2] = null
        m_items[3] = null
        m_items[4] = null

        m_patterns[0] = ItemBehavior.NONE
        m_patterns[1] = ItemBehavior.NONE
        m_patterns[2] = ItemBehavior.NONE
        m_patterns[3] = ItemBehavior.NONE
        m_patterns[4] = ItemBehavior.NONE

        m_patternType = PrefebPatterns.PT_INVALID
        m_triggerType = TRIGGERED_BY_SWAP
        m_fireCounter = -1;
    }

    public function setKeyItem(keyItem:Item)
    {
        m_keyItem = keyItem
    }

    public function getKeyItem()
    {
        return m_keyItem
    }

    public function getLayout()
    {
        return m_layoutType
    }

    public function getPatternType()
    {
        return m_patternType
    }

    public function isValid():Boolean
    {
        return m_patternType != PrefebPatterns.PT_INVALID
    }

    public function releaseThis()
    {
        reset()
        PatternPool.releaseAPattern(this)
    }

    public function fire()
    {
        trace("Patterns.fire")
        showDebugInfo()
        var len = m_items.length
        for(var i=0; i<len ; ++i)
        {
            var item = m_items[i]
            if(item)
            {
                item.fire()
            }
        }
        releaseThis()
    }

    public function setPatternType(patternType:Number)
    {
        if(m_patternType == patternType)
        {
            return
        }

        trace("setPatternType " + patternType)
        m_patternType = patternType
        if(m_patternType != PrefebPatterns.PT_INVALID)
        {
            if(m_items[0] == null and m_items[1] == null)
            {
                m_items[0] = m_items[2]
                m_items[1] = m_items[3]
                m_items[2] = m_items[4]
                m_items[3] = null
                m_items[4] = null
                m_patterns[0] = m_patterns[2]
                m_patterns[1] = m_patterns[3]
                m_patterns[2] = m_patterns[4]
                m_patterns[3] = ItemBehavior.NONE
                m_patterns[4] = ItemBehavior.NONE
            }
            else if(m_items[0] == null)
            {
                m_items[0] = m_items[1]
                m_items[1] = m_items[2]
                m_items[2] = m_items[3]
                m_items[3] = m_items[4]
                m_items[4] = null
                m_patterns[0] = m_patterns[1]
                m_patterns[1] = m_patterns[2]
                m_patterns[2] = m_patterns[3]
                m_patterns[3] = m_patterns[4]
                m_patterns[4] = ItemBehavior.NONE
            }
        }
    }

    public function checkFire()
    {
        var len = m_items.length
        for(var i=0; i<len ; ++i)
        {
            var item = m_items[i]
            if(item and not item.canFire())
            {
                return
            }
        }
        m_fireCounter = MAX_FIRE_DELAY_COUNT
    }

    public function update(dt)
    {
        if(m_patternType == PrefebPatterns.PT_INVALID)
        {
            return
        }

        if(m_fireCounter == -1)
        {
            checkFire()
        }
        else if(m_fireCounter == 0)
        {
            fire()
        }
        else
        {
            m_fireCounter -= 1
            checkToAddNewItem()
        }
    }
    public function getPatternValue()
    {
        return m_patterns
    }

    public function getItems()
    {
        return m_items;
    }
    public function showDebugInfo()
    {
        trace("pattern info ==========")
        trace(getName())
        trace("layoutType " + m_layoutType)
        trace("itemTypes: " + m_items[0].getItemType() + " " + m_items[1].getItemType() + " " + m_items[2].getItemType() + "  " + m_items[3].getItemType() + "  " + m_items[4].getItemType() )
        trace("patterns: " + m_patterns[0] + " " + m_patterns[1] + " " + m_patterns[2] + "  " + m_patterns[3] + "  " + m_patterns[4] )
        trace("m_patternType " + m_patternType)
        trace("======================")
    }

    public function checkToAddNewItem()
    {
        if(m_patternType == PrefebPatterns.PT_INVALID or m_patternType == PrefebPatterns.PT_FIVE)
        {
            return
        }

        var firstItem   = m_items[0]
        var lastItem    = null
        var preFirstItem = null
        var afterLastItem= null
        if(m_patternType == PrefebPatterns.PT_THREE)
        {
            lastItem = m_items[2]
        }
        else if(m_patternType == PrefebPatterns.PT_FOUR)
        {
            lastItem = m_items[3]
        }

        var gemMatrix = PatternPool.getGemMatrix()
        if(m_layoutType == Patterns.LAYOUT_VERTICAL)
        {
            preFirstItem = gemMatrix.getItem(firstItem.getGridX(), firstItem.getGridY() - 1)
            afterLastItem= gemMatrix.getItem(lastItem.getGridX(), lastItem.getGridY() + 1)
        }
        else
        {
            preFirstItem = gemMatrix.getItem(firstItem.getGridX() - 1, firstItem.getGridY())
            afterLastItem= gemMatrix.getItem(lastItem.getGridX() + 1, lastItem.getGridY())
        }
        if(ItemBehavior.getItemPatternType(this, preFirstItem, getKeyItem()) == ItemBehavior.SAME)
        {
            for(var i=5; i>0; --i)
            {
                m_items[i] = m_items[i-1]
                m_patterns[i] = m_patterns[i-1]
            }
            m_items[0] = preFirstItem
            m_patterns[0] = ItemBehavior.SAME
            if(m_patternType == PrefebPatterns.PT_THREE)
            {
                m_patternType = PrefebPatterns.PT_FOUR
            }
            else if(m_patternType == PrefebPatterns.PT_FOUR)
            {
                m_patternType = PrefebPatterns.PT_FIVE
            }
            m_keyItem.checkNextInnerType()
            preFirstItem.setInPattern(this)
            m_fireCounter = -1
            trace("find a preItem ")
            showDebugInfo()
            preFirstItem.showDebugInfo()
        }
        else if(ItemBehavior.getItemPatternType(this, afterLastItem, getKeyItem()) == ItemBehavior.SAME)
        {
            if(m_patternType == PrefebPatterns.PT_THREE)
            {
                m_items[3] = afterLastItem
                m_patterns[3] = ItemBehavior.SAME
                m_patternType = PrefebPatterns.PT_FOUR
                afterLastItem.setInPattern(this)
            }
            else if(m_patternType == PrefebPatterns.PT_FOUR)
            {
                m_items[4] = afterLastItem
                m_patterns[4] = ItemBehavior.SAME
                m_patternType = PrefebPatterns.PT_FIVE
                afterLastItem.setInPattern(this)
            }
            else
            {
                return
            }
            m_keyItem.checkNextInnerType()
            m_fireCounter = -1
            trace("find a afterItem ")
            showDebugInfo()
            afterLastItem.showDebugInfo()
        }
    }

    public function checkIsValid()
    {
        rePattern()
        if(m_patternType != PrefebPatterns.PT_INVALID)
        {
            var len = m_items.length
            for (var i=0; i<len ; ++i)
            {
                var item = m_items[i]
                if(item and m_patterns[i] == ItemBehavior.SAME)
                {
                    item.setInPattern(this)
                }
            }
        }
        else
        {
            releaseThis()
        }
    }

    public function rePattern()
    {
        m_patterns[0] = ItemBehavior.getItemPatternType(this, m_items[0], m_items[2])
        m_patterns[1] = ItemBehavior.getItemPatternType(this, m_items[1], m_items[2])
        m_patterns[2] = ItemBehavior.getItemPatternType(this, m_items[2], m_items[2])
        m_patterns[3] = ItemBehavior.getItemPatternType(this, m_items[3], m_items[2])
        m_patterns[4] = ItemBehavior.getItemPatternType(this, m_items[4], m_items[2])
        PrefebPatterns.checkPattern(this)

//        if(m_patternType != PrefebPatterns.PT_INVALID)
//        {
//            trace("find a valid pattern")
//            showDebugInfo()
//        }
    }

    static public function tryToFindAValidPattern(triggerType:Number, layoutType:Number, item:Item):Patterns
    {
        var pattern = PatternPool.getAPattern()
        pattern.constructPattern(triggerType, layoutType, item.getGridX(), item.getGridY())
        pattern.setKeyItem(item)
        pattern.checkIsValid()
        if(pattern.isValid())
        {
            return pattern
        }
        else
        {
            return null
        }
    }

    public function constructPattern(triggerType:Number,layoutType:Number, centerGridX, centerGridY)
    {
//        trace("constructPattern " + centerGridX + "  " + centerGridY)
        var gemMatrix = PatternPool.getGemMatrix()
        m_layoutType = layoutType
        setTriggerType(triggerType)
        if(m_layoutType == Patterns.LAYOUT_VERTICAL)
        {
            m_items[0] = gemMatrix.getItem(centerGridX , centerGridY - 2)
            m_items[1] = gemMatrix.getItem(centerGridX , centerGridY - 1)
            m_items[2] = gemMatrix.getItem(centerGridX , centerGridY - 0)
            m_items[3] = gemMatrix.getItem(centerGridX , centerGridY + 1)
            m_items[4] = gemMatrix.getItem(centerGridX , centerGridY + 2)
        }
        else if(m_layoutType == Patterns.LAYOUT_HORIZONTAL)
        {
            m_items[0] = gemMatrix.getItem(centerGridX - 2, centerGridY)
            m_items[1] = gemMatrix.getItem(centerGridX - 1, centerGridY)
            m_items[2] = gemMatrix.getItem(centerGridX - 0, centerGridY)
            m_items[3] = gemMatrix.getItem(centerGridX + 1, centerGridY)
            m_items[4] = gemMatrix.getItem(centerGridX + 2, centerGridY)
        }
    }

    public function setItemToIndex(item:Item, idx:Number)
    {
        m_items[idx] = item
    }

    public function swapItem(item1:Item, item2:Item)
    {
        var item1Index = -1
        var item2Index = -1
        for(var i=0; i<5; ++i)
        {
            if(item1.getID() == m_items[i].getID())
            {
                item1Index = i;
            }
            else if(item2.getID() == m_items[i].getID())
            {
                item2Index = i;
            }
        }
        var tempItem = m_items[item1Index]
        m_items[item1Index] = m_items[item2Index]
        m_items[item2Index] = tempItem
    }
}
