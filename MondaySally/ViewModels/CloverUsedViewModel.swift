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
    private var usedCloverList = [UsedCloverHistoryInfo]()
    
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
    
    //MARK: 사용 클로버 리스트 갯수
    var numOfUsedCloverList: Int {
        return usedCloverList.count
    }
    
    //MARK: 사용 클로버
    var usedClover: Int {
        return usedCloverInfo?.cloverTotal ?? 0
    }
    
    //MARK: 사용 클로버 리스트 인덱스 조회
    func usedCloverList(at index: Int) -> UsedCloverHistoryInfo? {
        return usedCloverInfo?.cloverHistoryList?[index]
    }
    
    var remainderOfCloverUsedPagination: Int {
        if usedCloverList.count == 0{
            return 0
        }
        return usedCloverList.count % 20
    }
    
    private func didEndPagination(with pagination: Bool){
        pagination ? (self.isPagination = false) : (self.isLoading = false)
    }
    
    
    // MARK: 사용 클로버 API 호출 함수
    func fetchCloverUsed(with pagination : Bool = false){
        if endOfPage{ return }
        if pagination {
            self.isPagination = true
            self.pageIndex = self.pageIndex + 1
        } else {
            self.isLoading = true
        }
        self.dataService?.requestFetchCloverUsed(page: self.pageIndex, completion: { [weak self] response, error in
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
            strongself.usedCloverInfo = response?.result
            if strongself.isPagination{
                strongself.usedCloverList.append(contentsOf: response?.result?.cloverHistoryList ?? [])
            }else {
                strongself.usedCloverInfo = response?.result
                strongself.usedCloverList = strongself.usedCloverInfo?.cloverHistoryList ?? []
            }
            strongself.didEndPagination(with: pagination)
        })
    }
}
