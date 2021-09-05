/* eslint-disable @typescript-eslint/ban-types, @typescript-eslint/no-explicit-any */

/** @noSelf **/
interface EventManager {
  EventExists(event: string): void;
  RegisterEvent(event: string): void;
  RemoveEvent(event: string): void;
  FireEvent(event: string, var_args: any): void;
  /**
   * @see Enums.Events
   */
  RegisterCallback(event: string, func: Function): void;
  /**
   * @see Enums.Events
   */
  RemoveCallback(event: string, func: Function): void;
}
