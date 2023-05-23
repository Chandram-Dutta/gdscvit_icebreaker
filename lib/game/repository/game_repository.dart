abstract class GameRepository {
  Future<void> changeNextChoosable({
    required String roomId,
  });

  Future<void> changePrompt({
    required String roomId,
    required String prompt,
  });

  Future<void> changeJoinable({
    required String roomId,
    required String roomState,
  });
}
