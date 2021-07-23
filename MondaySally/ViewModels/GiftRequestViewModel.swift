//
//  GiftRequestViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/16.
//

class GiftRequestViewModel {
    
    // MARK: - Properties
    private var dataService: GiftDataService?
    var giftInfo: GiftProveInfo? { didSet { self.didFinishFetch?() } }
    
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
    
    //MARK: 기프트 신청 API
    func fetchGiftRequest(with input: GiftRequestInput){
        self.isLoading = true
        self.dataService?.requestFetchGift(with: input, completion: { [weak self] response, error in
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
            self?.giftInfo = response?.result
        })
    }
}
