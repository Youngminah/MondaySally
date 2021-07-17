//
//  TeamCodeViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

class TeamCodeViewModel {
    
    // MARK: - Properties
    private var dataService: AuthDataService?
    private var teamCodeInfo: TeamCodeInfo? { didSet { self.didFinishFetch?() } }
    
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
    
    var jwtToken: String {
        guard let jwt = teamCodeInfo?.jwt else {
            print("인터넷 통신은 완료 되었지만, jwt를 upwrapping 할 수 없습니다")
            return ""
        }
        return jwt
    }
    
    // MARK: - 생성자
    init(dataService: AuthDataService) {
        self.dataService = dataService
    }
    
    func fetchJwt(with teamCodeId: String){
        self.isLoading = true
        self.dataService?.requestFetchTeamCode(with: teamCodeId, completion: { [weak self] (teamCodeResponse, error) in
            if let error = error {
                self?.error = error
                self?.isLoading = false
                return
            }
            if let isSuccess = teamCodeResponse?.isSuccess {
                if !isSuccess {
                    self?.failMessage = teamCodeResponse?.message
                    self?.failCode = teamCodeResponse?.code
                    self?.isLoading = false
                    return
                }
            }
            self?.error = nil
            self?.failMessage = nil
            self?.isLoading = false
            self?.teamCodeInfo = teamCodeResponse?.result
        })
    }
}
