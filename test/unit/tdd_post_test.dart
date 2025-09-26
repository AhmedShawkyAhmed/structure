import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_service/network_service.dart';
import 'package:structure/TDD/posts/cubit/posts_cubit.dart';
import 'package:structure/TDD/posts/cubit/posts_state.dart';
import 'package:structure/TDD/posts/data/models/post_model.dart';
import 'package:structure/TDD/posts/data/repo/interface/i_post_repo.dart';

class MockPostRepo extends Mock implements IPostRepo {}

final List<PostModel> posts = [
  PostModel(id: 1, title: 'Test Post 1', body: 'Body 1'),
  PostModel(id: 2, title: 'Test Post 2', body: 'Body 2'),
];

final newPost = PostModel(id: 3, title: ' Test Post 3', body: 'Body 3');

void main() {
  final serviceLocator = GetIt.instance;
  late MockPostRepo mockPostRepo;

  setUp(() {
    mockPostRepo = MockPostRepo();

    serviceLocator.reset();

    serviceLocator.registerFactory<IPostRepo>(() => mockPostRepo);
    serviceLocator.registerFactory(() => PostsCubit(serviceLocator<IPostRepo>()));
  });


  group('Post Repo Group Test', () {
    test('get posts test', () async {
      // arrange
      when(() => mockPostRepo.getPosts()).thenAnswer(
        (_) async => NetworkResult.success(NetworkBaseModel(data: posts)),
      );

      // act
      final result = await mockPostRepo.getPosts();

      // assert
      expect(result, isA<NetworkResult<NetworkBaseModel<List<PostModel>>>>());
      result.when(
        success: (data) {
          expect(data.data?.length, 2);
          expect(data.data?.first.title, 'Test Post 1');
        },
        failure: (_) {
          fail('Expected success but got failure');
        },
      );
    });

    test('add posts test', () async {
      // arrange
      when(() => mockPostRepo.addPost(post: newPost)).thenAnswer(
        (_) async => NetworkResult.success(NetworkBaseModel(data: newPost)),
      );

      // act
      final result = await mockPostRepo.addPost(post: newPost);

      // assert
      expect(result, isA<NetworkResult<NetworkBaseModel<PostModel>>>());
      result.when(
        success: (data) {
          expect(data.data?.id, 3);
          expect(data.data?.title, ' Test Post 3');
        },
        failure: (_) {
          fail('Expected success but got failure');
        },
      );
    });
  });

  group('Posts Cubit Group Test', () {
    blocTest<PostsCubit, PostsState>(
      'emits [loading, success] when getPosts succeeds',
      build: () {
        when(() => mockPostRepo.getPosts()).thenAnswer(
          (_) async => NetworkResult.success(
            NetworkBaseModel(data: posts, isSuccess: true),
          ),
        );
        return PostsCubit(mockPostRepo);
      },
      act: (cubit) => cubit.getPosts(),
      expect: () => [const PostsState.loading(), PostsState.success(posts)],
      verify: (_) {
        verify(() => mockPostRepo.getPosts()).called(1);
      },
    );

    blocTest<PostsCubit, PostsState>(
      'emits [loading, error] when getPosts fails',
      build: () {
        when(() => mockPostRepo.getPosts()).thenAnswer(
          (_) async => const NetworkResult.failure(
            NetworkExceptions.defaultError(
              NetworkErrorDetails(message: 'Server error'),
            ),
          ),
        );
        return PostsCubit(mockPostRepo);
      },
      act: (cubit) => cubit.getPosts(),
      expect: () => [
        const PostsState.loading(),
        const PostsState.error(
          NetworkExceptions.defaultError(
            NetworkErrorDetails(message: 'Server error'),
          ),
        ),
      ],
    );

    blocTest<PostsCubit, PostsState>(
      'emits [loading, success] when addPost succeeds',
      build: () {
        when(() => mockPostRepo.addPost(post: newPost)).thenAnswer(
          (_) async => NetworkResult.success(
            NetworkBaseModel(data: newPost, isSuccess: true),
          ),
        );
        return PostsCubit(mockPostRepo);
      },
      act: (cubit) => cubit.addPost(post: newPost),
      expect: () => [const PostsState.loading(), PostsState.success(newPost)],
      verify: (_) {
        verify(() => mockPostRepo.addPost(post: newPost)).called(1);
      },
    );

    blocTest<PostsCubit, PostsState>(
      'emits [loading, error] when addPost fails',
      build: () {
        when(() => mockPostRepo.addPost(post: newPost)).thenAnswer(
          (_) async => const NetworkResult.failure(
            NetworkExceptions.defaultError(
              NetworkErrorDetails(message: 'Failed to add post'),
            ),
          ),
        );
        return PostsCubit(mockPostRepo);
      },
      act: (cubit) => cubit.addPost(post: newPost),
      expect: () => [
        const PostsState.loading(),
        const PostsState.error(
          NetworkExceptions.defaultError(
            NetworkErrorDetails(message: 'Failed to add post'),
          ),
        ),
      ],
    );
  });
}
