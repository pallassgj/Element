import Cocoa

class ListParser {
    /**
     * Returns a NSView instance from @param dataProviderItem
     * @Note: This is a way to get to the actual "Buttons" directly
     */
    class func label(list:IList,_ dataProviderItem:Dictionary<String,String>) -> NSView {// :TODO: rename to toItem and maybe move to Listparser, dataProviderItemToItem? ListUtils
        let itemIndex:Int = list.dataProvider.getItemIndex(dataProviderItem)
        return list.lableContainer!.subviews[itemIndex]
    }
    /**
     * Returns the item from the list (NSView instance) from @param list at @param index
     */
    class func labelAt(list:IList,index:Int)->NSView? {
        let dataProvderItem:Dictionary<String,String>? = list.dataProvider.getItemAt(index)
        if(dataProvderItem != nil){return ListParser.label(list,dataProvderItem!)}
        return nil
    }
    /**
     * Returns a dataProviderItem
     */
    class func dataProviderItem(list:IList, view:NSView)->Dictionary<String,String>? {
        let index:Int = self.index(list, view)
        return list.dataProvider.getItemAt(index)
    }
    /**
     * Returns the index of a "label"
     * @param view is the Label
     */
    class func index(list:IList,_ view:NSView)->Int {
        return list.lableContainer!.indexOf(view)
    }
}