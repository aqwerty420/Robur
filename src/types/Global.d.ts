type Pointer = number;
type Handle_t = number;

interface maths {
  readonly huge: number;
  rad(number: number): number;
  sin(number: number): number;
  cos(number: number): number;
}

interface Global {
  readonly Libs: Libs;
  readonly CoreEx: CoreEx;
  readonly Player: AIHeroClient;
  readonly math: maths;
}

declare const _G: Global;

type OnLoadEvent = () => boolean;

// eslint-disable-next-line @typescript-eslint/no-explicit-any
declare function print(this: void, format: string, ...args: any[]): void;

declare let OnLoad: OnLoadEvent;

declare const Player: AIHeroClient;
