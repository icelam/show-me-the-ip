//
//  getIpAddress.swift
//  Show me the IP
//
//  Created by Pinky Lam on 8/5/2018.
//  Copyright © 2018 Pinky Lam. All rights reserved.
//

import Cocoa

class IpAddress: NSObject {
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var addresses : [String : String?] = ["v4": nil, "v6": nil]
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 and IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let addressMode =  addrFamily == UInt8(AF_INET) ? "v4" : "v6"
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "en1" {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    addresses[addressMode] = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return addresses["v4"] as? String ?? addresses["v6"] as? String ?? nil
    }
    
    func isIPv4(ipAddr: String) -> Bool {
        let addrArr = ipAddr.components(separatedBy: ".")
        return addrArr.count == 4
    }
    
    func getFormattedIP(n: Int?) -> String? {
        if let ipAddr = getWiFiAddress() {
            let addrArr = ipAddr.components(separatedBy: ".")
            if (n ?? 0 > 0 && addrArr.count == 4) {
                // FIXME: Convert this if else block to substring or regex
                var formattedAddr = "";
                if(n! < 1) {
                    formattedAddr += addrArr[0] + "."
                }
                if(n! < 2) {
                    formattedAddr += addrArr[1] + "."
                }
                if (n! < 3) {
                    formattedAddr += addrArr[2] + "."
                }
                formattedAddr += addrArr[3]
                
                return formattedAddr
            } else {
                return ipAddr
            }
        } else {
            return nil
        }
    }
}
