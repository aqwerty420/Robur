interface Item {
  readonly Name: string;
  readonly ItemId: number;
  readonly CurrentStacks: number;
  readonly MaxStacks: number;
  readonly Count: number;
  readonly MaxCount: number;
  readonly Duration: number;
  readonly RechargeTime: number;
  readonly MaxCharges: number;
  readonly HasActiveAbility: boolean;
}
