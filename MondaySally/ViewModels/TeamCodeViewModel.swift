//
//  TeamCodeViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

class TeamCodeViewModel {
    private var dataService: DataService?
    
    // MARK: - Properties
    private var teamCodeInfo: TeamCodeInfo? {
        didSet {
            self.didFinishFetch?()
        }
    }
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    
    var fail: Bool? {
        didSet { self.showAlertClosure?() }
    }
    
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    // MARK: - 생성자
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    func fetchJwt(with teamCodeId: String){
        self.dataService?.requestFetchTeamCode(with: teamCodeId, completion: { [weak self] (teamCodeResponse, error) in
            if let error = error {
                self?.error = error
                self?.isLoading = false
                return
            }
            if let isSuccess = teamCodeResponse?.isSuccess {
                if !isSuccess {
                    self?.fail = isSuccess
                    self?.isLoading = false
                    return
                }
            }
            self?.error = nil
            self?.isLoading = false
            self?.teamCodeInfo = teamCodeResponse?.result
        })
    }
}
