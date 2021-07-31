//
//  HomeViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/20.
//

import UIKit

class HomeViewModel {
    
    //MARK: 기본 프로퍼티
    private var dataService: HomeDataService?
    var homeInfo: HomeInfo? { didSet { self.didFinishFetch?() } }
    
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
    init(dataService: HomeDataService) {
        self.dataService = dataService
    }
    
    //MARK: 기프트 히스토리 미리보기 갯수
    var numOfGiftHistory: Int? {
        return homeInfo?.giftHistory?.count
    }
    
    //MARK: 현재 근무자 총 인원 수
    var numOfTwinkleRank: Int {
        return homeInfo?.twinkleRank?.count ?? 0
    }
    
    //MARK: 현재 근무자 총 인원 수
    var numOfWorkingMember: Int? {
        return homeInfo?.workingMemberlist?.count
    }
    
    //MARK: 기프트 히스토리 미리보기 인덱스 접근 조회 함수
    func giftHistoryList(at index: Int) -> GiftHistoryPreview? {
        return homeInfo?.giftHistory?[index]
    }
    
    //MARK: 기프트 인덱스로 접근 함수
    func twinkleRankPrviewList(at index: Int) -> TwinkleRankingPreview? {
        return homeInfo?.twinkleRank?[index]
    }
    
    func workingMemberList(at index: Int) -> WorkingMember? {
        return homeInfo?.workingMemberlist?[index]
    }
    
    
    
    func fetchHome(){
        self.isLoading = true
        self.dataService?.requestFetchHome(completion: { [weak self] response, error in
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
            strongself.homeInfo = response?.result
            strongself.isLoading = false
        })
    }
}
