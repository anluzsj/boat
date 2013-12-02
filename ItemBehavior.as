import Item
import Patterns

class ItemBehavior
{
    static public var NONE          = 1
    static public var SAME          = 2
    static public var DIFFERIENT    = 3

    static public function getItemPatternType(pattern:Patterns, itemBeenTest:Item, itemRef:Item)
    {
        if(not itemBeenTest or not itemRef or not itemBeenTest.canBeUsedInPattern(pattern.getLayout()))
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
