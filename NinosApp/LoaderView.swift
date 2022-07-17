//
//  LoaderView.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 12/07/22.
//

import UIKit
import Lottie

public class LoaderView: UIView{
    var animationView = AnimationView(name: "dog")
    override public init(frame: CGRect) {
        super.init(frame: frame)
        //self.segmento
        commonInit()
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        //self.segmento
        commonInit()
    }
    func commonInit(){
    
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = self.center
        animationView.animationSpeed = 0.2
        animationView.contentMode = .scaleToFill
        self.addSubview(animationView)
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        
        

    }
    func repintar(_ segmento: String){
        animationView.removeFromSuperview()
        animationView = AnimationView(name: segmento)
        commonInit()
    }

}
