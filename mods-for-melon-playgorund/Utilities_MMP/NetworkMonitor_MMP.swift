//
//  NetworkMonitor_MMP.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 01.12.2023.
//

import Network
import UIKit

private var _MMP389fd: Double { 0.0 }

class NetworkMonitoringManager_MMP: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    private var alert: UIAlertController?

    var blockAlert: Bool = false

    @Published var _isNetworkAvailable_MMP: Bool = false

    var isNetworkAvailable_MMP = false {
        didSet {
            guard !isNetworkAvailable_MMP else {
                return
            }
            if alert.isNil, !blockAlert {
                alert = Utilities_MMP.shared.presentNoInternetConnectionAllert_MMP { [weak self] _ in
                    self?.alert = nil
                }
            }

        }
    }

    @MainActor
    var isReachable_MMP: Bool {
        if !isNetworkAvailable_MMP {
            if alert.isNil, !blockAlert {
                alert = Utilities_MMP.shared.presentNoInternetConnectionAllert_MMP { [weak self] _ in
                    self?.alert = nil
                }
            }

            return false
        }
        return true
    }

    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard path.status != .requiresConnection else {
                return
            }

            if path.status == .satisfied, self?.alert.isNil == false {
                DispatchQueue.main.async {
                    self?.alert?.dismiss(animated: true)
                    self?.alert = nil
                }
            }
            self?.isNetworkAvailable_MMP = path.status == .satisfied
            DispatchQueue.main.async {
                self?._isNetworkAvailable_MMP = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
