/* eslint-disable @typescript-eslint/ban-types, @typescript-eslint/no-explicit-any */

/** @noSelf **/
interface Menu {
  Set(id: string, value: any, nothrow: boolean): any;
  Get(id: string, nothrow?: boolean): any;
  GetKey(id: string, nothrow: boolean): any;
  Indent(func: Function): void;
  SameLine(offset?: number | null, spacing?: number | null): void;
  Separator(): void;
  Text(displayText: string, centered?: boolean): void;
  ColoredText(displayText: string, color: number, centered?: boolean): void;
  SmallButton(id: string, displayText: string, func: Function): void;
  Button(id: string, displayText: string, func: Function, size?: Vector): void;
  Checkbox(id: string, displayText: string, defaultOn: boolean): boolean;
  ColorPicker(id: string, displayText: string, defaultColor: number): number;
  Dropdown(
    id: string,
    displayText: string,
    defaultChoice: number,
    list: LuaTable
  ): number;
  Keybind(
    id: string,
    displayText: string,
    defaultKey: number,
    toggle?: boolean | null,
    defaultVal?: boolean | null,
    dontUseColumns?: boolean | null
  ): boolean;
  Slider(
    id: string,
    displayText: string,
    defaultValue: number,
    minValue: number,
    maxValue: number,
    step: number
  ): number;
  NewTree(id: string, displayText: string, func: Function): void;
  ColumnLayout(
    id: string,
    displayText: string,
    columns: number,
    borders: boolean,
    func: Function
  ): void;
  NextColumn(): void;
  RegisterPermashow(
    id: string,
    displayText: string,
    func: Function,
    isVisible?: Function
  ): void;
  RegisterMenu(id: string, displayText: string, func: Function): void;
  IsKeyPressed(vKey: number): boolean;
}
