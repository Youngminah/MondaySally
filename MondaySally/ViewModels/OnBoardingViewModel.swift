//
//  OnBoardingViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/01.
//

class OnBoardingViewModel {
    let onBoardingInfoList: [OnBoardingInfo] = [
        OnBoardingInfo(imageName: "illustTimePoint",
                       title: "출퇴근 시간에 따른 포인트",
                       content: """
출퇴근 시 QR 코드 인증을 통해
근무시간을 포인트화 해보세요.
"""),
        
        OnBoardingInfo(imageName: "illustGift",
                       title: "누적 포인트로 기프트 구매",
                       content: """
다양하고 실용적인 기프트 구매를 통해
일에 대한 동기부여를 받아보세요.
"""),
        
        OnBoardingInfo(imageName: "illustTwinkleChicken", title: "포인트 스토리기능 트윙클", content: """
돈으로 환급 가능한 포인트를 활용하여
동료들과 그 순간을 공유해보세요.
""")
    ]

    var numOfBountyInfoList: Int {
        return onBoardingInfoList.count
    }
    
    func onBoardingInfo(at index: Int) -> OnBoardingInfo{
        return onBoardingInfoList[index]
    }
    
}
