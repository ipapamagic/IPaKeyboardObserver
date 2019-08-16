//
//  UIViewController+IPaKeyboardObserber.swift
//  IPaKeyboardObserver
//
//  Created by IPa Chen on 2019/4/20.
//

import UIKit

public extension UIViewController {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    fileprivate func _getKeyboardObserverView() -> UIScrollView? {
        
        guard let firstScrollView = self.view.subviews.first(where: { (subView) -> Bool in
            return Bool(subView is UIScrollView)
        }) else {
            return nil
        }
        return firstScrollView as? UIScrollView
    }
    fileprivate func _getBottomConstraint() -> NSLayoutConstraint? {
        guard let firstScrollView = self._getKeyboardObserverView() else {
            return nil
        }
        
        return self.view.constraints.first { (constraint) -> Bool in
            if let firstView = constraint.firstItem as? UIScrollView ,firstView == firstScrollView && constraint.firstAttribute == .bottom {
                return true
            }
            if let secondView = constraint.secondItem as? UIScrollView,secondView == firstScrollView && constraint.secondAttribute == .bottom {
                return true
            }
            return false
        }
        
        
    }
    @objc func addTapToCloseKeyboard() {
        guard let firstScrollView = self._getKeyboardObserverView() else {
            return
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.onTapToDismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        firstScrollView.addGestureRecognizer(tapGesture)
    }
    @objc func onTapToDismissKeyboard(_ sender:Any) {
        self.view.endEditing(true)
    }
    @objc func addKeyboardObserver() {
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(UIViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(UIViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func removeKeyboardObserver() {
        
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Keyboard notification
    @objc func keyboardWillShow(_ aNotification:NSNotification) {
        moveConfirmViewForKeyboard(aNotification,show:true)
    }
    @objc func keyboardWillHide(_ aNotification:NSNotification) {
        
        moveConfirmViewForKeyboard(aNotification,show:false)
    }
    
    func moveConfirmViewForKeyboard(_ aNotification:NSNotification ,show:Bool) {
        let userInfo = aNotification.userInfo!
        // Get animation info from userInfo
        var animationDuration:TimeInterval = 0
        var animationCurve = UIView.AnimationCurve.easeInOut
        
        var keyboardEndFrame = CGRect()
        
        var value = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSValue
        value.getValue(&animationCurve)
        
        value = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSValue
        value.getValue(&animationDuration)
        
        
        // Animate up or down
        //        var animOptions:UIViewAnimationOptions
        //        switch (animationCurve) {
        //            case .EaseInOut:
        //                animOptions = .CurveEaseInOut;
        //                break;
        //            case .EaseIn:
        //                animOptions = .CurveEaseIn;
        //                break;
        //            case .EaseOut:
        //                animOptions = .CurveEaseOut;
        //                break;
        //            case .Linear:
        //                animOptions = .CurveLinear;
        //                break;
        //        }
        updateViewConstraints()
        if let bottomConstraint = self._getBottomConstraint() {
            if (show) {
                value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                value.getValue(&keyboardEndFrame)
                let endFrame = self.view.convert(keyboardEndFrame, from: nil)
                bottomConstraint.constant = self.view.bounds.height - endFrame.minY
            
            }
            else {
                bottomConstraint.constant = 0
            }
        }
        
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        })
        
        
        
    }

}
