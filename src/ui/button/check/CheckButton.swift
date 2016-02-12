import Foundation
/**
 * @Note: to force the CheckButton to apply its Checked or unchecked skin, use the setChecked after the instance is created
 */
class CheckButton :Button,ICheckable{
    var isChecked:Bool;
    init(_ width:CGFloat, _ height:CGFloat, _ isChecked:Bool = false, _ parent:IElement? = nil, _ id:String? = nil){
        self.isChecked = isChecked
        super.init(width,height,parent,id);
    }
    override func mouseUpInside(event: MouseEvent) {
        Swift.print("CheckButton.mouseUpInside()")
        isChecked = !isChecked
        super.mouseUpInside(event)
        self.event!(CheckEvent(CheckEvent.check, isChecked, self))
    }
    /**
     * Sets the _isChecked variable (Toggles between two states)
     */
    func setChecked(isChecked:Bool) {
        self.isChecked = isChecked
        setSkinState(getSkinState())
    }
    
    override func getSkinState() -> String {
        return isChecked ? SkinStates.checked + " " + super.getSkinState() : super.getSkinState()
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
