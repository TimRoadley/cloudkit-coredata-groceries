//
//  Loggoing.swift
//  Groceries
//
//  Created by Tim Roadley on 21/10/2025.
//

import OSLog

// MARK: - Logger Extension

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.unknown"

    init(fileID: String = #fileID) {
        let category = (fileID as NSString).lastPathComponent
        self.init(subsystem: Logger.subsystem, category: category)
    }

    private func logf(
        level: OSLogType,
        _ message: String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let origin = "\(file):\(function):\(line)"
        log(level: level, "\(origin) — \(message, privacy: .public)")
    }

    func debug(_ message: String,
               file: String = #fileID,
               function: String = #function,
               line: Int = #line) {
        logf(level: .debug, message, file: file, function: function, line: line)
    }

    func info(_ message: String,
              file: String = #fileID,
              function: String = #function,
              line: Int = #line) {
        logf(level: .info, message, file: file, function: function, line: line)
    }

    func error(_ message: String,
               file: String = #fileID,
               function: String = #function,
               line: Int = #line) {
        logf(level: .error, message, file: file, function: function, line: line)
    }

    func fault(_ message: String,
               file: String = #fileID,
               function: String = #function,
               line: Int = #line) {
        logf(level: .fault, message, file: file, function: function, line: line)
    }
}

// MARK: - Global Logger

/// Global computed logger that automatically tags logs with the caller’s file.
var log: Logger {
    Logger(fileID: #fileID)
}
