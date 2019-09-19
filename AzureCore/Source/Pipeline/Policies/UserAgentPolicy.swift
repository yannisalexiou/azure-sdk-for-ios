//
//  UserAgentPolicy.swift
//  AzureCore
//
//  Created by Travis Prescott on 8/28/19.
//  Copyright © 2019 Azure SDK Team. All rights reserved.
//

import Foundation

public class UserAgentPolicy: SansIOHttpPolicy {

    private var _userAgent: String
    
    public let userAgentOverwrite: Bool
    public var userAgent: String {
        return self._userAgent
    }

    public init(baseUserAgent: String? = nil, userAgentOverwrite: Bool = false) {
        // TODO: User-Agent format accoring to SDK guidelines
        // [<application_id> ]azsdk-<sdk_language>-<package_name>/<package_version> <platform_info>
        // [Application/Version] azsdk-ios-AppConfiguration/0.1.0
        //   (Swift BLAH; ObjC BLAH; Macintosh; Intel Max OS X 10_10; rv:33.0)
        self.userAgentOverwrite = userAgentOverwrite
        if baseUserAgent == nil {
            // TODO: Distinguish between Swift and ObjC?
            let swiftVersion = 5.0
            let platform = "iPhone"
            let azureCoreVersion = "0.1.0"
            self._userAgent = "ios/\(swiftVersion) (\(platform)) AzureCore/\(azureCoreVersion)"
        } else {
            self._userAgent = baseUserAgent!
        }
    }

    public func appendUserAgent(value: String) {
        self._userAgent = "\(self._userAgent) \(value)"
    }

    public func onRequest(_ request: PipelineRequest) {
        let userAgentHeader = HttpHeader.userAgent.rawValue
        if let contextUserAgent = request.context?.getValue(forKey: "userAgent") as? String {
            if request.context?.getValue(forKey: "userAgentOverwrite") != nil {
                request.httpRequest.headers[userAgentHeader] = contextUserAgent
            } else {
                request.httpRequest.headers[userAgentHeader] = "\(self.userAgent) \(contextUserAgent)"
            }
        } else if self.userAgentOverwrite || request.httpRequest.headers[userAgentHeader] == nil {
            request.httpRequest.headers[userAgentHeader] = self.userAgent
        }
    }
}
