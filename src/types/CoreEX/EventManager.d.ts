/* eslint-disable @typescript-eslint/ban-types, @typescript-eslint/no-explicit-any */

/** @noSelf **/
interface EventManager {
  EventExists(event: string): void;
  RegisterEvent(event: string): void;
  RemoveEvent(event: string): void;
  FireEvent(event: string, var_args: any): void;
  /**
   * See Enums.Events
   */
  RegisterCallback(event: string, func: Function): void;
  /**
   * See Enums.Events
   */
  RemoveCallback(event: string, func: Function): void;
}
