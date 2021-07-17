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
    private var giftDetailInfo: GiftDetailInfo? {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    var error: Error? { didSet { self.showAlertClosure?() } }
    var failMessage: String? { didSet { self.showAlertClosure?() } }
    var failCode: Int? { didSet { self.codeAlertClosure?() } }
    var isLoading: Bool = false { didSet { self.updateLoadingStatus?() } }
    
    var getGiftInfo: GiftDetailInfo? { return giftDetailInfo }

    //MARK: 클로져
    var showAlertClosure: (() -> ())?
    var codeAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    // MARK: 생성자
    init(dataService: GiftDataService) { self.dataService = dataService }
    
    //MARK: 옵션관련 프로퍼티
    var numOfGiftOption: Int { return giftDetailInfo?.option.count ?? 0 }
    
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
    
    
    func getOptionClover(at index: Int) -> Int? {
        return giftDetailInfo?.option[index].usedClover
    }
    
    //MARK: 네트워크 API 호출 함수
    func fetchGiftDetail(with index: Int){
        self.isLoading = true
        self.dataService?.requestFetchGiftDetail(with: index, completion: { [weak self] response, error in
            if let error = error {
                self?.error = error
                self?.isLoading = false
                return
            }
            if let isSuccess = response?.isSuccess {
                if !isSuccess {
                    self?.failMessage = response?.message
                    self?.failCode = response?.code
                    self?.isLoading = false
                    return
                }
            }
            self?.error = nil
            self?.failMessage = nil
            self?.isLoading = false
            self?.giftDetailInfo = response?.result
        })
    }
}

//MARK: 옵션 태그에 관한 프로퍼티
extension GiftDetailViewModel {
    
    var optionTagList: [TTGTextTag]? {
        guard let optionList = giftDetailInfo?.option else { return []}
        
        var optionTTGTextTags: [TTGTextTag] = []
        
        for option in optionList {
            let tag = TTGTextTag()
            
            let nonSelectedString = NSMutableAttributedString(string: "")
            nonSelectedString.append(NSAttributedString(string: "\(option.usedClover) ", attributes: nonSelectedAttributes))
            nonSelectedString.append(NSAttributedString(attachment: self.nonSelectedimageAttachment))
            nonSelectedString.append(NSAttributedString(string: "/ \(option.money.toCloverMoney)", attributes: nonSelectedAttributes))
            print(nonSelectedString)
            let content = TTGTextTagAttributedStringContent()
            content.attributedText = nonSelectedString
            self.tagStyle.borderWidth = 0.5
            self.tagStyle.borderColor = .tagColor
            tag.content = content
            tag.style = self.tagStyle
            
            let selectedString = NSMutableAttributedString(string: "")
            selectedString.append(NSAttributedString(string: "\(option.usedClover) ", attributes: selectedAttributes))
            selectedString.append(NSAttributedString(attachment: self.selectedimageAttachment))
            selectedString.append(NSAttributedString(string: "/ \(option.money.toCloverMoney)", attributes: selectedAttributes))
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
