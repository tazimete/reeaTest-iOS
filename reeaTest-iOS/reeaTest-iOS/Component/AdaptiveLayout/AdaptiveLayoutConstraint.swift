//
//  AdaptiveConstraint.swift
//  AddMusicMotionTextVideoEditor
//
//  Created by AGM Tazim on 3/23/22.
//

import UIKit

class AdaptiveLayoutConstraint: NSLayoutConstraint {
    
    @IBInspectable var setAdaptiveLayout: Bool = true
    
    override func awakeFromNib() {
        if setAdaptiveLayout {
            self.constant = self.constant.adaptiveWidth()
            
            if let firstView = self.firstItem as? UIView {
                firstView.layoutIfNeeded()
            }
            if let secondVIew = self.secondItem as? UIView {
                secondVIew.layoutIfNeeded()
            }
        }
    }

    
    public convenience init(item view1: Any, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation, toItem view2: Any?, attribute attr2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant c: CGFloat, setAdaptiveLayout: Bool = true) {
        
        self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
        
        if setAdaptiveLayout {
            self.constant = self.constant.adaptiveWidth()
            
//            if attr2 == .top || attr2 == .bottom || attr2 == .height || attr2 == .centerY {
//                self.constant = self.constant.adaptiveHeight()
//            } else if attr1 == .top || attr1 == .bottom || attr1 == .height || attr1 == .centerY {
//                self.constant = self.constant.adaptiveHeight()
//            }
            
            if let firstView = self.firstItem as? UIView {
                firstView.layoutIfNeeded()
            }
            if let secondVIew = self.secondItem as? UIView {
                secondVIew.layoutIfNeeded()
            }
        }
    }
    
}
