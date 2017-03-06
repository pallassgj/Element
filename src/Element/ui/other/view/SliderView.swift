import Foundation
@testable import Utils

class SliderView:ScrollView,ISlidable {
    /*Slider*/
    var slider:VSlider?
    var sliderInterval:CGFloat?
    override func resolveSkin() {
        super.resolveSkin()
        /*slider*/
        Swift.print("SliderView.height: " + "\(height)")
        Swift.print("SliderView.getHeight(): " + "\(getHeight())")
        sliderInterval = floor(itemsHeight - height)/itemHeight// :TODO: use ScrollBarUtils.interval instead?// :TODO: explain what this is in a comment
        slider = addSubView(VSlider(itemHeight,height,0,0,self))
        let thumbHeight:CGFloat = SliderParser.thumbSize(height/itemsHeight, slider!.height)
        slider!.setThumbHeightValue(thumbHeight)
    }
    override func onEvent(_ event:Event) {
        Swift.print("event: " + "\(event)")
        if(event === (SliderEvent.change,slider!)){
            setProgress((event as! SliderEvent).progress)
        }/*events from the slider*/
        super.onEvent(event)
    }
}