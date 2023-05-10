// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:graphql/client.dart';
//
// class GraphQLImplementation implements IGraphQLClient {
//   final _headers = <String, String>{};
//   GraphQLClient _client;
//   GraphQLClient _websocketClient;
//
//   GraphQLImplementation(String url, String token, {String urlWebSocket}) {
//     // final token = await SharedPreferences.instance.accessToken as String;
//     if (token.isNotNullOrEmpty) {
//       _headers['Authorization'] = 'Bearer ' + token;
//     }
//     //
//     final _websocketLink = WebSocketLink(
//       urlWebSocket,
//       config: SocketClientConfig(
//         autoReconnect: true,
//         inactivityTimeout: Duration(seconds: 30),
//         initialPayload: () async => _headers,
//       ),
//     );
//     //
//     final _link = HttpLink(
//       url,
//       defaultHeaders: _headers,
//     );
//     //
//     _client = GraphQLClient(
//       cache: GraphQLCache(),
//       link: _link,
//     );
//     //
//     _websocketClient = GraphQLClient(
//       cache: GraphQLCache(),
//       link: _websocketLink,
//     );
//   }
//
//   @override
//   void setNewToken(String newToken) {
//     _headers['Authorization'] = 'Bearer ' + newToken;
//   }
//
//   @override
//   Future<DataResponse<T>> query<T extends BaseResponse>(
//       String doc,
//       String tag, {
//         Map<String, dynamic> vars = const {},
//       }) async {
//     final options = WatchQueryOptions(
//       document: gql(doc),
//       variables: vars,
//       operationName: tag,
//       fetchPolicy: FetchPolicy.noCache,
//       cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
//     );
//     DataResponse<T> result;
//     try {
//       Log.d('-----------------QUERY GRAPHQL API REQUEST------------------');
//       Log.d('DOCUMENTS:\n$doc');
//       Log.d('VARIABLES:\n$vars');
//
//       final response = await _client.query(options);
//
//       Log.d('-----------------QUERY GRAPHQL API RESPONSE------------------');
//       Log.d('DATA:\n${response.toString()}');
//
//       //
//       if (response.hasException || response.exception != null) {
//         final errors = response.exception?.graphqlErrors?.map((e) => e.message);
//         result = DataResponse<T>();
//         result.message = errors?.first;
//         result.statusCode = NetworkStatusCode.badRequest;
//         return result;
//       }
//
//       //
//       result = DataResponse<T>.fromGraphQLReq(response, tag);
//       result.statusCode = NetworkStatusCode.success;
//     } catch (e) {
//       Log.d('ERROR:\n${e.toString()}');
//       if (e is OperationException) {
//         final errors = e.graphqlErrors?.map((e) => e.message)?.toList();
//         result.message = errors?.first;
//         result.statusCode = NetworkStatusCode.badRequest;
//       }
//     }
//     return result;
//   }
//
//   @override
//   Future<DataResponse<T>> mutation<T extends BaseResponse>(
//       String doc,
//       String tag, {
//         Map<String, dynamic> vars = const {},
//       }) async {
//     final options = MutationOptions(
//       operationName: tag,
//       document: gql(doc),
//       variables: vars,
//       cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
//     );
//     DataResponse<T> result;
//     try {
//       Log.d('-----------------MUTATION GRAPHQL API REQUEST------------------');
//       Log.d('DOCUMENTS:\n$doc');
//       Log.d('VARIABLES:\n$vars');
//
//       final response = await _client.mutate(options);
//
//       Log.d('-----------------MUTATION GRAPHQL API RESPONSE------------------');
//       Log.d('DATA:\n${response.toString()}');
//
//       //
//       if (response.hasException || response.exception != null) {
//         final errors = response.exception?.graphqlErrors?.map((e) => e.message);
//         result = DataResponse<T>();
//         result.message = errors?.first;
//         result.statusCode = NetworkStatusCode.badRequest;
//         return result;
//       }
//       //
//
//       result = DataResponse<T>.fromGraphQLReq(response, tag);
//       result.statusCode = NetworkStatusCode.success;
//     } catch (e) {
//       Log.d('ERROR:\n${e.toString()}');
//       if (e is OperationException) {
//         final errors = e.graphqlErrors?.map((e) => e.message)?.toList();
//         result.message = errors?.first;
//         result.statusCode = NetworkStatusCode.badRequest;
//       } else {
//         result.message = e.toString();
//         result.statusCode = NetworkStatusCode.unknown;
//       }
//     }
//     return result;
//   }
//
//   @override
//   Future<void> subscription<T extends BaseResponse>(
//       String doc,
//       String tag,
//       {Map<String, dynamic> vars = const {}, ValueChanged<DataResponse<T>> onData, Function(dynamic) onError,
//         VoidCallback onDone,}) async {
//     DataResponse<T> result;
//     try {
//
//       Log.d(
//           '-----------------SUBSCRIBE GRAPHQL API REQUEST------------------');
//       Log.d('DOCUMENTS:\n$doc');
//       Log.d('VARIABLES:\n$vars');
//
//       final options = SubscriptionOptions(
//         operationName: tag,
//         document: gql(doc),
//         variables: vars,
//         cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
//       );
//
//       _websocketClient.subscribe(options).listen((response) {
//         Log.d(
//             '-----------------SUBSCRIBE GRAPHQL API RESPONSE------------------');
//         Log.d('DATA:\n${response.toString()}');
//
//         //
//         if (response.hasException || response.exception != null) {
//           print('response.exception: ${response.exception}');
//           // response.exception?.linkException?.originalException
//           final errors = response.exception?.graphqlErrors?.map((e) =>
//           e.message);
//           result = DataResponse<T>();
//           result.message = errors?.first;
//           result.statusCode = NetworkStatusCode.badRequest;
//           onError(result);
//           return;
//         }
//         //
//
//         result = DataResponse<T>.fromGraphQLReq(response, tag);
//         result.statusCode = NetworkStatusCode.success;
//         onData(result);
//       });
//     } catch (e) {
//       Log.d('ERROR:\n${e.toString()}');
//       if (e is OperationException) {
//         final errors = e.graphqlErrors?.map((e) => e.message)?.toList();
//         result.message = errors?.first;
//         result.statusCode = NetworkStatusCode.badRequest;
//         onError(result);
//       } else {
//         result.message = e.toString();
//         result.statusCode = NetworkStatusCode.unknown;
//         onError(result);
//       }
//     }
//   }
//
//   @override
//   FutureOr<void> subscriptionWebSocket<T extends BaseResponse>(
//       String doc,
//       String tag,
//       {Map<String, dynamic> vars = const {},
//         ValueChanged<DataResponse<T>> onData,
//         Function(dynamic p1) onError,
//         VoidCallback onDone}) {
//     DataResponse<T> result;
//     try {
//
//       Log.d(
//           '-----------------SUBSCRIBE GRAPHQL API REQUEST------------------');
//       Log.d('DOCUMENTS:\n$doc');
//       Log.d('VARIABLES:\n$vars');
//
//
//
//       final options = SubscriptionOptions(
//         operationName: tag,
//         document: gql(doc),
//         variables: vars,
//         cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
//       );
//
//       _client.subscribe(options).listen((response) {
//         Log.d(
//             '-----------------SUBSCRIBE GRAPHQL API RESPONSE------------------');
//         Log.d('DATA:\n${response.toString()}');
//
//         //
//         if (response.hasException || response.exception != null) {
//           print('response.exception: ${response.exception}');
//           // response.exception?.linkException?.originalException
//           final errors = response.exception?.graphqlErrors?.map((e) =>
//           e.message);
//           result = DataResponse<T>();
//           result.message = errors?.first;
//           result.statusCode = NetworkStatusCode.badRequest;
//           onError(result);
//           return;
//         }
//         //
//
//         result = DataResponse<T>.fromGraphQLReq(response, tag);
//         result.statusCode = NetworkStatusCode.success;
//         onData(result);
//       });
//     } catch (e) {
//       Log.d('ERROR:\n${e.toString()}');
//       if (e is OperationException) {
//         final errors = e.graphqlErrors?.map((e) => e.message)?.toList();
//         result.message = errors?.first;
//         result.statusCode = NetworkStatusCode.badRequest;
//         onError(result);
//       } else {
//         result.message = e.toString();
//         result.statusCode = NetworkStatusCode.unknown;
//         onError(result);
//       }
//     }
//   }
// }
