/** @noSelf **/
interface Game {
  GetTime(): number;
  GetLatency(): number;
  IsMinimized(): boolean;
  IsChatOpen(): boolean;
  SendChat(msg: string): void;
  IsTFT(): boolean;
  IsRankedGame(): boolean;
  IsCustomGame(): boolean;
  /**
   * @returns Enums_GameMaps
   */
  GetMapID(): keyof Enums_GameMaps;
  GetGameMode(): GameMode;
  GetQueueType(): QueueType;
}
