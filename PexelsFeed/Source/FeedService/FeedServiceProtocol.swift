protocol FeedServiceProtocol {
    func fetch() async throws -> FeedServiceResponse
    func fetchNext(using urlString: String) async throws -> FeedServiceResponse
}
