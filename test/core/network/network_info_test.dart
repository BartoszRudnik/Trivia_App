import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/network/network_info.dart';

import '../mock/mock_internet_connection_checker.dart';

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(
      internetConnectionChecker: mockInternetConnectionChecker,
    );
  });

  group("isConnected", () {
    test("should forward the call to InternetConnectionChecker.hasConnection", () async {
      final hasConnectionFuture = Future.value(true);
      when(() => mockInternetConnectionChecker.hasConnection).thenAnswer((_) => hasConnectionFuture);

      final result = networkInfoImpl.isConnected;

      verify(() => mockInternetConnectionChecker.hasConnection);
      expect(result, hasConnectionFuture);
    });
  });
}
