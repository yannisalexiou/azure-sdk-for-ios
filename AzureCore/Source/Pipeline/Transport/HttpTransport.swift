//
//  HttpTransport.swift
//  AzureCore
//
//  Created by Travis Prescott on 8/29/19.
//  Copyright © 2019 Azure SDK Team. All rights reserved.
//

import Foundation

public protocol HttpTransport: PipelineSendable {
    func open()
    func close()
    func sleep(duration: Int)
}
