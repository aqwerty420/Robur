interface AIMinionClient extends AIBaseClient {
  readonly IsPet: boolean;
  readonly IsLaneMinion: boolean;
  readonly IsEpicMinion: boolean;
  readonly IsEliteMinion: boolean;
  readonly IsScuttler: boolean;
  readonly IsSiegeMinion: boolean;
  readonly IsSuperMinion: boolean;
  readonly IsJunglePlant: boolean;
  readonly IsBarrel: boolean;
  readonly IsSennaSoul: boolean;
  readonly BonusDamageToMinions: number;
  readonly ReducedDamageFromMinions: number;
}
