import Debugger;
import Item;
import GemPool;
import GemMatrix;

class GemBuilder {
    public var m_baseXPos:Number;
    public var m_baseYPos:Number;
    public var m_baseXIndex:Number;
    public var m_maxYIndex:Number;
    public var m_gemPool;
    public var m_gemList:Array;
    public var m_builderName:String;
    public var m_gemMatrix:GemMatrix;

    public function GemBuilder(gemPool:GemPool, gemMatrix:GemMatrix, baseXPos:Number, baseYPos:Number, baseXIndex:Number, maxYIndex:Number)
    {
        m_baseXPos  = baseXPos;
        m_baseYPos  = baseYPos;
        m_baseXIndex = baseXIndex;
        m_maxYIndex  = maxYIndex;
        m_gemPool = gemPool;
        m_builderName = "Builder" + m_baseXIndex
        m_gemList = new Array();
        m_gemMatrix = gemMatrix;
    }

    public function getBaseGridX(): Number
    {
        return m_baseXIndex;
    }

    public function getBaseYPos() : Number
    {
        return m_baseYPos;
    }
    public function update(dt)
    {
        if(m_gemList[0] == null)
        {
            var firstValidItem = null
            for(var i=1; i<m_maxYIndex; ++i)
            {
                if(m_gemList[i])
                {
                    firstValidItem = m_gemList[i]
                    break;
                }
            }
            if(not firstValidItem or firstValidItem._y >= m_baseYPos)
            {
                genANewItem()
            }
        }

        var len = m_gemList.length
        for(var i = len - 1; i>=0; --i)
        {
            m_gemList[i].update(dt)
        }
    }

    public function removeItem(item:Item)
    {
        if(not m_gemList[item.getGridY()] == item)
        {
            trace("ERROR:" + "remove item not belong to gemBuilder")
        }
        for(var i=item.getGridY(); i>0; --i)
        {
            m_gemList[i] = m_gemList[i-1]
            var gem = m_gemList[i]
            if(gem)
            {
                gem.setGridY(gem.getGridY() + 1)
            }
        }
        m_gemList[0] = null
        m_gemPool.releaseItem(item)
    }

    public function setItemToIndex(item:Item, gridIndex:Number)
    {
        m_gemList[gridIndex] = item
        item.setGridX(m_baseXIndex)
        item.setGridY(gridIndex)
        item.setParent(this, m_gemMatrix)
    }

    public function isItemReachButtom(item:Item):Boolean
    {
        return item.getGridY() >= m_maxYIndex -1;
    }

    public function getItem(gridIndex):Item
    {
        return m_gemList[gridIndex];
    }

    public function getRandomTypeIndexExcept(excludeType1:Number, excludeType2:Number)
    {
        if(excludeType1 != null and excludeType2 != null)
        {
            var tempArray = new Array()
            var maxLen = GemPool.getAllGemTypeSize() - 2
            var nextIndex = 0;
            for(var i=0; i<maxLen; ++i)
            {
                if(nextIndex == excludeType1 or nextIndex == excludeType2)
                {
                    nextIndex++
                    if(nextIndex == excludeType1 or nextIndex == excludeType2)
                    {
                        nextIndex++;
                    }
                }
                tempArray[i] = nextIndex++;
            }
            var randomIndex = Math.round(Math.random() * (maxLen -1))
            return tempArray[randomIndex]
        }
        else if(excludeType1 != null)
        {
            return (excludeType1 + 1) % (GemPool.getAllGemTypeSize()-1)
        }
        else if(excludeType2 != null)
        {
            return (excludeType2 + 1) % (GemPool.getAllGemTypeSize()-1)
        }
        else
        {
            return Math.round(Math.random() * (GemPool.getAllGemTypeSize() -1))
        }
    }

    public function getARandomValidItemType(gridY:Number)
    {
        var excludeType1 = null
        var excludeType2 = null
        if(m_baseXIndex > 1)
        {
            var leftItem1 = m_gemMatrix.getItem(m_baseXIndex-1,gridY)
            var leftItem2 = m_gemMatrix.getItem(m_baseXIndex-2,gridY)
            if(leftItem1.getItemType() == leftItem2.getItemType())
            {
                excludeType1 = GemPool.getIndexFromTypeName(leftItem1.getItemType())
            }
        }
        if(gridY > 1)
        {
            var topItem1 = m_gemList[gridY - 1]
            var topItem2 = m_gemList[gridY - 2]
            if(topItem1.getItemType() == topItem2.getItemType())
            {
                excludeType2 = GemPool.getIndexFromTypeName(topItem1.getItemType())
            }
        }
        var randomIndex = getRandomTypeIndexExcept(excludeType1, excludeType2)
        var itemType = GemPool.getTypeNameFromIndex(randomIndex)
        return itemType
    }

    public function recreateGemBuilder()
    {
        for(var i=0; i<m_maxYIndex; ++i)
        {
            var gem:Item = m_gemPool.getAGem();
            var itemType = getARandomValidItemType(i)
            gem.setItemType(itemType)
            gem._x = m_baseXPos
            gem._y = m_baseYPos + i * Item.GemHeight
            gem.setGridX(m_baseXIndex)
            gem.setGridY(i)
            gem.setParent(this,m_gemMatrix)
            m_gemList[i] = gem
        }
    }

    public function genANewItem()
    {
        var gem:Item = m_gemPool.getAGem();
        var randomType = Math.round(Math.random() * (GemPool.getAllGemTypeSize() -1))
        var itemType = GemPool.getTypeNameFromIndex(randomType)
        gem.setItemType(itemType)
        gem._x = m_baseXPos
        gem._y = m_baseYPos - Item.GemHeight
        gem.setGridX(m_baseXIndex)
        gem.setGridY(0)
        gem.setParent(this,m_gemMatrix)
        m_gemList[0] = gem
//        trace("genANewItem")
//        trace("y" + gem._y)
//        trace("m_baseYPos " + m_baseYPos)
//        trace("itemHeight" + Item.GemHeight)
    }
}
