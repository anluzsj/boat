import Item;
import GemPool;
import GemBuilder;
import GemMatrix;
import GemStage;
import PatternPool;
import SwapHandle;

var g_frameCounter = 0
var g_gemMatrix = new GemMatrix(8, 8, _root.Panel)
_root.Panel.setGemMatrix(g_gemMatrix)
PatternPool.init(10)
SwapHandle.init(g_gemMatrix)

_root.onEnterFrame = function()
{
    g_frameCounter++;
    if(g_frameCounter >= 14)
    {
    //    return
    }
    g_gemMatrix.update(60)
    PatternPool.update(60)
}
