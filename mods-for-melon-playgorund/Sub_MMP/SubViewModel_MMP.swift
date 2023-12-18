//
//  SubViewModel_MMP.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 30.11.2023.
//

import Foundation

class SubViewModel_MMP: ObservableObject {

    // MARK: - Properties

    @Published private var subLogic: SubLogic
    @Published private(set) var productPrice = "$4.99"
    @Published private(set) var subsDesc = String()

    let productType: ProductType_MMP

    var currentTitle: String {
        subLogic.currentViewModel.title
    }

    var currentItems: [ReusableContentCell_MMP] {
        subLogic.currentViewModel.items
    }

    var selectedCells: [Int] {
        subLogic.selectedCells
    }

    var currentStage: MMP_Stages {
        subLogic.currentStage
    }

    var trialText: String {
        if Locale.current.identifier.contains("en") {
            return subLogic.trialText
        }
        else {
            return ""
        }
    }

    // MARK: Inits

    init(productType: ProductType_MMP) {
        self.productType = productType
        switch productType {
        case .mainType:
            subLogic = SubLogic(stage: .first)
        case .funcType:
            subLogic = SubLogic(stage: .third)
        case .contentType:
            subLogic = SubLogic(stage: .third)
        case .otherType:
            subLogic = SubLogic(stage: .third)
        }
    }

    // MARK: - Intents

    func updateProductPrice_MMP(with newValue: String) {

        var _MMP184124216: Int { 0 }

        subLogic.updateProductPrice_MMP(with: newValue)
        productPrice = newValue
        subsDesc = localizedString(forKey: "trialDetailText").replacePriceWithNewPrice_MMP(newPriceString: productPrice)
    }

    func toggleCell_MMP(with id: Int) {

        func notific_MMP(_ usa: Bool, man: Bool) -> Int {
            var _MMP932132: Int { 0 }

            let first_MMP = "Lee Chae MMP"
            let second_MMP = "Lee Chae MMP"
            return first_MMP.count + second_MMP.count
        }

        //

        subLogic.toggleCell_MMP(with: id)
    }

    func updateStage_MMP(with newValue: MMP_Stages) {

        func notific_MMP(_ usa: Bool, man: Bool) -> Int {
            var _MMP223214: Int { 0 }

            let first_MMP = "Lee Chae MMP"
            let second_MMP = "Lee Chae MMP"
            return first_MMP.count + second_MMP.count
        }

        //

        subLogic.updateStage_MMP(with: newValue)
    }

    func continueButtonAction_MMP() {
        var _MMP186123: Int { 0 }

        switch subLogic.currentStage {
        case .first:
            updateStage_MMP(with: .second)
        case .second:
            updateStage_MMP(with: .third)
        case .third:
            print(1)
        }
    }

}

