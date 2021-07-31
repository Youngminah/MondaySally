//
//  GiftListViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/15.
//
import UIKit

class GiftListViewModel {
    
    // MARK: - Properties
    private var dataService: GiftDataService?
    private var giftList: GiftListInfo? { didSet { self.didFinishFetch?() } }
    
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
    
    //MARK: 생성자
    init(dataService: GiftDataService) {
        self.dataService = dataService
    }
    
    //MARK: 기프트의 총 갯수
    var numOfGiftList: Int {
        return giftList?.gifts?.count ?? 0
    }
    
    //MARK: 기프트 인덱스로 접근 함수
    func giftListInfo(at index: Int) -> GiftInfo?{
        return giftList?.gifts?[index]
    }
    
    //MARK: 기프트 리스트 API 호출 함수
    func fetchGiftList(){
        self.isLoading = true
        self.dataService?.requestFetchGiftList( completion: { [weak self] response, error in
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
            strongself.giftList = response?.result
            strongself.isLoading = false
            
        })
    }
    
    
    func next(){
        guard let giftList = giftList else {
            return
        }
        self.isLoading = true
        self.dataService?.requestFetchGiftListNext(currentPage: giftList, completion: { [weak self] response, error in
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
            self?.giftList = response?.result 
            self?.isLoading = false
        })
    }
}
