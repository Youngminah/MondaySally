//
//  AutoLoginViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

class AutoLoginViewModel {
    
    //MARK: 기본 프로퍼티
    private var dataService: AuthDataService?
    private var autoLoginResponse: AutoLoginResponse? { didSet { self.didFinishFetch?() } }
    
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
    
    var message: String {
        guard let message = autoLoginResponse?.message else {
            print("인터넷 통신은 완료 되었지만, 응답의 message를 upwrapping 할 수 없습니다")
            return ""
        }
        return message
    }
    
    // MARK: 생성자
    init(dataService: AuthDataService) {
        self.dataService = dataService
    }
    
    func fetchAutoLogin(){
        self.isLoading = true
        self.dataService?.requestFetchAutoLogin(completion: { [weak self] response, error in
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
                    strongself.isLoading = false
                    return
                }
            }
            strongself.error = nil
            strongself.isLoading = false
            strongself.failMessage = nil
            strongself.autoLoginResponse = response
        })
    }
}
