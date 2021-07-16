//
//  MyGiftLogViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/16.
//

class GiftHistoryViewModel {
    private var dataService: GiftDataService?
    // MARK: - Properties
    private var myGiftLogInfo: [MyGiftLogInfo] = [] {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    
    var failMessage: String? {
        didSet { self.showAlertClosure?() }
    }
    
    var failCode: Int? {
        didSet { self.logOutAlertClosure?() }
    }
    
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    var numOfGiftLogInfo: Int {
        return myGiftLogInfo.count
    }
    
    //MARK: 클로져
    var showAlertClosure: (() -> ())?
    var logOutAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    // MARK: 생성자
    init(dataService: GiftDataService) {
        self.dataService = dataService
    }
    
    func myGiftLogInfo(at index: Int) -> MyGiftLogInfo?{
        return myGiftLogInfo[index]
    }
    
    func fetchMyGiftLog(){
        self.isLoading = true
        self.dataService?.requestFetchMyGiftLog(completion: { [weak self] response, error in
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
            self?.myGiftLogInfo = response?.result ?? []
        })
    }
}
