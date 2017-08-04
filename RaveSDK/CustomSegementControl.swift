//
//  CustomSegementControl.swift
//  RaveMobile
//
//  Created by Olusegun Solaja on 18/07/2017.
//  Copyright © 2017 Olusegun Solaja. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSegementControl: UIControl {
    var buttons = [UIButton]()
    var selectorView:UIView!
    var selectedIndex = 0
    @IBInspectable
    var borderWidth:CGFloat = 0  {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor:UIColor! = .clear  {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var bgColor: UIColor = .white  {
        didSet{
            backgroundColor = bgColor
        }
    }
    
    
    @IBInspectable
    var buttonTitles:String = ""{
        didSet{
           self.updateView()
        }
    }
    @IBInspectable
    var buttonTitleColor:UIColor = .gray{
        didSet{
            self.updateView()
        }
    }
    
    
    @IBInspectable
    var selectedTitleColor:UIColor = .darkGray{
        didSet{
            self.updateView()
        }
    }
    
    @IBInspectable
    var selectorColor:UIColor = .white{
        didSet{
            self.updateView()
        }
    }
    
    func updateView(){
        buttons.removeAll()
        let titles = buttonTitles.components(separatedBy: ",")
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        for buttonTitle in titles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(buttonTitleColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        
        buttons[0].setTitleColor(selectedTitleColor, for: .normal)
        
        
        let selectorWidth = self.frame.width / CGFloat(buttons.count)
        selectorView = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: self.frame.height))
        selectorView.backgroundColor = selectorColor
        selectorView.layer.cornerRadius = frame.height / 2
        addSubview(selectorView)
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.alignment = .fill
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        addSubview(sv)
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = self.frame.height / 2
    }
    
    func buttonTapped(_ sender:UIButton){
       
        for (buttonIndex,button) in buttons.enumerated(){
            button.setTitleColor(buttonTitleColor, for: .normal)
            
            if(button == sender){
                selectedIndex = buttonIndex
                let xOrigin = ( frame.width / CGFloat(buttons.count) ) * CGFloat(selectedIndex)
                    UIView.animate(withDuration: 0.3) {
                        self.selectorView.frame.origin = CGPoint(x: xOrigin, y: 0)
                }
                sender.setTitleColor(selectedTitleColor, for: .normal)
            
            }
            
        }
        
        sendActions(for: .valueChanged)
       
        
    }

}
