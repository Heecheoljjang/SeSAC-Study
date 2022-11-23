//
//  APIService.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation
import Alamofire

final class APIService {
    private init() {}
    
    static let shared = APIService()
    
    func request<T: Decodable>(type: T.Type = T.self, method: HTTPMethod, url: URL, parameters: [String: Any]?, headers: HTTPHeaders, completion: @escaping (T?, Int) -> Void) {
        AF.request(url, method: method, parameters: parameters, headers: headers).responseDecodable(of: T.self) { response in
            guard let statusCode = response.response?.statusCode else { return }
            var result: T?
            switch response.result {
            case .success(let data):
                result = data
            case .failure(_):
                result = nil
            }
            completion(result, statusCode)
        }
    }
    
    func noResponseRequest(method: HTTPMethod, url: URL, parameters: [String: Any]?, headers: HTTPHeaders, completion: @escaping (Int) -> Void) {
        AF.request(url, method: method, parameters: parameters, encoding: URLEncoding(arrayEncoding: .noBrackets),headers: headers).responseString { response in
            guard let statusCode = response.response?.statusCode else { return }
            completion(statusCode)
        }
    }
}

