//
//  CardView.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 13/07/22.
//

import Foundation
import UIKit

@IBDesignable class CardView : UIView{
    @IBInspectable var cornnerRadius: CGFloat = 5
    var ofsetWidth: CGFloat = 5
    var ofsetHeight: CGFloat = 5
    
    var ofsetShadowOpacity: Float = 5
    @IBInspectable var myColour: UIColor = UIColor.systemGray4
    
    override func layoutSubviews() {
        layer.cornerRadius = self.cornnerRadius
        layer.shadowColor = self.myColour.cgColor
        layer.shadowOffset = CGSize(width: self.ofsetWidth, height: self.ofsetHeight)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornnerRadius).cgPath
        layer.shadowOpacity = self.ofsetShadowOpacity
        
    }
}
