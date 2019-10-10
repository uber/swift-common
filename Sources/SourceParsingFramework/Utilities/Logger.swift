//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Concurrency
import Foundation

/// The various levels of logging.
public enum LoggingLevel: Int {
    /// The most verbose level including all logs.
    case debug
    /// The level that includes everything except debug logs.
    case info
    /// The level that only includes warning logs.
    case warning
    /// The level that indicates a fatal error has occurred.
    case error

    /// An cute emoticon describing the log level.
    public var emoticon: String {
        switch self {
        case .debug: return "🐞"
        case .info: return "📋"
        case .warning: return "❗️"
        case .error: return "💩"
        }
    }

    /// A text description the log level.
    public var text: String {
        switch self {
        case .debug: return "debug"
        case .info: return "info"
        case .warning: return "warning"
        case .error: return "error"
        }
    }

    /// Retrieve the logging level based on the given String value.
    ///
    /// - parameter value: The `String` value to parse from.
    /// - returns: The corresponding `LoggingLevel` if there is one.
    /// `nil` otherwise.
    public static func level(from value: String) -> LoggingLevel? {
        switch value {
        case "debug": return .debug
        case "info": return .info
        case "warning": return .warning
        case "error": return .error
        default: return nil
        }
    }
}

// Use `AtomicInt` since logging may be invoked from multiple threads.
private let minLoggingOutputLevel = AtomicInt(initialValue: LoggingLevel.warning.rawValue)

/// Set the minimum logging level required to output a message.
///
/// - parameter minLoggingOutputLevel: The minimum logging level.
public func set(minLoggingOutputLevel level: LoggingLevel) {
    minLoggingOutputLevel.value = level.rawValue
}

/// Log the given message at the `debug` level.
///
/// - parameter message: The message to log.
/// - parameter path: The file path this error applies to
///   (if specified, the log output changes to one that matches compiler error and can be parsed easily by build systems)
/// - note: The mesasge is only logged if the current `minLoggingOutputLevel`
/// is set at or below the `debug` level.
public func debug(_ message: String, path: String? = nil) {
    log(message, atLevel: .debug, path: path)
}

/// Log the given message at the `info` level.
///
/// - parameter message: The message to log.
/// - parameter path: The file path this error applies to
///   (if specified, the log output changes to one that matches compiler error and can be parsed easily by build systems)
/// - note: The mesasge is only logged if the current `minLoggingOutputLevel`
/// is set at or below the `info` level.
public func info(_ message: String, path: String? = nil) {
    log(message, atLevel: .info, path: path)
}

/// Log the given message at the `warning` level.
///
/// - parameter message: The message to log.
/// - parameter path: The file path this error applies to
///   (if specified, the log output changes to one that matches compiler error and can be parsed easily by build systems)
/// - note: The mesasge is only logged if the current `minLoggingOutputLevel`
/// is set at or below the `warning` level.
public func warning(_ message: String, path: String? = nil) {
    log(message, atLevel: .warning, path: path)
}

/// Log the given message at the `error` level and terminate.
///
/// - parameter message: The message to log.
/// - parameter path: The file path this error applies to
///   (if specified, the log output changes to one that matches compiler error and can be parsed easily by build systems)
/// - returns: `Never`.
/// - note: The mesasge is only logged if the current `minLoggingOutputLevel`
/// is set at or below the `error` level.
/// - note: This method terminates the program. It returns `Never`.
public func error(_ message: String, path: String? = nil) -> Never {
    log(message, atLevel: .error, path: path)
    exit(1)
}

private func log(_ message: String, atLevel level: LoggingLevel, path: String?) {
    #if DEBUG
        UnitTestLogger.instance.log(message, at: level)
    #endif

    if level.rawValue >= minLoggingOutputLevel.value {
        if let path = path {
            print("\(path):1:1: \(level.text): \(message)")
        } else {
            print("\(level.text): \(level.emoticon) \(message)")
        }
    }
}

// MARK: - Unit Test

/// A logger that accumulates log messages to support unit testing.
public class UnitTestLogger {

    /// The singleton instance.
    public static let instance = UnitTestLogger()

    /// The current set of logged messages.
    public var messages: [String] {
        return lockedMessages.values
    }

    // NARK: - Private

    private let lockedMessages = LockedArray<String>()

    private init() {}

    fileprivate func log(_ message: String, at level: LoggingLevel) {
        lockedMessages.append(message)
    }
}

private class LockedArray<ValueType> {

    private let lock = NSLock()
    private var unsafeValues = [ValueType]()

    fileprivate var values: [ValueType] {
        lock.lock()
        defer {
            lock.unlock()
        }
        return Array(unsafeValues)
    }

    fileprivate func append(_ value: ValueType) {
        lock.lock()
        defer {
            lock.unlock()
        }
        unsafeValues.append(value)
    }
}
