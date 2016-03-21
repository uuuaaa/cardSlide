//
//  ViewCustom.swift
//  cardSlide
//
//  Created by 大屋雄 on 2016/03/19.
//  Copyright © 2016年 Yu Oya. All rights reserved.
//

import UIKit

@IBDesignable
class ViewCustom: UIView {

    
    @IBInspectable var borderWidth :CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor :UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var cornerRadius :CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowColor :UIColor = UIColor.clearColor() {
        didSet {
            layer.shadowColor = shadowColor.CGColor
        }
    }
    
    @IBInspectable var shadowOpacity :CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable var shadowOffsetWidth :CGFloat = 0 {
        didSet {
            layer.shadowOffset.width = shadowOffsetWidth
        }
    }

    @IBInspectable var shadowOffsetHeight :CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetHeight
        }
    }

    
}
