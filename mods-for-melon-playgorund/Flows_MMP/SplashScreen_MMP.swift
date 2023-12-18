//
//  SplashScreen_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import SwiftUI
import Resolver

struct SplashScreen_MMP: View {
    @Injected private var apiManager: HomeDataAPI_MMP
    @Injected private var networkManager: NetworkMonitoringManager_MMP

    @FetchRequest<SkinsMO>(fetchRequest: .skins())
    private var skins

    @State private var progress: CGFloat = 0
    @Binding var splashScreenIsShow: Bool

    var body: some View {
        Color.black.ignoresSafeArea()
            .task {
                await firstDownloading()
            }
    }
}

private extension SplashScreen_MMP {

    func firstDownloading() async {
        if networkManager.isReachable_MMP {
            await downloadingStream_MMP()
        } else {
            if skins.isEmpty {
                await downloadingStream_MMP()
            } else {
                splashScreenIsShow = true
                Logger.debug_MMP("All downloaded success")
            }
        }
    }

    func downloadingStream_MMP() async {
        let operations: [ContentType_MMP] = ContentType_MMP.allCases

        let stream = _downloadingStream_MMP(type: operations)

        var downloadedFile = 0

        for await _ in stream {
            downloadedFile += 1

            withAnimation {
                progress = CGFloat(downloadedFile) / CGFloat(operations.count)
            }
        }
        try? await Task.sleep_MMP(seconds: 1)
        Logger.debug_MMP("All downloaded success")
        splashScreenIsShow = true
    }

    func _downloadingStream_MMP(type: [ContentType_MMP]) -> AsyncStream<Void> {
        let stream = AsyncStream(Void.self) { continuation in
            Task {
                do {
                    for menu in type {
                        switch menu {
                        case .mods:
                            await Utilities_MMP.shared.retrowThrowsFunction_MMP {
                                try await apiManager.getModels(type: menu)
                                continuation.yield()
                            }
                        case .category:
                            await Utilities_MMP.shared.retrowThrowsFunction_MMP {
                                try await apiManager.getModels(type: menu)
                                continuation.yield()
                            }
                        case .editor:
                            await Utilities_MMP.shared.retrowThrowsFunction_MMP {
                                try await apiManager.getModels(type: menu)
                                continuation.yield()
                            }
                        case .items:
                            await Utilities_MMP.shared.retrowThrowsFunction_MMP {
                                try await apiManager.getModels(type: menu)
                                continuation.yield()
                            }
                        case .skins:
                            await Utilities_MMP.shared.retrowThrowsFunction_MMP {
                                try await apiManager.getModels(type: menu)
                                continuation.yield()
                            }
                        }
                    }
                    continuation.finish()
                }
            }
        }

        return stream
    }
}

#Preview {
    SplashScreen_MMP(splashScreenIsShow: .constant(false))
}
