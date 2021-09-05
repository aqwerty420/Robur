/** @noSelf **/
interface Profiler {
  Start(): void;
  Stop(): void;
  Reset(): void;
  /**
   * @returns Creates a file named PerformanceReport.log on your robur folder
   */
  Report(filename: string): void;
}
