//
//  Decoder.swift
//
//  Copyright (c) 2015-2016 Nike, Inc. (https://www.nike.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

// MARK: Decoder Protocol Definition

/// The `Decoder` protocol declares an interface used to parse an `Any` of one underlying type to an `Any` of another
/// underlying type, which is typically a model object.
public protocol Decoder {
    /// Parses the given object into a value of type `T`.
    ///
    /// - parameter object: The object to parse.
    ///
    /// - throws:  A ParserError.Validation error if object decoding fails.
    /// - returns: The parsed object.
    func decode(_ object: Any) throws -> Any
}

// MARK: - Supplied Decoders

/// Decodes a String to an Int.
public class StringToIntDecoder: Decoder {
    /// Creates a new instance of the `StringToIntDecoder`.
    ///
    /// - returns: The new `StringToIntDecoder` instance.
    public init() {}

    /// Converts the `String` object to an `Int`.
    ///
    /// - parameter object: The `String` to decode.
    ///
    /// - throws:  A ParserError.Validation error if int decoding fails.
    /// - returns: The decoded `Int`.
    public func decode(_ object: Any) throws -> Any {
        if let intString = object as? String, let intValue = Int(intString) {
            return intValue
        }

        throw ParserError.validation(failureReason: "Could not convert String to Int")
    }
}

/// The date decoder converts a `String` into an `Date` object using the provided date format string or `DateFormatter`.
public class DateDecoder: Decoder {
    private let dateFormatter: DateFormatter

    /// Creates a data decoder with the given date format string.
    ///
    /// - parameter dateFormatString: The date format string.
    ///
    /// - returns: The date decoder.
    public init(dateFormatString: String) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = dateFormatString
    }

    /// Creates a date decoder with the given date formatter.
    ///
    /// - parameter dateFormatter: A `DateFormatter` instance.
    ///
    /// - returns: The date decoder.
    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }

    /// Decodes the data parameter into an `Date`.
    ///
    /// - parameter data: The string to parse. MUST be of type `String` or `NSString`.
    ///
    /// - throws: ParserError.Validation
    /// - returns: The parsed date.
    public func decode(_ object: Any) throws -> Any {
        guard let string = object as? String else {
            let description = "DateParser object to parse was not a String."
            throw ParserError.validation(failureReason: description)
        }

        return try date(from: string, using:self.dateFormatter)
    }

    private func date(from string: String, using formatter: DateFormatter) throws -> Any {
        let date = formatter.date(from: string)

        if let date = date {
            return date
        }

        let description = "DateParser string could not be parsed to Date with the given formatter."
        throw ParserError.validation(failureReason: description)
    }
}
