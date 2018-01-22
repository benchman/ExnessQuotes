//
//  UIViewController+LoadingView.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/18.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import PureLayout

extension UIViewController {
    @nonobjc private static var loadingViewKey = "com.benchman.loadingViewKey"
    @nonobjc private static var isLoadingKey = "com.benchman.isLoadingKey"
    
    @objc var isLoading: Bool {
        get {
            if let number = objc_getAssociatedObject(self, &UIViewController.isLoadingKey) as? NSNumber {
                return number.boolValue
            }
            return false
        }
        set {
            let old = isLoading
            let number = NSNumber(value: newValue)
            objc_setAssociatedObject(self, &UIViewController.isLoadingKey, number, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue && !old {
                let view = Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)!.first! as! UIView
                view.configureForAutoLayout()
                self.view.addSubview(view)
                view.autoPinEdgesToSuperviewEdges()
                self.loadingView = view
            }
            else {
                self.loadingView?.removeFromSuperview()
            }
        }
    }
    
    private var loadingView: UIView? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.loadingViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &UIViewController.loadingViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
