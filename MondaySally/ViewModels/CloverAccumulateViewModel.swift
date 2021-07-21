//
//  CloverHistoryViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/18.
//

class CloverAccumulateViewModel {
    
    // MARK: 기본 프로퍼티
    private var dataService: CloverDataService?
    private var accumulateCloverInfo: AccumulateCloverInfo? { didSet { self.didFinishFetch?() } }
    
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
    
    //MARK: 누적 클로버 리스트 갯수
    var numOfTotalClover: Int {
        return accumulateCloverInfo?.cloverHistoryList?.count ?? 0
    }
    
    //MARK: 누적 클로버
    var accumulateClover: Int {
        return accumulateCloverInfo?.cloverTotal ?? 0
    }
    
    //MARK: 누적 클로버 리스트 인덱스 조회
    func accumulateCloverList(at index: Int) -> AccumulateCloverHistoryInfo? {
        return accumulateCloverInfo?.cloverHistoryList?[index]
    }
    
    
    // MARK: 누적 클로버 API 호출 함수
    func fetchCloverAccumulate(){
        self.isLoading = true
        self.dataService?.requestFetchCloverAccumulate(completion: { [weak self] response, error in
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
            self?.accumulateCloverInfo = response?.result
            self?.isLoading = false
            
        })
    }
}
