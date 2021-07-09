//
//  MyProfileViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

class MyProfileViewModel {
    private var dataService: DataService?
    // MARK: - Properties
    private var myProfileInfo: MyProfileInfo? {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    
    var failMessage: String? {
        didSet { self.showAlertClosure?() }
    }
    
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    var getMyProfileInfo: MyProfileInfo? {
        return myProfileInfo
    }
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    // MARK: - 생성자
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    func fetchMyProfile(){
        self.isLoading = true
        self.dataService?.requestFetchMyProfile(completion: { [weak self] myProfileResponse, error in
            if let error = error {
                self?.error = error
                self?.isLoading = false
                return
            }
            if let isSuccess = myProfileResponse?.isSuccess {
                if !isSuccess {
                    self?.failMessage = myProfileResponse?.message
                    self?.isLoading = false
                    return
                }
            }
            self?.error = nil
            self?.failMessage = nil
            self?.isLoading = false
            self?.myProfileInfo = myProfileResponse?.result
        })
    }
}
