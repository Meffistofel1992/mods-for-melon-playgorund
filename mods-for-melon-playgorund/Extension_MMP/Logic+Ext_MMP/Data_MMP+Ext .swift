//
//  Data_MMP + .swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 16.11.2023.
//

import Foundation

typealias MMP_Data = Data

extension MMP_Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
