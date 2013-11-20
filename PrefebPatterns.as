import Item
import GemMatrix
import ItemBehavior
import Patterns;
class PrefebPatterns
{
    static public var PT_THREE      = 1;
    static public var PT_FOUR       = 2;
    static public var PT_FIVE       = 3;
    static public var PT_INVALID    = 4;

    static public function checkPattern(patternToCheck:Patterns):Boolean
    {
//        trace("checkPattern")
        var patterns = patternToCheck.getPatternValue()
        var items   = patternToCheck.getItems()
//        trace(patterns[0] + "  "+ patterns[1] + "  " +  patterns[2] + "  " +patterns[3] + "  " + patterns[4])
        if((patterns[0] == ItemBehavior.SAME) and
            (patterns[1] == ItemBehavior.SAME) and
            (patterns[2] == ItemBehavior.SAME) and
            (patterns[3] == ItemBehavior.SAME) and
            (patterns[4] == ItemBehavior.SAME) )
        {
            patternToCheck.setPatternType(PrefebPatterns.PT_FIVE)
            return true
        }
        else if((patterns[0] == ItemBehavior.SAME) and
            (patterns[1] == ItemBehavior.SAME) and
            (patterns[2] == ItemBehavior.SAME) and
            (patterns[3] == ItemBehavior.SAME) )
        {
            patterns[4] = ItemBehavior.NONE
            items[4] = null
            patternToCheck.setPatternType(PrefebPatterns.PT_FOUR)
            return true
        }
        else if((patterns[1] == ItemBehavior.SAME) and
            (patterns[2] == ItemBehavior.SAME) and
            (patterns[3] == ItemBehavior.SAME) and
            (patterns[4] == ItemBehavior.SAME) )
        {
            patterns[0] = ItemBehavior.NONE
            items[0] = null
            patternToCheck.setPatternType(PrefebPatterns.PT_FOUR)
            return true
        }
        else if((patterns[0] == ItemBehavior.SAME) and
            (patterns[1] == ItemBehavior.SAME) and
            (patterns[2] == ItemBehavior.SAME))
        {
            patterns[3] = ItemBehavior.NONE
            items[3] = null
            patterns[4] = ItemBehavior.NONE
            items[4] = null
            patternToCheck.setPatternType(PrefebPatterns.PT_THREE)
            return true
        }
        else if((patterns[1] == ItemBehavior.SAME) and
            (patterns[2] == ItemBehavior.SAME) and
            (patterns[3] == ItemBehavior.SAME))
        {
            patterns[0] = ItemBehavior.NONE
            items[0] = null
            patterns[4] = ItemBehavior.NONE
            items[4] = null
            patternToCheck.setPatternType(PrefebPatterns.PT_THREE)
            return true
        }
        else if((patterns[2] == ItemBehavior.SAME) and
            (patterns[3] == ItemBehavior.SAME) and
            (patterns[4] == ItemBehavior.SAME))
        {
            patterns[0] = ItemBehavior.NONE
            items[0] = null
            patterns[1] = ItemBehavior.NONE
            items[1] = null
            patternToCheck.setPatternType(PrefebPatterns.PT_THREE)
            return true
        }
        else
        {
            patternToCheck.setPatternType(PrefebPatterns.PT_INVALID)
            return false
        }
    }
}

