//
//  loadingpopanimator.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/27/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit

class loadingpopanimator: NSObject , UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    var presenting = true
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if(presenting == true){
            let toView = transitionContext.view(forKey: .to)!
            containerView.addSubview(toView)
            toView.alpha = 0.0
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                toView.alpha = 1.0
            }) { _ in
                transitionContext.completeTransition(true)
            }
        }else{
            let fromView = transitionContext.view(forKey: .from)!
            containerView.addSubview(fromView)
            fromView.alpha = 1.0
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                fromView.alpha = 0.0
            }) { _ in
                transitionContext.completeTransition(true)
            }
            /*UIView.animate(withDuration: duration, delay: 0.0, options: [.preferredFramesPerSecond60,.curveEaseInOut], animations: {
             fromView.transform = CGAffineTransform(scaleX: 0.000000000001, y: 0.000000000001)
             }) {  _ in
             fromView.isHidden = true
             transitionContext.completeTransition(true)
             }*/
        }
    }
    
    
}
