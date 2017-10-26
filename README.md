# libUbercommand.sh
A bash tool similar to Slack's [magic-cli](https://github.com/slackhq/magic-cli) : A foundation for building your own suite of command line tools.

magic-cli-bash exists to make it easy to create a set of tools that work together. It's not a tool you use as-is; it's here to offer a starting point for your own custom command line tools.

**The idea is to unify related tools under a single "ubercommand" in much the same way as `git`, making related tools easily discoverable.**

Building your ubercommand is trivial:

  1. Copy `libUbercommand.sh` and rename it to the ubercommand you want.
  2. Create "subcommands" using the scripting language of your choice in the same directory as your ubercommand named using the pattern "UBERCOMMAND-SUBCOMMAND" (for example, if your ubercommand is `mycmd` and you have a subcommand `dostuff`,  then that subcommand should be named `mycmd-dostuff`
  3. Add usage text to your subcommand.  This is done by adding a line anywhere in your subcommand script that contains the text `# Usage: ` followed by usage text.  If your subcommand is a binary, you should implement a wrapper script to invoke it so that it can provide usage text.
  4. Implement a `--help` option in your subcommand that provides more detailed help than just usage information.

That's it.  Now you can:
  * get a list of your subcommands by just typing the name of your ubercommand (e.g. `mycmd`)
  * get help for any of your subcommands via `help` (e.g. `mycmd help dostuff`)
  * invoke your subcommands (e.g. `mycmd dostuff arg1 arg2 ...`)
