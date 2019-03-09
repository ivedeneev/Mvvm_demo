//
//  NetworkRequestParams.swift
//  Pyaterochka
//
//  Created by Igor Vedeneev on 08.07.2018.
//  Copyright © 2018 Zeno Inc. All rights reserved.
//

import Alamofire

protocol NetworkRequestParams {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var encoding: ParameterEncoding { get }
    var headers: [String: String]? { get }
    var defaultHeaders: [String: String]? { get }
}

extension NetworkRequestParams {
    var encoding: ParameterEncoding {
        return URLEncoding.methodDependent
    }
    
    var headers: [String: String]? {
        return defaultHeaders
    }
    
    var parameters: Parameters {
        return [:]
    }
    
    var defaultHeaders: [String: String]? {
        let secureSettings = APSecureSettings()
        let settings = Settings()
        
        let canReceivePush = secureSettings.pushToken != nil ? "true" : "false"
        var headers =  ["Content-Type"         : "application/json",
                        "Accept"               : "application/json",
                        "X-PLATFORM"           : "ios",
                        "X-CAN-RECEIVE-PUSH"   : canReceivePush,
                        "X-APP-VERSION"        : Bundle.appVersionString]
        
        if let deviceId: String = settings[.deviceId] {
            headers["X-DEVICE-ID"] = deviceId
        }
        
        if let authToken = secureSettings.authToken {
            headers["X-Authorization"] = authToken
        }
        
        if let pushToken = secureSettings.pushToken {
            headers["X-PUSH-TOKEN"] = pushToken
        }
        
        if AppSettings.isTestServer() {
            let login = "5ka"
            let password = "pyatka"
            let credentials = "\(login):\(password)".data(using: .utf8)!.base64EncodedString()
            headers["Authorization"] = "Basic \(credentials)"
        }
        
        return headers
    }
    
    func basicAuthHeader(httpMethod: HTTPMethod) -> String {
//        let clientId = Constants.Network.clientId
//        let clientSecret = Constants.Network.clientSecret
//        let timestamp = String(format: "$.0f", Date().timeIntervalSince1970.rounded())
//        let stringToSign = "\(httpMethod.rawValue);\(clientId);\(timestamp);"
//        let signingKey = ""
//        let signature = ""
        //todo:
//        NSString *signingKey = [NetworkManager hmacSHA256:clientSecret key:timestamp];
//        NSString *signature = [NetworkManager hmacSHA256:stringToSign key:signingKey];
//        return "\(clientId),\(timestamp),\(signature)"
        return ""
    }
}

extension URLRequestConvertible where Self:NetworkRequestParams  {
    func asURLRequest() throws -> URLRequest {
        let baseUrl = URL(string: AppSettings.baseUrlWithoutVersionSuffix())!
        let url = baseUrl.appendingPathComponent(self.path)
        var request = try! URLRequest(url: url, method: self.method, headers: self.headers)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 30
        
        
        return try self.encoding.encode(request, with: self.parameters)
    }
}
