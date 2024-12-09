import strutils

proc parseArgs(args: string): seq[string] =
  result = args.split(" ")
