//
//  ReachabilityService.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Network

protocol ReachabilityServiceProtocol {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

class ReachabilityService: ReachabilityServiceProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachabilityService")
    
    private(set) var isConnected: Bool = true
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                print(path.status)
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
