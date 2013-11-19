import Item
import GemMatrix
import ItemBehavior
import PrefebPatterns;
import PatternPool;

class Patterns
{
    public var m_patterns:Array;
    public var m_items:Array;
    public var m_layoutType;
    public var m_patternType;
    static public var LAYOUT_VERTICAL_5     = 1
    static public var LAYOUT_HORIZONTAL_5   = 2

    public function Patterns()
    {
        m_patterns  = new Array()
        m_items     = new Array()
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
    }
    public function isValid():Boolean
    {
        return m_patternType != PrefebPatterns.PT_INVALID
    }
    public function fire()
    {
        trace("Patterns.fire")
        var len = m_items.length
        for(var i=0; i<len ; ++i)
        {
            var item = m_items[i]
            if(item and m_patterns[i] == ItemBehavior.SAME)
            {
                item.playAnim("destroy")
            }
        }
        reset()
        PatternPool.releaseAPattern(this)
    }

    public function setPatternType(patternType:Number)
    {
        trace("setPatternType " + patternType)
        m_patternType = patternType
    }

    public function checkFire()
    {
        var len = m_items.length
        for(var i=0; i<len ; ++i)
        {
            var item = m_items[i]
            if(item and item.getItemStatus() != Item.GEM_STATUS_IDLE)
            {
                return
            }
        }

        fire()
    }

    public function update(dt)
    {
        if(m_patternType == PrefebPatterns.PT_INVALID)
        {
            return
        }
        checkFire()
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
        trace("itemTypes: " + m_items[0].getItemType() + " " + m_items[1].getItemType() + " " + m_items[2].getItemType() + "  " + m_items[3].getItemType() + "  " + m_items[4].getItemType() )
        trace("patterns: " + m_patterns[0] + " " + m_patterns[1] + " " + m_patterns[2] + "  " + m_patterns[3] + "  " + m_patterns[4] )
        trace("m_patternType " + m_patternType)
    }
    public function rePattern()
    {
        trace("rePattern " + m_items[0])
        m_patterns[0] = ItemBehavior.getItemPatternType(m_items[0], m_items[2])
        m_patterns[1] = ItemBehavior.getItemPatternType(m_items[1], m_items[2])
        m_patterns[2] = ItemBehavior.getItemPatternType(m_items[2], m_items[2])
        m_patterns[3] = ItemBehavior.getItemPatternType(m_items[3], m_items[2])
        m_patterns[4] = ItemBehavior.getItemPatternType(m_items[4], m_items[2])
        PrefebPatterns.checkPattern(this)
        showDebugInfo()
        if(m_patternType != PrefebPatterns.PT_INVALID)
        {
            var len = m_items.length
            for (var i=0; i<len ; ++i)
            {
                var item = m_items[i]
                if(item and m_patterns[i] == ItemBehavior.SAME)
                {
                    item.setTag(Item.TAG_DESTROY)
                }
            }
        }
    }

    public function constructPattern(layoutType:Number, gemMatrix:GemMatrix, centerGridX, centerGridY, centerItem:Item)
    {
//        trace("constructPattern " + centerGridX + "  " + centerGridY)
        m_layoutType = layoutType
        if(m_layoutType == Patterns.LAYOUT_VERTICAL_5)
        {
            m_items[0] = gemMatrix.getItem(centerGridX , centerGridY - 2)
            m_items[1] = gemMatrix.getItem(centerGridX , centerGridY - 1)
            m_items[2] = gemMatrix.getItem(centerGridX , centerGridY - 0)
            m_items[3] = gemMatrix.getItem(centerGridX , centerGridY + 1)
            m_items[4] = gemMatrix.getItem(centerGridX , centerGridY + 2)
        }
        else if(m_layoutType == Patterns.LAYOUT_HORIZONTAL_5)
        {
            m_items[0] = gemMatrix.getItem(centerGridX - 2, centerGridY)
            m_items[1] = gemMatrix.getItem(centerGridX - 1, centerGridY)
            m_items[2] = gemMatrix.getItem(centerGridX - 0, centerGridY)
            m_items[3] = gemMatrix.getItem(centerGridX + 1, centerGridY)
            m_items[4] = gemMatrix.getItem(centerGridX + 2, centerGridY)
        }
        if(centerItem)
        {
            m_items[2] = centerItem
        }
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
