//
//  TwinkleProveViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/19.
//

class TwinkleProveViewModel {
    
    // MARK: 기본 프로퍼티
    private var dataService: TwinkleDataService?
    private var twinkleProveInfo = [TwinkleProveInfo]() { didSet { self.didFinishFetch?() } }
    
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
    init(dataService: TwinkleDataService) {
        self.dataService = dataService
    }
    
    //MARK: 전체 트윙클 총 갯수
    var numOfTwinkleTotal: Int {
        return twinkleProveInfo.count
    }
    
    
    var remainderOfTwinklePagination: Int {
        if twinkleProveInfo.count == 0{
            return 0
        }
        return twinkleProveInfo.count % 20
    }
    
    
    //MARK: 트윙클 인덱스 조회
    func twinkleProveList(at index: Int) -> TwinkleProveInfo? {
        return twinkleProveInfo[index]
    }
    
    
    // MARK: 미증빙/증빙 트윙클 페이징 적용 API 호출 함수
    func fetchTwinkleProve(with pagination : Bool = false){
        if endOfPage{ return }
        if pagination {
            self.isPagination = true
            self.pageIndex = self.pageIndex + 1
        } else {
            self.isLoading = true
        }
        self.dataService?.requestFetchTwinkleProve(page: self.pageIndex, completion: { [weak self] response, error in
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
                strongself.twinkleProveInfo.append(contentsOf: response?.result?.giftLogs ?? [])
            }else {
                strongself.twinkleProveInfo = response?.result?.giftLogs ?? []
            }
            strongself.didEndPagination(with: pagination)
        })
    }
    
    private func didEndPagination(with pagination: Bool){
        pagination ? (self.isPagination = false) : (self.isLoading = false)
    }
}
