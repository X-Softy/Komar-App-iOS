//
//  HTTPRequestBuilderTests.swift
//  KomaristaTests
//
//  Created by Giorgi Kratsashvili on 8/16/21.
//

import XCTest
@testable import Komarista

class HTTPRequestBuilderTests: XCTestCase {
    private var requestBuilder: HTTPRequestBuilder { HTTPRequestBuilderImpl.createInstance() }
    private let baseURL: String = "www.example.com/base/url"
    private let path: String = "/some/path"
    private var securedBaseURL: String { "https://\(baseURL)" }
    private var notSecuredBaseURL: String { "http://\(baseURL)" }
    private var securedBaseURLWithPath: String { "\(securedBaseURL)\(path)" }
    private var notSecuredBaseURLWithPath: String { "\(notSecuredBaseURL)\(path)" }

    /* Test set(baseURL:) */

    func testBaseURL() {
        // when
        let securedRequest = requestBuilder
            .set(baseURL: securedBaseURL)
            .set(method: HTTPMethodGet())
            .build()

        // than
        XCTAssertEqual(securedRequest.url?.absoluteString, securedBaseURL)

        // when
        let notSecuredRequest = requestBuilder
            .set(baseURL: notSecuredBaseURL)
            .set(method: HTTPMethodPost())
            .build()

        // than
        XCTAssertEqual(notSecuredRequest.url?.absoluteString, notSecuredBaseURL)
    }

    /* Test set(path:) */

    func testPath() {
        // when
        let request = requestBuilder
            .set(baseURL: securedBaseURL)
            .set(path: path)
            .set(method: HTTPMethodPatch())
            .build()

        // than
        XCTAssertEqual(request.url?.absoluteString, securedBaseURLWithPath)
    }

    /* Test setUrlParam(key:, value:) */

    func testSet1UrlParam() {
        // when
        let key   = "Key"
        let value = "Value"

        let request = requestBuilder
            .set(baseURL: notSecuredBaseURL)
            .set(path: path)
            .setUrlParam(key: key, value: value)
            .set(method: HTTPMethodDelete())
            .build()

        // than
        XCTAssertEqual(request.url?.absoluteString, "\(notSecuredBaseURLWithPath)?\(key)=\(value)")
    }

    func testSet2UrlParam() {
        // when
        let key1 = "Key1"
        let val1 = "Value1"

        let key2 = "Key2"
        let val2 = "Value2"

        let request = requestBuilder
            .set(baseURL: securedBaseURL)
            .setUrlParam(key: key1, value: val1)
            .setUrlParam(key: key2, value: val2)
            .set(method: HTTPMethodGet())
            .build()

        // than
        let actual = request.url?.absoluteString

        let expected1 = "\(securedBaseURL)?\(key1)=\(val1)&\(key2)=\(val2)"
        let expected2 = "\(securedBaseURL)?\(key2)=\(val2)&\(key1)=\(val1)"

        XCTAssert(actual == expected1 || actual == expected2)
    }

    /* Test set(urlParams:) */
    
    func testSetUrlParams() {
        // when
        let urlParams = [
            "Key1": "Value1",
            "Key2": "Value2",
            "Key3": "Value3",
        ]

        let request = requestBuilder
            .set(baseURL: notSecuredBaseURL)
            .set(path: path)
            .set(urlParams: urlParams)
            .set(method: HTTPMethodPost())
            .build()

        // than
        let actual = request.url?.absoluteString

        let urlParamsList = urlParams.map { ($0.key, $0.value) }

        for permutaion in permutations(of: urlParamsList) {
            var possibleExpected = "\(notSecuredBaseURLWithPath)?"
            for (key, value) in permutaion {
                possibleExpected.append("\(key)=\(value)&")
            }
            possibleExpected.removeLast() // remove last &
            if possibleExpected == actual {
                XCTAssert(true)
                return
            }
        }

        XCTAssert(false)
    }

    /* Test setHeader(key:, value:) */

    func testHeader() {
        let key = "X-Some-Header-Key"
        let value = "Some-Header-Value"

        // when
        let request = requestBuilder
            .set(baseURL: securedBaseURL)
            .setHeader(key: key, value: value)
            .set(method: HTTPMethodPatch())
            .build()

        // than
        XCTAssertEqual(request.allHTTPHeaderFields?[key], value)
    }

    /* Test set(headers:) */

    func testHeaders() {
        let key1   = "X-Some-Header1-Key"
        let value1 = "Some-Header1-Value"

        let key2   = "X-Some-Header2-Key"
        let value2 = "Some-Header2-Value"

        let headers = [
            key1: value1,
            key2: value2
        ]

        // when
        let request = requestBuilder
            .set(baseURL: notSecuredBaseURL)
            .set(path: path)
            .set(headers: headers)
            .set(method: HTTPMethodDelete())
            .build()

        // than
        XCTAssertEqual(request.allHTTPHeaderFields?[key1], value1)
        XCTAssertEqual(request.allHTTPHeaderFields?[key2], value2)
    }

    /* Test set(method:) */

    /// .get
    func testMethodGet() {
        // when
        let request = requestBuilder
            .set(baseURL: securedBaseURL)
            .set(method: HTTPMethodGet())
            .build()

        // than
        XCTAssertEqual(request.httpMethod, "GET")
    }

    /// .post
    func testMethodPost() {
        // when
        let request = requestBuilder
            .set(baseURL: securedBaseURL)
            .set(path: path)
            .set(method: HTTPMethodPost())
            .build()

        // than
        XCTAssertEqual(request.httpMethod, "POST")
    }

    /// .post
    func testMethodPatch() {
        // when
        let request = requestBuilder
            .set(baseURL: notSecuredBaseURL)
            .set(method: HTTPMethodPatch())
            .build()

        // than
        XCTAssertEqual(request.httpMethod, "PATCH")
    }

    /// .post
    func testMethodDelete() {
        // when
        let request = requestBuilder
            .set(baseURL: notSecuredBaseURL)
            .set(path: path)
            .set(method: HTTPMethodDelete())
            .build()

        // than
        XCTAssertEqual(request.httpMethod, "DELETE")
    }

    /* Test set(contentType:) and set(body:) */

    /// .urlEncoded
    func testContentTypeUrlEncoded() {
        let key1 = "Key1"
        let val1 = "Val1"

        let key2 = "Key2"
        let val2 = "Val2"

        // when
        let request = requestBuilder
            .set(baseURL: securedBaseURL)
            .set(method: HTTPMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .setBody(key: key1, value: val1)
            .set(body: [key2: val2])
            .build()

        // than
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/x-www-form-urlencoded")

        let expected1 = "\(key1)=\(val1)&\(key2)=\(val2)"
        let expected2 = "\(key2)=\(val2)&\(key1)=\(val1)"

        let actual = String(decoding: request.httpBody ?? .init(), as: UTF8.self)

        XCTAssert(actual == expected1 || actual == expected2)
    }

    /// .json
    func testContentTypeJson() {
        struct Mock: Encodable {
            let key1: String
            let key2: [String]
        }

        let jsonObj = Mock(key1: "value1", key2: [])

        // when
        let request = requestBuilder
            .set(baseURL: notSecuredBaseURL)
            .set(path: path)
            .set(method: HTTPMethodPatch())
            .set(contentType: ContentTypeJSON())
            .setBody(json: jsonObj)
            .build()

        // than
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")

        let expected1 = "{\"key1\":\"value1\",\"key2\":[]}"
        let expected2 = "{\"key2\":[],\"key1\":\"value1\"}"

        let actual = String(decoding: request.httpBody ?? .init(), as: UTF8.self)

        XCTAssert(actual == expected1 || actual == expected2)
    }

    /// .raw
    func testContentTypeRaw() {
        let stringData = "Some Raw Data"

        // when
        let request = requestBuilder
            .set(baseURL: securedBaseURL)
            .set(path: path)
            .set(method: HTTPMethodDelete())
            .set(contentType: ContentTypeRaw())
            .setBody(raw: Data(stringData.utf8))
            .build()

        // than
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "text/plain")

        let expected = stringData
        let actual   = String(decoding: request.httpBody ?? .init(), as: UTF8.self)
        XCTAssertEqual(expected, actual)
    }

    // helpers
    private func permutations<T: Any>(of list: [T]) -> [[T]] {
        if list.count < 2 {
            return [list]
        }
        var result: [[T]] = []
        list.enumerated().forEach { i, e in
            var nextList = list
            nextList.swapAt(0, i)
            let firstElem = nextList.remove(at: 0)
            let subResult = permutations(of: nextList)
            result.append(contentsOf: subResult.map {
                var list = $0
                list.insert(firstElem, at: 0)
                return list
            })
        }
        return result
    }
}
