//
//  NetworkMonitor.swift
//  Backend
//
//  Created by Gabriel Carvalho on 24/09/23.
//

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private(set) var status: NWPath.Status = .requiresConnection
    private var isReachable: Bool { status == .satisfied }
    private var isReachableOnCellular: Bool = true
    private(set) var isMonitoring = false

    func startMonitoring() {
        isMonitoring = true
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status != .satisfied {
                print("No connection.")
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
        isMonitoring = false
    }
}
