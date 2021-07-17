//
//  CloverHistoryViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/18.
//

class CloverHistoryViewModel {
    
    // MARK: 기본 프로퍼티
    private var dataService: CloverDataService?
    private var cloverHistoryInfo: CloverHistoryInfo? { didSet { self.didFinishFetch?() } }
    
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
    
    //MARK: 누적 클로버 총 갯수
    var numOfTotalCloverList: Int? {
        return cloverHistoryInfo?.accumulatedCloverList?.count
    }
    
    //MARK: 사용 클로버 총 갯수
    var numOfUsedCloverList: Int? {
        return cloverHistoryInfo?.usedCloverList?.count
    }
    
    //MARK: 누적 클로버 리스트 인덱스 조회
    func totalCloverList(at index: Int) -> TotalCloverInfo? {
        return cloverHistoryInfo?.accumulatedCloverList?[index]
    }
    
    //MARK: 사용 클로버 리스트 인덱스 조회
    func usedCloverList(at index: Int) -> UsedCloverInfo? {
        return cloverHistoryInfo?.usedCloverList?[index]
    }
    
    // MARK: 클로버 히스토리 API 호출 함수
    func fetchCloverHistory(){
        self.isLoading = true
        self.dataService?.requestFetchCloverHistory(completion: { [weak self] response, error in
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
            self?.cloverHistoryInfo = response?.result
            self?.isLoading = false
            
        })
    }
}
