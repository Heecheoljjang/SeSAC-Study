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
    
    func request<T: Decodable>(type: T.Type = T.self, method: HTTPMethod, url: URL, parameters: [String: Any]?, headers: HTTPHeaders, errorType: NetworkError, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, method: method, parameters: parameters, headers: headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                print("data: \(data)")
                completion(.success(data))
                
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                print("상태코드: \(statusCode)")
                switch errorType {
                case .LoginError:
                    guard let error = LoginError(rawValue: statusCode) else { return }
                    print("로그인에러: \(error)")
                    completion(.failure(error))
                case .SesacRequestError:
                    guard let error = SesacRequestError(rawValue: statusCode) else { return }
                    print("로그인에러: \(error)")
                    completion(.failure(error))
                case .SesacCancelError:
                    guard let error = SesacCancelError(rawValue: statusCode) else { return }
                    print("로그인에러: \(error)")
                    completion(.failure(error))
                case .SesacSearchError:
                    guard let error = SesacSearchError(rawValue: statusCode) else { return }
                    completion(.failure(error))
                case .QueueStateError:
                    guard let error = QueueStateError(rawValue: statusCode) else { return }
                    completion(.failure(error))
                }
            }
        }
    }
}

