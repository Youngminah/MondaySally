//
//  TwinkleWriteImageViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/17.
//

import UIKit

class TwinkleWriteImageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var cloverImageList = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func deleteButtonTap(_ sender: UIButton) {
        sender.isHidden = true
        collectionView.reloadData()
    }
}


extension TwinkleWriteImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwinkleWriteImageCell", for: indexPath) as? TwinkleWriteImageCell else {
            return UICollectionViewCell()
        }
        if indexPath.item < cloverImageList.count {
            print("1")
            cell.updateUI(with : cloverImageList[indexPath.item])
        }else {
            cell.updateDefaultUI()
        }
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.height
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
}


//버튼 이미지 관련 함수
extension TwinkleWriteImageViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.cloverImageList.append(image)
            self.collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

