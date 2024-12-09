import telegrambot, db, utils

let filtersCollection = getCollection("filters")

proc registerFilterCommands(bot: Bot) =
  bot.command("filter", "Add a new filter.") do (ctx: Context) =
    let args = ctx.args.split(" ", 2)
    if args.len < 2:
      await ctx.reply("Usage: /filter <trigger> <reply>")
      return

    let (trigger, reply) = (args[0], args[1])
    filtersCollection.insert({"trigger": trigger, "reply": reply})
    await ctx.reply("Filter added!")

  bot.command("filters", "List all filters.") do (ctx: Context) =
    let filters = filtersCollection.find().toSeq()
    if filters.isEmpty:
      await ctx.reply("No filters are set.")
    else:
      let filterList = filters.mapIt(it["trigger"].getStr()).join(", ")
      await ctx.reply("Filters: " & filterList)

  bot.command("stop", "Remove a filter.") do (ctx: Context) =
    let trigger = ctx.args
    if trigger.isNilOrEmpty:
      await ctx.reply("Usage: /stop <trigger>")
      return

    filtersCollection.delete({"trigger": trigger})
    await ctx.reply("Filter removed!")

  bot.command("stopall", "Remove all filters.") do (ctx: Context) =
    filtersCollection.deleteMany({})
    await ctx.reply("All filters removed!")

  bot.onMessage do (ctx: Context) =
    let message = ctx.message.text
    if message.isNil: return

    let filter = filtersCollection.findOne({"trigger": message})
    if filter.isSome:
      await ctx.reply(filter["reply"].getStr())
