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
    private var availableGiftList = [AvailableGiftInfo]()
    
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
    
    //MARK: 현재 클로버로 신청가능한 기프트 갯수
    var numOfAvailableGift: Int {
        return availableGiftList.count
    }
    
    //MARK: 현재 클로버
    var currentClover: Int {
        return currentCloverInfo?.cloverTotal ?? 0
    }
    
    //MARK: 현재 클로버 리스트 인덱스 조회
    func availableGiftList(at index: Int) -> AvailableGiftInfo? {
        return currentCloverInfo?.availableGiftList?[index]
    }
    
    var remainderOfCloverCurrentPagination: Int {
        if availableGiftList.count == 0{
            return 0
        }
        return availableGiftList.count % 20
    }
    
    private func didEndPagination(with pagination: Bool){
        pagination ? (self.isPagination = false) : (self.isLoading = false)
    }
    
    // MARK: 현재 클로버 API 호출 함수
    func fetchCloverCurrent(with pagination : Bool = false){
        if endOfPage{ return }
        if pagination {
            self.isPagination = true
            self.pageIndex = self.pageIndex + 1
        } else {
            self.isLoading = true
        }
        self.dataService?.requestFetchCloverCurrent(page: self.pageIndex, completion: { [weak self] response, error in
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
                strongself.availableGiftList.append(contentsOf: response?.result?.availableGiftList ?? [])
            }else {
                strongself.currentCloverInfo = response?.result
                strongself.availableGiftList = strongself.currentCloverInfo?.availableGiftList ?? []
            }
            strongself.didEndPagination(with: pagination)
        })
    }
}
