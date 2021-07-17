//
//  GiftListViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/15.
//
import UIKit

class GiftListViewModel {
    private var dataService: GiftDataService?
    // MARK: - Properties
    private var giftList: [GiftInfo] = [] {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    var error: Error? { didSet { self.showAlertClosure?() } }
    var failMessage: String? { didSet { self.showAlertClosure?() } }
    var failCode: Int? { didSet { self.codeAlertClosure?() } }
    var isLoading: Bool = false { didSet { self.updateLoadingStatus?() } }
    
    //MARK: 클로져
    var showAlertClosure: (() -> ())?
    var codeAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    var numOfGiftList: Int {
        return giftList.count
    }
    
    // MARK: 생성자
    init(dataService: GiftDataService) {
        self.dataService = dataService
    }
    
    func giftListInfo(at index: Int) -> GiftInfo{
        return giftList[index]
    }
    
    func fetchGiftList(){
        self.isLoading = true
        self.dataService?.requestFetchGiftList(completion: { [weak self] response, error in
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
            self?.failCode = nil
            self?.giftList = response?.result ?? []
            self?.isLoading = false
        })
    }
}
