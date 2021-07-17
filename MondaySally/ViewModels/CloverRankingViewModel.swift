//
//  CloverRankingViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/18.
//

class CloverRankingViewModel {
    
    // MARK: 기본 프로퍼티
    private var dataService: CloverDataService?
    private var cloverRankingInfo: [CloverRankingInfo]? { didSet { self.didFinishFetch?() } }
    
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
    init(dataService: CloverDataService) {
        self.dataService = dataService
    }
    
    //MARK: 클로버 랭킹 총 갯수
    var numOfCloverRankingList: Int? {
        return cloverRankingInfo?.count
    }
    
    //MARK: 클로버 랭킹 인덱스 조회
    func cloverRankingList(at index: Int) -> CloverRankingInfo? {
        return cloverRankingInfo?[index]
    }
    
    // MARK: 클로버 히스토리 API 호출 함수
    func fetchCloverRanking(){
        self.isLoading = true
        self.dataService?.requestFetchCloverRanking(completion: { [weak self] response, error in
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
            self?.cloverRankingInfo = response?.result
            self?.isLoading = false
            
        })
    }
}
