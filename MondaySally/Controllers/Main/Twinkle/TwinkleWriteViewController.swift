//
//  TwinkleWriteViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/07.
//

import UIKit

class TwinkleWriteViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var photoTag: Int = 0
    
    @IBOutlet weak var photoButtonFirst: UIButton!
    @IBOutlet weak var photoButtonSecond: UIButton!
    @IBOutlet weak var photoButtonThird: UIButton!
    @IBOutlet weak var receiptPhotoButton: UIButton!
    
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
    
    @IBAction func photoSelectButtonTap(_ sender: UIButton) {
        let vc = UIImagePickerController()
        self.photoTag = sender.tag
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)

    }
    
}

extension TwinkleWriteViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if photoTag == 0 {
                self.photoButtonFirst.setImage(image, for: .normal)
            } else if photoTag == 1{
                self.photoButtonSecond.setImage(image, for: .normal)
            }else if photoTag == 2 {
                self.photoButtonThird.setImage(image, for: .normal)
            }else {
                self.receiptPhotoButton.setImage(image, for: .normal)
            }
            
        }
        //self.photoSelectButton.imageView?.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
