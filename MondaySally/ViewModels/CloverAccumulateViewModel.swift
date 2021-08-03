//
//  CloverHistoryViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/18.
//

class CloverAccumulateViewModel {
    
    // MARK: 기본 프로퍼티
    private var dataService: CloverDataService?
    private var accumulateCloverInfo: AccumulateCloverInfo?
    private var accumulateCloverList = [AccumulateCloverHistoryInfo]() { didSet { self.didFinishFetch?() } }
    
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
    
    //MARK: 생성자
    init(dataService: CloverDataService) {
        self.dataService = dataService
    }
    
    //MARK: 누적 클로버 리스트 갯수
    var numOfTotalClover: Int {
        return accumulateCloverList.count
    }
    
    //MARK: 누적 클로버
    var accumulateClover: Int {
        return accumulateCloverInfo?.cloverTotal ?? 0
    }
    
    //MARK: 누적 클로버 리스트 인덱스 조회
    func accumulateCloverList(at index: Int) -> AccumulateCloverHistoryInfo? {
        return accumulateCloverList[index]
    }
    
    var remainderOfCloverAccumulatePagination: Int {
        if accumulateCloverList.count == 0{
            return 0
        }
        return accumulateCloverList.count % 20
    }
    
    private func didEndPagination(with pagination: Bool){
        pagination ? (self.isPagination = false) : (self.isLoading = false)
    }
    
    // MARK: 누적 클로버 API 호출 함수
    func fetchCloverAccumulate(with pagination : Bool = false){
        if endOfPage{ return }
        if pagination {
            self.isPagination = true
            self.pageIndex = self.pageIndex + 1
        } else {
            self.isLoading = true
        }
        self.dataService?.requestFetchCloverAccumulate(page: self.pageIndex, completion: { [weak self] response, error in
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
            print("\(strongself.pageIndex)")
            if strongself.isPagination{
                guard let data = response?.result?.cloverHistoryList else { return }
                strongself.accumulateCloverList.append(contentsOf: data)
            }else {
                strongself.accumulateCloverInfo = response?.result
                strongself.accumulateCloverList = strongself.accumulateCloverInfo?.cloverHistoryList ?? []
            }
            strongself.didEndPagination(with: pagination)
        })
    }
}
