//
// Created by Arnon Keereena on 23/12/2018 AD.
//

import Foundation
import Moya
import GithubDomain

public enum Target: Moya.TargetType {
  case login(request: LoginRequest)
  case profile(username: String)
  case deletePAT(id: String, username: String, password: String)
  case searchRepo(request: SearchRepoRequest, token: String)
  
  public var baseURL: URL {
    return URL(string: "https://api.github.com")!
  }
  
  public var path: String {
    switch self {
    case .login: return "/authorizations"
    case .profile(let username): return "/users/\(username)"
    case .deletePAT(let id, _, _): return "/authorizations/\(id)"
    case .searchRepo: return "/search/repositories"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .login: return .post
    case .profile, .searchRepo: return .get
    case .deletePAT(let id): return .delete
    }
  }
  
  public var sampleData: Data {
    return Data()
  }
  
  public var task: Task {
    switch self {
    case .login(let request): return .requestJSONEncodable(request.body)
    case .profile, .deletePAT: return .requestPlain
    case .searchRepo(let request, _): return .requestParameters(parameters: request.parameters,
                                                                encoding: URLEncoding.default)
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .login(let request):
      return basicAuthorizationHeaders(username: request.username, password: request.password)
    case .deletePAT(_, let username, let password):
      return basicAuthorizationHeaders(username: username, password: password)
    case .profile: return [:]
    case .searchRepo(_, let token):
      return self.tokenAuthorizationHeaders(token: token)
    }
  }
  
  private func basicAuthorizationHeaders(username: String, password: String) -> [String: String] {
    let credentials = "\(username):\(password)"
    let base64 = credentials.data(using: .utf8)?.base64EncodedString() ?? ""
    return ["Authorization": "Basic \(base64)"]
  }
  
  private func tokenAuthorizationHeaders(token: String) -> [String: String] {
    return ["Authorization": "token \(token)"]
  }
}
