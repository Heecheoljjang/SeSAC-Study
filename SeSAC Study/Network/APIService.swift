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
    
    func request<T: Decodable>(type: T.Type = T.self, method: HTTPMethod, url: URL, parameters: [String: Any]?, headers: HTTPHeaders, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, method: method, parameters: parameters, headers: headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                print("data: \(data)")
                completion(.success(data))
                
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                guard let error = NetworkError(rawValue: statusCode) else { return }
                print("error: \(error)")
                print("statusCode: \(statusCode)")
                completion(.failure(error))
            }
        }
    }
}
