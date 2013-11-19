import GemMatrix;
import MovieClip;
class GemStage extends MovieClip {
    public var m_gemMatrix:GemMatrix;
    public function GemStage() {
        onPress = function()
        {
            m_gemMatrix.handlePanelPress()
        }
        this.onRelease = function()
        {
            m_gemMatrix.handlePanelRelease()
        }
    }
    public function setGemMatrix(gemMatrix:GemMatrix)
    {
        m_gemMatrix = gemMatrix
    }
}


