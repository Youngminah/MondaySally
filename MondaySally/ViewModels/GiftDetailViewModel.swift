//
//  GiftDetailViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/15.
//

import TTGTagCollectionView
import UIKit

class GiftDetailViewModel {
    
    private var dataService: GiftDataService?
    
    // MARK: - Properties
    private var giftDetailInfo: GiftDetailInfo? { didSet { self.didFinishFetch?() } }
    var getGiftInfo: GiftDetailInfo? { return giftDetailInfo }
    
    //MARK: 프로퍼티 DidSet
    var error: Error? { didSet { self.showAlertClosure?() } }
    var failMessage: String? { didSet { self.showAlertClosure?() } }
    var failCode: Int? { didSet { self.codeAlertClosure?() } }
    var isLoading: Bool = false { didSet { self.updateLoadingStatus?() } }

    //MARK: 클로져
    var showAlertClosure: (() -> ())?
    var codeAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    // MARK: 생성자
    init(dataService: GiftDataService) { self.dataService = dataService }
    
    //MARK: 옵션 갯수
    var numOfGiftOption: Int { return giftDetailInfo?.options.count ?? 0 }
    
    //MARK: 인덱스로 조회한 옵션의 클로버 조회
    func getOptionClover(at index: Int) -> Int? {
        return giftDetailInfo?.options[index].usedClover
    }
    
    let nonSelectedAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.tagColor,
        .font: UIFont(name: "NotoSansCJKkr-Regular", size: 13) as Any
    ]
    
    let selectedAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.mainOrange,
        .font: UIFont(name: "NotoSansCJKkr-Regular", size: 13) as Any
    ]
    
    private let tagStyle: TTGTextTagStyle = {
        let style = TTGTextTagStyle()
        style.textAlignment = .center
        style.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        style.extraSpace.width = 14
        style.extraSpace.height = 10
        style.shadowOpacity = 0
        return style
    }()
    
    private let nonSelectedimageAttachment: NSTextAttachment = {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = #imageLiteral(resourceName: "icCloverGray")
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 11, height: 11)
        return imageAttachment
    }()
    
    private let selectedimageAttachment: NSTextAttachment = {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = #imageLiteral(resourceName: "icCloverOrange")
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 11, height: 11)
        return imageAttachment
    }()
    
    //MARK: 네트워크 API 호출 함수
    func fetchGiftDetail(with index: Int){
        self.isLoading = true
        self.dataService?.requestFetchGiftDetail(with: index, completion: { [weak self] response, error in
            guard let strongself = self else { return }
            if let error = error {
                strongself.error = error
                strongself.isLoading = false
                return
            }
            if let isSuccess = response?.isSuccess {
                if !isSuccess {
                    strongself.failMessage = response?.message
                    strongself.failCode = response?.code
                    strongself.isLoading = false
                    return
                }
            }
            strongself.error = nil
            strongself.failMessage = nil
            strongself.isLoading = false
            strongself.giftDetailInfo = response?.result
        })
    }
}

//MARK: 옵션 태그 TTGTextTag 생성 관한 프로퍼티
extension GiftDetailViewModel {
    
    var optionTagList: [TTGTextTag]? {
        guard let optionList = giftDetailInfo?.options else { return []}
        var optionTTGTextTags: [TTGTextTag] = []
        
        for option in optionList {
            let tag = TTGTextTag()
            
            let nonSelectedString = NSMutableAttributedString(string: "")
            nonSelectedString.append(NSAttributedString(string: "\(option.usedClover) ", attributes: nonSelectedAttributes))
            nonSelectedString.append(NSAttributedString(attachment: self.nonSelectedimageAttachment))
            nonSelectedString.append(NSAttributedString(string: " / \(option.money.toCloverMoney)", attributes: nonSelectedAttributes))
            let content = TTGTextTagAttributedStringContent()
            content.attributedText = nonSelectedString
            self.tagStyle.borderWidth = 0.5
            self.tagStyle.borderColor = .tagColor
            tag.content = content
            tag.style = self.tagStyle
            
            let selectedString = NSMutableAttributedString(string: "")
            selectedString.append(NSAttributedString(string: "\(option.usedClover) ", attributes: selectedAttributes))
            selectedString.append(NSAttributedString(attachment: self.selectedimageAttachment))
            selectedString.append(NSAttributedString(string: " / \(option.money.toCloverMoney)", attributes: selectedAttributes))
            content.attributedText = selectedString
            
            self.tagStyle.borderWidth = 1
            self.tagStyle.borderColor = .mainOrange
            tag.selectedContent = content
            tag.selectedStyle = self.tagStyle
            optionTTGTextTags.append(tag)
        }

        return optionTTGTextTags
    }
}
