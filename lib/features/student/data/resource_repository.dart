import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'student_mock_data.dart';

// ─── Repository Interface ─────────────────────────────────────────────────────

abstract class ResourceRepository {
  Future<List<StudentResource>> getResources();
  Future<void> toggleSaved(String resourceId);
  Future<void> toggleCompleted(String resourceId);
}

// ─── Mock Implementation ──────────────────────────────────────────────────────

class MockResourceRepository implements ResourceRepository {
  final List<StudentResource> _resources = studentResources.toList();

  @override
  Future<List<StudentResource>> getResources() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_resources);
  }

  @override
  Future<void> toggleSaved(String resourceId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _resources.indexWhere((r) => r.id == resourceId);
    if (index != -1) {
      final resource = _resources[index];
      // Create a copy or just mutate (since we use notifier, we can just mutate and emit a new list)
      resource.isSaved = !resource.isSaved;
    }
  }

  @override
  Future<void> toggleCompleted(String resourceId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _resources.indexWhere((r) => r.id == resourceId);
    if (index != -1) {
      final resource = _resources[index];
      resource.status = resource.status == 'completed' ? 'in_progress' : 'completed';
    }
  }
}

// ─── Riverpod Providers ───────────────────────────────────────────────────────

final resourceRepositoryProvider = Provider<ResourceRepository>((ref) {
  return MockResourceRepository();
});

class ResourceNotifier extends StateNotifier<AsyncValue<List<StudentResource>>> {
  ResourceNotifier(this.repository) : super(const AsyncValue.loading()) {
    _loadResources();
  }

  final ResourceRepository repository;

  Future<void> _loadResources() async {
    try {
      final resources = await repository.getResources();
      state = AsyncValue.data(resources);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleSaved(String id) async {
    if (state is AsyncData) {
      // Optimistic update
      final currentList = state.value!;
      final tempList = currentList.toList();
      final idx = tempList.indexWhere((r) => r.id == id);
      if (idx != -1) {
        tempList[idx].isSaved = !tempList[idx].isSaved;
        state = AsyncValue.data(tempList);
      }
      
      try {
        await repository.toggleSaved(id);
      } catch (e) {
        // Revert on error
        final revertList = state.value!.toList();
        final revIdx = revertList.indexWhere((r) => r.id == id);
        if (revIdx != -1) {
          revertList[revIdx].isSaved = !revertList[revIdx].isSaved;
          state = AsyncValue.data(revertList);
        }
      }
    }
  }

  Future<void> toggleCompleted(String id) async {
    if (state is AsyncData) {
      // Optimistic update
      final currentList = state.value!;
      final tempList = currentList.toList();
      final idx = tempList.indexWhere((r) => r.id == id);
      if (idx != -1) {
        tempList[idx].status = tempList[idx].status == 'completed' ? 'in_progress' : 'completed';
        state = AsyncValue.data(tempList);
      }
      
      try {
        await repository.toggleCompleted(id);
      } catch (e) {
        // Revert on error
        final revertList = state.value!.toList();
        final revIdx = revertList.indexWhere((r) => r.id == id);
        if (revIdx != -1) {
          revertList[revIdx].status = revertList[revIdx].status == 'completed' ? 'in_progress' : 'completed';
          state = AsyncValue.data(revertList);
        }
      }
    }
  }
}

final resourcesProvider = StateNotifierProvider<ResourceNotifier, AsyncValue<List<StudentResource>>>((ref) {
  final repo = ref.watch(resourceRepositoryProvider);
  return ResourceNotifier(repo);
});
