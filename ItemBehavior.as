import Item

class ItemBehavior
{
    static public var NONE          = 1
    static public var SAME          = 2
    static public var DIFFERIENT    = 3

    static public function getItemPatternType(itemBeenTest:Item, itemRef:Item)
    {
        if(not itemBeenTest)
        {
            return NONE;
        }
        else if(itemBeenTest.getItemType() == itemRef.getItemType())
        {
            return SAME;
        }
        else
        {
            return DIFFERIENT;
        }
    }
}
