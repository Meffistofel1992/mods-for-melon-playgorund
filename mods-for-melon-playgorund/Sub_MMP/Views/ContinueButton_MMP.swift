//
//  ContinueButton.swift
//  Tamagochi
//
//  Created by Vlad Nechyporenko on 13.09.2023.
//

import SwiftUI

struct ContinueButton: View {
    
    @EnvironmentObject var iapViewModel: IAPManager_MMP
    
    @ObservedObject var SubViewModel_MMP: SubViewModel_MMP
    
    @State private var isScaled: Bool = false
    
    var body: some View {
        Button(action: {
            withAnimation(Animation.easeIn(duration: 0.5)) {
                if SubViewModel_MMP.currentStage == .third {
                    iapViewModel.purchaseProduct(of: SubViewModel_MMP.productType)
                } else {
                    SubViewModel_MMP.continueButtonAction_MMP()
                }
            }
        }, label: {
            ZStack {
                Color.black
                Image("")
                Text(NSLocalizedString("continueText", comment: ""))
            }
            .cornerRadius(16)
        })
        .disabled(iapViewModel.isPurchasing)
        .font(Font.custom(Configurations_MMP.MMP_getSubFontName(), size: 25))
        .foregroundColor(.white)
        .scaleEffect(isScaled ? 1 : 0.75)
        .onAppear {
            isScaled = true
        }
        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isScaled)
    }
    
}

struct ContinueButton_Previews: PreviewProvider {
    static var previews: some View {
        ContinueButton(SubViewModel_MMP: SubViewModel_MMP(productType: .mainType))
            .environmentObject(SubViewModel_MMP(productType: .mainType))
            .previewLayout(.fixed(width: 500, height: 100))
    }
}

