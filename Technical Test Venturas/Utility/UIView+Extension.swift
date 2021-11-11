//
//  GExtension+UIView.swift
//  MapWithAudioController.swift
//  Technical Test Venturas
//
//  Created by Faizul Karim on 7/11/21.

import UIKit
extension UIView {
    func animShow(){
         UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn],
                        animations: {
                         self.center.y -= self.bounds.height
                         self.layoutIfNeeded()
         }, completion: nil)
         self.isHidden = false
     }
     func animHide(){
         UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear],
                        animations: {
                         self.center.y += self.bounds.height
                         self.layoutIfNeeded()

         },  completion: {(_ completed: Bool) -> Void in
         self.isHidden = true
             })
     }
}
