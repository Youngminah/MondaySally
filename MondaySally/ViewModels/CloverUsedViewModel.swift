//
//  CloverUsedViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/21.
//

class CloverUsedViewModel {
    
    // MARK: 기본 프로퍼티
    private var dataService: CloverDataService?
    private var usedCloverInfo: UsedCloverInfo? { didSet { self.didFinishFetch?() } }
    
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
    
    //MARK: 사용 클로버 리스트 갯수
    var numOfUsedCloverList: Int {
        return usedCloverInfo?.cloverHistoryList?.count ?? 0
    }
    
    //MARK: 사용 클로버
    var usedClover: Int {
        return usedCloverInfo?.cloverTotal ?? 0
    }
    
    //MARK: 사용 클로버 리스트 인덱스 조회
    func usedCloverList(at index: Int) -> UsedCloverHistoryInfo? {
        return usedCloverInfo?.cloverHistoryList?[index]
    }
    
    
    // MARK: 사용 클로버 API 호출 함수
    func fetchCloverUsed(){
        self.isLoading = true
        self.dataService?.requestFetchCloverUsed(completion: { [weak self] response, error in
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
            self?.usedCloverInfo = response?.result
            self?.isLoading = false
            
        })
    }
}
