//
//  TwinkleProveViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/19.
//

class TwinkleProveViewModel {
    
    // MARK: 기본 프로퍼티
    private var dataService: TwinkleDataService?
    private var twinkleProveInfo: [TwinkleProveInfo]? { didSet { self.didFinishFetch?() } }
    
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
    init(dataService: TwinkleDataService) {
        self.dataService = dataService
    }
    
    //MARK: 전체 트윙클 총 갯수
    var numOfTwinkleTotal: Int {
        guard let data = twinkleProveInfo else { return 0 }
        return data.count
    }
    
    
    //MARK: 트윙클 인덱스 조회
    func twinkleProveList(at index: Int) -> TwinkleProveInfo? {
        return twinkleProveInfo?[index]
    }
    
    
    // MARK: 전체 트윙클 API 호출 함수
    func fetchTwinkleProve(){
        self.isLoading = true
        self.dataService?.requestFetchTwinkleProve(completion: { [weak self] response, error in
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
            self?.twinkleProveInfo = response?.result?.giftLogs
            self?.isLoading = false
            
        })
    }
}
