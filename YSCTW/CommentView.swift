//
//  CommentView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class CommentView: UIView {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet var view: CommentView!
    @IBOutlet weak var sendButton: RoundedButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        UINib(nibName: "CommentView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.commentTextField.placeholder = "ADD_COMMENT".localized
        self.sendButton.setTitle("SEND".localized, for: .normal)
        self.sendButton.setTitle("SEND".localized, for: .selected)
    }
    
    override func layoutSubviews() {
        
        self.backgroundColor = customLightGray

        super.layoutSubviews()
    }
    
    //:Mark - Button handling
    @IBAction func handleSendCommentButtonTapped(_ sender: AnyObject) {
        
    }
    

}
