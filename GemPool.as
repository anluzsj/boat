import Item;
class GemPool{
    public var m_allGems:Array;
    public var m_freeGems:Array;
    public var m_parentMC:MovieClip;
    static public var m_nextValidID:Number = 1;
    static public var m_gemTypeDef:Array = new Array;
    public function GemPool(initSize:Number, parentMC:MovieClip)
    {
        m_parentMC = parentMC
        m_freeGems = new Array()
        m_allGems  = new Array()
        for(var i=0; i<initSize; ++i)
        {
            var gem = m_parentMC.attachMovie("item_gem", "gem"+i, m_parentMC.getNextHighestDepth())
            gem.setID(m_nextValidID);
            m_nextValidID ++;
            m_freeGems.push(gem)
            m_allGems.push(gem)
//            trace("gemHeight " + gem._height)
//            trace("gemWidth " + gem._width)
//            trace("gemPosX" + gem._x)
//            trace("gemPosY" + gem._y)
            gem.reset()
            gem._visible = false
        }
//        Item.GemWidth = m_allGems[0]._width
//        Item.GemHeight= m_allGems[0]._height
        m_parentMC = parentMC;

        m_gemTypeDef[0] = "blue";
        m_gemTypeDef[1] = "green";
        m_gemTypeDef[2] = "red";
        m_gemTypeDef[3] = "yellow";
        m_gemTypeDef[4] = "gray";
//        m_gemTypeDef[5] = "pink";
    }
    static public function getAllGemTypeSize():Number
    {
        return m_gemTypeDef.length;
    }

    static public function getTypeNameFromIndex(typeIndex:Number) : String
    {
        return m_gemTypeDef[typeIndex];
    }

    static public function getIndexFromTypeName(typeName:String) : String
    {
        var len = m_gemTypeDef.length
        for(var i=0; i<len; ++i)
        {
            if(m_gemTypeDef[i] == typeName)
            {
                return i
            }
        }
        trace("Error: unknow typeName " + typeName)
    }
    public function getAGem() : Item
    {
        if(m_freeGems.length <=0)
        {
            for(var i=0; i<5; ++i)
            {
                var gem = m_parentMC.attachMovie("item_gem", "gem"+i, m_parentMC.getNextHighestDepth())
                gem.setID(m_nextValidID);
                m_nextValidID ++;
                m_freeGems.push(gem)
                m_allGems.push(gem)
                gem.reset()
                gem._visible = false
            }
        }
        var item = m_freeGems.pop()
        item._visible = true
        return item
    }

    public function releaseGem(item:Item)
    {
        item._visible = false
        item.reset()
        m_freeGems.push(item)
    }

    public function updateAll(dt:Number)
    {
        var len = m_allGems.length
        for (var i=0; i<len; ++i)
        {
            var item = m_allGems[i]
            if(item._visible)
            {
                item.update(dt)
            }
        }
    }
}
