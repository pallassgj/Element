import Cocoa
@testable import Utils
/**
 * HSlider is a simple horizontal slider
 * NOTE: the reason we have two sliders instead of 1 is because otherwise the math and variable naming scheme becomes too complex (same goes for the idea of extending a Slider class)
 * TODO: consider having thumbWidth and thumbHeight, its just easier to understand
 */
class HSlider:Element{
    var progress:CGFloat
    var thumbWidth:CGFloat
    var thumb:Button?
    var tempThumbMouseX:CGFloat = 0/*This value holds the onDown position when you click the thumb*/
    var leftMouseDraggedEventListener:Any? = nil
    init(_ width:CGFloat, _ height:CGFloat, _ thumbWidth:CGFloat = NaN, _ progress:CGFloat = 0, _ parent:IElement? = nil, _ id:String? = nil, _ classId:String? = nil) {
        self.progress = progress
        self.thumbWidth = thumbWidth.isNaN ? height:thumbWidth
        super.init(width,height,parent,id)
    }
    override func resolveSkin() {
        super.resolveSkin()
        createThumb()
    }
    /**
     * Override this method if you want to add a custom thumb
     */
    func createThumb(){
        thumb = addSubView(Button(thumbWidth, height,self))
        setProgressValue(progress)
    }
    func onThumbDown(){
        //Swift.print("HSlider.onThumbDown")
        tempThumbMouseX = thumb!.localPos().x
        if(leftMouseDraggedEventListener != nil){NSEvent.removeMonitor(leftMouseDraggedEventListener!);leftMouseDraggedEventListener = nil}//avoids potential bugs
        leftMouseDraggedEventListener = NSEvent.addLocalMonitorForEvents(matching:[.leftMouseDragged], handler:onThumbMove )
    }
    func onThumbMove(event:NSEvent)-> NSEvent{
        progress = Utils.progress(event.localPos(self).x, tempThumbMouseX, width, thumbWidth)
        let thumbX:CGFloat = Utils.thumbPosition(progress, width, thumbWidth)
        thumb!.x = thumbX
        super.onEvent(SliderEvent(SliderEvent.change,progress,self))
        return event
    }
    func onThumbUp(){
        if(leftMouseDraggedEventListener != nil){NSEvent.removeMonitor(leftMouseDraggedEventListener!);leftMouseDraggedEventListener = nil}//we remove a global mouse move event listener
    }
    func onMouseMove(event:NSEvent) -> NSEvent?{
        progress = Utils.progress(event.localPos(self).x, thumbWidth/2, width, thumbWidth)
        thumb!.x = Utils.thumbPosition(progress, width, thumbWidth)
        super.onEvent(SliderEvent(SliderEvent.change,progress,self))
        return event
    }
    /**
     * TODO: Overriding mouseUp like this isn't good, listen to buttonUp etc
     */
    override func mouseUp(_ event:MouseEvent) {
        if(leftMouseDraggedEventListener != nil){NSEvent.removeMonitor(leftMouseDraggedEventListener!);leftMouseDraggedEventListener = nil}//we remove a global mouse move event listener
    }
    override func onEvent(_ event:Event) {
        //Swift.print("\(self.dynamicType)" + ".onEvent() event: " + "\(event)")
        if(event.origin === thumb && event.type == ButtonEvent.down){onThumbDown()}//if thumbButton is down call onThumbDown
        else if(event.origin === thumb && event.type == ButtonEvent.up){onThumbUp()}//if thumbButton is down call onThumbUp
        //super.onEvent(event)/*forward events, or stop the bubbeling of events by commenting this line out*/
    }
    /**
     * PARAM: progress (0-1)
     */
    func setProgressValue(_ progress:CGFloat){/*Can't be named setProgress because of objc*/
        self.progress = Swift.max(0,Swift.min(1,progress))/*If the progress is more than 0 and less than 1 use progress, else use 0 if progress is less than 0 and 1 if its more than 1*/
        thumb!.x = Utils.thumbPosition(self.progress, width, thumbWidth)
        //thumb?.applyOvershot(progress)/*<--We use the unclipped scalar value*/
    }
    /**
     * Sets the thumbs width and repositions the thumb accordingly
     */
    func setThumbWidthValue(_ thumbWidth:CGFloat) {/*Can't be named setThumbHeight because of objc*/
        self.thumbWidth = thumbWidth
        thumb!.setSize(thumbWidth, thumb!.getHeight())
        thumb!.x = Utils.thumbPosition(progress, width, thumbWidth)
    }
    override func setSize(_ width:CGFloat, _ height:CGFloat) {
        super.setSize(width,height)
        thumb!.setSize(thumb!.width, height)
        thumb!.x = Utils.thumbPosition(progress, width, thumbWidth)
    }
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
private class HSliderUtils{
    /**
     * Returns the x position of a nodes PARAM: progress
     */
    static func thumbPosition(_ progress:CGFloat, _ width:CGFloat, _ thumbWidth:CGFloat)->CGFloat {
        let minThumbPos:CGFloat = width - thumbWidth/*Minimum thumb position*/
        return progress * minThumbPos
    }
    /**
     * Returns the progress derived from a node
     * RETURN: a number between 0 and 1
     */
    static func progress(_ mouseX:CGFloat,_ tempNodeMouseX:CGFloat,_ width:CGFloat,_ thumbWidth:CGFloat)->CGFloat {
        if(thumbWidth == width) {return 0;}/*if the thumbWidth is the same as the Width of the slider then return 0*/
        let progress:CGFloat = (mouseX-tempNodeMouseX) / (width-thumbWidth)
        return max(0,min(progress,1))/*Ensures that progress is between 0 and 1 and if its beyond 0 or 1 then it is 0 or 1*/
    }
}
