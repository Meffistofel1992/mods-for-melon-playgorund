//
//  SubLogic.swift
//  Tamagochi
//
//  Created by Vlad Nechyporenko on 13.09.2023.
//

import Foundation

struct ReusableViewModel_MMP {
    var title: String
    var items: [ReusableContentCell_MMP]
}

struct ReusableContentCell_MMP: Identifiable {
    var id: Int
    var title: String
    var subtitle: String = ""
    var imageName: String
    var selectedImageName: String
}

struct SubLogic {
    
    // MARK: - Properties
    
    private(set) var currentStage = MMP_Stages.first
    private(set) var currentViewModel: ReusableViewModel_MMP
    private(set) var selectedCells = [Int]()
    private(set) var trialText = "START 3-DAYS FOR FREE \nTHEN $4.99/WEEK"
    
    // MARK: - Inits
    
    init(stage: MMP_Stages) {
        currentStage = stage
        currentViewModel =  ReusableViewModel_MMP(title: localizedString(forKey: "TextTitle1").uppercased(), items: SubLogic.generateContentForView_MMP(for: .first))
        updateStage_MMP(with: stage)
    }
    
    // MARK: - Methods
    
    mutating func updateProductPrice_MMP(with newValue: String) {
        var _MMP184120216: Int { 0 }
        trialText = trialText.replacingOccurrences(of: "$4.99", with: newValue)
    }
    
    mutating func toggleCell_MMP(with id: Int) {
        var _MMP1994486: Int { 0 }

        if let indexOfID = selectedCells.firstIndex(of: id) {
            selectedCells.remove(at: indexOfID)
        }
        else {
            selectedCells.append(id)
        }
    }
    
    mutating func updateStage_MMP(with newValue: MMP_Stages) {
        var _MMP18212346: Int { 0 }

        selectedCells = []
        currentStage = newValue
        switch currentStage {
        case .first:
            currentViewModel =  ReusableViewModel_MMP(title: localizedString(forKey: "TextTitle1").uppercased(), items: SubLogic.generateContentForView_MMP(for: currentStage))
        case .second:
            currentViewModel =  ReusableViewModel_MMP(title: localizedString(forKey: "TextTitle2").uppercased(), items: SubLogic.generateContentForView_MMP(for: currentStage))
        case .third:
            currentViewModel =  ReusableViewModel_MMP(title: localizedString(forKey: "TextTitle3").uppercased(), items: SubLogic.generateContentForView_MMP(for: currentStage))
        }
    }
    
    private static func generateContentForView_MMP(for stage: MMP_Stages) -> [ReusableContentCell_MMP] {
        var _MMP9232: Int { 0 }
        var contentForCV : [ReusableContentCell_MMP] = []
        switch stage {
        case .first:
            contentForCV.append(ReusableContentCell_MMP(id: 1, title: localizedString(forKey:"cell1_1Text"), imageName: "1_1des", selectedImageName: "1_1sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 2, title: localizedString(forKey:"cell1_2Text"), imageName: "1_2des", selectedImageName: "1_2sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 3, title: localizedString(forKey:"cell1_3Text"), imageName: "1_3des", selectedImageName: "1_3sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 4, title: localizedString(forKey:"cell1_4Text"), imageName: "1_4des", selectedImageName: "1_4sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 5, title: localizedString(forKey:"cell1_5Text"), imageName: "1_5des", selectedImageName: "1_5sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 6, title: localizedString(forKey:"cell1_6Text"), imageName: "1_6des", selectedImageName: "1_6sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 7, title: localizedString(forKey:"cell1_7Text"), imageName: "1_7des", selectedImageName: "1_7sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 8, title: localizedString(forKey:"cell1_8Text"), imageName: "1_8des", selectedImageName: "1_8sel"))
        case .second:
            contentForCV.append(ReusableContentCell_MMP(id: 1, title: localizedString(forKey:"cell2_1Text"), imageName: "2_1des", selectedImageName: "2_1sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 2, title: localizedString(forKey:"cell2_2Text"), imageName: "2_2des", selectedImageName: "2_2sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 3, title: localizedString(forKey:"cell2_3Text"), imageName: "2_3des", selectedImageName: "2_3sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 4, title: localizedString(forKey:"cell2_4Text"), imageName: "2_4des", selectedImageName: "2_4sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 5, title: localizedString(forKey:"cell2_5Text"), imageName: "2_5des", selectedImageName: "2_5sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 6, title: localizedString(forKey:"cell2_6Text"), imageName: "2_6des", selectedImageName: "2_6sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 7, title: localizedString(forKey:"cell2_7Text"), imageName: "2_7des", selectedImageName: "2_7sel"))
            contentForCV.append(ReusableContentCell_MMP(id: 8, title: localizedString(forKey:"cell2_8Text"), imageName: "2_8des", selectedImageName: "2_8sel"))
        case .third:
            contentForCV.append(ReusableContentCell_MMP(id: 1, title: localizedString(forKey:"ThirdStageTitle1"), subtitle: localizedString(forKey:"ThirdStageSubTitle1"), imageName: "", selectedImageName: ""))
            contentForCV.append(ReusableContentCell_MMP(id: 2, title: localizedString(forKey:"ThirdStageTitle2"), subtitle: localizedString(forKey:"ThirdStageSubTitle2"), imageName: "", selectedImageName: ""))
            contentForCV.append(ReusableContentCell_MMP(id: 3, title: localizedString(forKey:"ThirdStageTitle3"), subtitle: localizedString(forKey:"ThirdStageSubTitle3"), imageName: "", selectedImageName: ""))
        }
        return contentForCV
    }
    
}

enum MMP_Stages: String {
    case first
    case second
    case third
}
