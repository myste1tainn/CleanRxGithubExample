//
// Created by Arnon Keereena on 13/1/2019 AD.
//

import Foundation

public protocol RepoUseCase {
  func myRepo() -> Single<[SearchRepoResponse]>
  
  func search(request: SearchRepoRequest) -> Single<[SearchRepoResponse]>
}