//
//  ClientPath.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import Foundation

struct ClientPath {
    
    /// The base Uri. Defaults to "client-api/${getBaseUriVersion()}"
    let baseURI: String
    
    /// The base Uri version.
    let baseURIVersion: String
    
    /// The service name of the presentation service.
    let serviceName: String
}

extension ClientPath {
    /// Constructs the complete components path (baseURI + baseURIVersion + serviceName).
    var completePath: String? { clientURL?.absoluteString }
    
    /// The URL for which to create a data task.
    var clientURL: URL? {
        URL(string: baseURI)?.appendingPathComponent(baseURIVersion).appendingPathComponent(serviceName)
    }
}
