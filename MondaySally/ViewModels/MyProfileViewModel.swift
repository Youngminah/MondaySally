//
//  MyProfileViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

class MyProfileViewModel {
    
    // MARK: - Properties
    private var dataService: AuthDataService?
    private var myProfileInfo: MyProfileInfo? { didSet { self.didFinishFetch?() } }
    
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
    
    
    // MARK: - 생성자
    init(dataService: AuthDataService) {
        self.dataService = dataService
    }
    
    var getMyProfileInfo: MyProfileInfo? {
        return myProfileInfo
    }
    
    func fetchMyProfile(){
        self.isLoading = true
        self.dataService?.requestFetchMyProfile(completion: { [weak self] response, error in
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
            strongself.failMessage = nil
            strongself.isLoading = false
            strongself.myProfileInfo = response?.result
        })
    }
}
