/*

*/

import UIKit

extension UIColor
{
    /**
        Creamos un `UIColor` a partir de una cadena hexadecimal
    */
    public convenience init(hexadecimal: String, alpha: CGFloat = 1.0)
    {
        var mutableHex:String = hexadecimal

        if(mutableHex.hasPrefix("#"))
        {
            mutableHex.remove(at: mutableHex.startIndex)
        }

        var hexInt: CUnsignedLongLong = 0

        let scanner: Scanner = Scanner(string:mutableHex)
        scanner.scanHexInt64(&hexInt)

        let red: CGFloat = CGFloat((hexInt & 0xFF0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((hexInt & 0x00FF00) >> 8) / 255.0
        let blue: CGFloat = CGFloat(hexInt & 0x0000FF) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:alpha);
    }

    /**
        Lo mismo de arriba pero con método de clase
    */
    public class func color(from hexadecimal: String, alpha: CGFloat) -> UIColor
    {
        var mutableHex:String = hexadecimal

        if(mutableHex.hasPrefix("#"))
        {
            mutableHex.remove(at: mutableHex.startIndex)
        }

        var hexInt: CUnsignedLongLong = 0

        let scanner: Scanner = Scanner(string:mutableHex)
        scanner.scanHexInt64(&hexInt)

        let red: CGFloat = CGFloat((hexInt & 0xFF0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((hexInt & 0x00FF00) >> 8) / 255.0
        let blue: CGFloat = CGFloat(hexInt & 0x0000FF) / 255.0

        //
        return UIColor(red:red, green:green, blue:blue, alpha:alpha);
    }

}
