//
//  Logger.swift
//  FishWorld
//
//  Created by Yurii Hranchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit

extension MMP_UIApplication.State {
    public func displayName() -> String {
        switch self {
        case .active: return "active"
        case .inactive: return "inactive"
        case .background: return "in background"
        default: return ""
        }
    }
}

public struct Logger {
    static let logglyDestination = SlimLogglyDestination()
    static func configure_MMP() {
        Slim.addLogDestination_MMP(logglyDestination)
    }
    public enum LogType: String {
        case `default` = ""
        case warning = "⚠️ Warning: "
        case info = "ℹ️ Info: "
        case error = "🔥 Error: "
        case debug = "🐞 Debug: "
        case verbose = "👍 Verbose: "
    }
    static func debugLog_MMP(_ string: @autoclosure () -> String,
                         type: LogType = .default,
                         filename: String = #file,
                         line: Int = #line,
                         isDebug: Bool = true) {
        if isDebug {
            Slim.debug_MMP("\(type.rawValue)\(string())\n",
                filename: filename,
                line: line)
        }
    }
    static func log_MMP<T>(_ message: @autoclosure () -> T,
                       type: LogType = .default,
                       filename: String = #file,
                       line: Int = #line,
                       isDebug: Bool = true) {
        if isDebug {
            Slim.debug_MMP("\(type.rawValue)\(message())\n",
                filename: filename,
                line: line)
        } else {
            Slim.info_MMP(message(), filename: filename, line: line)
        }
    }
    public static func error_MMP<T>(_ message: @autoclosure () -> T,
                         filename: String = #file,
                         line: Int = #line) {
        log_MMP(message(), type: .error, filename: filename, line: line)
    }
    public static func debug_MMP<T>(_ message: @autoclosure () -> T,
                         filename: String = #file,
                         line: Int = #line) {
        log_MMP(message(), type: .debug, filename: filename, line: line)
    }
    public static func warrning_MMP<T>(_ message: @autoclosure () -> T,
                            filename: String = #file,
                            line: Int = #line) {
        log_MMP(message(), type: .warning, filename: filename, line: line)
    }
    public static func info_MMP<T>(_ message: @autoclosure () -> T,
                        filename: String = #file,
                        line: Int = #line) {
        log_MMP(message(), type: .info, filename: filename, line: line)
    }
    public static func verbose_MMP<T>(_ message: @autoclosure () -> T,
                           filename: String = #file,
                           line: Int = #line) {
        log_MMP(message(), type: .verbose, filename: filename, line: line)
    }
}
