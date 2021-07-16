//
//  GiftDetailViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/15.
//


class GiftDetailViewModel {
    private var dataService: GiftDataService?
    // MARK: - Properties
    private var giftDetailInfo: GiftDetailInfo? {
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
    
    var getGiftInfo: GiftDetailInfo? {
        return giftDetailInfo
    }
    
    var numOfGiftOption: Int {
        return giftDetailInfo?.option.count ?? 0
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
    
    func getOptionInfo(at index: Int) -> OptionInfo?{
        return giftDetailInfo?.option[index] ?? nil
    }
    
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
