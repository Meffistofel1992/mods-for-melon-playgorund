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

    var isNeedFit: Bool = true
    var imageDidLoad: ValueClosure_MMP<Data>?

    var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
            } else {
                ZStack {
                    Color.white.opacity(0.0001)
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.gray)
                }
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
        .if(isNeedFit, transform: { $0.aspectRatio(contentMode: .fit) })
        .iosDeviceTypeFrame_mmp(
            iOSHeight: size.height,
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

#Preview {
    let moc = CoreDataMockService_MMP.preview

    return HomeView_MMP()
        .environment(\.managedObjectContext, moc)
}


extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
