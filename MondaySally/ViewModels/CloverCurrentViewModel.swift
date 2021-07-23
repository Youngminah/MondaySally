//
//  CloverCurrentViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/21.
//

class CloverCurrentViewModel {
    
    // MARK: 기본 프로퍼티
    private var dataService: CloverDataService?
    private var currentCloverInfo: CurrentCloverInfo? { didSet { self.didFinishFetch?() } }
    
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
    init(dataService: CloverDataService) {
        self.dataService = dataService
    }
    
    //MARK: 현재 클로버로 신청가능한 기프트 갯수
    var numOfAvailableGift: Int {
        return currentCloverInfo?.availableGiftList?.count ?? 0
    }
    
    //MARK: 현재 클로버
    var currentClover: Int {
        return currentCloverInfo?.cloverTotal ?? 0
    }
    
    //MARK: 현재 클로버 리스트 인덱스 조회
    func availableGiftList(at index: Int) -> AvailableGiftInfo? {
        return currentCloverInfo?.availableGiftList?[index]
    }
    
    
    // MARK: 현재 클로버 API 호출 함수
    func fetchCloverCurrent(){
        self.isLoading = true
        self.dataService?.requestFetchCloverCurrent(completion: { [weak self] response, error in
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
            self?.currentCloverInfo = response?.result
            self?.isLoading = false
            
        })
    }
}
