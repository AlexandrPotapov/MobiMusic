//
//  FooterView.swift
//  MobiMusic
//
//  Created by Александр on 26.06.2021.
//

import UIKit

class SpinnerView: UIView {
    
    private var loader: UIActivityIndicatorView = {
       let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(loader)

        
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
      loader.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
    }
    
    func showLoader() {
        loader.startAnimating()
    }
    
    func hideLoader() {
        loader.stopAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

