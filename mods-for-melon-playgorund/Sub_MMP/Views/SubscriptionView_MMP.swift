//
//  SubscriptionView.swift
//  Tamagochi
//
//  Created by Vlad Nechyporenko on 13.09.2023.
//

import SwiftUI
import AVFoundation
import Resolver

struct SubscriptionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @InjectedObject private var iapManager: IAPManager_MMP

    @StateObject var SubViewModel_MMP: SubViewModel_MMP
    
    @State private var player = AVQueuePlayer()
    @State private var showError = false

    var body: some View {
        MMP_makeMainView()
    }
    
    @ViewBuilder
    private func MMP_makeMainView() -> some View {
        let _ = print("MMP_13413")
        GeometryReader { geo in
            ZStack {
                MMP_makePlayerView()
                    .frame(width: geo.size.width, height: geo.size.height)
                if SubViewModel_MMP.currentStage != .third {
                    MMP_makeViewForFirstAndSecondStage(with: geo)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        .zIndex(1)
                }
                else {
                    MMP_makeViewForThirdStage(with: geo)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
            .onAppear {
                SubViewModel_MMP.updateProductPrice_MMP(with: iapManager.getPrice(of: SubViewModel_MMP.productType))
                if !iapManager.error.isEmpty {
                    showError = true
                }
            }
            .onChange(of: iapManager.error, perform: { newValue in
                if !newValue.isEmpty {
                    showError = true
                }
            })
            .alert("", isPresented: $showError, actions: {
                Button(action: {
                    showError = false
                    iapManager.resetError()
                }, label: {
                    Text("OK")
                })
            }, message: {
                Text(iapManager.error)
            })
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func MMP_makeViewForThirdStage(with geo: GeometryProxy) -> some View {
        let _ = print("MMP_01293214")
        VStack {
            HStack {
                if SubViewModel_MMP.productType != .mainType {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    })
                }
                Spacer()
                Button(action: {
                    iapManager.restore()
                }, label: {
                    Text(NSLocalizedString("restore", comment: ""))
                })
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .regular, size: 12),
                    iPad: .init(name: .sfProDisplay, style: .regular, size: 22)
                )
                .foregroundColor(.white)
            }
            .padding(EdgeInsets(top: 60, leading: 20, bottom: 0, trailing: 20))
            Spacer()
            VStack {
                HStack {
                    MMP_makeTitle(with: SubViewModel_MMP.currentTitle, isLeftAlignment: true)
                    Spacer()
                }
                ForEach(SubViewModel_MMP.currentItems){ item in
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 0) {
                            MMP_makeTextView(with: item.title, and: .white, fontSize: 12)
                            MMP_makeTextView(with: item.subtitle, and: .white, fontSize: 12)
                        }
                        Spacer()
                    }
                    .padding(.leading)
                }
                ScrollView(.vertical) {
                    HStack {
                        if !SubViewModel_MMP.trialText.isEmpty {
                            Image(systemName: "star.fill")
                                .foregroundColor(.white)
                            MMP_makeTextView(with: SubViewModel_MMP.trialText, and: .white, fontSize: 12, maxLines: 2)
                        }
                    }
                    .frame(height: 30)
                    HStack {
                        Spacer()
                        ContinueButton(SubViewModel_MMP: SubViewModel_MMP)
                            .frame(width: geo.size.width * 0.9, height: UIDevice.current.userInterfaceIdiom == .phone ? 60 : geo.size.height / 15)
                        Spacer()
                    }
                    HStack {
                        MMP_makeBottomButton(with: localizedString(forKey: "TermsID"), and: {
                            UIApplication.shared.open(URL(string: Configurations_MMP.termsLink)!)
                        })
                        Spacer()
                        MMP_makeBottomButton(with: localizedString(forKey: "PrivacyID"), and: {
                            UIApplication.shared.open(URL(string: Configurations_MMP.policyLink)!)
                        })
                    }
                    .padding([.leading, .trailing])
                    Text(SubViewModel_MMP.subsDesc)
                        .font(.system(size: 15))
                        .padding([.horizontal, .top], 10)
                        .padding(.bottom, 20)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 5)
                .frame(height: MMP_getScrollHeight(from: geo))
            }
        }
    }
    
    @ViewBuilder
    private func MMP_makeViewForFirstAndSecondStage(with geo: GeometryProxy) -> some View {
        let _ = print("MMP_123915")
        VStack {
            Spacer()
            MMP_makeTitle(with: SubViewModel_MMP.currentTitle)
            if SubViewModel_MMP.currentStage == .first {
                MMP_makeScrollForGrid(with: geo)
            } else {
                MMP_makeScrollForGrid(with: geo)
            }
            HStack {
                Spacer()
                ContinueButton(SubViewModel_MMP: SubViewModel_MMP)
                    .frame(width: geo.size.width * 0.9, height: UIDevice.current.userInterfaceIdiom == .phone ? 60 : geo.size.height / 15)
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 42, trailing: 0))
        }
    }
    
    private func MMP_makeScrollForGrid(with geo: GeometryProxy) -> some View {
        let _ = print("MMP_1921002130")
        return ScrollView(.horizontal, showsIndicators: false) {
            MMP_makeGrid(with: geo)
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        .frame(width: geo.size.width, height: geo.size.height / (UIDevice.current.userInterfaceIdiom == .phone ? 6 : 8))
    }
    
    @ViewBuilder
    private func MMP_makeGrid(with geo: GeometryProxy) -> some View {
        let _ = print("MMP_192312412")
        LazyHGrid(rows: [GridItem(.fixed(geo.size.height / (UIDevice.current.userInterfaceIdiom == .pad ? 9.5 : 7)))], spacing: geo.size.width / (UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20)){
            ForEach(SubViewModel_MMP.currentItems){ item in
            ZStack {
                Color(.gray)
                VStack {
                    MMP_makeCellImage(with: item.imageName)
                    MMP_makeTextView(with: item.title, and: SubViewModel_MMP.selectedCells.contains(item.id) ? Color(red: 1, green: 1, blue: 1, alpha: 1) : Color(red: 1, green: 1, blue: 1, alpha: 0.5))
                }
            }
            .cornerRadius(UIDevice.current.userInterfaceIdiom == .phone ? 6 : 12)
            .onTapGesture {
                withAnimation(Animation.easeInOut(duration: 0.25)) {
                    SubViewModel_MMP.toggleCell_MMP(with: item.id)
                }
            }
            .scaleEffect(SubViewModel_MMP.selectedCells.contains(item.id) ? 1.15 : 1)
            .frame(width: geo.size.width / (UIDevice.current.userInterfaceIdiom == .pad ? 9 : (UIDevice.current.hasPhysicalButton ? 5 : 4)), height: geo.size.height / (UIDevice.current.userInterfaceIdiom == .pad ? 9.5 : 7))
        }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
    
    @ViewBuilder
    private func MMP_makeTextView(with text: String, and foregroundColor: Color, fontSize: CGFloat = 10, maxLines: Int = 1) -> some View {
        let _ = print("MMP_9012323")
        Text(text)
            .minimumScaleFactor(0.2)
            .font(Font.custom(Configurations_MMP.MMP_getSubFontName(), size: fontSize))
            .multilineTextAlignment(.center)
            .lineLimit(maxLines)
            .foregroundColor(foregroundColor)
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
    }
    
    @ViewBuilder
    private func MMP_makeBottomButton(with text: String, and action: @escaping () -> Void) -> some View {
        let _ = print("MMP_23999321")

        Button(action: {
            action()
        }, label: {
            Text(text)
                .underline(true, color: .white)
                .minimumScaleFactor(0.2)
                .font(Font.custom("Poppins-Medium", size: 12))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .foregroundColor(.white)
        })
    }
    
    @ViewBuilder
    private func MMP_makeCellImage(with name: String) -> some View {
        let _ = print("MMP_1929214")
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
    }
    
    @ViewBuilder
    private func MMP_makeTitle(with text: String, isLeftAlignment: Bool = false) -> some View {
        let _ = print("MMP_0023921")
        Text(text)
            .multilineTextAlignment(isLeftAlignment ? .leading : .center)
            .font(Font.custom(Configurations_MMP.MMP_getSubFontName(), size: 24))
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
    
    @ViewBuilder
    private func MMP_makePlayerView() -> some View {
        let _ = print("MMP_23223921")

        PlayerView_MMP(videoName: UIDevice.current.userInterfaceIdiom == .pad ? ConfigurationMediaSub_MMP.nameFileVideoForPad : ConfigurationMediaSub_MMP.nameFileVideoForPhone, player: player)
            .aspectRatio(contentMode: .fill)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                player.play()
            }
            .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { notification in
                MMP_handleInterruption(notification: notification)
            }
    }
    
    private func MMP_handleInterruption(notification: Notification) {
        var _MMP18132496: Int { 0 }

        guard let info = notification.userInfo,
            let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        if type == .began {
            // Interruption began, take appropriate actions (save state, update user interface)
            player.pause()
        } else if type == .ended {
            guard let optionsValue =
                info[AVAudioSessionInterruptionOptionKey] as? UInt else {
                    return
            }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // Interruption Ended - playback should resume
                player.play()
            }
        }
    }
    
    private func MMP_getScrollHeight(from geo: GeometryProxy) -> CGFloat {
        let _ = print("MMP_999232")
        return (UIDevice.current.userInterfaceIdiom == .phone ? 60 : geo.size.height / 15) + 87
    }
    
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView(SubViewModel_MMP: SubViewModel_MMP(productType: .mainType))
            .environmentObject(IAPManager_MMP())
    }
}

