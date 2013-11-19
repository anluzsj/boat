import Item
import GemMatrix
import Patterns;
class PatternPool
{
    static public var m_freePatternList:Array
    static public var m_allPatternList:Array
    public function PatternPool()
    {
    }

    static public function init(sz:Number)
    {
        m_freePatternList   = new Array()
        m_allPatternList    = new Array()
        for(var i=0; i<sz; ++i)
        {
            var pattern = new Patterns();
            m_freePatternList.push(pattern)
            m_allPatternList.push(pattern)
        }
    }
    static public function update(dt)
    {
        var len = m_allPatternList.length
        for(var i=0; i<len; ++i)
        {
            m_allPatternList[i].update(dt)
        }

    }
    static public function getAPattern()
    {
        if(m_freePatternList.length <= 0)
        {
            for(var i=0; i<3; ++i)
            {
                var pattern = new Patterns();
                m_freePatternList.push(pattern)
                m_allPatternList.push(pattern)
            }
        }
        return m_freePatternList.pop()
    }

    static public function releaseAPattern(pattern:Patterns)
    {
        m_freePatternList.push(pattern)
    }
}

