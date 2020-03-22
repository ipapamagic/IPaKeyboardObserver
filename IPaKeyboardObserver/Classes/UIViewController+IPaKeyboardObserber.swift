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
    @objc func addTapToCloseKeyboard(_ targetView:UIView? = nil) {
        var targetView = targetView
        if targetView == nil {
            guard let firstScrollView = self._getKeyboardObserverView() else {
                return
            }
            targetView = firstScrollView
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.onTapToDismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        targetView!.addGestureRecognizer(tapGesture)
    }
    @objc func onTapToDismissKeyboard(_ sender:Any) {
        self.view.endEditing(true)
    }
    @objc func addKeyboardObserver() {
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        nc.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func removeKeyboardObserver() {
        
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        nc.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK: Keyboard notification
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        // Get animation info from userInfo
        var animationDuration:TimeInterval = 0
    //    var animationCurve = UIView.AnimationCurve.easeInOut
        
        var keyboardEndFrame = CGRect()
        
        var value = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSValue
        value.getValue(&animationDuration)
        
        
        value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        value.getValue(&keyboardEndFrame)
        //safeAreaInset will include additionalSafeAreaInset,so have to remove it here
        let keyboardHeight = keyboardEndFrame.height - self.view.safeAreaInsets.bottom + additionalSafeAreaInsets.bottom

        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight , right: 0)
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded();
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let userInfo = notification.userInfo!
        var animationDuration:TimeInterval = 0
        let value = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSValue
        value.getValue(&animationDuration)

        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded();
        }
    }

//    @objc func keyboardWillChange(notification: NSNotification) {
//        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        let userInfo = notification.userInfo!
//        var animationDuration:TimeInterval = 0
//        var keyboardEndFrame = CGRect()
//        var value = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSValue
//        value.getValue(&animationDuration)
//
//        value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
//        value.getValue(&keyboardEndFrame)
//        let keyboardHeight = max(keyboardEndFrame.height - self.view.safeAreaInsets.bottom,0)
//
//        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
//        self.bottomLayoutGuide
//        UIView.animate(withDuration: animationDuration) {
//            self.view.layoutIfNeeded();
//        }
//    }

}
