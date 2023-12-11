//
//  AsyncLoadingImage.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 17.11.2023.
//

import SwiftUI
import Resolver
import PDFKit

struct AsyncLoadingImage_MMP: View {

    @Injected private var dropBoxManager: Dropbox_MMP
    @InjectedObject private var networkManager: NetworkMonitoringManager_MMP

    @State private var image: Image?
    @State private var task: Task<Void, Error>?

    var path: String?
    var isPDF: Bool = false
    var isNeedLoader: Bool = true
    let size: CGSize
    var additionalYoffSet: CGFloat?

    var imageDidLoad: ValueClosure_MMP<Data>?

    var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.gray)
            }
        }
        .onChange(of: path, perform: { newValue in
            Task.detached {
                await getImage(path: newValue)
            }
        })
        .onChange(of: networkManager._isNetworkAvailable_MMP) { isOn in
            if image.isNil, isOn {
                if !task.isNil {
                    task?.cancel()
                }
                task = Task.detached {
                    await getImage(path: path)
                }
            }
        }
        .iosDeviceTypeFrame_mmp(
            iOSWidth: size.width,
            iOSHeight: size.height,
            iPadWidth: size.width,
            iPadHeight: size.height
        )
        .onViewDidLoad(action: {

            task = Task.detached {
                await getImage(path: path)
            }
        })
    }

    private func getImage(path: String?) async {
        guard let path else {
            return
        }
        do {
            let data = try await dropBoxManager.getData_MMP(forPath: path)

            await MainActor.run {
                imageDidLoad?(data)
            }

            if isPDF, let image = await Utilities_MMP.shared.getPDFImage_MMP(data: data, size: size, additionalYoffSet: additionalYoffSet) {
                await MainActor.run {
                    self.image = Image(uiImage: image)
                }
            } else if let image = Utilities_MMP.shared.getImage_MMP(data: data) {
                await MainActor.run {
                    self.image = Image(uiImage: image)
                }
            }
        } catch {
            Logger.error_MMP(error)
        }
    }
}
