import Cocoa
@testable import Utils

class SliderScrollerView5:SliderView5,Scrollable5 {
    private var sliderHandler:SliderScrollerHandler {return handler as! SliderScrollerHandler}
    override lazy var handler:ProgressHandler = {
        return SliderScrollerHandler(progressable:self)
    }()
    /**
     * TODO: ⚠️️ Try to override with generics ContainerView<VerticalScrollable>  etc, in swift 4 this could probably be done with where Self:... nopp wont work 🚫
     */
    override open func scrollWheel(with event: NSEvent) {
        sliderHandler.scroll(event)
        super.scrollWheel(with: event)
    }
    
   
}
