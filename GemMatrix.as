import Item;
import GemPool;
import GemBuilder;
import SwapHandle;
import Patterns;

class GemMatrix{
    public var m_gemPool:GemPool;
    public var m_gemBuilderList:Array;
    public var m_maxGridX:Number;
    public var m_maxGridY:Number;
    public var m_firstItemGridX:Number;
    public var m_firstItemGridY:Number;
    public var m_firstItem:Item;
    public var m_secondItemGridX:Number;
    public var m_secondItemGridY:Number;
    public var m_secondItem:Item;
    public var m_panel:MovieClip;
    public var m_isPressed:Boolean = false;

    public function GemMatrix(maxGridX:Number, maxGridY:Number, panel:MovieClip)
    {
        m_maxGridX = maxGridX
        m_maxGridY = maxGridY
        m_panel = panel
        m_gemPool = new GemPool(maxGridX * maxGridY, m_panel)
        m_gemBuilderList = new Array();
        for(var i=0; i<maxGridX; ++i)
        {
            m_gemBuilderList[i] = new GemBuilder(m_gemPool, this, i*Item.GemWidth, 0, i, maxGridY)
        }
        recreateMatrix()
    }

    public function tryToFindComboPattern(item:Item)
    {
        var verticalPattern = Patterns.tryToFindAValidPattern(Patterns.TRIGGERED_BY_COMBO, Patterns.LAYOUT_VERTICAL, item)
        var horizontalPattern = Patterns.tryToFindAValidPattern(Patterns.TRIGGERED_BY_COMBO, Patterns.LAYOUT_HORIZONTAL, item)

        return verticalPattern or horizontalPattern
    }

    public function recreateMatrix()
    {
        for(var i=0; i<m_maxGridX; ++i)
        {
            m_gemBuilderList[i].recreateGemBuilder()
        }
    }

    public function handlePanelPress()
    {
        var xMouse = m_panel._xMouse
        var yMouse = m_panel._yMouse
        m_firstItemGridX = Math.floor(xMouse/Item.GemWidth)
        m_firstItemGridY = Math.floor(yMouse/Item.GemHeight)
        if(m_firstItemGridX >= m_maxGridX || m_firstItemGridY >= m_maxGridY)
        {
            m_firstItemGridX = -1;
            m_firstItemGridY = -1;
            return
        }
        m_isPressed = true
        m_firstItem = getItem(m_firstItemGridX, m_firstItemGridY)
//        trace("handlePanelPress " + m_firstItem  + m_firstItemGridX + "  " + m_firstItemGridY)
//        trace("itemPos "+ m_firstItem.getGridX() + "  " + m_firstItem.getGridY())
    }

    public function handlePanelRelease()
    {
        m_isPressed = false
        m_firstItemGridX = -1;
        m_firstItemGridY = -1;
        m_firstItem = null
        m_secondItemGridX = -1;
        m_secondItemGridY = -1;
        m_secondItem = null
    }

    public function getGemBuilder(gridX)
    {
        return m_gemBuilderList[gridX]
    }

    public function getItem(gridX, gridY):Item
    {
//        trace("GemMatrix:getItem " + gridX + gridY)
        if(m_gemBuilderList[gridX])
        {
            return m_gemBuilderList[gridX].getItem(gridY)
        }
        return null
    }

    public function setItemToIndex(item:Item, gridX:Number, gridY:Number)
    {
//        trace("GemMatrix:setItemToIndex " + item + " " + gridX + "  " + gridY)
//        trace(item.getGridX())
//        trace(item.getGridY())
        var gemBuilder = getGemBuilder(gridX)
        gemBuilder.setItemToIndex(item, gridY)
    }

    public function triggerSwapItem()
    {
        if(m_firstItem and m_secondItem and m_firstItem.canSwap() and m_secondItem.canSwap())
        {
            var isValidSwap = SwapHandle.trySwap(m_firstItem, m_secondItem)
            m_firstItem.swapDepths(m_firstItem._parent.getNextHighestDepth())
            m_firstItem.setStatus(Item.GEM_STATUS_SWAPING)
            m_secondItem.setStatus(Item.GEM_STATUS_SWAPING)
            if(isValidSwap)
            {
                setItemToIndex(m_firstItem, m_secondItemGridX, m_secondItemGridY)
                setItemToIndex(m_secondItem, m_firstItemGridX, m_firstItemGridY)
            }
            else
            {
                //if it's a invalid swap, change depth
                m_secondItem.setTag(Item.TAG_HIGHEST_DEPTH)
            }

            if(m_firstItemGridX > m_secondItemGridX)
            {
                if(isValidSwap)
                {
                    m_firstItem.playAnim("toLeft")
                    m_secondItem.playAnim("toRight")
                }
                else
                {
                    m_firstItem.playAnim("rollToLeft")
                    m_secondItem.playAnim("rollToRight")
                }
            }
            else if(m_firstItemGridX < m_secondItemGridX)
            {
                if(isValidSwap)
                {
                    m_firstItem.playAnim("toRight")
                    m_secondItem.playAnim("toLeft")
                }
                else
                {
                    m_firstItem.playAnim("rollToRight")
                    m_secondItem.playAnim("rollToLeft")
                }
            }
            else if(m_firstItemGridY > m_secondItemGridY)
            {
                if(isValidSwap)
                {
                    m_firstItem.playAnim("toTop")
                    m_secondItem.playAnim("toButtom")
                }
                else
                {
                    m_firstItem.playAnim("rollToTop")
                    m_secondItem.playAnim("rollToButtom")
                }
            }
            else if(m_firstItemGridY < m_secondItemGridY)
            {
                if(isValidSwap)
                {
                    m_firstItem.playAnim("toButtom")
                    m_secondItem.playAnim("toTop")
                }
                else
                {
                    m_firstItem.playAnim("rollToButtom")
                    m_secondItem.playAnim("rollToTop")
                }
            }
            else
            {
                trace("invalid swap")
            }
        }
    m_isPressed = false;
    m_firstItem = null;
    m_secondItem = null;
}

    public function update(dt:Number)
    {
        var gemBuilderLen = m_gemBuilderList.length
        for(var i=0; i<gemBuilderLen; ++i)
        {
            m_gemBuilderList[i].update(dt)
        }

        if(m_isPressed)
        {
            var xMouse = m_panel._xMouse
            var yMouse = m_panel._yMouse
            m_secondItemGridX = Math.floor(xMouse/Item.GemWidth)
            m_secondItemGridY = Math.floor(yMouse/Item.GemHeight)
            if(m_secondItemGridX >= m_maxGridX || m_secondItemGridY >= m_maxGridY)
            {
                m_secondItemGridX = -1;
                m_secondItemGridY = -1;
                return;
            }
            if((m_firstItemGridX != m_secondItemGridX and m_firstItemGridY == m_secondItemGridY) or (m_firstItemGridX == m_secondItemGridX and m_firstItemGridY != m_secondItemGridY) )
            {
                m_secondItem = getItem(m_secondItemGridX, m_secondItemGridY)
                triggerSwapItem()
            }
        }
    }
}
