//
//  CloverRankingViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/18.
//

class CloverRankingViewModel {
    
    // MARK: 기본 프로퍼티
    private var dataService: CloverDataService?
    private var cloverRankingInfo = [CloverRankingInfo]() { didSet { self.didFinishFetch?() } }
    
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
    
    var pageIndex = 1
    var endOfPage = false
    var isPagination = false
    
    // MARK: 생성자
    init(dataService: CloverDataService) {
        self.dataService = dataService
    }
    
    //MARK: 클로버 랭킹 총 갯수
    var numOfCloverRankingList: Int {
        return cloverRankingInfo.count
    }
    
    //MARK: 클로버 랭킹 인덱스 조회
    func cloverRankingList(at index: Int) -> CloverRankingInfo? {
        return cloverRankingInfo[index]
    }
    
    var remainderOfCloverCurrentPagination: Int {
        if cloverRankingInfo.count == 0{
            return 0
        }
        return cloverRankingInfo.count % 20
    }
    
    private func didEndPagination(with pagination: Bool){
        pagination ? (self.isPagination = false) : (self.isLoading = false)
    }
    
    // MARK: 클로버 히스토리 API 호출 함수
    func fetchCloverRanking(with pagination : Bool = false){
        if endOfPage{ return }
        if pagination {
            self.isPagination = true
            self.pageIndex = self.pageIndex + 1
        } else {
            self.isLoading = true
        }
        self.dataService?.requestFetchCloverRanking(page: self.pageIndex, completion: { [weak self] response, error in
            guard let strongself = self else { return }
            if let error = error {
                strongself.error = error
                strongself.isLoading = false
                return
            }
            if let isSuccess = response?.isSuccess {
                if !isSuccess {
                    strongself.failMessage = response?.message
                    strongself.failCode = response?.code
                    if strongself.failCode == 366 { strongself.endOfPage = true }
                    strongself.didEndPagination(with: pagination)
                    return
                }
            }
            strongself.error = nil
            strongself.failMessage = nil
            if strongself.isPagination{
                strongself.cloverRankingInfo.append(contentsOf: response?.result?.ranks ?? [])
            }else {
                strongself.cloverRankingInfo = response?.result?.ranks ?? []
            }
            strongself.didEndPagination(with: pagination)
            
        })
    }
}
