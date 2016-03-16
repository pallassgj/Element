import Foundation
/**
 * HorizontalNodeSlider is used when 2 sliders are need, as in section definition or zoom, or gradient values
 * // :TODO: to get the toFront method working you need to support relative positioning, currently the Element framework doesnt support this
 * // :TODO: support for custom node shape design
 * // :TODO: when implimenting selectgroup functionality you need to be able to change set the selection on press not on release (You might need to impliment NodeButton that impliments iselectable in order to make this happen)
 */
class VNodeSlider:Element{
    var startNode:SelectButton?
    var endNode:SelectButton?
    var selectGroup:SelectGroup?
    var nodeHeight:CGFloat
    var tempNodeMouseY:CGFloat?
    var startProgress:CGFloat
    var endProgress:CGFloat
    init(_ width:CGFloat = NaN, _ height:CGFloat = NaN, _ nodeHeight:CGFloat = NaN, _ startProgress:CGFloat = 0, _ endProgress:CGFloat = 1, _ parent:IElement? = nil, _ id:String? = nil, _ classId:String? = nil) {
        self.startProgress = startProgress
        self.endProgress = endProgress
        self.nodeHeight = nodeHeight.isNaN ? width:nodeHeight
        super.init(width, height, parent, id)
    }
    override func resolveSkin() {
        super.resolveSkin();
        startNode = addSubView(SelectButton(width, nodeHeight,false,self,"start"))
        setStartProgress(startProgress)
        endNode = addSubView(SelectButton(width, nodeHeight,false,self,"end"))
        setEndProgress(endProgress)
        selectGroup = SelectGroup([startNode!,endNode!],startNode)
    }
    func onStartNodeDown(event : ButtonEvent) {
//		DepthModifier.toFront(_startNode, this);// :TODO: this may now work since they are floating:none
        tempNodeMouseY = startNode.mouseY
        //add on move listener here
    }
    func onEndNodeDown(event : ButtonEvent) {
//		DepthModifier.toFront(_endNode, this);// :TODO: this may now work since they are floating:none
        tempNodeMouseY = _endNode.mouseY
        //add on move listener here
    }
    func onStartNodeMove(event : MouseEvent) {
        startProgress = Utils.progress(self.mouseY, tempNodeMouseY, height, nodeHeight)
        startNode.y = Utils.nodePosition(startProgress, height, nodeHeight)
        NodeSliderEvent(NodeSliderEvent.change,startProgress,endProgress,startNode)
    }
    func onEndNodeMove(event : MouseEvent) {
        endProgress = Utils.progress(this.mouseY, tempNodeMouseY, height, nodeHeight)
        endNode.y = Utils.nodePosition(endProgress, height, nodeHeight)
        NodeSliderEvent(NodeSliderEvent.change,startProgress,endProgress,endNode)
    }
    func onStartNodeUp(event : MouseEvent) {
        //remove listener
    }
    func onEndNodeUp(event : MouseEvent) {
        //remove listener
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}