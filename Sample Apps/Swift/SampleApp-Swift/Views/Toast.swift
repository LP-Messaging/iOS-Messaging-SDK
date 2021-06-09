//
//  Toast.swift
//  SampleApp
//
//  Created by David Villacis on 6/8/21.
//  Copyright © 2021 LivePerson. All rights reserved.
//

import UIKit
import LPMessagingSDK

class Toast: UIView {
    
    // MARK: - Properties
    
    private lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var title : UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private lazy var subtitle : UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
        
    private var notification: LPNotification?
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addViews()
    }
    
    func addViews() {
        self.addSubview(self.stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stackView.addArrangedSubview(self.title)
        stackView.addArrangedSubview(self.subtitle)
    }
    
    func set(with notification: LPNotification) {
        self.notification = notification
        self.backgroundColor = .blue
        self.title.text = notification.user.nickName
        self.subtitle.text = notification.text
        self.addTapGesture()
    }
    
    func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func tapped(_ sender: UIView){
        if let notification = self.notification {
            LPMessaging.instance.handleTapForInAppNotification(notification: notification)
        }
    }
}

