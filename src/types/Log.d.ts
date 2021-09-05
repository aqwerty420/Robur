/* eslint-disable @typescript-eslint/no-explicit-any */

/*
  [Usage]:

  module("modname", package.seeall, log.setup, ...)
  clean.module("modname", clean.seeall, log.setup, ...)
*/

interface log {
  /**
   * helper function to create local logging shortcuts (DEBUG, INFO, ...) passed as Parameter To 'module'.
   */
  setup(this: void, module_id: string): void;
}

declare const log: log;

interface package {
  seeall: any;
}

declare const package: package;

/**
 * helper function to create local logging shortcuts (DEBUG, INFO, ...) passed as Parameter To 'module'.
 */
declare function module(
  this: void,
  module: string,
  seeal: any,
  setup: any,
  ...args: any[]
): void;

interface clean {
  module(
    this: void,
    module: string,
    seeall: any,
    setup: any,
    ...args: any[]
  ): void;
  seeall: any;
}

declare const clean: clean;
