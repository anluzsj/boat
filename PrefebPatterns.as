import Item
import GemMatrix
import ItemBehavior
import Patterns;
class PrefebPatterns
{
    static public var PT_THREE_MID   = 1;
    static public var PT_THREE_LEFT  = 2;
    static public var PT_THREE_RIGHT = 3;
    static public var PT_FOUR_LEFT   = 4;
    static public var PT_FOUR_RIGHT  = 5;
    static public var PT_FIVE        = 6;
    static public var PT_INVALID     = 7;

    static public function checkPattern(patternToCheck:Patterns):Boolean
    {
        trace("checkPattern")
        var patterns = patternToCheck.getPatternValue()
        trace(patterns[0] + "  "+ patterns[1] + "  " +  patterns[2] + "  " +patterns[3] + "  " + patterns[4])
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
            patternToCheck.setPatternType(PrefebPatterns.PT_FOUR_LEFT)
            return true
        }
        else if((patterns[1] == ItemBehavior.SAME) and
            (patterns[2] == ItemBehavior.SAME) and
            (patterns[3] == ItemBehavior.SAME) and
            (patterns[4] == ItemBehavior.SAME) )
        {
            patternToCheck.setPatternType(PrefebPatterns.PT_FOUR_RIGHT)
            return true
        }
        else if((patterns[0] == ItemBehavior.SAME) and
            (patterns[1] == ItemBehavior.SAME) and
            (patterns[2] == ItemBehavior.SAME))
        {
            patternToCheck.setPatternType(PrefebPatterns.PT_THREE_LEFT)
            return true
        }
        else if((patterns[1] == ItemBehavior.SAME) and
            (patterns[2] == ItemBehavior.SAME) and
            (patterns[3] == ItemBehavior.SAME))
        {
            patternToCheck.setPatternType(PrefebPatterns.PT_THREE_MID)
            return true
        }
        else if((patterns[2] == ItemBehavior.SAME) and
            (patterns[3] == ItemBehavior.SAME) and
            (patterns[4] == ItemBehavior.SAME))
        {
            patternToCheck.setPatternType(PrefebPatterns.PT_THREE_MID)
            return true
        }
        else
        {
            patternToCheck.setPatternType(PrefebPatterns.PT_INVALID)
            return false
        }
    }
}

