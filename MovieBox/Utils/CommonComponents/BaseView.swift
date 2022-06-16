//
//  BaseView.swift
//
//  Created by Nicolae Rogojan on 22.10.2021.
//

import UIKit

protocol View {
    func setupView()
}

class BaseView: UIView, View {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        // Use this method to do any set up that is shared between all your views,
        // for example drawing backgrounds, etc.
        backgroundColor = UIColor.white
    }
}
