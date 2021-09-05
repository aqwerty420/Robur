interface BuffInst {
  readonly IsValid: boolean;
  readonly Name: string;
  readonly Source: AIBaseClient;
  // Enum_BuffTypes
  readonly BuffType: number;
  readonly Count: number;
  readonly StartTime: number;
  readonly EndTime: number;
  readonly Duration: number;
  readonly DurationLeft: number;
  readonly IsCC: boolean;
  readonly IsNotDebuff: boolean;
  readonly IsFear: boolean;
  readonly IsRoot: boolean;
  readonly IsSilence: boolean;
  readonly IsDisarm: boolean;
}
