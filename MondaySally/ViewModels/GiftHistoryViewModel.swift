//
//  MyGiftLogViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/16.
//

class GiftHistoryViewModel {
    
    //MARK: - Properties
    private var dataService: GiftDataService?
    private var myGiftLogInfo: GiftHistoryPagination?
    private var giftHistoryList = [MyGiftLogInfo]() { didSet { self.didFinishFetch?() } } 
    
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

    //MARK: 페이징을 위한 변수
    var pageIndex = 1
    var isPagination = false
    
    
    //MARK: 생성자
    init(dataService: GiftDataService) {
        self.dataService = dataService
    }
    
    //MARK: 기프트 히스토리 전체 갯수
    var numOfGiftLogInfo: Int {
        return giftHistoryList.count
    }
    
    var numOfTotalGiftLogInfo: Int {
        return myGiftLogInfo?.totalCount ?? 0
    }
    
    var remainderOfGiftPagination: Int {
        if giftHistoryList.count == 0{
            return 0
        }
        return giftHistoryList.count % 20
    }
    
    //MARK: 특정 기프트 히스토리
    func myGiftLogInfo(at index: Int) -> MyGiftLogInfo? {
        return giftHistoryList[index]
    }
    
    //MARK: 기프트 히스토리 API 호출 함수
    func fetchMyGiftLog(with pagination : Bool = false){
        if pagination && self.giftHistoryList.count == self.numOfTotalGiftLogInfo { return } // 마지막 페이지임.
        if pagination {
            self.isPagination = true
            self.pageIndex = self.pageIndex + 1
        } else {
            self.isLoading = true
        }
        self.dataService?.requestFetchMyGiftLog(page: self.pageIndex, completion: { [weak self] response, error in
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
                    strongself.didEndPagination(with: pagination)
                    return
                }
            }
            strongself.error = nil
            strongself.failMessage = nil
            if strongself.isPagination{
                strongself.giftHistoryList.append(contentsOf: response?.result?.giftLogs ?? [])
            }else {
                strongself.myGiftLogInfo = response?.result
                strongself.giftHistoryList = strongself.myGiftLogInfo?.giftLogs ?? []
            }
            strongself.didEndPagination(with: pagination)
        })
    }
    
    private func didEndPagination(with pagination: Bool){
        pagination ? (self.isPagination = false) : (self.isLoading = false)
    }
}
