//
//  SplashViewController.swift
//  MobiMusic
//
//  Created by Александр on 30.06.2021.
//

import UIKit

  class SplashViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
//    @IBOutlet weak var textImageView: UIImageView!
    
//    var textImage: UIImage?
    var logoIsHidden: Bool = false
    
    static let logoImageBig: UIImage = UIImage(named: "splash-logo-big")!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        textImageView.image = textImage
      
      
//      let gradient = CAGradientLayer()
//      gradient.frame = view.bounds
//      gradient.startPoint = CGPoint(x: 0, y: 0)
//      gradient.endPoint = CGPoint(x: 1, y: 1)
//      
//      gradient.colors = [UIColor.cyan.cgColor, UIColor.clear.cgColor]
////      view.layer.addSublayer(gradient)
//      view.layer.insertSublayer(gradient, at: 0)

      logoImageView.isHidden = logoIsHidden

    }
    
}



