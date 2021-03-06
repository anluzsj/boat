import Item;
import GemMatrix;
import GemBuilder;
import Patterns;
import PrefebPattern;
import PatternPool;
class SwapHandle
{
    static public var m_gemMatrix:GemMatrix

    static public function init(gemMatrix:GemMatrix)
    {
        m_gemMatrix = gemMatrix
    }

    static public function trySwap(item1:Item, item2:Item):Boolean
    {
        var item1VerticalPattern    = PatternPool.getAPattern()
        var item1HorizontalPattern  = PatternPool.getAPattern()
        var item2VerticalPattern    = PatternPool.getAPattern()
        var item2HorizontalPattern  = PatternPool.getAPattern()
        if(item1.getGridX() == item2.getGridX() and Math.abs(item1.getGridY() - item2.getGridY()) == 1)
        {
            item1VerticalPattern.constructPattern(Patterns.TRIGGERED_BY_SWAP, Patterns.LAYOUT_VERTICAL, item2.getGridX(), item2.getGridY())
            item1VerticalPattern.swapItem(item1, item2)
            item2VerticalPattern.constructPattern(Patterns.TRIGGERED_BY_SWAP,Patterns.LAYOUT_VERTICAL,item1.getGridX(), item1.getGridY())
            item2VerticalPattern.swapItem(item1, item2)
            item1HorizontalPattern.constructPattern(Patterns.TRIGGERED_BY_SWAP,Patterns.LAYOUT_HORIZONTAL,item2.getGridX(), item2.getGridY())
            item1HorizontalPattern.setItemToIndex(item1, 2)
            item2HorizontalPattern.constructPattern(Patterns.TRIGGERED_BY_SWAP,Patterns.LAYOUT_HORIZONTAL, item1.getGridX(), item1.getGridY())
            item2HorizontalPattern.setItemToIndex(item2, 2)
        }
        else if(item1.getGridY() == item2.getGridY() and Math.abs(item1.getGridX() - item2.getGridX()) == 1)
        {
            item1VerticalPattern.constructPattern(Patterns.TRIGGERED_BY_SWAP,Patterns.LAYOUT_VERTICAL, item2.getGridX(), item2.getGridY())
            item1VerticalPattern.setItemToIndex(item1, 2)
            item2VerticalPattern.constructPattern(Patterns.TRIGGERED_BY_SWAP,Patterns.LAYOUT_VERTICAL, item1.getGridX(), item1.getGridY(), item2)
            item2VerticalPattern.setItemToIndex(item2, 2)
            item1HorizontalPattern.constructPattern(Patterns.TRIGGERED_BY_SWAP,Patterns.LAYOUT_HORIZONTAL,item2.getGridX(), item2.getGridY())
            item1HorizontalPattern.swapItem(item1, item2)
            item2HorizontalPattern.constructPattern(Patterns.TRIGGERED_BY_SWAP,Patterns.LAYOUT_HORIZONTAL,item1.getGridX(), item1.getGridY())
            item2HorizontalPattern.swapItem(item1, item2)
        }
        else
        {
            trace("Error:Invalid move " + item1.getGridX() + " " + item1.getGridY() + "  " + item2.getGridX() + "  " + item2.getGridY())
        }

        item1VerticalPattern.setKeyItem(item1)
        item1HorizontalPattern.setKeyItem(item1)
        item2VerticalPattern.setKeyItem(item2)
        item2HorizontalPattern.setKeyItem(item2)

        item1VerticalPattern.checkIsValid()
        item1HorizontalPattern.checkIsValid()
        item2VerticalPattern.checkIsValid()
        item2HorizontalPattern.checkIsValid()

        if(item1VerticalPattern.isValid() or
            item1HorizontalPattern.isValid() or
            item2VerticalPattern.isValid() or
            item2HorizontalPattern.isValid() )
        {
            return true
        }
        else
        {
            return false
        }
    }
}
