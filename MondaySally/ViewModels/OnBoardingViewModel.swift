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
출퇴근을 인증하고 근무시간만큼
클로버를 획득하세요.
"""),
        
        OnBoardingInfo(imageName: "illustGift",
                       title: "클로버로 기프트 신청",
                       content: """
클로버로 다양하고 실용적인 기프트를
얻어 일에 대한 동기부여을 받아보세요.
"""),
        
        OnBoardingInfo(imageName: "illustTwinkleChicken", title: "반짝이는 순간, 트윙클", content: """
기프트를 통해 얻은 반짝이는 순간을
기록하고 동료들과 공유해보세요.
""")
    ]

    var numOfBountyInfoList: Int {
        return onBoardingInfoList.count
    }
    
    func onBoardingInfo(at index: Int) -> OnBoardingInfo{
        return onBoardingInfoList[index]
    }
    
}
