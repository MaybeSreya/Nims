import telegrambot, utils

var lockedItems: seq[string] = @[]

proc registerLockCommands(bot: Bot) =
  bot.command("lock", "Lock specific items.") do (ctx: Context) =
    let items = ctx.args.split(" ")
    for item in items:
      if not lockedItems.contains(item):
        lockedItems.add(item)
    await ctx.reply("Locked items: " & lockedItems.join(", "))

  bot.command("unlock", "Unlock specific items.") do (ctx: Context) =
    let items = ctx.args.split(" ")
    for item in items:
      lockedItems.remove(item)
    await ctx.reply("Unlocked items: " & lockedItems.join(", "))

  bot.command("locks", "List locked items.") do (ctx: Context) =
    if lockedItems.isEmpty:
      await ctx.reply("No items are locked.")
    else:
      await ctx.reply("Locked items: " & lockedItems.join(", "))
