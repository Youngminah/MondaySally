//
//  TwinkleWriteViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/07.
//

import UIKit

class TwinkleWriteViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "내 트윙클 추가하기"
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        self.textView.layer.cornerRadius = 4

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    

}
